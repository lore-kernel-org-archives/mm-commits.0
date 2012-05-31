From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-store-priority-in-struct-scan_control.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:15 -0700
Message-ID: <20120531191715.5F9EBA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34772 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932979Ab2EaTRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:17:17 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75709lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: store "priority" in struct scan_control
has been removed from the -mm tree.  Its filename was
     mm-vmscan-store-priority-in-struct-scan_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: store "priority" in struct scan_control

In memory reclaim some function have too many arguments - "priority" is
one of them.  It can be stored in struct scan_control - we construct them
on the same level.  Instead of an open coded loop we set the initial
sc.priority, and do_try_to_free_pages() decreases it down to zero.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  117 ++++++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 56 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-store-priority-in-struct-scan_control mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-store-priority-in-struct-scan_control
+++ a/mm/vmscan.c
@@ -78,6 +78,9 @@ struct scan_control {
 
 	int order;
 
+	/* Scan (total_size >> priority) pages at once */
+	int priority;
+
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
 	 * primary target of this reclaim invocation.
@@ -687,7 +690,6 @@ static enum page_references page_check_r
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct mem_cgroup_zone *mz,
 				      struct scan_control *sc,
-				      int priority,
 				      unsigned long *ret_nr_dirty,
 				      unsigned long *ret_nr_writeback)
 {
@@ -790,7 +792,8 @@ static unsigned long shrink_page_list(st
 			 * unless under significant pressure.
 			 */
 			if (page_is_file_cache(page) &&
-					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
+					(!current_is_kswapd() ||
+					 sc->priority >= DEF_PRIORITY - 2)) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principal to deactivate_page()
@@ -1257,7 +1260,7 @@ update_isolated_counts(struct mem_cgroup
  */
 static noinline_for_stack unsigned long
 shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone *mz,
-		     struct scan_control *sc, int priority, enum lru_list lru)
+		     struct scan_control *sc, enum lru_list lru)
 {
 	LIST_HEAD(page_list);
 	unsigned long nr_scanned;
@@ -1307,7 +1310,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
 
-	nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
+	nr_reclaimed = shrink_page_list(&page_list, mz, sc,
 						&nr_dirty, &nr_writeback);
 
 	spin_lock_irq(&zone->lru_lock);
@@ -1356,13 +1359,14 @@ shrink_inactive_list(unsigned long nr_to
 	 * DEF_PRIORITY-6 For SWAP_CLUSTER_MAX isolated pages, throttle if any
 	 *                     isolated page is PageWriteback
 	 */
-	if (nr_writeback && nr_writeback >= (nr_taken >> (DEF_PRIORITY-priority)))
+	if (nr_writeback && nr_writeback >=
+			(nr_taken >> (DEF_PRIORITY - sc->priority)))
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
 
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
-		priority,
+		sc->priority,
 		trace_shrink_flags(file));
 	return nr_reclaimed;
 }
@@ -1426,7 +1430,7 @@ static void move_active_pages_to_lru(str
 static void shrink_active_list(unsigned long nr_to_scan,
 			       struct mem_cgroup_zone *mz,
 			       struct scan_control *sc,
-			       int priority, enum lru_list lru)
+			       enum lru_list lru)
 {
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
@@ -1609,17 +1613,17 @@ static int inactive_list_is_low(struct m
 
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 				 struct mem_cgroup_zone *mz,
-				 struct scan_control *sc, int priority)
+				 struct scan_control *sc)
 {
 	int file = is_file_lru(lru);
 
 	if (is_active_lru(lru)) {
 		if (inactive_list_is_low(mz, file))
-			shrink_active_list(nr_to_scan, mz, sc, priority, lru);
+			shrink_active_list(nr_to_scan, mz, sc, lru);
 		return 0;
 	}
 
-	return shrink_inactive_list(nr_to_scan, mz, sc, priority, lru);
+	return shrink_inactive_list(nr_to_scan, mz, sc, lru);
 }
 
 static int vmscan_swappiness(struct scan_control *sc)
@@ -1638,7 +1642,7 @@ static int vmscan_swappiness(struct scan
  * nr[0] = anon pages to scan; nr[1] = file pages to scan
  */
 static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
-			   unsigned long *nr, int priority)
+			   unsigned long *nr)
 {
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
@@ -1740,8 +1744,8 @@ out:
 		unsigned long scan;
 
 		scan = zone_nr_lru_pages(mz, lru);
-		if (priority || noswap || !vmscan_swappiness(sc)) {
-			scan >>= priority;
+		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
+			scan >>= sc->priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
 			scan = div64_u64(scan * fraction[file], denominator);
@@ -1751,11 +1755,11 @@ out:
 }
 
 /* Use reclaim/compaction for costly allocs or under memory pressure */
-static bool in_reclaim_compaction(int priority, struct scan_control *sc)
+static bool in_reclaim_compaction(struct scan_control *sc)
 {
 	if (COMPACTION_BUILD && sc->order &&
 			(sc->order > PAGE_ALLOC_COSTLY_ORDER ||
-			 priority < DEF_PRIORITY - 2))
+			 sc->priority < DEF_PRIORITY - 2))
 		return true;
 
 	return false;
