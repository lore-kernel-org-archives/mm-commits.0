From: akpm@linux-foundation.org
Subject: + mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
 added to -mm tree
Date: Fri, 08 Jul 2016 13:33:37 -0700
Message-ID: <57800e21.FsID9xg0EVMU/GTb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbcGHUdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: make shrink_node decisions more node-centric
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-shrink_node-decisions-more-node-centric.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-shrink_node-decisions-more-node-centric.patch

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
Subject: mm, vmscan: make shrink_node decisions more node-centric

Earlier patches focused on having direct reclaim and kswapd use data that
is node-centric for reclaiming but shrink_node() itself still uses too
much zone information.  This patch removes unnecessary zone-based
information with the most important decision being whether to continue
reclaim or not.  Some memcg APIs are adjusted as a result even though
memcg itself still uses some zone information.

Link: http://lkml.kernel.org/r/1467970510-21195-14-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   19 +++++------
 include/linux/mmzone.h     |    4 +-
 include/linux/swap.h       |    2 -
 mm/memcontrol.c            |    4 +-
 mm/page_alloc.c            |    2 -
 mm/vmscan.c                |   59 +++++++++++++++++++----------------
 mm/workingset.c            |    6 +--
 7 files changed, 52 insertions(+), 44 deletions(-)

diff -puN include/linux/memcontrol.h~mm-vmscan-make-shrink_node-decisions-more-node-centric include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/include/linux/memcontrol.h
@@ -325,22 +325,23 @@ mem_cgroup_zone_zoneinfo(struct mem_cgro
 }
 
 /**
- * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
+ * mem_cgroup_lruvec - get the lru list vector for a node or a memcg zone
+ * @node: node of the wanted lruvec
  * @zone: zone of the wanted lruvec
  * @memcg: memcg of the wanted lruvec
  *
- * Returns the lru list vector holding pages for the given @zone and
- * @mem.  This can be the global zone lruvec, if the memory controller
+ * Returns the lru list vector holding pages for a given @node or a given
+ * @memcg and @zone. This can be the node lruvec, if the memory controller
  * is disabled.
  */
-static inline struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
-						    struct mem_cgroup *memcg)
+static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
+				struct zone *zone, struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_per_zone *mz;
 	struct lruvec *lruvec;
 
 	if (mem_cgroup_disabled()) {
-		lruvec = zone_lruvec(zone);
+		lruvec = node_lruvec(pgdat);
 		goto out;
 	}
 
@@ -610,10 +611,10 @@ static inline void mem_cgroup_migrate(st
 {
 }
 
-static inline struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
-						    struct mem_cgroup *memcg)
+static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
+				struct zone *zone, struct mem_cgroup *memcg)
 {
-	return zone_lruvec(zone);
+	return node_lruvec(pgdat);
 }
 
 static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
diff -puN include/linux/mmzone.h~mm-vmscan-make-shrink_node-decisions-more-node-centric include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/include/linux/mmzone.h
@@ -739,9 +739,9 @@ static inline spinlock_t *zone_lru_lock(
 	return &zone->zone_pgdat->lru_lock;
 }
 
-static inline struct lruvec *zone_lruvec(struct zone *zone)
+static inline struct lruvec *node_lruvec(struct pglist_data *pgdat)
 {
-	return &zone->zone_pgdat->lruvec;
+	return &pgdat->lruvec;
 }
 
 static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
diff -puN include/linux/swap.h~mm-vmscan-make-shrink_node-decisions-more-node-centric include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/include/linux/swap.h
@@ -316,7 +316,7 @@ extern unsigned long try_to_free_mem_cgr
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
 						  bool may_swap);
-extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
+extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						struct zone *zone,
 						unsigned long *nr_scanned);
diff -puN mm/memcontrol.c~mm-vmscan-make-shrink_node-decisions-more-node-centric mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/mm/memcontrol.c
@@ -1432,8 +1432,8 @@ static int mem_cgroup_soft_reclaim(struc
 			}
 			continue;
 		}
-		total += mem_cgroup_shrink_node_zone(victim, gfp_mask, false,
-						     zone, &nr_scanned);
+		total += mem_cgroup_shrink_node(victim, gfp_mask, false,
+					zone, &nr_scanned);
 		*total_scanned += nr_scanned;
 		if (!soft_limit_excess(root_memcg))
 			break;
diff -puN mm/page_alloc.c~mm-vmscan-make-shrink_node-decisions-more-node-centric mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/mm/page_alloc.c
@@ -5911,6 +5911,7 @@ static void __paginginit free_area_init_
 #endif
 	pgdat_page_ext_init(pgdat);
 	spin_lock_init(&pgdat->lru_lock);
+	lruvec_init(node_lruvec(pgdat));
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
@@ -5973,7 +5974,6 @@ static void __paginginit free_area_init_
 		/* For bootup, initialized properly in watermark setup */
 		mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);
 
-		lruvec_init(zone_lruvec(zone));
 		if (!size)
 			continue;
 
diff -puN mm/vmscan.c~mm-vmscan-make-shrink_node-decisions-more-node-centric mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/mm/vmscan.c
@@ -2224,12 +2224,13 @@ static inline void init_tlb_ubc(void)
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 
 /*
- * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
+ * This is a basic per-node page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_zone_memcg(struct zone *zone, struct mem_cgroup *memcg,
+static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memcg,
 			      struct scan_control *sc, unsigned long *lru_pages)
 {
-	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	struct zone *zone = &pgdat->node_zones[sc->reclaim_idx];
+	struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, zone, memcg);
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long targets[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
@@ -2362,13 +2363,14 @@ static bool in_reclaim_compaction(struct
  * calls try_to_compact_zone() that it will have enough free pages to succeed.
  * It will give up earlier than that if there is difficulty reclaiming pages.
  */
