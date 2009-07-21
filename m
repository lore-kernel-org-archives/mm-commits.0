From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-reclaim-on-contention-v9.patch added to -mm tree
Date: Tue, 21 Jul 2009 14:14:31 -0700
Message-ID: <200907212114.n6LLEWj4025209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbZGUVOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 17:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memory controller: soft limit reclaim on contention
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-reclaim-on-contention-v9.patch

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
Subject: memory controller: soft limit reclaim on contention
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Implement reclaim from groups over their soft limit

Permit reclaim from memory cgroups on contention (via the direct reclaim
path).

memory cgroup soft limit reclaim finds the group that exceeds its soft
limit by the largest number of pages and reclaims pages from it and then
reinserts the cgroup into its correct place in the rbtree.

Add additional checks to mem_cgroup_hierarchical_reclaim() to detect long
loops in case all swap is turned off.  The code has been refactored and
the loop check (loop < 2) has been enhanced for soft limits.  For soft
limits, we try to do more targetted reclaim.  Instead of bailing out after
two loops, the routine now reclaims memory proportional to the size by
which the soft limit is exceeded.  The proportion has been empirically
determined.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +
 include/linux/swap.h       |    5 
 mm/memcontrol.c            |  213 ++++++++++++++++++++++++++++++++---
 mm/vmscan.c                |   45 +++++++
 4 files changed, 259 insertions(+), 15 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-soft-limit-reclaim-on-contention-v9 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-soft-limit-reclaim-on-contention-v9
+++ a/include/linux/memcontrol.h
@@ -118,6 +118,9 @@ static inline bool mem_cgroup_disabled(v
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
 void mem_cgroup_update_mapped_file_stat(struct page *page, int val);
+unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+						gfp_t gfp_mask, int nid,
+						int zid);
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -276,6 +279,14 @@ static inline void mem_cgroup_update_map
 {
 }
 
+static inline
+unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+						gfp_t gfp_mask, int nid,
+						int zid, int priority)
+{
+	return 0;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN include/linux/swap.h~memory-controller-soft-limit-reclaim-on-contention-v9 include/linux/swap.h
--- a/include/linux/swap.h~memory-controller-soft-limit-reclaim-on-contention-v9
+++ a/include/linux/swap.h
@@ -217,6 +217,11 @@ extern unsigned long try_to_free_pages(s
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 						  gfp_t gfp_mask, bool noswap,
 						  unsigned int swappiness);
+extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
+						gfp_t gfp_mask, bool noswap,
+						unsigned int swappiness,
+						struct zone *zone,
+						int nid);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9
+++ a/mm/memcontrol.c
@@ -139,6 +139,8 @@ struct mem_cgroup_per_zone {
 	unsigned long long	usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
+	struct mem_cgroup	*mem;		/* Back pointer, we cannot */
+						/* use container_of	   */
 };
 /* Macro for accessing counter */
 #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
@@ -228,6 +230,13 @@ struct mem_cgroup {
 	struct mem_cgroup_stat stat;
 };
 
+/*
+ * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
+ * limit reclaim to prevent infinite loops, if they ever occur.
+ */
+#define	MEM_CGROUP_MAX_RECLAIM_LOOPS		(100)
+#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	(2)
+
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
@@ -259,6 +268,8 @@ enum charge_type {
 #define MEM_CGROUP_RECLAIM_NOSWAP	(1 << MEM_CGROUP_RECLAIM_NOSWAP_BIT)
 #define MEM_CGROUP_RECLAIM_SHRINK_BIT	0x1
 #define MEM_CGROUP_RECLAIM_SHRINK	(1 << MEM_CGROUP_RECLAIM_SHRINK_BIT)
+#define MEM_CGROUP_RECLAIM_SOFT_BIT	0x2
+#define MEM_CGROUP_RECLAIM_SOFT		(1 << MEM_CGROUP_RECLAIM_SOFT_BIT)
 
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
@@ -299,7 +310,7 @@ soft_limit_tree_from_page(struct page *p
 }
 
 static void
-mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
+__mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
 				struct mem_cgroup_per_zone *mz,
 				struct mem_cgroup_tree_per_zone *mctz)
 {
@@ -311,7 +322,6 @@ mem_cgroup_insert_exceeded(struct mem_cg
 		return;
 
 	mz->usage_in_excess = res_counter_soft_limit_excess(&mem->res);
-	spin_lock(&mctz->lock);
 	while (*p) {
 		parent = *p;
 		mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
@@ -328,6 +338,26 @@ mem_cgroup_insert_exceeded(struct mem_cg
 	rb_link_node(&mz->tree_node, parent, p);
 	rb_insert_color(&mz->tree_node, &mctz->rb_root);
 	mz->on_tree = true;
+}
+
+static void
+__mem_cgroup_remove_exceeded(struct mem_cgroup *mem,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz)
+{
+	if (!mz->on_tree)
+		return;
+	rb_erase(&mz->tree_node, &mctz->rb_root);
+	mz->on_tree = false;
+}
+
+static void
+mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
+				struct mem_cgroup_per_zone *mz,
+				struct mem_cgroup_tree_per_zone *mctz)
+{
+	spin_lock(&mctz->lock);
+	__mem_cgroup_insert_exceeded(mem, mz, mctz);
 	spin_unlock(&mctz->lock);
 }
 
@@ -337,8 +367,7 @@ mem_cgroup_remove_exceeded(struct mem_cg
 				struct mem_cgroup_tree_per_zone *mctz)
 {
 	spin_lock(&mctz->lock);
-	rb_erase(&mz->tree_node, &mctz->rb_root);
-	mz->on_tree = false;
+	__mem_cgroup_remove_exceeded(mem, mz, mctz);
 	spin_unlock(&mctz->lock);
 }
 
@@ -410,6 +439,47 @@ static void mem_cgroup_remove_from_trees
 	}
 }
 
+static inline unsigned long mem_cgroup_get_excess(struct mem_cgroup *mem)
+{
+	return res_counter_soft_limit_excess(&mem->res) >> PAGE_SHIFT;
+}
+
+static struct mem_cgroup_per_zone *
+__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
+{
+	struct rb_node *rightmost = NULL;
+	struct mem_cgroup_per_zone *mz = NULL;
+
+retry:
+	rightmost = rb_last(&mctz->rb_root);
+	if (!rightmost)
+		goto done;		/* Nothing to reclaim from */
+
+	mz = rb_entry(rightmost, struct mem_cgroup_per_zone, tree_node);
+	/*
+	 * Remove the node now but someone else can add it back,
+	 * we will to add it back at the end of reclaim to its correct
+	 * position in the tree.
+	 */
+	__mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
+	if (!res_counter_soft_limit_excess(&mz->mem->res) ||
+		!css_tryget(&mz->mem->css))
+		goto retry;
+done:
+	return mz;
+}
+
+static struct mem_cgroup_per_zone *
+mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
+{
+	struct mem_cgroup_per_zone *mz;
+
+	spin_lock(&mctz->lock);
+	mz = __mem_cgroup_largest_soft_limit_node(mctz);
+	spin_unlock(&mctz->lock);
+	return mz;
+}
+
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
 					 bool charge)
