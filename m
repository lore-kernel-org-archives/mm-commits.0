From: akpm@linux-foundation.org
Subject: [merged] memcg-use-css-id.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:25 -0700
Message-ID: <200904061934.n36JYPnP011631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757565AbZDFUgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: use CSS ID
has been removed from the -mm tree.  Its filename was
     memcg-use-css-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: use CSS ID
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Assigning CSS ID for each memcg and use css_get_next() for scanning hierarchy.

	Assume folloing tree.

	group_A (ID=3)
		/01 (ID=4)
		   /0A (ID=7)
		/02 (ID=10)
	group_B (ID=5)
	and task in group_A/01/0A hits limit at group_A.

	reclaim will be done in following order (round-robin).
	group_A(3) -> group_A/01 (4) -> group_A/01/0A (7) -> group_A/02(10)
	-> group_A -> .....

	Round robin by ID. The last visited cgroup is recorded and restart
	from it when it start reclaim again.
	(More smart algorithm can be implemented..)

	No cgroup_mutex or hierarchy_mutex is required.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  220 +++++++++++++++++-----------------------------
 1 file changed, 82 insertions(+), 138 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-css-id mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css-id
+++ a/mm/memcontrol.c
@@ -95,6 +95,15 @@ static s64 mem_cgroup_read_stat(struct m
 	return ret;
 }
 
+static s64 mem_cgroup_local_usage(struct mem_cgroup_stat *stat)
+{
+	s64 ret;
+
+	ret = mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_CACHE);
+	ret += mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_RSS);
+	return ret;
+}
+
 /*
  * per-zone information in memory controller.
  */