-static inline bool should_continue_reclaim(struct zone *zone,
+static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 					unsigned long nr_reclaimed,
 					unsigned long nr_scanned,
 					struct scan_control *sc)
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
+	int z;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -2402,21 +2404,27 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = node_page_state(zone->zone_pgdat, NR_INACTIVE_FILE);
+	inactive_lru_pages = node_page_state(pgdat, NR_INACTIVE_FILE);
 	if (get_nr_swap_pages() > 0)
-		inactive_lru_pages += node_page_state(zone->zone_pgdat, NR_INACTIVE_ANON);
+		inactive_lru_pages += node_page_state(pgdat, NR_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
 
 	/* If compaction would go ahead or the allocation would succeed, stop */
-	switch (compaction_suitable(zone, sc->order, 0, 0)) {
-	case COMPACT_PARTIAL:
-	case COMPACT_CONTINUE:
-		return false;
-	default:
-		return true;
+	for (z = 0; z <= sc->reclaim_idx; z++) {
+		struct zone *zone = &pgdat->node_zones[z];
+
+		switch (compaction_suitable(zone, sc->order, 0, sc->reclaim_idx)) {
+		case COMPACT_PARTIAL:
+		case COMPACT_CONTINUE:
+			return false;
+		default:
+			/* check next zone */
+			;
+		}
 	}
+	return true;
 }
 
 static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc,
@@ -2425,15 +2433,14 @@ static bool shrink_node(pg_data_t *pgdat
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
-	struct zone *zone = &pgdat->node_zones[classzone_idx];
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
 		struct mem_cgroup_reclaim_cookie reclaim = {
-			.zone = zone,
+			.zone = &pgdat->node_zones[classzone_idx],
 			.priority = sc->priority,
 		};
-		unsigned long zone_lru_pages = 0;
+		unsigned long node_lru_pages = 0;
 		struct mem_cgroup *memcg;
 
 		nr_reclaimed = sc->nr_reclaimed;
@@ -2454,11 +2461,11 @@ static bool shrink_node(pg_data_t *pgdat
 			reclaimed = sc->nr_reclaimed;
 			scanned = sc->nr_scanned;
 
-			shrink_zone_memcg(zone, memcg, sc, &lru_pages);
-			zone_lru_pages += lru_pages;
+			shrink_node_memcg(pgdat, memcg, sc, &lru_pages);
+			node_lru_pages += lru_pages;
 
 			if (!global_reclaim(sc))
-				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
+				shrink_slab(sc->gfp_mask, pgdat->node_id,
 					    memcg, sc->nr_scanned - scanned,
 					    lru_pages);
 
@@ -2470,7 +2477,7 @@ static bool shrink_node(pg_data_t *pgdat
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
 			 * cgroups to fulfill the overall scan target for the
-			 * zone.
+			 * node.
 			 *
 			 * Limit reclaim, on the other hand, only cares about
 			 * nr_to_reclaim pages to be reclaimed and it will
@@ -2489,9 +2496,9 @@ static bool shrink_node(pg_data_t *pgdat
 		 * the eligible LRU pages were scanned.
 		 */
 		if (global_reclaim(sc))
-			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
+			shrink_slab(sc->gfp_mask, pgdat->node_id, NULL,
 				    sc->nr_scanned - nr_scanned,
-				    zone_lru_pages);
+				    node_lru_pages);
 
 		if (reclaim_state) {
 			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -2506,7 +2513,7 @@ static bool shrink_node(pg_data_t *pgdat
 		if (sc->nr_reclaimed - nr_reclaimed)
 			reclaimable = true;
 
-	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
+	} while (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
 
 	return reclaimable;
@@ -2906,7 +2913,7 @@ unsigned long try_to_free_pages(struct z
 
 #ifdef CONFIG_MEMCG
 
-unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
+unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 						gfp_t gfp_mask, bool noswap,
 						struct zone *zone,
 						unsigned long *nr_scanned)
@@ -2931,11 +2938,11 @@ unsigned long mem_cgroup_shrink_node_zon
 	/*
 	 * NOTE: Although we can get the priority field, using it
 	 * here is not a good idea, since it limits the pages we can scan.
-	 * if we don't reclaim here, the shrink_zone from balance_pgdat
+	 * if we don't reclaim here, the shrink_node from balance_pgdat
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_zone_memcg(zone, memcg, &sc, &lru_pages);
+	shrink_node_memcg(zone->zone_pgdat, memcg, &sc, &lru_pages);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
@@ -2994,7 +3001,7 @@ static void age_active_anon(struct pglis
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+		struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, zone, memcg);
 
 		if (inactive_list_is_low(lruvec, false))
 			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
diff -puN mm/workingset.c~mm-vmscan-make-shrink_node-decisions-more-node-centric mm/workingset.c
--- a/mm/workingset.c~mm-vmscan-make-shrink_node-decisions-more-node-centric
+++ a/mm/workingset.c
@@ -218,7 +218,7 @@ void *workingset_eviction(struct address
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, zone, memcg);
 	eviction = atomic_long_inc_return(&lruvec->inactive_age);
 	return pack_shadow(memcgid, zone, eviction);
 }
@@ -267,7 +267,7 @@ bool workingset_refault(void *shadow)
 		rcu_read_unlock();
 		return false;
 	}
-	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, zone, memcg);
 	refault = atomic_long_read(&lruvec->inactive_age);
 	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE);
 	rcu_read_unlock();
@@ -319,7 +319,7 @@ void workingset_activation(struct page *
 	memcg = page_memcg_rcu(page);
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec = mem_cgroup_zone_lruvec(page_zone(page), memcg);
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), page_zone(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
 out:
 	rcu_read_unlock();
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

