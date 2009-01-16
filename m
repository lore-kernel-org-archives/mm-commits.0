From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-hierarchical-reclaim.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:29 -0800
Message-ID: <200901161917.n0GJHTVx026072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936742AbZAPTR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: fix hierarchical reclaim
has been removed from the -mm tree.  Its filename was
     memcg-fix-hierarchical-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix hierarchical reclaim
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

If root_mem has no children, last_scaned_child is set to root_mem itself. 
But after some children added to root_mem, mem_cgroup_get_next_node can
mem_cgroup_put the root_mem although root_mem has not been mem_cgroup_get.

This patch fixes this behavior by:

- Set last_scanned_child to NULL if root_mem has no children or DFS
  search has returned to root_mem itself(root_mem is not a "child" of
  root_mem).  Make mem_cgroup_get_first_node return root_mem in this case.
   There are no mem_cgroup_get/put for root_mem.

- Rename mem_cgroup_get_next_node to __mem_cgroup_get_next_node, and
  mem_cgroup_get_first_node to mem_cgroup_get_next_node.  Make
  mem_cgroup_hierarchical_reclaim call only new mem_cgroup_get_next_node.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   68 ++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-hierarchical-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-hierarchical-reclaim
+++ a/mm/memcontrol.c
@@ -633,7 +633,7 @@ unsigned long mem_cgroup_isolate_pages(u
  * called with hierarchy_mutex held
  */
 static struct mem_cgroup *
-mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
+__mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
 {
 	struct cgroup *cgroup, *curr_cgroup, *root_cgroup;
 
@@ -644,19 +644,16 @@ mem_cgroup_get_next_node(struct mem_cgro
 		/*
 		 * Walk down to children
 		 */
-		mem_cgroup_put(curr);
 		cgroup = list_entry(curr_cgroup->children.next,
 						struct cgroup, sibling);
 		curr = mem_cgroup_from_cont(cgroup);
-		mem_cgroup_get(curr);
 		goto done;
 	}
 
 visit_parent:
 	if (curr_cgroup == root_cgroup) {
-		mem_cgroup_put(curr);
-		curr = root_mem;
-		mem_cgroup_get(curr);
+		/* caller handles NULL case */
+		curr = NULL;
 		goto done;
 	}
 
@@ -664,11 +661,9 @@ visit_parent:
 	 * Goto next sibling
 	 */
 	if (curr_cgroup->sibling.next != &curr_cgroup->parent->children) {
-		mem_cgroup_put(curr);
 		cgroup = list_entry(curr_cgroup->sibling.next, struct cgroup,
 						sibling);
 		curr = mem_cgroup_from_cont(cgroup);
-		mem_cgroup_get(curr);
 		goto done;
 	}
 
@@ -679,7 +674,6 @@ visit_parent:
 	goto visit_parent;
 
 done:
-	root_mem->last_scanned_child = curr;
 	return curr;
 }
 
@@ -689,40 +683,46 @@ done:
  * that to reclaim free pages from.
  */
 static struct mem_cgroup *
-mem_cgroup_get_first_node(struct mem_cgroup *root_mem)
+mem_cgroup_get_next_node(struct mem_cgroup *root_mem)
 {
 	struct cgroup *cgroup;
-	struct mem_cgroup *ret;
+	struct mem_cgroup *orig, *next;
 	bool obsolete;
 
-	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
-
 	/*
 	 * Scan all children under the mem_cgroup mem
 	 */
 	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
+
+	orig = root_mem->last_scanned_child;
+	obsolete = mem_cgroup_is_obsolete(orig);
+
 	if (list_empty(&root_mem->css.cgroup->children)) {
-		ret = root_mem;
+		/*
+		 * root_mem might have children before and last_scanned_child
+		 * may point to one of them. We put it later.
+		 */
+		if (orig)
+			VM_BUG_ON(!obsolete);
+		next = NULL;
 		goto done;
 	}
 
-	if (!root_mem->last_scanned_child || obsolete) {
-
-		if (obsolete && root_mem->last_scanned_child)
-			mem_cgroup_put(root_mem->last_scanned_child);
-
+	if (!orig || obsolete) {
 		cgroup = list_first_entry(&root_mem->css.cgroup->children,
 				struct cgroup, sibling);
-		ret = mem_cgroup_from_cont(cgroup);
-		mem_cgroup_get(ret);
+		next = mem_cgroup_from_cont(cgroup);
 	} else
-		ret = mem_cgroup_get_next_node(root_mem->last_scanned_child,
-						root_mem);
+		next = __mem_cgroup_get_next_node(orig, root_mem);
 
 done:
-	root_mem->last_scanned_child = ret;
+	if (next)
+		mem_cgroup_get(next);
+	root_mem->last_scanned_child = next;
+	if (orig)
+		mem_cgroup_put(orig);
 	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
-	return ret;
+	return (next) ? next : root_mem;
 }
 
 static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
@@ -780,21 +780,18 @@ static int mem_cgroup_hierarchical_recla
 	if (!root_mem->use_hierarchy)
 		return ret;
 
-	next_mem = mem_cgroup_get_first_node(root_mem);
+	next_mem = mem_cgroup_get_next_node(root_mem);
 
 	while (next_mem != root_mem) {
 		if (mem_cgroup_is_obsolete(next_mem)) {
-			mem_cgroup_put(next_mem);
-			next_mem = mem_cgroup_get_first_node(root_mem);
+			next_mem = mem_cgroup_get_next_node(root_mem);
 			continue;
 		}
 		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
 						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
 			return 0;
-		mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
-		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
-		mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
+		next_mem = mem_cgroup_get_next_node(root_mem);
 	}
 	return ret;
 }
@@ -2254,7 +2251,14 @@ static void mem_cgroup_pre_destroy(struc
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	mem_cgroup_put(mem_cgroup_from_cont(cont));
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	struct mem_cgroup *last_scanned_child = mem->last_scanned_child;
+
+	if (last_scanned_child) {
+		VM_BUG_ON(!mem_cgroup_is_obsolete(last_scanned_child));
+		mem_cgroup_put(last_scanned_child);
+	}
+	mem_cgroup_put(mem);
 }
 
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-get-put-parents-at-create-free.patch

