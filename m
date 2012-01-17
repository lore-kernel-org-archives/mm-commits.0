From: akpm@linux-foundation.org
Subject: + memcg-replace-mem-and-mem_cont-stragglers.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:32:18 -0800
Message-ID: <20120117223219.42BC910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:53398 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2AQWi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:38:56 -0500
Received: by ghbg20 with SMTP id g20so364615ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:38:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: replace mem and mem_cont stragglers
has been added to the -mm tree.  Its filename is
     memcg-replace-mem-and-mem_cont-stragglers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -592,9 +592,9 @@ retry:
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
@@ -1738,22 +1738,22 @@ static DEFINE_SPINLOCK(memcg_oom_lock);
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
@@ -1782,7 +1782,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	struct oom_wait_info owait;
 	bool locked, need_to_kill;
 
-	owait.mem = memcg;
+	owait.memcg = memcg;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;
 	owait.wait.private = current;
@@ -3530,7 +3530,7 @@ unsigned long mem_cgroup_soft_limit_recl
 			break;
 
 		nr_scanned = 0;
-		reclaimed = mem_cgroup_soft_reclaim(mz->mem, zone,
+		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, zone,
 						    gfp_mask, &nr_scanned);
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
@@ -3557,13 +3557,13 @@ unsigned long mem_cgroup_soft_limit_recl
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
@@ -3573,9 +3573,9 @@ unsigned long mem_cgroup_soft_limit_recl
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
@@ -3588,7 +3588,7 @@ unsigned long mem_cgroup_soft_limit_recl
 			break;
 	} while (!nr_reclaimed);
 	if (next_mz)
-		css_put(&next_mz->mem->css);
+		css_put(&next_mz->memcg->css);
 	return nr_reclaimed;
 }
 
@@ -4079,38 +4079,38 @@ static int mem_control_numa_stat_show(st
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
@@ -4122,12 +4122,12 @@ static int mem_control_numa_stat_show(st
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
@@ -4139,14 +4139,14 @@ static int mem_control_stat_show(struct 
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
@@ -4162,7 +4162,7 @@ static int mem_control_stat_show(struct 
 
 		for_each_online_node(nid)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
+				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
 
 				recent_rotated[0] +=
 					mz->reclaim_stat.recent_rotated[0];
@@ -4738,7 +4738,7 @@ static int alloc_mem_cgroup_per_zone_inf
 			INIT_LIST_HEAD(&mz->lruvec.lists[l]);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
-		mz->mem = memcg;
+		mz->memcg = memcg;
 	}
 	memcg->info.nodeinfo[node] = pn;
 	return 0;
@@ -4751,29 +4751,29 @@ static void free_mem_cgroup_per_zone_inf
 
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
Subject: Subject: memcg: replace mem and mem_cont stragglers

Patches currently in -mm which might be from hughd@google.com are

origin.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
prio_tree-debugging-patch.patch

