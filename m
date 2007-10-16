From: akpm@linux-foundation.org
Subject: - categorize-gfp-flags.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:16 -0700
Message-ID: <200710162034.l9GKYGBA014917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965844AbXJPVkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Categorize GFP flags
has been removed from the -mm tree.  Its filename was
     categorize-gfp-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix fallback_alloc()]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   20 +++++++++++++-------
 mm/slab.c           |    8 ++++----
 mm/slub.c           |    5 +++--
 mm/vmalloc.c        |    5 +++--
 4 files changed, 23 insertions(+), 15 deletions(-)

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
@@ -2746,9 +2746,9 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
+	BUG_ON(flags & GFP_SLAB_BUG_MASK);
+	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
-	local_flags = (flags & GFP_LEVEL_MASK);
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
 	l3 = cachep->nodelists[nodeid];
@@ -2785,7 +2785,7 @@ static int cache_grow(struct kmem_cache 
 
 	/* Get slab management. */
 	slabp = alloc_slabmgmt(cachep, objp, offset,
-			local_flags & ~GFP_THISNODE, nodeid);
+			local_flags & ~GFP_CONSTRAINT_MASK, nodeid);
 	if (!slabp)
 		goto opps1;
 
@@ -3225,7 +3225,7 @@ static void *fallback_alloc(struct kmem_
 
 	zonelist = &NODE_DATA(slab_node(current->mempolicy))
 			->node_zonelists[gfp_zone(flags)];
-	local_flags = (flags & GFP_LEVEL_MASK);
+	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry:
 	/*
diff -puN mm/slub.c~categorize-gfp-flags mm/slub.c
--- a/mm/slub.c~categorize-gfp-flags
+++ a/mm/slub.c
@@ -1088,12 +1088,13 @@ static struct page *new_slab(struct kmem
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

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
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
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
