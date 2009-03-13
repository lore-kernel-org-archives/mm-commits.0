From: akpm@linux-foundation.org
Subject: - memory-controller-soft-limit-organize-cgroups-v5.patch removed from -mm tree
Date: Fri, 13 Mar 2009 00:07:49 -0700
Message-ID: <200903130707.n2D77nMb030227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbZCMHNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 03:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, riel@redhat.com, yamamoto@valinux.co.jp, mm-commits@


The patch titled
     Memory controller soft limit organize cgroups
has been removed from the -mm tree.  Its filename was
     memory-controller-soft-limit-organize-cgroups-v5.patch

This patch was dropped because it seems to need a bit more thought ;)

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller soft limit organize cgroups
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Organize cgroups over soft limit in a RB-Tree

Introduce an RB-Tree for storing memory cgroups that are over their soft
limit.  The overall goal is to

1. Add a memory cgroup to the RB-Tree when the soft limit is exceeded.
   We are careful about updates, updates take place only after a
   particular time interval has passed

2. We remove the node from the RB-Tree when the usage goes below the
   soft limit

The next set of patches will exploit the RB-Tree to get the group that is
over its soft limit by the largest amount and reclaim from it, when we
face memory contention.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    6 -
 kernel/res_counter.c        |   18 +++-
 mm/memcontrol.c             |  141 +++++++++++++++++++++++++++++-----
 3 files changed, 143 insertions(+), 22 deletions(-)

diff -puN include/linux/res_counter.h~memory-controller-soft-limit-organize-cgroups-v5 include/linux/res_counter.h
--- a/include/linux/res_counter.h~memory-controller-soft-limit-organize-cgroups-v5
+++ a/include/linux/res_counter.h
@@ -112,7 +112,8 @@ void res_counter_init(struct res_counter
 int __must_check res_counter_charge_locked(struct res_counter *counter,
 		unsigned long val);
 int __must_check res_counter_charge(struct res_counter *counter,
-		unsigned long val, struct res_counter **limit_fail_at);
+		unsigned long val, struct res_counter **limit_fail_at,
+		struct res_counter **soft_limit_at);
 
 /*
  * uncharge - tell that some portion of the resource is released
@@ -125,7 +126,8 @@ int __must_check res_counter_charge(stru
  */
 
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
-void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+void res_counter_uncharge(struct res_counter *counter, unsigned long val,
+				bool *was_soft_limit_excess);
 
 static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 {
diff -puN kernel/res_counter.c~memory-controller-soft-limit-organize-cgroups-v5 kernel/res_counter.c
--- a/kernel/res_counter.c~memory-controller-soft-limit-organize-cgroups-v5
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
+		if (c == counter && was_soft_limit_excess)
+			*was_soft_limit_excess =
+				!res_counter_soft_limit_check_locked(c);
 		res_counter_uncharge_locked(c, val);
 		spin_unlock(&c->lock);
 	}
diff -puN mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v5 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-organize-cgroups-v5
+++ a/mm/memcontrol.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
 #include <linux/mutex.h>
+#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/spinlock.h>
@@ -129,6 +130,14 @@ struct mem_cgroup_lru_info {
 };
 
 /*
+ * Cgroups above their limits are maintained in a RB-Tree, independent of
+ * their hierarchy representation
+ */
+
+static struct rb_root mem_cgroup_soft_limit_tree;
+static DEFINE_SPINLOCK(memcg_soft_limit_tree_lock);
+
+/*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
@@ -176,12 +185,20 @@ struct mem_cgroup {
 
 	unsigned int	swappiness;
 
+	struct rb_node mem_cgroup_node;		/* RB tree node */
+	unsigned long long usage_in_excess;	/* Set to the value by which */
+						/* the soft limit is exceeded*/
+	unsigned long last_tree_update;		/* Last time the tree was */
+						/* updated in jiffies     */
+
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
 	struct mem_cgroup_stat stat;
 };
 
+#define	MEM_CGROUP_TREE_UPDATE_INTERVAL		(HZ/4)
+
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
@@ -214,6 +231,41 @@ static void mem_cgroup_get(struct mem_cg
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
 
+static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
+{
+	struct rb_node **p = &mem_cgroup_soft_limit_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct mem_cgroup *mem_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+	while (*p) {
+		parent = *p;
+		mem_node = rb_entry(parent, struct mem_cgroup, mem_cgroup_node);
+		if (mem->usage_in_excess < mem_node->usage_in_excess)
+			p = &(*p)->rb_left;
+		/*
+		 * We can't avoid mem cgroups that are over their soft
+		 * limit by the same amount
+		 */
+		else if (mem->usage_in_excess >= mem_node->usage_in_excess)
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&mem->mem_cgroup_node, parent, p);
+	rb_insert_color(&mem->mem_cgroup_node,
+			&mem_cgroup_soft_limit_tree);
+	mem->last_tree_update = jiffies;
+	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+}
+
+static void mem_cgroup_remove_exceeded(struct mem_cgroup *mem)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+	rb_erase(&mem->mem_cgroup_node, &mem_cgroup_soft_limit_tree);
+	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+}
+
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
 					 bool charge)
@@ -897,6 +949,40 @@ static void record_last_oom(struct mem_c
 	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
 }
 
