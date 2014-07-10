From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch added to -mm tree
Date: Thu, 10 Jul 2014 15:55:26 -0700
Message-ID: <53bf19de.XiIsDAO+/0X+ZjuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:55940 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaGJWz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 18:55:27 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so75745pdi.3
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 15:55:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: reduce cost of the fair zone allocation policy
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
consumed at uneven rates.  Allocation failure due to watermark depletion
result in additional zonelist scans for the reset and another watermark
check before hitting the slowpath.

On UMA, the benefit is negligible -- around 0.25%.  On 4-socket NUMA
machine it's variable due to the variability of measuring overhead with
the vmstat changes.  The system CPU overhead comparison looks like

          3.16.0-rc3  3.16.0-rc3  3.16.0-rc3
             vanilla   vmstat-v5 lowercost-v5
User          746.94      774.56      802.00
System      65336.22    32847.27    40852.33
Elapsed     27553.52    27415.04    27368.46

However it is worth noting that the overall benchmark still completed
faster and intuitively it makes sense to take as few passes as possible
through the zonelists.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++
 mm/page_alloc.c        |  101 ++++++++++++++++++++-------------------
 2 files changed, 59 insertions(+), 48 deletions(-)

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
@@ -1612,6 +1612,9 @@ again:
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&
+	    !zone_is_fair_depleted(zone))
+		zone_set_flag(zone, ZONE_FAIR_DEPLETED);
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
@@ -1923,6 +1926,18 @@ static bool zone_allows_reclaim(struct z
 
 #endif	/* CONFIG_NUMA */
 
+static void reset_alloc_batches(struct zone *preferred_zone)
+{
+	struct zone *zone = preferred_zone->zone_pgdat->node_zones;
+
+	do {
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
@@ -1940,8 +1955,12 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 	bool consider_zone_dirty = (alloc_flags & ALLOC_WMARK_LOW) &&
 				(gfp_mask & __GFP_WRITE);
+	int nr_fair_skipped = 0;
+	bool zonelist_rescan;
 
 zonelist_scan:
+	zonelist_rescan = false;
+
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed_softwall() comment in kernel/cpuset.c.
@@ -1966,8 +1985,10 @@ zonelist_scan:
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
 				break;
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
+			if (zone_is_fair_depleted(zone)) {
+				nr_fair_skipped++;
 				continue;
+			}
 		}
 		/*
 		 * When allocating a page cache page for writing, we
@@ -2073,13 +2094,7 @@ this_zone_full:
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
@@ -2088,8 +2103,37 @@ this_zone_full:
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
@@ -2410,28 +2454,6 @@ __alloc_pages_high_priority(gfp_t gfp_ma
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
@@ -2767,29 +2789,12 @@ retry_cpuset:
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
mm-update-the-description-for-vm_total_pages.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
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

