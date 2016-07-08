From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch added to -mm tree
Date: Fri, 08 Jul 2016 13:34:01 -0700
Message-ID: <57800e39.8joDQzwYC9NFJWuo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbcGHUeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to shrink_node
has been added to the -mm tree.  Its filename is
     mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to shrink_node

shrink_node receives all information it needs about classzone_idx
from sc->reclaim_idx so remove the aliases.

Link: http://lkml.kernel.org/r/1467970510-21195-25-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node
+++ a/mm/vmscan.c
@@ -2426,8 +2426,7 @@ static inline bool should_continue_recla
 	return true;
 }
 
-static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc,
-			enum zone_type classzone_idx)
+static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
@@ -2656,7 +2655,7 @@ static void shrink_zones(struct zonelist
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
-		shrink_node(zone->zone_pgdat, sc, classzone_idx);
+		shrink_node(zone->zone_pgdat, sc);
 	}
 
 	/*
@@ -3080,7 +3079,6 @@ static bool prepare_kswapd_sleep(pg_data
  * This is used to determine if the scanning priority needs to be raised.
  */
 static bool kswapd_shrink_node(pg_data_t *pgdat,
-			       int classzone_idx,
 			       struct scan_control *sc)
 {
 	struct zone *zone;
@@ -3088,7 +3086,7 @@ static bool kswapd_shrink_node(pg_data_t
 
 	/* Reclaim a number of pages proportional to the number of zones */
 	sc->nr_to_reclaim = 0;
-	for (z = 0; z <= classzone_idx; z++) {
+	for (z = 0; z <= sc->reclaim_idx; z++) {
 		zone = pgdat->node_zones + z;
 		if (!populated_zone(zone))
 			continue;
@@ -3100,7 +3098,7 @@ static bool kswapd_shrink_node(pg_data_t
 	 * Historically care was taken to put equal pressure on all zones but
 	 * now pressure is applied based on node LRU order.
 	 */
-	shrink_node(pgdat, sc, classzone_idx);
+	shrink_node(pgdat, sc);
 
 	/*
 	 * Fragmentation may mean that the system cannot be rebalanced for
@@ -3162,7 +3160,7 @@ static int balance_pgdat(pg_data_t *pgda
 				if (!populated_zone(zone))
 					continue;
 
-				classzone_idx = i;
+				sc.reclaim_idx = i;
 				break;
 			}
 		}
@@ -3175,12 +3173,12 @@ static int balance_pgdat(pg_data_t *pgda
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
 
@@ -3211,7 +3209,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 * enough pages are already being scanned that that high
 		 * watermark would be met at 100% efficiency.
 		 */
-		if (kswapd_shrink_node(pgdat, classzone_idx, &sc))
+		if (kswapd_shrink_node(pgdat, &sc))
 			raise_priority = false;
 
 		/*
@@ -3674,7 +3672,7 @@ static int __node_reclaim(struct pglist_
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-			shrink_node(pgdat, &sc, classzone_idx);
+			shrink_node(pgdat, &sc);
 		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
 	}
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
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
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

