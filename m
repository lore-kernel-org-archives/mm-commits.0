From: akpm@linux-foundation.org
Subject: [merged] mm-kasan-slab-support.patch removed from -mm tree
Date: Sat, 26 Mar 2016 20:31:18 -0700
Message-ID: <56f75406.PLWRnnwrRmRVCZMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0DbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: SLAB support
has been removed from the -mm tree.  Its filename was
     mm-kasan-slab-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: SLAB support

Add KASAN hooks to SLAB allocator.

This patch is based on the "mm: kasan: unified support for SLUB and
SLAB allocators" patch originally prepared by Dmitry Chernenkov.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt  |    5 -
 include/linux/kasan.h    |   12 ++++
 include/linux/slab.h     |    6 ++
 include/linux/slab_def.h |   14 +++++
 include/linux/slub_def.h |   11 +++
 lib/Kconfig.kasan        |    4 +
 mm/Makefile              |    1 
 mm/kasan/kasan.c         |  102 +++++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h         |   34 ++++++++++++
 mm/kasan/report.c        |   54 +++++++++++++++----
 mm/slab.c                |   43 +++++++++++++--
 mm/slab_common.c         |    2 
 12 files changed, 266 insertions(+), 22 deletions(-)

diff -puN Documentation/kasan.txt~mm-kasan-slab-support Documentation/kasan.txt
--- a/Documentation/kasan.txt~mm-kasan-slab-support
+++ a/Documentation/kasan.txt
@@ -12,8 +12,7 @@ KASAN uses compile-time instrumentation
 therefore you will need a GCC version 4.9.2 or later. GCC 5.0 or later is
 required for detection of out-of-bounds accesses to stack or global variables.
 
-Currently KASAN is supported only for x86_64 architecture and requires the
-kernel to be built with the SLUB allocator.
+Currently KASAN is supported only for x86_64 architecture.
 
 1. Usage
 ========
@@ -27,7 +26,7 @@ inline are compiler instrumentation type
 the latter is 1.1 - 2 times faster. Inline instrumentation requires a GCC
 version 5.0 or later.
 
-Currently KASAN works only with the SLUB memory allocator.
+KASAN works with both SLUB and SLAB memory allocators.
 For better bug detection and nicer reporting, enable CONFIG_STACKTRACE.
 
 To disable instrumentation for specific files or directories, add a line
diff -puN include/linux/kasan.h~mm-kasan-slab-support include/linux/kasan.h
--- a/include/linux/kasan.h~mm-kasan-slab-support
+++ a/include/linux/kasan.h
@@ -48,6 +48,9 @@ void kasan_unpoison_task_stack(struct ta
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
 
+void kasan_cache_create(struct kmem_cache *cache, size_t *size,
+			unsigned long *flags);
+
 void kasan_poison_slab(struct page *page);
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
 void kasan_poison_object_data(struct kmem_cache *cache, void *object);
@@ -61,6 +64,11 @@ void kasan_krealloc(const void *object,
 void kasan_slab_alloc(struct kmem_cache *s, void *object);
 void kasan_slab_free(struct kmem_cache *s, void *object);
 
+struct kasan_cache {
+	int alloc_meta_offset;
+	int free_meta_offset;
+};
+
 int kasan_module_alloc(void *addr, size_t size);
 void kasan_free_shadow(const struct vm_struct *vm);
 
@@ -76,6 +84,10 @@ static inline void kasan_disable_current
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 
+static inline void kasan_cache_create(struct kmem_cache *cache,
+				      size_t *size,
+				      unsigned long *flags) {}
+
 static inline void kasan_poison_slab(struct page *page) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
 					void *object) {}
diff -puN include/linux/slab.h~mm-kasan-slab-support include/linux/slab.h
--- a/include/linux/slab.h~mm-kasan-slab-support
+++ a/include/linux/slab.h
@@ -92,6 +92,12 @@
 # define SLAB_ACCOUNT		0x00000000UL
 #endif
 
+#ifdef CONFIG_KASAN
+#define SLAB_KASAN		0x08000000UL
+#else
+#define SLAB_KASAN		0x00000000UL
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff -puN include/linux/slab_def.h~mm-kasan-slab-support include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-kasan-slab-support
+++ a/include/linux/slab_def.h
@@ -76,8 +76,22 @@ struct kmem_cache {
 #ifdef CONFIG_MEMCG
 	struct memcg_cache_params memcg_params;
 #endif
+#ifdef CONFIG_KASAN
+	struct kasan_cache kasan_info;
+#endif
 
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
+static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
+				void *x) {
+	void *object = x - (x - page->s_mem) % cache->size;
+	void *last_object = page->s_mem + (cache->num - 1) * cache->size;
+
+	if (unlikely(object > last_object))
+		return last_object;
+	else
+		return object;
+}
+
 #endif	/* _LINUX_SLAB_DEF_H */
diff -puN include/linux/slub_def.h~mm-kasan-slab-support include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-kasan-slab-support
+++ a/include/linux/slub_def.h
@@ -130,4 +130,15 @@ static inline void *virt_to_obj(struct k
 void object_err(struct kmem_cache *s, struct page *page,
 		u8 *object, char *reason);
 
+static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
+				void *x) {
+	void *object = x - (x - page_address(page)) % cache->size;
+	void *last_object = page_address(page) +
+		(page->objects - 1) * cache->size;
+	if (unlikely(object > last_object))
+		return last_object;
+	else
+		return object;
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
diff -puN lib/Kconfig.kasan~mm-kasan-slab-support lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~mm-kasan-slab-support
+++ a/lib/Kconfig.kasan
@@ -5,7 +5,7 @@ if HAVE_ARCH_KASAN
 
 config KASAN
 	bool "KASan: runtime memory debugger"
-	depends on SLUB_DEBUG
+	depends on SLUB_DEBUG || (SLAB && !DEBUG_SLAB)
 	select CONSTRUCTORS
 	help
 	  Enables kernel address sanitizer - runtime memory debugger,
@@ -16,6 +16,8 @@ config KASAN
 	  This feature consumes about 1/8 of available memory and brings about
 	  ~x3 performance slowdown.
 	  For better error detection enable CONFIG_STACKTRACE.
+	  Currently CONFIG_KASAN doesn't work with CONFIG_DEBUG_SLAB
+	  (the resulting kernel does not boot).
 
 choice
 	prompt "Instrumentation type"
diff -puN mm/Makefile~mm-kasan-slab-support mm/Makefile
--- a/mm/Makefile~mm-kasan-slab-support
+++ a/mm/Makefile
@@ -3,6 +3,7 @@
 #
 
 KASAN_SANITIZE_slab_common.o := n
+KASAN_SANITIZE_slab.o := n
 KASAN_SANITIZE_slub.o := n
 
 # These files are disabled because they produce non-interesting and/or
diff -puN mm/kasan/kasan.c~mm-kasan-slab-support mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-slab-support
+++ a/mm/kasan/kasan.c
@@ -334,6 +334,59 @@ void kasan_free_pages(struct page *page,
 				KASAN_FREE_PAGE);
 }
 
+#ifdef CONFIG_SLAB
+/*
+ * Adaptive redzone policy taken from the userspace AddressSanitizer runtime.
+ * For larger allocations larger redzones are used.
+ */
+static size_t optimal_redzone(size_t object_size)
+{
+	int rz =
+		object_size <= 64        - 16   ? 16 :
+		object_size <= 128       - 32   ? 32 :
+		object_size <= 512       - 64   ? 64 :
+		object_size <= 4096      - 128  ? 128 :
+		object_size <= (1 << 14) - 256  ? 256 :
+		object_size <= (1 << 15) - 512  ? 512 :
+		object_size <= (1 << 16) - 1024 ? 1024 : 2048;
+	return rz;
+}
+
+void kasan_cache_create(struct kmem_cache *cache, size_t *size,
+			unsigned long *flags)
+{
+	int redzone_adjust;
+	/* Make sure the adjusted size is still less than
+	 * KMALLOC_MAX_CACHE_SIZE.
+	 * TODO: this check is only useful for SLAB, but not SLUB. We'll need
+	 * to skip it for SLUB when it starts using kasan_cache_create().
+	 */
+	if (*size > KMALLOC_MAX_CACHE_SIZE -
+	    sizeof(struct kasan_alloc_meta) -
+	    sizeof(struct kasan_free_meta))
+		return;
+	*flags |= SLAB_KASAN;
+	/* Add alloc meta. */
+	cache->kasan_info.alloc_meta_offset = *size;
+	*size += sizeof(struct kasan_alloc_meta);
+
+	/* Add free meta. */
+	if (cache->flags & SLAB_DESTROY_BY_RCU || cache->ctor ||
+	    cache->object_size < sizeof(struct kasan_free_meta)) {
+		cache->kasan_info.free_meta_offset = *size;
+		*size += sizeof(struct kasan_free_meta);
+	}
+	redzone_adjust = optimal_redzone(cache->object_size) -
+		(*size - cache->object_size);
+	if (redzone_adjust > 0)
+		*size += redzone_adjust;
+	*size = min(KMALLOC_MAX_CACHE_SIZE,
+		    max(*size,
+			cache->object_size +
+			optimal_redzone(cache->object_size)));
+}
+#endif
+
 void kasan_poison_slab(struct page *page)
 {
 	kasan_poison_shadow(page_address(page),
@@ -351,8 +404,36 @@ void kasan_poison_object_data(struct kme
 	kasan_poison_shadow(object,
 			round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE),
 			KASAN_KMALLOC_REDZONE);
+#ifdef CONFIG_SLAB
+	if (cache->flags & SLAB_KASAN) {
+		struct kasan_alloc_meta *alloc_info =
+			get_alloc_info(cache, object);
+		alloc_info->state = KASAN_STATE_INIT;
+	}
+#endif
 }
 
+static inline void set_track(struct kasan_track *track)
+{
+	track->cpu = raw_smp_processor_id();
+	track->pid = current->pid;
+	track->when = jiffies;
+}
+
+#ifdef CONFIG_SLAB
+struct kasan_alloc_meta *get_alloc_info(struct kmem_cache *cache,
+					const void *object)
+{
+	return (void *)object + cache->kasan_info.alloc_meta_offset;
+}
+
+struct kasan_free_meta *get_free_info(struct kmem_cache *cache,
+				      const void *object)
+{
+	return (void *)object + cache->kasan_info.free_meta_offset;
+}
+#endif
+
 void kasan_slab_alloc(struct kmem_cache *cache, void *object)
 {
 	kasan_kmalloc(cache, object, cache->object_size);
@@ -367,6 +448,17 @@ void kasan_slab_free(struct kmem_cache *
 	if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
 		return;
 
+#ifdef CONFIG_SLAB
+	if (cache->flags & SLAB_KASAN) {
+		struct kasan_free_meta *free_info =
+			get_free_info(cache, object);
+		struct kasan_alloc_meta *alloc_info =
+			get_alloc_info(cache, object);
+		alloc_info->state = KASAN_STATE_FREE;
+		set_track(&free_info->track);
+	}
+#endif
+
 	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
 }
 
@@ -386,6 +478,16 @@ void kasan_kmalloc(struct kmem_cache *ca
 	kasan_unpoison_shadow(object, size);
 	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
 		KASAN_KMALLOC_REDZONE);
+#ifdef CONFIG_SLAB
+	if (cache->flags & SLAB_KASAN) {
+		struct kasan_alloc_meta *alloc_info =
+			get_alloc_info(cache, object);
+
+		alloc_info->state = KASAN_STATE_ALLOC;
+		alloc_info->alloc_size = size;
+		set_track(&alloc_info->track);
+	}
+#endif
 }
 EXPORT_SYMBOL(kasan_kmalloc);
 
diff -puN mm/kasan/kasan.h~mm-kasan-slab-support mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-slab-support
+++ a/mm/kasan/kasan.h
@@ -54,6 +54,40 @@ struct kasan_global {
 #endif
 };
 
+/**
+ * Structures to keep alloc and free tracks *
+ */
+
+enum kasan_state {
+	KASAN_STATE_INIT,
+	KASAN_STATE_ALLOC,
+	KASAN_STATE_FREE
+};
+
+struct kasan_track {
+	u64 cpu : 6;			/* for NR_CPUS = 64 */
+	u64 pid : 16;			/* 65536 processes */
+	u64 when : 42;			/* ~140 years */
+};
+
+struct kasan_alloc_meta {
+	u32 state : 2;	/* enum kasan_state */
+	u32 alloc_size : 30;
+	struct kasan_track track;
+};
+
+struct kasan_free_meta {
+	/* Allocator freelist pointer, unused by KASAN. */
+	void **freelist;
+	struct kasan_track track;
+};
+
+struct kasan_alloc_meta *get_alloc_info(struct kmem_cache *cache,
+					const void *object);
+struct kasan_free_meta *get_free_info(struct kmem_cache *cache,
+					const void *object);
+
+
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
 {
 	return (void *)(((unsigned long)shadow_addr - KASAN_SHADOW_OFFSET)
diff -puN mm/kasan/report.c~mm-kasan-slab-support mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-slab-support
+++ a/mm/kasan/report.c
@@ -115,6 +115,46 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
+#ifdef CONFIG_SLAB
+static void print_track(struct kasan_track *track)
+{
+	pr_err("PID = %u, CPU = %u, timestamp = %lu\n", track->pid,
+	       track->cpu, (unsigned long)track->when);
+}
+
+static void object_err(struct kmem_cache *cache, struct page *page,
+			void *object, char *unused_reason)
+{
+	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
+	struct kasan_free_meta *free_info;
+
+	dump_stack();
+	pr_err("Object at %p, in cache %s\n", object, cache->name);
+	if (!(cache->flags & SLAB_KASAN))
+		return;
+	switch (alloc_info->state) {
+	case KASAN_STATE_INIT:
+		pr_err("Object not allocated yet\n");
+		break;
+	case KASAN_STATE_ALLOC:
+		pr_err("Object allocated with size %u bytes.\n",
+		       alloc_info->alloc_size);
+		pr_err("Allocation:\n");
+		print_track(&alloc_info->track);
+		break;
+	case KASAN_STATE_FREE:
+		pr_err("Object freed, allocated with size %u bytes\n",
+		       alloc_info->alloc_size);
+		free_info = get_free_info(cache, object);
+		pr_err("Allocation:\n");
+		print_track(&alloc_info->track);
+		pr_err("Deallocation:\n");
+		print_track(&free_info->track);
+		break;
+	}
+}
+#endif
+
 static void print_address_description(struct kasan_access_info *info)
 {
 	const void *addr = info->access_addr;
@@ -126,17 +166,10 @@ static void print_address_description(st
 		if (PageSlab(page)) {
 			void *object;
 			struct kmem_cache *cache = page->slab_cache;
-			void *last_object;
-
-			object = virt_to_obj(cache, page_address(page), addr);
-			last_object = page_address(page) +
-				page->objects * cache->size;
-
-			if (unlikely(object > last_object))
-				object = last_object; /* we hit into padding */
-
+			object = nearest_obj(cache, page,
+						(void *)info->access_addr);
 			object_err(cache, page, object,
-				"kasan: bad access detected");
+					"kasan: bad access detected");
 			return;
 		}
 		dump_page(page, "kasan: bad access detected");
@@ -146,7 +179,6 @@ static void print_address_description(st
 		if (!init_task_stack_addr(addr))
 			pr_err("Address belongs to variable %pS\n", addr);
 	}
-
 	dump_stack();
 }
 
diff -puN mm/slab.c~mm-kasan-slab-support mm/slab.c
--- a/mm/slab.c~mm-kasan-slab-support
+++ a/mm/slab.c
@@ -2086,6 +2086,8 @@ __kmem_cache_create (struct kmem_cache *
 	}
 #endif
 
+	kasan_cache_create(cachep, &size, &flags);
+
 	size = ALIGN(size, cachep->align);
 	/*
 	 * We should restrict the number of objects in a slab to implement
@@ -2387,8 +2389,13 @@ static void cache_init_objs_debug(struct
 		 * cache which they are a constructor for.  Otherwise, deadlock.
 		 * They must also be threaded.
 		 */
-		if (cachep->ctor && !(cachep->flags & SLAB_POISON))
+		if (cachep->ctor && !(cachep->flags & SLAB_POISON)) {
+			kasan_unpoison_object_data(cachep,
+						   objp + obj_offset(cachep));
 			cachep->ctor(objp + obj_offset(cachep));
+			kasan_poison_object_data(
+				cachep, objp + obj_offset(cachep));
+		}
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
@@ -2409,6 +2416,7 @@ static void cache_init_objs(struct kmem_
 			    struct page *page)
 {
 	int i;
+	void *objp;
 
 	cache_init_objs_debug(cachep, page);
 
@@ -2419,8 +2427,12 @@ static void cache_init_objs(struct kmem_
 
 	for (i = 0; i < cachep->num; i++) {
 		/* constructor could break poison info */
-		if (DEBUG == 0 && cachep->ctor)
-			cachep->ctor(index_to_obj(cachep, page, i));
+		if (DEBUG == 0 && cachep->ctor) {
+			objp = index_to_obj(cachep, page, i);
+			kasan_unpoison_object_data(cachep, objp);
+			cachep->ctor(objp);
+			kasan_poison_object_data(cachep, objp);
+		}
 
 		set_free_obj(page, i, i);
 	}
@@ -2550,6 +2562,7 @@ static int cache_grow(struct kmem_cache
 
 	slab_map_pages(cachep, page, freelist);
 
+	kasan_poison_slab(page);
 	cache_init_objs(cachep, page);
 
 	if (gfpflags_allow_blocking(local_flags))
@@ -3316,6 +3329,8 @@ static inline void __cache_free(struct k
 {
 	struct array_cache *ac = cpu_cache_get(cachep);
 
+	kasan_slab_free(cachep, objp);
+
 	check_irq_off();
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
@@ -3363,6 +3378,7 @@ void *kmem_cache_alloc(struct kmem_cache
 {
 	void *ret = slab_alloc(cachep, flags, _RET_IP_);
 
+	kasan_slab_alloc(cachep, ret);
 	trace_kmem_cache_alloc(_RET_IP_, ret,
 			       cachep->object_size, cachep->size, flags);
 
@@ -3428,6 +3444,7 @@ kmem_cache_alloc_trace(struct kmem_cache
 
 	ret = slab_alloc(cachep, flags, _RET_IP_);
 
+	kasan_kmalloc(cachep, ret, size);
 	trace_kmalloc(_RET_IP_, ret,
 		      size, cachep->size, flags);
 	return ret;
@@ -3451,6 +3468,7 @@ void *kmem_cache_alloc_node(struct kmem_
 {
 	void *ret = slab_alloc_node(cachep, flags, nodeid, _RET_IP_);
 
+	kasan_slab_alloc(cachep, ret);
 	trace_kmem_cache_alloc_node(_RET_IP_, ret,
 				    cachep->object_size, cachep->size,
 				    flags, nodeid);
@@ -3468,7 +3486,7 @@ void *kmem_cache_alloc_node_trace(struct
 	void *ret;
 
 	ret = slab_alloc_node(cachep, flags, nodeid, _RET_IP_);
-
+	kasan_kmalloc(cachep, ret, size);
 	trace_kmalloc_node(_RET_IP_, ret,
 			   size, cachep->size,
 			   flags, nodeid);
@@ -3481,11 +3499,15 @@ static __always_inline void *
 __do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller)
 {
 	struct kmem_cache *cachep;
+	void *ret;
 
 	cachep = kmalloc_slab(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	return kmem_cache_alloc_node_trace(cachep, flags, node, size);
+	ret = kmem_cache_alloc_node_trace(cachep, flags, node, size);
+	kasan_kmalloc(cachep, ret, size);
+
+	return ret;
 }
 
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
@@ -3519,6 +3541,7 @@ static __always_inline void *__do_kmallo
 		return cachep;
 	ret = slab_alloc(cachep, flags, caller);
 
+	kasan_kmalloc(cachep, ret, size);
 	trace_kmalloc(caller, ret,
 		      size, cachep->size, flags);
 
@@ -4290,10 +4313,18 @@ module_init(slab_proc_init);
  */
 size_t ksize(const void *objp)
 {
+	size_t size;
+
 	BUG_ON(!objp);
 	if (unlikely(objp == ZERO_SIZE_PTR))
 		return 0;
 
-	return virt_to_cache(objp)->object_size;
+	size = virt_to_cache(objp)->object_size;
+	/* We assume that ksize callers could use the whole allocated area,
+	 * so we need to unpoison this area.
+	 */
+	kasan_krealloc(objp, size);
+
+	return size;
 }
 EXPORT_SYMBOL(ksize);
diff -puN mm/slab_common.c~mm-kasan-slab-support mm/slab_common.c
--- a/mm/slab_common.c~mm-kasan-slab-support
+++ a/mm/slab_common.c
@@ -35,7 +35,7 @@ struct kmem_cache *kmem_cache;
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB)
+		SLAB_FAILSLAB | SLAB_KASAN)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_NOTRACK | SLAB_ACCOUNT)
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch

