From: akpm@linux-foundation.org
Subject: + mempolicy-add-mpol_f_static_nodes-flag.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:26:29 -0800
Message-ID: <200803060126.m261QT5t002034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762973AbYCFB1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com


The patch titled
     mempolicy: add MPOL_F_STATIC_NODES flag
has been added to the -mm tree.  Its filename is
     mempolicy-add-mpol_f_static_nodes-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: add MPOL_F_STATIC_NODES flag
From: David Rientjes <rientjes@google.com>

Add an optional mempolicy mode flag, MPOL_F_STATIC_NODES, that suppresses the
node remap when the policy is rebound.

Adds another member to struct mempolicy, nodemask_t user_nodemask, as part of
a union with cpuset_mems_allowed:

	struct mempolicy {
		...
		union {
			nodemask_t cpuset_mems_allowed;
			nodemask_t user_nodemask;
		} w;
	}

that stores the the nodemask that the user passed when he or she created the
mempolicy via set_mempolicy() or mbind().  When using MPOL_F_STATIC_NODES,
which is passed with any mempolicy mode, the user's passed nodemask
intersected with the VMA or task's allowed nodes is always used when
determining the preferred node, setting the MPOL_BIND zonelist, or creating
the interleave nodemask.  This happens whenever the policy is rebound,
including when a task's cpuset assignment changes or the cpuset's mems are
changed.

This creates an interesting side-effect in that it allows the mempolicy
"intent" to lie dormant and uneffected until it has access to the node(s) that
it desires.  For example, if you currently ask for an interleaved policy over
a set of nodes that you do not have access to, the mempolicy is not created
and the task continues to use the previous policy.  With this change, however,
it is possible to create the same mempolicy; it is only effected when access
to nodes in the nodemask is acquired.

It is also possible to mount tmpfs with the static nodemask behavior when
specifying a node or nodemask.  To do this, simply add "=static" immediately
following the mempolicy mode at mount time:

	mount -o remount mpol=interleave=static:1-3

Also removes mpol_check_policy() and folds its logic into mpol_new() since it
is now obsoleted.  The unused vma_mpol_equal() is also removed.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   11 +-
 mm/mempolicy.c            |  172 ++++++++++++++++++------------------
 mm/shmem.c                |    2 
 3 files changed, 97 insertions(+), 88 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-add-mpol_f_static_nodes-flag include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-add-mpol_f_static_nodes-flag
+++ a/include/linux/mempolicy.h
@@ -24,11 +24,13 @@ enum {
 };
 
 /* Flags for set_mempolicy */
+#define MPOL_F_STATIC_NODES	(1 << 15)
+
 /*
  * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
  * either set_mempolicy() or mbind().
  */
-#define MPOL_MODE_FLAGS	(0)
+#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES)
 
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
@@ -85,7 +87,10 @@ struct mempolicy {
 		nodemask_t	 nodes;		/* interleave/bind */
 		/* undefined for default */
 	} v;
-	nodemask_t cpuset_mems_allowed;	/* mempolicy relative to these nodes */
+	union {
+		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
+		nodemask_t user_nodemask;	/* nodemask passed by user */
+	} w;
 };
 
 /*
@@ -124,7 +129,6 @@ static inline int mpol_equal(struct memp
 		return 1;
 	return __mpol_equal(a, b);
 }
-#define vma_mpol_equal(a,b) mpol_equal(vma_policy(a), vma_policy(b))
 
 /* Could later add inheritance of the process policy here. */
 
@@ -197,7 +201,6 @@ static inline int mpol_equal(struct memp
 {
 	return 1;
 }
-#define vma_mpol_equal(a,b) 1
 
 #define mpol_set_vma_default(vma) do {} while(0)
 
diff -puN mm/mempolicy.c~mempolicy-add-mpol_f_static_nodes-flag mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-add-mpol_f_static_nodes-flag
+++ a/mm/mempolicy.c
@@ -113,58 +113,6 @@ struct mempolicy default_policy = {
 static void mpol_rebind_policy(struct mempolicy *pol,
                                const nodemask_t *newmask);
 
-/* Do sanity checking on a policy */
-static int mpol_check_policy(unsigned short mode, nodemask_t *nodes)
-{
-	int was_empty, is_empty;
-
-	if (!nodes)
-		return 0;
-
-	/*
-	 * "Contextualize" the in-coming nodemast for cpusets:
-	 * Remember whether in-coming nodemask was empty,  If not,
-	 * restrict the nodes to the allowed nodes in the cpuset.
-	 * This is guaranteed to be a subset of nodes with memory.
-	 */
-	cpuset_update_task_memory_state();
-	is_empty = was_empty = nodes_empty(*nodes);
-	if (!was_empty) {
-		nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
-		is_empty = nodes_empty(*nodes);	/* after "contextualization" */
-	}
-
-	switch (mode) {
-	case MPOL_DEFAULT:
-		/*
-		 * require caller to specify an empty nodemask
-		 * before "contextualization"
-		 */
-		if (!was_empty)
-			return -EINVAL;
-		break;
-	case MPOL_BIND:
-	case MPOL_INTERLEAVE:
-		/*
-		 * require at least 1 valid node after "contextualization"
-		 */
-		if (is_empty)
-			return -EINVAL;
-		break;
-	case MPOL_PREFERRED:
-		/*
-		 * Did caller specify invalid nodes?
-		 * Don't silently accept this as "local allocation".
-		 */
-		if (!was_empty && is_empty)
-			return -EINVAL;
-		break;
-	default:
-		BUG();
-	}
-	return 0;
-}
-
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(nodemask_t *nodemask)
 {
@@ -186,48 +134,60 @@ static int is_valid_nodemask(nodemask_t 
 	return 0;
 }
 
+static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
+{
+	return pol->flags & MPOL_F_STATIC_NODES;
+}
+
 /* Create a new policy */
 static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
+	nodemask_t cpuset_context_nmask;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
 	if (mode == MPOL_DEFAULT)
-		return NULL;
+		return (nodes && nodes_weight(*nodes)) ? ERR_PTR(-EINVAL) :
+							 NULL;
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
+	cpuset_update_task_memory_state();
+	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
-		policy->v.nodes = *nodes;
-		if (nodes_weight(policy->v.nodes) == 0) {
-			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-EINVAL);
-		}
+		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask))
+			goto free;
+		policy->v.nodes = cpuset_context_nmask;
 		break;
 	case MPOL_PREFERRED:
-		policy->v.preferred_node = first_node(*nodes);
+		policy->v.preferred_node = first_node(cpuset_context_nmask);
 		if (policy->v.preferred_node >= MAX_NUMNODES)
-			policy->v.preferred_node = -1;
+			goto free;
 		break;
 	case MPOL_BIND:
-		if (!is_valid_nodemask(nodes)) {
-			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-EINVAL);
-		}
-		policy->v.nodes = *nodes;
+		if (!is_valid_nodemask(&cpuset_context_nmask))
+			goto free;
+		policy->v.nodes = cpuset_context_nmask;
 		break;
 	default:
 		BUG();
 	}
 	policy->policy = mode;
 	policy->flags = flags;
-	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
+	if (mpol_store_user_nodemask(policy))
+		policy->w.user_nodemask = *nodes;
+	else
+		policy->w.cpuset_mems_allowed = cpuset_mems_allowed(current);
 	return policy;
+
+free:
+	kmem_cache_free(policy_cache, policy);
+	return ERR_PTR(-EINVAL);
 }
 
 static void gather_stats(struct page *, void *, int pte_dirty);
