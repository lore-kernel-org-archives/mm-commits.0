From: akpm@linux-foundation.org
Subject: - memoryless-nodes-fix-interleave-behavior.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:11 -0700
Message-ID: <200708040515.l745FB4t011714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbXHDFPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless Nodes: Fix interleave behavior
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-fix-interleave-behavior.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Memoryless Nodes: Fix interleave behavior
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

MPOL_INTERLEAVE currently simply loops over all nodes.  Allocations on
memoryless nodes will be redirected to nodes with memory.  This results in an
imbalance because the neighboring nodes to memoryless nodes will get
significantly more interleave hits that the rest of the nodes on the system.

We can avoid this imbalance by clearing the nodes in the interleave node set
that have no memory.  If we use the node map of the memory nodes instead of
the online nodes then we have only the nodes we want.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~memoryless-nodes-fix-interleave-behavior mm/mempolicy.c
--- a/mm/mempolicy.c~memoryless-nodes-fix-interleave-behavior
+++ a/mm/mempolicy.c
@@ -183,7 +183,9 @@ static struct mempolicy *mpol_new(int mo
 	switch (mode) {
 	case MPOL_INTERLEAVE:
 		policy->v.nodes = *nodes;
-		if (nodes_weight(*nodes) == 0) {
+		nodes_and(policy->v.nodes, policy->v.nodes,
+					node_states[N_MEMORY]);
+		if (nodes_weight(policy->v.nodes) == 0) {
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
 		}
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
memoryless-nodes-fix-interleave-behavior.patch
oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
