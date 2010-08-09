From: akpm@linux-foundation.org
Subject: + vmscan-raise-the-bar-to-pageout_io_sync-stalls.patch added to -mm tree
Date: Mon, 09 Aug 2010 12:58:16 -0700
Message-ID: <201008091958.o79JwHmo015468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713Ab0HIT7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Aug 2010 15:59:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@lisas.de, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
has been added to the -mm tree.  Its filename is
     vmscan-raise-the-bar-to-pageout_io_sync-stalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
From: Wu Fengguang <fengguang.wu@intel.com>

Fix "system goes unresponsive under memory pressure and lots of
dirty/writeback pages" bug.

	http://lkml.org/lkml/2010/4/4/86

In the above thread, Andreas Mohr described that

	Invoking any command locked up for minutes (note that I'm
	talking about attempted additional I/O to the _other_,
	_unaffected_ main system HDD - such as loading some shell
	binaries -, NOT the external SSD18M!!).

This happens when the two conditions are both meet:
- under memory pressure
- writing heavily to a slow device

OOM also happens in Andreas' system.  The OOM trace shows that 3 processes
are stuck in wait_on_page_writeback() in the direct reclaim path.  One in
do_fork() and the other two in unix_stream_sendmsg().  They are blocked on
this condition:

	(sc->order && priority < DEF_PRIORITY - 2)

which was introduced in commit 78dc583d (vmscan: low order lumpy reclaim
also should use PAGEOUT_IO_SYNC) one year ago.  That condition may be too
permissive.  In Andreas' case, 512MB/1024 = 512KB.  If the direct reclaim
for the order-1 fork() allocation runs into a range of 512KB
hard-to-reclaim LRU pages, it will be stalled.

It's a severe problem in three ways.

Firstly, it can easily happen in daily desktop usage.  vmscan priority can
easily go below (DEF_PRIORITY - 2) on _local_ memory pressure.  Even if
the system has 50% globally reclaimable pages, it still has good
opportunity to have 0.1% sized hard-to-reclaim ranges.  For example, a
simple dd can easily create a big range (up to 20%) of dirty pages in the
LRU lists.  And order-1 to order-3 allocations are more than common with
SLUB.  Try "grep -v '1 :' /proc/slabinfo" to get the list of high order
slab caches.  For example, the order-1 radix_tree_node slab cache may
stall applications at swap-in time; the order-3 inode cache on most
filesystems may stall applications when trying to read some file; the
order-2 proc_inode_cache may stall applications when trying to open a
/proc file.

Secondly, once triggered, it will stall unrelated processes (not doing IO
at all) in the system.  This "one slow USB device stalls the whole system"
avalanching effect is very bad.

Thirdly, once stalled, the stall time could be intolerable long for the
users.  When there are 20MB queued writeback pages and USB 1.1 is writing
them in 1MB/s, wait_on_page_writeback() will stuck for up to 20 seconds. 
Not to mention it may be called multiple times.

So raise the bar to only enable PAGEOUT_IO_SYNC when priority goes below
DEF_PRIORITY/3, or 6.25% LRU size.  As the default dirty throttle ratio is
20%, it will hardly be triggered by pure dirty pages.  We'd better treat
PAGEOUT_IO_SYNC as some last resort workaround -- its stall time is so
uncomfortably long (easily goes beyond 1s).

The bar is only raised for (order < PAGE_ALLOC_COSTLY_ORDER) allocations,
which are easy to satisfy in 1TB memory boxes.  So, although 6.25% of
memory could be an awful lot of pages to scan on a system with 1TB of
memory, it won't really have to busy scan that much.

Andreas tested an older version of this patch and reported that it mostly
fixed his problem.  Mel Gorman helped improve it and KOSAKI Motohiro will
fix it further in the next patch.

Reported-by: Andreas Mohr <andi@lisas.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   51 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~vmscan-raise-the-bar-to-pageout_io_sync-stalls mm/vmscan.c
--- a/mm/vmscan.c~vmscan-raise-the-bar-to-pageout_io_sync-stalls
+++ a/mm/vmscan.c
@@ -1234,6 +1234,47 @@ static noinline_for_stack void update_is
 }
 
 /*
+ * Returns true if the caller should wait to clean dirty/writeback pages.
+ *
+ * If we are direct reclaiming for contiguous pages and we do not reclaim
+ * everything in the list, try again and wait for writeback IO to complete.
+ * This will stall high-order allocations noticeably. Only do that when really
+ * need to free the pages under high memory pressure.
+ */
+static inline bool should_reclaim_stall(unsigned long nr_taken,
+					unsigned long nr_freed,
+					int priority,
+					struct scan_control *sc)
+{
+	int lumpy_stall_priority;
+
+	/* kswapd should not stall on sync IO */
+	if (current_is_kswapd())
+		return false;
+
+	/* Only stall on lumpy reclaim */
+	if (!sc->lumpy_reclaim_mode)
+		return false;
+
+	/* If we have relaimed everything on the isolated list, no stall */
+	if (nr_freed == nr_taken)
+		return false;
+
+	/*
+	 * For high-order allocations, there are two stall thresholds.
+	 * High-cost allocations stall immediately where as lower
+	 * order allocations such as stacks require the scanning
+	 * priority to be much higher before stalling.
+	 */
+	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+		lumpy_stall_priority = DEF_PRIORITY;
+	else
+		lumpy_stall_priority = DEF_PRIORITY / 3;
+
+	return priority <= lumpy_stall_priority;
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
@@ -1298,14 +1339,8 @@ shrink_inactive_list(unsigned long nr_to
 
 	nr_reclaimed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
 
-	/*
-	 * If we are direct reclaiming for contiguous pages and we do
-	 * not reclaim everything in the list, try again and wait
-	 * for IO to complete. This will stall high-order allocations
-	 * but that should be acceptable to the caller
-	 */
-	if (nr_reclaimed < nr_taken && !current_is_kswapd() &&
-			sc->lumpy_reclaim_mode) {
+	/* Check if we should syncronously wait for writeback */
+	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
fs-inodec-work-around-bug.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update.patch
writeback-add-comment-to-the-dirty-limit-functions.patch
writeback-add-comment-to-the-dirty-limit-functions-update.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-fix-queue_io-ordering-update.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
writeback-merge-for_kupdate-and-for_kupdate-cases-update.patch
vmscan-raise-the-bar-to-pageout_io_sync-stalls.patch
mm-fix-writeback_in_progress.patch
mm-avoid-resetting-wb_start-after-each-writeback-round.patch
vfs-add-super-operation-writeback_inodes.patch

