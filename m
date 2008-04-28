From: akpm@linux-foundation.org
Subject: - mempolicy-create-mempolicy_operations-structure.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:43 -0700
Message-ID: <200804282151.m3SLphSc017599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964950AbYD1Vvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@sgi.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: create mempolicy_operations structure
has been removed from the -mm tree.  Its filename was
     mempolicy-create-mempolicy_operations-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: create mempolicy_operations structure
From: David Rientjes <rientjes@google.com>

Create a mempolicy_operations structure that currently points to two
functions[*] for the various modes:

	int (*create)(struct mempolicy *, const nodemask_t *);
	void (*rebind)(struct mempolicy *, const nodemask_t *);

This splits the implementation for the various modes out of two large
functions, mpol_new() and mpol_rebind_policy().  Eventually it may be
beneficial to add additional functions to accomodate the existing switch()
statements in mm/mempolicy.c.

 [*] The ->create() function for MPOL_DEFAULT is currently NULL since no
     struct mempolicy is dynamically allocated.

[Lee.Schermerhorn@hp.com: fix regression in the package mempolicy regression tests]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |  233 ++++++++++++++++++++++++++++-------------------
 1 file changed, 140 insertions(+), 93 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-create-mempolicy_operations-structure mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-create-mempolicy_operations-structure
+++ a/mm/mempolicy.c
@@ -63,7 +63,6 @@
    grows down?
    make bind policy root only? It can trigger oom much faster and the
    kernel is not always grateful with that.
-   could replace all the switch()es with a mempolicy_ops structure.
 */
 
 #include <linux/mempolicy.h>
@@ -110,8 +109,13 @@ struct mempolicy default_policy = {
 	.policy = MPOL_DEFAULT,
 };
 
+static const struct mempolicy_operations {
+	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
+	void (*rebind)(struct mempolicy *pol, const nodemask_t *nodes);
+} mpol_ops[MPOL_MAX];
+
 /* Check that the nodemask contains at least one populated zone */
-static int is_valid_nodemask(nodemask_t *nodemask)
+static int is_valid_nodemask(const nodemask_t *nodemask)
 {
 	int nd, k;
 
@@ -144,125 +148,151 @@ static void mpol_relative_nodemask(nodem
 	nodes_onto(*ret, tmp, *rel);
 }
 
+static int mpol_new_interleave(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (nodes_empty(*nodes))
+		return -EINVAL;
+	pol->v.nodes = *nodes;
+	return 0;
+}
+
+static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (!nodes)
+		pol->v.preferred_node = -1;	/* local allocation */
+	else if (nodes_empty(*nodes))
+		return -EINVAL;			/*  no allowed nodes */
+	else
+		pol->v.preferred_node = first_node(*nodes);
+	return 0;
+}
+
+static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (!is_valid_nodemask(nodes))
+		return -EINVAL;
+	pol->v.nodes = *nodes;
+	return 0;
+}
+
 /* Create a new policy */
 static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
+	int localalloc = 0;
+	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
 	if (mode == MPOL_DEFAULT)
-		return (nodes && nodes_weight(*nodes)) ? ERR_PTR(-EINVAL) :
-							 NULL;
+		return NULL;
+	if (!nodes || nodes_empty(*nodes)) {
+		if (mode != MPOL_PREFERRED)
+			return ERR_PTR(-EINVAL);
+		localalloc = 1;	/* special case:  no mode flags */
+	}
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
-	cpuset_update_task_memory_state();
-	if (flags & MPOL_F_RELATIVE_NODES)
-		mpol_relative_nodemask(&cpuset_context_nmask, nodes,
-				       &cpuset_current_mems_allowed);
-	else
-		nodes_and(cpuset_context_nmask, *nodes,
-			  cpuset_current_mems_allowed);
-	switch (mode) {
-	case MPOL_INTERLEAVE:
-		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask))
-			goto free;
-		policy->v.nodes = cpuset_context_nmask;
-		break;
-	case MPOL_PREFERRED:
-		policy->v.preferred_node = first_node(cpuset_context_nmask);
-		if (policy->v.preferred_node >= MAX_NUMNODES)
-			goto free;
-		break;
-	case MPOL_BIND:
-		if (!is_valid_nodemask(&cpuset_context_nmask))
-			goto free;
-		policy->v.nodes = cpuset_context_nmask;
-		break;
-	default:
-		BUG();
-	}
 	policy->policy = mode;
