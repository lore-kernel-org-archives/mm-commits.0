From: akpm@linux-foundation.org
Subject: [merged] memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:01 -0700
Message-ID: <201107271926.p6RJQlIw003145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571Ab1G0T1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, bsingharora@gmail.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, shaohua.li@intel.com, yinghan@google.com, mm-commit


The patch titled
     memcg: export memory cgroup's swappiness with mem_cgroup_swappiness()
has been removed from the -mm tree.  Its filename was
     memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: export memory cgroup's swappiness with mem_cgroup_swappiness()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Each memory cgroup has a 'swappiness' value which can be accessed by
get_swappiness(memcg).  The major user is try_to_free_mem_cgroup_pages()
and swappiness is passed by argument.  It's propagated by scan_control.

get_swappiness() is a static function but some planned updates will need
to get swappiness from files other than memcontrol.c This patch exports
get_swappiness() as mem_cgroup_swappiness().  With this, we can remove the
argument of swapiness from try_to_free...  and drop swappiness from
scan_control.  only memcg uses it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   13 +++++++++----
 mm/memcontrol.c      |   15 +++++++--------
 mm/vmscan.c          |   23 ++++++++++-------------
 3 files changed, 26 insertions(+), 25 deletions(-)

diff -puN include/linux/swap.h~memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness include/linux/swap.h
--- a/include/linux/swap.h~memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness
+++ a/include/linux/swap.h
@@ -252,11 +252,9 @@ static inline void lru_cache_add_file(st
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
-						  gfp_t gfp_mask, bool noswap,
-						  unsigned int swappiness);
+						  gfp_t gfp_mask, bool noswap);
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
 						struct zone *zone,
 						unsigned long *nr_scanned);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
@@ -299,7 +297,14 @@ static inline void scan_unevictable_unre
 
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
-
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+extern int mem_cgroup_swappiness(struct mem_cgroup *mem);
+#else
+static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+{
+	return vm_swappiness;
+}
+#endif
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
diff -puN mm/memcontrol.c~memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness
+++ a/mm/memcontrol.c
@@ -249,7 +249,7 @@ struct mem_cgroup {
 	atomic_t	oom_lock;
 	atomic_t	refcnt;
 
-	unsigned int	swappiness;
+	int	swappiness;
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
@@ -1329,7 +1329,7 @@ static unsigned long mem_cgroup_margin(s
 	return margin >> PAGE_SHIFT;
 }
 
-static unsigned int get_swappiness(struct mem_cgroup *memcg)
+int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 
@@ -1776,12 +1776,11 @@ static int mem_cgroup_hierarchical_recla
 		/* we use swappiness of local cgroup */
 		if (check_soft) {
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone,
-				&nr_scanned);
+				noswap, zone, &nr_scanned);
 			*total_scanned += nr_scanned;
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
-						noswap, get_swappiness(victim));
+						noswap);
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -3826,7 +3825,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
-						false, get_swappiness(mem));
+						false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -4288,7 +4287,7 @@ static u64 mem_cgroup_swappiness_read(st
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 
-	return get_swappiness(memcg);
+	return mem_cgroup_swappiness(memcg);
 }
 
 static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
@@ -4997,7 +4996,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
-		mem->swappiness = get_swappiness(parent);
+		mem->swappiness = mem_cgroup_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
diff -puN mm/vmscan.c~memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness mm/vmscan.c
--- a/mm/vmscan.c~memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness
+++ a/mm/vmscan.c
@@ -95,8 +95,6 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	int may_swap;
 
-	int swappiness;
-
 	int order;
 
 	/*
@@ -1770,6 +1768,13 @@ static unsigned long shrink_list(enum lr
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
+static int vmscan_swappiness(struct scan_control *sc)
+{
+	if (scanning_global_lru(sc))
+		return vm_swappiness;
+	return mem_cgroup_swappiness(sc->mem_cgroup);
+}
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
@@ -1830,8 +1835,8 @@ static void get_scan_count(struct zone *
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = sc->swappiness;
-	file_prio = 200 - sc->swappiness;
+	anon_prio = vmscan_swappiness(sc);
+	file_prio = 200 - vmscan_swappiness(sc);
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache
@@ -2220,7 +2225,6 @@ unsigned long try_to_free_pages(struct z
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
 		.nodemask = nodemask,
@@ -2244,7 +2248,6 @@ unsigned long try_to_free_pages(struct z
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
 						struct zone *zone,
 						unsigned long *nr_scanned)
 {
@@ -2254,7 +2257,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
 	};
@@ -2283,8 +2285,7 @@ unsigned long mem_cgroup_shrink_node_zon
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 					   gfp_t gfp_mask,
-					   bool noswap,
-					   unsigned int swappiness)
+					   bool noswap)
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
@@ -2294,7 +2295,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.nodemask = NULL, /* we don't care the placement */
@@ -2445,7 +2445,6 @@ static unsigned long balance_pgdat(pg_da
 		 * we want to put equal scanning pressure on each zone.
 		 */
 		.nr_to_reclaim = ULONG_MAX,
-		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
 	};
@@ -2915,7 +2914,6 @@ unsigned long shrink_all_memory(unsigned
 		.may_writepage = 1,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
-		.swappiness = vm_swappiness,
 		.order = 0,
 	};
 	struct shrink_control shrink = {
@@ -3102,7 +3100,6 @@ static int __zone_reclaim(struct zone *z
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
-		.swappiness = vm_swappiness,
 		.order = order,
 	};
 	struct shrink_control shrink = {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-mempolicyc-make-copy_from_user-provably-correct.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

