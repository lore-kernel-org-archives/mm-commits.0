From: akpm@osdl.org
Subject: - cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:06:29 -0800
Message-ID: <200612140606.kBE66TdB001872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbWLNGGq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:06:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Cleanup slab headers / API to allow easy addition of new slab allocators
has been removed from the -mm tree.  Its filename was
     cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Cleanup slab headers / API to allow easy addition of new slab allocators
From: Christoph Lameter <clameter@sgi.com>

This is a response to an earlier discussion on linux-mm about splitting
slab.h components per allocator.  Patch is against 2.6.19-git11.  See
http://marc.theaimsgroup.com/?l=linux-mm&m=116469577431008&w=2

This patch cleans up the slab header definitions.  We define the common
functions of slob and slab in slab.h and put the extra definitions needed
for slab's kmalloc implementations in <linux/slab_def.h>.  In order to get
a greater set of common functions we add several empty functions to slob.c
and also rename slob's kmalloc to __kmalloc.

Slob does not need any special definitions since we introduce a fallback
case.  If there is no need for a slab implementation to provide its own
kmalloc mess^H^H^Hacros then we simply fall back to __kmalloc functions. 
That is sufficient for SLOB.

Sort the function in slab.h according to their functionality.  First the
functions operating on struct kmem_cache * then the kmalloc related
functions followed by special debug and fallback definitions.

Also redo a lot of comments.

Signed-off-by: Christoph Lameter <clameter@sgi.com>?
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/slab.h     |  310 +++++++++++++------------------------
 include/linux/slab_def.h |  100 +++++++++++
 mm/slob.c                |   16 +
 3 files changed, 225 insertions(+), 201 deletions(-)

diff -puN include/linux/slab.h~cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab include/linux/slab.h
--- a/include/linux/slab.h~cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab
+++ a/include/linux/slab.h
@@ -1,7 +1,9 @@
 /*
- * linux/include/linux/slab.h
- * Written by Mark Hemment, 1996.
- * (markhe@nextd.demon.co.uk)
+ * Written by Mark Hemment, 1996 (markhe@nextd.demon.co.uk).
+ *
+ * (C) SGI 2006, Christoph Lameter <clameter@sgi.com>
+ * 	Cleaned up and restructured to ease the addition of alternative
+ * 	implementations of SLAB allocators.
  */
 
 #ifndef _LINUX_SLAB_H
@@ -10,64 +12,99 @@
 #ifdef __KERNEL__
 
 #include <linux/gfp.h>
-#include <linux/init.h>
 #include <linux/types.h>
-#include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
-#include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
-#include <linux/compiler.h>
 
-/* kmem_cache_t exists for legacy reasons and is not used by code in mm */
 typedef struct kmem_cache kmem_cache_t __deprecated;
 
-/* flags to pass to kmem_cache_create().
- * The first 3 are only valid when the allocator as been build
- * SLAB_DEBUG_SUPPORT.
- */
-#define	SLAB_DEBUG_FREE		0x00000100UL	/* Peform (expensive) checks on free */
-#define	SLAB_DEBUG_INITIAL	0x00000200UL	/* Call constructor (as verifier) */
-#define	SLAB_RED_ZONE		0x00000400UL	/* Red zone objs in a cache */
-#define	SLAB_POISON		0x00000800UL	/* Poison objects */
-#define	SLAB_HWCACHE_ALIGN	0x00002000UL	/* align objs on a h/w cache lines */
-#define SLAB_CACHE_DMA		0x00004000UL	/* use GFP_DMA memory */
-#define SLAB_MUST_HWCACHE_ALIGN	0x00008000UL	/* force alignment */
-#define SLAB_STORE_USER		0x00010000UL	/* store the last owner for bug hunting */
-#define SLAB_RECLAIM_ACCOUNT	0x00020000UL	/* track pages allocated to indicate
-						   what is reclaimable later*/
-#define SLAB_PANIC		0x00040000UL	/* panic if kmem_cache_create() fails */
-#define SLAB_DESTROY_BY_RCU	0x00080000UL	/* defer freeing pages to RCU */
+/*
+ * Flags to pass to kmem_cache_create().
+ * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
+ */
+#define	SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
+#define	SLAB_DEBUG_INITIAL	0x00000200UL	/* DEBUG: Call constructor (as verifier) */
+#define	SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
+#define	SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
+#define	SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
+#define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
+#define SLAB_MUST_HWCACHE_ALIGN	0x00008000UL	/* Force alignment even if debuggin is active */
+#define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
+#define SLAB_RECLAIM_ACCOUNT	0x00020000UL	/* Objects are reclaimable */
+#define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
+#define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 
-/* flags passed to a constructor func */
-#define	SLAB_CTOR_CONSTRUCTOR	0x001UL		/* if not set, then deconstructor */
-#define SLAB_CTOR_ATOMIC	0x002UL		/* tell constructor it can't sleep */
-#define	SLAB_CTOR_VERIFY	0x004UL		/* tell constructor it's a verify call */
-
-#ifndef CONFIG_SLOB
+/* Flags passed to a constructor functions */
+#define	SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
+#define SLAB_CTOR_ATOMIC	0x002UL		/* Tell constructor it can't sleep */
+#define	SLAB_CTOR_VERIFY	0x004UL		/* Tell constructor it's a verify call */
 
