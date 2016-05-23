From: akpm@linux-foundation.org
Subject: [merged] mm-kasan-initial-memory-quarantine-implementation.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:47:18 -0700
Message-ID: <57435e46.Azfj8UueiOjx/rng%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbcEWTrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: initial memory quarantine implementation
has been removed from the -mm tree.  Its filename was
     mm-kasan-initial-memory-quarantine-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: kasan: initial memory quarantine implementation

Quarantine isolates freed objects in a separate queue.  The objects are
returned to the allocator later, which helps to detect use-after-free
errors.

When the object is freed, its state changes from KASAN_STATE_ALLOC to
KASAN_STATE_QUARANTINE.  The object is poisoned and put into quarantine
instead of being returned to the allocator, therefore every subsequent
access to that object triggers a KASAN error, and the error handler is
able to say where the object has been allocated and deallocated.

When it's time for the object to leave quarantine, its state becomes
KASAN_STATE_FREE and it's returned to the allocator.  From now on the
allocator may reuse it for another allocation.  Before that happens,
it's still possible to detect a use-after free on that object (it
retains the allocation/deallocation stacks).

When the allocator reuses this object, the shadow is unpoisoned and old
allocation/deallocation stacks are wiped.  Therefore a use of this
object, even an incorrect one, won't trigger ASan warning.

Without the quarantine, it's not guaranteed that the objects aren't
reused immediately, that's why the probability of catching a
use-after-free is lower than with quarantine in place.



Quarantine isolates freed objects in a separate queue.  The objects are
returned to the allocator later, which helps to detect use-after-free
errors.

Freed objects are first added to per-cpu quarantine queues.  When a cache
is destroyed or memory shrinking is requested, the objects are moved into
the global quarantine queue.  Whenever a kmalloc call allows memory
reclaiming, the oldest objects are popped out of the global queue until
the total size of objects in quarantine is less than 3/4 of the maximum
quarantine size (which is a fraction of installed physical memory).

As long as an object remains in the quarantine, KASAN is able to report
accesses to it, so the chance of reporting a use-after-free is increased. 
Once the object leaves quarantine, the allocator may reuse it, in which
case the object is unpoisoned and KASAN can't detect incorrect accesses to
it.

Right now quarantine support is only enabled in SLAB allocator. 
Unification of KASAN features in SLAB and SLUB will be done later.

This patch is based on the "mm: kasan: quarantine" patch originally
prepared by Dmitry Chernenkov.  A number of improvements have been
suggested by Andrey Ryabinin.

[glider@google.com: v9]
  Link: http://lkml.kernel.org/r/1462987130-144092-1-git-send-email-glider@google.com
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

 include/linux/kasan.h |   13 +
 mm/kasan/Makefile     |    1 
 mm/kasan/kasan.c      |   57 ++++++-
 mm/kasan/kasan.h      |   21 ++
 mm/kasan/quarantine.c |  291 ++++++++++++++++++++++++++++++++++++++++
 mm/kasan/report.c     |    1 
 mm/mempool.c          |    2 
 mm/slab.c             |   12 +
 mm/slab.h             |    2 
 mm/slab_common.c      |    2 
 10 files changed, 387 insertions(+), 15 deletions(-)

