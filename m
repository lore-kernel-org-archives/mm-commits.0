From: akpm@linux-foundation.org
Subject: [folded] vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch removed from -mm tree
Date: Fri, 12 Jun 2009 09:05:28 -0700
Message-ID: <200906121605.n5CG5SZG009853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757852AbZFLQHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 12:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmscan: properly account for the number of page cache pages zone_reclaim() can reclaim
has been removed from the -mm tree.  Its filename was
     vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch

This patch was dropped because it was folded into vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: properly account for the number of page cache pages zone_reclaim() can reclaim
From: Mel Gorman <mel@csn.ul.ie>

A bug was brought to my attention against a distro kernel but it affects
mainline and I believe problems like this have been reported in various
guises on the mailing lists although I don't have specific examples at the
moment.

The reported problem was that malloc() stalled for a long time (minutes in
some cases) if a large tmpfs mount was occupying a large percentage of
memory overall.  The pages did not get cleaned or reclaimed by
zone_reclaim() because the zone_reclaim_mode was unsuitable, but the lists
are uselessly scanned frequencly making the CPU spin at near 100%.

This patchset intends to address that bug and bring the behaviour of
zone_reclaim() more in line with expectations which were noticed during
investigation.  It is based on top of mmotm and takes advantage of
Kosaki's work with respect to zone_reclaim().

Patch 1 fixes the heuristics that zone_reclaim() uses to determine if the
	scan should go ahead. The broken heuristic is what was causing the
	malloc() stall as it uselessly scanned the LRU constantly. Currently,
	zone_reclaim is assuming zone_reclaim_mode is 1 and historically it
	could not deal with tmpfs pages at all. This fixes up the heuristic so
	that an unnecessary scan is more likely to be correctly avoided.

Patch 2 notes that zone_reclaim() returning a failure automatically means
	the zone is marked full. This is not always true. It could have
	failed because the GFP mask or zone_reclaim_mode were unsuitable.

Patch 3 introduces a counter zreclaim_failed that will increment each
	time the zone_reclaim scan-avoidance heuristics fail. If that
	counter is rapidly increasing, then zone_reclaim_mode should be
	set to 0 as a temporarily resolution and a bug reported because
	the scan-avoidance heuristic is still broken.


This patch:

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim.  On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that
clean unmapped pages will be reclaimed if the zone watermarks are not
being met.

There is a heuristic that determines if the scan is worthwhile but the
problem is that the heuristic is not being properly applied and is
basically assuming zone_reclaim_mode is 1 if it is enabled.  The lack of
proper detection can manfiest as high CPU usage as the LRU list is scanned
uselessly.

Historically, once enabled it was depending on NR_FILE_PAGES which may
include swapcache pages that the reclaim_mode cannot deal with.  Patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch by
Kosaki Motohiro noted that zone_page_state(zone, NR_FILE_PAGES) included
pages that were not file-backed such as swapcache and made a calculation
based on the inactive, active and mapped files.  This is far superior when
zone_reclaim==1 but if RECLAIM_SWAP is set, then NR_FILE_PAGES is a
reasonable starting figure.

This patch alters how zone_reclaim() works out how many pages it might be
able to reclaim given the current reclaim_mode.  If RECLAIM_SWAP is set in
the reclaim_mode it will either consider NR_FILE_PAGES as potential
candidates or else use NR_{IN}ACTIVE}_PAGES-NR_FILE_MAPPED to discount
swapcache and other non-file-backed pages.  If RECLAIM_WRITE is not set,
then NR_FILE_DIRTY number of pages are not candidates.  If RECLAIM_SWAP is
not set, then NR_FILE_MAPPED are not.

[kosaki.motohiro@jp.fujitsu.com: Estimate unmapped pages minus tmpfs pages]
[fengguang.wu@intel.com: Fix underflow problem in Kosaki's estimate]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   55 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim
+++ a/mm/vmscan.c
@@ -2356,6 +2356,44 @@ int sysctl_min_unmapped_ratio = 1;
  */
 int sysctl_min_slab_ratio = 5;
 
+static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
+{
+	unsigned long file_mapped = zone_page_state(zone, NR_FILE_MAPPED);
+	unsigned long file_lru = zone_page_state(zone, NR_INACTIVE_FILE) +
+		zone_page_state(zone, NR_ACTIVE_FILE);
+
+	/*
+	 * It's possible for there to be more file mapped pages than
+	 * accounted for by the pages on the file LRU lists because
+	 * tmpfs pages accounted for as ANON can also be FILE_MAPPED
+	 */
+	return (file_lru > file_mapped) ? (file_lru - file_mapped) : 0;
+}
+
+/* Work out how many page cache pages we can reclaim in this reclaim_mode */
+static long zone_pagecache_reclaimable(struct zone *zone)
+{
+	long nr_pagecache_reclaimable;
+	long delta = 0;
+
+	/*
+	 * If RECLAIM_SWAP is set, then all file pages are considered
+	 * potentially reclaimable. Otherwise, we have to worry about
+	 * pages like swapcache and zone_unmapped_file_pages() provides
+	 * a better estimate
+	 */
+	if (zone_reclaim_mode & RECLAIM_SWAP)
+		nr_pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
+	else
+		nr_pagecache_reclaimable = zone_unmapped_file_pages(zone);
+
+	/* If we can't clean pages, remove dirty pages from consideration */
+	if (!(zone_reclaim_mode & RECLAIM_WRITE))
+		delta += zone_page_state(zone, NR_FILE_DIRTY);
+
+	return nr_pagecache_reclaimable;
+}
+
 /*
  * Try to free up some pages from this zone through reclaim.
  */
@@ -2378,7 +2416,6 @@ static int __zone_reclaim(struct zone *z
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
-	long nr_unmapped_file_pages;
 
 	disable_swap_token();
 	cond_resched();
@@ -2391,11 +2428,7 @@ static int __zone_reclaim(struct zone *z
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
-
-	if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
+	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
 		/*
 		 * Free memory by calling shrink zone with increasing
 		 * priorities until we have enough memory freed.
@@ -2442,8 +2475,6 @@ int zone_reclaim(struct zone *zone, gfp_
 {
 	int node_id;
 	int ret;
-	long nr_unmapped_file_pages;
-	long nr_slab_reclaimable;
 
 	/*
 	 * Zone reclaim reclaims unmapped file backed pages and
@@ -2455,12 +2486,8 @@ int zone_reclaim(struct zone *zone, gfp_
 	 * if less than a specified percentage of the zone is used by
 	 * unmapped file backed pages.
 	 */
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
-	nr_slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	if (nr_unmapped_file_pages <= zone->min_unmapped_pages &&
-	    nr_slab_reclaimable <= zone->min_slab_pages)
+	if (zone_pagecache_reclaimable(zone) <= zone->min_unmapped_pages &&
+	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return 0;
 
 	if (zone_is_all_unreclaimable(zone))
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
add-debugging-aid-for-memory-initialisation-problems.patch

