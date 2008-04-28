From: akpm@linux-foundation.org
Subject: - mempolicy-create-mempolicy_operations-structure-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:53:35 -0700
Message-ID: <200804280653.m3S6rZ18012653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759006AbYD1GyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy-create-mempolicy_operations-structure fix
has been removed from the -mm tree.  Its filename was
     mempolicy-create-mempolicy_operations-structure-fix.patch

This patch was dropped because it was folded into mempolicy-create-mempolicy_operations-structure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy-create-mempolicy_operations-structure fix
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

The subject patch causes a regression in the numactl package mempolicy
regression tests.

I'm using the numactl-1.0.2 package with the patches available at:

http://free.linux.hp.com/~lts/Patches/Numactl/numactl-1.0.2-patches-080226.tar.gz

The numastat and regress patches in that tarball are necessary for
recent kernels, else the tests will report false failures.

The following patch fixes the regression.



Specifically this patch fixes problems introduced by the rework of mpol_new()
in patch 2/4 in the second series.  As a result, we're no longer accepting
NULL/empty nodemask with MPOL_PREFERRED as "local" allocation.  This breaks
the numactl regression tests.

"numactl --localalloc" <some command>" fails with invalid argument.

This patch fixes the regression by again treating NULL/empty nodemask with
MPOL_PREFERRED as "local allocation", and special casing this condition, as
needed, in mpol_new(), mpol_new_preferred() and mpol_rebind_preferred().

It also appears that the patch series listed above required a non-empty
nodemask with MPOL_DEFAULT.  However, I didn't test that.  With this
patch, MPOL_DEFAULT effectively ignores the nodemask--empty or not.
This is a change in behavior that I have argued against, but the
regression tests don't test this, so I'm not going to attempt to address
it with this patch.

Note:  I have no tests to test the 'STATIC_NODES and 'RELATIVE_NODES
behavior to ensure that this patch doesn't regress those.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   54 +++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-create-mempolicy_operations-structure-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-create-mempolicy_operations-structure-fix
+++ a/mm/mempolicy.c
@@ -158,9 +158,12 @@ static int mpol_new_interleave(struct me
 
 static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	if (nodes_empty(*nodes))
-		return -EINVAL;
-	pol->v.preferred_node = first_node(*nodes);
+	if (!nodes)
+		pol->v.preferred_node = -1;	/* local allocation */
+	else if (nodes_empty(*nodes))
+		return -EINVAL;			/*  no allowed nodes */
+	else
+		pol->v.preferred_node = first_node(*nodes);
 	return 0;
 }
 
@@ -178,34 +181,43 @@ static struct mempolicy *mpol_new(unsign
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
+	int localalloc = 0;
 	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (nodes && nodes_empty(*nodes) && mode != MPOL_PREFERRED)
-		return ERR_PTR(-EINVAL);
 	if (mode == MPOL_DEFAULT)
 		return NULL;
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
 	policy->policy = mode;
-	policy->flags = flags;
-	if (mpol_store_user_nodemask(policy))
-		policy->w.user_nodemask = *nodes;
-	else
-		policy->w.cpuset_mems_allowed = cpuset_mems_allowed(current);
 
-	ret = mpol_ops[mode].create(policy, &cpuset_context_nmask);
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
 	if (ret < 0) {
 		kmem_cache_free(policy_cache, policy);
 		return ERR_PTR(ret);
@@ -247,6 +259,10 @@ static void mpol_rebind_preferred(struct
 {
 	nodemask_t tmp;
 
+	/*
+	 * check 'STATIC_NODES first, as preferred_node == -1 may be
+	 * a temporary, "fallback" state for this policy.
+	 */
 	if (pol->flags & MPOL_F_STATIC_NODES) {
 		int node = first_node(pol->w.user_nodemask);
 
@@ -254,6 +270,8 @@ static void mpol_rebind_preferred(struct
 			pol->v.preferred_node = node;
 		else
 			pol->v.preferred_node = -1;
+	} else if (pol->v.preferred_node == -1) {
+		return;	/* no remap required for explicit local alloc */
 	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 		pol->v.preferred_node = first_node(tmp);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
fix-indentation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch

