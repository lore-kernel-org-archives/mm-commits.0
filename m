From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch added to -mm tree
Date: Fri, 08 Jul 2016 13:34:07 -0700
Message-ID: <57800e3f.UJFoR+4HeVeIaTsM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbcGHUeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: Have kswapd reclaim from all zones if reclaiming and buffer_heads_over_limit
has been added to the -mm tree.  Its filename is
     mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch

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
Subject: mm, vmscan: Have kswapd reclaim from all zones if reclaiming and buffer_heads_over_limit

The buffer_heads_over_limit limit in kswapd is inconsistent with direct
reclaim behaviour. It may force an an attempt to reclaim from all zones and
then not reclaim at all because higher zones were balanced than required
by the original request.

This patch will causes kswapd to consider reclaiming from all zones if
buffer_heads_over_limit.  However, if there are eligible zones for the
allocation request that woke kswapd then no reclaim will occur even if
buffer_heads_over_limit. This avoids kswapd over-reclaiming just because
buffer_heads_over_limit.

Link: http://lkml.kernel.org/r/1467970510-21195-28-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit
+++ a/mm/vmscan.c
@@ -3122,7 +3122,6 @@ static int balance_pgdat(pg_data_t *pgda
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.reclaim_idx = classzone_idx,
 	};
 	count_vm_event(PAGEOUTRUN);
 
@@ -3130,12 +3129,16 @@ static int balance_pgdat(pg_data_t *pgda
 		bool raise_priority = true;
 
 		sc.nr_reclaimed = 0;
+		sc.reclaim_idx = classzone_idx;
 
 		/*
-		 * If the number of buffer_heads in the machine exceeds the
-		 * maximum allowed level then reclaim from all zones. This is
-		 * not specific to highmem as highmem may not exist but it is
-		 * it is expected that buffer_heads are stripped in writeback.
+		 * If the number of buffer_heads exceeds the maximum allowed
+		 * then consider reclaiming from all zones. This is not
+		 * specific to highmem which may not exist but it is it is
+		 * expected that buffer_heads are stripped in writeback.
+		 * Reclaim may still not go ahead if all eligible zones
+		 * for the original allocation request are balanced to
+		 * avoid excessive reclaim from kswapd.
 		 */
 		if (buffer_heads_over_limit) {
 			for (i = MAX_NR_ZONES - 1; i >= 0; i--) {
@@ -3154,14 +3157,16 @@ static int balance_pgdat(pg_data_t *pgda
 		 * Scanning from low to high zone would allow congestion to be
 		 * cleared during a very small window when a small low
 		 * zone was balanced even under extreme pressure when the
-		 * overall node may be congested.
+		 * overall node may be congested. Note that sc.reclaim_idx
+		 * is not used as buffer_heads_over_limit may have adjusted
+		 * it.
 		 */
-		for (i = sc.reclaim_idx; i >= 0; i--) {
+		for (i = classzone_idx; i >= 0; i--) {
 			zone = pgdat->node_zones + i;
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_balanced(zone, sc.order, sc.reclaim_idx))
+			if (zone_balanced(zone, sc.order, classzone_idx))
 				goto out;
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