@@ -1039,6 +1109,7 @@ mem_cgroup_select_victim(struct mem_cgro
  * If shrink==true, for avoiding to free too much, this returns immedieately.
  */
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
+						struct zone *zone,
 						gfp_t gfp_mask,
 						unsigned long reclaim_options)
 {
@@ -1047,23 +1118,49 @@ static int mem_cgroup_hierarchical_recla
 	int loop = 0;
 	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
 	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
+	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
+	unsigned long excess = mem_cgroup_get_excess(root_mem);
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
 	if (root_mem->memsw_is_minimum)
 		noswap = true;
 
-	while (loop < 2) {
+	while (1) {
 		victim = mem_cgroup_select_victim(root_mem);
-		if (victim == root_mem)
+		if (victim == root_mem) {
 			loop++;
+			if (loop >= 2) {
+				/*
+				 * If we have not been able to reclaim
+				 * anything, it might because there are
+				 * no reclaimable pages under this hierarchy
+				 */
+				if (!check_soft || !total)
+					break;
+				/*
+				 * We want to do more targetted reclaim.
+				 * excess >> 2 is not to excessive so as to
+				 * reclaim too much, nor too less that we keep
+				 * coming back to reclaim from this cgroup
+				 */
+				if (total >= (excess >> 2) ||
+					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
+					break;
+			}
+		}
 		if (!mem_cgroup_local_usage(&victim->stat)) {
 			/* this cgroup's local usage == 0 */
 			css_put(&victim->css);
 			continue;
 		}
 		/* we use swappiness of local cgroup */
-		ret = try_to_free_mem_cgroup_pages(victim, gfp_mask, noswap,
-						   get_swappiness(victim));
+		if (check_soft)
+			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
+				noswap, get_swappiness(victim), zone,
+				zone->zone_pgdat->node_id);
+		else
+			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
+						noswap, get_swappiness(victim));
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -1073,7 +1170,10 @@ static int mem_cgroup_hierarchical_recla
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
@@ -1208,8 +1308,8 @@ static int __mem_cgroup_try_charge(struc
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
-							flags);
+		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
+						gfp_mask, flags);
 		if (ret)
 			continue;
 
@@ -2020,8 +2120,9 @@ static int mem_cgroup_resize_limit(struc
 		if (!ret)
 			break;
 
-		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
-						   MEM_CGROUP_RECLAIM_SHRINK);
+		progress = mem_cgroup_hierarchical_reclaim(memcg, NULL,
+						GFP_KERNEL,
+						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
   		if (curusage >= oldusage)
@@ -2073,7 +2174,7 @@ static int mem_cgroup_resize_memsw_limit
 		if (!ret)
 			break;
 
-		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
+		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
 						MEM_CGROUP_RECLAIM_NOSWAP |
 						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
@@ -2086,6 +2187,88 @@ static int mem_cgroup_resize_memsw_limit
 	return ret;
 }
 
+unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+						gfp_t gfp_mask, int nid,
+						int zid)
+{
+	unsigned long nr_reclaimed = 0;
+	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
+	unsigned long reclaimed;
+	int loop = 0;
+	struct mem_cgroup_tree_per_zone *mctz;
+
+	if (order > 0)
+		return 0;
+
+	mctz = soft_limit_tree_node_zone(nid, zid);
+	/*
+	 * This loop can run a while, specially if mem_cgroup's continuously
+	 * keep exceeding their soft limit and putting the system under
+	 * pressure
+	 */
+	do {
+		if (next_mz)
+			mz = next_mz;
+		else
+			mz = mem_cgroup_largest_soft_limit_node(mctz);
+		if (!mz)
+			break;
+
+		reclaimed = mem_cgroup_hierarchical_reclaim(mz->mem, zone,
+						gfp_mask,
+						MEM_CGROUP_RECLAIM_SOFT);
+		nr_reclaimed += reclaimed;
+		spin_lock(&mctz->lock);
+
+		/*
+		 * If we failed to reclaim anything from this memory cgroup
+		 * it is time to move on to the next cgroup
+		 */
+		next_mz = NULL;
+		if (!reclaimed) {
+			do {
+				/*
+				 * By the time we get the soft_limit lock
+				 * again, someone might have aded the
+				 * group back on the RB tree. Iterate to
+				 * make sure we get a different mem.
+				 * mem_cgroup_largest_soft_limit_node returns
+				 * NULL if no other cgroup is present on
+				 * the tree
+				 */
+				next_mz =
+				__mem_cgroup_largest_soft_limit_node(mctz);
+			} while (next_mz == mz);
+		}
+		mz->usage_in_excess =
+			res_counter_soft_limit_excess(&mz->mem->res);
+		__mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
+		/*
+		 * One school of thought says that we should not add
+		 * back the node to the tree if reclaim returns 0.
+		 * But our reclaim could return 0, simply because due
+		 * to priority we are exposing a smaller subset of
+		 * memory to reclaim from. Consider this as a longer
+		 * term TODO.
+		 */
+		if (mz->usage_in_excess)
+			__mem_cgroup_insert_exceeded(mz->mem, mz, mctz);
+		spin_unlock(&mctz->lock);
+		css_put(&mz->mem->css);
+		loop++;
+		/*
+		 * Could not reclaim anything and there are no more
+		 * mem cgroups to try or we seem to be looping without
+		 * reclaiming anything.
+		 */
+		if (!nr_reclaimed &&
+			(next_mz == NULL ||
+			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
+			break;
+	} while (!nr_reclaimed);
+	return nr_reclaimed;
+}
+
 /*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
@@ -2688,6 +2871,8 @@ static int alloc_mem_cgroup_per_zone_inf
 		for_each_lru(l)
 			INIT_LIST_HEAD(&mz->lists[l]);
 		mz->usage_in_excess = 0;
+		mz->on_tree = false;
+		mz->mem = mem;
 	}
 	return 0;
 }
diff -puN mm/vmscan.c~memory-controller-soft-limit-reclaim-on-contention-v9 mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-soft-limit-reclaim-on-contention-v9
+++ a/mm/vmscan.c
@@ -1827,11 +1827,45 @@ unsigned long try_to_free_pages(struct z
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
+unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
+						gfp_t gfp_mask, bool noswap,
+						unsigned int swappiness,
+						struct zone *zone, int nid)
+{
+	struct scan_control sc = {
+		.may_writepage = !laptop_mode,
+		.may_unmap = 1,
+		.may_swap = !noswap,
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.swappiness = swappiness,
+		.order = 0,
+		.mem_cgroup = mem,
+		.isolate_pages = mem_cgroup_isolate_pages,
+	};
+	nodemask_t nm  = nodemask_of_node(nid);
+
+	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
+			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
+	sc.nodemask = &nm;
+	sc.nr_reclaimed = 0;
+	sc.nr_scanned = 0;
+	/*
+	 * NOTE: Although we can get the priority field, using it
+	 * here is not a good idea, since it limits the pages we can scan.
+	 * if we don't reclaim here, the shrink_zone from balance_pgdat
+	 * will pick up pages from other mem cgroup's as well. We hack
+	 * the priority and make it zero.
+	 */
+	shrink_zone(0, zone, &sc);
+	return sc.nr_reclaimed;
+}
+
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 					   gfp_t gfp_mask,
 					   bool noswap,
 					   unsigned int swappiness)
 {
+	struct zonelist *zonelist;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
@@ -1843,7 +1877,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.isolate_pages = mem_cgroup_isolate_pages,
 		.nodemask = NULL, /* we don't care the placement */
 	};
-	struct zonelist *zonelist;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -1965,6 +1998,7 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
+			int nid, zid;
 
 			if (!populated_zone(zone))
 				continue;
@@ -1979,6 +2013,15 @@ loop_again:
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
+
+			nid = pgdat->node_id;
+			zid = zone_idx(zone);
+			/*
+			 * Call soft limit reclaim before calling shrink_zone.
+			 * For now we ignore the return value
+			 */
+			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask,
+							nid, zid);
 			/*
 			 * We put equal pressure on every zone, unless one
 			 * zone has way too many pages free already.
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

