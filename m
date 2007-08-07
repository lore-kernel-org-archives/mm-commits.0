From: akpm@linux-foundation.org
Subject: + categorize-gfp-flags.patch added to -mm tree
Date: Tue, 07 Aug 2007 14:12:04 -0700
Message-ID: <200708072112.l77LC42H004663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936648AbXHGVMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 17:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Categorize GFP flags
has been added to the -mm tree.  Its filename is
     categorize-gfp-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Categorize GFP flags
From: Christoph Lameter <clameter@sgi.com>

The function of GFP_LEVEL_MASK seems to be unclear.  In order to clear up
the mystery we get rid of it and replace GFP_LEVEL_MASK with 3 sets of GFP
flags:

GFP_RECLAIM_MASK	Flags used to control page allocator reclaim behavior.

GFP_CONSTRAINT_MASK	Flags used to limit where allocations can occur.

GFP_SLAB_BUG_MASK	Flags that the slab allocator BUG()s on.

These replace the uses of GFP_LEVEL mask in the slab allocators and in
vmalloc.c.

The use of the flags not included in these sets may occur as a result of a
slab allocation standing in for a page allocation when constructing scatter
gather lists.  Extraneous flags are cleared and not passed through to the
page allocator.  __GFP_MOVABLE/RECLAIMABLE, __GFP_COLD and __GFP_COMP will
now be ignored if passed to a slab allocator.

Change the allocation of allocator meta data in SLAB and vmalloc to not
pass through flags listed in GFP_CONSTRAINT_MASK.  SLAB already removes the
__GFP_THISNODE flag for such allocations.  Generalize that to also cover
vmalloc.  The use of GFP_CONSTRAINT_MASK also includes __GFP_HARDWALL.

The impact of allocator metadata placement on access latency to the
cachelines of the object itself is minimal since metadata is only
referenced on alloc and free.  The attempt is still made to place the meta
data optimally but we consistently allow fallback both in SLAB and vmalloc
(SLUB does not need to allocate metadata like that).

Allocator metadata may serve multiple in kernel users and thus should not
be subject to the limitations arising from a single allocation context.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   20 +++++++++++++-------
 mm/slab.c           |    6 +++---
 mm/slub.c           |    5 +++--
 mm/vmalloc.c        |    5 +++--
 4 files changed, 22 insertions(+), 14 deletions(-)

diff -puN include/linux/gfp.h~categorize-gfp-flags include/linux/gfp.h
--- a/include/linux/gfp.h~categorize-gfp-flags
+++ a/include/linux/gfp.h
@@ -53,13 +53,6 @@ struct vm_area_struct;
 #define __GFP_BITS_SHIFT 20	/* Room for 20 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
-/* if you forget to add the bitmask here kernel will crash, period */
-#define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
-			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
-			__GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
-			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| \
-			__GFP_MOVABLE)
-
 /* This equals 0, but use constants in case they ever change */
 #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
 /* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
@@ -86,6 +79,19 @@ struct vm_area_struct;
 #define GFP_THISNODE	((__force gfp_t)0)
 #endif
 
+/* This mask makes up all the page movable related flags */
+#define GFP_MOVABLE_MASK (__GFP_MOVABLE)
+
+/* Control page allocator reclaim behavior */
+#define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
+			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
+			__GFP_NORETRY|__GFP_NOMEMALLOC)
+
+/* Control allocation constraints */
+#define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
+
+/* Do not use these with a slab allocator */
+#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
 /* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
    platforms, used as appropriate on others */
diff -puN mm/slab.c~categorize-gfp-flags mm/slab.c
--- a/mm/slab.c~categorize-gfp-flags
+++ a/mm/slab.c
@@ -2743,9 +2743,9 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
+	BUG_ON(flags & GFP_SLAB_BUG_MASK);
+	local_flags = (flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK));
 
-	local_flags = (flags & GFP_LEVEL_MASK);
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
 	l3 = cachep->nodelists[nodeid];
@@ -2782,7 +2782,7 @@ static int cache_grow(struct kmem_cache 
 
 	/* Get slab management. */
 	slabp = alloc_slabmgmt(cachep, objp, offset,
-			local_flags & ~GFP_THISNODE, nodeid);
+			local_flags & ~GFP_CONSTRAINT_MASK, nodeid);
 	if (!slabp)
 		goto opps1;
 
diff -puN mm/slub.c~categorize-gfp-flags mm/slub.c
--- a/mm/slub.c~categorize-gfp-flags
+++ a/mm/slub.c
@@ -1078,12 +1078,13 @@ static struct page *new_slab(struct kmem
 	void *last;
 	void *p;
 
-	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
+	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
 	if (flags & __GFP_WAIT)
 		local_irq_enable();
 
-	page = allocate_slab(s, flags & GFP_LEVEL_MASK, node);
+	page = allocate_slab(s,
+		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 	if (!page)
 		goto out;
 
diff -puN mm/vmalloc.c~categorize-gfp-flags mm/vmalloc.c
--- a/mm/vmalloc.c~categorize-gfp-flags
+++ a/mm/vmalloc.c
@@ -190,7 +190,8 @@ static struct vm_struct *__get_vm_area_n
 	if (unlikely(!size))
 		return NULL;
 
-	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_LEVEL_MASK, node);
+	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);
+
 	if (unlikely(!area))
 		return NULL;
 
@@ -439,7 +440,7 @@ void *__vmalloc_area_node(struct vm_stru
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_LEVEL_MASK) | __GFP_ZERO,
+				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
 				node);
 	}
 	area->pages = pages;
_

Patches currently in -mm which might be from clameter@sgi.com are

apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
document-linux-memory-policy-v3.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
categorize-gfp-flags.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