-/* prototypes */
-extern void __init kmem_cache_init(void);
+/*
+ * struct kmem_cache related prototypes
+ */
+void __init kmem_cache_init(void);
+extern int slab_is_available(void);
 
-extern struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
+struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
 			void (*)(void *, struct kmem_cache *, unsigned long),
 			void (*)(void *, struct kmem_cache *, unsigned long));
-extern void kmem_cache_destroy(struct kmem_cache *);
-extern int kmem_cache_shrink(struct kmem_cache *);
-extern void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
-extern void *kmem_cache_zalloc(struct kmem_cache *, gfp_t);
-extern void kmem_cache_free(struct kmem_cache *, void *);
-extern unsigned int kmem_cache_size(struct kmem_cache *);
-extern const char *kmem_cache_name(struct kmem_cache *);
-
-/* Size description struct for general caches. */
-struct cache_sizes {
-	size_t		 	cs_size;
-	struct kmem_cache	*cs_cachep;
-	struct kmem_cache	*cs_dmacachep;
-};
-extern struct cache_sizes malloc_sizes[];
+void kmem_cache_destroy(struct kmem_cache *);
+int kmem_cache_shrink(struct kmem_cache *);
+void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
+void *kmem_cache_zalloc(struct kmem_cache *, gfp_t);
+void kmem_cache_free(struct kmem_cache *, void *);
+unsigned int kmem_cache_size(struct kmem_cache *);
+const char *kmem_cache_name(struct kmem_cache *);
+int kmem_ptr_validate(struct kmem_cache *cachep, void *ptr);
 
-extern void *__kmalloc(size_t, gfp_t);
+#ifdef CONFIG_NUMA
+extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
+#else
+static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
+					gfp_t flags, int node)
+{
+	return kmem_cache_alloc(cachep, flags);
+}
+#endif
+
+/*
+ * Common kmalloc functions provided by all allocators
+ */
+void *__kmalloc(size_t, gfp_t);
+void *__kzalloc(size_t, gfp_t);
+void kfree(const void *);
+unsigned int ksize(const void *);
+
+/**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate.
+ */
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	if (n != 0 && size > ULONG_MAX / n)
+		return NULL;
+	return __kzalloc(n * size, flags);
+}
+
+/*
+ * Allocator specific definitions. These are mainly used to establish optimized
+ * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by selecting
+ * the appropriate general cache at compile time.
+ */
+#ifdef CONFIG_SLAB
+#include <linux/slab_def.h>
+#else
+
+/*
+ * Fallback definitions for an allocator not wanting to provide
+ * its own optimized kmalloc definitions (like SLOB).
+ */
+
+#if defined(CONFIG_NUMA) || defined(CONFIG_DEBUG_SLAB)
+#error "SLAB fallback definitions not usable for NUMA or Slab debug"
+#endif
 
 /**
  * kmalloc - allocate memory
@@ -114,29 +151,22 @@ extern void *__kmalloc(size_t, gfp_t);
  *
  * %__GFP_REPEAT - If allocation fails initially, try once more before failing.
  */
