From: akpm@linux-foundation.org
Subject: [merged]
 slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:46 -0700
Message-ID: <543c1786.+uw5joi5Y8fNLQkS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaJMSSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, anton@samba.org, benh@kernel.crashing.org, cl@linux.com, hanpt@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com, mpe@ellerman.id.au, nacc@linux.vnet.ibm.com, paulus@samba.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fall back to node_to_mem_node() node if allocating on memoryless node
has been removed from the -mm tree.  Its filename was
     slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slub: fall back to node_to_mem_node() node if allocating on memoryless node

Update the SLUB code to search for partial slabs on the nearest node with
memory in the presence of memoryless nodes.  Additionally, do not consider
it to be an ALLOC_NODE_MISMATCH (and deactivate the slab) when a
memoryless-node specified allocation goes off-node.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node mm/slub.c
--- a/mm/slub.c~slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node
+++ a/mm/slub.c
@@ -1699,7 +1699,12 @@ static void *get_partial(struct kmem_cac
 		struct kmem_cache_cpu *c)
 {
 	void *object;
-	int searchnode = (node == NUMA_NO_NODE) ? numa_mem_id() : node;
+	int searchnode = node;
+
+	if (node == NUMA_NO_NODE)
+		searchnode = numa_mem_id();
+	else if (!node_present_pages(node))
+		searchnode = node_to_mem_node(node);
 
 	object = get_partial_node(s, get_node(s, searchnode), c, flags);
 	if (object || node != NUMA_NO_NODE)
@@ -2280,11 +2285,18 @@ static void *__slab_alloc(struct kmem_ca
 redo:
 
 	if (unlikely(!node_match(page, node))) {
-		stat(s, ALLOC_NODE_MISMATCH);
-		deactivate_slab(s, page, c->freelist);
-		c->page = NULL;
-		c->freelist = NULL;
-		goto new_slab;
+		int searchnode = node;
+
+		if (node != NUMA_NO_NODE && !node_present_pages(node))
+			searchnode = node_to_mem_node(node);
+
+		if (unlikely(!node_match(page, searchnode))) {
+			stat(s, ALLOC_NODE_MISMATCH);
+			deactivate_slab(s, page, c->freelist);
+			c->page = NULL;
+			c->freelist = NULL;
+			goto new_slab;
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

