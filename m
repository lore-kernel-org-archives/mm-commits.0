From: akpm@linux-foundation.org
Subject: + fix-interleave-with-memoryless-nodes.patch added to -mm tree
Date: Mon, 11 Jun 2007 17:57:06 -0700
Message-ID: <200706120057.l5C0v6dB000773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbXFLBCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 21:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, clameter@sgi.com


The patch titled
     Fix INTERLEAVE with memoryless nodes
has been added to the -mm tree.  Its filename is
     fix-interleave-with-memoryless-nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix INTERLEAVE with memoryless nodes
From: Nishanth Aravamudan <nacc@us.ibm.com>

Based on ideas from Christoph Lameter, add checks in the INTERLEAVE paths
for memoryless nodes.  We do not want to try interleaving onto those nodes.

Christoph said:
"This does not work for the address based interleaving for anonymous
vmas.  I am not sure what to do there. We could change the calculation
of the node to be based only on nodes with memory and then skip the
memoryless ones. I have only added a comment to describe its brokennes
for now."

I have copied his draft's comment.

Change alloc_pages_node() to fail __GFP_THISNODE allocations if the node
is not populated.

Again, Christoph said:
"This will fix the alloc_pages_node case but not the alloc_pages() case.
In the alloc_pages() case we do not specify a node. Implicitly it is
understood that we (in the case of no memory policy / cpuset options)
allocate from the nearest node. So it may be argued there that the
GFP_THISNODE behavior of taking the first node from the zonelist is
okay."

Christoph was also worried about the performance impact on these paths,
as am I.

Finally, as he suggested, uninline alloc_pages_node() and move it to
mempolicy.c.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   14 +-------------
 mm/mempolicy.c      |   38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 18 deletions(-)

diff -puN include/linux/gfp.h~fix-interleave-with-memoryless-nodes include/linux/gfp.h
--- a/include/linux/gfp.h~fix-interleave-with-memoryless-nodes
+++ a/include/linux/gfp.h
@@ -130,19 +130,7 @@ static inline void arch_alloc_page(struc
 extern struct page *
 FASTCALL(__alloc_pages(gfp_t, unsigned int, struct zonelist *));
 
-static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
-						unsigned int order)
-{
-	if (unlikely(order >= MAX_ORDER))
-		return NULL;
-
-	/* Unknown node is current node */
-	if (nid < 0)
-		nid = numa_node_id();
-
-	return __alloc_pages(gfp_mask, order,
-		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));
-}
+extern struct page * alloc_pages_node(int, gfp_t, unsigned int);
 
 #ifdef CONFIG_NUMA
 extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
diff -puN mm/mempolicy.c~fix-interleave-with-memoryless-nodes mm/mempolicy.c
--- a/mm/mempolicy.c~fix-interleave-with-memoryless-nodes
+++ a/mm/mempolicy.c
@@ -172,6 +172,7 @@ static struct zonelist *bind_zonelist(no
 static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
+	unsigned nid;
 
 	pr_debug("setting mode %d nodes[0] %lx\n",
 		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
@@ -184,8 +185,12 @@ static struct mempolicy *mpol_new(int mo
 	atomic_set(&policy->refcnt, 1);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
-		policy->v.nodes = *nodes;
-		if (nodes_weight(*nodes) == 0) {
+		/*
+		 * Clear any memoryless nodes here so that v.nodes can be used
+		 * without extra checks
+		 */
+		nodes_and(policy->v.nodes, *nodes, node_populated_mask);
+		if (nodes_weight(policy->v.nodes) == 0) {
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
 		}
@@ -578,6 +583,22 @@ long do_get_mempolicy(int *policy, nodem
 	return err;
 }
 
+struct page *alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
+{
+	if (unlikely(order >= MAX_ORDER))
+		return NULL;
+
+	/* Unknown node is current node */
+	if (nid < 0)
+		nid = numa_node_id();
+
+	if ((gfp_mask & __GFP_THISNODE) && !node_populated(nid))
+		return NULL;
+
+	return __alloc_pages(gfp_mask, order,
+		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));
+}
+
 #ifdef CONFIG_MIGRATION
 /*
  * page migration
@@ -1125,9 +1146,11 @@ static unsigned interleave_nodes(struct 
 	struct task_struct *me = current;
 
 	nid = me->il_next;
-	next = next_node(nid, policy->v.nodes);
-	if (next >= MAX_NUMNODES)
-		next = first_node(policy->v.nodes);
+	do {
+		next = next_node(nid, policy->v.nodes);
+		if (next >= MAX_NUMNODES)
+			next = first_node(policy->v.nodes);
+	} while (!node_populated(next));
 	me->il_next = next;
 	return nid;
 }
@@ -1191,6 +1214,11 @@ static inline unsigned interleave_nid(st
 		 * for huge pages, since vm_pgoff is in units of small
 		 * pages, we need to shift off the always 0 bits to get
 		 * a useful offset.
+		 *
+		 * NOTE: For configurations with memoryless nodes this
+		 * is broken since the allocation attempts on that node
+		 * will fall back to other nodes and thus one
+		 * neighboring node will be overallocated from.
 		 */
 		BUG_ON(shift < PAGE_SHIFT);
 		off = vma->vm_pgoff >> (shift - PAGE_SHIFT);
_

Patches currently in -mm which might be from nacc@us.ibm.com are

hugetlb-remove-unnecessary-nid-initialization.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
fix-interleave-with-memoryless-nodes.patch
fix-interleave-with-memoryless-nodes-fix.patch
