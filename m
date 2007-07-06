From: akpm@linux-foundation.org
Subject: + slab-allocators-cleanup-zeroing-allocations.patch added to -mm tree
Date: Fri, 06 Jul 2007 16:21:26 -0700
Message-ID: <200707062321.l66NLQ5F026541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbXGFXVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 19:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Slab allocators: Cleanup zeroing allocations
has been added to the -mm tree.  Its filename is
     slab-allocators-cleanup-zeroing-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Slab allocators: Cleanup zeroing allocations
From: Christoph Lameter <clameter@sgi.com>

It becomes now easy to support the zeroing allocs with generic inline
functions in slab.h.  Provide inline definitions to allow the continued use of
kzalloc, kmem_cache_zalloc etc but remove other definitions of zeroing
functions from the slab allocators and util.c.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |   77 ++++++++++++++++++++++---------------
 include/linux/slab_def.h |   30 --------------
 include/linux/slub_def.h |   13 ------
 mm/slab.c                |   17 --------
 mm/slob.c                |   10 ----
 mm/slub.c                |   11 -----
 mm/util.c                |   14 ------
 7 files changed, 46 insertions(+), 126 deletions(-)

diff -puN include/linux/slab.h~slab-allocators-cleanup-zeroing-allocations include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-cleanup-zeroing-allocations
+++ a/include/linux/slab.h
@@ -57,7 +57,6 @@ struct kmem_cache *kmem_cache_create(con
 			void (*)(void *, struct kmem_cache *, unsigned long));
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
-void *kmem_cache_zalloc(struct kmem_cache *, gfp_t);
 void kmem_cache_free(struct kmem_cache *, void *);
 unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
