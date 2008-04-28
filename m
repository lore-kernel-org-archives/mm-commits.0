From: akpm@linux-foundation.org
Subject: - mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:23 -0700
Message-ID: <200804282153.m3SLrNfA017863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936014AbYD1Vxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: use MPOL_PREFERRED for system-wide default policy
has been removed from the -mm tree.  Its filename was
     mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: use MPOL_PREFERRED for system-wide default policy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Currently, when one specifies MPOL_DEFAULT via a NUMA memory policy API
[set_mempolicy(), mbind() and internal versions], the kernel simply installs a
NULL struct mempolicy pointer in the appropriate context: task policy, vma
policy, or shared policy.  This causes any use of that policy to "fall back"
to the next most specific policy scope.

The only use of MPOL_DEFAULT to mean "local allocation" is in the system
default policy.  This requires extra checks/cases for MPOL_DEFAULT in many
mempolicy.c functions.

There is another, "preferred" way to specify local allocation via the APIs. 
That is using the MPOL_PREFERRED policy mode with an empty nodemask. 
Internally, the empty nodemask gets converted to a preferred_node id of '-1'. 
All internal usage of MPOL_PREFERRED will convert the '-1' to the id of the
node local to the cpu where the allocation occurs.

System default policy, except during boot, is hard-coded to "local
allocation".  By using the MPOL_PREFERRED mode with a negative value of
preferred node for system default policy, MPOL_DEFAULT will never occur in the
'policy' member of a struct mempolicy.  Thus, we can remove all checks for
MPOL_DEFAULT when converting policy to a node id/zonelist in the allocation
paths.

In slab_node() return local node id when policy pointer is NULL.  No need to
set a pol value to take the switch default.  Replace switch default with
BUG()--i.e., shouldn't happen.

With this patch MPOL_DEFAULT is only used in the APIs, including internal
calls to do_set_mempolicy() and in the display of policy in
/proc/<pid>/numa_maps.  It always means "fall back" to the the next most
specific policy scope.  This simplifies the description of memory policies
quite a bit, with no visible change in behavior.

get_mempolicy() continues to return MPOL_DEFAULT and an empty nodemask when
the requested policy [task or vma/shared] is NULL.  These are the values one
would supply via set_mempolicy() or mbind() to achieve that condition--default
behavior.

This patch updates Documentation to reflect this change.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   52 +++++-----------
 mm/mempolicy.c                          |   68 +++++++++++++---------
 2 files changed, 59 insertions(+), 61 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mempolicy-use-mpol_preferred-for-system-wide-default-policy Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mempolicy-use-mpol_preferred-for-system-wide-default-policy
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -147,35 +147,18 @@ Components of Memory Policies
 
    Linux memory policy supports the following 4 behavioral modes:
 
-	Default Mode--MPOL_DEFAULT:  The behavior specified by this mode is
-	context or scope dependent.
+	Default Mode--MPOL_DEFAULT:  This mode is only used in the memory
+	policy APIs.  Internally, MPOL_DEFAULT is converted to the NULL
+	memory policy in all policy scopes.  Any existing non-default policy
+	will simply be removed when MPOL_DEFAULT is specified.  As a result,
+	MPOL_DEFAULT means "fall back to the next most specific policy scope."
+
+	    For example, a NULL or default task policy will fall back to the
+	    system default policy.  A NULL or default vma policy will fall
+	    back to the task policy.
 
-	    As mentioned in the Policy Scope section above, during normal
-	    system operation, the System Default Policy is hard coded to
-	    contain the Default mode.
-
-	    In this context, default mode means "local" allocation--that is
-	    attempt to allocate the page from the node associated with the cpu
-	    where the fault occurs.  If the "local" node has no memory, or the
-	    node's memory can be exhausted [no free pages available], local
-	    allocation will "fallback to"--attempt to allocate pages from--
-	    "nearby" nodes, in order of increasing "distance".
-
-		Implementation detail -- subject to change:  "Fallback" uses
-		a per node list of sibling nodes--called zonelists--built at
-		boot time, or when nodes or memory are added or removed from
-		the system [memory hotplug].  These per node zonelist are
-		constructed with nodes in order of increasing distance based
-		on information provided by the platform firmware.
-
-	    When a task/process policy or a shared policy contains the Default
-	    mode, this also means "local allocation", as described above.
-
-	    In the context of a VMA, Default mode means "fall back to task
-	    policy"--which may or may not specify Default mode.  Thus, Default
-	    mode can not be counted on to mean local allocation when used
-	    on a non-shared region of the address space.  However, see
-	    MPOL_PREFERRED below.
+	    When specified in one of the memory policy APIs, the Default mode
+	    does not use the optional set of nodes.
 
 	    It is an error for the set of nodes specified for this policy to
 	    be non-empty.
@@ -187,19 +170,18 @@ Components of Memory Policies
 
 	MPOL_PREFERRED:  This mode specifies that the allocation should be
 	attempted from the single node specified in the policy.  If that
-	allocation fails, the kernel will search other nodes, exactly as
-	it would for a local allocation that started at the preferred node
-	in increasing distance from the preferred node.  "Local" allocation
-	policy can be viewed as a Preferred policy that starts at the node
+	allocation fails, the kernel will search other nodes, in order of
+	increasing distance from the preferred node based on information
+	provided by the platform firmware.
 	containing the cpu where the allocation takes place.
 
 	    Internally, the Preferred policy uses a single node--the
 	    preferred_node member of struct mempolicy.  A "distinguished
 	    value of this preferred_node, currently '-1', is interpreted
 	    as "the node containing the cpu where the allocation takes
-	    place"--local allocation.  This is the way to specify
-	    local allocation for a specific range of addresses--i.e. for
-	    VMA policies.
+	    place"--local allocation.  "Local" allocation policy can be
+	    viewed as a Preferred policy that starts at the node containing
+	    the cpu where the allocation takes place.
 
 	    It is possible for the user to specify that local allocation is
 	    always preferred by passing an empty nodemask with this mode.
diff -puN mm/mempolicy.c~mempolicy-use-mpol_preferred-for-system-wide-default-policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-use-mpol_preferred-for-system-wide-default-policy
+++ a/mm/mempolicy.c
@@ -104,9 +104,13 @@ static struct kmem_cache *sn_cache;
    policied. */
 enum zone_type policy_zone = 0;
 
+/*
+ * run-time system-wide default policy => local allocation
+ */
 struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
