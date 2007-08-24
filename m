From: akpm@linux-foundation.org
Subject: + slub-move-page-offset-to-kmem_cache_cpu-offset.patch added to -mm tree
Date: Fri, 24 Aug 2007 14:45:16 -0700
Message-ID: <200708242145.l7OLjHg8016220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760295AbXHXVpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Move page->offset to kmem_cache_cpu->offset
has been added to the -mm tree.  Its filename is
     slub-move-page-offset-to-kmem_cache_cpu-offset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Move page->offset to kmem_cache_cpu->offset
From: Christoph Lameter <clameter@sgi.com>

We need the offset from the page struct during slab_alloc and slab_free. In
both cases we also reference the cacheline of the kmem_cache_cpu structure.
We can therefore move the offset field into the kmem_cache_cpu structure
freeing up 16 bits in the page struct.

Moving the offset allows an allocation from slab_alloc() without touching the
page struct in the hot path.

The only thing left in slab_free() that touches the page struct cacheline for
per cpu freeing is the checking of SlabDebug(page). The next patch deals with
that.

Use the available 16 bits to broaden page->inuse. More than 64k objects per
slab become possible and we can get rid of the checks for that limitation.

No need anymore to shrink the order of slabs if we boot with 2M sized slabs
(slub_min_order=9).

No need anymore to switch off the offset calculation for very large slabs
since the field in the kmem_cache_cpu structure is 32 bits and so the offset
field can now handle slab sizes of up to 8GB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 --
 include/linux/slub_def.h |    1 
 mm/slub.c                |   80 +++++++------------------------------
 3 files changed, 18 insertions(+), 68 deletions(-)

