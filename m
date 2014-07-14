From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-all_unreclaimable-fix.patch added to -mm tree
Date: Mon, 14 Jul 2014 12:52:16 -0700
Message-ID: <53c434f0.BoFkP7ipcc1GTi/u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:50704 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbaGNTwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 15:52:17 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so961847obb.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 12:52:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove all_unreclaimable() fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-all_unreclaimable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-all_unreclaimable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-all_unreclaimable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: remove all_unreclaimable() fix

As per Mel, use bool for reclaimability throughout and simplify the
reclaimability tracking in shrink_zones().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
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

mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
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
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
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
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

