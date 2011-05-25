From: akpm@linux-foundation.org
Subject: [merged] vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:38 -0700
Message-ID: <201105252028.p4PKS2G4014640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053Ab1EYU26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     vmscan: change shrink_slab() interfaces by passing shrink_control
has been removed from the -mm tree.  Its filename was
     vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: change shrink_slab() interfaces by passing shrink_control
From: Ying Han <yinghan@google.com>

Consolidate the existing parameters to shrink_slab() into a new
shrink_control struct.  This is needed later to pass the same struct to
shrinkers.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c    |    6 ++++-
 include/linux/mm.h  |   13 ++++++++++-
 mm/memory-failure.c |    7 +++++-
 mm/vmscan.c         |   46 ++++++++++++++++++++++++++++++------------
 4 files changed, 55 insertions(+), 17 deletions(-)

diff -puN fs/drop_caches.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control fs/drop_caches.c
--- a/fs/drop_caches.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/fs/drop_caches.c
@@ -40,9 +40,13 @@ static void drop_pagecache_sb(struct sup
 static void drop_slab(void)
 {
 	int nr_objects;
+	struct shrink_control shrink = {
+		.gfp_mask = GFP_KERNEL,
+		.nr_scanned = 1000,
+	};
 
 	do {
-		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
+		nr_objects = shrink_slab(&shrink, 1000);
 	} while (nr_objects > 10);
 }
 
diff -puN include/linux/mm.h~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control include/linux/mm.h
--- a/include/linux/mm.h~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/include/linux/mm.h
@@ -1162,6 +1162,15 @@ static inline void sync_mm_rss(struct ta
 #endif
 
 /*
+ * This struct is used to pass information from page reclaim to the shrinkers.
+ * We consolidate the values for easier extention later.
+ */
+struct shrink_control {
+	unsigned long nr_scanned;
+	gfp_t gfp_mask;
+};
+
+/*
  * A callback you can register to apply pressure to ageable caches.
  *
  * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
@@ -1633,8 +1642,8 @@ int in_gate_area_no_mm(unsigned long add
 
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
-unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages);
+unsigned long shrink_slab(struct shrink_control *shrink,
+				unsigned long lru_pages);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff -puN mm/memory-failure.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control mm/memory-failure.c
--- a/mm/memory-failure.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/mm/memory-failure.c
@@ -239,7 +239,12 @@ void shake_page(struct page *p, int acce
 	if (access) {
 		int nr;
 		do {
-			nr = shrink_slab(1000, GFP_KERNEL, 1000);
+			struct shrink_control shrink = {
+				.gfp_mask = GFP_KERNEL,
+				.nr_scanned = 1000,
+			};
+
+			nr = shrink_slab(&shrink, 1000);
 			if (page_count(p) == 1)
 				break;
 		} while (nr > 10);
diff -puN mm/vmscan.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/mm/vmscan.c
@@ -222,11 +222,13 @@ EXPORT_SYMBOL(unregister_shrinker);
  *
  * Returns the number of slab objects which we shrunk.
  */
-unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages)
+unsigned long shrink_slab(struct shrink_control *shrink,
+			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long ret = 0;
+	unsigned long scanned = shrink->nr_scanned;
+	gfp_t gfp_mask = shrink->gfp_mask;
 
 	if (scanned == 0)
 		scanned = SWAP_CLUSTER_MAX;
@@ -2035,7 +2037,8 @@ static bool all_unreclaimable(struct zon
  * 		else, the number of pages reclaimed
  */
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
-					struct scan_control *sc)
+					struct scan_control *sc,
+					struct shrink_control *shrink)
 {
 	int priority;
 	unsigned long total_scanned = 0;
@@ -2069,7 +2072,8 @@ static unsigned long do_try_to_free_page
 				lru_pages += zone_reclaimable_pages(zone);
 			}
 
-			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
+			shrink->nr_scanned = sc->nr_scanned;
+			shrink_slab(shrink, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -2141,12 +2145,15 @@ unsigned long try_to_free_pages(struct z
 		.mem_cgroup = NULL,
 		.nodemask = nodemask,
 	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
 				sc.may_writepage,
 				gfp_mask);
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
 
@@ -2206,17 +2213,20 @@ unsigned long try_to_free_mem_cgroup_pag
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.nodemask = NULL, /* we don't care the placement */
+		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
+				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
 	};
 
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
 					    sc.gfp_mask);
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
@@ -2344,6 +2354,9 @@ static unsigned long balance_pgdat(pg_da
 		.order = order,
 		.mem_cgroup = NULL,
 	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
@@ -2443,8 +2456,8 @@ loop_again:
 					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
-			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
+			shrink.nr_scanned = sc.nr_scanned;
+			nr_slab = shrink_slab(&shrink, lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
@@ -2796,7 +2809,10 @@ unsigned long shrink_all_memory(unsigned
 		.swappiness = vm_swappiness,
 		.order = 0,
 	};
-	struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
+	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
 	unsigned long nr_reclaimed;
 
@@ -2805,7 +2821,7 @@ unsigned long shrink_all_memory(unsigned
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
@@ -2980,6 +2996,9 @@ static int __zone_reclaim(struct zone *z
 		.swappiness = vm_swappiness,
 		.order = order,
 	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
 	unsigned long nr_slab_pages0, nr_slab_pages1;
 
 	cond_resched();
@@ -3006,6 +3025,7 @@ static int __zone_reclaim(struct zone *z
 	}
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+	shrink.nr_scanned = sc.nr_scanned;
 	if (nr_slab_pages0 > zone->min_slab_pages) {
 		/*
 		 * shrink_slab() does not currently allow us to determine how
@@ -3021,7 +3041,7 @@ static int __zone_reclaim(struct zone *z
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
 			/* No reclaimable slab or very low memory pressure */
-			if (!shrink_slab(sc.nr_scanned, gfp_mask, lru_pages))
+			if (!shrink_slab(&shrink, lru_pages))
 				break;
 
 			/* Freed enough memory */
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch
add-the-pagefault-count-into-memcg-stats.patch

