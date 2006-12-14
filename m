From: akpm@osdl.org
Subject: - more-slabh-cleanups.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:06:41 -0800
Message-ID: <200612140606.kBE66fM3001880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbWLNGHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:07:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     More slab.h cleanups
has been removed from the -mm tree.  Its filename was
     more-slabh-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: More slab.h cleanups
From: Christoph Lameter <clameter@sgi.com>

More cleanups for slab.h

1. Remove tabs from weird locations as suggested by Pekka

2. Drop the check for NUMA and SLAB_DEBUG from the fallback section
   as suggested by Pekka.

3. Uses static inline for the fallback defs as also suggested by Pekka.

4. Make kmem_ptr_valid take a const * argument.

5. Separate the NUMA fallback definitions from the kmalloc_track fallback
   definitions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/slab.h |   44 ++++++++++++++++++++++-------------------
 mm/slab.c            |    2 -
 mm/slob.c            |    2 -
 3 files changed, 26 insertions(+), 22 deletions(-)

diff -puN include/linux/slab.h~more-slabh-cleanups include/linux/slab.h
--- a/include/linux/slab.h~more-slabh-cleanups
+++ a/include/linux/slab.h
@@ -20,11 +20,11 @@ typedef struct kmem_cache kmem_cache_t _
  * Flags to pass to kmem_cache_create().
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
  */
-#define	SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
-#define	SLAB_DEBUG_INITIAL	0x00000200UL	/* DEBUG: Call constructor (as verifier) */
-#define	SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
-#define	SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
-#define	SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
+#define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
+#define SLAB_DEBUG_INITIAL	0x00000200UL	/* DEBUG: Call constructor (as verifier) */
+#define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
+#define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
+#define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
 #define SLAB_MUST_HWCACHE_ALIGN	0x00008000UL	/* Force alignment even if debuggin is active */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
@@ -34,9 +34,9 @@ typedef struct kmem_cache kmem_cache_t _
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 
 /* Flags passed to a constructor functions */
-#define	SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
+#define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
 #define SLAB_CTOR_ATOMIC	0x002UL		/* Tell constructor it can't sleep */
-#define	SLAB_CTOR_VERIFY	0x004UL		/* Tell constructor it's a verify call */
+#define SLAB_CTOR_VERIFY	0x004UL		/* Tell constructor it's a verify call */
 
 /*
  * struct kmem_cache related prototypes
@@ -55,7 +55,7 @@ void *kmem_cache_zalloc(struct kmem_cach
 void kmem_cache_free(struct kmem_cache *, void *);
 unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
-int kmem_ptr_validate(struct kmem_cache *cachep, void *ptr);
+int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
 #ifdef CONFIG_NUMA
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
@@ -93,19 +93,15 @@ static inline void *kcalloc(size_t n, si
  * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by selecting
  * the appropriate general cache at compile time.
  */
+
 #ifdef CONFIG_SLAB
 #include <linux/slab_def.h>
 #else
-
 /*
  * Fallback definitions for an allocator not wanting to provide
  * its own optimized kmalloc definitions (like SLOB).
  */
 
-#if defined(CONFIG_NUMA) || defined(CONFIG_DEBUG_SLAB)
-#error "SLAB fallback definitions not usable for NUMA or Slab debug"
-#endif
-
 /**
  * kmalloc - allocate memory
  * @size: how many bytes of memory are required.
@@ -151,7 +147,7 @@ static inline void *kcalloc(size_t n, si
  *
  * %__GFP_REPEAT - If allocation fails initially, try once more before failing.
  */
-void *kmalloc(size_t size, gfp_t flags)
+static inline void *kmalloc(size_t size, gfp_t flags)
 {
 	return __kmalloc(size, flags);
 }
@@ -161,12 +157,24 @@ void *kmalloc(size_t size, gfp_t flags)
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-void *kzalloc(size_t size, gfp_t flags)
+static inline void *kzalloc(size_t size, gfp_t flags)
 {
 	return __kzalloc(size, flags);
 }
 #endif
 
+#ifndef CONFIG_NUMA
+static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	return kmalloc(size, flags);
+}
+
+static inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	return __kmalloc(size, flags);
+}
+#endif /* !CONFIG_NUMA */
+
 /*
  * kmalloc_track_caller is a special version of kmalloc that records the
  * calling function of the routine calling it for slab leak tracking instead
@@ -208,12 +216,8 @@ extern void *__kmalloc_node_track_caller
 #define kmalloc_node_track_caller(size, flags, node) \
 	kmalloc_track_caller(size, flags)
 
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
-{
-	return kmalloc(size, flags);
-}
+#endif /* DEBUG_SLAB */
 
-#endif /* !CONFIG_NUMA */
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
 
diff -puN mm/slab.c~more-slabh-cleanups mm/slab.c
--- a/mm/slab.c~more-slabh-cleanups
+++ a/mm/slab.c
@@ -3541,7 +3541,7 @@ EXPORT_SYMBOL(kmem_cache_zalloc);
  *
  * Currently only used for dentry validation.
  */
-int fastcall kmem_ptr_validate(struct kmem_cache *cachep, void *ptr)
+int fastcall kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr)
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long min_addr = PAGE_OFFSET;
diff -puN mm/slob.c~more-slabh-cleanups mm/slob.c
--- a/mm/slob.c~more-slabh-cleanups
+++ a/mm/slob.c
@@ -334,7 +334,7 @@ int kmem_cache_shrink(struct kmem_cache 
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-int kmem_ptr_validate(struct kmem_cache *a, void *b)
+int kmem_ptr_validate(struct kmem_cache *a, const void *b)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

config_vm_event_counter-comment-decrustify.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

