From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vmscan-remove-all_unreclaimable-fix.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:46:31 -0700
Message-ID: <53e2b047.2pAQRZS2Mxfe5Fys%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:47570 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaHFWqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:46:32 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so838970pab.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:46:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove all_unreclaimable() fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-all_unreclaimable-fix.patch

This patch was dropped because it was folded into mm-vmscan-remove-all_unreclaimable.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: remove all_unreclaimable() fix

As per Mel, use bool for reclaimability throughout and simplify the
reclaimability tracking in shrink_zones().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-all_unreclaimable-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-all_unreclaimable-fix
+++ a/mm/vmscan.c
@@ -2248,10 +2248,10 @@ static inline bool should_continue_recla
 	}
 }
 
-static unsigned long shrink_zone(struct zone *zone, struct scan_control *sc)
+static bool shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned;
-	unsigned long zone_reclaimed = 0;
+	bool reclaimable = false;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2295,12 +2295,13 @@ static unsigned long shrink_zone(struct
 			   sc->nr_scanned - nr_scanned,
 			   sc->nr_reclaimed - nr_reclaimed);
 
-		zone_reclaimed += sc->nr_reclaimed - nr_reclaimed;
+		if (sc->nr_reclaimed - nr_reclaimed)
+			reclaimable = true;
 
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
 
-	return zone_reclaimed;
+	return reclaimable;
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
@@ -2350,7 +2351,7 @@ static inline bool compaction_ready(stru
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  *
- * Returns whether the zones overall are reclaimable or not.
+ * Returns true if a zone was reclaimable.
  */
 static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
@@ -2365,7 +2366,7 @@ static bool shrink_zones(struct zonelist
 		.gfp_mask = sc->gfp_mask,
 	};
 	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
-	bool all_unreclaimable = true;
+	bool reclaimable = false;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2380,8 +2381,6 @@ static bool shrink_zones(struct zonelist
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
-		unsigned long zone_reclaimed = 0;
-
 		if (!populated_zone(zone))
 			continue;
 		/*
@@ -2428,15 +2427,17 @@ static bool shrink_zones(struct zonelist
 						&nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
-			zone_reclaimed += nr_soft_reclaimed;
+			if (nr_soft_reclaimed)
+				reclaimable = true;
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		zone_reclaimed += shrink_zone(zone, sc);
+		if (shrink_zone(zone, sc))
+			reclaimable = true;
 
-		if (zone_reclaimed ||
-		    (global_reclaim(sc) && zone_reclaimable(zone)))
-			all_unreclaimable = false;
+		if (global_reclaim(sc) &&
+		    !reclaimable && zone_reclaimable(zone))
+			reclaimable = true;
 	}
 
 	/*
@@ -2459,7 +2460,7 @@ static bool shrink_zones(struct zonelist
 	 */
 	sc->gfp_mask = orig_mask;
 
-	return !all_unreclaimable;
+	return reclaimable;
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge.patch