diff -puN include/linux/mm_types.h~slub-move-page-offset-to-kmem_cache_cpu-offset include/linux/mm_types.h
--- a/include/linux/mm_types.h~slub-move-page-offset-to-kmem_cache_cpu-offset
+++ a/include/linux/mm_types.h
@@ -37,10 +37,7 @@ struct page {
 					 * to show when page is mapped
 					 * & limit reverse map searches.
 					 */
-		struct {	/* SLUB uses */
-			short unsigned int inuse;
-			short unsigned int offset;
-		};
+		unsigned int inuse;	/* SLUB: Nr of objects */
 	};
 	union {
 	    struct {
diff -puN include/linux/slub_def.h~slub-move-page-offset-to-kmem_cache_cpu-offset include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-move-page-offset-to-kmem_cache_cpu-offset
+++ a/include/linux/slub_def.h
@@ -15,6 +15,7 @@ struct kmem_cache_cpu {
 	void **freelist;
 	struct page *page;
 	int node;
+	unsigned int offset;
 	/* Lots of wasted space */
 } ____cacheline_aligned_in_smp;
 
diff -puN mm/slub.c~slub-move-page-offset-to-kmem_cache_cpu-offset mm/slub.c
--- a/mm/slub.c~slub-move-page-offset-to-kmem_cache_cpu-offset
+++ a/mm/slub.c
@@ -200,11 +200,6 @@ static inline void ClearSlabDebug(struct
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
-/*
- * The page->inuse field is 16 bit thus we have this limitation
- */
-#define MAX_OBJECTS_PER_SLAB 65535
-
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
 #define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
@@ -729,11 +724,6 @@ static int check_slab(struct kmem_cache 
 		slab_err(s, page, "Not a valid slab page");
 		return 0;
 	}
-	if (page->offset * sizeof(void *) != s->offset) {
-		slab_err(s, page, "Corrupted offset %lu",
-			(unsigned long)(page->offset * sizeof(void *)));
-		return 0;
-	}
 	if (page->inuse > s->objects) {
 		slab_err(s, page, "inuse %u > max %u",
 			s->name, page->inuse, s->objects);
@@ -872,8 +862,6 @@ bad:
 		slab_fix(s, "Marking all objects used");
 		page->inuse = s->objects;
 		page->freelist = NULL;
-		/* Fix up fields that may be corrupted */
-		page->offset = s->offset / sizeof(void *);
 	}
 	return 0;
 }
@@ -989,30 +977,12 @@ __setup("slub_debug", setup_slub_debug);
 static void kmem_cache_open_debug_check(struct kmem_cache *s)
 {
 	/*
-	 * The page->offset field is only 16 bit wide. This is an offset
-	 * in units of words from the beginning of an object. If the slab
-	 * size is bigger then we cannot move the free pointer behind the
-	 * object anymore.
-	 *
-	 * On 32 bit platforms the limit is 256k. On 64bit platforms
-	 * the limit is 512k.
-	 *
-	 * Debugging or ctor may create a need to move the free
-	 * pointer. Fail if this happens.
+	 * Enable debugging if selected on the kernel commandline.
 	 */
-	if (s->objsize >= 65535 * sizeof(void *)) {
-		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
-				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
-		BUG_ON(s->ctor);
-	}
-	else
-		/*
-		 * Enable debugging if selected on the kernel commandline.
-		 */
-		if (slub_debug && (!slub_debug_slabs ||
-		    strncmp(slub_debug_slabs, s->name,
-		    	strlen(slub_debug_slabs)) == 0))
-				s->flags |= slub_debug;
+	if (slub_debug && (!slub_debug_slabs ||
+		strncmp(slub_debug_slabs, s->name,
+		strlen(slub_debug_slabs)) == 0))
+			s->flags |= slub_debug;
 }
 #else
 static inline void setup_object_debug(struct kmem_cache *s,
@@ -1095,7 +1065,6 @@ static struct page *new_slab(struct kmem
 	n = get_node(s, page_to_nid(page));
 	if (n)
 		atomic_long_inc(&n->nr_slabs);
-	page->offset = s->offset / sizeof(void *);
 	page->slab = s;
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
@@ -1389,10 +1358,10 @@ static void deactivate_slab(struct kmem_
 
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
-		c->freelist = c->freelist[page->offset];
+		c->freelist = c->freelist[c->offset];
 
 		/* And put onto the regular freelist */
-		object[page->offset] = page->freelist;
+		object[c->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
@@ -1488,7 +1457,7 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->page->offset];
+	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
@@ -1540,7 +1509,7 @@ debug:
 		goto another_slab;
 
 	c->page->inuse++;
-	c->page->freelist = object[c->page->offset];
+	c->page->freelist = object[c->offset];
 	slab_unlock(c->page);
 	return object;
 }
@@ -1571,7 +1540,7 @@ static void __always_inline *slab_alloc(
 
 	else {
 		object = c->freelist;
-		c->freelist = object[c->page->offset];
+		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
 
@@ -1604,7 +1573,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-					void *x, void *addr)
+				void *x, void *addr, unsigned int offset)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1614,7 +1583,7 @@ static void __slab_free(struct kmem_cach
 	if (unlikely(SlabDebug(page)))
 		goto debug;
 checks_ok:
-	prior = object[page->offset] = page->freelist;
+	prior = object[offset] = page->freelist;
 	page->freelist = object;
 	page->inuse--;
 
@@ -1675,10 +1644,10 @@ static void __always_inline slab_free(st
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
 	if (likely(page == c->page && !SlabDebug(page))) {
-		object[page->offset] = c->freelist;
+		object[c->offset] = c->freelist;
 		c->freelist = object;
 	} else
-		__slab_free(s, page, x, addr);
+		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
 }
@@ -1765,14 +1734,6 @@ static inline int slab_order(int size, i
 	int rem;
 	int min_order = slub_min_order;
 
-	/*
-	 * If we would create too many object per slab then reduce
-	 * the slab order even if it goes below slub_min_order.
-	 */
-	while (min_order > 0 &&
-		(PAGE_SIZE << min_order) >= MAX_OBJECTS_PER_SLAB * size)
-			min_order--;
-
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
 			order <= max_order; order++) {
@@ -1787,9 +1748,6 @@ static inline int slab_order(int size, i
 		if (rem <= slab_size / fract_leftover)
 			break;
 
-		/* If the next size is too high then exit now */
-		if (slab_size * 2 >= MAX_OBJECTS_PER_SLAB * size)
-			break;
 	}
 
 	return order;
@@ -1869,6 +1827,7 @@ static void init_kmem_cache_cpu(struct k
 {
 	c->page = NULL;
 	c->freelist = NULL;
+	c->offset = s->offset / sizeof(void *);
 	c->node = 0;
 }
 
@@ -2101,14 +2060,7 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->objects = (PAGE_SIZE << s->order) / size;
 
-	/*
-	 * Verify that the number of objects is within permitted limits.
-	 * The page->inuse field is only 16 bit wide! So we cannot have
-	 * more than 64k objects per slab.
-	 */
-	if (!s->objects || s->objects > MAX_OBJECTS_PER_SLAB)
-		return 0;
-	return 1;
+	return !!s->objects;
 
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
process_zones-fix-recovery-code.patch
fix-rcu_read_lock-in-page-migraton.patch
do-not-fail-if-we-cannot-register-a-slab-with-sysfs.patch
page-migration-do-not-accept-invalid-nodes-in-the-target-nodeset.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
infiniband-work-around-gcc-slub-problem.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
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
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
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
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
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
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