-	policy->flags = flags;
-	if (mpol_store_user_nodemask(policy))
-		policy->w.user_nodemask = *nodes;
-	else
-		policy->w.cpuset_mems_allowed = cpuset_mems_allowed(current);
+
+	if (!localalloc) {
+		policy->flags = flags;
+		cpuset_update_task_memory_state();
+		if (flags & MPOL_F_RELATIVE_NODES)
+			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
+					       &cpuset_current_mems_allowed);
+		else
+			nodes_and(cpuset_context_nmask, *nodes,
+				  cpuset_current_mems_allowed);
+		if (mpol_store_user_nodemask(policy))
+			policy->w.user_nodemask = *nodes;
+		else
+			policy->w.cpuset_mems_allowed =
+						cpuset_mems_allowed(current);
+	}
+
+	ret = mpol_ops[mode].create(policy,
+				localalloc ? NULL : &cpuset_context_nmask);
+	if (ret < 0) {
+		kmem_cache_free(policy_cache, policy);
+		return ERR_PTR(ret);
+	}
 	return policy;
+}
+
+static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
+{
+}
+
+static void mpol_rebind_nodemask(struct mempolicy *pol,
+				 const nodemask_t *nodes)
+{
+	nodemask_t tmp;
 
-free:
-	kmem_cache_free(policy_cache, policy);
-	return ERR_PTR(-EINVAL);
+	if (pol->flags & MPOL_F_STATIC_NODES)
+		nodes_and(tmp, pol->w.user_nodemask, *nodes);
+	else if (pol->flags & MPOL_F_RELATIVE_NODES)
+		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
+	else {
+		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
+			    *nodes);
+		pol->w.cpuset_mems_allowed = *nodes;
+	}
+
+	pol->v.nodes = tmp;
+	if (!node_isset(current->il_next, tmp)) {
+		current->il_next = next_node(current->il_next, tmp);
+		if (current->il_next >= MAX_NUMNODES)
+			current->il_next = first_node(tmp);
+		if (current->il_next >= MAX_NUMNODES)
+			current->il_next = numa_node_id();
+	}
+}
+
+static void mpol_rebind_preferred(struct mempolicy *pol,
+				  const nodemask_t *nodes)
+{
+	nodemask_t tmp;
+
+	/*
+	 * check 'STATIC_NODES first, as preferred_node == -1 may be
+	 * a temporary, "fallback" state for this policy.
+	 */
+	if (pol->flags & MPOL_F_STATIC_NODES) {
+		int node = first_node(pol->w.user_nodemask);
+
+		if (node_isset(node, *nodes))
+			pol->v.preferred_node = node;
+		else
+			pol->v.preferred_node = -1;
+	} else if (pol->v.preferred_node == -1) {
+		return;	/* no remap required for explicit local alloc */
+	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
+		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
+		pol->v.preferred_node = first_node(tmp);
+	} else {
+		pol->v.preferred_node = node_remap(pol->v.preferred_node,
+						   pol->w.cpuset_mems_allowed,
+						   *nodes);
+		pol->w.cpuset_mems_allowed = *nodes;
+	}
 }
 
 /* Migrate a policy to a different set of nodes */
 static void mpol_rebind_policy(struct mempolicy *pol,
 			       const nodemask_t *newmask)
 {
-	nodemask_t tmp;
-	int static_nodes;
-	int relative_nodes;
-
 	if (!pol)
 		return;
-	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
-	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
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
+	mpol_ops[pol->policy].rebind(pol, newmask);
 }
 
 /*
@@ -291,6 +321,24 @@ void mpol_rebind_mm(struct mm_struct *mm
 	up_write(&mm->mmap_sem);
 }
 
+static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
+	[MPOL_DEFAULT] = {
+		.rebind = mpol_rebind_default,
+	},
+	[MPOL_INTERLEAVE] = {
+		.create = mpol_new_interleave,
+		.rebind = mpol_rebind_nodemask,
+	},
+	[MPOL_PREFERRED] = {
+		.create = mpol_new_preferred,
+		.rebind = mpol_rebind_preferred,
+	},
+	[MPOL_BIND] = {
+		.create = mpol_new_bind,
+		.rebind = mpol_rebind_nodemask,
+	},
+};
+
 static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
@@ -1848,7 +1896,6 @@ void numa_default_policy(void)
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
