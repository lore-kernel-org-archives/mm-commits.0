From: akpm@linux-foundation.org
Subject: + mm-kasan-initial-memory-quarantine-implementation.patch added
 to -mm tree
Date: Wed, 09 Mar 2016 12:23:39 -0800
Message-ID: <56e0864b.AFFSyfhNhijMz9Ua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160AbcCIUXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 15:23:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: initial memory quarantine implementation
has been added to the -mm tree.  Its filename is
     mm-kasan-initial-memory-quarantine-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-initial-memory-quarantine-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-initial-memory-quarantine-implementation.patch

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
Subject: mm: kasan: initial memory quarantine implementation

Quarantine isolates freed objects in a separate queue.  The objects are
returned to the allocator later, which helps to detect use-after-free
errors.

Freed objects are first added to per-cpu quarantine queues.  When a cache
is destroyed or memory shrinking is requested, the objects are moved into
the global quarantine queue.  Whenever a kmalloc call allows memory
reclaiming, the oldest objects are popped out of the global queue until
the total size of objects in quarantine is less than 3/4 of the maximum
quarantine size (which is a fraction of installed physical memory).

Right now quarantine support is only enabled in SLAB allocator. 
Unification of KASAN features in SLAB and SLUB will be done later.

This patch is based on the "mm: kasan: quarantine" patch originally
prepared by Dmitry Chernenkov.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   30 ++-
 lib/test_kasan.c      |   29 +++
 mm/kasan/Makefile     |    4 
 mm/kasan/kasan.c      |   71 +++++++--
 mm/kasan/kasan.h      |   11 +
 mm/kasan/quarantine.c |  306 ++++++++++++++++++++++++++++++++++++++++
 mm/kasan/report.c     |    1 
 mm/mempool.c          |    7 
 mm/page_alloc.c       |    2 
 mm/slab.c             |   15 +
 mm/slab.h             |    2 
 mm/slab_common.c      |    2 
 mm/slub.c             |    4 
 13 files changed, 455 insertions(+), 29 deletions(-)

diff -puN include/linux/kasan.h~mm-kasan-initial-memory-quarantine-implementation include/linux/kasan.h
--- a/include/linux/kasan.h~mm-kasan-initial-memory-quarantine-implementation
+++ a/include/linux/kasan.h
@@ -46,24 +46,29 @@ void kasan_unpoison_shadow(const void *a
 void kasan_unpoison_task_stack(struct task_struct *task);
 
 void kasan_alloc_pages(struct page *page, unsigned int order);
-void kasan_free_pages(struct page *page, unsigned int order);
+void kasan_poison_free_pages(struct page *page, unsigned int order);
 
 void kasan_cache_create(struct kmem_cache *cache, size_t *size,
 			unsigned long *flags);
+void kasan_cache_shrink(struct kmem_cache *cache);
+void kasan_cache_destroy(struct kmem_cache *cache);
 
 void kasan_poison_slab(struct page *page);
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
 void kasan_poison_object_data(struct kmem_cache *cache, void *object);
 
 void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
-void kasan_kfree_large(const void *ptr);
-void kasan_kfree(void *ptr);
+void kasan_poison_kfree_large(const void *ptr);
+void kasan_poison_kfree(void *ptr);
 void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size,
 		  gfp_t flags);
 void kasan_krealloc(const void *object, size_t new_size, gfp_t flags);
 
 void kasan_slab_alloc(struct kmem_cache *s, void *object, gfp_t flags);
