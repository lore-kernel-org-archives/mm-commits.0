From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-remove-all_unreclaimable.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:04:49 -0700
Message-ID: <53e3dbe1.1u2AVRj1ULFtcuYC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33239 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHGUEu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:50 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so609011qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove all_unreclaimable()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-all_unreclaimable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-all_unreclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-all_unreclaimable
+++ a/mm/vmscan.c
@@ -2244,9 +2244,10 @@ static inline bool should_continue_recla
 	}
 }
 
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
+static bool shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned;
+	bool reclaimable = false;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2290,8 +2291,13 @@ static void shrink_zone(struct zone *zon
 			   sc->nr_scanned - nr_scanned,
 			   sc->nr_reclaimed - nr_reclaimed);
 
+		if (sc->nr_reclaimed - nr_reclaimed)
+			reclaimable = true;
+
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
+
+	return reclaimable;
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
@@ -2340,8 +2346,10 @@ static inline bool compaction_ready(stru
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
+ *
+ * Returns true if a zone was reclaimable.
  */
-static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2354,6 +2362,7 @@ static void shrink_zones(struct zonelist
 		.gfp_mask = sc->gfp_mask,
 	};
 	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
+	bool reclaimable = false;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2414,10 +2423,17 @@ static void shrink_zones(struct zonelist
 						&nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
+			if (nr_soft_reclaimed)
+				reclaimable = true;
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		shrink_zone(zone, sc);
+		if (shrink_zone(zone, sc))
+			reclaimable = true;
+
+		if (global_reclaim(sc) &&
+		    !reclaimable && zone_reclaimable(zone))
+			reclaimable = true;
 	}
 
 	/*
@@ -2439,26 +2455,8 @@ static void shrink_zones(struct zonelist
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
+	return reclaimable;
 }
 
 /*
@@ -2482,6 +2480,7 @@ static unsigned long do_try_to_free_page
 {
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
+	bool zones_reclaimable;
 
 	delayacct_freepages_start();
 
@@ -2492,7 +2491,7 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		shrink_zones(zonelist, sc);
+		zones_reclaimable = shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2532,8 +2531,8 @@ static unsigned long do_try_to_free_page
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

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

