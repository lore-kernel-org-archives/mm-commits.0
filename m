From: akpm@linux-foundation.org
Subject: + mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
 added to -mm tree
Date: Tue, 21 Jun 2016 15:49:20 -0700
Message-ID: <5769c470.xAjOXRS9JjxKkXE8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbcFUWuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 18:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: begin reclaiming pages on a per-node basis
has been added to the -mm tree.  Its filename is
     mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch

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
Subject: mm, vmscan: begin reclaiming pages on a per-node basis

This patch makes reclaim decisions on a per-node basis.  A reclaimer knows
what zone is required by the allocation request and skips pages from
higher zones.  In many cases this will be ok because it's a GFP_HIGHMEM
request of some description.  On 64-bit, ZONE_DMA32 requests will cause
some problems but 32-bit devices on 64-bit platforms are increasingly
rare.  Historically it would have been a major problem on 32-bit with big
Highmem:Lowmem ratios but such configurations are also now rare and even
where they exist, they are not encouraged.  If it really becomes a
problem, it'll manifest as very low reclaim efficiencies.

Link: http://lkml.kernel.org/r/1466518566-30034-5-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   78 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 25 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis
+++ a/mm/vmscan.c
@@ -84,6 +84,9 @@ struct scan_control {
 	/* Scan (total_size >> priority) pages at once */
 	int priority;
 
+	/* The highest zone to isolate pages for reclaim from */
+	enum zone_type reclaim_idx;
+
 	unsigned int may_writepage:1;
 
 	/* Can mapped pages be reclaimed? */
@@ -1392,6 +1395,7 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_taken = 0;
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
 	unsigned long scan, nr_pages;
+	LIST_HEAD(pages_skipped);
 
 	for (scan = 0; scan < nr_to_scan && nr_taken < nr_to_scan &&
 					!list_empty(src); scan++) {
@@ -1402,6 +1406,11 @@ static unsigned long isolate_lru_pages(u
 
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
 
+		if (page_zonenum(page) > sc->reclaim_idx) {
+			list_move(&page->lru, &pages_skipped);
+			continue;
+		}
+
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			nr_pages = hpage_nr_pages(page);
@@ -1420,6 +1429,15 @@ static unsigned long isolate_lru_pages(u
 		}
 	}
 
+	/*
+	 * Splice any skipped pages to the start of the LRU list. Note that
+	 * this disrupts the LRU order when reclaiming for lower zones but
+	 * we cannot splice to the tail. If we did then the SWAP_CLUSTER_MAX
+	 * scanning would soon rescan the same pages to skip and put the
+	 * system at risk of premature OOM.
+	 */
+	if (!list_empty(&pages_skipped))
+		list_splice(&pages_skipped, src);
 	*nr_scanned = scan;
 	trace_mm_vmscan_lru_isolate(sc->order, nr_to_scan, scan,
 				    nr_taken, mode, is_file_lru(lru));
@@ -1589,7 +1607,7 @@ static int current_may_throttle(void)
 }
 
 /*
- * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
+ * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
  */
 static noinline_for_stack unsigned long
@@ -2401,12 +2419,13 @@ static inline bool should_continue_recla
 	}
 }
 
-static bool shrink_zone(struct zone *zone, struct scan_control *sc,
-			bool is_classzone)
+static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc,
+			enum zone_type classzone_idx)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
+	struct zone *zone = &pgdat->node_zones[classzone_idx];
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2438,7 +2457,7 @@ static bool shrink_zone(struct zone *zon
 			shrink_zone_memcg(zone, memcg, sc, &lru_pages);
 			zone_lru_pages += lru_pages;
 
-			if (memcg && is_classzone)
+			if (!global_reclaim(sc) && sc->reclaim_idx == classzone_idx)
 				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
 					    memcg, sc->nr_scanned - scanned,
 					    lru_pages);
@@ -2469,7 +2488,7 @@ static bool shrink_zone(struct zone *zon
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
-		if (global_reclaim(sc) && is_classzone)
+		if (global_reclaim(sc) && sc->reclaim_idx == classzone_idx)
 			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
 				    sc->nr_scanned - nr_scanned,
 				    zone_lru_pages);
