From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
 added to -mm tree
Date: Fri, 08 Jul 2016 13:33:35 -0700
Message-ID: <57800e1f.bA/3PY8sitDa2tqk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbcGHUdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not reclaim from kswapd if there is any eligible zone
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
-
-		/*
 		 * Raise priority if scanning rate is too low or there was no
 		 * progress in reclaiming pages
 		 */
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

