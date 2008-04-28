From: akpm@linux-foundation.org
Subject: - mempolicy-move-rebind-functions.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:41 -0700
Message-ID: <200804282151.m3SLpfHY017593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964942AbYD1Vvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: move rebind functions
has been removed from the -mm tree.  Its filename was
     mempolicy-move-rebind-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: move rebind functions
From: David Rientjes <rientjes@google.com>

Move the mpol_rebind_{policy,task,mm}() functions after mpol_new() to avoid
having to declare function prototypes.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |  185 +++++++++++++++++++++++------------------------
 1 file changed, 91 insertions(+), 94 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-move-rebind-functions mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-move-rebind-functions
+++ a/mm/mempolicy.c
@@ -110,9 +110,6 @@ struct mempolicy default_policy = {
 	.policy = MPOL_DEFAULT,
 };
 
-static void mpol_rebind_policy(struct mempolicy *pol,
-                               const nodemask_t *newmask);
-
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(nodemask_t *nodemask)
 {
@@ -203,6 +200,97 @@ free:
 	return ERR_PTR(-EINVAL);
 }
 
+/* Migrate a policy to a different set of nodes */
+static void mpol_rebind_policy(struct mempolicy *pol,
+			       const nodemask_t *newmask)
+{
+	nodemask_t tmp;
+	int static_nodes;
+	int relative_nodes;
+
+	if (!pol)
+		return;
+	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
+	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
+	if (!mpol_store_user_nodemask(pol) &&
+	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
+		return;
+
+	switch (pol->policy) {
+	case MPOL_DEFAULT:
+		break;
+	case MPOL_BIND:
+		/* Fall through */
+	case MPOL_INTERLEAVE:
+		if (static_nodes)
+			nodes_and(tmp, pol->w.user_nodemask, *newmask);
+		else if (relative_nodes)
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
+		else {
+			nodes_remap(tmp, pol->v.nodes,
+				    pol->w.cpuset_mems_allowed, *newmask);
+			pol->w.cpuset_mems_allowed = *newmask;
+		}
+		pol->v.nodes = tmp;
+		if (!node_isset(current->il_next, tmp)) {
+			current->il_next = next_node(current->il_next, tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = first_node(tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = numa_node_id();
+		}
+		break;
+	case MPOL_PREFERRED:
+		if (static_nodes) {
+			int node = first_node(pol->w.user_nodemask);
+
+			if (node_isset(node, *newmask))
+				pol->v.preferred_node = node;
+			else
+				pol->v.preferred_node = -1;
+		} else if (relative_nodes) {
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
+			pol->v.preferred_node = first_node(tmp);
+		} else {
+			pol->v.preferred_node = node_remap(pol->v.preferred_node,
+					pol->w.cpuset_mems_allowed, *newmask);
+			pol->w.cpuset_mems_allowed = *newmask;
+		}
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+/*
+ * Wrapper for mpol_rebind_policy() that just requires task
+ * pointer, and updates task mempolicy.
+ */
+
+void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
+{
+	mpol_rebind_policy(tsk->mempolicy, new);
+}
+
+/*
+ * Rebind each vma in mm to new nodemask.
+ *
+ * Call holding a reference to mm.  Takes mm->mmap_sem during call.
+ */
+
+void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
+{
+	struct vm_area_struct *vma;
+
+	down_write(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		mpol_rebind_policy(vma->vm_policy, new);
+	up_write(&mm->mmap_sem);
+}
+
 static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
@@ -1757,97 +1845,6 @@ void numa_default_policy(void)
 	do_set_mempolicy(MPOL_DEFAULT, 0, NULL);
 }
 
-/* Migrate a policy to a different set of nodes */
-static void mpol_rebind_policy(struct mempolicy *pol,
-			       const nodemask_t *newmask)
-{
-	nodemask_t tmp;
-	int static_nodes;
-	int relative_nodes;
-
-	if (!pol)
-		return;
-	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
-	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
-	if (!mpol_store_user_nodemask(pol) &&
-	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
-		return;
-
-	switch (pol->policy) {
-	case MPOL_DEFAULT:
-		break;
-	case MPOL_BIND:
-		/* Fall through */
-	case MPOL_INTERLEAVE:
-		if (static_nodes)
-			nodes_and(tmp, pol->w.user_nodemask, *newmask);
-		else if (relative_nodes)
-			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
-					       newmask);
-		else {
-			nodes_remap(tmp, pol->v.nodes,
-				    pol->w.cpuset_mems_allowed, *newmask);
-			pol->w.cpuset_mems_allowed = *newmask;
-		}
-		pol->v.nodes = tmp;
-		if (!node_isset(current->il_next, tmp)) {
-			current->il_next = next_node(current->il_next, tmp);
-			if (current->il_next >= MAX_NUMNODES)
-				current->il_next = first_node(tmp);
-			if (current->il_next >= MAX_NUMNODES)
-				current->il_next = numa_node_id();
-		}
-		break;
-	case MPOL_PREFERRED:
-		if (static_nodes) {
-			int node = first_node(pol->w.user_nodemask);
-
-			if (node_isset(node, *newmask))
-				pol->v.preferred_node = node;
-			else
-				pol->v.preferred_node = -1;
-		} else if (relative_nodes) {
-			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
-					       newmask);
-			pol->v.preferred_node = first_node(tmp);
-		} else {
-			pol->v.preferred_node = node_remap(pol->v.preferred_node,
-					pol->w.cpuset_mems_allowed, *newmask);
-			pol->w.cpuset_mems_allowed = *newmask;
-		}
-		break;
-	default:
-		BUG();
-		break;
-	}
-}
-
-/*
- * Wrapper for mpol_rebind_policy() that just requires task
- * pointer, and updates task mempolicy.
- */
-
-void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
-{
-	mpol_rebind_policy(tsk->mempolicy, new);
-}
-
-/*
- * Rebind each vma in mm to new nodemask.
- *
- * Call holding a reference to mm.  Takes mm->mmap_sem during call.
- */
-
-void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
-{
-	struct vm_area_struct *vma;
-
-	down_write(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
-		mpol_rebind_policy(vma->vm_policy, new);
-	up_write(&mm->mmap_sem);
-}
