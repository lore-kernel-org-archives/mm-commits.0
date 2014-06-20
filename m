From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-all_unreclaimable.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:24:52 -0700
Message-ID: <53a4b4b4.2uja06qOx47bC+LD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:24:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org


The patch titled
     Subject: mm: vmscan: remove all_unreclaimable()
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-all_unreclaimable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-all_unreclaimable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-all_unreclaimable.patch

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
Subject: mm: vmscan: remove all_unreclaimable()

Direct reclaim currently calls shrink_zones() to reclaim all members of a
zonelist, and if that wasn't successful it does another pass through the
same zonelist to check overall reclaimability.

Just check reclaimability in shrink_zones() directly and propagate the
result through the return value.  Then remove all_unreclaimable().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-all_unreclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-all_unreclaimable
+++ a/mm/vmscan.c
@@ -2250,9 +2250,10 @@ static inline bool should_continue_recla
 	}
 }
 
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
+static unsigned long shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned;
+	unsigned long zone_reclaimed = 0;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2296,8 +2297,12 @@ static void shrink_zone(struct zone *zon
 			   sc->nr_scanned - nr_scanned,
 			   sc->nr_reclaimed - nr_reclaimed);
 
+		zone_reclaimed += sc->nr_reclaimed - nr_reclaimed;
+
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
+
+	return zone_reclaimed;
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
@@ -2346,8 +2351,10 @@ static inline bool compaction_ready(stru
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
+ *
+ * Returns whether the zones overall are reclaimable or not.
  */
-static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2360,6 +2367,7 @@ static void shrink_zones(struct zonelist
 		.gfp_mask = sc->gfp_mask,
 	};
 	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
+	bool all_unreclaimable = true;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2374,6 +2382,8 @@ static void shrink_zones(struct zonelist
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
+		unsigned long zone_reclaimed = 0;
+
 		if (!populated_zone(zone))
 			continue;
 		/*
@@ -2420,10 +2430,15 @@ static void shrink_zones(struct zonelist
 						&nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
+			zone_reclaimed += nr_soft_reclaimed;
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		shrink_zone(zone, sc);
+		zone_reclaimed += shrink_zone(zone, sc);
+
+		if (zone_reclaimed ||
+		    (global_reclaim(sc) && zone_reclaimable(zone)))
+			all_unreclaimable = false;
 	}
 
 	/*
@@ -2445,26 +2460,8 @@ static void shrink_zones(struct zonelist
 	 * promoted it to __GFP_HIGHMEM.
 	 */
 	sc->gfp_mask = orig_mask;
-}
-
-/* All zones in zonelist are unreclaimable? */
-static bool all_unreclaimable(struct zonelist *zonelist,
-		struct scan_control *sc)
-{
-	struct zoneref *z;
-	struct zone *zone;
-
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-			gfp_zone(sc->gfp_mask), sc->nodemask) {
-		if (!populated_zone(zone))
-			continue;
-		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-			continue;
-		if (zone_reclaimable(zone))
-			return false;
-	}
 
-	return true;
+	return !all_unreclaimable;
 }
 
 /*
@@ -2488,6 +2485,7 @@ static unsigned long do_try_to_free_page
 {
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
+	bool zones_reclaimable;
 
 	delayacct_freepages_start();
 
@@ -2498,7 +2496,7 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		shrink_zones(zonelist, sc);
+		zones_reclaimable = shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2539,8 +2537,8 @@ out:
 	if (sc->compaction_ready)
 		return 1;
 
-	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (global_reclaim(sc) && !all_unreclaimable(zonelist, sc))
+	/* Any of the zones still reclaimable?  Don't OOM. */
+	if (zones_reclaimable)
 		return 1;
 
 	return 0;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
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
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