@@ -473,15 +433,14 @@ static long do_set_mempolicy(unsigned sh
 {
 	struct mempolicy *new;
 
-	if (mpol_check_policy(mode, nodes))
-		return -EINVAL;
 	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 	mpol_free(current->mempolicy);
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
-	if (new && new->policy == MPOL_INTERLEAVE)
+	if (new && new->policy == MPOL_INTERLEAVE &&
+	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
 	return 0;
 }
@@ -796,9 +755,6 @@ static long do_mbind(unsigned long start
 	if (end == start)
 		return 0;
 
-	if (mpol_check_policy(mode, nmask))
-		return -EINVAL;
-
 	new = mpol_new(mode, mode_flags, nmask);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
@@ -1206,7 +1162,8 @@ static unsigned interleave_nodes(struct 
 	next = next_node(nid, policy->v.nodes);
 	if (next >= MAX_NUMNODES)
 		next = first_node(policy->v.nodes);
-	me->il_next = next;
+	if (next < MAX_NUMNODES)
+		me->il_next = next;
 	return nid;
 }
 
@@ -1251,10 +1208,13 @@ static unsigned offset_il_node(struct me
 		struct vm_area_struct *vma, unsigned long off)
 {
 	unsigned nnodes = nodes_weight(pol->v.nodes);
-	unsigned target = (unsigned)off % nnodes;
+	unsigned target;
 	int c;
 	int nid = -1;
 
+	if (!nnodes)
+		return numa_node_id();
+	target = (unsigned int)off % nnodes;
 	c = 0;
 	do {
 		nid = next_node(nid, pol->v.nodes);
@@ -1458,6 +1418,16 @@ struct mempolicy *__mpol_copy(struct mem
 	return new;
 }
 
+static int mpol_match_intent(const struct mempolicy *a,
+			     const struct mempolicy *b)
+{
+	if (a->flags != b->flags)
+		return 0;
+	if (!mpol_store_user_nodemask(a))
+		return 1;
+	return nodes_equal(a->w.user_nodemask, b->w.user_nodemask);
+}
+
 /* Slow path of a mempolicy comparison */
 int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
@@ -1465,6 +1435,8 @@ int __mpol_equal(struct mempolicy *a, st
 		return 0;
 	if (a->policy != b->policy)
 		return 0;
+	if (a->policy != MPOL_DEFAULT && !mpol_match_intent(a, b))
+		return 0;
 	switch (a->policy) {
 	case MPOL_DEFAULT:
 		return 1;
@@ -1764,13 +1736,14 @@ void numa_default_policy(void)
 static void mpol_rebind_policy(struct mempolicy *pol,
 			       const nodemask_t *newmask)
 {
-	nodemask_t *mpolmask;
 	nodemask_t tmp;
+	int static_nodes;
 
 	if (!pol)
 		return;
-	mpolmask = &pol->cpuset_mems_allowed;
-	if (nodes_equal(*mpolmask, *newmask))
+	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
+	if (!mpol_store_user_nodemask(pol) &&
+	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
 
 	switch (pol->policy) {
@@ -1779,16 +1752,35 @@ static void mpol_rebind_policy(struct me
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
-		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
+		if (static_nodes)
+			nodes_and(tmp, pol->w.user_nodemask, *newmask);
+		else {
+			nodes_remap(tmp, pol->v.nodes,
+				    pol->w.cpuset_mems_allowed, *newmask);
+			pol->w.cpuset_mems_allowed = *newmask;
+		}
 		pol->v.nodes = tmp;
-		*mpolmask = *newmask;
-		current->il_next = node_remap(current->il_next,
-						*mpolmask, *newmask);
+		if (!node_isset(current->il_next, tmp)) {
+			current->il_next = next_node(current->il_next, tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = first_node(tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = numa_node_id();
+		}
 		break;
 	case MPOL_PREFERRED:
-		pol->v.preferred_node = node_remap(pol->v.preferred_node,
-						*mpolmask, *newmask);
-		*mpolmask = *newmask;
+		if (static_nodes) {
+			int node = first_node(pol->w.user_nodemask);
+
+			if (node_isset(node, *newmask))
+				pol->v.preferred_node = node;
+			else
+				pol->v.preferred_node = -1;
+		} else {
+			pol->v.preferred_node = node_remap(pol->v.preferred_node,
+					pol->w.cpuset_mems_allowed, *newmask);
+			pol->w.cpuset_mems_allowed = *newmask;
+		}
 		break;
 	default:
 		BUG();
@@ -1840,6 +1832,7 @@ static inline int mpol_to_str(char *buff
 	int l;
 	nodemask_t nodes;
 	unsigned short mode = pol ? pol->policy : MPOL_DEFAULT;
+	unsigned short flags = pol ? pol->flags : 0;
 
 	switch (mode) {
 	case MPOL_DEFAULT:
@@ -1869,6 +1862,17 @@ static inline int mpol_to_str(char *buff
 	strcpy(p, policy_types[mode]);
 	p += l;
 
+	if (flags) {
+		int need_bar = 0;
+
+		if (buffer + maxlen < p + 2)
+			return -ENOSPC;
+		*p++ = '=';
+
+		if (flags & MPOL_F_STATIC_NODES)
+			p += sprintf(p, "%sstatic", need_bar++ ? "|" : "");
+	}
+
 	if (!nodes_empty(nodes)) {
 		if (buffer + maxlen < p + 2)
 			return -ENOSPC;
diff -puN mm/shmem.c~mempolicy-add-mpol_f_static_nodes-flag mm/shmem.c
--- a/mm/shmem.c~mempolicy-add-mpol_f_static_nodes-flag
+++ a/mm/shmem.c
@@ -1129,6 +1129,8 @@ static int shmem_parse_mpol(char *value,
 		err = 0;
 	}
 	if (flags) {
+		if (!strcmp(flags, "static"))
+			*mode_flags |= MPOL_F_STATIC_NODES;
 	}
 out:
 	/* Restore string for error message */
_

Patches currently in -mm which might be from rientjes@google.com are

fix-mempolicy-reference-counting-bugs.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
make-cgroup_enable_task_cg_lists-static.patch

