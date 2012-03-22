From: akpm@linux-foundation.org
Subject: [merged] memcg-replace-mem-and-mem_cont-stragglers.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:30 -0700
Message-ID: <20120322201930.89871A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34424 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab2CVUTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:31 -0400
Received: by yhgm50 with SMTP id m50so403323yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace mem and mem_cont stragglers
has been removed from the -mm tree.  Its filename was
     memcg-replace-mem-and-mem_cont-stragglers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: replace mem and mem_cont stragglers

Replace mem and mem_cont stragglers in memcontrol.c by memcg.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   84 +++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff -puN mm/memcontrol.c~memcg-replace-mem-and-mem_cont-stragglers mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-replace-mem-and-mem_cont-stragglers
+++ a/mm/memcontrol.c
@@ -144,7 +144,7 @@ struct mem_cgroup_per_zone {
 	unsigned long long	usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
-	struct mem_cgroup	*mem;		/* Back pointer, we cannot */
+	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 };
 /* Macro for accessing counter */
@@ -612,9 +612,9 @@ retry:
 	 * we will to add it back at the end of reclaim to its correct
 	 * position in the tree.
 	 */
-	__mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
-	if (!res_counter_soft_limit_excess(&mz->mem->res) ||
-		!css_tryget(&mz->mem->css))
+	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
+		!css_tryget(&mz->memcg->css))
 		goto retry;
 done:
 	return mz;
@@ -1772,22 +1772,22 @@ static DEFINE_SPINLOCK(memcg_oom_lock);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
 struct oom_wait_info {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *memcg;
 	wait_queue_t	wait;
 };
 
 static int memcg_oom_wake_function(wait_queue_t *wait,
 	unsigned mode, int sync, void *arg)
 {
-	struct mem_cgroup *wake_memcg = (struct mem_cgroup *)arg,
-			  *oom_wait_memcg;
+	struct mem_cgroup *wake_memcg = (struct mem_cgroup *)arg;
+	struct mem_cgroup *oom_wait_memcg;
 	struct oom_wait_info *oom_wait_info;
 
 	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
-	oom_wait_memcg = oom_wait_info->mem;
+	oom_wait_memcg = oom_wait_info->memcg;
 
 	/*
-	 * Both of oom_wait_info->mem and wake_mem are stable under us.
+	 * Both of oom_wait_info->memcg and wake_memcg are stable under us.
 	 * Then we can use css_is_ancestor without taking care of RCU.
 	 */
 	if (!mem_cgroup_same_or_subtree(oom_wait_memcg, wake_memcg)
@@ -1816,7 +1816,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	struct oom_wait_info owait;
 	bool locked, need_to_kill;
 
-	owait.mem = memcg;
+	owait.memcg = memcg;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;
 	owait.wait.private = current;
@@ -3549,7 +3549,7 @@ unsigned long mem_cgroup_soft_limit_recl
 			break;
 
 		nr_scanned = 0;
-		reclaimed = mem_cgroup_soft_reclaim(mz->mem, zone,
+		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, zone,
 						    gfp_mask, &nr_scanned);
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
@@ -3576,13 +3576,13 @@ unsigned long mem_cgroup_soft_limit_recl
 				next_mz =
 				__mem_cgroup_largest_soft_limit_node(mctz);
 				if (next_mz == mz)
-					css_put(&next_mz->mem->css);
+					css_put(&next_mz->memcg->css);
 				else /* next_mz == NULL or other memcg */
 					break;
 			} while (1);
 		}
-		__mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
-		excess = res_counter_soft_limit_excess(&mz->mem->res);
+		__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+		excess = res_counter_soft_limit_excess(&mz->memcg->res);
 		/*
 		 * One school of thought says that we should not add
 		 * back the node to the tree if reclaim returns 0.
@@ -3592,9 +3592,9 @@ unsigned long mem_cgroup_soft_limit_recl
 		 * term TODO.
 		 */
 		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz->mem, mz, mctz, excess);
+		__mem_cgroup_insert_exceeded(mz->memcg, mz, mctz, excess);
 		spin_unlock(&mctz->lock);
-		css_put(&mz->mem->css);
+		css_put(&mz->memcg->css);
 		loop++;
 		/*
 		 * Could not reclaim anything and there are no more
@@ -3607,7 +3607,7 @@ unsigned long mem_cgroup_soft_limit_recl
 			break;
 	} while (!nr_reclaimed);
 	if (next_mz)
-		css_put(&next_mz->mem->css);
+		css_put(&next_mz->memcg->css);
 	return nr_reclaimed;
 }
 
@@ -4098,38 +4098,38 @@ static int mem_control_numa_stat_show(st
 	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
 	unsigned long node_nr;
 	struct cgroup *cont = m->private;
-	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
-	total_nr = mem_cgroup_nr_lru_pages(mem_cont, LRU_ALL);
+	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
 	seq_printf(m, "total=%lu", total_nr);
 	for_each_node_state(nid, N_HIGH_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(mem_cont, nid, LRU_ALL);
+		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
 
-	file_nr = mem_cgroup_nr_lru_pages(mem_cont, LRU_ALL_FILE);
+	file_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
 	seq_printf(m, "file=%lu", file_nr);
 	for_each_node_state(nid, N_HIGH_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(mem_cont, nid,
+		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_FILE);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
 
-	anon_nr = mem_cgroup_nr_lru_pages(mem_cont, LRU_ALL_ANON);
+	anon_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
 	seq_printf(m, "anon=%lu", anon_nr);
 	for_each_node_state(nid, N_HIGH_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(mem_cont, nid,
+		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				LRU_ALL_ANON);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
 
-	unevictable_nr = mem_cgroup_nr_lru_pages(mem_cont, BIT(LRU_UNEVICTABLE));
+	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
 	seq_printf(m, "unevictable=%lu", unevictable_nr);
 	for_each_node_state(nid, N_HIGH_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(mem_cont, nid,
+		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
 				BIT(LRU_UNEVICTABLE));
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
@@ -4141,12 +4141,12 @@ static int mem_control_numa_stat_show(st
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct cgroup_map_cb *cb)
 {
-	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	struct mcs_total_stat mystat;
 	int i;
 
 	memset(&mystat, 0, sizeof(mystat));
-	mem_cgroup_get_local_stat(mem_cont, &mystat);
+	mem_cgroup_get_local_stat(memcg, &mystat);
 
 
 	for (i = 0; i < NR_MCS_STAT; i++) {
@@ -4158,14 +4158,14 @@ static int mem_control_stat_show(struct 
 	/* Hierarchical information */
 	{
 		unsigned long long limit, memsw_limit;
-		memcg_get_hierarchical_limit(mem_cont, &limit, &memsw_limit);
+		memcg_get_hierarchical_limit(memcg, &limit, &memsw_limit);
 		cb->fill(cb, "hierarchical_memory_limit", limit);
 		if (do_swap_account)
 			cb->fill(cb, "hierarchical_memsw_limit", memsw_limit);
 	}
 
 	memset(&mystat, 0, sizeof(mystat));
-	mem_cgroup_get_total_stat(mem_cont, &mystat);
+	mem_cgroup_get_total_stat(memcg, &mystat);
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
 			continue;
@@ -4181,7 +4181,7 @@ static int mem_control_stat_show(struct 
 
 		for_each_online_node(nid)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
+				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
 
 				recent_rotated[0] +=
 					mz->reclaim_stat.recent_rotated[0];
@@ -4758,7 +4758,7 @@ static int alloc_mem_cgroup_per_zone_inf
 			INIT_LIST_HEAD(&mz->lruvec.lists[l]);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
-		mz->mem = memcg;
+		mz->memcg = memcg;
 	}
 	memcg->info.nodeinfo[node] = pn;
 	return 0;
@@ -4771,29 +4771,29 @@ static void free_mem_cgroup_per_zone_inf
 
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *memcg;
 	int size = sizeof(struct mem_cgroup);
 
 	/* Can be very big if MAX_NUMNODES is very big */
 	if (size < PAGE_SIZE)
-		mem = kzalloc(size, GFP_KERNEL);
+		memcg = kzalloc(size, GFP_KERNEL);
 	else
-		mem = vzalloc(size);
+		memcg = vzalloc(size);
 
-	if (!mem)
+	if (!memcg)
 		return NULL;
 
-	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
-	if (!mem->stat)
+	memcg->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
+	if (!memcg->stat)
 		goto out_free;
-	spin_lock_init(&mem->pcp_counter_lock);
-	return mem;
+	spin_lock_init(&memcg->pcp_counter_lock);
+	return memcg;
 
 out_free:
 	if (size < PAGE_SIZE)
-		kfree(mem);
+		kfree(memcg);
 	else
-		vfree(mem);
+		vfree(memcg);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

