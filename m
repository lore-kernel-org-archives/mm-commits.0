From: akpm@linux-foundation.org
Subject: - mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:29 -0700
Message-ID: <200804282153.m3SLrTUt017875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936252AbYD1Vxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: use MPOL_F_LOCAL to Indicate Preferred Local Policy
has been removed from the -mm tree.  Its filename was
     mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: use MPOL_F_LOCAL to Indicate Preferred Local Policy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Now that we're using "preferred local" policy for system default, we need to
make this as fast as possible.  Because of the variable size of the mempolicy
structure [based on size of nodemasks], the preferred_node may be in a
different cacheline from the mode.  This can result in accessing an extra
cacheline in the normal case of system default policy.  Suspect this is the
cause of an observed 2-3% slowdown in page fault testing relative to kernel
without this patch series.

To alleviate this, use an internal mode flag, MPOL_F_LOCAL in the mempolicy
flags member which is guaranteed [?] to be in the same cacheline as the mode
itself.

Verified that reworked mempolicy now performs slightly better on 25-rc8-mm1
for both anon and shmem segments with system default and vma [preferred local]
policy.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   11 ++---
 include/linux/mempolicy.h               |    1 
 mm/mempolicy.c                          |   47 ++++++++++------------
 3 files changed, 28 insertions(+), 31 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -176,12 +176,11 @@ Components of Memory Policies
 	containing the cpu where the allocation takes place.
 
 	    Internally, the Preferred policy uses a single node--the
-	    preferred_node member of struct mempolicy.  A "distinguished
-	    value of this preferred_node, currently '-1', is interpreted
-	    as "the node containing the cpu where the allocation takes
-	    place"--local allocation.  "Local" allocation policy can be
-	    viewed as a Preferred policy that starts at the node containing
-	    the cpu where the allocation takes place.
+	    preferred_node member of struct mempolicy.  When the internal
+	    mode flag MPOL_F_LOCAL is set, the preferred_node is ignored and
+	    the policy is interpreted as local allocation.  "Local" allocation
+	    policy can be viewed as a Preferred policy that starts at the node
+	    containing the cpu where the allocation takes place.
 
 	    It is possible for the user to specify that local allocation is
 	    always preferred by passing an empty nodemask with this mode.