@@ -2546,14 +2565,14 @@ static inline bool compaction_ready(stru
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc,
+		enum zone_type classzone_idx)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
-	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2566,15 +2585,20 @@ static void shrink_zones(struct zonelist
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
-		enum zone_type classzone_idx;
-
 		if (!populated_zone(zone))
 			continue;
 
-		classzone_idx = requested_highidx;
+		/*
+		 * Note that reclaim_idx does not change as it is the highest
+		 * zone reclaimed from which for empty zones is a no-op but
+		 * classzone_idx is used by shrink_node to test if the slabs
+		 * should be shrunk on a given node.
+		 */
 		while (!populated_zone(zone->zone_pgdat->node_zones +
-							classzone_idx))
+							classzone_idx)) {
 			classzone_idx--;
+			continue;
+		}
 
 		/*
 		 * Take care memory controller reclaiming has small influence
@@ -2600,8 +2624,8 @@ static void shrink_zones(struct zonelist
 			 */
 			if (IS_ENABLED(CONFIG_COMPACTION) &&
 			    sc->order > PAGE_ALLOC_COSTLY_ORDER &&
-			    zonelist_zone_idx(z) <= requested_highidx &&
-			    compaction_ready(zone, sc->order, requested_highidx)) {
+			    zonelist_zone_idx(z) <= classzone_idx &&
+			    compaction_ready(zone, sc->order, classzone_idx)) {
 				sc->compaction_ready = true;
 				continue;
 			}
@@ -2621,7 +2645,7 @@ static void shrink_zones(struct zonelist
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		shrink_zone(zone, sc, zone_idx(zone) == classzone_idx);
+		shrink_node(zone->zone_pgdat, sc, classzone_idx);
 	}
 
 	/*
@@ -2653,6 +2677,7 @@ static unsigned long do_try_to_free_page
 	int initial_priority = sc->priority;
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
+	enum zone_type classzone_idx = sc->reclaim_idx;
 retry:
 	delayacct_freepages_start();
 
@@ -2663,7 +2688,7 @@ retry:
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		shrink_zones(zonelist, sc);
+		shrink_zones(zonelist, sc, classzone_idx);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2847,6 +2872,7 @@ unsigned long try_to_free_pages(struct z
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
+		.reclaim_idx = gfp_zone(gfp_mask),
 		.order = order,
 		.nodemask = nodemask,
 		.priority = DEF_PRIORITY,
@@ -3118,7 +3144,7 @@ static bool kswapd_shrink_zone(struct zo
 						balance_gap, classzone_idx))
 		return true;
 
-	shrink_zone(zone, sc, zone_idx(zone) == classzone_idx);
+	shrink_node(zone->zone_pgdat, sc, classzone_idx);
 
 	/* TODO: ANOMALY */
 	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
@@ -3167,6 +3193,7 @@ static int balance_pgdat(pg_data_t *pgda
 	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
+		.reclaim_idx = MAX_NR_ZONES - 1,
 		.order = order,
 		.priority = DEF_PRIORITY,
 		.may_writepage = !laptop_mode,
@@ -3237,15 +3264,14 @@ static int balance_pgdat(pg_data_t *pgda
 			sc.may_writepage = 1;
 
 		/*
-		 * Now scan the zone in the dma->highmem direction, stopping
-		 * at the last zone which needs scanning.
-		 *
-		 * We do this because the page allocator works in the opposite
-		 * direction.  This prevents the page allocator from allocating
-		 * pages behind kswapd's direction of progress, which would
-		 * cause too much scanning of the lower zones.
+		 * Continue scanning in the highmem->dma direction stopping at
+		 * the last zone which needs scanning. This may reclaim lowmem
+		 * pages that are not necessary for zone balancing but it
+		 * preserves LRU ordering. It is assumed that the bulk of
+		 * allocation requests can use arbitrary zones with the
+		 * possible exception of big highmem:lowmem configurations.
 		 */
-		for (i = 0; i <= end_zone; i++) {
+		for (i = end_zone; i >= 0; i--) {
 			struct zone *zone = pgdat->node_zones + i;
 
 			if (!populated_zone(zone))
@@ -3256,6 +3282,7 @@ static int balance_pgdat(pg_data_t *pgda
 				continue;
 
 			sc.nr_scanned = 0;
+			sc.reclaim_idx = i;
 
 			nr_soft_scanned = 0;
 			/*
@@ -3704,6 +3731,7 @@ static int __zone_reclaim(struct zone *z
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_UNMAP),
 		.may_swap = 1,
+		.reclaim_idx = zone_idx(zone),
 	};
 
 	cond_resched();
@@ -3723,7 +3751,7 @@ static int __zone_reclaim(struct zone *z
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-			shrink_zone(zone, &sc, true);
+			shrink_node(zone->zone_pgdat, &sc, zone_idx(zone));
 		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
 	}
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
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
mm-vmscan-update-classzone_idx-if-buffer_heads_over_limit.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch

