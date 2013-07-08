From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:49 -0700
Message-ID: <51db1201.RfYw7jW6zQr58G2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3GHTYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:49 -0700


The patch titled
     Subject: mm: vmscan: move logic from balance_pgdat() to kswapd_shrink_zone()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: move logic from balance_pgdat() to kswapd_shrink_zone()

balance_pgdat() is very long and some of the logic can and should be
internal to kswapd_shrink_zone().  Move it so the flow of balance_pgdat()
is marginally easier to follow.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  112 ++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 57 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone
+++ a/mm/vmscan.c
@@ -2709,18 +2709,53 @@ static bool prepare_kswapd_sleep(pg_data
  * This is used to determine if the scanning priority needs to be raised.
  */
 static bool kswapd_shrink_zone(struct zone *zone,
+			       int classzone_idx,
 			       struct scan_control *sc,
 			       unsigned long lru_pages,
 			       unsigned long *nr_attempted)
 {
 	unsigned long nr_slab;
+	int testorder = sc->order;
+	unsigned long balance_gap;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct shrink_control shrink = {
 		.gfp_mask = sc->gfp_mask,
 	};
+	bool lowmem_pressure;
 
 	/* Reclaim above the high watermark. */
 	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
+
+	/*
+	 * Kswapd reclaims only single pages with compaction enabled. Trying
+	 * too hard to reclaim until contiguous free pages have become
+	 * available can hurt performance by evicting too much useful data
+	 * from memory. Do not reclaim more than needed for compaction.
+	 */
+	if (IS_ENABLED(CONFIG_COMPACTION) && sc->order &&
+			compaction_suitable(zone, sc->order) !=
+				COMPACT_SKIPPED)
+		testorder = 0;
+
+	/*
+	 * We put equal pressure on every zone, unless one zone has way too
+	 * many pages free already. The "too many pages" is defined as the
+	 * high wmark plus a "gap" where the gap is either the low
+	 * watermark or 1% of the zone, whichever is smaller.
+	 */
+	balance_gap = min(low_wmark_pages(zone),
+		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+		KSWAPD_ZONE_BALANCE_GAP_RATIO);
+
+	/*
+	 * If there is no low memory pressure or the zone is balanced then no
+	 * reclaim is necessary
+	 */
+	lowmem_pressure = (buffer_heads_over_limit && is_highmem(zone));
+	if (!lowmem_pressure && zone_balanced(zone, testorder,
+						balance_gap, classzone_idx))
+		return true;
+
 	shrink_zone(zone, sc);
 
 	reclaim_state->reclaimed_slab = 0;
@@ -2735,6 +2770,18 @@ static bool kswapd_shrink_zone(struct zo
 
 	zone_clear_flag(zone, ZONE_WRITEBACK);
 
+	/*
+	 * If a zone reaches its high watermark, consider it to be no longer
+	 * congested. It's possible there are dirty pages backed by congested
+	 * BDIs but as pressure is relieved, speculatively avoid congestion
+	 * waits.
+	 */
+	if (!zone->all_unreclaimable &&
+	    zone_balanced(zone, testorder, 0, classzone_idx)) {
+		zone_clear_flag(zone, ZONE_CONGESTED);
+		zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
+	}
+
 	return sc->nr_scanned >= sc->nr_to_reclaim;
 }
 
@@ -2870,8 +2917,6 @@ static unsigned long balance_pgdat(pg_da
 		 */
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
-			int testorder;
-			unsigned long balance_gap;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2892,61 +2937,14 @@ static unsigned long balance_pgdat(pg_da
 			sc.nr_reclaimed += nr_soft_reclaimed;
 
 			/*
-			 * We put equal pressure on every zone, unless
-			 * one zone has way too many pages free
-			 * already. The "too many pages" is defined
-			 * as the high wmark plus a "gap" where the
-			 * gap is either the low watermark or 1%
-			 * of the zone, whichever is smaller.
-			 */
-			balance_gap = min(low_wmark_pages(zone),
-				(zone->managed_pages +
-					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
-				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			/*
-			 * Kswapd reclaims only single pages with compaction
-			 * enabled. Trying too hard to reclaim until contiguous
-			 * free pages have become available can hurt performance
-			 * by evicting too much useful data from memory.
-			 * Do not reclaim more than needed for compaction.
-			 */
-			testorder = order;
-			if (IS_ENABLED(CONFIG_COMPACTION) && order &&
-					compaction_suitable(zone, order) !=
-						COMPACT_SKIPPED)
-				testorder = 0;
-
-			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
-			    !zone_balanced(zone, testorder,
-					   balance_gap, end_zone)) {
-				/*
-				 * There should be no need to raise the
-				 * scanning priority if enough pages are
-				 * already being scanned that high
-				 * watermark would be met at 100% efficiency.
-				 */
-				if (kswapd_shrink_zone(zone, &sc, lru_pages,
-						       &nr_attempted))
-					raise_priority = false;
-			}
-
-			if (zone->all_unreclaimable) {
-				if (end_zone && end_zone == i)
-					end_zone--;
-				continue;
-			}
-
-			if (zone_balanced(zone, testorder, 0, end_zone))
-				/*
-				 * If a zone reaches its high watermark,
-				 * consider it to be no longer congested. It's
-				 * possible there are dirty pages backed by
-				 * congested BDIs but as pressure is relieved,
-				 * speculatively avoid congestion waits
-				 * or writing pages from kswapd context.
-				 */
-				zone_clear_flag(zone, ZONE_CONGESTED);
-				zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
+			 * There should be no need to raise the scanning
+			 * priority if enough pages are already being scanned
+			 * that that high watermark would be met at 100%
+			 * efficiency.
+			 */
+			if (kswapd_shrink_zone(zone, end_zone, &sc,
+					lru_pages, &nr_attempted))
+				raise_priority = false;
 		}
 
 		/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

