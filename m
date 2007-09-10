From: akpm@linux-foundation.org
Subject: + slub-accurately-compare-debug-flags-during-slab-cache-merge.patch added to -mm tree
Date: Mon, 10 Sep 2007 12:13:31 -0700
Message-ID: <200709101913.l8AJDVdp006190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755AbXIJTNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 15:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, cebbert@redhat.com


The patch titled
     SLUB: accurately compare debug flags during slab cache merge
has been added to the -mm tree.  Its filename is
     slub-accurately-compare-debug-flags-during-slab-cache-merge.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: accurately compare debug flags during slab cache merge
From: Christoph Lameter <clameter@sgi.com>

This was posted on Aug 28 and fixes an issue that could cause troubles
when slab caches >=128k are created.

http://marc.info/?l=linux-mm&m=118798149918424&w=2

Currently we simply add the debug flags unconditional when checking for a
matching slab.  This creates issues for sysfs processing when slabs exist
that are exempt from debugging due to their huge size or because only a
subset of slabs was selected for debugging.

We need to only add the flags if kmem_cache_open() would also add them.

Create a function to calculate the flags that would be set
if the cache would be opened and use that function to determine
the flags before looking for a compatible slab.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff -puN mm/slub.c~slub-accurately-compare-debug-flags-during-slab-cache-merge mm/slub.c
--- a/mm/slub.c~slub-accurately-compare-debug-flags-during-slab-cache-merge
+++ a/mm/slub.c
@@ -986,7 +986,9 @@ out:
 
 __setup("slub_debug", setup_slub_debug);
 
-static void kmem_cache_open_debug_check(struct kmem_cache *s)
+static unsigned long kmem_cache_flags(unsigned long objsize,
+	unsigned long flags, const char *name,
+	void (*ctor)(void *, struct kmem_cache *, unsigned long))
 {
 	/*
 	 * The page->offset field is only 16 bit wide. This is an offset
@@ -1000,19 +1002,20 @@ static void kmem_cache_open_debug_check(
 	 * Debugging or ctor may create a need to move the free
 	 * pointer. Fail if this happens.
 	 */
-	if (s->objsize >= 65535 * sizeof(void *)) {
-		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
+	if (objsize >= 65535 * sizeof(void *)) {
+		BUG_ON(flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
-		BUG_ON(s->ctor);
-	}
-	else
+		BUG_ON(ctor);
+	} else
 		/*
 		 * Enable debugging if selected on the kernel commandline.
 		 */
 		if (slub_debug && (!slub_debug_slabs ||
-		    strncmp(slub_debug_slabs, s->name,
+		    strncmp(slub_debug_slabs, name,
 		    	strlen(slub_debug_slabs)) == 0))
-				s->flags |= slub_debug;
+				flags |= slub_debug;
+
+	return flags;
 }
 #else
 static inline void setup_object_debug(struct kmem_cache *s,
@@ -1029,7 +1032,12 @@ static inline int slab_pad_check(struct 
 static inline int check_object(struct kmem_cache *s, struct page *page,
 			void *object, int active) { return 1; }
 static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
-static inline void kmem_cache_open_debug_check(struct kmem_cache *s) {}
+static unsigned long kmem_cache_flags(unsigned long objsize,
+	unsigned long flags, const char *name,
+	void (*ctor)(void *, struct kmem_cache *, unsigned long))
+{
+	return flags;
+}
 #define slub_debug 0
 #endif
 /*
@@ -2088,9 +2096,8 @@ static int kmem_cache_open(struct kmem_c
 	s->name = name;
 	s->ctor = ctor;
 	s->objsize = size;
-	s->flags = flags;
 	s->align = align;
-	kmem_cache_open_debug_check(s);
+	s->flags = kmem_cache_flags(size, flags, name, ctor);
 
 	if (!calculate_sizes(s))
 		goto error;
@@ -2660,7 +2667,7 @@ static int slab_unmergeable(struct kmem_
 }
 
 static struct kmem_cache *find_mergeable(size_t size,
-		size_t align, unsigned long flags,
+		size_t align, unsigned long flags, const char *name,
 		void (*ctor)(void *, struct kmem_cache *, unsigned long))
 {
 	struct kmem_cache *s;
@@ -2674,6 +2681,7 @@ static struct kmem_cache *find_mergeable
 	size = ALIGN(size, sizeof(void *));
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
+	flags = kmem_cache_flags(size, flags, name, NULL);
 
 	list_for_each_entry(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
@@ -2682,8 +2690,7 @@ static struct kmem_cache *find_mergeable
 		if (size > s->size)
 			continue;
 
-		if (((flags | slub_debug) & SLUB_MERGE_SAME) !=
-			(s->flags & SLUB_MERGE_SAME))
+		if ((flags & SLUB_MERGE_SAME) != (s->flags & SLUB_MERGE_SAME))
 				continue;
 		/*
 		 * Check if alignment is compatible.
@@ -2707,7 +2714,7 @@ struct kmem_cache *kmem_cache_create(con
 	struct kmem_cache *s;
 
 	down_write(&slub_lock);
-	s = find_mergeable(size, align, flags, ctor);
+	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
 		s->refcount++;
 		/*
_

Patches currently in -mm which might be from clameter@sgi.com are

infiniband-work-around-gcc-slub-problem.patch
input-limit-memory-allocated-by-uinput-ff-drivers.patch
input-limit-memory-allocated-by-uinput-ff-drivers-fix.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable-broke-ia64.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
revert-highmem-catch-illegal-nesting.patch
slub-accurately-compare-debug-flags-during-slab-cache-merge.patch
slub-accurately-compare-debug-flags-during-slab-cache-merge-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-optimize-cacheline-use-for-zeroing.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
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
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
page-owner-tracking-leak-detector.patch
