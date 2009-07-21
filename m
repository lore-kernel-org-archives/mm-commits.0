From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-organize-cgroups-v9.patch added to -mm tree
Date: Tue, 21 Jul 2009 14:14:26 -0700
Message-ID: <200907212114.n6LLERv2025053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbZGUVOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 17:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memory controller: soft limit organize cgroups
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-organize-cgroups-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory controller: soft limit organize cgroups
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Organize cgroups over soft limit in a RB-Tree

Introduce an RB-Tree for storing memory cgroups that are over their soft
limit.  The overall goal is to

1. Add a memory cgroup to the RB-Tree when the soft limit is exceeded.
   We are careful about updates, updates take place only after a particular
   time interval has passed
2. We remove the node from the RB-Tree when the usage goes below the soft
   limit

The next set of patches will exploit the RB-Tree to get the group that is
over its soft limit by the largest amount and reclaim from it, when we
face memory contention.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    6 
 kernel/res_counter.c        |   18 +-
 mm/memcontrol.c             |  302 +++++++++++++++++++++++++++++-----
 3 files changed, 279 insertions(+), 47 deletions(-)

diff -puN include/linux/res_counter.h~memory-controller-soft-limit-organize-cgroups-v9 include/linux/res_counter.h
--- a/include/linux/res_counter.h~memory-controller-soft-limit-organize-cgroups-v9
+++ a/include/linux/res_counter.h
@@ -114,7 +114,8 @@ void res_counter_init(struct res_counter
 int __must_check res_counter_charge_locked(struct res_counter *counter,
 		unsigned long val);
 int __must_check res_counter_charge(struct res_counter *counter,
-		unsigned long val, struct res_counter **limit_fail_at);
+		unsigned long val, struct res_counter **limit_fail_at,
+		struct res_counter **soft_limit_at);
 
 /*
  * uncharge - tell that some portion of the resource is released
@@ -127,7 +128,8 @@ int __must_check res_counter_charge(stru
  */
 
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
-void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+void res_counter_uncharge(struct res_counter *counter, unsigned long val,
+				bool *was_soft_limit_excess);
 
 static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 {
diff -puN kernel/res_counter.c~memory-controller-soft-limit-organize-cgroups-v9 kernel/res_counter.c
--- a/kernel/res_counter.c~memory-controller-soft-limit-organize-cgroups-v9
+++ a/kernel/res_counter.c
@@ -37,17 +37,27 @@ int res_counter_charge_locked(struct res
 }
 
 int res_counter_charge(struct res_counter *counter, unsigned long val,
-			struct res_counter **limit_fail_at)
+			struct res_counter **limit_fail_at,
+			struct res_counter **soft_limit_fail_at)
 {
 	int ret;
 	unsigned long flags;
 	struct res_counter *c, *u;
 
 	*limit_fail_at = NULL;
+	if (soft_limit_fail_at)
+		*soft_limit_fail_at = NULL;
 	local_irq_save(flags);
 	for (c = counter; c != NULL; c = c->parent) {
 		spin_lock(&c->lock);
 		ret = res_counter_charge_locked(c, val);
+		/*
+		 * With soft limits, we return the highest ancestor
+		 * that exceeds its soft limit
+		 */
+		if (soft_limit_fail_at &&
+			!res_counter_soft_limit_check_locked(c))
+			*soft_limit_fail_at = c;
 		spin_unlock(&c->lock);
 		if (ret < 0) {
 			*limit_fail_at = c;
@@ -75,7 +85,8 @@ void res_counter_uncharge_locked(struct 
 	counter->usage -= val;
 }
 
-void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+void res_counter_uncharge(struct res_counter *counter, unsigned long val,
+				bool *was_soft_limit_excess)
 {
 	unsigned long flags;
 	struct res_counter *c;
@@ -83,6 +94,9 @@ void res_counter_uncharge(struct res_cou
 	local_irq_save(flags);
 	for (c = counter; c != NULL; c = c->parent) {
 		spin_lock(&c->lock);
+		if (was_soft_limit_excess)
+			*was_soft_limit_excess =
+				!res_counter_soft_limit_check_locked(c);
 		res_counter_uncharge_locked(c, val);
 		spin_unlock(&c->lock);
 	}
diff -puN mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v9 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v9
+++ a/mm/memcontrol.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
 #include <linux/mutex.h>
+#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/spinlock.h>
@@ -54,6 +55,7 @@ static int really_do_swap_account __init
 #endif
 
 static DEFINE_MUTEX(memcg_tasklist);	/* can be hold under cgroup_mutex */
+#define SOFTLIMIT_EVENTS_THRESH (1000)
 
 /*
  * Statistics for memory cgroup.
@@ -67,6 +69,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_MAPPED_FILE,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
+	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -79,6 +82,20 @@ struct mem_cgroup_stat {
 	struct mem_cgroup_stat_cpu cpustat[0];
 };
 
+static inline void
+__mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
+				enum mem_cgroup_stat_index idx)
+{
+	stat->count[idx] = 0;
+}
+
+static inline s64
+__mem_cgroup_stat_read_local(struct mem_cgroup_stat_cpu *stat,
+				enum mem_cgroup_stat_index idx)
+{
+	return stat->count[idx];
+}
+
 /*
  * For accounting under irq disable, no need for increment preempt count.
  */
@@ -118,6 +135,10 @@ struct mem_cgroup_per_zone {
 	unsigned long		count[NR_LRU_LISTS];
 
 	struct zone_reclaim_stat reclaim_stat;
+	struct rb_node		tree_node;	/* RB tree node */
+	unsigned long long	usage_in_excess;/* Set to the value by which */
+						/* the soft limit is exceeded*/
+	bool			on_tree;
 };
 /* Macro for accessing counter */
 #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
@@ -131,6 +152,26 @@ struct mem_cgroup_lru_info {
 };
 
 /*
+ * Cgroups above their limits are maintained in a RB-Tree, independent of
+ * their hierarchy representation
+ */
+
+struct mem_cgroup_tree_per_zone {
+	struct rb_root rb_root;
+	spinlock_t lock;
+};
+
+struct mem_cgroup_tree_per_node {
+	struct mem_cgroup_tree_per_zone rb_tree_per_zone[MAX_NR_ZONES];
+};
+
+struct mem_cgroup_tree {
+	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
+};
+
+static struct mem_cgroup_tree soft_limit_tree __read_mostly;
+
+/*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
@@ -215,6 +256,152 @@ static void mem_cgroup_get(struct mem_cg
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
 
+static struct mem_cgroup_per_zone *
+mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
+{
+	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
+}
+
+static struct mem_cgroup_per_zone *
+page_cgroup_zoneinfo(struct page_cgroup *pc)
+{
+	struct mem_cgroup *mem = pc->mem_cgroup;
+	int nid = page_cgroup_nid(pc);
+	int zid = page_cgroup_zid(pc);
+
+	if (!mem)
+		return NULL;
+
+	return mem_cgroup_zoneinfo(mem, nid, zid);
+}
+
+static struct mem_cgroup_tree_per_zone *
+soft_limit_tree_node_zone(int nid, int zid)
+{
+	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
+}
+
+static struct mem_cgroup_tree_per_zone *
+soft_limit_tree_from_page(struct page *page)
+{
+	int nid = page_to_nid(page);
+	int zid = page_zonenum(page);
+
+	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
+}
+
+static void
+mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz)
+{
+	struct rb_node **p = &mctz->rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct mem_cgroup_per_zone *mz_node;
+
+	if (mz->on_tree)
+		return;
+
+	mz->usage_in_excess = res_counter_soft_limit_excess(&mem->res);
+	spin_lock(&mctz->lock);
+	while (*p) {
+		parent = *p;
+		mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
+					tree_node);
+		if (mz->usage_in_excess < mz_node->usage_in_excess)
+			p = &(*p)->rb_left;
+		/*
+		 * We can't avoid mem cgroups that are over their soft
+		 * limit by the same amount
+		 */
+		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&mz->tree_node, parent, p);
+	rb_insert_color(&mz->tree_node, &mctz->rb_root);
+	mz->on_tree = true;
+	spin_unlock(&mctz->lock);
+}
+
+static void
+mem_cgroup_remove_exceeded(struct mem_cgroup *mem,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz)
+{
+	spin_lock(&mctz->lock);
+	rb_erase(&mz->tree_node, &mctz->rb_root);
+	mz->on_tree = false;
+	spin_unlock(&mctz->lock);
+}
+
+static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem,
+					bool over_soft_limit)
+{
+	bool ret = false;
+	int cpu = get_cpu();
+	s64 val;
+	struct mem_cgroup_stat_cpu *cpustat;
+
+	if (!over_soft_limit)
+		return ret;
+
+	cpustat = &mem->stat.cpustat[cpu];
+	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
+	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
+		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
+		ret = true;
+	}
+	return ret;
+}
+
+static void mem_cgroup_update_tree(struct mem_cgroup *mem, struct page *page)
+{
+	unsigned long long prev_usage_in_excess, new_usage_in_excess;
+	bool updated_tree = false;
+	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_tree_per_zone *mctz;
+
+	mz = mem_cgroup_zoneinfo(mem, page_to_nid(page), page_zonenum(page));
+	mctz = soft_limit_tree_from_page(page);
+
+	/*
+	 * We do updates in lazy mode, mem's are removed
+	 * lazily from the per-zone, per-node rb tree
+	 */
+	prev_usage_in_excess = mz->usage_in_excess;
+
+	new_usage_in_excess = res_counter_soft_limit_excess(&mem->res);
+	if (prev_usage_in_excess) {
+		mem_cgroup_remove_exceeded(mem, mz, mctz);
+		updated_tree = true;
+	}
+	if (!new_usage_in_excess)
+		goto done;
+	mem_cgroup_insert_exceeded(mem, mz, mctz);
+
+done:
+	if (updated_tree) {
+		spin_lock(&mctz->lock);
+		mz->usage_in_excess = new_usage_in_excess;
+		spin_unlock(&mctz->lock);
+	}
+}
+
+static void mem_cgroup_remove_from_trees(struct mem_cgroup *mem)
+{
+	int node, zone;
+	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_tree_per_zone *mctz;
+
+	for_each_node_state(node, N_POSSIBLE) {
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			mz = mem_cgroup_zoneinfo(mem, node, zone);
+			mctz = soft_limit_tree_node_zone(node, zone);
+			mem_cgroup_remove_exceeded(mem, mz, mctz);
+		}
+	}
+}
+
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
 					 bool charge)
