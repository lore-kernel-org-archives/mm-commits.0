From: akpm@linux-foundation.org
Subject: +
 topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch added to -mm tree
Date: Tue, 09 Sep 2014 17:11:01 -0700
Message-ID: <540f9715.S4s35MbtM4n9ouYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaIJALD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2014 20:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, anton@samba.org, benh@kernel.crashing.org, cl@linux.com, hanpt@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com, mpe@ellerman.id.au, nacc@linux.vnet.ibm.com, paulus@samba.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: topology: add support for node_to_mem_node() to determine the fallback node
has been added to the -mm tree.  Its filename is
     topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch
partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

