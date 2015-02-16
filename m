From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:10 -0800
Message-ID: <54e25082.ewo1GmVOKWBpaQVZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbBPUSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: add kernel address sanitizer support for slub allocator
has been removed from the -mm tree.  Its filename was
     mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: slub: add kernel address sanitizer support for slub allocator

With this patch kasan will be able to catch bugs in memory allocated by
slub.  Initially all objects in newly allocated slab page, marked as
redzone.  Later, when allocation of slub object happens, requested by
caller number of bytes marked as accessible, and the rest of the object
(including slub's metadata) marked as redzone (inaccessible).

We also mark object as accessible if ksize was called for this object. 
There is some places in kernel where ksize function is called to inquire
size of really allocated area.  Such callers could validly access whole
allocated memory, so it should be marked as accessible.

Code in slub.c and slab_common.c files could validly access to object's
metadata, so instrumentation for this files are disabled.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Dmitry Chernenkov <dmitryc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   27 +++++++++++
 include/linux/slab.h  |   11 +++-
 lib/Kconfig.kasan     |    1 
 mm/Makefile           |    3 +
 mm/kasan/kasan.c      |   98 ++++++++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h      |    5 ++
 mm/kasan/report.c     |   21 ++++++++
 mm/slab_common.c      |    5 +-
 mm/slub.c             |   31 +++++++++++-
 9 files changed, 197 insertions(+), 5 deletions(-)

diff -puN include/linux/kasan.h~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator include/linux/kasan.h
--- a/include/linux/kasan.h~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/include/linux/kasan.h
@@ -37,6 +37,18 @@ void kasan_unpoison_shadow(const void *a
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
 
+void kasan_poison_slab(struct page *page);
+void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
+void kasan_poison_object_data(struct kmem_cache *cache, void *object);
+
+void kasan_kmalloc_large(const void *ptr, size_t size);
+void kasan_kfree_large(const void *ptr);
+void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size);
+void kasan_krealloc(const void *object, size_t new_size);
+
+void kasan_slab_alloc(struct kmem_cache *s, void *object);
+void kasan_slab_free(struct kmem_cache *s, void *object);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -47,6 +59,21 @@ static inline void kasan_disable_current
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 
+static inline void kasan_poison_slab(struct page *page) {}
+static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
+					void *object) {}
+static inline void kasan_poison_object_data(struct kmem_cache *cache,
+					void *object) {}
+
+static inline void kasan_kmalloc_large(void *ptr, size_t size) {}
+static inline void kasan_kfree_large(const void *ptr) {}
+static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
+				size_t size) {}
+static inline void kasan_krealloc(const void *object, size_t new_size) {}
+
+static inline void kasan_slab_alloc(struct kmem_cache *s, void *object) {}
+static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff -puN include/linux/slab.h~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator include/linux/slab.h
--- a/include/linux/slab.h~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/include/linux/slab.h
@@ -104,6 +104,7 @@
 				(unsigned long)ZERO_SIZE_PTR)
 
 #include <linux/kmemleak.h>
+#include <linux/kasan.h>
 
 struct mem_cgroup;
 /*
@@ -325,7 +326,10 @@ kmem_cache_alloc_node_trace(struct kmem_
 static __always_inline void *kmem_cache_alloc_trace(struct kmem_cache *s,
 		gfp_t flags, size_t size)
 {
-	return kmem_cache_alloc(s, flags);
+	void *ret = kmem_cache_alloc(s, flags);
+
+	kasan_kmalloc(s, ret, size);
+	return ret;
 }
 
 static __always_inline void *
@@ -333,7 +337,10 @@ kmem_cache_alloc_node_trace(struct kmem_
 			      gfp_t gfpflags,
 			      int node, size_t size)
 {
-	return kmem_cache_alloc_node(s, gfpflags, node);
+	void *ret = kmem_cache_alloc_node(s, gfpflags, node);
+
+	kasan_kmalloc(s, ret, size);
+	return ret;
 }
 #endif /* CONFIG_TRACING */
 
diff -puN lib/Kconfig.kasan~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/lib/Kconfig.kasan
@@ -5,6 +5,7 @@ if HAVE_ARCH_KASAN
 
 config KASAN
 	bool "KASan: runtime memory debugger"
+	depends on SLUB_DEBUG
 	help
 	  Enables kernel address sanitizer - runtime memory debugger,
 	  designed to find out-of-bounds accesses and use-after-free bugs.
diff -puN mm/Makefile~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator mm/Makefile
--- a/mm/Makefile~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/mm/Makefile
@@ -2,6 +2,9 @@
 # Makefile for the linux memory manager.
 #
 
+KASAN_SANITIZE_slab_common.o := n
+KASAN_SANITIZE_slub.o := n
+
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= gup.o highmem.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
diff -puN mm/kasan/kasan.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/mm/kasan/kasan.c
@@ -31,6 +31,7 @@
 #include <linux/kasan.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 /*
  * Poisons the shadow memory for 'size' bytes starting from 'addr'.
@@ -268,6 +269,103 @@ void kasan_free_pages(struct page *page,
 				KASAN_FREE_PAGE);
 }
 
+void kasan_poison_slab(struct page *page)
+{
+	kasan_poison_shadow(page_address(page),
+			PAGE_SIZE << compound_order(page),
+			KASAN_KMALLOC_REDZONE);
+}
+
+void kasan_unpoison_object_data(struct kmem_cache *cache, void *object)
+{
+	kasan_unpoison_shadow(object, cache->object_size);
+}
+
+void kasan_poison_object_data(struct kmem_cache *cache, void *object)
+{
+	kasan_poison_shadow(object,
+			round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE),
+			KASAN_KMALLOC_REDZONE);
+}
+
+void kasan_slab_alloc(struct kmem_cache *cache, void *object)
+{
+	kasan_kmalloc(cache, object, cache->object_size);
+}
+
+void kasan_slab_free(struct kmem_cache *cache, void *object)
+{
+	unsigned long size = cache->object_size;
+	unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
+
+	/* RCU slabs could be legally used after free within the RCU period */
+	if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
+		return;
+
+	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
+}
+
+void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size)
+{
+	unsigned long redzone_start;
+	unsigned long redzone_end;
+
+	if (unlikely(object == NULL))
+		return;
+
+	redzone_start = round_up((unsigned long)(object + size),
+				KASAN_SHADOW_SCALE_SIZE);
+	redzone_end = round_up((unsigned long)object + cache->object_size,
+				KASAN_SHADOW_SCALE_SIZE);
+
+	kasan_unpoison_shadow(object, size);
+	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
+		KASAN_KMALLOC_REDZONE);
+}
+EXPORT_SYMBOL(kasan_kmalloc);
+
+void kasan_kmalloc_large(const void *ptr, size_t size)
+{
+	struct page *page;
+	unsigned long redzone_start;
+	unsigned long redzone_end;
+
+	if (unlikely(ptr == NULL))
+		return;
+
+	page = virt_to_page(ptr);
+	redzone_start = round_up((unsigned long)(ptr + size),
+				KASAN_SHADOW_SCALE_SIZE);
+	redzone_end = (unsigned long)ptr + (PAGE_SIZE << compound_order(page));
+
+	kasan_unpoison_shadow(ptr, size);
+	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
+		KASAN_PAGE_REDZONE);
+}
+
+void kasan_krealloc(const void *object, size_t size)
+{
+	struct page *page;
+
+	if (unlikely(object == ZERO_SIZE_PTR))
+		return;
+
+	page = virt_to_head_page(object);
+
+	if (unlikely(!PageSlab(page)))
+		kasan_kmalloc_large(object, size);
+	else
+		kasan_kmalloc(page->slab_cache, object, size);
+}
+
+void kasan_kfree_large(const void *ptr)
+{
+	struct page *page = virt_to_page(ptr);
+
+	kasan_poison_shadow(ptr, PAGE_SIZE << compound_order(page),
+			KASAN_FREE_PAGE);
+}
+
 #define DEFINE_ASAN_LOAD_STORE(size)				\
 	void __asan_load##size(unsigned long addr)		\
 	{							\
diff -puN mm/kasan/kasan.h~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/mm/kasan/kasan.h
@@ -7,6 +7,11 @@
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
 #define KASAN_FREE_PAGE         0xFF  /* page was freed */
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
+#define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
+#define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
+#define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
+
 
 struct kasan_access_info {
 	const void *access_addr;
diff -puN mm/kasan/report.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator mm/kasan/report.c
--- a/mm/kasan/report.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/mm/kasan/report.c
@@ -24,6 +24,7 @@
 #include <linux/kasan.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 /* Shadow layout customization. */
 #define SHADOW_BYTES_PER_BLOCK 1
@@ -55,8 +56,11 @@ static void print_error_description(stru
 
 	switch (shadow_val) {
 	case KASAN_FREE_PAGE:
+	case KASAN_KMALLOC_FREE:
 		bug_type = "use after free";
 		break;
+	case KASAN_PAGE_REDZONE:
+	case KASAN_KMALLOC_REDZONE:
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "out of bounds access";
 		break;
@@ -77,6 +81,23 @@ static void print_address_description(st
 	if ((addr >= (void *)PAGE_OFFSET) &&
 		(addr < high_memory)) {
 		struct page *page = virt_to_head_page(addr);
+
+		if (PageSlab(page)) {
+			void *object;
+			struct kmem_cache *cache = page->slab_cache;
+			void *last_object;
+
+			object = virt_to_obj(cache, page_address(page), addr);
+			last_object = page_address(page) +
+				page->objects * cache->size;
+
+			if (unlikely(object > last_object))
+				object = last_object; /* we hit into padding */
+
+			object_err(cache, page, object,
+				"kasan: bad access detected");
+			return;
+		}
 		dump_page(page, "kasan: bad access detected");
 	}
 
diff -puN mm/slab_common.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator mm/slab_common.c
--- a/mm/slab_common.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/mm/slab_common.c
@@ -898,6 +898,7 @@ void *kmalloc_order(size_t size, gfp_t f
 	page = alloc_kmem_pages(flags, order);
 	ret = page ? page_address(page) : NULL;
 	kmemleak_alloc(ret, size, 1, flags);
+	kasan_kmalloc_large(ret, size);
 	return ret;
 }
 EXPORT_SYMBOL(kmalloc_order);
@@ -1077,8 +1078,10 @@ static __always_inline void *__do_kreall
 	if (p)
 		ks = ksize(p);
 
-	if (ks >= new_size)
+	if (ks >= new_size) {
+		kasan_krealloc((void *)p, new_size);
 		return (void *)p;
+	}
 
 	ret = kmalloc_track_caller(new_size, flags);
 	if (ret && p)
diff -puN mm/slub.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator mm/slub.c
--- a/mm/slub.c~mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator
+++ a/mm/slub.c
@@ -1251,11 +1251,13 @@ static inline void dec_slabs_node(struct
 static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
 {
 	kmemleak_alloc(ptr, size, 1, flags);
+	kasan_kmalloc_large(ptr, size);
 }
 
 static inline void kfree_hook(const void *x)
 {
 	kmemleak_free(x);
+	kasan_kfree_large(x);
 }
 
 static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
@@ -1278,6 +1280,7 @@ static inline void slab_post_alloc_hook(
 	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
 	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
 	memcg_kmem_put_cache(s);
+	kasan_slab_alloc(s, object);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
@@ -1301,6 +1304,8 @@ static inline void slab_free_hook(struct
 #endif
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
+
+	kasan_slab_free(s, x);
 }
 
 /*
@@ -1395,8 +1400,11 @@ static void setup_object(struct kmem_cac
 				void *object)
 {
 	setup_object_debug(s, page, object);
-	if (unlikely(s->ctor))
+	if (unlikely(s->ctor)) {
+		kasan_unpoison_object_data(s, object);
 		s->ctor(object);
+		kasan_poison_object_data(s, object);
+	}
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
@@ -1429,6 +1437,8 @@ static struct page *new_slab(struct kmem
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
+	kasan_poison_slab(page);
+
 	for_each_object_idx(p, idx, s, start, page->objects) {
 		setup_object(s, page, p);
 		if (likely(idx < page->objects))
@@ -2522,6 +2532,7 @@ void *kmem_cache_alloc_trace(struct kmem
 {
 	void *ret = slab_alloc(s, gfpflags, _RET_IP_);
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags);
+	kasan_kmalloc(s, ret, size);
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_trace);
@@ -2548,6 +2559,8 @@ void *kmem_cache_alloc_node_trace(struct
 
 	trace_kmalloc_node(_RET_IP_, ret,
 			   size, s->size, gfpflags, node);
+
+	kasan_kmalloc(s, ret, size);
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
@@ -2933,6 +2946,7 @@ static void early_kmem_cache_node_alloc(
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 	init_tracking(kmem_cache_node, n);
 #endif
+	kasan_kmalloc(kmem_cache_node, n, sizeof(struct kmem_cache_node));
 	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
@@ -3305,6 +3319,8 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
+	kasan_kmalloc(s, ret, size);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc);
@@ -3348,12 +3364,14 @@ void *__kmalloc_node(size_t size, gfp_t
 
 	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
+	kasan_kmalloc(s, ret, size);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
-size_t ksize(const void *object)
+static size_t __ksize(const void *object)
 {
 	struct page *page;
 
@@ -3369,6 +3387,15 @@ size_t ksize(const void *object)
 
 	return slab_ksize(page->slab_cache);
 }
+
+size_t ksize(const void *object)
+{
+	size_t size = __ksize(object);
+	/* We assume that ksize callers could use whole allocated area,
+	   so we need unpoison this area. */
+	kasan_krealloc(object, size);
+	return size;
+}
 EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

