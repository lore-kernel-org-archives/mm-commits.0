From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:52 -0700
Message-ID: <533f086c.LhhAwFntB7KZrOzI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: [merged] mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch removed from -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:52 -0700


The patch titled
     Subject: mm: vmscan: move call to shrink_slab() to shrink_zones()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: move call to shrink_slab() to shrink_zones()

This reduces the indentation level of do_try_to_free_pages() and removes
extra loop over all eligible zones counting the number of on-LRU pages.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Glauber Costa <glommer@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   56 ++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-move-call-to-shrink_slab-to-shrink_zones mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-call-to-shrink_slab-to-shrink_zones
+++ a/mm/vmscan.c
@@ -2291,13 +2291,16 @@ static inline bool compaction_ready(stru
  * the caller that it should consider retrying the allocation instead of
  * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc,
+			 struct shrink_control *shrink)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	unsigned long lru_pages = 0;
 	bool aborted_reclaim = false;
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2307,6 +2310,8 @@ static bool shrink_zones(struct zonelist
 	if (buffer_heads_over_limit)
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
+	nodes_clear(shrink->nodes_to_scan);
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2318,6 +2323,10 @@ static bool shrink_zones(struct zonelist
 		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
+
+			lru_pages += zone_reclaimable_pages(zone);
+			node_set(zone_to_nid(zone), shrink->nodes_to_scan);
+
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
@@ -2354,6 +2363,20 @@ static bool shrink_zones(struct zonelist
 		shrink_zone(zone, sc);
 	}
 
+	/*
+	 * Don't shrink slabs when reclaiming memory from over limit cgroups
+	 * but do shrink slab at least once when aborting reclaim for
+	 * compaction to avoid unevenly scanning file/anon LRU pages over slab
+	 * pages.
+	 */
+	if (global_reclaim(sc)) {
+		shrink_slab(shrink, sc->nr_scanned, lru_pages);
+		if (reclaim_state) {
+			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+			reclaim_state->reclaimed_slab = 0;
+		}
+	}
+
 	return aborted_reclaim;
 }
 
@@ -2398,9 +2421,6 @@ static unsigned long do_try_to_free_page
 					struct shrink_control *shrink)
 {
 	unsigned long total_scanned = 0;
-	struct reclaim_state *reclaim_state = current->reclaim_state;
-	struct zoneref *z;
-	struct zone *zone;
 	unsigned long writeback_threshold;
 	bool aborted_reclaim;
 
@@ -2413,34 +2433,8 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
+		aborted_reclaim = shrink_zones(zonelist, sc, shrink);
 
-		/*
-		 * Don't shrink slabs when reclaiming memory from over limit
-		 * cgroups but do shrink slab at least once when aborting
-		 * reclaim for compaction to avoid unevenly scanning file/anon
-		 * LRU pages over slab pages.
-		 */
-		if (global_reclaim(sc)) {
-			unsigned long lru_pages = 0;
-
-			nodes_clear(shrink->nodes_to_scan);
-			for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask), sc->nodemask) {
-				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-					continue;
-
-				lru_pages += zone_reclaimable_pages(zone);
-				node_set(zone_to_nid(zone),
-					 shrink->nodes_to_scan);
-			}
