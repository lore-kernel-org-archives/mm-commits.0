From: akpm@linux-foundation.org
Subject: + mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch added to -mm tree
Date: Thu, 18 Aug 2011 16:54:49 -0700
Message-ID: <201108182354.p7INsn60002686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249Ab1HRXzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 19:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, riel@redhat.com, tytso@mit.edu


The patch titled
     mm: vmscan: throttle reclaim if encountering too many dirty pages under writeback
has been added to the -mm tree.  Its filename is
     mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch

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
Subject: mm: vmscan: throttle reclaim if encountering too many dirty pages under writeback
From: Mel Gorman <mgorman@suse.de>

Workloads that are allocating frequently and writing files place a large
number of dirty pages on the LRU.  With use-once logic, it is possible for
them to reach the end of the LRU quickly requiring the reclaimer to scan
more to find clean pages.  Ordinarily, processes that are dirtying memory
will get throttled by dirty balancing but this is a global heuristic and
does not take into account that LRUs are maintained on a per-zone basis. 
This can lead to a situation whereby reclaim is scanning heavily, skipping
over a large number of pages under writeback and recycling them around the
LRU consuming CPU.

This patch checks how many of the number of pages isolated from the LRU
were dirty and under writeback.  If a percentage of them under writeback,
the process will be throttled if a backing device or the zone is
congested.  Note that this applies whether it is anonymous or file-backed
pages that are under writeback meaning that swapping is potentially
throttled.  This is intentional due to the fact if the swap device is
congested, scanning more pages and dispatching more IO is not going to
help matters.

The percentage that must be in writeback depends on the priority.  At
default priority, all of them must be dirty.  At DEF_PRIORITY-1, 50% of
them must be, DEF_PRIORITY-2, 25% etc.  i.e.  as pressure increases the
greater the likelihood the process will get throttled to allow the flusher
threads to make some progress.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <>
---

 mm/vmscan.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback
+++ a/mm/vmscan.c
@@ -752,7 +752,9 @@ static noinline_for_stack void free_page
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
 				      struct scan_control *sc,
-				      int priority)
+				      int priority,
+				      unsigned long *ret_nr_dirty,
+				      unsigned long *ret_nr_writeback)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
@@ -760,6 +762,7 @@ static unsigned long shrink_page_list(st
 	unsigned long nr_dirty = 0;
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
+	unsigned long nr_writeback = 0;
 
 	cond_resched();
 
@@ -796,6 +799,7 @@ static unsigned long shrink_page_list(st
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
+			nr_writeback++;
 			/*
 			 * Synchronous reclaim cannot queue pages for
 			 * writeback due to the possibility of stack overflow
@@ -1001,6 +1005,8 @@ keep_lumpy:
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
+	*ret_nr_dirty += nr_dirty;
+	*ret_nr_writeback += nr_writeback;
 	return nr_reclaimed;
 }
 
@@ -1467,6 +1473,8 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_taken;
 	unsigned long nr_anon;
 	unsigned long nr_file;
+	unsigned long nr_dirty = 0;
+	unsigned long nr_writeback = 0;
 	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
@@ -1519,12 +1527,14 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc, priority);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, priority,
+						&nr_dirty, &nr_writeback);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_reclaim_mode(priority, sc, true);
-		nr_reclaimed += shrink_page_list(&page_list, zone, sc, priority);
+		nr_reclaimed += shrink_page_list(&page_list, zone, sc,
+					priority, &nr_dirty, &nr_writeback);
 	}
 
 	if (!scanning_global_lru(sc))
@@ -1537,6 +1547,16 @@ shrink_inactive_list(unsigned long nr_to
 
 	putback_lru_pages(zone, sc, nr_anon, nr_file, &page_list);
 
+	/*
+	 * If we have encountered a high number of dirty pages under writeback
+	 * then we are reaching the end of the LRU too quickly and global
+	 * limits are not enough to throttle processes due to the page
+	 * distribution throughout zones. Scale the number of dirty pages that
+	 * must be under writeback before being throttled to priority.
+	 */
+	if (nr_writeback && nr_writeback >= (nr_taken >> (DEF_PRIORITY-priority)))
+		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
+
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
hugepages-fix-race-between-hugetlbfs-umount-and-quota-update-checkpatch-fixes.patch

