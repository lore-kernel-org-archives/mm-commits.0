From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:54:49 -0700
Message-ID: <579ba679.sPB19Rvqc1+VtAk8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcG2Syu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not reclaim from kswapd if there is any eligible zone
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmscan: do not reclaim from kswapd if there is any eligible zone

kswapd scans from highest to lowest for a zone that requires balancing.
This was necessary when reclaim was per-zone to fairly age pages on lower
zones.  Now that we are reclaiming on a per-node basis, any eligible zone
can be used and pages will still be aged fairly.  This patch avoids
reclaiming excessively unless buffer_heads are over the limit and it's
necessary to reclaim from a higher zone than requested by the waker of
kswapd to relieve low memory pressure.

[hillf.zj@alibaba-inc.com: Force kswapd reclaim no more than needed]
Link: http://lkml.kernel.org/r/1466518566-30034-12-git-send-email-mgorman@techsingularity.net
Link: http://lkml.kernel.org/r/1467970510-21195-13-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   59 ++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone
+++ a/mm/vmscan.c
@@ -3144,31 +3144,39 @@ static int balance_pgdat(pg_data_t *pgda
 
 		sc.nr_reclaimed = 0;
 
-		/* Scan from the highest requested zone to dma */
-		for (i = classzone_idx; i >= 0; i--) {
-			zone = pgdat->node_zones + i;
-			if (!populated_zone(zone))
-				continue;
-
-			/*
-			 * If the number of buffer_heads in the machine
-			 * exceeds the maximum allowed level and this node
-			 * has a highmem zone, force kswapd to reclaim from
-			 * it to relieve lowmem pressure.
-			 */
-			if (buffer_heads_over_limit && is_highmem_idx(i)) {
-				classzone_idx = i;
-				break;
-			}
+		/*
+		 * If the number of buffer_heads in the machine exceeds the
+		 * maximum allowed level then reclaim from all zones. This is
+		 * not specific to highmem as highmem may not exist but it is
+		 * it is expected that buffer_heads are stripped in writeback.
+		 */
+		if (buffer_heads_over_limit) {
+			for (i = MAX_NR_ZONES - 1; i >= 0; i--) {
+				zone = pgdat->node_zones + i;
+				if (!populated_zone(zone))
+					continue;
 
-			if (!zone_balanced(zone, order, 0)) {
 				classzone_idx = i;
 				break;
 			}
 		}
 
-		if (i < 0)
-			goto out;
+		/*
+		 * Only reclaim if there are no eligible zones. Check from
+		 * high to low zone as allocations prefer higher zones.
+		 * Scanning from low to high zone would allow congestion to be
+		 * cleared during a very small window when a small low
+		 * zone was balanced even under extreme pressure when the
+		 * overall node may be congested.
+		 */
+		for (i = classzone_idx; i >= 0; i--) {
+			zone = pgdat->node_zones + i;
+			if (!populated_zone(zone))
+				continue;
+
+			if (zone_balanced(zone, sc.order, classzone_idx))
+				goto out;
+		}
 
 		/*
 		 * Do some background aging of the anon list, to give
@@ -3214,19 +3222,6 @@ static int balance_pgdat(pg_data_t *pgda
 			break;
 
 		/*
-		 * Stop reclaiming if any eligible zone is balanced and clear
-		 * node writeback or congested.
-		 */
-		for (i = 0; i <= classzone_idx; i++) {
-			zone = pgdat->node_zones + i;
-			if (!populated_zone(zone))
-				continue;
-
-			if (zone_balanced(zone, sc.order, classzone_idx))
-				goto out;
-		}
