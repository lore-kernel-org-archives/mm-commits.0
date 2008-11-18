From: akpm@linux-foundation.org
Subject: + memory-cgroup-hierarchical-reclaim-v4.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:31:34 -0800
Message-ID: <200811182331.mAINVYhi026130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbYKRXbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:31:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: memory cgroup hierarchical reclaim
has been added to the -mm tree.  Its filename is
     memory-cgroup-hierarchical-reclaim-v4.patch

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
Subject: memcg: memory cgroup hierarchical reclaim
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch introduces hierarchical reclaim.  When an ancestor goes over
its limit, the charging routine points to the parent that is above its
limit.  The reclaim process then starts from the last scanned child of the
ancestor and reclaims until the ancestor goes below its limit.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  170 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 167 insertions(+), 3 deletions(-)

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
@@ -461,6 +468,153 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
+static struct mem_cgroup *
+mem_cgroup_from_res_counter(struct res_counter *counter)
+{
+	return container_of(counter, struct mem_cgroup, res);
+}
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
+		if (res_counter_check_under_limit(&root_mem->res)) {
+			return 0;
+		}
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
@@ -469,7 +623,7 @@ static int __mem_cgroup_try_charge(struc
 			gfp_t gfp_mask, struct mem_cgroup **memcg,
 			bool oom)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct res_counter *fail_res;
 	/*
@@ -515,8 +669,16 @@ static int __mem_cgroup_try_charge(struc
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		if (try_to_free_mem_cgroup_pages(mem, gfp_mask, noswap))
-			continue;
+		/*
+		 * Is one of our ancestors over their limit?
+		 */
+		if (fail_res)
+			mem_over_limit = mem_cgroup_from_res_counter(fail_res);
+		else
+			mem_over_limit = mem;
+
+		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
+							noswap);
 
 		/*
 		 * try_to_free_mem_cgroup_pages() might not give us a full
@@ -1722,6 +1884,8 @@ mem_cgroup_create(struct cgroup_subsys *
 	res_counter_init(&mem->memsw, parent ? &parent->memsw : NULL);
 
 
+	mem->last_scanned_child = NULL;
+
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchy-feature-selector-v4.patch

