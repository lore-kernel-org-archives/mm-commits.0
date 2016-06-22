From: akpm@linux-foundation.org
Subject: +
 mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch
 added to -mm tree
Date: Wed, 22 Jun 2016 14:26:49 -0700
Message-ID: <576b0299.8+J+QlshVNVLYG/m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbcFVV0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: switch SLUB to stackdepot, enable memory quarantine for SLUB
has been added to the -mm tree.  Its filename is
     mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: switch SLUB to stackdepot, enable memory quarantine for SLUB

For KASAN builds:
 - switch SLUB allocator to using stackdepot instead of storing the
   allocation/deallocation stacks in the objects;
 - change the freelist hook so that parts of the freelist can be put
   into the quarantine.

Link: http://lkml.kernel.org/r/1466617421-58518-1-git-send-email-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab_def.h |   11 -----
 include/linux/slub_def.h |   15 +------
 lib/Kconfig.kasan        |    4 -
 mm/kasan/Makefile        |    3 -
 mm/kasan/kasan.c         |   61 ++++++++++++++++-------------
 mm/kasan/kasan.h         |    2 
 mm/kasan/report.c        |    8 +--
 mm/slab.c                |   11 +++++
 mm/slab.h                |    9 ++++
 mm/slub.c                |   76 ++++++++++++++++++++++++++++++-------
 10 files changed, 126 insertions(+), 74 deletions(-)

diff -puN include/linux/slab_def.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/include/linux/slab_def.h
@@ -87,15 +87,4 @@ struct kmem_cache {
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
-static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
-				void *x) {
-	void *object = x - (x - page->s_mem) % cache->size;
-	void *last_object = page->s_mem + (cache->num - 1) * cache->size;
-
-	if (unlikely(object > last_object))
-		return last_object;
-	else
-		return object;
-}
-
 #endif	/* _LINUX_SLAB_DEF_H */
diff -puN include/linux/slub_def.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/include/linux/slub_def.h
@@ -104,6 +104,10 @@ struct kmem_cache {
 	unsigned int *random_seq;
 #endif
 
+#ifdef CONFIG_KASAN
+	struct kasan_cache kasan_info;
+#endif
+
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
@@ -119,15 +123,4 @@ static inline void sysfs_slab_remove(str
 void object_err(struct kmem_cache *s, struct page *page,
 		u8 *object, char *reason);
 
-static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
-				void *x) {
-	void *object = x - (x - page_address(page)) % cache->size;
-	void *last_object = page_address(page) +
-		(page->objects - 1) * cache->size;
-	if (unlikely(object > last_object))
-		return last_object;
-	else
-		return object;
-}
-
 #endif /* _LINUX_SLUB_DEF_H */
diff -puN lib/Kconfig.kasan~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/lib/Kconfig.kasan
@@ -5,9 +5,9 @@ if HAVE_ARCH_KASAN
 
 config KASAN
 	bool "KASan: runtime memory debugger"
-	depends on SLUB_DEBUG || (SLAB && !DEBUG_SLAB)
+	depends on SLUB || (SLAB && !DEBUG_SLAB)
 	select CONSTRUCTORS
-	select STACKDEPOT if SLAB
+	select STACKDEPOT
 	help
 	  Enables kernel address sanitizer - runtime memory debugger,
 	  designed to find out-of-bounds accesses and use-after-free bugs.
diff -puN mm/kasan/Makefile~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/kasan/Makefile
--- a/mm/kasan/Makefile~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/kasan/Makefile
@@ -7,5 +7,4 @@ CFLAGS_REMOVE_kasan.o = -pg
 # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
 CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
 
-obj-y := kasan.o report.o kasan_init.o
-obj-$(CONFIG_SLAB) += quarantine.o
+obj-y := kasan.o report.o kasan_init.o quarantine.o
diff -puN mm/kasan/kasan.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/kasan/kasan.c
@@ -351,7 +351,6 @@ void kasan_free_pages(struct page *page,
 				KASAN_FREE_PAGE);
 }
 
-#ifdef CONFIG_SLAB
 /*
  * Adaptive redzone policy taken from the userspace AddressSanitizer runtime.
  * For larger allocations larger redzones are used.
@@ -373,16 +372,12 @@ void kasan_cache_create(struct kmem_cach
 			unsigned long *flags)
 {
 	int redzone_adjust;
-	/* Make sure the adjusted size is still less than
-	 * KMALLOC_MAX_CACHE_SIZE.
-	 * TODO: this check is only useful for SLAB, but not SLUB. We'll need
-	 * to skip it for SLUB when it starts using kasan_cache_create().
-	 */
-	if (*size > KMALLOC_MAX_CACHE_SIZE -
-	    sizeof(struct kasan_alloc_meta) -
-	    sizeof(struct kasan_free_meta))
-		return;
+#ifdef CONFIG_SLAB
+	int orig_size = *size;
+#endif
+
 	*flags |= SLAB_KASAN;
+
 	/* Add alloc meta. */
 	cache->kasan_info.alloc_meta_offset = *size;
 	*size += sizeof(struct kasan_alloc_meta);
@@ -392,17 +387,35 @@ void kasan_cache_create(struct kmem_cach
 	    cache->object_size < sizeof(struct kasan_free_meta)) {
 		cache->kasan_info.free_meta_offset = *size;
 		*size += sizeof(struct kasan_free_meta);
+	} else {
+		cache->kasan_info.free_meta_offset = 0;
 	}
 	redzone_adjust = optimal_redzone(cache->object_size) -
 		(*size - cache->object_size);
+
 	if (redzone_adjust > 0)
 		*size += redzone_adjust;
-	*size = min(KMALLOC_MAX_CACHE_SIZE,
+
+#ifdef CONFIG_SLAB
+	*size = min(KMALLOC_MAX_SIZE,
 		    max(*size,
 			cache->object_size +
 			optimal_redzone(cache->object_size)));
-}
+	/*
+	 * If the metadata doesn't fit, disable KASAN at all.
+	 */
+	if (*size <= cache->kasan_info.alloc_meta_offset ||
+			*size <= cache->kasan_info.free_meta_offset) {
+		*flags &= ~SLAB_KASAN;
+		*size = orig_size;
+	}
+#else
+	*size = max(*size,
+			cache->object_size +
+			optimal_redzone(cache->object_size));
+
 #endif
+}
 
 void kasan_cache_shrink(struct kmem_cache *cache)
 {
@@ -431,16 +444,13 @@ void kasan_poison_object_data(struct kme
 	kasan_poison_shadow(object,
 			round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE),
 			KASAN_KMALLOC_REDZONE);
-#ifdef CONFIG_SLAB
 	if (cache->flags & SLAB_KASAN) {
 		struct kasan_alloc_meta *alloc_info =
 			get_alloc_info(cache, object);
 		alloc_info->state = KASAN_STATE_INIT;
 	}
-#endif
 }
 
