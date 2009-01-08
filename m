From: akpm@linux-foundation.org
Subject: - memory-cgroup-hierarchical-reclaim-v4.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:39 -0800
Message-ID: <200901082248.n08MmdHU027988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761197AbZAHW7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, xemul@o


The patch titled
     memcg: memory cgroup hierarchical reclaim
has been removed from the -mm tree.  Its filename was
     memory-cgroup-hierarchical-reclaim-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memory cgroup hierarchical reclaim
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch introduces hierarchical reclaim.  When an ancestor goes over
its limit, the charging routine points to the parent that is above its
limit.  The reclaim process then starts from the last scanned child of the
ancestor and reclaims until the ancestor goes below its limit.

[akpm@linux-foundation.org: coding-style fixes]
[d-nishimura@mtf.biglobe.ne.jp: mem_cgroup_from_res_counter should handle both mem->res and mem->memsw]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  166 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 162 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-hierarchical-reclaim-v4 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-hierarchical-reclaim-v4
+++ a/mm/memcontrol.c
@@ -143,6 +143,13 @@ struct mem_cgroup {
 	struct mem_cgroup_lru_info info;
 
 	int	prev_priority;	/* for recording reclaim priority */
+
+	/*
+	 * While reclaiming in a hiearchy, we cache the last child we
+	 * reclaimed from. Protected by cgroup_lock()
+	 */
+	struct mem_cgroup *last_scanned_child;
+
 	int		obsolete;
 	atomic_t	refcnt;
 	/*
@@ -461,6 +468,149 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
+#define mem_cgroup_from_res_counter(counter, member)	\
+	container_of(counter, struct mem_cgroup, member)
+
+/*
+ * This routine finds the DFS walk successor. This routine should be
+ * called with cgroup_mutex held
+ */
+static struct mem_cgroup *
+mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
+{
+	struct cgroup *cgroup, *curr_cgroup, *root_cgroup;
+
+	curr_cgroup = curr->css.cgroup;
+	root_cgroup = root_mem->css.cgroup;
+
+	if (!list_empty(&curr_cgroup->children)) {
+		/*
+		 * Walk down to children
+		 */
+		mem_cgroup_put(curr);
+		cgroup = list_entry(curr_cgroup->children.next,
+						struct cgroup, sibling);
+		curr = mem_cgroup_from_cont(cgroup);
+		mem_cgroup_get(curr);
+		goto done;
+	}
+
+visit_parent:
+	if (curr_cgroup == root_cgroup) {
+		mem_cgroup_put(curr);
+		curr = root_mem;
+		mem_cgroup_get(curr);
+		goto done;
+	}
+
+	/*
+	 * Goto next sibling
+	 */
+	if (curr_cgroup->sibling.next != &curr_cgroup->parent->children) {
+		mem_cgroup_put(curr);
+		cgroup = list_entry(curr_cgroup->sibling.next, struct cgroup,
+						sibling);
+		curr = mem_cgroup_from_cont(cgroup);
+		mem_cgroup_get(curr);
+		goto done;
+	}
+
+	/*
+	 * Go up to next parent and next parent's sibling if need be
+	 */
+	curr_cgroup = curr_cgroup->parent;
+	goto visit_parent;
+
+done:
+	root_mem->last_scanned_child = curr;
+	return curr;
+}
+
+/*
+ * Visit the first child (need not be the first child as per the ordering
+ * of the cgroup list, since we track last_scanned_child) of @mem and use
+ * that to reclaim free pages from.
+ */
+static struct mem_cgroup *
+mem_cgroup_get_first_node(struct mem_cgroup *root_mem)
+{
+	struct cgroup *cgroup;
+	struct mem_cgroup *ret;
+	bool obsolete = (root_mem->last_scanned_child &&
+				root_mem->last_scanned_child->obsolete);
+
+	/*
+	 * Scan all children under the mem_cgroup mem
+	 */
+	cgroup_lock();
+	if (list_empty(&root_mem->css.cgroup->children)) {
+		ret = root_mem;
+		goto done;
+	}
+
+	if (!root_mem->last_scanned_child || obsolete) {
+
+		if (obsolete)
+			mem_cgroup_put(root_mem->last_scanned_child);
+
+		cgroup = list_first_entry(&root_mem->css.cgroup->children,
+				struct cgroup, sibling);
+		ret = mem_cgroup_from_cont(cgroup);
+		mem_cgroup_get(ret);
+	} else
+		ret = mem_cgroup_get_next_node(root_mem->last_scanned_child,
+						root_mem);
+
+done:
+	root_mem->last_scanned_child = ret;
+	cgroup_unlock();
+	return ret;
+}
+
+/*
+ * Dance down the hierarchy if needed to reclaim memory. We remember the
+ * last child we reclaimed from, so that we don't end up penalizing
+ * one child extensively based on its position in the children list.
+ *
+ * root_mem is the original ancestor that we've been reclaim from.
+ */
+static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
+						gfp_t gfp_mask, bool noswap)
+{
+	struct mem_cgroup *next_mem;
+	int ret = 0;
+
+	/*
+	 * Reclaim unconditionally and don't check for return value.
+	 * We need to reclaim in the current group and down the tree.
+	 * One might think about checking for children before reclaiming,
+	 * but there might be left over accounting, even after children
+	 * have left.
+	 */
+	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
+	if (res_counter_check_under_limit(&root_mem->res))
+		return 0;
+
+	next_mem = mem_cgroup_get_first_node(root_mem);
+
+	while (next_mem != root_mem) {
+		if (next_mem->obsolete) {
+			mem_cgroup_put(next_mem);
+			cgroup_lock();
+			next_mem = mem_cgroup_get_first_node(root_mem);
+			cgroup_unlock();
+			continue;
+		}
+		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
+		if (res_counter_check_under_limit(&root_mem->res))
+			return 0;
+		cgroup_lock();
+		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
+		cgroup_unlock();
+	}
+	return ret;
+}
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -469,7 +619,7 @@ static int __mem_cgroup_try_charge(struc
 			gfp_t gfp_mask, struct mem_cgroup **memcg,
 			bool oom)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct res_counter *fail_res;
 	/*
@@ -511,12 +661,18 @@ static int __mem_cgroup_try_charge(struc
 			/* mem+swap counter fails */
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			noswap = true;
-		}
+			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
+									memsw);
+		} else
+			/* mem counter fails */
+			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
+									res);
+
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		if (try_to_free_mem_cgroup_pages(mem, gfp_mask, noswap))
-			continue;
+		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
+							noswap);
 
 		/*
 		 * try_to_free_mem_cgroup_pages() might not give us a full
@@ -1732,6 +1888,8 @@ mem_cgroup_create(struct cgroup_subsys *
 	res_counter_init(&mem->memsw, parent ? &parent->memsw : NULL);
 
 
+	mem->last_scanned_child = NULL;
+
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch

