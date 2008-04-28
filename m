From: akpm@linux-foundation.org
Subject: - mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:48 -0700
Message-ID: <200804282151.m3SLpmqb017606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965038AbYD1VwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com, pj@sgi.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: disallow static or relative flags for local preferred mode
has been removed from the -mm tree.  Its filename was
     mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: disallow static or relative flags for local preferred mode
From: David Rientjes <rientjes@google.com>

MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES don't mean anything for
MPOL_PREFERRED policies that were created with an empty nodemask (for purely
local allocations).  They'll never be invalidated because the allowed mems of
a task changes or need to be rebound relative to a cpuset's placement.

Also fixes a bug identified by Lee Schermerhorn that disallowed empty
nodemasks to be passed to MPOL_PREFERRED to specify local allocations.  [A
different, somewhat incomplete, patch already existed in 25-rc5-mm1.]

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   16 +++++++-
 mm/mempolicy.c                          |   42 +++++++++++++---------
 2 files changed, 40 insertions(+), 18 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -205,6 +205,12 @@ Components of Memory Policies
 	    local allocation for a specific range of addresses--i.e. for
 	    VMA policies.
 
+	    It is possible for the user to specify that local allocation is
+	    always preferred by passing an empty nodemask with this mode.
+	    If an empty nodemask is passed, the policy cannot use the
+	    MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags described
+	    below.
+
 	MPOL_INTERLEAVED:  This mode specifies that page allocations be
 	interleaved, on a page granularity, across the nodes specified in
 	the policy.  This mode also behaves slightly differently, based on
@@ -254,7 +260,10 @@ Components of Memory Policies
 	    occurs over that node.  If no nodes from the user's nodemask are
 	    now allowed, the Default behavior is used.
 
-	    MPOL_F_STATIC_NODES cannot be used with MPOL_F_RELATIVE_NODES.
+	    MPOL_F_STATIC_NODES cannot be combined with the
+	    MPOL_F_RELATIVE_NODES flag.  It also cannot be used for
+	    MPOL_PREFERRED policies that were created with an empty nodemask
+	    (local allocation).
 
 	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
 	by the user will be mapped relative to the set of the task or VMA's
@@ -301,7 +310,10 @@ Components of Memory Policies
 	    set of memory nodes allowed by the task's cpuset, as that may
 	    change over time.
 
-	    MPOL_F_RELATIVE_NODES cannot be used with MPOL_F_STATIC_NODES.
+	    MPOL_F_RELATIVE_NODES cannot be combined with the
+	    MPOL_F_STATIC_NODES flag.  It also cannot be used for
+	    MPOL_PREFERRED policies that were created with an empty nodemask
+	    (local allocation).
 
 MEMORY POLICY APIs
 
diff -puN mm/mempolicy.c~mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode
+++ a/mm/mempolicy.c
@@ -181,27 +181,43 @@ static struct mempolicy *mpol_new(unsign
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
-	int localalloc = 0;
 	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (mode == MPOL_DEFAULT)
-		return NULL;
-	if (!nodes || nodes_empty(*nodes)) {
-		if (mode != MPOL_PREFERRED)
+	if (mode == MPOL_DEFAULT) {
+		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
-		localalloc = 1;	/* special case:  no mode flags */
+		return NULL;
 	}
+	VM_BUG_ON(!nodes);
+
+	/*
+	 * MPOL_PREFERRED cannot be used with MPOL_F_STATIC_NODES or
+	 * MPOL_F_RELATIVE_NODES if the nodemask is empty (local allocation).
+	 * All other modes require a valid pointer to a non-empty nodemask.
+	 */
+	if (mode == MPOL_PREFERRED) {
+		if (nodes_empty(*nodes)) {
+			if (((flags & MPOL_F_STATIC_NODES) ||
+			     (flags & MPOL_F_RELATIVE_NODES)))
+				return ERR_PTR(-EINVAL);
+			nodes = NULL;	/* flag local alloc */
+		}
+	} else if (nodes_empty(*nodes))
+		return ERR_PTR(-EINVAL);
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
 	policy->policy = mode;
+	policy->flags = flags;
 
-	if (!localalloc) {
-		policy->flags = flags;
+	if (nodes) {
+		/*
+		 * cpuset related setup doesn't apply to local allocation
+		 */
 		cpuset_update_task_memory_state();
 		if (flags & MPOL_F_RELATIVE_NODES)
 			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
@@ -217,7 +233,7 @@ static struct mempolicy *mpol_new(unsign
 	}
 
 	ret = mpol_ops[mode].create(policy,
-				localalloc ? NULL : &cpuset_context_nmask);
+				nodes ? &cpuset_context_nmask : NULL);
 	if (ret < 0) {
 		kmem_cache_free(policy_cache, policy);
 		return ERR_PTR(ret);
@@ -259,10 +275,6 @@ static void mpol_rebind_preferred(struct
 {
 	nodemask_t tmp;
 
-	/*
-	 * check 'STATIC_NODES first, as preferred_node == -1 may be
-	 * a temporary, "fallback" state for this policy.
-	 */
 	if (pol->flags & MPOL_F_STATIC_NODES) {
 		int node = first_node(pol->w.user_nodemask);
 
@@ -270,12 +282,10 @@ static void mpol_rebind_preferred(struct
 			pol->v.preferred_node = node;
 		else
 			pol->v.preferred_node = -1;
-	} else if (pol->v.preferred_node == -1) {
-		return;	/* no remap required for explicit local alloc */
 	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 		pol->v.preferred_node = first_node(tmp);
-	} else {
+	} else if (pol->v.preferred_node != -1) {
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
 						   pol->w.cpuset_mems_allowed,
 						   *nodes);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch

