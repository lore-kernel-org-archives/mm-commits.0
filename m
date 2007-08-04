From: akpm@linux-foundation.org
Subject: - memoryless-nodes-introduce-mask-of-nodes-with-memory.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:09 -0700
Message-ID: <200708040515.l745F9tT011711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbXHDFPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, Lee.Schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless nodes: introduce mask of nodes with memory
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-introduce-mask-of-nodes-with-memory.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Memoryless nodes: introduce mask of nodes with memory
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

It is necessary to know if nodes have memory since we have recently begun to
add support for memoryless nodes.  For that purpose we introduce a new node
state N_MEMORY.

A node has its bit in node_memory_map set if it has memory.  If a node has
memory then it has at least one zone defined in its pgdat structure that is
located in the pgdat itself.

N_MEMORY can then be used in various places to insure that we do the right
thing when we encounter a memoryless node.

Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 mm/page_alloc.c          |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/nodemask.h~memoryless-nodes-introduce-mask-of-nodes-with-memory include/linux/nodemask.h
--- a/include/linux/nodemask.h~memoryless-nodes-introduce-mask-of-nodes-with-memory
+++ a/include/linux/nodemask.h
@@ -343,6 +343,7 @@ static inline void __nodes_remap(nodemas
 enum node_states {
 	N_POSSIBLE,	/* The node could become online at some point */
 	N_ONLINE,	/* The node is online */
+	N_MEMORY,	/* The node has memory */
 	NR_NODE_STATES
 };
 
diff -puN mm/page_alloc.c~memoryless-nodes-introduce-mask-of-nodes-with-memory mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-introduce-mask-of-nodes-with-memory
+++ a/mm/page_alloc.c
@@ -2313,8 +2313,13 @@ static int __build_all_zonelists(void *d
 	int nid;
 
 	for_each_online_node(nid) {
-		build_zonelists(NODE_DATA(nid));
-		build_zonelist_cache(NODE_DATA(nid));
+		pg_data_t *pgdat = NODE_DATA(nid);
+
+		build_zonelists(pgdat);
+		build_zonelist_cache(pgdat);
+
+		if (pgdat->node_present_pages)
+			node_set_state(nid, N_MEMORY);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
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