-#ifdef CONFIG_SLAB
 static inline int in_irqentry_text(unsigned long ptr)
 {
 	return (ptr >= (unsigned long)&__irqentry_text_start &&
@@ -501,7 +511,6 @@ struct kasan_free_meta *get_free_info(st
 	BUILD_BUG_ON(sizeof(struct kasan_free_meta) > 32);
 	return (void *)object + cache->kasan_info.free_meta_offset;
 }
-#endif
 
 void kasan_slab_alloc(struct kmem_cache *cache, void *object, gfp_t flags)
 {
@@ -522,16 +531,16 @@ static void kasan_poison_slab_free(struc
 
 bool kasan_slab_free(struct kmem_cache *cache, void *object)
 {
-#ifdef CONFIG_SLAB
 	/* RCU slabs could be legally used after free within the RCU period */
 	if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
 		return false;
 
 	if (likely(cache->flags & SLAB_KASAN)) {
-		struct kasan_alloc_meta *alloc_info =
-			get_alloc_info(cache, object);
-		struct kasan_free_meta *free_info =
-			get_free_info(cache, object);
+		struct kasan_alloc_meta *alloc_info;
+		struct kasan_free_meta *free_info;
+
+		alloc_info = get_alloc_info(cache, object);
+		free_info = get_free_info(cache, object);
 
 		switch (alloc_info->state) {
 		case KASAN_STATE_ALLOC:
@@ -550,10 +559,6 @@ bool kasan_slab_free(struct kmem_cache *
 		}
 	}
 	return false;
-#else
-	kasan_poison_slab_free(cache, object);
-	return false;
-#endif
 }
 
 void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size,
@@ -568,6 +573,9 @@ void kasan_kmalloc(struct kmem_cache *ca
 	if (unlikely(object == NULL))
 		return;
 
+	if (!(cache->flags & SLAB_KASAN))
+		return;
+
 	redzone_start = round_up((unsigned long)(object + size),
 				KASAN_SHADOW_SCALE_SIZE);
 	redzone_end = round_up((unsigned long)object + cache->object_size,
@@ -576,16 +584,13 @@ void kasan_kmalloc(struct kmem_cache *ca
 	kasan_unpoison_shadow(object, size);
 	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
 		KASAN_KMALLOC_REDZONE);
-#ifdef CONFIG_SLAB
 	if (cache->flags & SLAB_KASAN) {
 		struct kasan_alloc_meta *alloc_info =
 			get_alloc_info(cache, object);
-
 		alloc_info->state = KASAN_STATE_ALLOC;
 		alloc_info->alloc_size = size;
 		set_track(&alloc_info->track, flags);
 	}
-#endif
 }
 EXPORT_SYMBOL(kasan_kmalloc);
 
diff -puN mm/kasan/kasan.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/kasan/kasan.h
@@ -110,7 +110,7 @@ static inline bool kasan_report_enabled(
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 
-#ifdef CONFIG_SLAB
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
 void quarantine_reduce(void);
 void quarantine_remove_cache(struct kmem_cache *cache);
diff -puN mm/kasan/report.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/kasan/report.c
@@ -116,7 +116,6 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
-#ifdef CONFIG_SLAB
 static void print_track(struct kasan_track *track)
 {
 	pr_err("PID = %u\n", track->pid);
@@ -130,8 +129,8 @@ static void print_track(struct kasan_tra
 	}
 }
 
-static void object_err(struct kmem_cache *cache, struct page *page,
-			void *object, char *unused_reason)
+static void kasan_object_err(struct kmem_cache *cache, struct page *page,
+				void *object, char *unused_reason)
 {
 	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
 	struct kasan_free_meta *free_info;
@@ -162,7 +161,6 @@ static void object_err(struct kmem_cache
 		break;
 	}
 }
-#endif
 
 static void print_address_description(struct kasan_access_info *info)
 {
@@ -177,7 +175,7 @@ static void print_address_description(st
 			struct kmem_cache *cache = page->slab_cache;
 			object = nearest_obj(cache, page,
 						(void *)info->access_addr);
-			object_err(cache, page, object,
+			kasan_object_err(cache, page, object,
 					"kasan: bad access detected");
 			return;
 		}
diff -puN mm/slab.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/slab.c
--- a/mm/slab.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/slab.c
@@ -4469,3 +4469,14 @@ size_t ksize(const void *objp)
 	return size;
 }
 EXPORT_SYMBOL(ksize);
+
+void *nearest_obj(struct kmem_cache *cache, struct page *page, void *x)
+{
+	void *object = x - (x - page->s_mem) % cache->size;
+	void *last_object = page->s_mem + (cache->num - 1) * cache->size;
+
+	if (unlikely(object > last_object))
+		return last_object;
+	else
+		return object;
+}
diff -puN mm/slab.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/slab.h
--- a/mm/slab.h~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/slab.h
@@ -369,6 +369,8 @@ static inline size_t slab_ksize(const st
 	if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
 		return s->object_size;
 # endif
+	if (s->flags & SLAB_KASAN)
+		return s->object_size;
 	/*
 	 * If we have the need to store the freelist pointer
 	 * back there or track user information then we can
@@ -471,7 +473,14 @@ void *slab_next(struct seq_file *m, void
 void slab_stop(struct seq_file *m, void *p);
 int memcg_slab_show(struct seq_file *m, void *p);
 
+void *nearest_obj(struct kmem_cache *cache, struct page *page, void *x);
+
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr);
+#if defined(CONFIG_SLUB)
+void do_slab_free(struct kmem_cache *s,
+		struct page *page, void *head, void *tail,
+		int cnt, unsigned long addr);
+#endif
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
 int cache_random_seq_create(struct kmem_cache *cachep, unsigned int count,
diff -puN mm/slub.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub mm/slub.c
--- a/mm/slub.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub
+++ a/mm/slub.c
@@ -191,7 +191,11 @@ static inline bool kmem_cache_has_cpu_pa
 #define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
 
 /* Internal SLUB flags */
+#ifndef CONFIG_KASAN
 #define __OBJECT_POISON		0x80000000UL /* Poison object */
+#else
+#define __OBJECT_POISON		0x00000000UL /* Disable object poisoning */
+#endif
 #define __CMPXCHG_DOUBLE	0x40000000UL /* Use cmpxchg_double */
 
 #ifdef CONFIG_SMP
@@ -454,8 +458,6 @@ static inline void *restore_red_left(str
  */
 #if defined(CONFIG_SLUB_DEBUG_ON)
 static int slub_debug = DEBUG_DEFAULT_FLAGS;
-#elif defined(CONFIG_KASAN)
-static int slub_debug = SLAB_STORE_USER;
 #else
 static int slub_debug;
 #endif
@@ -1322,7 +1324,7 @@ static inline void kfree_hook(const void
 	kasan_kfree_large(x);
 }
 
-static inline void slab_free_hook(struct kmem_cache *s, void *x)
+static inline bool slab_free_hook(struct kmem_cache *s, void *x)
 {
 	kmemleak_free_recursive(x, s->flags);
 
@@ -1344,11 +1346,11 @@ static inline void slab_free_hook(struct
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
 
-	kasan_slab_free(s, x);
+	return kasan_slab_free(s, x);
 }
 
 static inline void slab_free_freelist_hook(struct kmem_cache *s,
-					   void *head, void *tail)
+					   void **head, void **tail, int *cnt)
 {
 /*
  * Compiler cannot detect this function can be removed if slab_free_hook()
@@ -1360,13 +1362,27 @@ static inline void slab_free_freelist_ho
 	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
 	defined(CONFIG_KASAN)
 
-	void *object = head;
-	void *tail_obj = tail ? : head;
+	void *object = *head, *prev = NULL, *next = NULL;
+	void *tail_obj = *tail ? : *head;
+	bool skip = false;
 
 	do {
-		slab_free_hook(s, object);
-	} while ((object != tail_obj) &&
-		 (object = get_freepointer(s, object)));
+		skip = slab_free_hook(s, object);
+		next = (object != tail_obj) ?
+			get_freepointer(s, object) : NULL;
+		if (skip) {
+			if (!prev)
+				*head = next;
+			else
+				set_freepointer(s, prev, next);
+			if (object == tail_obj)
+				*tail = prev;
+			(*cnt)--;
+		} else {
+			prev = object;
+		}
+		object = next;
+	} while (next);
 #endif
 }
 
@@ -2882,12 +2898,22 @@ static __always_inline void slab_free(st
 				      void *head, void *tail, int cnt,
 				      unsigned long addr)
 {
+	void *free_head = head, *free_tail = tail;
+
+	slab_free_freelist_hook(s, &free_head, &free_tail, &cnt);
+	/* slab_free_freelist_hook() could have emptied the freelist. */
+	if (cnt == 0)
+		return;
+	do_slab_free(s, page, free_head, free_tail, cnt, addr);
+}
+
+__always_inline void do_slab_free(struct kmem_cache *s,
+				struct page *page, void *head, void *tail,
+				int cnt, unsigned long addr)
+{
 	void *tail_obj = tail ? : head;
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
-
-	slab_free_freelist_hook(s, head, tail);
-
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
@@ -2921,6 +2947,12 @@ redo:
 
 }
 
+/* Helper function to be used from qlink_free() in mm/kasan/quarantine.c */
+void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
+{
+	do_slab_free(cache, virt_to_head_page(x), x, NULL, 1, addr);
+}
+
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
 	s = cache_from_obj(s, x);
@@ -3363,7 +3395,7 @@ static void set_min_partial(struct kmem_
 static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	unsigned long flags = s->flags;
-	unsigned long size = s->object_size;
+	size_t size = s->object_size;
 	int order;
 
 	/*
@@ -3422,7 +3454,10 @@ static int calculate_sizes(struct kmem_c
 		 * the object.
 		 */
 		size += 2 * sizeof(struct track);
+#endif
 
+	kasan_cache_create(s, &size, &s->flags);
+#ifdef CONFIG_SLUB_DEBUG
 	if (flags & SLAB_RED_ZONE) {
 		/*
 		 * Add some empty padding so that we can catch
@@ -5706,3 +5741,16 @@ ssize_t slabinfo_write(struct file *file
 	return -EIO;
 }
 #endif /* CONFIG_SLABINFO */
+
+void *nearest_obj(struct kmem_cache *cache, struct page *page,
+				void *x) {
+	void *object = x - (x - page_address(page)) % cache->size;
+	void *last_object = page_address(page) +
+		(page->objects - 1) * cache->size;
+	void *result = (unlikely(object > last_object)) ? last_object : object;
+
+	if (cache->flags & SLAB_RED_ZONE)
+		return (void *)((char *)result + cache->red_left_pad);
+	else
+		return result;
+}
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