@@ -236,28 +423,10 @@ static void mem_cgroup_charge_statistics
 	else
 		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
 	put_cpu();
 }
 
-static struct mem_cgroup_per_zone *
-mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
-{
-	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
-}
-
-static struct mem_cgroup_per_zone *
-page_cgroup_zoneinfo(struct page_cgroup *pc)
-{
-	struct mem_cgroup *mem = pc->mem_cgroup;
-	int nid = page_cgroup_nid(pc);
-	int zid = page_cgroup_zid(pc);
-
-	if (!mem)
-		return NULL;
-
-	return mem_cgroup_zoneinfo(mem, nid, zid);
-}
-
 static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
 					enum lru_list idx)
 {
@@ -972,11 +1141,11 @@ done:
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
 			gfp_t gfp_mask, struct mem_cgroup **memcg,
-			bool oom)
+			bool oom, struct page *page)
 {
-	struct mem_cgroup *mem, *mem_over_limit;
+	struct mem_cgroup *mem, *mem_over_limit, *mem_over_soft_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct res_counter *fail_res;
+	struct res_counter *fail_res, *soft_fail_res = NULL;
 
 	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
 		/* Don't account this! */
@@ -1006,16 +1175,17 @@ static int __mem_cgroup_try_charge(struc
 		int ret;
 		bool noswap = false;
 
-		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
+		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
+						&soft_fail_res);
 		if (likely(!ret)) {
 			if (!do_swap_account)
 				break;
 			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
-							&fail_res);
+							&fail_res, NULL);
 			if (likely(!ret))
 				break;
 			/* mem+swap counter fails */
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
 			noswap = true;
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									memsw);
@@ -1053,13 +1223,23 @@ static int __mem_cgroup_try_charge(struc
 			goto nomem;
 		}
 	}
+	/*
+	 * Insert just the ancestor, we should trickle down to the correct
+	 * cgroup for reclaim, since the other nodes will be below their
+	 * soft limit
+	 */
+	if (soft_fail_res) {
+		mem_over_soft_limit =
+			mem_cgroup_from_res_counter(soft_fail_res, res);
+		if (mem_cgroup_soft_limit_check(mem_over_soft_limit, true))
+			mem_cgroup_update_tree(mem_over_soft_limit, page);
+	}
 	return 0;
 nomem:
 	css_put(&mem->css);
 	return -ENOMEM;
 }
 
-
 /*
  * A helper function to get mem_cgroup from ID. must be called under
  * rcu_read_lock(). The caller must check css_is_removed() or some if
@@ -1126,9 +1306,9 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
 		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
 		css_put(&mem->css);
 		return;
 	}
@@ -1205,7 +1385,7 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out;
 
-	res_counter_uncharge(&from->res, PAGE_SIZE);
+	res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
 	mem_cgroup_charge_statistics(from, pc, false);
 
 	page = pc->page;
@@ -1225,7 +1405,7 @@ static int mem_cgroup_move_account(struc
 	}
 
 	if (do_swap_account)
-		res_counter_uncharge(&from->memsw, PAGE_SIZE);
+		res_counter_uncharge(&from->memsw, PAGE_SIZE, NULL);
 	css_put(&from->css);
 
 	css_get(&to->css);
@@ -1265,7 +1445,7 @@ static int mem_cgroup_move_parent(struct
 	parent = mem_cgroup_from_cont(pcg);
 
 
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, page);
 	if (ret || !parent)
 		return ret;
 
@@ -1295,9 +1475,9 @@ uncharge:
 	/* drop extra refcnt by try_charge() */
 	css_put(&parent->css);
 	/* uncharge if move fails */
