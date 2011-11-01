From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:29 -0700
Message-ID: <201111012109.pA1L9UMc003946@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1KAVKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, min


The patch titled
     Subject: mm: vmscan: throttle reclaim if encountering too many dirty pages under writeback
has been removed from the -mm tree.  Its filename was
     mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: throttle reclaim if encountering too many dirty pages under writeback

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback
+++ a/mm/vmscan.c
@@ -751,7 +751,9 @@ static noinline_for_stack void free_page
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
@@ -759,6 +761,7 @@ static unsigned long shrink_page_list(st
 	unsigned long nr_dirty = 0;
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
+	unsigned long nr_writeback = 0;
 
 	cond_resched();
 
@@ -795,6 +798,7 @@ static unsigned long shrink_page_list(st
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
+			nr_writeback++;
 			/*
 			 * Synchronous reclaim cannot queue pages for
 			 * writeback due to the possibility of stack overflow
@@ -1000,6 +1004,8 @@ keep_lumpy:
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
+	*ret_nr_dirty += nr_dirty;
+	*ret_nr_writeback += nr_writeback;
 	return nr_reclaimed;
 }
 
@@ -1460,6 +1466,8 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_taken;
 	unsigned long nr_anon;
 	unsigned long nr_file;
+	unsigned long nr_dirty = 0;
+	unsigned long nr_writeback = 0;
 	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
@@ -1512,12 +1520,14 @@ shrink_inactive_list(unsigned long nr_to
 
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
 
 	local_irq_disable();
@@ -1527,6 +1537,32 @@ shrink_inactive_list(unsigned long nr_to
 
 	putback_lru_pages(zone, sc, nr_anon, nr_file, &page_list);
 
+	/*
+	 * If reclaim is isolating dirty pages under writeback, it implies
+	 * that the long-lived page allocation rate is exceeding the page
+	 * laundering rate. Either the global limits are not being effective
+	 * at throttling processes due to the page distribution throughout
+	 * zones or there is heavy usage of a slow backing device. The
+	 * only option is to throttle from reclaim context which is not ideal
+	 * as there is no guarantee the dirtying process is throttled in the
+	 * same way balance_dirty_pages() manages.
+	 *
+	 * This scales the number of dirty pages that must be under writeback
+	 * before throttling depending on priority. It is a simple backoff
+	 * function that has the most effect in the range DEF_PRIORITY to
+	 * DEF_PRIORITY-2 which is the priority reclaim is considered to be
+	 * in trouble and reclaim is considered to be in trouble.
+	 *
+	 * DEF_PRIORITY   100% isolated pages must be PageWriteback to throttle
+	 * DEF_PRIORITY-1  50% must be PageWriteback
+	 * DEF_PRIORITY-2  25% must be PageWriteback, kswapd in trouble
+	 * ...
+	 * DEF_PRIORITY-6 For SWAP_CLUSTER_MAX isolated pages, throttle if any
+	 *                     isolated page is PageWriteback
+	 */
+	if (nr_writeback && nr_writeback >= (nr_taken >> (DEF_PRIORITY-priority)))
+		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
+
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