+static void mem_cgroup_check_and_update_tree(struct mem_cgroup *mem,
+						bool time_check)
+{
+	unsigned long long prev_usage_in_excess, new_usage_in_excess;
+	bool updated_tree = false;
+	unsigned long next_update = 0;
+	unsigned long flags;
+
+	prev_usage_in_excess = mem->usage_in_excess;
+
+	if (time_check)
+		next_update = mem->last_tree_update +
+				MEM_CGROUP_TREE_UPDATE_INTERVAL;
+
+	if (!time_check || time_after(jiffies, next_update)) {
+		new_usage_in_excess = res_counter_soft_limit_excess(&mem->res);
+		if (prev_usage_in_excess) {
+			mem_cgroup_remove_exceeded(mem);
+			updated_tree = true;
+		}
+		if (!new_usage_in_excess)
+			goto done;
+		mem_cgroup_insert_exceeded(mem);
+		updated_tree = true;
+	}
+
+done:
+	if (updated_tree) {
+		spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+		mem->last_tree_update = jiffies;
+		mem->usage_in_excess = new_usage_in_excess;
+		spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+	}
+}
 
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
@@ -906,9 +992,9 @@ static int __mem_cgroup_try_charge(struc
 			gfp_t gfp_mask, struct mem_cgroup **memcg,
 			bool oom)
 {
-	struct mem_cgroup *mem, *mem_over_limit;
+	struct mem_cgroup *mem, *mem_over_limit, *mem_over_soft_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct res_counter *fail_res;
+	struct res_counter *fail_res, *soft_fail_res = NULL;
 
 	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
 		/* Don't account this! */
@@ -938,16 +1024,17 @@ static int __mem_cgroup_try_charge(struc
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
@@ -985,6 +1072,17 @@ static int __mem_cgroup_try_charge(struc
 			goto nomem;
 		}
 	}
+
+	/*
+	 * Insert just the ancestor, we should trickle down to the correct
+	 * cgroup for reclaim, since the other nodes will be below their
+	 * soft limit
+	 */
+	if (soft_fail_res) {
+		mem_over_soft_limit =
+			mem_cgroup_from_res_counter(soft_fail_res, res);
+		mem_cgroup_check_and_update_tree(mem_over_soft_limit, true);
+	}
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -1061,9 +1159,9 @@ static void __mem_cgroup_commit_charge(s
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
@@ -1116,10 +1214,10 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out;
 
-	res_counter_uncharge(&from->res, PAGE_SIZE);
+	res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (do_swap_account)
-		res_counter_uncharge(&from->memsw, PAGE_SIZE);
+		res_counter_uncharge(&from->memsw, PAGE_SIZE, NULL);
 	css_put(&from->css);
 
 	css_get(&to->css);
@@ -1183,9 +1281,9 @@ uncharge:
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
 
@@ -1314,7 +1412,7 @@ int mem_cgroup_cache_charge(struct page 
 			 * Recorded ID can be obsolete. We avoid calling
 			 * css_tryget()
 			 */
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
 			mem_cgroup_put(mem);
 		}
 		rcu_read_unlock();
@@ -1393,7 +1491,7 @@ void mem_cgroup_commit_charge_swapin(str
 			 * This recorded memcg can be obsolete one. So, avoid
 			 * calling css_tryget
 			 */
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
 			mem_cgroup_put(memcg);
 		}
 		rcu_read_unlock();
@@ -1408,9 +1506,9 @@ void mem_cgroup_cancel_charge_swapin(str
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
 
@@ -1424,6 +1522,7 @@ __mem_cgroup_uncharge_common(struct page
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
+	bool soft_limit_excess = false;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1461,9 +1560,9 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
 	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
 	mem_cgroup_charge_statistics(mem, pc, false);
 
 	ClearPageCgroupUsed(pc);
@@ -1477,6 +1576,8 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
+	if (soft_limit_excess)
+		mem_cgroup_check_and_update_tree(mem, true);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		css_put(&mem->css);
@@ -1545,7 +1646,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		 * We uncharge this because swap is freed.
 		 * This memcg can be obsolete one. We avoid calling css_tryget
 		 */
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
 		mem_cgroup_put(memcg);
 	}
 	rcu_read_unlock();
@@ -2409,6 +2510,7 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	mem_cgroup_check_and_update_tree(mem, false);
 	free_css_id(&mem_cgroup_subsys, &mem->css);
 
 	for_each_node_state(node, N_POSSIBLE)
@@ -2475,6 +2577,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (cont->parent == NULL) {
 		enable_swap_cgroup();
 		parent = NULL;
+		mem_cgroup_soft_limit_tree = RB_ROOT;
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
@@ -2495,6 +2598,8 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
+	mem->usage_in_excess = 0;
+	mem->last_tree_update = 0;	/* Yes, time begins at 0 here */
 	spin_lock_init(&mem->reclaim_param_lock);
 
 	if (parent)
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
memcg-charge-swapcache-to-proper-memcg.patch
memory-controller-soft-limit-organize-cgroups-v5.patch
memory-controller-soft-limit-reclaim-on-contention-v5.patch
memory-controller-soft-limit-reclaim-on-contention-v5-fix.patch