-	.mode   = MPOL_DEFAULT,
+	.mode = MPOL_PREFERRED,
+	.v =  { .preferred_node =  -1 },
 };
 
 static const struct mempolicy_operations {
@@ -189,7 +193,7 @@ static struct mempolicy *mpol_new(unsign
 	if (mode == MPOL_DEFAULT) {
 		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
-		return NULL;
+		return NULL;	/* simply delete any existing policy */
 	}
 	VM_BUG_ON(!nodes);
 
@@ -246,7 +250,6 @@ void __mpol_put(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
-	p->mode = MPOL_DEFAULT;
 	kmem_cache_free(policy_cache, p);
 }
 
@@ -626,13 +629,16 @@ static long do_set_mempolicy(unsigned sh
 	return 0;
 }
 
-/* Fill a zone bitmap for a policy */
-static void get_zonemask(struct mempolicy *p, nodemask_t *nodes)
+/*
+ * Return nodemask for policy for get_mempolicy() query
+ */
+static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
 {
 	nodes_clear(*nodes);
+	if (p == &default_policy)
+		return;
+
 	switch (p->mode) {
-	case MPOL_DEFAULT:
-		break;
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
@@ -686,6 +692,11 @@ static long do_get_mempolicy(int *policy
 	}
 
 	if (flags & MPOL_F_ADDR) {
+		/*
+		 * Do NOT fall back to task policy if the
+		 * vma/shared policy at addr is NULL.  We
+		 * want to return MPOL_DEFAULT in this case.
+		 */
 		down_read(&mm->mmap_sem);
 		vma = find_vma_intersection(mm, addr, addr+1);
 		if (!vma) {
@@ -700,7 +711,7 @@ static long do_get_mempolicy(int *policy
 		return -EINVAL;
 
 	if (!pol)
-		pol = &default_policy;
+		pol = &default_policy;	/* indicates default behavior */
 
 	if (flags & MPOL_F_NODE) {
 		if (flags & MPOL_F_ADDR) {
@@ -715,8 +726,11 @@ static long do_get_mempolicy(int *policy
 			err = -EINVAL;
 			goto out;
 		}
-	} else
-		*policy = pol->mode | pol->flags;
+	} else {
+		*policy = pol == &default_policy ? MPOL_DEFAULT :
+						pol->mode;
+		*policy |= pol->flags;
+	}
 
 	if (vma) {
 		up_read(&current->mm->mmap_sem);
@@ -725,7 +739,7 @@ static long do_get_mempolicy(int *policy
 
 	err = 0;
 	if (nmask)
-		get_zonemask(pol, nmask);
+		get_policy_nodemask(pol, nmask);
 
  out:
 	mpol_cond_put(pol);
@@ -1286,8 +1300,7 @@ static struct mempolicy *get_vma_policy(
 									addr);
 			if (vpol)
 				pol = vpol;
-		} else if (vma->vm_policy &&
-				vma->vm_policy->mode != MPOL_DEFAULT)
+		} else if (vma->vm_policy)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
@@ -1334,7 +1347,6 @@ static struct zonelist *policy_zonelist(
 			nd = first_node(policy->v.nodes);
 		break;
 	case MPOL_INTERLEAVE: /* should not happen */
-	case MPOL_DEFAULT:
 		nd = numa_node_id();
 		break;
 	default:
@@ -1369,9 +1381,15 @@ static unsigned interleave_nodes(struct 
  */
 unsigned slab_node(struct mempolicy *policy)
 {
-	unsigned short pol = policy ? policy->mode : MPOL_DEFAULT;
+	if (!policy)
+		return numa_node_id();
+
+	switch (policy->mode) {
+	case MPOL_PREFERRED:
+		if (unlikely(policy->v.preferred_node >= 0))
+			return policy->v.preferred_node;
+		return numa_node_id();
 
-	switch (pol) {
 	case MPOL_INTERLEAVE:
 		return interleave_nodes(policy);
 
@@ -1390,13 +1408,8 @@ unsigned slab_node(struct mempolicy *pol
 		return zone->node;
 	}
 
-	case MPOL_PREFERRED:
-		if (policy->v.preferred_node >= 0)
-			return policy->v.preferred_node;
-		/* Fall through */
-
 	default:
-		return numa_node_id();
+		BUG();
 	}
 }
 
@@ -1650,8 +1663,6 @@ int __mpol_equal(struct mempolicy *a, st
 	if (a->mode != MPOL_DEFAULT && !mpol_match_intent(a, b))
 		return 0;
 	switch (a->mode) {
-	case MPOL_DEFAULT:
-		return 1;
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
@@ -1828,7 +1839,7 @@ void mpol_shared_policy_init(struct shar
 	if (policy != MPOL_DEFAULT) {
 		struct mempolicy *newpol;
 
-		/* Falls back to MPOL_DEFAULT on any error */
+		/* Falls back to NULL policy [MPOL_DEFAULT] on any error */
 		newpol = mpol_new(policy, flags, policy_nodes);
 		if (!IS_ERR(newpol)) {
 			/* Create pseudo-vma that contains just the policy */
@@ -1952,9 +1963,14 @@ static inline int mpol_to_str(char *buff
 	char *p = buffer;
 	int l;
 	nodemask_t nodes;
-	unsigned short mode = pol ? pol->mode : MPOL_DEFAULT;
+	unsigned short mode;
 	unsigned short flags = pol ? pol->flags : 0;
 
+	if (!pol || pol == &default_policy)
+		mode = MPOL_DEFAULT;
+	else
+		mode = pol->mode;
+
 	switch (mode) {
 	case MPOL_DEFAULT:
 		nodes_clear(nodes);
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

