From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch added
 to -mm tree
Date: Fri, 20 Jun 2014 15:24:51 -0700
Message-ID: <53a4b4b3.anzYQXjrHt9/8+N6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTWYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org


The patch titled
     Subject: mm: vmscan: rework compaction-ready signaling in direct reclaim
has been added to the -mm tree.  Its filename is
     mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   67 +++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

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
 
@@ -2298,15 +2301,11 @@ static void shrink_zone(struct zone *zon
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
@@ -2315,18 +2314,18 @@ static inline bool compaction_ready(stru
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
@@ -2347,20 +2346,14 @@ static inline bool compaction_ready(stru
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
@@ -2397,22 +2390,24 @@ static bool shrink_zones(struct zonelist
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
@@ -2450,8 +2445,6 @@ static bool shrink_zones(struct zonelist
 	 * promoted it to __GFP_HIGHMEM.
 	 */
 	sc->gfp_mask = orig_mask;
-
-	return aborted_reclaim;
 }
 
 /* All zones in zonelist are unreclaimable? */
@@ -2495,7 +2488,6 @@ static unsigned long do_try_to_free_page
 {
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
-	bool aborted_reclaim;
 
 	delayacct_freepages_start();
 
@@ -2506,12 +2498,15 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
+		shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			goto out;
 
+		if (sc->compaction_ready)
+			goto out;
+
 		/*
 		 * If we're getting trouble reclaiming, start doing
 		 * writepage even in laptop mode.
@@ -2532,7 +2527,7 @@ static unsigned long do_try_to_free_page
 						WB_REASON_TRY_TO_FREE_PAGES);
 			sc->may_writepage = 1;
 		}
-	} while (--sc->priority >= 0 && !aborted_reclaim);
+	} while (--sc->priority >= 0);
 
 out:
 	delayacct_freepages_end();
@@ -2541,7 +2536,7 @@ out:
 		return sc->nr_reclaimed;
 
 	/* Aborted reclaim to try compaction? don't OOM, then */
-	if (aborted_reclaim)
+	if (sc->compaction_ready)
 		return 1;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

