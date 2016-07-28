From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch removed from -mm tree
Date: Thu, 28 Jul 2016 14:54:06 -0700
Message-ID: <579a7efe.bIMojzgj1QjElNuT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbcG1VyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 17:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to compaction_ready
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch

This patch was dropped because it was folded into mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to compaction_ready

The scan_control structure has enough information available for
compaction_ready() to make a decision. The classzone_idx manipulations in
shrink_zones() are no longer necessary as the highest populated zone is
no longer used to determine if shrink_slab should be called or not.

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

 mm/vmscan.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

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
-
-		/*
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
 		 */
@@ -2623,8 +2611,8 @@ static void shrink_zones(struct zonelist
 			 */
 			if (IS_ENABLED(CONFIG_COMPACTION) &&
 			    sc->order > PAGE_ALLOC_COSTLY_ORDER &&
-			    zonelist_zone_idx(z) <= classzone_idx &&
-			    compaction_ready(zone, sc->order, classzone_idx)) {
+			    zonelist_zone_idx(z) <= sc->reclaim_idx &&
+			    compaction_ready(zone, sc)) {
 				sc->compaction_ready = true;
 				continue;
 			}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready-fix.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit-fix.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries-fix.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
mm-vmscan-remove-redundant-check-in-shrink_zones.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change-fix.patch
mm-add-per-zone-lru-list-stat-fix.patch
mm-vmscan-remove-highmem_file_pages.patch
mm-vmscan-remove-highmem_file_pages-fix.patch
mm-remove-reclaim-and-compaction-retry-approximations.patch
mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch
mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch

