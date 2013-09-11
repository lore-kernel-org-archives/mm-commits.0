From: akpm@linux-foundation.org
Subject: [folded-merged] mm-page_alloc-fair-zone-allocator-policy-v2.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:54:16 -0700
Message-ID: <5230d878.BmCc5UtUCArinuMm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3IKUyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [folded-merged] mm-page_alloc-fair-zone-allocator-policy-v2.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:54:16 -0700


The patch titled
     Subject: mm-page_alloc-fair-zone-allocator-policy-v2
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fair-zone-allocator-policy-v2.patch

This patch was dropped because it was folded into mm-page_alloc-fair-zone-allocator-policy.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-page_alloc-fair-zone-allocator-policy-v2

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 -
 mm/page_alloc.c        |   52 ++++++++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 12 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy-v2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy-v2
+++ a/include/linux/mmzone.h
@@ -352,7 +352,7 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
-	atomic_t		alloc_batch;
+	int			alloc_batch;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	/* Set to true when the PG_migrate_skip bits should be cleared */
diff -puN mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2
+++ a/mm/page_alloc.c
@@ -1817,6 +1817,11 @@ static void zlc_clear_zones_full(struct
 	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 }
 
+static bool zone_local(struct zone *local_zone, struct zone *zone)
+{
+	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
+}
+
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
@@ -1854,6 +1859,11 @@ static void zlc_clear_zones_full(struct
 {
 }
 
+static bool zone_local(struct zone *local_zone, struct zone *zone)
+{
+	return true;
+}
+
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return true;
@@ -1905,9 +1915,21 @@ zonelist_scan:
 		 * zone size to ensure fair page aging.  The zone a
 		 * page was allocated in should have no effect on the
 		 * time the page has in memory before being reclaimed.
+		 *
+		 * When zone_reclaim_mode is enabled, try to stay in
+		 * local zones in the fastpath.  If that fails, the
+		 * slowpath is entered, which will do another pass
+		 * starting with the local zones, but ultimately fall
+		 * back to remote zones that do not partake in the
+		 * fairness round-robin cycle of this zonelist.
 		 */
-		if (atomic_read(&zone->alloc_batch) <= 0)
-			continue;
+		if (alloc_flags & ALLOC_WMARK_LOW) {
+			if (zone->alloc_batch <= 0)
+				continue;
+			if (zone_reclaim_mode &&
+			    !zone_local(preferred_zone, zone))
+				continue;
+		}
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
@@ -2015,7 +2037,7 @@ this_zone_full:
 	}
 
 	if (page) {
-		atomic_sub(1U << order, &zone->alloc_batch);
+		zone->alloc_batch -= 1U << order;
 		/*
 		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
 		 * necessary to allocate the page. The expectation is
@@ -2359,16 +2381,24 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 static void prepare_slowpath(gfp_t gfp_mask, unsigned int order,
 			     struct zonelist *zonelist,
 			     enum zone_type high_zoneidx,
-			     enum zone_type classzone_idx)
+			     struct zone *preferred_zone)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-		atomic_set(&zone->alloc_batch,
-			   high_wmark_pages(zone) - low_wmark_pages(zone));
 		if (!(gfp_mask & __GFP_NO_KSWAPD))
-			wakeup_kswapd(zone, order, classzone_idx);
+			wakeup_kswapd(zone, order, zone_idx(preferred_zone));
+		/*
+		 * Only reset the batches of zones that were actually
+		 * considered in the fast path, we don't want to
+		 * thrash fairness information for zones that are not
+		 * actually part of this zonelist's round-robin cycle.
+		 */
+		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+			continue;
+		zone->alloc_batch = high_wmark_pages(zone) -
+			low_wmark_pages(zone);
 	}
 }
 
@@ -2466,7 +2496,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 restart:
 	prepare_slowpath(gfp_mask, order, zonelist,
-			 high_zoneidx, zone_idx(preferred_zone));
+			 high_zoneidx, preferred_zone);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -4768,7 +4798,7 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		/* For bootup, initialized properly in watermark setup */
-		atomic_set(&zone->alloc_batch, zone->managed_pages);
+		zone->alloc_batch = zone->managed_pages;
 
 		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec);
@@ -5541,8 +5571,8 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
-		atomic_set(&zone->alloc_batch,
-			   high_wmark_pages(zone) - low_wmark_pages(zone));
+		zone->alloc_batch = high_wmark_pages(zone) -
+			low_wmark_pages(zone);
 
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch
mm-page_alloc-fair-zone-allocator-policy-v2-fix-2.patch
mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
memcg-fix-multiple-large-threshold-notifications.patch

