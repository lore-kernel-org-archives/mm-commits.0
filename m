From: akpm@linux-foundation.org
Subject: - memoryless-nodes-slub-support.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:19 -0700
Message-ID: <200708040515.l745FJ06011726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbXHDFP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless nodes: SLUB support
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-slub-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Memoryless nodes: SLUB support
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Memoryless nodes: SLUB support

Simply switch all for_each_online_node to for_each_memory_node.  That way SLUB
only operates on nodes with memory.  Any allocation attempt on a memoryless
node will fall whereupon SLUB will fetch memory from a nearby node (depending
on how memory policies and cpuset describe fallback).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/slub.c~memoryless-nodes-slub-support mm/slub.c
--- a/mm/slub.c~memoryless-nodes-slub-support
+++ a/mm/slub.c
@@ -1919,7 +1919,7 @@ static void free_kmem_cache_nodes(struct
 {
 	int node;
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		struct kmem_cache_node *n = s->node[node];
 		if (n && n != &s->local_node)
 			kmem_cache_free(kmalloc_caches, n);
@@ -1937,7 +1937,7 @@ static int init_kmem_cache_nodes(struct 
 	else
 		local_node = 0;
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		struct kmem_cache_node *n;
 
 		if (local_node == node)
@@ -2190,7 +2190,7 @@ static inline int kmem_cache_close(struc
 	flush_all(s);
 
 	/* Attempt to free all objects */
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
 		n->nr_partial -= free_list(s, n, &n->partial);
@@ -2485,7 +2485,7 @@ int kmem_cache_shrink(struct kmem_cache 
 		return -ENOMEM;
 
 	flush_all(s);
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		n = get_node(s, node);
 
 		if (!n->nr_partial)
@@ -2885,7 +2885,7 @@ static long validate_slab_cache(struct k
 		return -ENOMEM;
 
 	flush_all(s);
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
 		count += validate_slab_node(s, n, map);
@@ -3105,7 +3105,7 @@ static int list_locations(struct kmem_ca
 	/* Push back cpu slabs */
 	flush_all(s);
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 		unsigned long flags;
 		struct page *page;
@@ -3232,7 +3232,7 @@ static unsigned long slab_objects(struct
 		}
 	}
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
 		if (flags & SO_PARTIAL) {
@@ -3260,7 +3260,7 @@ static unsigned long slab_objects(struct
 
 	x = sprintf(buf, "%lu", total);
 #ifdef CONFIG_NUMA
-	for_each_online_node(node)
+	for_each_node_state(node, N_MEMORY)
 		if (nodes[node])
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
