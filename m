From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-consolidate-hierarchy-iteration-primitives.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:23 -0800
Message-ID: <20120113203224.BF71D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56633 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2AMUca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:30 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23612eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: consolidate hierarchy iteration primitives
has been removed from the -mm tree.  Its filename was
     mm-memcg-consolidate-hierarchy-iteration-primitives.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: consolidate hierarchy iteration primitives

The memcg naturalization series:

Memory control groups are currently bolted onto the side of
traditional memory management in places where better integration would
be preferrable.  To reclaim memory, for example, memory control groups
maintain their own LRU list and reclaim strategy aside from the global
per-zone LRU list reclaim.  But an extra list head for each existing
page frame is expensive and maintaining it requires additional code.

This patchset disables the global per-zone LRU lists on memory cgroup
configurations and converts all its users to operate on the per-memory
cgroup lists instead.  As LRU pages are then exclusively on one list,
this saves two list pointers for each page frame in the system:

page_cgroup array size with 4G physical memory

  vanilla: [    0.000000] allocated 31457280 bytes of page_cgroup
  patched: [    0.000000] allocated 15728640 bytes of page_cgroup

At the same time, system performance for various workloads is
unaffected:

100G sparse file cat, 4G physical memory, 10 runs, to test for code
bloat in the traditional LRU handling and kswapd & direct reclaim
paths, without/with the memory controller configured in

  vanilla: 71.603(0.207) seconds
  patched: 71.640(0.156) seconds

  vanilla: 79.558(0.288) seconds
  patched: 77.233(0.147) seconds

100G sparse file cat in 1G memory cgroup, 10 runs, to test for code
bloat in the traditional memory cgroup LRU handling and reclaim path

  vanilla: 96.844(0.281) seconds
  patched: 94.454(0.311) seconds

4 unlimited memcgs running kbuild -j32 each, 4G physical memory, 500M
swap on SSD, 10 runs, to test for regressions in kswapd & direct
reclaim using per-memcg LRU lists with multiple memcgs and multiple
allocators within each memcg

  vanilla: 717.722(1.440) seconds [ 69720.100(11600.835) majfaults ]
  patched: 714.106(2.313) seconds [ 71109.300(14886.186) majfaults ]

16 unlimited memcgs running kbuild, 1900M hierarchical limit, 500M
swap on SSD, 10 runs, to test for regressions in hierarchical memcg
setups

  vanilla: 2742.058(1.992) seconds [ 26479.600(1736.737) majfaults ]
  patched: 2743.267(1.214) seconds [ 27240.700(1076.063) majfaults ]

This patch:

There are currently two different implementations of iterating over a
memory cgroup hierarchy tree.

Consolidate them into one worker function and base the convenience
looping-macros on top of it.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  199 +++++++++++++++++-----------------------------
 1 file changed, 75 insertions(+), 124 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-consolidate-hierarchy-iteration-primitives mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-consolidate-hierarchy-iteration-primitives
+++ a/mm/memcontrol.c
@@ -853,83 +853,76 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return memcg;
 }
 
-/* The caller has to guarantee "mem" exists before calling this */
-static struct mem_cgroup *mem_cgroup_start_loop(struct mem_cgroup *memcg)
+static struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
+					  struct mem_cgroup *prev,
+					  bool reclaim)
 {
-	struct cgroup_subsys_state *css;
-	int found;
+	struct mem_cgroup *memcg = NULL;
+	int id = 0;
 
-	if (!memcg) /* ROOT cgroup has the smallest ID */
-		return root_mem_cgroup; /*css_put/get against root is ignored*/
-	if (!memcg->use_hierarchy) {
-		if (css_tryget(&memcg->css))
-			return memcg;
-		return NULL;
-	}
-	rcu_read_lock();
-	/*
-	 * searching a memory cgroup which has the smallest ID under given
-	 * ROOT cgroup. (ID >= 1)
-	 */
-	css = css_get_next(&mem_cgroup_subsys, 1, &memcg->css, &found);
-	if (css && css_tryget(css))
-		memcg = container_of(css, struct mem_cgroup, css);
-	else
-		memcg = NULL;
-	rcu_read_unlock();
-	return memcg;
-}
+	if (!root)
+		root = root_mem_cgroup;
 
-static struct mem_cgroup *mem_cgroup_get_next(struct mem_cgroup *iter,
-					struct mem_cgroup *root,
-					bool cond)
-{
-	int nextid = css_id(&iter->css) + 1;
-	int found;
-	int hierarchy_used;
-	struct cgroup_subsys_state *css;
+	if (prev && !reclaim)
+		id = css_id(&prev->css);
 
-	hierarchy_used = iter->use_hierarchy;
+	if (prev && prev != root)
+		css_put(&prev->css);
 
-	css_put(&iter->css);
-	/* If no ROOT, walk all, ignore hierarchy */
-	if (!cond || (root && !hierarchy_used))
-		return NULL;
+	if (!root->use_hierarchy && root != root_mem_cgroup) {
+		if (prev)
+			return NULL;
+		return root;
+	}
 
-	if (!root)
-		root = root_mem_cgroup;
+	while (!memcg) {
+		struct cgroup_subsys_state *css;
 
-	do {
-		iter = NULL;
-		rcu_read_lock();
+		if (reclaim)
+			id = root->last_scanned_child;
 
-		css = css_get_next(&mem_cgroup_subsys, nextid,
-				&root->css, &found);
-		if (css && css_tryget(css))
-			iter = container_of(css, struct mem_cgroup, css);
+		rcu_read_lock();
+		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
+		if (css) {
+			if (css == &root->css || css_tryget(css))
+				memcg = container_of(css,
+						     struct mem_cgroup, css);
+		} else
+			id = 0;
 		rcu_read_unlock();
-		/* If css is NULL, no more cgroups will be found */
-		nextid = found + 1;
-	} while (css && !iter);
 
-	return iter;
+		if (reclaim)
+			root->last_scanned_child = id;
+
+		if (prev && !css)
+			return NULL;
+	}
+	return memcg;
 }
-/*
- * for_eacn_mem_cgroup_tree() for visiting all cgroup under tree. Please
- * be careful that "break" loop is not allowed. We have reference count.
- * Instead of that modify "cond" to be false and "continue" to exit the loop.
- */
-#define for_each_mem_cgroup_tree_cond(iter, root, cond)	\
-	for (iter = mem_cgroup_start_loop(root);\
-	     iter != NULL;\
-	     iter = mem_cgroup_get_next(iter, root, cond))
 
-#define for_each_mem_cgroup_tree(iter, root) \
-	for_each_mem_cgroup_tree_cond(iter, root, true)
+static void mem_cgroup_iter_break(struct mem_cgroup *root,
+				  struct mem_cgroup *prev)
+{
+	if (!root)
+		root = root_mem_cgroup;
+	if (prev && prev != root)
+		css_put(&prev->css);
+}
 
-#define for_each_mem_cgroup_all(iter) \
-	for_each_mem_cgroup_tree_cond(iter, NULL, true)
+/*
+ * Iteration constructs for visiting all cgroups (under a tree).  If
+ * loops are exited prematurely (break), mem_cgroup_iter_break() must
+ * be used for reference counting.
+ */
+#define for_each_mem_cgroup_tree(iter, root)		\
+	for (iter = mem_cgroup_iter(root, NULL, false);	\
+	     iter != NULL;				\
+	     iter = mem_cgroup_iter(root, iter, false))
 
+#define for_each_mem_cgroup(iter)			\
+	for (iter = mem_cgroup_iter(NULL, NULL, false);	\
+	     iter != NULL;				\
+	     iter = mem_cgroup_iter(NULL, iter, false))
 
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
@@ -1536,43 +1529,6 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	return min(limit, memsw);
 }
 
-/*
- * Visit the first child (need not be the first child as per the ordering
- * of the cgroup list, since we track last_scanned_child) of @mem and use
- * that to reclaim free pages from.
- */
-static struct mem_cgroup *
-mem_cgroup_select_victim(struct mem_cgroup *root_memcg)
-{
-	struct mem_cgroup *ret = NULL;
-	struct cgroup_subsys_state *css;
-	int nextid, found;
-
-	if (!root_memcg->use_hierarchy) {
-		css_get(&root_memcg->css);
-		ret = root_memcg;
-	}
-
-	while (!ret) {
-		rcu_read_lock();
-		nextid = root_memcg->last_scanned_child + 1;
-		css = css_get_next(&mem_cgroup_subsys, nextid, &root_memcg->css,
-				   &found);
-		if (css && css_tryget(css))
-			ret = container_of(css, struct mem_cgroup, css);
-
-		rcu_read_unlock();
-		/* Updates scanning parameter */
-		if (!css) {
-			/* this means start scan from ID:1 */
-			root_memcg->last_scanned_child = 0;
-		} else
-			root_memcg->last_scanned_child = found;
-	}
-
-	return ret;
-}
-
 /**
  * test_mem_cgroup_node_reclaimable
  * @mem: the target memcg
@@ -1728,7 +1684,7 @@ static int mem_cgroup_hierarchical_recla
 						unsigned long reclaim_options,
 						unsigned long *total_scanned)
 {
-	struct mem_cgroup *victim;
+	struct mem_cgroup *victim = NULL;
 	int ret, total = 0;
 	int loop = 0;
 	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
@@ -1744,8 +1700,8 @@ static int mem_cgroup_hierarchical_recla
 		noswap = true;
 
 	while (1) {
-		victim = mem_cgroup_select_victim(root_memcg);
-		if (victim == root_memcg) {
+		victim = mem_cgroup_iter(root_memcg, victim, true);
+		if (!victim) {
 			loop++;
 			/*
 			 * We are not draining per cpu cached charges during
@@ -1761,10 +1717,8 @@ static int mem_cgroup_hierarchical_recla
 				 * anything, it might because there are
 				 * no reclaimable pages under this hierarchy
 				 */
-				if (!check_soft || !total) {
-					css_put(&victim->css);
+				if (!check_soft || !total)
 					break;
-				}
 				/*
 				 * We want to do more targeted reclaim.
 				 * excess >> 2 is not to excessive so as to
@@ -1772,15 +1726,13 @@ static int mem_cgroup_hierarchical_recla
 				 * coming back to reclaim from this cgroup
 				 */
 				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS)) {
-					css_put(&victim->css);
+					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
 					break;
-				}
 			}
+			continue;
 		}
 		if (!mem_cgroup_reclaimable(victim, noswap)) {
 			/* this cgroup's local usage == 0 */
-			css_put(&victim->css);
 			continue;
 		}
 		/* we use swappiness of local cgroup */
@@ -1791,21 +1743,21 @@ static int mem_cgroup_hierarchical_recla
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap);
-		css_put(&victim->css);
+		total += ret;
 		/*
 		 * At shrinking usage, we can't check we should stop here or
 		 * reclaim more. It's depends on callers. last_scanned_child
 		 * will work enough for keeping fairness under tree.
 		 */
 		if (shrink)
-			return ret;
-		total += ret;
+			break;
 		if (check_soft) {
 			if (!res_counter_soft_limit_excess(&root_memcg->res))
-				return total;
+				break;
 		} else if (mem_cgroup_margin(root_memcg))
-			return total;
+			break;
 	}
+	mem_cgroup_iter_break(root_memcg, victim);
 	return total;
 }
 
@@ -1817,16 +1769,16 @@ static int mem_cgroup_hierarchical_recla
 static bool mem_cgroup_oom_lock(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *iter, *failed = NULL;
-	bool cond = true;
 
-	for_each_mem_cgroup_tree_cond(iter, memcg, cond) {
+	for_each_mem_cgroup_tree(iter, memcg) {
 		if (iter->oom_lock) {
 			/*
 			 * this subtree of our hierarchy is already locked
 			 * so we cannot give a lock.
 			 */
 			failed = iter;
-			cond = false;
+			mem_cgroup_iter_break(memcg, iter);
+			break;
 		} else
 			iter->oom_lock = true;
 	}
@@ -1838,11 +1790,10 @@ static bool mem_cgroup_oom_lock(struct m
 	 * OK, we failed to lock the whole subtree so we have to clean up
 	 * what we set up to the failing subtree
 	 */
-	cond = true;
-	for_each_mem_cgroup_tree_cond(iter, memcg, cond) {
+	for_each_mem_cgroup_tree(iter, memcg) {
 		if (iter == failed) {
-			cond = false;
-			continue;
+			mem_cgroup_iter_break(memcg, iter);
+			break;
 		}
 		iter->oom_lock = false;
 	}
@@ -2238,7 +2189,7 @@ static int __cpuinit memcg_cpu_hotplug_c
 	struct mem_cgroup *iter;
 
 	if ((action == CPU_ONLINE)) {
-		for_each_mem_cgroup_all(iter)
+		for_each_mem_cgroup(iter)
 			synchronize_mem_cgroup_on_move(iter, cpu);
 		return NOTIFY_OK;
 	}
@@ -2246,7 +2197,7 @@ static int __cpuinit memcg_cpu_hotplug_c
 	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
-	for_each_mem_cgroup_all(iter)
+	for_each_mem_cgroup(iter)
 		mem_cgroup_drain_pcp_counter(iter, cpu);
 
 	stock = &per_cpu(memcg_stock, cpu);
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

