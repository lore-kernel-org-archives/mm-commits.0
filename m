From: akpm@linux-foundation.org
Subject: [merged] memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:54 -0700
Message-ID: <201105271955.p4RJtxcf017499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab1E0UP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.c


The patch titled
     memcg: count the soft_limit reclaim in global background reclaim
has been removed from the -mm tree.  Its filename was
     memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: count the soft_limit reclaim in global background reclaim
From: Ying Han <yinghan@google.com>

The global kswapd scans per-zone LRU and reclaims pages regardless of the
cgroup. It breaks memory isolation since one cgroup can end up reclaiming
pages from another cgroup. Instead we should rely on memcg-aware target
reclaim including per-memcg kswapd and soft_limit hierarchical reclaim under
memory pressure.

In the global background reclaim, we do soft reclaim before scanning the
per-zone LRU. However, the return value is ignored. This patch is the first
step to skip shrink_zone() if soft_limit reclaim does enough work.

This is part of the effort which tries to reduce reclaiming pages in global
LRU in memcg. The per-memcg background reclaim patchset further enhances the
per-cgroup targetting reclaim, which I should have V4 posted shortly.

Try running multiple memory intensive workloads within seperate memcgs. Watch
the counters of soft_steal in memory.stat.

$ cat /dev/cgroup/A/memory.stat | grep 'soft'
soft_steal 240000
soft_scan 240000
total_soft_steal 240000
total_soft_scan 240000



This patch:

In the global background reclaim, we do soft reclaim before scanning the
per-zone LRU.  However, the return value is ignored.

We would like to skip shrink_zone() if soft_limit reclaim does enough
work.  Also, we need to make the memory pressure balanced across per-memcg
zones, like the logic vm-core.  This patch is the first step where we
start with counting the nr_scanned and nr_reclaimed from soft_limit
reclaim into the global scan_control.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 include/linux/swap.h       |    3 ++-
 mm/memcontrol.c            |   29 ++++++++++++++++++++---------
 mm/vmscan.c                |   16 +++++++++++++---
 4 files changed, 39 insertions(+), 15 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim
+++ a/include/linux/memcontrol.h
@@ -144,7 +144,8 @@ static inline void mem_cgroup_dec_page_s
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask);
+						gfp_t gfp_mask,
+						unsigned long *total_scanned);
 u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -338,7 +339,8 @@ static inline void mem_cgroup_dec_page_s
 
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask)
+					    gfp_t gfp_mask,
+					    unsigned long *total_scanned)
 {
 	return 0;
 }
diff -puN include/linux/swap.h~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim include/linux/swap.h
--- a/include/linux/swap.h~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim
+++ a/include/linux/swap.h
@@ -257,7 +257,8 @@ extern unsigned long try_to_free_mem_cgr
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						unsigned int swappiness,
-						struct zone *zone);
+						struct zone *zone,
+						unsigned long *nr_scanned);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/memcontrol.c~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim
+++ a/mm/memcontrol.c
@@ -1433,7 +1433,8 @@ mem_cgroup_select_victim(struct mem_cgro
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 						struct zone *zone,
 						gfp_t gfp_mask,
-						unsigned long reclaim_options)
+						unsigned long reclaim_options,
+						unsigned long *total_scanned)
 {
 	struct mem_cgroup *victim;
 	int ret, total = 0;
@@ -1442,6 +1443,7 @@ static int mem_cgroup_hierarchical_recla
 	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
 	unsigned long excess;
+	unsigned long nr_scanned;
 
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
@@ -1484,10 +1486,12 @@ static int mem_cgroup_hierarchical_recla
 			continue;
 		}
 		/* we use swappiness of local cgroup */
-		if (check_soft)
+		if (check_soft) {
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone);
-		else
+				noswap, get_swappiness(victim), zone,
+				&nr_scanned);
+			*total_scanned += nr_scanned;
+		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
 		css_put(&victim->css);
@@ -1928,7 +1932,7 @@ static int mem_cgroup_do_charge(struct m
 		return CHARGE_WOULDBLOCK;
 
 	ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
-					      gfp_mask, flags);
+					      gfp_mask, flags, NULL);
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		return CHARGE_RETRY;
 	/*
@@ -3211,7 +3215,8 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
-						MEM_CGROUP_RECLAIM_SHRINK);
+						MEM_CGROUP_RECLAIM_SHRINK,
+						NULL);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
   		if (curusage >= oldusage)
@@ -3271,7 +3276,8 @@ static int mem_cgroup_resize_memsw_limit
 
 		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
 						MEM_CGROUP_RECLAIM_NOSWAP |
-						MEM_CGROUP_RECLAIM_SHRINK);
+						MEM_CGROUP_RECLAIM_SHRINK,
+						NULL);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
@@ -3285,7 +3291,8 @@ static int mem_cgroup_resize_memsw_limit
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask)
+					    gfp_t gfp_mask,
+					    unsigned long *total_scanned)
 {
 	unsigned long nr_reclaimed = 0;
 	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
@@ -3293,6 +3300,7 @@ unsigned long mem_cgroup_soft_limit_recl
 	int loop = 0;
 	struct mem_cgroup_tree_per_zone *mctz;
 	unsigned long long excess;
+	unsigned long nr_scanned;
 
 	if (order > 0)
 		return 0;
@@ -3311,10 +3319,13 @@ unsigned long mem_cgroup_soft_limit_recl
 		if (!mz)
 			break;
 
+		nr_scanned = 0;
 		reclaimed = mem_cgroup_hierarchical_reclaim(mz->mem, zone,
 						gfp_mask,
-						MEM_CGROUP_RECLAIM_SOFT);
+						MEM_CGROUP_RECLAIM_SOFT,
+						&nr_scanned);
 		nr_reclaimed += reclaimed;
+		*total_scanned += nr_scanned;
 		spin_lock(&mctz->lock);
 
 		/*
diff -puN mm/vmscan.c~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-count-the-soft_limit-reclaim-in-global-background-reclaim
+++ a/mm/vmscan.c
@@ -2171,9 +2171,11 @@ unsigned long try_to_free_pages(struct z
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						unsigned int swappiness,
-						struct zone *zone)
+						struct zone *zone,
+						unsigned long *nr_scanned)
 {
 	struct scan_control sc = {
+		.nr_scanned = 0,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
@@ -2182,6 +2184,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.order = 0,
 		.mem_cgroup = mem,
 	};
+
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
@@ -2200,6 +2203,7 @@ unsigned long mem_cgroup_shrink_node_zon
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
+	*nr_scanned = sc.nr_scanned;
 	return sc.nr_reclaimed;
 }
 
@@ -2347,6 +2351,8 @@ static unsigned long balance_pgdat(pg_da
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
+	unsigned long nr_soft_reclaimed;
+	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
@@ -2439,11 +2445,15 @@ loop_again:
 
 			sc.nr_scanned = 0;
 
+			nr_soft_scanned = 0;
 			/*
 			 * Call soft limit reclaim before calling shrink_zone.
-			 * For now we ignore the return value
 			 */
-			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask);
+			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+							order, sc.gfp_mask,
+							&nr_soft_scanned);
+			sc.nr_reclaimed += nr_soft_reclaimed;
+			total_scanned += nr_soft_scanned;
 
 			/*
 			 * We put equal pressure on every zone, unless
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch

