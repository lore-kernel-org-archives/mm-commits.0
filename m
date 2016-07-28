From: akpm@linux-foundation.org
Subject: [patch 042/101] mm, vmscan: avoid passing in classzone_idx
 unnecessarily to compaction_ready
Date: Thu, 28 Jul 2016 15:46:38 -0700
Message-ID: <579a8b4e.6zFgQyEahvF8Y7rv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbcG1Wqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to compaction_ready

The scan_control structure has enough information available for
compaction_ready() to make a decision. The classzone_idx manipulations in
shrink_zones() are no longer necessary as the highest populated zone is
no longer used to determine if shrink_slab should be called or not.

[mgorman@techsingularity.net remove redundant check in shrink_zones()]
  Link: http://lkml.kernel.org/r/1468588165-12461-3-git-send-email-mgorman@techsingularity.net
Link: http://lkml.kernel.org/r/1467970510-21195-26-git-send-email-mgorman@techsingularity.net
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

 mm/vmscan.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready
+++ a/mm/vmscan.c
@@ -2523,7 +2523,7 @@ static bool shrink_node(pg_data_t *pgdat
  * Returns true if compaction should go ahead for a high-order request, or
  * the high-order allocation would succeed without compaction.
  */
-static inline bool compaction_ready(struct zone *zone, int order, int classzone_idx)
+static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long watermark;
 	bool watermark_ok;
@@ -2534,21 +2534,21 @@ static inline bool compaction_ready(stru
 	 * there is a buffer of free pages available to give compaction
 	 * a reasonable chance of completing and allocating the page
 	 */
-	watermark = high_wmark_pages(zone) + (2UL << order);
-	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, classzone_idx);
+	watermark = high_wmark_pages(zone) + (2UL << sc->order);
+	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, sc->reclaim_idx);
 
 	/*
 	 * If compaction is deferred, reclaim up to a point where
 	 * compaction will have a chance of success when re-enabled
 	 */
-	if (compaction_deferred(zone, order))
+	if (compaction_deferred(zone, sc->order))
 		return watermark_ok;
 
 	/*
 	 * If compaction is not ready to start and allocation is not likely
 	 * to succeed without it, then keep reclaiming.
 	 */
-	if (compaction_suitable(zone, order, 0, classzone_idx) == COMPACT_SKIPPED)
+	if (compaction_suitable(zone, sc->order, 0, sc->reclaim_idx) == COMPACT_SKIPPED)
 		return false;
 
 	return watermark_ok;
@@ -2569,7 +2569,6 @@ static void shrink_zones(struct zonelist
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
-	enum zone_type classzone_idx;
 	pg_data_t *last_pgdat = NULL;
 
 	/*
@@ -2580,7 +2579,7 @@ static void shrink_zones(struct zonelist
 	orig_mask = sc->gfp_mask;
 	if (buffer_heads_over_limit) {
 		sc->gfp_mask |= __GFP_HIGHMEM;
-		sc->reclaim_idx = classzone_idx = gfp_zone(sc->gfp_mask);
+		sc->reclaim_idx = gfp_zone(sc->gfp_mask);
 	}
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
@@ -2589,17 +2588,6 @@ static void shrink_zones(struct zonelist
 			continue;
 
 		/*
-		 * Note that reclaim_idx does not change as it is the highest
-		 * zone reclaimed from which for empty zones is a no-op but
-		 * classzone_idx is used by shrink_node to test if the slabs
-		 * should be shrunk on a given node.
-		 */
-		classzone_idx = sc->reclaim_idx;
-		while (!populated_zone(zone->zone_pgdat->node_zones +
-							classzone_idx))
-			classzone_idx--;