@@ -93,11 +92,37 @@ int kmem_ptr_validate(struct kmem_cache 
 /*
  * Common kmalloc functions provided by all allocators
  */
-void *__kzalloc(size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 size_t ksize(const void *);
 
+/*
+ * Allocator specific definitions. These are mainly used to establish optimized
+ * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by
+ * selecting the appropriate general cache at compile time.
+ *
+ * Allocators must define at least:
+ *
+ *	kmem_cache_alloc()
+ *	__kmalloc()
+ *	kmalloc()
+ *
+ * Those wishing to support NUMA must also define:
+ *
+ *	kmem_cache_alloc_node()
+ *	kmalloc_node()
+ *
+ * See each allocator definition file for additional comments and
+ * implementation notes.
+ */
+#ifdef CONFIG_SLUB
+#include <linux/slub_def.h>
+#elif defined(CONFIG_SLOB)
+#include <linux/slob_def.h>
+#else
+#include <linux/slab_def.h>
+#endif
+
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
  * @n: number of elements.
@@ -153,37 +178,9 @@ static inline void *kcalloc(size_t n, si
 {
 	if (n != 0 && size > ULONG_MAX / n)
 		return NULL;
-	return __kzalloc(n * size, flags);
+	return __kmalloc(n * size, flags | __GFP_ZERO);
 }
 
-/*
- * Allocator specific definitions. These are mainly used to establish optimized
- * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by
- * selecting the appropriate general cache at compile time.
- *
- * Allocators must define at least:
- *
- *	kmem_cache_alloc()
- *	__kmalloc()
- *	kmalloc()
- *	kzalloc()
- *
- * Those wishing to support NUMA must also define:
- *
- *	kmem_cache_alloc_node()
- *	kmalloc_node()
- *
- * See each allocator definition file for additional comments and
- * implementation notes.
- */
-#ifdef CONFIG_SLUB
-#include <linux/slub_def.h>
-#elif defined(CONFIG_SLOB)
-#include <linux/slob_def.h>
-#else
-#include <linux/slab_def.h>
-#endif
-
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
 /**
  * kmalloc_node - allocate memory from a specific node
@@ -257,5 +254,23 @@ extern void *__kmalloc_node_track_caller
 
 #endif /* DEBUG_SLAB */
 
+/*
+ * Shortcuts
+ */
+static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
+{
+	return kmem_cache_alloc(k, flags | __GFP_ZERO);
+}
+
+/**
+ * kzalloc - allocate memory. The memory is set to zero.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *kzalloc(size_t size, gfp_t flags)
+{
+	return kmalloc(size, flags | __GFP_ZERO);
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
diff -puN include/linux/slab_def.h~slab-allocators-cleanup-zeroing-allocations include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-allocators-cleanup-zeroing-allocations
+++ a/include/linux/slab_def.h
@@ -58,36 +58,6 @@ found:
 	return __kmalloc(size, flags);
 }
 
-static inline void *kzalloc(size_t size, gfp_t flags)
-{
-	if (__builtin_constant_p(size)) {
-		int i = 0;
-
-		if (!size)
-			return ZERO_SIZE_PTR;
-
-#define CACHE(x) \
-		if (size <= x) \
-			goto found; \
-		else \
-			i++;
-#include "kmalloc_sizes.h"
-#undef CACHE
-		{
-			extern void __you_cannot_kzalloc_that_much(void);
-			__you_cannot_kzalloc_that_much();
-		}
-found:
-#ifdef CONFIG_ZONE_DMA
-		if (flags & GFP_DMA)
-			return kmem_cache_zalloc(malloc_sizes[i].cs_dmacachep,
-						flags);
-#endif
-		return kmem_cache_zalloc(malloc_sizes[i].cs_cachep, flags);
-	}
-	return __kzalloc(size, flags);
-}
-
 #ifdef CONFIG_NUMA
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
diff -puN include/linux/slub_def.h~slab-allocators-cleanup-zeroing-allocations include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-allocators-cleanup-zeroing-allocations
+++ a/include/linux/slub_def.h
@@ -179,19 +179,6 @@ static inline void *kmalloc(size_t size,
 		return __kmalloc(size, flags);
 }
 
-static inline void *kzalloc(size_t size, gfp_t flags)
-{
-	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
-		struct kmem_cache *s = kmalloc_slab(size);
-
-		if (!s)
-			return ZERO_SIZE_PTR;
-
-		return kmem_cache_zalloc(s, flags);
-	} else
-		return __kzalloc(size, flags);
-}
-
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
diff -puN mm/slab.c~slab-allocators-cleanup-zeroing-allocations mm/slab.c
--- a/mm/slab.c~slab-allocators-cleanup-zeroing-allocations
+++ a/mm/slab.c
@@ -3592,23 +3592,6 @@ void *kmem_cache_alloc(struct kmem_cache
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 /**
- * kmem_cache_zalloc - Allocate an object. The memory is set to zero.
- * @cache: The cache to allocate from.
- * @flags: See kmalloc().
- *
- * Allocate an object from this cache and set the allocated memory to zero.
- * The flags are only relevant if the cache has no available objects.
- */
-void *kmem_cache_zalloc(struct kmem_cache *cache, gfp_t flags)
-{
-	void *ret = __cache_alloc(cache, flags, __builtin_return_address(0));
-	if (ret)
-		memset(ret, 0, obj_size(cache));
-	return ret;
-}
-EXPORT_SYMBOL(kmem_cache_zalloc);
-
-/**
  * kmem_ptr_validate - check if an untrusted pointer might
  *	be a slab entry.
  * @cachep: the cache we're checking against
diff -puN mm/slob.c~slab-allocators-cleanup-zeroing-allocations mm/slob.c
--- a/mm/slob.c~slab-allocators-cleanup-zeroing-allocations
+++ a/mm/slob.c
@@ -543,16 +543,6 @@ void *kmem_cache_alloc_node(struct kmem_
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
-void *kmem_cache_zalloc(struct kmem_cache *c, gfp_t flags)
-{
-	void *ret = kmem_cache_alloc(c, flags);
-	if (ret)
-		memset(ret, 0, c->size);
-
-	return ret;
-}
-EXPORT_SYMBOL(kmem_cache_zalloc);
-
 static void __kmem_cache_free(void *b, int size)
 {
 	if (size < PAGE_SIZE)
diff -puN mm/slub.c~slab-allocators-cleanup-zeroing-allocations mm/slub.c
--- a/mm/slub.c~slab-allocators-cleanup-zeroing-allocations
+++ a/mm/slub.c
@@ -2730,17 +2730,6 @@ err:
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
-void *kmem_cache_zalloc(struct kmem_cache *s, gfp_t flags)
-{
-	void *x;
-
-	x = slab_alloc(s, flags, -1, __builtin_return_address(0));
-	if (x)
-		memset(x, 0, s->objsize);
-	return x;
-}
-EXPORT_SYMBOL(kmem_cache_zalloc);
-
 #ifdef CONFIG_SMP
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
diff -puN mm/util.c~slab-allocators-cleanup-zeroing-allocations mm/util.c
--- a/mm/util.c~slab-allocators-cleanup-zeroing-allocations
+++ a/mm/util.c
@@ -5,20 +5,6 @@
 #include <asm/uaccess.h>
 
 /**
- * __kzalloc - allocate memory. The memory is set to zero.
- * @size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- */
-void *__kzalloc(size_t size, gfp_t flags)
-{
-	void *ret = kmalloc_track_caller(size, flags);
-	if (ret)
-		memset(ret, 0, size);
-	return ret;
-}
-EXPORT_SYMBOL(__kzalloc);
-
-/**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-remove-useless-export_symbol.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
x86_64-get-mp_bus_to_node-as-early-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
numa-mempolicy-trivial-debug-fixes.patch
slob-initial-numa-support.patch
mm-fixup-proc-vmstat-output.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slab-allocators-support-__gfp_zero-in-all-allocators-fix.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix-2.patch
slub-simplify-dma-index-size-calculation.patch
mm-slubc-make-code-static.patch
slub-style-fix-up-the-loop-to-disable-small-slabs.patch
slub-do-not-use-length-parameter-in-slab_alloc.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-do-not-allocate-object-bit-array-on-stack.patch
slub-move-sysfs-operations-outside-of-slub_lock.patch
slub-fix-config_slub_debug-use-for-config_numa.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
revoke-core-code.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