diff -puN include/linux/mempolicy.h~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy
+++ a/include/linux/mempolicy.h
@@ -50,6 +50,7 @@ enum {
  * are never OR'ed into the mode in mempolicy API arguments.
  */
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
+#define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 
 #ifdef __KERNEL__
 
diff -puN mm/mempolicy.c~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy
+++ a/mm/mempolicy.c
@@ -110,7 +110,7 @@ enum zone_type policy_zone = 0;
 struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
 	.mode = MPOL_PREFERRED,
-	.v =  { .preferred_node =  -1 },
+	.flags = MPOL_F_LOCAL,
 };
 
 static const struct mempolicy_operations {
@@ -163,7 +163,7 @@ static int mpol_new_interleave(struct me
 static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 {
 	if (!nodes)
-		pol->v.preferred_node = -1;	/* local allocation */
+		pol->flags |= MPOL_F_LOCAL;	/* local allocation */
 	else if (nodes_empty(*nodes))
 		return -EINVAL;			/*  no allowed nodes */
 	else
@@ -290,14 +290,15 @@ static void mpol_rebind_preferred(struct
 	if (pol->flags & MPOL_F_STATIC_NODES) {
 		int node = first_node(pol->w.user_nodemask);
 
-		if (node_isset(node, *nodes))
+		if (node_isset(node, *nodes)) {
 			pol->v.preferred_node = node;
-		else
-			pol->v.preferred_node = -1;
+			pol->flags &= ~MPOL_F_LOCAL;
+		} else
+			pol->flags |= MPOL_F_LOCAL;
 	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 		pol->v.preferred_node = first_node(tmp);
-	} else if (pol->v.preferred_node != -1) {
+	} else if (!(pol->flags & MPOL_F_LOCAL)) {
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
 						   pol->w.cpuset_mems_allowed,
 						   *nodes);
@@ -645,7 +646,7 @@ static void get_policy_nodemask(struct m
 		*nodes = p->v.nodes;
 		break;
 	case MPOL_PREFERRED:
-		if (p->v.preferred_node >= 0)
+		if (!(p->flags & MPOL_F_LOCAL))
 			node_set(p->v.preferred_node, *nodes);
 		/* else return empty node mask for local allocation */
 		break;
@@ -1324,13 +1325,12 @@ static nodemask_t *policy_nodemask(gfp_t
 /* Return a zonelist indicated by gfp for node representing a mempolicy */
 static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy)
 {
-	int nd;
+	int nd = numa_node_id();
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
-		nd = policy->v.preferred_node;
-		if (nd < 0)
-			nd = numa_node_id();
+		if (!(policy->flags & MPOL_F_LOCAL))
+			nd = policy->v.preferred_node;
 		break;
 	case MPOL_BIND:
 		/*
@@ -1339,16 +1339,13 @@ static struct zonelist *policy_zonelist(
 		 * current node is part of the mask, we use the zonelist for
 		 * the first node in the mask instead.
 		 */
-		nd = numa_node_id();
 		if (unlikely(gfp & __GFP_THISNODE) &&
 				unlikely(!node_isset(nd, policy->v.nodes)))
 			nd = first_node(policy->v.nodes);
 		break;
 	case MPOL_INTERLEAVE: /* should not happen */
-		nd = numa_node_id();
 		break;
 	default:
-		nd = 0;
 		BUG();
 	}
 	return node_zonelist(nd, gfp);
@@ -1379,14 +1376,15 @@ static unsigned interleave_nodes(struct 
  */
 unsigned slab_node(struct mempolicy *policy)
 {
-	if (!policy)
+	if (!policy || policy->flags & MPOL_F_LOCAL)
 		return numa_node_id();
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
-		if (unlikely(policy->v.preferred_node >= 0))
-			return policy->v.preferred_node;
-		return numa_node_id();
+		/*
+		 * handled MPOL_F_LOCAL above
+		 */
+		return policy->v.preferred_node;
 
 	case MPOL_INTERLEAVE:
 		return interleave_nodes(policy);
@@ -1666,7 +1664,8 @@ int __mpol_equal(struct mempolicy *a, st
 	case MPOL_INTERLEAVE:
 		return nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
-		return a->v.preferred_node == b->v.preferred_node;
+		return a->v.preferred_node == b->v.preferred_node &&
+			a->flags == b->flags;
 	default:
 		BUG();
 		return 0;
@@ -1946,7 +1945,7 @@ void numa_default_policy(void)
 }
 
 /*
- * "local" is pseudo-policy:  MPOL_PREFERRED with preferred_node == -1
+ * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
  * Used only for mpol_to_str()
  */
 #define MPOL_LOCAL (MPOL_INTERLEAVE + 1)
@@ -1962,7 +1961,6 @@ static inline int mpol_to_str(char *buff
 {
 	char *p = buffer;
 	int l;
-	int nid;
 	nodemask_t nodes;
 	unsigned short mode;
 	unsigned short flags = pol ? pol->flags : 0;
@@ -1979,11 +1977,10 @@ static inline int mpol_to_str(char *buff
 
 	case MPOL_PREFERRED:
 		nodes_clear(nodes);
-		nid = pol->v.preferred_node;
-		if (nid < 0)
+		if (flags & MPOL_F_LOCAL)
 			mode = MPOL_LOCAL;	/* pseudo-policy */
 		else
-			node_set(nid, nodes);
+			node_set(pol->v.preferred_node, nodes);
 		break;
 
 	case MPOL_BIND:
@@ -2004,7 +2001,7 @@ static inline int mpol_to_str(char *buff
 	strcpy(p, policy_types[mode]);
 	p += l;
 
-	if (flags) {
+	if (flags & MPOL_MODE_FLAGS) {
 		int need_bar = 0;
 
 		if (buffer + maxlen < p + 2)
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