@@ -154,9 +163,9 @@ struct mem_cgroup {
 
 	/*
 	 * While reclaiming in a hiearchy, we cache the last child we
-	 * reclaimed from. Protected by hierarchy_mutex
+	 * reclaimed from.
 	 */
-	struct mem_cgroup *last_scanned_child;
+	int last_scanned_child;
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
@@ -629,103 +638,6 @@ unsigned long mem_cgroup_isolate_pages(u
 #define mem_cgroup_from_res_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
-/*
- * This routine finds the DFS walk successor. This routine should be
- * called with hierarchy_mutex held
- */
-static struct mem_cgroup *
-__mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
-{
-	struct cgroup *cgroup, *curr_cgroup, *root_cgroup;
-
-	curr_cgroup = curr->css.cgroup;
-	root_cgroup = root_mem->css.cgroup;
-
-	if (!list_empty(&curr_cgroup->children)) {
-		/*
-		 * Walk down to children
-		 */
-		cgroup = list_entry(curr_cgroup->children.next,
-						struct cgroup, sibling);
-		curr = mem_cgroup_from_cont(cgroup);
-		goto done;
-	}
-
-visit_parent:
-	if (curr_cgroup == root_cgroup) {
-		/* caller handles NULL case */
-		curr = NULL;
-		goto done;
-	}
-
-	/*
-	 * Goto next sibling
-	 */
-	if (curr_cgroup->sibling.next != &curr_cgroup->parent->children) {
-		cgroup = list_entry(curr_cgroup->sibling.next, struct cgroup,
-						sibling);
-		curr = mem_cgroup_from_cont(cgroup);
-		goto done;
-	}
-
-	/*
-	 * Go up to next parent and next parent's sibling if need be
-	 */
-	curr_cgroup = curr_cgroup->parent;
-	goto visit_parent;
-
-done:
-	return curr;
-}
-
-/*
- * Visit the first child (need not be the first child as per the ordering
- * of the cgroup list, since we track last_scanned_child) of @mem and use
- * that to reclaim free pages from.
- */
-static struct mem_cgroup *
-mem_cgroup_get_next_node(struct mem_cgroup *root_mem)
-{
-	struct cgroup *cgroup;
-	struct mem_cgroup *orig, *next;
-	bool obsolete;
-
-	/*
-	 * Scan all children under the mem_cgroup mem
-	 */
-	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
-
-	orig = root_mem->last_scanned_child;
-	obsolete = mem_cgroup_is_obsolete(orig);
-
-	if (list_empty(&root_mem->css.cgroup->children)) {
-		/*
-		 * root_mem might have children before and last_scanned_child
-		 * may point to one of them. We put it later.
-		 */
-		if (orig)
-			VM_BUG_ON(!obsolete);
-		next = NULL;
-		goto done;
-	}
-
-	if (!orig || obsolete) {
-		cgroup = list_first_entry(&root_mem->css.cgroup->children,
-				struct cgroup, sibling);
-		next = mem_cgroup_from_cont(cgroup);
-	} else
-		next = __mem_cgroup_get_next_node(orig, root_mem);
-
-done:
-	if (next)
-		mem_cgroup_get(next);
-	root_mem->last_scanned_child = next;
-	if (orig)
-		mem_cgroup_put(orig);
-	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
-	return (next) ? next : root_mem;
-}
-
 static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
 {
 	if (do_swap_account) {
@@ -755,46 +667,79 @@ static unsigned int get_swappiness(struc
 }
 
 /*
- * Dance down the hierarchy if needed to reclaim memory. We remember the
- * last child we reclaimed from, so that we don't end up penalizing
- * one child extensively based on its position in the children list.
+ * Visit the first child (need not be the first child as per the ordering
+ * of the cgroup list, since we track last_scanned_child) of @mem and use
+ * that to reclaim free pages from.
+ */
+static struct mem_cgroup *
+mem_cgroup_select_victim(struct mem_cgroup *root_mem)
+{
+	struct mem_cgroup *ret = NULL;
+	struct cgroup_subsys_state *css;
+	int nextid, found;
+
+	if (!root_mem->use_hierarchy) {
+		css_get(&root_mem->css);
+		ret = root_mem;
+	}
+
+	while (!ret) {
+		rcu_read_lock();
+		nextid = root_mem->last_scanned_child + 1;
+		css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
+				   &found);
+		if (css && css_tryget(css))
+			ret = container_of(css, struct mem_cgroup, css);
+
+		rcu_read_unlock();
+		/* Updates scanning parameter */
+		spin_lock(&root_mem->reclaim_param_lock);
+		if (!css) {
+			/* this means start scan from ID:1 */
+			root_mem->last_scanned_child = 0;
+		} else
+			root_mem->last_scanned_child = found;
+		spin_unlock(&root_mem->reclaim_param_lock);
+	}
+
+	return ret;
+}
+
+/*
+ * Scan the hierarchy if needed to reclaim memory. We remember the last child
+ * we reclaimed from, so that we don't end up penalizing one child extensively
+ * based on its position in the children list.
  *
  * root_mem is the original ancestor that we've been reclaim from.
+ *
+ * We give up and return to the caller when we visit root_mem twice.
+ * (other groups can be removed while we're walking....)
  */
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 						gfp_t gfp_mask, bool noswap)
 {
-	struct mem_cgroup *next_mem;
-	int ret = 0;
-
-	/*
-	 * Reclaim unconditionally and don't check for return value.
-	 * We need to reclaim in the current group and down the tree.
-	 * One might think about checking for children before reclaiming,
-	 * but there might be left over accounting, even after children
-	 * have left.
-	 */
-	ret += try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
-					   get_swappiness(root_mem));
-	if (mem_cgroup_check_under_limit(root_mem))
-		return 1;	/* indicate reclaim has succeeded */
-	if (!root_mem->use_hierarchy)
-		return ret;
-
-	next_mem = mem_cgroup_get_next_node(root_mem);
-
-	while (next_mem != root_mem) {
-		if (mem_cgroup_is_obsolete(next_mem)) {
-			next_mem = mem_cgroup_get_next_node(root_mem);
+	struct mem_cgroup *victim;
+	int ret, total = 0;
+	int loop = 0;
+
+	while (loop < 2) {
+		victim = mem_cgroup_select_victim(root_mem);
+		if (victim == root_mem)
+			loop++;
+		if (!mem_cgroup_local_usage(&victim->stat)) {
+			/* this cgroup's local usage == 0 */
+			css_put(&victim->css);
 			continue;
 		}
-		ret += try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
-						   get_swappiness(next_mem));
+		/* we use swappiness of local cgroup */
+		ret = try_to_free_mem_cgroup_pages(victim, gfp_mask, noswap,
+						   get_swappiness(victim));
+		css_put(&victim->css);
+		total += ret;
 		if (mem_cgroup_check_under_limit(root_mem))
-			return 1;	/* indicate reclaim has succeeded */
-		next_mem = mem_cgroup_get_next_node(root_mem);
+			return 1 + total;
 	}
-	return ret;
+	return total;
 }
 
 bool mem_cgroup_oom_called(struct task_struct *task)
@@ -1324,8 +1269,8 @@ __mem_cgroup_uncharge_common(struct page
 	res_counter_uncharge(&mem->res, PAGE_SIZE);
 	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
 		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-
 	mem_cgroup_charge_statistics(mem, pc, false);
+
 	ClearPageCgroupUsed(pc);
 	/*
 	 * pc->mem_cgroup is not cleared here. It will be accessed when it's
@@ -2178,6 +2123,8 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	free_css_id(&mem_cgroup_subsys, &mem->css);
+
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
@@ -2228,11 +2175,12 @@ static struct cgroup_subsys_state * __re
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem, *parent;
+	long error = -ENOMEM;
 	int node;
 
 	mem = mem_cgroup_alloc();
 	if (!mem)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(error);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
@@ -2260,7 +2208,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->res, NULL);
 		res_counter_init(&mem->memsw, NULL);
 	}
-	mem->last_scanned_child = NULL;
+	mem->last_scanned_child = 0;
 	spin_lock_init(&mem->reclaim_param_lock);
 
 	if (parent)
@@ -2269,7 +2217,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(error);
 }
 
 static int mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
@@ -2284,12 +2232,7 @@ static void mem_cgroup_destroy(struct cg
 				struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	struct mem_cgroup *last_scanned_child = mem->last_scanned_child;
 
-	if (last_scanned_child) {
-		VM_BUG_ON(!mem_cgroup_is_obsolete(last_scanned_child));
-		mem_cgroup_put(last_scanned_child);
-	}
 	mem_cgroup_put(mem);
 }
 
@@ -2328,6 +2271,7 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
+	.use_id = 1,
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch

