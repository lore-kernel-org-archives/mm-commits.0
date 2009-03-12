From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-reclaim-on-contention-v5.patch added to -mm tree
Date: Thu, 12 Mar 2009 16:34:44 -0700
Message-ID: <200903122334.n2CNYjjL017774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbZCLXkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 19:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, riel@redhat.com, yamamoto@valinux.co.jp


The patch titled
     Memory controller soft limit reclaim on contention
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-reclaim-on-contention-v5.patch

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
Subject: Memory controller soft limit reclaim on contention
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Implement reclaim from groups over their soft limit

Allow reclaim from memory cgroups on contention (via the kswapd() path)
only if the order is 0.

memory cgroup soft limit reclaim finds the group that exceeds its soft
limit by the largest amount and reclaims pages from it and then reinserts
the cgroup into its correct place in the rbtree.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +
 include/linux/swap.h       |    1 
 mm/memcontrol.c            |  180 +++++++++++++++++++++++++++++++----
 mm/page_alloc.c            |    9 +
 mm/vmscan.c                |    5 
 5 files changed, 179 insertions(+), 23 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-soft-limit-reclaim-on-contention-v5 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-soft-limit-reclaim-on-contention-v5
+++ a/include/linux/memcontrol.h
@@ -116,7 +116,8 @@ static inline bool mem_cgroup_disabled(v
 }
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
-
+unsigned long mem_cgroup_soft_limit_reclaim(struct zonelist *zl,
+						gfp_t gfp_mask);
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -264,6 +265,10 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
+unsigned long mem_cgroup_soft_limit_reclaim(struct zonelist *zl, gfp_t gfp_mask)
+{
+	return 0;
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN include/linux/swap.h~memory-controller-soft-limit-reclaim-on-contention-v5 include/linux/swap.h
--- a/include/linux/swap.h~memory-controller-soft-limit-reclaim-on-contention-v5
+++ a/include/linux/swap.h
@@ -215,6 +215,7 @@ static inline void lru_cache_add_active_
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
+						  struct zonelist *zl,
 						  gfp_t gfp_mask, bool noswap,
 						  unsigned int swappiness);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
diff -puN mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v5 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v5
+++ a/mm/memcontrol.c
@@ -20,6 +20,7 @@
 #include <linux/res_counter.h>
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
+#include <linux/completion.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/smp.h>
@@ -191,6 +192,7 @@ struct mem_cgroup {
 	unsigned long last_tree_update;		/* Last time the tree was */
 						/* updated in jiffies     */
 
+	bool on_tree;				/* Is the node on tree? */
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -227,18 +229,29 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
+/*
+ * Bits used for hierarchical reclaim bits
+ */
+#define MEM_CGROUP_RECLAIM_NOSWAP_BIT	0x0
+#define MEM_CGROUP_RECLAIM_NOSWAP	(1 << MEM_CGROUP_RECLAIM_NOSWAP_BIT)
+#define MEM_CGROUP_RECLAIM_SHRINK_BIT	0x1
+#define MEM_CGROUP_RECLAIM_SHRINK	(1 << MEM_CGROUP_RECLAIM_SHRINK_BIT)
+#define MEM_CGROUP_RECLAIM_SOFT_BIT	0x2
+#define MEM_CGROUP_RECLAIM_SOFT		(1 << MEM_CGROUP_RECLAIM_SOFT_BIT)
+
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
 
-static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
+static void __mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
 {
 	struct rb_node **p = &mem_cgroup_soft_limit_tree.rb_node;
 	struct rb_node *parent = NULL;
 	struct mem_cgroup *mem_node;
-	unsigned long flags;
 
-	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+	if (mem->on_tree)
+		return;
+
 	while (*p) {
 		parent = *p;
 		mem_node = rb_entry(parent, struct mem_cgroup, mem_cgroup_node);
@@ -255,6 +268,23 @@ static void mem_cgroup_insert_exceeded(s
 	rb_insert_color(&mem->mem_cgroup_node,
 			&mem_cgroup_soft_limit_tree);
 	mem->last_tree_update = jiffies;
+	mem->on_tree = true;
+}
+
+static void __mem_cgroup_remove_exceeded(struct mem_cgroup *mem)
+{
+	if (!mem->on_tree)
+		return;
+	rb_erase(&mem->mem_cgroup_node, &mem_cgroup_soft_limit_tree);
+	mem->on_tree = false;
+}
+
+static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+	__mem_cgroup_insert_exceeded(mem);
 	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
 }
 
@@ -262,8 +292,53 @@ static void mem_cgroup_remove_exceeded(s
 {
 	unsigned long flags;
 	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
-	rb_erase(&mem->mem_cgroup_node, &mem_cgroup_soft_limit_tree);
+	__mem_cgroup_remove_exceeded(mem);
+	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+}
+
+unsigned long mem_cgroup_get_excess(struct mem_cgroup *mem)
+{
+	unsigned long flags;
+	unsigned long long excess;
+
+	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+	excess = mem->usage_in_excess >> PAGE_SHIFT;
 	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+	return (excess > ULONG_MAX) ? ULONG_MAX : excess;
+}
+
+static struct mem_cgroup *__mem_cgroup_largest_soft_limit_node(void)
+{
+	struct rb_node *rightmost = NULL;
+	struct mem_cgroup *mem = NULL;
+
+retry:
+	rightmost = rb_last(&mem_cgroup_soft_limit_tree);
+	if (!rightmost)
+		goto done;		/* Nothing to reclaim from */
+
+	mem = rb_entry(rightmost, struct mem_cgroup, mem_cgroup_node);
+	/*
+	 * Remove the node now but someone else can add it back,
+	 * we will to add it back at the end of reclaim to its correct
+	 * position in the tree.
+	 */
+	__mem_cgroup_remove_exceeded(mem);
+	if (!css_tryget(&mem->css) || !res_counter_soft_limit_excess(&mem->res))
+		goto retry;
+done:
+	return mem;
+}
+
+static struct mem_cgroup *mem_cgroup_largest_soft_limit_node(void)
+{
+	struct mem_cgroup *mem;
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+	mem = __mem_cgroup_largest_soft_limit_node();
+	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+	return mem;
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
@@ -888,14 +963,39 @@ mem_cgroup_select_victim(struct mem_cgro
  * If shrink==true, for avoiding to free too much, this returns immedieately.
  */
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
-				   gfp_t gfp_mask, bool noswap, bool shrink)
+						struct zonelist *zl,
+						gfp_t gfp_mask,
+						unsigned long flags)
 {
 	struct mem_cgroup *victim;
 	int ret, total = 0;
 	int loop = 0;
+	bool noswap = flags & MEM_CGROUP_RECLAIM_NOSWAP;
+	bool shrink = flags & MEM_CGROUP_RECLAIM_SHRINK;
+	bool check_soft = flags & MEM_CGROUP_RECLAIM_SOFT;
+	unsigned long excess = mem_cgroup_get_excess(root_mem);
 
-	while (loop < 2) {
+	while (1) {
+		if (loop >= 2) {
+			/*
+			 * With soft limits, do more targetted reclaim
+			 */
+			if (check_soft && (total >= (excess >> 4)))
+				break;
+			else if (!check_soft)
+				break;
+		}
 		victim = mem_cgroup_select_victim(root_mem);
+		/*
+		 * In the first loop, don't reclaim from victims below
+		 * their soft limit
+		 */
+		if (!loop && res_counter_check_under_soft_limit(&victim->res)) {
+			if (victim == root_mem)
+				loop++;
+			css_put(&victim->css);
+			continue;
+		}
 		if (victim == root_mem)
 			loop++;
 		if (!mem_cgroup_local_usage(&victim->stat)) {
@@ -904,8 +1004,9 @@ static int mem_cgroup_hierarchical_recla
 			continue;
 		}
 		/* we use swappiness of local cgroup */
-		ret = try_to_free_mem_cgroup_pages(victim, gfp_mask, noswap,
-						   get_swappiness(victim));
+		ret = try_to_free_mem_cgroup_pages(victim, zl, gfp_mask,
+							noswap,
+							get_swappiness(victim));
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -915,7 +1016,10 @@ static int mem_cgroup_hierarchical_recla
 		if (shrink)
 			return ret;
 		total += ret;
-		if (mem_cgroup_check_under_limit(root_mem))
+		if (check_soft) {
+			if (res_counter_check_under_soft_limit(&root_mem->res))
+				return total;
+		} else if (mem_cgroup_check_under_limit(root_mem))
 			return 1 + total;
 	}
 	return total;
@@ -1022,7 +1126,7 @@ static int __mem_cgroup_try_charge(struc
 
 	while (1) {
 		int ret;
-		bool noswap = false;
+		unsigned long flags = 0;
 
 		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
 						&soft_fail_res);
@@ -1035,7 +1139,7 @@ static int __mem_cgroup_try_charge(struc
 				break;
 			/* mem+swap counter fails */
 			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
-			noswap = true;
+			flags = MEM_CGROUP_RECLAIM_NOSWAP;
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									memsw);
 		} else
@@ -1046,8 +1150,8 @@ static int __mem_cgroup_try_charge(struc
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
-							noswap, false);
+		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
+							gfp_mask, flags);
 		if (ret)
 			continue;
 
@@ -1757,8 +1861,8 @@ int mem_cgroup_shrink_usage(struct page 
 		return 0;
 
 	do {
-		progress = mem_cgroup_hierarchical_reclaim(mem,
-					gfp_mask, true, false);
+		progress = mem_cgroup_hierarchical_reclaim(mem, NULL,
+					gfp_mask, MEM_CGROUP_RECLAIM_NOSWAP);
 		progress += mem_cgroup_check_under_limit(mem);
 	} while (!progress && --retry);
 
@@ -1812,8 +1916,9 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
-						   false, true);
+		progress = mem_cgroup_hierarchical_reclaim(memcg, NULL,
+						GFP_KERNEL,
+						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
   		if (curusage >= oldusage)
@@ -1861,7 +1966,9 @@ int mem_cgroup_resize_memsw_limit(struct
 		if (!ret)
 			break;
 
-		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true, true);
+		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
+						MEM_CGROUP_RECLAIM_NOSWAP |
+						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
@@ -1872,6 +1979,39 @@ int mem_cgroup_resize_memsw_limit(struct
 	return ret;
 }
 
+unsigned long mem_cgroup_soft_limit_reclaim(struct zonelist *zl, gfp_t gfp_mask)
+{
+	unsigned long nr_reclaimed = 0;
+	struct mem_cgroup *mem;
+	unsigned long flags;
+	unsigned long reclaimed;
+
+	/*
+	 * This loop can run a while, specially if mem_cgroup's continuously
+	 * keep exceeding their soft limit and putting the system under
+	 * pressure
+	 */
+	do {
+		mem = mem_cgroup_largest_soft_limit_node();
+		if (!mem)
+			break;
+
+		reclaimed = mem_cgroup_hierarchical_reclaim(mem, zl,
+						gfp_mask,
+						MEM_CGROUP_RECLAIM_SOFT);
+		nr_reclaimed += reclaimed;
+		spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
+		mem->usage_in_excess = res_counter_soft_limit_excess(&mem->res);
+		__mem_cgroup_remove_exceeded(mem);
+		if (mem->usage_in_excess)
+			__mem_cgroup_insert_exceeded(mem);
+		spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
+		css_put(&mem->css);
+		cond_resched();
+	} while (!nr_reclaimed);
+	return nr_reclaimed;
+}
+
 /*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
@@ -1995,7 +2135,7 @@ try_to_free:
 			ret = -EINTR;
 			goto out;
 		}
-		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
+		progress = try_to_free_mem_cgroup_pages(mem, NULL, GFP_KERNEL,
 						false, get_swappiness(mem));
 		if (!progress) {
 			nr_retries--;
@@ -2600,6 +2740,8 @@ mem_cgroup_create(struct cgroup_subsys *
 	mem->last_scanned_child = 0;
 	mem->usage_in_excess = 0;
 	mem->last_tree_update = 0;	/* Yes, time begins at 0 here */
+	mem->on_tree = false;
+
 	spin_lock_init(&mem->reclaim_param_lock);
 
 	if (parent)
diff -puN mm/page_alloc.c~memory-controller-soft-limit-reclaim-on-contention-v5 mm/page_alloc.c
--- a/mm/page_alloc.c~memory-controller-soft-limit-reclaim-on-contention-v5
+++ a/mm/page_alloc.c
@@ -1598,7 +1598,14 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
+	/*
+	 * Try to free up some pages from the memory controllers soft
+	 * limit queue.
+	 */
+	did_some_progress = mem_cgroup_soft_limit_reclaim(zonelist, gfp_mask);
+	if (!order || !did_some_progress)
+		did_some_progress += try_to_free_pages(zonelist, order,
+							gfp_mask);
 
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
diff -puN mm/vmscan.c~memory-controller-soft-limit-reclaim-on-contention-v5 mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-soft-limit-reclaim-on-contention-v5
+++ a/mm/vmscan.c
@@ -1701,6 +1701,7 @@ unsigned long try_to_free_pages(struct z
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
+					   struct zonelist *zonelist,
 					   gfp_t gfp_mask,
 					   bool noswap,
 					   unsigned int swappiness)
@@ -1714,14 +1715,14 @@ unsigned long try_to_free_mem_cgroup_pag
 		.mem_cgroup = mem_cont,
 		.isolate_pages = mem_cgroup_isolate_pages,
 	};
-	struct zonelist *zonelist;
 
 	if (noswap)
 		sc.may_unmap = 0;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
+	if (!zonelist)
+		zonelist = NODE_DATA(numa_node_id())->node_zonelists;
 	return do_try_to_free_pages(zonelist, &sc);
 }
 #endif
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
memory-controller-soft-limit-documentation-v5.patch
memory-controller-soft-limit-interface-v5.patch
memory-controller-soft-limit-organize-cgroups-v5.patch
memory-controller-soft-limit-reclaim-on-contention-v5.patch

