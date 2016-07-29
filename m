From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-remove-balance-gap.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:54:41 -0700
Message-ID: <579ba671.KA4MtBd/deRG+OnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbcG2Sym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: remove balance gap
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-balance-gap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: remove balance gap

The balance gap was introduced to apply equal pressure to all zones when
reclaiming for a higher zone.  With node-based LRU, the need for the
balance gap is removed and the code is dead so remove it.

[vbabka@suse.cz: Also remove KSWAPD_ZONE_BALANCE_GAP_RATIO]
Link: http://lkml.kernel.org/r/1467970510-21195-9-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 ---------
 mm/vmscan.c          |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff -puN include/linux/swap.h~mm-vmscan-remove-balance-gap include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscan-remove-balance-gap
+++ a/include/linux/swap.h
@@ -157,15 +157,6 @@ enum {
 #define SWAP_CLUSTER_MAX 32UL
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
-/*
- * Ratio between zone->managed_pages and the "gap" that above the per-zone
- * "high_wmark". While balancing nodes, We allow kswapd to shrink zones that
- * do not meet the (high_wmark + gap) watermark, even which already met the
- * high_wmark, in order to provide better per-zone lru behavior. We are ok to
- * spend not more than 1% of the memory for this zone balancing "gap".
- */
-#define KSWAPD_ZONE_BALANCE_GAP_RATIO 100
-
 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
 #define SWAP_MAP_BAD	0x3f	/* Note pageblock is bad, in first swap_map */
 #define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
diff -puN mm/vmscan.c~mm-vmscan-remove-balance-gap mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-balance-gap
+++ a/mm/vmscan.c
@@ -2518,7 +2518,7 @@ static bool shrink_node(pg_data_t *pgdat
  */
 static inline bool compaction_ready(struct zone *zone, int order, int classzone_idx)
 {
-	unsigned long balance_gap, watermark;
+	unsigned long watermark;
 	bool watermark_ok;
 
 	/*
@@ -2527,9 +2527,7 @@ static inline bool compaction_ready(stru
 	 * there is a buffer of free pages available to give compaction
 	 * a reasonable chance of completing and allocating the page
 	 */
-	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
-			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
-	watermark = high_wmark_pages(zone) + balance_gap + (2UL << order);
+	watermark = high_wmark_pages(zone) + (2UL << order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, classzone_idx);
 
 	/*
@@ -3000,10 +2998,9 @@ static void age_active_anon(struct pglis
 	} while (memcg);
 }
 
-static bool zone_balanced(struct zone *zone, int order,
-			unsigned long balance_gap, int classzone_idx)
+static bool zone_balanced(struct zone *zone, int order, int classzone_idx)
 {
-	unsigned long mark = high_wmark_pages(zone) + balance_gap;
+	unsigned long mark = high_wmark_pages(zone);
 
 	return zone_watermark_ok_safe(zone, order, mark, classzone_idx);
 }
@@ -3045,7 +3042,7 @@ static bool prepare_kswapd_sleep(pg_data
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone_balanced(zone, order, 0, classzone_idx))
+		if (zone_balanced(zone, order, classzone_idx))
 			return true;
 	}
 
@@ -3148,7 +3145,7 @@ static int balance_pgdat(pg_data_t *pgda
 				break;
 			}
 
-			if (!zone_balanced(zone, order, 0, 0)) {
+			if (!zone_balanced(zone, order, 0)) {
 				classzone_idx = i;
 				break;
 			} else {
@@ -3216,7 +3213,7 @@ static int balance_pgdat(pg_data_t *pgda
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_balanced(zone, sc.order, 0, classzone_idx)) {
+			if (zone_balanced(zone, sc.order, classzone_idx)) {
 				clear_bit(PGDAT_CONGESTED, &pgdat->flags);
 				clear_bit(PGDAT_DIRTY, &pgdat->flags);
 				goto out;
@@ -3427,7 +3424,7 @@ void wakeup_kswapd(struct zone *zone, in
 	}
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
-	if (zone_balanced(zone, order, 0, 0))
+	if (zone_balanced(zone, order, 0))
 		return;
 
 	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


