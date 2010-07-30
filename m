From: akpm@linux-foundation.org
Subject: + vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch added to -mm tree
Date: Fri, 30 Jul 2010 15:06:56 -0700
Message-ID: <201007302206.o6UM6ump003486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab0G3WIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 18:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: kick flusher threads to clean pages when reclaim is encountering dirty pages
has been added to the -mm tree.  Its filename is
     vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch

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
Subject: vmscan: kick flusher threads to clean pages when reclaim is encountering dirty pages
From: Mel Gorman <mel@csn.ul.ie>

There are a number of cases where pages get cleaned but two of concern
to this patch are:

- When dirtying pages, processes may be throttled to clean pages if
  dirty_ratio is exceeded.

- Pages belonging to inodes dirtied longer than
  dirty_writeback_centisecs get cleaned.

The problem for reclaim is that dirty pages can reach the end of the LRU
if pages are being dirtied slowly so that neither the throttling or a
flusher thread waking periodically cleans them.

Background flush is already cleaning old or expired inodes first but the
expire time is too far in the future at the time of page reclaim.  To
mitigate future problems, this patch wakes flusher threads to clean 4M of
data - an amount that should be manageable without causing congestion in
many cases.

Ideally, the background flushers would only be cleaning pages belonging to
the zone being scanned but it's not clear if this would be of benefit
(less IO) or not (potentially less efficient IO if an inode is scattered
across multiple zones).

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages
+++ a/mm/vmscan.c
@@ -142,6 +142,18 @@ static DECLARE_RWSEM(shrinker_rwsem);
 /* Direct lumpy reclaim waits up to five seconds for background cleaning */
 #define MAX_SWAP_CLEAN_WAIT 50
 
+/*
+ * When reclaim encounters dirty data, wakeup flusher threads to clean
+ * a maximum of 4M of data.
+ */
+#define MAX_WRITEBACK (4194304UL >> PAGE_SHIFT)
+#define WRITEBACK_FACTOR (MAX_WRITEBACK / SWAP_CLUSTER_MAX)
+static inline long nr_writeback_pages(unsigned long nr_dirty)
+{
+	return laptop_mode ? 0 :
+			min(MAX_WRITEBACK, (nr_dirty * WRITEBACK_FACTOR));
+}
+
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
@@ -649,12 +661,14 @@ static noinline_for_stack void free_page
 static unsigned long shrink_page_list(struct list_head *page_list,
 					struct scan_control *sc,
 					enum pageout_io sync_writeback,
+					int file,
 					unsigned long *nr_still_dirty)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
 	int pgactivate = 0;
 	unsigned long nr_dirty = 0;
+	unsigned long nr_dirty_seen = 0;
 	unsigned long nr_reclaimed = 0;
 
 	cond_resched();
@@ -748,6 +762,8 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
+			nr_dirty_seen++;
+
 			/*
 			 * Only kswapd can writeback filesystem pages to
 			 * avoid risk of stack overflow
@@ -875,6 +891,18 @@ keep:
 
 	list_splice(&ret_pages, page_list);
 
+	/*
+	 * If reclaim is encountering dirty pages, it may be because
+	 * dirty pages are reaching the end of the LRU even though the
+	 * dirty_ratio may be satisified. In this case, wake flusher
+	 * threads to pro-actively clean up to a maximum of
+	 * 4 * SWAP_CLUSTER_MAX amount of data (usually 1/2MB) unless
+	 * !may_writepage indicates that this is a direct reclaimer in
+	 * laptop mode avoiding disk spin-ups
+	 */
+	if (file && nr_dirty_seen && sc->may_writepage)
+		wakeup_flusher_threads(nr_writeback_pages(nr_dirty));
+
 	*nr_still_dirty = nr_dirty;
 	count_vm_events(PGACTIVATE, pgactivate);
 	return nr_reclaimed;
@@ -1315,7 +1343,7 @@ shrink_inactive_list(unsigned long nr_to
 	spin_unlock_irq(&zone->lru_lock);
 
 	nr_reclaimed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC,
-								&nr_dirty);
+							file, &nr_dirty);
 
 	/*
 	 * If specific pages are needed such as with direct reclaiming
@@ -1351,7 +1379,8 @@ shrink_inactive_list(unsigned long nr_to
 			count_vm_events(PGDEACTIVATE, nr_active);
 
 			nr_reclaimed += shrink_page_list(&page_list, sc,
-						PAGEOUT_IO_SYNC, &nr_dirty);
+						PAGEOUT_IO_SYNC, file,
+						&nr_dirty);
 		}
 	}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
vmscan-avoid-subtraction-of-unsigned-types.patch
vmscan-convert-direct-reclaim-tracepoint-to-define_trace.patch
memcg-vmscan-add-memcg-reclaim-tracepoint.patch
vmscan-convert-mm_vmscan_lru_isolate-to-define_event.patch
memcg-add-mm_vmscan_memcg_isolate-tracepoint.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
memcg-scnr_to_reclaim-should-be-initialized.patch
memcg-kill-unnecessary-initialization-in-mem_cgroup_shrink_node_zone.patch
memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch
memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch
memcg-convert-to-use-zone_to_nid-from-bare-zone-zone_pgdat-node_id.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

