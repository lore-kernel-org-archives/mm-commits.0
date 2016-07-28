From: akpm@linux-foundation.org
Subject: [patch 041/101] mm, vmscan: avoid passing in classzone_idx
 unnecessarily to shrink_node
Date: Thu, 28 Jul 2016 15:46:35 -0700
Message-ID: <579a8b4b.7GZRcdGvOaIFIjtr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcG1Wqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to shrink_node

shrink_node receives all information it needs about classzone_idx
from sc->reclaim_idx so remove the aliases.

Link: http://lkml.kernel.org/r/1467970510-21195-25-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node
+++ a/mm/vmscan.c
@@ -2428,8 +2428,7 @@ static inline bool should_continue_recla
 	return true;
 }
 
-static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc,
-			enum zone_type classzone_idx)
+static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
@@ -2658,7 +2657,7 @@ static void shrink_zones(struct zonelist
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
-		shrink_node(zone->zone_pgdat, sc, classzone_idx);
+		shrink_node(zone->zone_pgdat, sc);
 	}
 
 	/*
@@ -3082,7 +3081,6 @@ static bool prepare_kswapd_sleep(pg_data
  * This is used to determine if the scanning priority needs to be raised.
  */
 static bool kswapd_shrink_node(pg_data_t *pgdat,
-			       int classzone_idx,
 			       struct scan_control *sc)
 {
 	struct zone *zone;
@@ -3090,7 +3088,7 @@ static bool kswapd_shrink_node(pg_data_t
 
 	/* Reclaim a number of pages proportional to the number of zones */
 	sc->nr_to_reclaim = 0;
-	for (z = 0; z <= classzone_idx; z++) {
+	for (z = 0; z <= sc->reclaim_idx; z++) {
 		zone = pgdat->node_zones + z;
 		if (!populated_zone(zone))
 			continue;
@@ -3102,7 +3100,7 @@ static bool kswapd_shrink_node(pg_data_t
 	 * Historically care was taken to put equal pressure on all zones but
 	 * now pressure is applied based on node LRU order.
 	 */
-	shrink_node(pgdat, sc, classzone_idx);
+	shrink_node(pgdat, sc);
 
 	/*
 	 * Fragmentation may mean that the system cannot be rebalanced for
@@ -3164,7 +3162,7 @@ static int balance_pgdat(pg_data_t *pgda
 				if (!populated_zone(zone))
 					continue;
 
-				classzone_idx = i;
+				sc.reclaim_idx = i;
 				break;
 			}
 		}
@@ -3177,12 +3175,12 @@ static int balance_pgdat(pg_data_t *pgda
 		 * zone was balanced even under extreme pressure when the
 		 * overall node may be congested.
 		 */
-		for (i = classzone_idx; i >= 0; i--) {
+		for (i = sc.reclaim_idx; i >= 0; i--) {
 			zone = pgdat->node_zones + i;
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_balanced(zone, sc.order, classzone_idx))
+			if (zone_balanced(zone, sc.order, sc.reclaim_idx))
 				goto out;
 		}
 
@@ -3213,7 +3211,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 * enough pages are already being scanned that that high
 		 * watermark would be met at 100% efficiency.
 		 */
-		if (kswapd_shrink_node(pgdat, classzone_idx, &sc))
+		if (kswapd_shrink_node(pgdat, &sc))
 			raise_priority = false;
 
 		/*
@@ -3676,7 +3674,7 @@ static int __node_reclaim(struct pglist_
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-			shrink_node(pgdat, &sc, classzone_idx);
+			shrink_node(pgdat, &sc);
 		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
 	}
 
_
