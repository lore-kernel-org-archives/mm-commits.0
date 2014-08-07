From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:47 -0700
Message-ID: <53e3dbdf.adzFb7YJZ0iD5yBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:51080 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHGUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:48 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so610123ykq.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: rework compaction-ready signaling in direct reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: rework compaction-ready signaling in direct reclaim

Page reclaim for a higher-order page runs until compaction is ready, then
aborts and signals this situation through the return value of
shrink_zones().  This is an oddly specific signal to encode in the return
value of shrink_zones(), though, and can be quite confusing.

Introduce sc->compaction_ready and signal the compactability of the zones
out-of-band to free up the return value of shrink_zones() for actual zone
reclaimability.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   70 ++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 38 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim
+++ a/mm/vmscan.c
@@ -65,6 +65,9 @@ struct scan_control {
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
+	/* One of the zones is ready for compaction */
+	int compaction_ready;
+
 	/* How many pages shrink_list() should reclaim */
 	unsigned long nr_to_reclaim;
 
@@ -2292,15 +2295,11 @@ static void shrink_zone(struct zone *zon
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
-static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
+static inline bool compaction_ready(struct zone *zone, int order)
 {
 	unsigned long balance_gap, watermark;
 	bool watermark_ok;
 
-	/* Do not consider compaction for orders reclaim is meant to satisfy */
-	if (sc->order <= PAGE_ALLOC_COSTLY_ORDER)
-		return false;
-
 	/*
 	 * Compaction takes time to run and there are potentially other
 	 * callers using the pages just freed. Continue reclaiming until
@@ -2309,18 +2308,18 @@ static inline bool compaction_ready(stru
 	 */
 	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
 			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
-	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
+	watermark = high_wmark_pages(zone) + balance_gap + (2UL << order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
 
 	/*
 	 * If compaction is deferred, reclaim up to a point where
 	 * compaction will have a chance of success when re-enabled
 	 */
-	if (compaction_deferred(zone, sc->order))
+	if (compaction_deferred(zone, order))
 		return watermark_ok;
 
 	/* If compaction is not ready to start, keep reclaiming */
-	if (!compaction_suitable(zone, sc->order))
+	if (!compaction_suitable(zone, order))
 		return false;
 
 	return watermark_ok;
@@ -2341,20 +2340,14 @@ static inline bool compaction_ready(stru
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
- *
- * This function returns true if a zone is being reclaimed for a costly
- * high-order allocation and compaction is ready to begin. This indicates to
- * the caller that it should consider retrying the allocation instead of
- * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	unsigned long lru_pages = 0;
-	bool aborted_reclaim = false;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	gfp_t orig_mask;
 	struct shrink_control shrink = {
@@ -2391,22 +2384,24 @@ static bool shrink_zones(struct zonelist
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
-			if (IS_ENABLED(CONFIG_COMPACTION)) {
-				/*
-				 * If we already have plenty of memory free for
-				 * compaction in this zone, don't free any more.
-				 * Even though compaction is invoked for any
-				 * non-zero order, only frequent costly order
-				 * reclamation is disruptive enough to become a
-				 * noticeable problem, like transparent huge
-				 * page allocations.
-				 */
-				if ((zonelist_zone_idx(z) <= requested_highidx)
-				    && compaction_ready(zone, sc)) {
-					aborted_reclaim = true;
-					continue;
-				}
+
+			/*
+			 * If we already have plenty of memory free for
+			 * compaction in this zone, don't free any more.
+			 * Even though compaction is invoked for any
+			 * non-zero order, only frequent costly order
+			 * reclamation is disruptive enough to become a
+			 * noticeable problem, like transparent huge
+			 * page allocations.
+			 */
+			if (IS_ENABLED(CONFIG_COMPACTION) &&
+			    sc->order > PAGE_ALLOC_COSTLY_ORDER &&
+			    zonelist_zone_idx(z) <= requested_highidx &&
+			    compaction_ready(zone, sc->order)) {
+				sc->compaction_ready = true;
+				continue;
 			}
+
 			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and
@@ -2444,8 +2439,6 @@ static bool shrink_zones(struct zonelist
 	 * promoted it to __GFP_HIGHMEM.
 	 */
 	sc->gfp_mask = orig_mask;
-
-	return aborted_reclaim;
 }
 
 /* All zones in zonelist are unreclaimable? */
@@ -2489,7 +2482,6 @@ static unsigned long do_try_to_free_page
 {
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
-	bool aborted_reclaim;
 
 	delayacct_freepages_start();
 
@@ -2500,11 +2492,14 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
+		shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
-			goto out;
+			break;
+
+		if (sc->compaction_ready)
+			break;
 
 		/*
 		 * If we're getting trouble reclaiming, start doing
@@ -2526,16 +2521,15 @@ static unsigned long do_try_to_free_page
 						WB_REASON_TRY_TO_FREE_PAGES);
 			sc->may_writepage = 1;
 		}
-	} while (--sc->priority >= 0 && !aborted_reclaim);
+	} while (--sc->priority >= 0);
 
-out:
 	delayacct_freepages_end();
 
 	if (sc->nr_reclaimed)
 		return sc->nr_reclaimed;
 
 	/* Aborted reclaim to try compaction? don't OOM, then */
-	if (aborted_reclaim)
+	if (sc->compaction_ready)
 		return 1;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

