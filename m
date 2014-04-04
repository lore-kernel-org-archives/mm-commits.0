From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:54 -0700
Message-ID: <533f086e.rRINeQWGab2heIpQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: [merged] mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch removed from -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:54 -0700


The patch titled
     Subject: mm: vmscan: remove shrink_control arg from do_try_to_free_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: remove shrink_control arg from do_try_to_free_pages()

There is no need passing on a shrink_control struct from
try_to_free_pages() and friends to do_try_to_free_pages() and then to
shrink_zones(), because it is only used in shrink_zones() and the only
field initialized on the top level is gfp_mask, which is always equal to
scan_control.gfp_mask.  So let's move shrink_control initialization to
shrink_zones().

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages
+++ a/mm/vmscan.c
@@ -2291,8 +2291,7 @@ static inline bool compaction_ready(stru
  * the caller that it should consider retrying the allocation instead of
  * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc,
-			 struct shrink_control *shrink)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2301,6 +2300,9 @@ static bool shrink_zones(struct zonelist
 	unsigned long lru_pages = 0;
 	bool aborted_reclaim = false;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
+	struct shrink_control shrink = {
+		.gfp_mask = sc->gfp_mask,
+	};
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2310,7 +2312,7 @@ static bool shrink_zones(struct zonelist
 	if (buffer_heads_over_limit)
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
-	nodes_clear(shrink->nodes_to_scan);
+	nodes_clear(shrink.nodes_to_scan);
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2325,7 +2327,7 @@ static bool shrink_zones(struct zonelist
 				continue;
 
 			lru_pages += zone_reclaimable_pages(zone);
-			node_set(zone_to_nid(zone), shrink->nodes_to_scan);
+			node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
@@ -2370,7 +2372,7 @@ static bool shrink_zones(struct zonelist
 	 * pages.
 	 */
 	if (global_reclaim(sc)) {
-		shrink_slab(shrink, sc->nr_scanned, lru_pages);
+		shrink_slab(&shrink, sc->nr_scanned, lru_pages);
 		if (reclaim_state) {
 			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 			reclaim_state->reclaimed_slab = 0;
@@ -2417,8 +2419,7 @@ static bool all_unreclaimable(struct zon
  * 		else, the number of pages reclaimed
  */
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
-					struct scan_control *sc,
-					struct shrink_control *shrink)
+					  struct scan_control *sc)
 {
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
@@ -2433,7 +2434,7 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc, shrink);
+		aborted_reclaim = shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2596,9 +2597,6 @@ unsigned long try_to_free_pages(struct z
 		.target_mem_cgroup = NULL,
 		.nodemask = nodemask,
 	};
-	struct shrink_control shrink = {
-		.gfp_mask = sc.gfp_mask,
-	};
 
 	/*
 	 * Do not enter reclaim if fatal signal was delivered while throttled.
@@ -2612,7 +2610,7 @@ unsigned long try_to_free_pages(struct z
 				sc.may_writepage,
 				gfp_mask);
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
 
@@ -2679,9 +2677,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 	};
-	struct shrink_control shrink = {
-		.gfp_mask = sc.gfp_mask,
-	};
 
 	/*
 	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
@@ -2696,7 +2691,7 @@ unsigned long try_to_free_mem_cgroup_pag
 					    sc.may_writepage,
 					    sc.gfp_mask);
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
@@ -3331,9 +3326,6 @@ unsigned long shrink_all_memory(unsigned
 		.order = 0,
 		.priority = DEF_PRIORITY,
 	};
-	struct shrink_control shrink = {
-		.gfp_mask = sc.gfp_mask,
-	};
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
 	unsigned long nr_reclaimed;
@@ -3343,7 +3335,7 @@ unsigned long shrink_all_memory(unsigned
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
slub-fix-leak-of-name-in-sysfs_slab_add.patch