-static inline void *kmalloc(size_t size, gfp_t flags)
+void *kmalloc(size_t size, gfp_t flags)
 {
-	if (__builtin_constant_p(size)) {
-		int i = 0;
-#define CACHE(x) \
-		if (size <= x) \
-			goto found; \
-		else \
-			i++;
-#include "kmalloc_sizes.h"
-#undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
-found:
-		return kmem_cache_alloc((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags);
-	}
 	return __kmalloc(size, flags);
 }
 
+/**
+ * kzalloc - allocate memory. The memory is set to zero.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *kzalloc(size_t size, gfp_t flags)
+{
+	return __kzalloc(size, flags);
+}
+#endif
+
 /*
  * kmalloc_track_caller is a special version of kmalloc that records the
  * calling function of the routine calling it for slab leak tracking instead
@@ -145,89 +175,16 @@ found:
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-#ifndef CONFIG_DEBUG_SLAB
-#define kmalloc_track_caller(size, flags) \
-	__kmalloc(size, flags)
-#else
+#ifdef CONFIG_DEBUG_SLAB
 extern void *__kmalloc_track_caller(size_t, gfp_t, void*);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, __builtin_return_address(0))
-#endif
-
-extern void *__kzalloc(size_t, gfp_t);
-
-/**
- * kzalloc - allocate memory. The memory is set to zero.
- * @size: how many bytes of memory are required.
- * @flags: the type of memory to allocate (see kmalloc).
- */
-static inline void *kzalloc(size_t size, gfp_t flags)
-{
-	if (__builtin_constant_p(size)) {
-		int i = 0;
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
-		return kmem_cache_zalloc((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags);
-	}
-	return __kzalloc(size, flags);
-}
-
-/**
- * kcalloc - allocate memory for an array. The memory is set to zero.
- * @n: number of elements.
- * @size: element size.
- * @flags: the type of memory to allocate.
- */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
-{
-	if (n != 0 && size > ULONG_MAX / n)
-		return NULL;
-	return kzalloc(n * size, flags);
-}
-
-extern void kfree(const void *);
-extern unsigned int ksize(const void *);
-extern int slab_is_available(void);
+#else
+#define kmalloc_track_caller(size, flags) \
+	__kmalloc(size, flags)
+#endif /* DEBUG_SLAB */
 
 #ifdef CONFIG_NUMA
-extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
-extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
-
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
-{
-	if (__builtin_constant_p(size)) {
-		int i = 0;
-#define CACHE(x) \
-		if (size <= x) \
-			goto found; \
-		else \
-			i++;
-#include "kmalloc_sizes.h"
-#undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
-found:
-		return kmem_cache_alloc_node((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags, node);
-	}
-	return __kmalloc_node(size, flags, node);
-}
-
 /*
  * kmalloc_node_track_caller is a special version of kmalloc_node that
  * records the calling function of the routine calling it for slab leak
@@ -236,70 +193,27 @@ found:
  * standard allocator where we care about the real place the memory
  * allocation request comes from.
  */
-#ifndef CONFIG_DEBUG_SLAB
-#define kmalloc_node_track_caller(size, flags, node) \
-	__kmalloc_node(size, flags, node)
-#else
+#ifdef CONFIG_DEBUG_SLAB
 extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			__builtin_return_address(0))
+#else
+#define kmalloc_node_track_caller(size, flags, node) \
+	__kmalloc_node(size, flags, node)
 #endif
+
 #else /* CONFIG_NUMA */
-static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
-					gfp_t flags, int node)
-{
-	return kmem_cache_alloc(cachep, flags);
-}
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
-{
-	return kmalloc(size, flags);
-}
 
 #define kmalloc_node_track_caller(size, flags, node) \
 	kmalloc_track_caller(size, flags)
-#endif
 
-extern int FASTCALL(kmem_cache_reap(int));
-extern int FASTCALL(kmem_ptr_validate(struct kmem_cache *cachep, void *ptr));
-
-#else /* CONFIG_SLOB */
-
-/* SLOB allocator routines */
-
-void kmem_cache_init(void);
-struct kmem_cache *kmem_cache_create(const char *c, size_t, size_t,
-	unsigned long,
-	void (*)(void *, struct kmem_cache *, unsigned long),
-	void (*)(void *, struct kmem_cache *, unsigned long));
-void kmem_cache_destroy(struct kmem_cache *c);
-void *kmem_cache_alloc(struct kmem_cache *c, gfp_t flags);
-void *kmem_cache_zalloc(struct kmem_cache *, gfp_t);
-void kmem_cache_free(struct kmem_cache *c, void *b);
-const char *kmem_cache_name(struct kmem_cache *);
-void *kmalloc(size_t size, gfp_t flags);
-void *__kzalloc(size_t size, gfp_t flags);
-void kfree(const void *m);
-unsigned int ksize(const void *m);
-unsigned int kmem_cache_size(struct kmem_cache *c);
-
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	return __kzalloc(n * size, flags);
+	return kmalloc(size, flags);
 }
 
-#define kmem_cache_shrink(d) (0)
-#define kmem_cache_reap(a)
-#define kmem_ptr_validate(a, b) (0)
-#define kmem_cache_alloc_node(c, f, n) kmem_cache_alloc(c, f)
-#define kmalloc_node(s, f, n) kmalloc(s, f)
-#define kzalloc(s, f) __kzalloc(s, f)
-#define kmalloc_track_caller kmalloc
-
-#define kmalloc_node_track_caller kmalloc_node
-
-#endif /* CONFIG_SLOB */
-
+#endif /* !CONFIG_NUMA */
 #endif	/* __KERNEL__ */