-	res_counter_uncharge(&parent->res, PAGE_SIZE);
+	res_counter_uncharge(&parent->res, PAGE_SIZE, NULL);
 	if (do_swap_account)
-		res_counter_uncharge(&parent->memsw, PAGE_SIZE);
+		res_counter_uncharge(&parent->memsw, PAGE_SIZE, NULL);
 	return ret;
 }
 
@@ -1322,7 +1502,7 @@ static int mem_cgroup_charge_common(stru
 	prefetchw(pc);
 
 	mem = memcg;
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page);
 	if (ret || !mem)
 		return ret;
 
@@ -1441,14 +1621,14 @@ int mem_cgroup_try_charge_swapin(struct 
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true, page);
 	/* drop extra refcnt from tryget */
 	css_put(&mem->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, ptr, true);
+	return __mem_cgroup_try_charge(mm, mask, ptr, true, page);
 }
 
 static void
@@ -1486,7 +1666,7 @@ __mem_cgroup_commit_charge_swapin(struct
 			 * This recorded memcg can be obsolete one. So, avoid
 			 * calling css_tryget
 			 */
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
 			mem_cgroup_put(memcg);
 		}
 		rcu_read_unlock();
@@ -1511,9 +1691,9 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
 	if (do_swap_account)
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
 	css_put(&mem->css);
 }
 
@@ -1527,6 +1707,7 @@ __mem_cgroup_uncharge_common(struct page
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
+	bool soft_limit_excess = false;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1565,9 +1746,9 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
 	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
 	mem_cgroup_charge_statistics(mem, pc, false);
 
 	ClearPageCgroupUsed(pc);
@@ -1581,6 +1762,8 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
+	if (mem_cgroup_soft_limit_check(mem, soft_limit_excess))
+		mem_cgroup_update_tree(mem, page);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		css_put(&mem->css);
@@ -1656,7 +1839,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		 * We uncharge this because swap is freed.
 		 * This memcg can be obsolete one. We avoid calling css_tryget
 		 */
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
 		mem_cgroup_put(memcg);
 	}
 	rcu_read_unlock();
@@ -1685,7 +1868,8 @@ int mem_cgroup_prepare_migration(struct 
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
+						page);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
@@ -2194,6 +2378,7 @@ static int mem_cgroup_reset(struct cgrou
 			res_counter_reset_failcnt(&mem->memsw);
 		break;
 	}
+
 	return 0;
 }
 
@@ -2489,6 +2674,7 @@ static int alloc_mem_cgroup_per_zone_inf
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
 			INIT_LIST_HEAD(&mz->lists[l]);
+		mz->usage_in_excess = 0;
 	}
 	return 0;
 }
@@ -2534,6 +2720,7 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	mem_cgroup_remove_from_trees(mem);
 	free_css_id(&mem_cgroup_subsys, &mem->css);
 
 	for_each_node_state(node, N_POSSIBLE)
@@ -2582,6 +2769,31 @@ static void __init enable_swap_cgroup(vo
 }
 #endif
 
+static int mem_cgroup_soft_limit_tree_init(void)
+{
+	struct mem_cgroup_tree_per_node *rtpn;
+	struct mem_cgroup_tree_per_zone *rtpz;
+	int tmp, node, zone;
+
+	for_each_node_state(node, N_POSSIBLE) {
+		tmp = node;
+		if (!node_state(node, N_NORMAL_MEMORY))
+			tmp = -1;
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
+		if (!rtpn)
+			return 1;
+
+		soft_limit_tree.rb_tree_per_node[node] = rtpn;
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			rtpz = &rtpn->rb_tree_per_zone[zone];
+			rtpz->rb_root = RB_ROOT;
+			spin_lock_init(&rtpz->lock);
+		}
+	}
+	return 0;
+}
+
 static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -2596,11 +2808,15 @@ mem_cgroup_create(struct cgroup_subsys *
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
+
 	/* root ? */
 	if (cont->parent == NULL) {
 		enable_swap_cgroup();
 		parent = NULL;
 		root_mem_cgroup = mem;
+		if (mem_cgroup_soft_limit_tree_init())
+			goto free_out;
+
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-avoid-permanent-sleep-at-rmdir-v7.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch

