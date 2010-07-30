From: akpm@linux-foundation.org
Subject: + vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch added to -mm tree
Date: Fri, 30 Jul 2010 15:06:53 -0700
Message-ID: <201007302206.o6UM6rnB003483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab0G3WHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 18:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: do not writeback filesystem pages in direct reclaim
has been added to the -mm tree.  Its filename is
     vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch

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
Subject: vmscan: do not writeback filesystem pages in direct reclaim
From: Mel Gorman <mel@csn.ul.ie>

When memory is under enough pressure, a process may enter direct reclaim
to free pages in the same manner kswapd does.  If a dirty page is
encountered during the scan, this page is written to backing storage using
mapping->writepage.  This can result in very deep call stacks,
particularly if the target storage or filesystem are complex.  It has
already been observed on XFS that the stack overflows but the problem is
not XFS-specific.

This patch prevents direct reclaim writing back filesystem pages by
checking if current is kswapd or the page is anonymous before writing
back.  If the dirty pages cannot be written back, they are placed back on
the LRU lists for either background writing by the BDI threads or kswapd. 
If in direct lumpy reclaim and dirty pages are encountered, the process
will stall for the background flusher before trying to reclaim the pages
again.

As the call-chain for writing anonymous pages is not expected to be deep
and they are not cleaned by flusher threads, anonymous pages are still
written back in direct reclaim.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
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

 mm/vmscan.c |   69 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 15 deletions(-)

diff -puN mm/vmscan.c~vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim
+++ a/mm/vmscan.c
@@ -139,6 +139,9 @@ static DECLARE_RWSEM(shrinker_rwsem);
 #define scanning_global_lru(sc)	(1)
 #endif
 
+/* Direct lumpy reclaim waits up to five seconds for background cleaning */
+#define MAX_SWAP_CLEAN_WAIT 50
+
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
@@ -645,11 +648,13 @@ static noinline_for_stack void free_page
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
 					struct scan_control *sc,
-					enum pageout_io sync_writeback)
+					enum pageout_io sync_writeback,
+					unsigned long *nr_still_dirty)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
 	int pgactivate = 0;
+	unsigned long nr_dirty = 0;
 	unsigned long nr_reclaimed = 0;
 
 	cond_resched();
@@ -743,6 +748,15 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
+			/*
+			 * Only kswapd can writeback filesystem pages to
+			 * avoid risk of stack overflow
+			 */
+			if (page_is_file_cache(page) && !current_is_kswapd()) {
+				nr_dirty++;
+				goto keep_locked;
+			}
+
 			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
 			if (!may_enter_fs)
@@ -860,6 +874,8 @@ keep:
 	free_page_list(&free_pages);
 
 	list_splice(&ret_pages, page_list);
+
+	*nr_still_dirty = nr_dirty;
 	count_vm_events(PGACTIVATE, pgactivate);
 	return nr_reclaimed;
 }
@@ -1242,12 +1258,14 @@ shrink_inactive_list(unsigned long nr_to
 			struct scan_control *sc, int priority, int file)
 {
 	LIST_HEAD(page_list);
+	LIST_HEAD(putback_list);
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
 	unsigned long nr_active;
 	unsigned long nr_anon;
 	unsigned long nr_file;
+	unsigned long nr_dirty;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1296,28 +1314,49 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
+	nr_reclaimed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC,
+								&nr_dirty);
 
 	/*
-	 * If we are direct reclaiming for contiguous pages and we do
+	 * If specific pages are needed such as with direct reclaiming
+	 * for contiguous pages or for memory containers and we do
 	 * not reclaim everything in the list, try again and wait
-	 * for IO to complete. This will stall high-order allocations
-	 * but that should be acceptable to the caller
+	 * for IO to complete. This will stall callers that require
+	 * specific pages but it should be acceptable to the caller
 	 */
-	if (nr_reclaimed < nr_taken && !current_is_kswapd() &&
-			sc->lumpy_reclaim_mode) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
+	if (sc->may_writepage && !current_is_kswapd() &&
+			(sc->lumpy_reclaim_mode || sc->mem_cgroup)) {
+		int dirty_retry = MAX_SWAP_CLEAN_WAIT;
 
-		/*
-		 * The attempt at page out may have made some
-		 * of the pages active, mark them inactive again.
-		 */
-		nr_active = clear_active_flags(&page_list, NULL);
-		count_vm_events(PGDEACTIVATE, nr_active);
+		while (nr_reclaimed < nr_taken && nr_dirty && dirty_retry--) {
+			struct page *page, *tmp;
+
+			/* Take off the clean pages marked for activation */
+			list_for_each_entry_safe(page, tmp, &page_list, lru) {
+				if (PageDirty(page) || PageWriteback(page))
+					continue;
+
+				list_del(&page->lru);
+				list_add(&page->lru, &putback_list);
+			}
+
+			wakeup_flusher_threads(laptop_mode ? 0 : nr_dirty);
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
-		nr_reclaimed += shrink_page_list(&page_list, sc, PAGEOUT_IO_SYNC);
+			/*
+			 * The attempt at page out may have made some
+			 * of the pages active, mark them inactive again.
+			 */
+			nr_active = clear_active_flags(&page_list, NULL);
+			count_vm_events(PGDEACTIVATE, nr_active);
+
+			nr_reclaimed += shrink_page_list(&page_list, sc,
+						PAGEOUT_IO_SYNC, &nr_dirty);
+		}
 	}
 
+	list_splice(&putback_list, &page_list);
+
 	local_irq_disable();
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
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