-
 #endif	/* _LINUX_SLAB_H */
+
diff -puN /dev/null include/linux/slab_def.h
--- /dev/null
+++ a/include/linux/slab_def.h
@@ -0,0 +1,100 @@
+#ifndef _LINUX_SLAB_DEF_H
+#define	_LINUX_SLAB_DEF_H
+
+/*
+ * Definitions unique to the original Linux SLAB allocator.
+ *
+ * What we provide here is a way to optimize the frequent kmalloc
+ * calls in the kernel by selecting the appropriate general cache
+ * if kmalloc was called with a size that can be established at
+ * compile time.
+ */
+
+#include <linux/init.h>
+#include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
+#include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
+#include <linux/compiler.h>
+
+/* Size description struct for general caches. */
+struct cache_sizes {
+	size_t		 	cs_size;
+	struct kmem_cache	*cs_cachep;
+	struct kmem_cache	*cs_dmacachep;
+};
+extern struct cache_sizes malloc_sizes[];
+
+static inline void *kmalloc(size_t size, gfp_t flags)
+{
+	if (__builtin_constant_p(size)) {
+		int i = 0;
+#define CACHE(x) \
+		if (size <= x) \
+			goto found; \
+		else \
+			i++;
+#include "kmalloc_sizes.h"
+#undef CACHE
+		{
+			extern void __you_cannot_kmalloc_that_much(void);
+			__you_cannot_kmalloc_that_much();
+		}
+found:
+		return kmem_cache_alloc((flags & GFP_DMA) ?
+			malloc_sizes[i].cs_dmacachep :
+			malloc_sizes[i].cs_cachep, flags);
+	}
+	return __kmalloc(size, flags);
+}
+
+static inline void *kzalloc(size_t size, gfp_t flags)
+{
+	if (__builtin_constant_p(size)) {
+		int i = 0;
+#define CACHE(x) \
+		if (size <= x) \
+			goto found; \
+		else \
+			i++;
+#include "kmalloc_sizes.h"
+#undef CACHE
+		{
+			extern void __you_cannot_kzalloc_that_much(void);
+			__you_cannot_kzalloc_that_much();
+		}
+found:
+		return kmem_cache_zalloc((flags & GFP_DMA) ?
+			malloc_sizes[i].cs_dmacachep :
+			malloc_sizes[i].cs_cachep, flags);
+	}
+	return __kzalloc(size, flags);
+}
+
+#ifdef CONFIG_NUMA
+extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
+
+static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	if (__builtin_constant_p(size)) {
+		int i = 0;
+#define CACHE(x) \
+		if (size <= x) \
+			goto found; \
+		else \
+			i++;
+#include "kmalloc_sizes.h"
+#undef CACHE
+		{
+			extern void __you_cannot_kmalloc_that_much(void);
+			__you_cannot_kmalloc_that_much();
+		}
+found:
+		return kmem_cache_alloc_node((flags & GFP_DMA) ?
+			malloc_sizes[i].cs_dmacachep :
+			malloc_sizes[i].cs_cachep, flags, node);
+	}
+	return __kmalloc_node(size, flags, node);
+}
+
+#endif	/* CONFIG_NUMA */
+
+#endif	/* _LINUX_SLAB_DEF_H */
diff -puN mm/slob.c~cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab mm/slob.c
--- a/mm/slob.c~cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab
+++ a/mm/slob.c
@@ -157,7 +157,7 @@ static int fastcall find_order(int size)
 	return order;
 }
 
-void *kmalloc(size_t size, gfp_t gfp)
+void *__kmalloc(size_t size, gfp_t gfp)
 {
 	slob_t *m;
 	bigblock_t *bb;
@@ -186,8 +186,7 @@ void *kmalloc(size_t size, gfp_t gfp)
 	slob_free(bb, sizeof(bigblock_t));
 	return 0;
 }
-
-EXPORT_SYMBOL(kmalloc);
+EXPORT_SYMBOL(__kmalloc);
 
 void kfree(const void *block)
 {
@@ -329,6 +328,17 @@ EXPORT_SYMBOL(kmem_cache_name);
 static struct timer_list slob_timer = TIMER_INITIALIZER(
 	(void (*)(unsigned long))kmem_cache_init, 0, 0);
 
+int kmem_cache_shrink(struct kmem_cache *d)
+{
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_shrink);
+
+int kmem_ptr_validate(struct kmem_cache *a, void *b)
+{
+	return 0;
+}
+
 void kmem_cache_init(void)
 {
 	void *p = slob_alloc(PAGE_SIZE, 0, PAGE_SIZE-1);
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