diff -puN include/linux/kasan.h~mm-kasan-initial-memory-quarantine-implementation include/linux/kasan.h
--- a/include/linux/kasan.h~mm-kasan-initial-memory-quarantine-implementation
+++ a/include/linux/kasan.h
@@ -50,6 +50,8 @@ void kasan_free_pages(struct page *page,
 
 void kasan_cache_create(struct kmem_cache *cache, size_t *size,
 			unsigned long *flags);
+void kasan_cache_shrink(struct kmem_cache *cache);
+void kasan_cache_destroy(struct kmem_cache *cache);
 
 void kasan_poison_slab(struct page *page);
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
@@ -63,7 +65,8 @@ void kasan_kmalloc(struct kmem_cache *s,
 void kasan_krealloc(const void *object, size_t new_size, gfp_t flags);
 
 void kasan_slab_alloc(struct kmem_cache *s, void *object, gfp_t flags);
-void kasan_slab_free(struct kmem_cache *s, void *object);
+bool kasan_slab_free(struct kmem_cache *s, void *object);
+void kasan_poison_slab_free(struct kmem_cache *s, void *object);
 
 struct kasan_cache {
 	int alloc_meta_offset;
@@ -88,6 +91,8 @@ static inline void kasan_free_pages(stru
 static inline void kasan_cache_create(struct kmem_cache *cache,
 				      size_t *size,
 				      unsigned long *flags) {}
+static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
+static inline void kasan_cache_destroy(struct kmem_cache *cache) {}
 
 static inline void kasan_poison_slab(struct page *page) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
@@ -105,7 +110,11 @@ static inline void kasan_krealloc(const
 
 static inline void kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags) {}
-static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
+static inline bool kasan_slab_free(struct kmem_cache *s, void *object)
+{
+	return false;
+}
+static inline void kasan_poison_slab_free(struct kmem_cache *s, void *object) {}
 
 static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
 static inline void kasan_free_shadow(const struct vm_struct *vm) {}
diff -puN mm/kasan/Makefile~mm-kasan-initial-memory-quarantine-implementation mm/kasan/Makefile
--- a/mm/kasan/Makefile~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/kasan/Makefile
@@ -8,3 +8,4 @@ CFLAGS_REMOVE_kasan.o = -pg
 CFLAGS_kasan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
 
 obj-y := kasan.o report.o kasan_init.o
+obj-$(CONFIG_SLAB) += quarantine.o
diff -puN mm/kasan/kasan.c~mm-kasan-initial-memory-quarantine-implementation mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/kasan/kasan.c
@@ -388,6 +388,16 @@ void kasan_cache_create(struct kmem_cach
 }
 #endif
 
+void kasan_cache_shrink(struct kmem_cache *cache)
+{
+	quarantine_remove_cache(cache);
+}
+
+void kasan_cache_destroy(struct kmem_cache *cache)
+{
+	quarantine_remove_cache(cache);
+}
+
 void kasan_poison_slab(struct page *page)
 {
 	kasan_poison_shadow(page_address(page),
@@ -482,7 +492,7 @@ void kasan_slab_alloc(struct kmem_cache
 	kasan_kmalloc(cache, object, cache->object_size, flags);
 }
 
-void kasan_slab_free(struct kmem_cache *cache, void *object)
+void kasan_poison_slab_free(struct kmem_cache *cache, void *object)
 {
 	unsigned long size = cache->object_size;
 	unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
@@ -491,18 +501,43 @@ void kasan_slab_free(struct kmem_cache *
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
-		set_track(&free_info->track, GFP_NOWAIT);
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
@@ -511,6 +546,9 @@ void kasan_kmalloc(struct kmem_cache *ca
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
+	if (flags & __GFP_RECLAIM)
+		quarantine_reduce();
+
 	if (unlikely(object == NULL))
 		return;
 
@@ -541,6 +579,9 @@ void kasan_kmalloc_large(const void *ptr
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
+	if (flags & __GFP_RECLAIM)
+		quarantine_reduce();
+
 	if (unlikely(ptr == NULL))
 		return;
 
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
 
@@ -79,9 +80,14 @@ struct kasan_alloc_meta {
 	u32 reserved;
 };
 
+struct qlist_node {
+	struct qlist_node *next;
+};
 struct kasan_free_meta {
-	/* Allocator freelist pointer, unused by KASAN. */
-	void **freelist;
+	/* This field is used while the object is in the quarantine.
+	 * Otherwise it might be used for the allocator freelist.
+	 */
+	struct qlist_node quarantine_link;
 	struct kasan_track track;
 };
 
@@ -105,4 +111,15 @@ static inline bool kasan_report_enabled(
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 
+#ifdef CONFIG_SLAB
+void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
+void quarantine_reduce(void);
+void quarantine_remove_cache(struct kmem_cache *cache);
+#else
+static inline void quarantine_put(struct kasan_free_meta *info,
+				struct kmem_cache *cache) { }
+static inline void quarantine_reduce(void) { }
+static inline void quarantine_remove_cache(struct kmem_cache *cache) { }
+#endif
+
 #endif
diff -puN /dev/null mm/kasan/quarantine.c
--- /dev/null
+++ a/mm/kasan/quarantine.c
@@ -0,0 +1,291 @@
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
+/*
+ * Each queue is a signle-linked list, which also stores the total size of
+ * objects inside of it.
+ */
+struct qlist_head {
+	struct qlist_node *head;
+	struct qlist_node *tail;
+	size_t bytes;
+};
+
+#define QLIST_INIT { NULL, NULL, 0 }
+
+static bool qlist_empty(struct qlist_head *q)
+{
+	return !q->head;
+}
+
+static void qlist_init(struct qlist_head *q)
+{
+	q->head = q->tail = NULL;
+	q->bytes = 0;
+}
+
+static void qlist_put(struct qlist_head *q, struct qlist_node *qlink,
+		size_t size)
+{
+	if (unlikely(qlist_empty(q)))
+		q->head = qlink;
+	else
+		q->tail->next = qlink;
+	q->tail = qlink;
+	qlink->next = NULL;
+	q->bytes += size;
+}
+
+static void qlist_move_all(struct qlist_head *from, struct qlist_head *to)
+{
+	if (unlikely(qlist_empty(from)))
+		return;
+
+	if (qlist_empty(to)) {
+		*to = *from;
+		qlist_init(from);
+		return;
+	}
+
+	to->tail->next = from->head;
+	to->tail = from->tail;
+	to->bytes += from->bytes;
+
+	qlist_init(from);
+}
+
+static void qlist_move(struct qlist_head *from, struct qlist_node *last,
+		struct qlist_head *to, size_t size)
+{
+	if (unlikely(last == from->tail)) {
+		qlist_move_all(from, to);
+		return;
+	}
+	if (qlist_empty(to))
+		to->head = from->head;
+	else
+		to->tail->next = from->head;
+	to->tail = last;
+	from->head = last->next;
+	last->next = NULL;
+	from->bytes -= size;
+	to->bytes += size;
+}
+
+
+/*
+ * The object quarantine consists of per-cpu queues and a global queue,
+ * guarded by quarantine_lock.
+ */
+static DEFINE_PER_CPU(struct qlist_head, cpu_quarantine);
+
+static struct qlist_head global_quarantine;
+static DEFINE_SPINLOCK(quarantine_lock);
+
+/* Maximum size of the global queue. */
+static unsigned long quarantine_size;
+
+/*
+ * The fraction of physical memory the quarantine is allowed to occupy.
+ * Quarantine doesn't support memory shrinker with SLAB allocator, so we keep
+ * the ratio low to avoid OOM.
+ */
+#define QUARANTINE_FRACTION 32
+
+#define QUARANTINE_LOW_SIZE (READ_ONCE(quarantine_size) * 3 / 4)
+#define QUARANTINE_PERCPU_SIZE (1 << 20)
+
+static struct kmem_cache *qlink_to_cache(struct qlist_node *qlink)
+{
+	return virt_to_head_page(qlink)->slab_cache;
+}
+
+static void *qlink_to_object(struct qlist_node *qlink, struct kmem_cache *cache)
+{
+	struct kasan_free_meta *free_info =
+		container_of(qlink, struct kasan_free_meta,
+			     quarantine_link);
+
+	return ((void *)free_info) - cache->kasan_info.free_meta_offset;
+}
+
+static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
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
+static void qlist_free_all(struct qlist_head *q, struct kmem_cache *cache)
+{
+	struct qlist_node *qlink;
+
+	if (unlikely(qlist_empty(q)))
+		return;
+
+	qlink = q->head;
+	while (qlink) {
+		struct kmem_cache *obj_cache =
+			cache ? cache :	qlink_to_cache(qlink);
+		struct qlist_node *next = qlink->next;
+
+		qlink_free(qlink, obj_cache);
+		qlink = next;
+	}
+	qlist_init(q);
+}
+
+void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
+{
+	unsigned long flags;
+	struct qlist_head *q;
+	struct qlist_head temp = QLIST_INIT;
+
+	local_irq_save(flags);
+
+	q = this_cpu_ptr(&cpu_quarantine);
+	qlist_put(q, &info->quarantine_link, cache->size);
+	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE))
+		qlist_move_all(q, &temp);
+
+	local_irq_restore(flags);
+
+	if (unlikely(!qlist_empty(&temp))) {
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
+	struct qlist_head to_free = QLIST_INIT;
+	size_t size_to_free = 0;
+	struct qlist_node *last;
+
+	if (likely(READ_ONCE(global_quarantine.bytes) <=
+		   READ_ONCE(quarantine_size)))
+		return;
+
+	spin_lock_irqsave(&quarantine_lock, flags);
+
+	/*
+	 * Update quarantine size in case of hotplug. Allocate a fraction of
+	 * the installed memory to quarantine minus per-cpu queue limits.
+	 */
+	new_quarantine_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
+		QUARANTINE_FRACTION;
+	new_quarantine_size -= QUARANTINE_PERCPU_SIZE * num_online_cpus();
+	WRITE_ONCE(quarantine_size, new_quarantine_size);
+
+	last = global_quarantine.head;
+	while (last) {
+		struct kmem_cache *cache = qlink_to_cache(last);
+
+		size_to_free += cache->size;
+		if (!last->next || size_to_free >
+		    global_quarantine.bytes - QUARANTINE_LOW_SIZE)
+			break;
+		last = last->next;
+	}
+	qlist_move(&global_quarantine, last, &to_free, size_to_free);
+
+	spin_unlock_irqrestore(&quarantine_lock, flags);
+
+	qlist_free_all(&to_free, NULL);
+}
+
+static void qlist_move_cache(struct qlist_head *from,
+				   struct qlist_head *to,
+				   struct kmem_cache *cache)
+{
+	struct qlist_node *prev = NULL, *curr;
+
+	if (unlikely(qlist_empty(from)))
+		return;
+
+	curr = from->head;
+	while (curr) {
+		struct qlist_node *qlink = curr;
+		struct kmem_cache *obj_cache = qlink_to_cache(qlink);
+
+		if (obj_cache == cache) {
+			if (unlikely(from->head == qlink)) {
+				from->head = curr->next;
+				prev = curr;
+			} else
+				prev->next = curr->next;
+			if (unlikely(from->tail == qlink))
+				from->tail = curr->next;
+			from->bytes -= cache->size;
+			qlist_put(to, qlink, cache->size);
+		} else {
+			prev = curr;
+		}
+		curr = curr->next;
+	}
+}
+
+static void per_cpu_remove_cache(void *arg)
+{
+	struct kmem_cache *cache = arg;
+	struct qlist_head to_free = QLIST_INIT;
+	struct qlist_head *q;
+
+	q = this_cpu_ptr(&cpu_quarantine);
+	qlist_move_cache(q, &to_free, cache);
+	qlist_free_all(&to_free, cache);
+}
+
+void quarantine_remove_cache(struct kmem_cache *cache)
+{
+	unsigned long flags;
+	struct qlist_head to_free = QLIST_INIT;
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
@@ -151,6 +151,7 @@ static void object_err(struct kmem_cache
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
@@ -105,7 +105,7 @@ static inline void poison_element(mempoo
 static void kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab)
-		kasan_slab_free(pool->pool_data, element);
+		kasan_poison_slab_free(pool->pool_data, element);
 	if (pool->alloc == mempool_kmalloc)
 		kasan_kfree(element);
 	if (pool->alloc == mempool_alloc_pages)
diff -puN mm/slab.c~mm-kasan-initial-memory-quarantine-implementation mm/slab.c
--- a/mm/slab.c~mm-kasan-initial-memory-quarantine-implementation
+++ a/mm/slab.c
@@ -3547,9 +3547,17 @@ free_done:
 static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 				unsigned long caller)
 {
-	struct array_cache *ac = cpu_cache_get(cachep);
+	/* Put the object into the quarantine, don't touch it for now. */
+	if (kasan_slab_free(cachep, objp))
+		return;
+
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
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-dont-call-kasan_krealloc-from-ksize.patch
mm-kasan-add-a-ksize-test.patch