-void kasan_slab_free(struct kmem_cache *s, void *object);
+/* kasan_slab_free() returns true if the object has been put into quarantine.
+ */
+bool kasan_slab_free(struct kmem_cache *s, void *object);
+void kasan_poison_slab_free(struct kmem_cache *s, void *object);
 
 struct kasan_cache {
 	int alloc_meta_offset;
@@ -83,11 +88,14 @@ static inline void kasan_enable_current(
 static inline void kasan_disable_current(void) {}
 
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
-static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+static inline void kasan_poison_free_pages(struct page *page,
+						unsigned int order) {}
 
 static inline void kasan_cache_create(struct kmem_cache *cache,
 				      size_t *size,
 				      unsigned long *flags) {}
+static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
+static inline void kasan_cache_destroy(struct kmem_cache *cache) {}
 
 static inline void kasan_poison_slab(struct page *page) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
@@ -96,8 +104,8 @@ static inline void kasan_poison_object_d
 					void *object) {}
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
-static inline void kasan_kfree_large(const void *ptr) {}
-static inline void kasan_kfree(void *ptr) {}
+static inline void kasan_poison_kfree_large(const void *ptr) {}
+static inline void kasan_poison_kfree(void *ptr) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size, gfp_t flags) {}
 static inline void kasan_krealloc(const void *object, size_t new_size,
@@ -105,7 +113,13 @@ static inline void kasan_krealloc(const
 
 static inline void kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags) {}
-static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
+/* kasan_slab_free() returns true if the object has been put into quarantine.
+ */
+static inline bool kasan_slab_free(struct kmem_cache *s, void *object)
+{
+	return false;
+}
+static inline void kasan_poison_slab_free(struct kmem_cache *s, void *object) {}
 
 static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
 static inline void kasan_free_shadow(const struct vm_struct *vm) {}
diff -puN lib/test_kasan.c~mm-kasan-initial-memory-quarantine-implementation lib/test_kasan.c
--- a/lib/test_kasan.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/lib/test_kasan.c
@@ -344,6 +344,32 @@ static noinline void __init kasan_stack_
 	*(volatile char *)p;
 }
 
+#ifdef CONFIG_SLAB
+static noinline void __init kasan_quarantine_cache(void)
+{
+	struct kmem_cache *cache = kmem_cache_create(
+			"test", 137, 8, GFP_KERNEL, NULL);
+	int i;
+
+	for (i = 0; i <  100; i++) {
+		void *p = kmem_cache_alloc(cache, GFP_KERNEL);
+
+		kmem_cache_free(cache, p);
+		p = kmalloc(sizeof(u64), GFP_KERNEL);
+		kfree(p);
+	}
+	kmem_cache_shrink(cache);
+	for (i = 0; i <  100; i++) {
+		u64 *p = kmem_cache_alloc(cache, GFP_KERNEL);
+
+		kmem_cache_free(cache, p);
+		p = kmalloc(sizeof(u64), GFP_KERNEL);
+		kfree(p);
+	}
+	kmem_cache_destroy(cache);
+}
+#endif
+
 static int __init kmalloc_tests_init(void)
 {
 	kmalloc_oob_right();
@@ -367,6 +393,9 @@ static int __init kmalloc_tests_init(voi
 	kmem_cache_oob();
 	kasan_stack_oob();
 	kasan_global_oob();
+#ifdef CONFIG_SLAB
+	kasan_quarantine_cache();
+#endif
 	return -EAGAIN;
 }
 
diff -puN mm/kasan/Makefile~mm-kasan-initial-memory-quarantine-implementation mm/kasan/Makefile
--- a/mm/kasan/Makefile~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/kasan/Makefile
@@ -7,3 +7,7 @@ CFLAGS_REMOVE_kasan.o = -pg
 CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
 
 obj-y := kasan.o report.o kasan_init.o
+
+ifdef CONFIG_SLAB
+	obj-y	+= quarantine.o
+endif
diff -puN mm/kasan/kasan.c~mm-kasan-initial-memory-quarantine-implementation mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/kasan/kasan.c
@@ -327,7 +327,7 @@ void kasan_alloc_pages(struct page *page
 		kasan_unpoison_shadow(page_address(page), PAGE_SIZE << order);
 }
 
-void kasan_free_pages(struct page *page, unsigned int order)
+void kasan_poison_free_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
 		kasan_poison_shadow(page_address(page),
@@ -388,6 +388,20 @@ void kasan_cache_create(struct kmem_cach
 }
 #endif
 
+void kasan_cache_shrink(struct kmem_cache *cache)
+{
+#ifdef CONFIG_SLAB
+	quarantine_remove_cache(cache);
+#endif
+}
+
+void kasan_cache_destroy(struct kmem_cache *cache)
+{
+#ifdef CONFIG_SLAB
+	quarantine_remove_cache(cache);
+#endif
+}
+
 void kasan_poison_slab(struct page *page)
 {
 	kasan_poison_shadow(page_address(page),
@@ -484,7 +498,7 @@ void kasan_slab_alloc(struct kmem_cache
 	kasan_kmalloc(cache, object, cache->object_size, flags);
 }
 
-void kasan_slab_free(struct kmem_cache *cache, void *object)
+void kasan_poison_slab_free(struct kmem_cache *cache, void *object)
 {
 	unsigned long size = cache->object_size;
 	unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
@@ -493,18 +507,43 @@ void kasan_slab_free(struct kmem_cache *
 	if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
 		return;
 
+	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
+}
+
+bool kasan_slab_free(struct kmem_cache *cache, void *object)
+{
 #ifdef CONFIG_SLAB
-	if (cache->flags & SLAB_KASAN) {
-		struct kasan_free_meta *free_info =
-			get_free_info(cache, object);
+	/* RCU slabs could be legally used after free within the RCU period */
+	if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
+		return false;
+
+	if (likely(cache->flags & SLAB_KASAN)) {
 		struct kasan_alloc_meta *alloc_info =
 			get_alloc_info(cache, object);
-		alloc_info->state = KASAN_STATE_FREE;
-		set_track(&free_info->track);
+		struct kasan_free_meta *free_info =
+			get_free_info(cache, object);
+
+		switch (alloc_info->state) {
+		case KASAN_STATE_ALLOC:
+			alloc_info->state = KASAN_STATE_QUARANTINE;
+			quarantine_put(free_info, cache);
+			set_track(&free_info->track, GFP_NOWAIT);
+			kasan_poison_slab_free(cache, object);
+			return true;
+		case KASAN_STATE_QUARANTINE:
+		case KASAN_STATE_FREE:
+			pr_err("Double free");
+			dump_stack();
+			break;
+		default:
+			break;
+		}
 	}
+	return false;
+#else
+	kasan_poison_slab_free(cache, object);
+	return false;
 #endif
-
-	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
 }
 
 void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size,
@@ -513,6 +552,11 @@ void kasan_kmalloc(struct kmem_cache *ca
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
+#ifdef CONFIG_SLAB
+	if (flags & __GFP_RECLAIM)
+		quarantine_reduce();
+#endif
+
 	if (unlikely(object == NULL))
 		return;
 
@@ -543,6 +587,11 @@ void kasan_kmalloc_large(const void *ptr
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
+#ifdef CONFIG_SLAB
+	if (flags & __GFP_RECLAIM)
+		quarantine_reduce();
+#endif
+
 	if (unlikely(ptr == NULL))
 		return;
 
@@ -571,7 +620,7 @@ void kasan_krealloc(const void *object,
 		kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
-void kasan_kfree(void *ptr)
+void kasan_poison_kfree(void *ptr)
 {
 	struct page *page;
 
@@ -584,7 +633,7 @@ void kasan_kfree(void *ptr)
 		kasan_slab_free(page->slab_cache, ptr);
 }
 
-void kasan_kfree_large(const void *ptr)
+void kasan_poison_kfree_large(const void *ptr)
 {
 	struct page *page = virt_to_page(ptr);
 
diff -puN mm/kasan/kasan.h~mm-kasan-initial-memory-quarantine-implementation mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/kasan/kasan.h
@@ -62,6 +62,7 @@ struct kasan_global {
 enum kasan_state {
 	KASAN_STATE_INIT,
 	KASAN_STATE_ALLOC,
+	KASAN_STATE_QUARANTINE,
 	KASAN_STATE_FREE
 };
 
@@ -81,8 +82,10 @@ struct kasan_alloc_meta {
 };
 
 struct kasan_free_meta {
-	/* Allocator freelist pointer, unused by KASAN. */
-	void **freelist;
+	/* This field is used while the object is in the quarantine.
+	 * Otherwise it might be used for the allocator freelist.
+	 */
+	void **quarantine_link;
 	struct kasan_track track;
 };
 
@@ -106,4 +109,8 @@ static inline bool kasan_report_enabled(
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 
+void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
+void quarantine_reduce(void);
+void quarantine_remove_cache(struct kmem_cache *cache);
+
 #endif
diff -puN /dev/null mm/kasan/quarantine.c
--- /dev/null
+++ a/mm/kasan/quarantine.c
@@ -0,0 +1,306 @@
+/*
+ * KASAN quarantine.
+ *
+ * Author: Alexander Potapenko <glider@google.com>
+ * Copyright (C) 2016 Google, Inc.
+ *
+ * Based on code by Dmitry Chernenkov.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#include <linux/gfp.h>
+#include <linux/hash.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/percpu.h>
+#include <linux/printk.h>
+#include <linux/shrinker.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include "../slab.h"
+#include "kasan.h"
+
+/* Data structure and operations for quarantine queues. */
+
+/* Each queue is a signled-linked list, which also stores the total size of
+ * objects inside of it.
+ */
+struct qlist {
+	void **head;
+	void **tail;
+	size_t bytes;
+};
+
+#define QLIST_INIT { NULL, NULL, 0 }
+
+static inline bool empty_qlist(struct qlist *q)
+{
+	return !q->head;
+}
+
+static inline void init_qlist(struct qlist *q)
+{
+	q->head = q->tail = NULL;
+	q->bytes = 0;
+}
+
+static inline void qlist_put(struct qlist *q, void **qlink, size_t size)
+{
+	if (unlikely(empty_qlist(q)))
+		q->head = qlink;
+	else
+		*q->tail = qlink;
+	q->tail = qlink;
+	*qlink = NULL;
+	q->bytes += size;
+}
+
+static inline void **qlist_remove(struct qlist *q, void ***prev,
+				 size_t size)
+{
+	void **qlink = *prev;
+
+	*prev = *qlink;
+	if (q->tail == qlink) {
+		if (q->head == qlink)
+			q->tail = NULL;
+		else
+			q->tail = (void **)prev;
+	}
+	q->bytes -= size;
+
+	return qlink;
+}
+
+static inline void qlist_move_all(struct qlist *from, struct qlist *to)
+{
+	if (unlikely(empty_qlist(from)))
+		return;
+
+	if (empty_qlist(to)) {
+		*to = *from;
+		init_qlist(from);
+		return;
+	}
+
+	*to->tail = from->head;
+	to->tail = from->tail;
+	to->bytes += from->bytes;
+
+	init_qlist(from);
+}
+
+static inline void qlist_move(struct qlist *from, void **last, struct qlist *to,
+			  size_t size)
+{
+	if (unlikely(last == from->tail)) {
+		qlist_move_all(from, to);
+		return;
+	}
+	if (empty_qlist(to))
+		to->head = from->head;
+	else
+		*to->tail = from->head;
+	to->tail = last;
+	from->head = *last;
+	*last = NULL;
+	from->bytes -= size;
+	to->bytes += size;
+}
+
+
+/* The object quarantine consists of per-cpu queues and a global queue,
+ * guarded by quarantine_lock.
+ */
+static DEFINE_PER_CPU(struct qlist, cpu_quarantine);
+
+static struct qlist global_quarantine;
+static DEFINE_SPINLOCK(quarantine_lock);
+
+/* Maximum size of the global queue. */
+static unsigned long quarantine_size;
+
+/* The fraction of physical memory the quarantine is allowed to occupy.
+ * Quarantine doesn't support memory shrinker with SLAB allocator, so we keep
+ * the ratio low to avoid OOM.
+ */
+#define QUARANTINE_FRACTION 32
+
+/* smp_load_acquire() here pairs with smp_store_release() in
+ * quarantine_reduce().
+ */
+#define QUARANTINE_LOW_SIZE (smp_load_acquire(&quarantine_size) * 3 / 4)
+#define QUARANTINE_PERCPU_SIZE (1 << 20)
+
+static inline struct kmem_cache *qlink_to_cache(void **qlink)
+{
+	return virt_to_head_page(qlink)->slab_cache;
+}
+
+static inline void *qlink_to_object(void **qlink, struct kmem_cache *cache)
+{
+	struct kasan_free_meta *free_info =
+		container_of((void ***)qlink, struct kasan_free_meta,
+			     quarantine_link);
+
+	return ((void *)free_info) - cache->kasan_info.free_meta_offset;
+}
+
+static inline void qlink_free(void **qlink, struct kmem_cache *cache)
+{
+	void *object = qlink_to_object(qlink, cache);
+	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
+	unsigned long flags;
+
+	local_irq_save(flags);
+	alloc_info->state = KASAN_STATE_FREE;
+	___cache_free(cache, object, _THIS_IP_);
+	local_irq_restore(flags);
+}
+
+static inline void qlist_free_all(struct qlist *q, struct kmem_cache *cache)
+{
+	void **qlink;
+
+	if (unlikely(empty_qlist(q)))
+		return;
+
+	qlink = q->head;
+	while (qlink) {
+		struct kmem_cache *obj_cache =
+			cache ? cache :	qlink_to_cache(qlink);
+		void **next = *qlink;
+
+		qlink_free(qlink, obj_cache);
+		qlink = next;
+	}
+	init_qlist(q);
+}
+
+void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
+{
+	unsigned long flags;
+	struct qlist *q;
+	struct qlist temp = QLIST_INIT;
+
+	local_irq_save(flags);
+
+	q = this_cpu_ptr(&cpu_quarantine);
+	qlist_put(q, (void **) &info->quarantine_link, cache->size);
+	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE))
+		qlist_move_all(q, &temp);
+
+	local_irq_restore(flags);
+
+	if (unlikely(!empty_qlist(&temp))) {
+		spin_lock_irqsave(&quarantine_lock, flags);
+		qlist_move_all(&temp, &global_quarantine);
+		spin_unlock_irqrestore(&quarantine_lock, flags);
+	}
+}
+
+void quarantine_reduce(void)
+{
+	size_t new_quarantine_size;
+	unsigned long flags;
+	struct qlist to_free = QLIST_INIT;
+	size_t size_to_free = 0;
+	void **last;
+
+	/* smp_load_acquire() here pairs with smp_store_release() below. */
+	if (likely(ACCESS_ONCE(global_quarantine.bytes) <=
+		   smp_load_acquire(&quarantine_size)))
+		return;
+
+	spin_lock_irqsave(&quarantine_lock, flags);
+
+	/* Update quarantine size in case of hotplug. Allocate a fraction of
+	 * the installed memory to quarantine minus per-cpu queue limits.
+	 */
+	new_quarantine_size = (ACCESS_ONCE(totalram_pages) << PAGE_SHIFT) /
+		QUARANTINE_FRACTION;
+	new_quarantine_size -= QUARANTINE_PERCPU_SIZE * num_online_cpus();
+	/* Pairs with smp_load_acquire() above and in QUARANTINE_LOW_SIZE. */
+	smp_store_release(&quarantine_size, new_quarantine_size);
+
+	last = global_quarantine.head;
+	while (last) {
+		struct kmem_cache *cache = qlink_to_cache(last);
+
+		size_to_free += cache->size;
+		if (!*last || size_to_free >
+		    global_quarantine.bytes - QUARANTINE_LOW_SIZE)
+			break;
+		last = (void **) *last;
+	}
+	qlist_move(&global_quarantine, last, &to_free, size_to_free);
+
+	spin_unlock_irqrestore(&quarantine_lock, flags);
+
+	qlist_free_all(&to_free, NULL);
+}
+
+static inline void qlist_move_cache(struct qlist *from,
+				   struct qlist *to,
+				   struct kmem_cache *cache)
+{
+	void ***prev;
+
+	if (unlikely(empty_qlist(from)))
+		return;
+
+	prev = &from->head;
+	while (*prev) {
+		void **qlink = *prev;
+		struct kmem_cache *obj_cache = qlink_to_cache(qlink);
+
+		if (obj_cache == cache) {
+			if (unlikely(from->tail == qlink))
+				from->tail = (void **) prev;
+			*prev = (void **) *qlink;
+			from->bytes -= cache->size;
+			qlist_put(to, qlink, cache->size);
+		} else
+			prev = (void ***) *prev;
+	}
+}
+
+static void per_cpu_remove_cache(void *arg)
+{
+	struct kmem_cache *cache = arg;
+	struct qlist to_free = QLIST_INIT;
+	struct qlist *q;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	q = this_cpu_ptr(&cpu_quarantine);
+	qlist_move_cache(q, &to_free, cache);
+	local_irq_restore(flags);
+
+	qlist_free_all(&to_free, cache);
+}
+
+void quarantine_remove_cache(struct kmem_cache *cache)
+{
+	unsigned long flags;
+	struct qlist to_free = QLIST_INIT;
+
+	on_each_cpu(per_cpu_remove_cache, cache, 1);
+
+	spin_lock_irqsave(&quarantine_lock, flags);
+	qlist_move_cache(&global_quarantine, &to_free, cache);
+	spin_unlock_irqrestore(&quarantine_lock, flags);
+
+	qlist_free_all(&to_free, cache);
+}
diff -puN mm/kasan/report.c~mm-kasan-initial-memory-quarantine-implementation mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/kasan/report.c
@@ -152,6 +152,7 @@ static void object_err(struct kmem_cache
 		print_track(&alloc_info->track);
 		break;
 	case KASAN_STATE_FREE:
+	case KASAN_STATE_QUARANTINE:
 		pr_err("Object freed, allocated with size %u bytes\n",
 		       alloc_info->alloc_size);
 		free_info = get_free_info(cache, object);
diff -puN mm/mempool.c~mm-kasan-initial-memory-quarantine-implementation mm/mempool.c
--- a/mm/mempool.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/mempool.c
@@ -105,11 +105,12 @@ static inline void poison_element(mempoo
 static void kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab)
-		kasan_slab_free(pool->pool_data, element);
+		kasan_poison_slab_free(pool->pool_data, element);
 	if (pool->alloc == mempool_kmalloc)
-		kasan_kfree(element);
+		kasan_poison_kfree(element);
 	if (pool->alloc == mempool_alloc_pages)
-		kasan_free_pages(element, (unsigned long)pool->pool_data);
+		kasan_poison_free_pages(element,
+					(unsigned long)pool->pool_data);
 }
 
 static void kasan_unpoison_element(mempool_t *pool, void *element, gfp_t flags)
diff -puN mm/page_alloc.c~mm-kasan-initial-memory-quarantine-implementation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/page_alloc.c
@@ -1005,7 +1005,7 @@ static bool free_pages_prepare(struct pa
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
-	kasan_free_pages(page, order);
+	kasan_poison_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
diff -puN mm/slab.c~mm-kasan-initial-memory-quarantine-implementation mm/slab.c
--- a/mm/slab.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/slab.c
@@ -3327,9 +3327,20 @@ free_done:
 static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 				unsigned long caller)
 {
-	struct array_cache *ac = cpu_cache_get(cachep);
+#ifdef CONFIG_KASAN
+	if (kasan_slab_free(cachep, objp))
+		/* The object has been put into the quarantine, don't touch it
+		 * for now.
+		 */
+		return;
+#endif
+	___cache_free(cachep, objp, caller);
+}
 
-	kasan_slab_free(cachep, objp);
+void ___cache_free(struct kmem_cache *cachep, void *objp,
+		unsigned long caller)
+{
+	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
 	kmemleak_free_recursive(objp, cachep->flags);
diff -puN mm/slab.h~mm-kasan-initial-memory-quarantine-implementation mm/slab.h
--- a/mm/slab.h~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/slab.h
@@ -462,4 +462,6 @@ void *slab_next(struct seq_file *m, void
 void slab_stop(struct seq_file *m, void *p);
 int memcg_slab_show(struct seq_file *m, void *p);
 
+void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr);
+
 #endif /* MM_SLAB_H */
diff -puN mm/slab_common.c~mm-kasan-initial-memory-quarantine-implementation mm/slab_common.c
--- a/mm/slab_common.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/slab_common.c
@@ -715,6 +715,7 @@ void kmem_cache_destroy(struct kmem_cach
 	get_online_cpus();
 	get_online_mems();
 
+	kasan_cache_destroy(s);
 	mutex_lock(&slab_mutex);
 
 	s->refcount--;
@@ -753,6 +754,7 @@ int kmem_cache_shrink(struct kmem_cache
 
 	get_online_cpus();
 	get_online_mems();
+	kasan_cache_shrink(cachep);
 	ret = __kmem_cache_shrink(cachep, false);
 	put_online_mems();
 	put_online_cpus();
diff -puN mm/slub.c~mm-kasan-initial-memory-quarantine-implementation mm/slub.c
--- a/mm/slub.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/slub.c
@@ -1319,7 +1319,7 @@ static inline void kmalloc_large_node_ho
 static inline void kfree_hook(const void *x)
 {
 	kmemleak_free(x);
-	kasan_kfree_large(x);
+	kasan_poison_kfree_large(x);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
@@ -1344,7 +1344,7 @@ static inline void slab_free_hook(struct
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
 
-	kasan_slab_free(s, x);
+	kasan_poison_slab_free(s, x);
 }
 
 static inline void slab_free_freelist_hook(struct kmem_cache *s,
_

Patches currently in -mm which might be from glider@google.com are

kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right.patch
mm-kasan-slab-support.patch
mm-kasan-added-gfp-flags-to-kasan-api.patch
arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch
kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch
mm-kasan-initial-memory-quarantine-implementation.patch

