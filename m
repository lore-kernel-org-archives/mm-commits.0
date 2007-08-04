From: akpm@linux-foundation.org
Subject: - memoryless-node-slab-support.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:17 -0700
Message-ID: <200708040515.l745FH86011723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbXHDFP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless Node: Slab support
has been removed from the -mm tree.  Its filename was
     memoryless-node-slab-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Memoryless Node: Slab support
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Slab should not allocate control structures for nodes without memory.  This
may seem to work right now but its unreliable since not all allocations can
fall back due to the use of GFP_THISNODE.

Switching a few for_each_online_node's to for_each_memory_node will allow us
to only allocate for nodes that actually have memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~memoryless-node-slab-support mm/slab.c
--- a/mm/slab.c~memoryless-node-slab-support
+++ a/mm/slab.c
@@ -1565,7 +1565,7 @@ void __init kmem_cache_init(void)
 		/* Replace the static kmem_list3 structures for the boot cpu */
 		init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], node);
 
-		for_each_online_node(nid) {
+		for_each_node_state(nid, N_MEMORY) {
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
 
@@ -1943,7 +1943,7 @@ static void __init set_up_list3s(struct 
 {
 	int node;
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		cachep->nodelists[node] = &initkmem_list3[index + node];
 		cachep->nodelists[node]->next_reap = jiffies +
 		    REAPTIMEOUT_LIST3 +
@@ -2074,7 +2074,7 @@ static int __init_refok setup_cpu_cache(
 			g_cpucache_up = PARTIAL_L3;
 		} else {
 			int node;
-			for_each_online_node(node) {
+			for_each_node_state(node, N_MEMORY) {
 				cachep->nodelists[node] =
 				    kmalloc_node(sizeof(struct kmem_list3),
 						GFP_KERNEL, node);
@@ -3784,7 +3784,7 @@ static int alloc_kmemlist(struct kmem_ca
 	struct array_cache *new_shared;
 	struct array_cache **new_alien = NULL;
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 
                 if (use_alien_caches) {
                         new_alien = alloc_alien_cache(node, cachep->limit);
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
