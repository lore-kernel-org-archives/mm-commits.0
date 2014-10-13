From: akpm@linux-foundation.org
Subject: [merged]
 topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:44 -0700
Message-ID: <543c1784.f6V3YXKiOf6UgfAb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaJMSSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, anton@samba.org, benh@kernel.crashing.org, cl@linux.com, hanpt@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com, mpe@ellerman.id.au, nacc@linux.vnet.ibm.com, paulus@samba.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: topology: add support for node_to_mem_node() to determine the fallback node
has been removed from the -mm tree.  Its filename was
     topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: topology: add support for node_to_mem_node() to determine the fallback node

Anton noticed (http://www.spinics.net/lists/linux-mm/msg67489.html) that
on ppc LPARs with memoryless nodes, a large amount of memory was consumed
by slabs and was marked unreclaimable.  He tracked it down to slab
deactivations in the SLUB core when we allocate remotely, leading to poor
efficiency always when memoryless nodes are present.

After much discussion, Joonsoo provided a few patches that help
significantly.  They don't resolve the problem altogether:

 - memory hotplug still needs testing, that is when a memoryless node
   becomes memory-ful, we want to dtrt
 - there are other reasons for going off-node than memoryless nodes,
   e.g., fully exhausted local nodes

Neither case is resolved with this series, but I don't think that should
block their acceptance, as they can be explored/resolved with follow-on
patches.

The series consists of:

[1/3] topology: add support for node_to_mem_node() to determine the
      fallback node

[2/3] slub: fallback to node_to_mem_node() node if allocating on
      memoryless node

      - Joonsoo's patches to cache the nearest node with memory for each
        NUMA node

[3/3] Partial revert of 81c98869faa5 (""kthread: ensure locality of
      task_struct allocations")

 - At Tejun's request, keep the knowledge of memoryless node fallback
   to the allocator core.



This patch (of 3):

We need to determine the fallback node in slub allocator if the allocation
target node is memoryless node.  Without it, the SLUB wrongly select the
node which has no memory and can't use a partial slab, because of node
mismatch.  Introduced function, node_to_mem_node(X), will return a node Y
with memory that has the nearest distance.  If X is memoryless node, it
will return nearest distance node, but, if X is normal node, it will
return itself.

We will use this function in following patch to determine the fallback
node.

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

 include/linux/topology.h |   17 +++++++++++++++++
 mm/page_alloc.c          |    1 +
 2 files changed, 18 insertions(+)

diff -puN include/linux/topology.h~topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node include/linux/topology.h
--- a/include/linux/topology.h~topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node
+++ a/include/linux/topology.h
@@ -119,11 +119,20 @@ static inline int numa_node_id(void)
  * Use the accessor functions set_numa_mem(), numa_mem_id() and cpu_to_mem().
  */
 DECLARE_PER_CPU(int, _numa_mem_);
+extern int _node_numa_mem_[MAX_NUMNODES];
 
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
 	this_cpu_write(_numa_mem_, node);
+	_node_numa_mem_[numa_node_id()] = node;
+}
+#endif
+
+#ifndef node_to_mem_node
+static inline int node_to_mem_node(int node)
+{
+	return _node_numa_mem_[node];
 }
 #endif
 
@@ -146,6 +155,7 @@ static inline int cpu_to_mem(int cpu)
 static inline void set_cpu_numa_mem(int cpu, int node)
 {
 	per_cpu(_numa_mem_, cpu) = node;
+	_node_numa_mem_[cpu_to_node(cpu)] = node;
 }
 #endif
 
@@ -159,6 +169,13 @@ static inline int numa_mem_id(void)
 }
 #endif
 
+#ifndef node_to_mem_node
+static inline int node_to_mem_node(int node)
+{
+	return node;
+}
+#endif
+
 #ifndef cpu_to_mem
 static inline int cpu_to_mem(int cpu)
 {
diff -puN mm/page_alloc.c~topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node mm/page_alloc.c
--- a/mm/page_alloc.c~topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node
+++ a/mm/page_alloc.c
@@ -85,6 +85,7 @@ EXPORT_PER_CPU_SYMBOL(numa_node);
  */
 DEFINE_PER_CPU(int, _numa_mem_);		/* Kernel "local memory" node */
 EXPORT_PER_CPU_SYMBOL(_numa_mem_);
+int _node_numa_mem_[MAX_NUMNODES];
 #endif
 
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