@@ -1771,14 +1775,13 @@ static bool in_reclaim_compaction(int pr
 static inline bool should_continue_reclaim(struct mem_cgroup_zone *mz,
 					unsigned long nr_reclaimed,
 					unsigned long nr_scanned,
-					int priority,
 					struct scan_control *sc)
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
 
 	/* If not in reclaim/compaction mode, stop */
-	if (!in_reclaim_compaction(priority, sc))
+	if (!in_reclaim_compaction(sc))
 		return false;
 
 	/* Consider stopping depending on scan and reclaim activity */
@@ -1829,7 +1832,7 @@ static inline bool should_continue_recla
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_mem_cgroup_zone(int priority, struct mem_cgroup_zone *mz,
+static void shrink_mem_cgroup_zone(struct mem_cgroup_zone *mz,
 				   struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
@@ -1842,7 +1845,7 @@ static void shrink_mem_cgroup_zone(int p
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
-	get_scan_count(mz, sc, nr, priority);
+	get_scan_count(mz, sc, nr);
 
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
@@ -1854,7 +1857,7 @@ restart:
 				nr[lru] -= nr_to_scan;
 
 				nr_reclaimed += shrink_list(lru, nr_to_scan,
-							    mz, sc, priority);
+							    mz, sc);
 			}
 		}
 		/*
@@ -1865,7 +1868,8 @@ restart:
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
+		if (nr_reclaimed >= nr_to_reclaim &&
+		    sc->priority < DEF_PRIORITY)
 			break;
 	}
 	blk_finish_plug(&plug);
@@ -1877,24 +1881,22 @@ restart:
 	 */
 	if (inactive_anon_is_low(mz))
 		shrink_active_list(SWAP_CLUSTER_MAX, mz,
-				   sc, priority, LRU_ACTIVE_ANON);
+				   sc, LRU_ACTIVE_ANON);
 
 	/* reclaim/compaction might need reclaim to continue */
 	if (should_continue_reclaim(mz, nr_reclaimed,
-					sc->nr_scanned - nr_scanned,
-					priority, sc))
+				    sc->nr_scanned - nr_scanned, sc))
 		goto restart;
 
 	throttle_vm_writeout(sc->gfp_mask);
 }
 
-static void shrink_zone(int priority, struct zone *zone,
-			struct scan_control *sc)
+static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	struct mem_cgroup *root = sc->target_mem_cgroup;
 	struct mem_cgroup_reclaim_cookie reclaim = {
 		.zone = zone,
-		.priority = priority,
+		.priority = sc->priority,
 	};
 	struct mem_cgroup *memcg;
 
@@ -1905,7 +1907,7 @@ static void shrink_zone(int priority, st
 			.zone = zone,
 		};
 
-		shrink_mem_cgroup_zone(priority, &mz, sc);
+		shrink_mem_cgroup_zone(&mz, sc);
 		/*
 		 * Limit reclaim has historically picked one memcg and
 		 * scanned it with decreasing priority levels until
@@ -1981,8 +1983,7 @@ static inline bool compaction_ready(stru
  * the caller that it should consider retrying the allocation instead of
  * further reclaim.
  */
-static bool shrink_zones(int priority, struct zonelist *zonelist,
-					struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2009,7 +2010,8 @@ static bool shrink_zones(int priority, s
 		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
-			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable &&
+					sc->priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
 			if (COMPACTION_BUILD) {
 				/*
@@ -2041,7 +2043,7 @@ static bool shrink_zones(int priority, s
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		shrink_zone(priority, zone, sc);
+		shrink_zone(zone, sc);
 	}
 
 	return aborted_reclaim;
@@ -2092,7 +2094,6 @@ static unsigned long do_try_to_free_page
 					struct scan_control *sc,
 					struct shrink_control *shrink)
 {
-	int priority;
 	unsigned long total_scanned = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct zoneref *z;
@@ -2105,9 +2106,9 @@ static unsigned long do_try_to_free_page
 	if (global_reclaim(sc))
 		count_vm_event(ALLOCSTALL);
 
-	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+	do {
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(priority, zonelist, sc);
+		aborted_reclaim = shrink_zones(zonelist, sc);
 
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2149,7 +2150,7 @@ static unsigned long do_try_to_free_page
 
 		/* Take a nap, wait for some writeback to complete */
 		if (!sc->hibernation_mode && sc->nr_scanned &&
-		    priority < DEF_PRIORITY - 2) {
+		    sc->priority < DEF_PRIORITY - 2) {
 			struct zone *preferred_zone;
 
 			first_zones_zonelist(zonelist, gfp_zone(sc->gfp_mask),
@@ -2157,7 +2158,7 @@ static unsigned long do_try_to_free_page
 						&preferred_zone);
 			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/10);
 		}
-	}
+	} while (--sc->priority >= 0);
 
 out:
 	delayacct_freepages_end();
