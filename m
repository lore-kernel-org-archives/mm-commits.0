From: akpm@linux-foundation.org
Subject: + oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:16:01 -0700
Message-ID: <200707290716.l6T7G12J013224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760063AbXG2HQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com


The patch titled
     OOM: use the N_MEMORY map instead of constructing one on the fly
has been added to the -mm tree.  Its filename is
     oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OOM: use the N_MEMORY map instead of constructing one on the fly
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

constrained_alloc() builds its own memory map for nodes with memory.  We have
that available in node_memory_map now.  So simplify the code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly mm/oom_kill.c
--- a/mm/oom_kill.c~oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly
+++ a/mm/oom_kill.c
@@ -176,14 +176,7 @@ static inline int constrained_alloc(stru
 {
 #ifdef CONFIG_NUMA
 	struct zone **z;
-	nodemask_t nodes;
-	int node;
-
-	nodes_clear(nodes);
-	/* node has memory ? */
-	for_each_online_node(node)
-		if (NODE_DATA(node)->node_present_pages)
-			node_set(node, nodes);
+	nodemask_t nodes = node_states[N_MEMORY];
 
 	for (z = zonelist->zones; *z; z++)
 		if (cpuset_zone_allowed_softwall(*z, gfp_mask))
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

numa-generic-management-of-nodemasks-for-various-purposes.patch
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
