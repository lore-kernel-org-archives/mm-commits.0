From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch removed
 from -mm tree
Date: Wed, 02 Jul 2014 12:27:05 -0700
Message-ID: <53b45d09.yiVf1YHOpzeDRmiK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:59858 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaGBT1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 15:27:06 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so1980312pdi.1
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 12:27:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: reduce cost of the fair zone allocation policy
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: reduce cost of the fair zone allocation policy

The fair zone allocation policy round-robins allocations between zones
within a node to avoid age inversion problems during reclaim.  If the
first allocation fails, the batch counts are reset and a second attempt
made before entering the slow path.

One assumption made with this scheme is that batches expire at roughly the
same time and the resets each time are justified.  This assumption does
not hold when zones reach their low watermark as the batches will be
consumed at uneven rates.  Allocation failures due to watermark depletion
result in additional zonelist scans for the reset and another watermark
check before hitting the slowpath.

This patch makes a number of changes that should reduce the overall cost

o Abort the fair zone allocation policy once remote zones are
  encountered

o Use a simplier scan when resetting NR_ALLOC_BATCH

o Use a simple flag to identify depleted zones instead of accessing a
  potentially write-intensive cache line for counters

On UMA machines, the effect on overall performance is marginal.  The main
impact is on system CPU usage which is small enough on UMA to begin with. 
This comparison shows the system CPU usage between vanilla, the previous
patch and this patch.

          3.16.0-rc2  3.16.0-rc2  3.16.0-rc2
             vanilla checklow-v4 fairzone-v4
User          390.13      400.85      396.13
System        404.41      393.60      389.61
Elapsed      5412.45     5166.12     5163.49

There is a small reduction and it appears consistent.

On NUMA machines, the scanning overhead is higher as zones are scanned
that are ineligible for use by zone allocation policy.  This patch fixes
the zone-order zonelist policy and reduces the numbers of zones scanned by
the allocator leading to an overall reduction of CPU usage.

          3.16.0-rc2  3.16.0-rc2  3.16.0-rc2
             vanilla checklow-v4 fairzone-v4
User          744.05      763.26      778.53
System      70148.60    49331.48    44905.73
Elapsed     28094.08    27476.72    27378.98

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++
 mm/page_alloc.c        |  113 ++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 49 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy
+++ a/include/linux/mmzone.h
@@ -534,6 +534,7 @@ typedef enum {
 	ZONE_WRITEBACK,			/* reclaim scanning has recently found
 					 * many pages under writeback
 					 */
+	ZONE_FAIR_DEPLETED,		/* fair zone policy batch depleted */
 } zone_flags_t;
 
 static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
@@ -571,6 +572,11 @@ static inline int zone_is_reclaim_locked
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
 }
 
+static inline int zone_is_fair_depleted(const struct zone *zone)
+{
+	return test_bit(ZONE_FAIR_DEPLETED, &zone->flags);
+}
+
 static inline int zone_is_oom_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
diff -puN mm/page_alloc.c~mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy
+++ a/mm/page_alloc.c
@@ -1606,6 +1606,8 @@ again:
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0)
+		zone_set_flag(zone, ZONE_FAIR_DEPLETED);
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
@@ -1917,6 +1919,20 @@ static bool zone_allows_reclaim(struct z
 
 #endif	/* CONFIG_NUMA */
 
+static void reset_alloc_batches(struct zone *preferred_zone)
+{
+	struct zone *zone = preferred_zone->zone_pgdat->node_zones;
+
+	do {
+		if (!zone_is_fair_depleted(zone))
+			continue;
+		mod_zone_page_state(zone, NR_ALLOC_BATCH,
+			high_wmark_pages(zone) - low_wmark_pages(zone) -
+			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
+		zone_clear_flag(zone, ZONE_FAIR_DEPLETED);
+	} while (zone++ != preferred_zone);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -1934,8 +1950,11 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 	bool consider_zone_dirty = (alloc_flags & ALLOC_WMARK_LOW) &&
 				(gfp_mask & __GFP_WRITE);
+	int nr_fair_skipped = 0;
+	bool zonelist_rescan;
 
 zonelist_scan:
+	zonelist_rescan = false;
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed_softwall() comment in kernel/cpuset.c.
@@ -1959,9 +1978,12 @@ zonelist_scan:
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
+				break;
+
+			if (zone_is_fair_depleted(zone)) {
+				nr_fair_skipped++;
 				continue;
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
-				continue;
+			}
 		}
 		/*
 		 * When allocating a page cache page for writing, we
@@ -2067,13 +2089,7 @@ this_zone_full:
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-	if (unlikely(IS_ENABLED(CONFIG_NUMA) && page == NULL && zlc_active)) {
-		/* Disable zlc cache for second zonelist scan */
-		zlc_active = 0;
-		goto zonelist_scan;
-	}
-
-	if (page)
+	if (page) {
 		/*
 		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
 		 * necessary to allocate the page. The expectation is
@@ -2082,8 +2098,37 @@ this_zone_full:
 		 * for !PFMEMALLOC purposes.
 		 */
 		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+		return page;
+	}
 
-	return page;
+	/*
+	 * The first pass makes sure allocations are spread fairly within the
+	 * local node.  However, the local node might have free pages left
+	 * after the fairness batches are exhausted, and remote zones haven't
+	 * even been considered yet.  Try once more without fairness, and
+	 * include remote zones now, before entering the slowpath and waking
+	 * kswapd: prefer spilling to a remote zone over swapping locally.
+	 */
+	if (alloc_flags & ALLOC_FAIR) {
+		alloc_flags &= ~ALLOC_FAIR;
+		if (nr_fair_skipped) {
+			zonelist_rescan = true;
+			reset_alloc_batches(preferred_zone);
+		}
+		if (nr_online_nodes > 1)
+			zonelist_rescan = true;
+	}
+
+	if (unlikely(IS_ENABLED(CONFIG_NUMA) && zlc_active)) {
+		/* Disable zlc cache for second zonelist scan */
+		zlc_active = 0;
+		zonelist_rescan = true;
+	}
+
+	if (zonelist_rescan)
+		goto zonelist_scan;
+
+	return NULL;
 }
 
 /*
@@ -2404,28 +2449,6 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 	return page;
 }
 
-static void reset_alloc_batches(struct zonelist *zonelist,
-				enum zone_type high_zoneidx,
-				struct zone *preferred_zone)
-{
-	struct zoneref *z;
-	struct zone *zone;
-
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-		/*
-		 * Only reset the batches of zones that were actually
-		 * considered in the fairness pass, we don't want to
-		 * trash fairness information for zones that are not
-		 * actually part of this zonelist's round-robin cycle.
-		 */
-		if (!zone_local(preferred_zone, zone))
-			continue;
-		mod_zone_page_state(zone, NR_ALLOC_BATCH,
-			high_wmark_pages(zone) - low_wmark_pages(zone) -
-			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
-	}
-}
-
 static void wake_all_kswapds(unsigned int order,
 			     struct zonelist *zonelist,
 			     enum zone_type high_zoneidx,
@@ -2723,6 +2746,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
 	struct zoneref *preferred_zoneref;
+	struct zoneref *second_zoneref;
 	struct page *page = NULL;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
@@ -2757,33 +2781,24 @@ retry_cpuset:
 		goto out;
 	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
+	/*
+	 * Only apply the fair zone allocation policy if there is more than
+	 * one local eligible zone
+	 */
+	second_zoneref = preferred_zoneref + 1;
+	if (zonelist_zone(second_zoneref) &&
+	    zone_local(preferred_zone, zonelist_zone(second_zoneref)))
+		alloc_flags |= ALLOC_FAIR;
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
-retry:
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
 			preferred_zone, classzone_idx, migratetype);
 	if (unlikely(!page)) {
 		/*
-		 * The first pass makes sure allocations are spread
-		 * fairly within the local node.  However, the local
-		 * node might have free pages left after the fairness
-		 * batches are exhausted, and remote zones haven't
-		 * even been considered yet.  Try once more without
-		 * fairness, and include remote zones now, before
-		 * entering the slowpath and waking kswapd: prefer
-		 * spilling to a remote zone over swapping locally.
-		 */
-		if (alloc_flags & ALLOC_FAIR) {
-			reset_alloc_batches(zonelist, high_zoneidx,
-					    preferred_zone);
-			alloc_flags &= ~ALLOC_FAIR;
-			goto retry;
-		}
-		/*
 		 * Runtime PM, block IO and its error handling path
 		 * can deadlock because I/O on the device might not
 		 * complete.
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mem-hotplug-improve-zone_movable_is_highmem-logic.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