@@ -2195,6 +2196,7 @@ unsigned long try_to_free_pages(struct z
 		.may_unmap = 1,
 		.may_swap = 1,
 		.order = order,
+		.priority = DEF_PRIORITY,
 		.target_mem_cgroup = NULL,
 		.nodemask = nodemask,
 	};
@@ -2227,6 +2229,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.order = 0,
+		.priority = 0,
 		.target_mem_cgroup = memcg,
 	};
 	struct mem_cgroup_zone mz = {
@@ -2237,7 +2240,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(0,
+	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
 						      sc.may_writepage,
 						      sc.gfp_mask);
 
@@ -2248,7 +2251,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_mem_cgroup_zone(0, &mz, &sc);
+	shrink_mem_cgroup_zone(&mz, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
@@ -2269,6 +2272,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.order = 0,
+		.priority = DEF_PRIORITY,
 		.target_mem_cgroup = memcg,
 		.nodemask = NULL, /* we don't care the placement */
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
@@ -2299,8 +2303,7 @@ unsigned long try_to_free_mem_cgroup_pag
 }
 #endif
 
-static void age_active_anon(struct zone *zone, struct scan_control *sc,
-			    int priority)
+static void age_active_anon(struct zone *zone, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
 
@@ -2316,7 +2319,7 @@ static void age_active_anon(struct zone 
 
 		if (inactive_anon_is_low(&mz))
 			shrink_active_list(SWAP_CLUSTER_MAX, &mz,
-					   sc, priority, LRU_ACTIVE_ANON);
+					   sc, LRU_ACTIVE_ANON);
 
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 	} while (memcg);
@@ -2425,7 +2428,6 @@ static unsigned long balance_pgdat(pg_da
 {
 	int all_zones_ok;
 	unsigned long balanced;
-	int priority;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 	unsigned long total_scanned;
@@ -2449,11 +2451,12 @@ static unsigned long balance_pgdat(pg_da
 	};
 loop_again:
 	total_scanned = 0;
+	sc.priority = DEF_PRIORITY;
 	sc.nr_reclaimed = 0;
 	sc.may_writepage = !laptop_mode;
 	count_vm_event(PAGEOUTRUN);
 
-	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+	do {
 		unsigned long lru_pages = 0;
 		int has_under_min_watermark_zone = 0;
 
@@ -2470,14 +2473,15 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable &&
+			    sc.priority != DEF_PRIORITY)
 				continue;
 
 			/*
 			 * Do some background aging of the anon list, to give
 			 * pages a chance to be referenced before reclaiming.
 			 */
-			age_active_anon(zone, &sc, priority);
+			age_active_anon(zone, &sc);
 
 			/*
 			 * If the number of buffer_heads in the machine
@@ -2525,7 +2529,8 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable &&
+			    sc.priority != DEF_PRIORITY)
 				continue;
 
 			sc.nr_scanned = 0;
@@ -2569,7 +2574,7 @@ loop_again:
 				    !zone_watermark_ok_safe(zone, testorder,
 					high_wmark_pages(zone) + balance_gap,
 					end_zone, 0)) {
-				shrink_zone(priority, zone, &sc);
+				shrink_zone(zone, &sc);
 
 				reclaim_state->reclaimed_slab = 0;
 				nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
@@ -2626,7 +2631,7 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && (priority < DEF_PRIORITY - 2)) {
+		if (total_scanned && (sc.priority < DEF_PRIORITY - 2)) {
 			if (has_under_min_watermark_zone)
 				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
 			else
@@ -2641,7 +2646,7 @@ loop_again:
 		 */
 		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
-	}
+	} while (--sc.priority >= 0);
 out:
 
 	/*
@@ -2691,7 +2696,8 @@ out:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable &&
+			    sc.priority != DEF_PRIORITY)
 				continue;
 
 			/* Would compaction fail due to lack of free memory? */
@@ -2958,6 +2964,7 @@ unsigned long shrink_all_memory(unsigned
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
 		.order = 0,
+		.priority = DEF_PRIORITY,
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
@@ -3135,7 +3142,6 @@ static int __zone_reclaim(struct zone *z
 	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
-	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
@@ -3144,6 +3150,7 @@ static int __zone_reclaim(struct zone *z
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.priority = ZONE_RECLAIM_PRIORITY,
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
@@ -3166,11 +3173,9 @@ static int __zone_reclaim(struct zone *z
 		 * Free memory by calling shrink zone with increasing
 		 * priorities until we have enough memory freed.
 		 */
-		priority = ZONE_RECLAIM_PRIORITY;
 		do {
-			shrink_zone(priority, zone, &sc);
-			priority--;
-		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
+			shrink_zone(zone, &sc);
+		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
 	}
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

