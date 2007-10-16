From: akpm@linux-foundation.org
Subject: - slub-move-page-offset-to-kmem_cache_cpu-offset.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:15 -0700
Message-ID: <200710162035.l9GKZFu8015044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964887AbXJPVc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Move page->offset to kmem_cache_cpu->offset
has been removed from the -mm tree.  Its filename was
     slub-move-page-offset-to-kmem_cache_cpu-offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 include/linux/mm_types.h |    5 ---
 include/linux/slub_def.h |    1 
 mm/slub.c                |   52 +++++++------------------------------
 3 files changed, 13 insertions(+), 45 deletions(-)

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
@@ -1104,7 +1092,6 @@ static struct page *new_slab(struct kmem
 	n = get_node(s, page_to_nid(page));
 	if (n)
 		atomic_long_inc(&n->nr_slabs);
-	page->offset = s->offset / sizeof(void *);
 	page->slab = s;
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
@@ -1398,10 +1385,10 @@ static void deactivate_slab(struct kmem_
 
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
@@ -1497,7 +1484,7 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->page->offset];
+	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
@@ -1549,7 +1536,7 @@ debug:
 		goto another_slab;
 
 	c->page->inuse++;
-	c->page->freelist = object[c->page->offset];
+	c->page->freelist = object[c->offset];
 	slab_unlock(c->page);
 	return object;
 }
@@ -1580,7 +1567,7 @@ static void __always_inline *slab_alloc(
 
 	else {
 		object = c->freelist;
-		c->freelist = object[c->page->offset];
+		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
 
@@ -1613,7 +1600,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-					void *x, void *addr)
+				void *x, void *addr, unsigned int offset)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1623,7 +1610,7 @@ static void __slab_free(struct kmem_cach
 	if (unlikely(SlabDebug(page)))
 		goto debug;
 checks_ok:
-	prior = object[page->offset] = page->freelist;
+	prior = object[offset] = page->freelist;
 	page->freelist = object;
 	page->inuse--;
 
@@ -1684,10 +1671,10 @@ static void __always_inline slab_free(st
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
@@ -1774,14 +1761,6 @@ static inline int slab_order(int size, i
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
@@ -1796,9 +1775,6 @@ static inline int slab_order(int size, i
 		if (rem <= slab_size / fract_leftover)
 			break;
 
-		/* If the next size is too high then exit now */
-		if (slab_size * 2 >= MAX_OBJECTS_PER_SLAB * size)
-			break;
 	}
 
 	return order;
@@ -1878,6 +1854,7 @@ static void init_kmem_cache_cpu(struct k
 {
 	c->page = NULL;
 	c->freelist = NULL;
+	c->offset = s->offset / sizeof(void *);
 	c->node = 0;
 }
 
@@ -2110,14 +2087,7 @@ static int calculate_sizes(struct kmem_c
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
