From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-initial-memory-quarantine-implementation-v8.patch removed from -mm tree
Date: Fri, 20 May 2016 16:39:05 -0700
Message-ID: <573fa019.bl0/pT0vnDsrLhuI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbcETXjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: Initial memory quarantine implementation
has been removed from the -mm tree.  Its filename was
     mm-kasan-initial-memory-quarantine-implementation-v8.patch

This patch was dropped because it was folded into mm-kasan-initial-memory-quarantine-implementation.patch

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: kasan: Initial memory quarantine implementation

v2: - added copyright comments
    - per request from Joonsoo Kim made __cache_free() more straightforward
    - added comments for smp_load_acquire()/smp_store_release()

v3: - incorporate changes introduced by the "mm, kasan: SLAB support" patch

v4: - fix kbuild compile-time error (missing ___cache_free() declaration)
      and a warning (wrong format specifier)

v6: - extended the patch description
    - dropped the unused qlist_remove() function

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

 mm/kasan/quarantine.c |   59 ++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff -puN mm/kasan/quarantine.c~mm-kasan-initial-memory-quarantine-implementation-v8 mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~mm-kasan-initial-memory-quarantine-implementation-v8
+++ a/mm/kasan/quarantine.c
@@ -33,7 +33,7 @@
 
 /* Data structure and operations for quarantine queues. */
 
-/* Each queue is a signled-linked list, which also stores the total size of
+/* Each queue is a signle-linked list, which also stores the total size of
  * objects inside of it.
  */
 struct qlist {
@@ -44,20 +44,20 @@ struct qlist {
 
 #define QLIST_INIT { NULL, NULL, 0 }
 
-static inline bool empty_qlist(struct qlist *q)
+static bool qlist_empty(struct qlist *q)
 {
 	return !q->head;
 }
 
-static inline void init_qlist(struct qlist *q)
+static void qlist_init(struct qlist *q)
 {
 	q->head = q->tail = NULL;
 	q->bytes = 0;
 }
 
-static inline void qlist_put(struct qlist *q, void **qlink, size_t size)
+static void qlist_put(struct qlist *q, void **qlink, size_t size)
 {
-	if (unlikely(empty_qlist(q)))
+	if (unlikely(qlist_empty(q)))
 		q->head = qlink;
 	else
 		*q->tail = qlink;
@@ -66,31 +66,14 @@ static inline void qlist_put(struct qlis
 	q->bytes += size;
 }
 
-static inline void **qlist_remove(struct qlist *q, void ***prev,
-				 size_t size)
+static void qlist_move_all(struct qlist *from, struct qlist *to)
 {
-	void **qlink = *prev;
-
-	*prev = *qlink;
-	if (q->tail == qlink) {
-		if (q->head == qlink)
-			q->tail = NULL;
-		else
-			q->tail = (void **)prev;
-	}
-	q->bytes -= size;
-
-	return qlink;
-}
-
-static inline void qlist_move_all(struct qlist *from, struct qlist *to)
-{
-	if (unlikely(empty_qlist(from)))
+	if (unlikely(qlist_empty(from)))
 		return;
 
-	if (empty_qlist(to)) {
+	if (qlist_empty(to)) {
 		*to = *from;
-		init_qlist(from);
+		qlist_init(from);
 		return;
 	}
 
@@ -98,17 +81,17 @@ static inline void qlist_move_all(struct
 	to->tail = from->tail;
 	to->bytes += from->bytes;
 
-	init_qlist(from);
+	qlist_init(from);
 }
 
-static inline void qlist_move(struct qlist *from, void **last, struct qlist *to,
+static void qlist_move(struct qlist *from, void **last, struct qlist *to,
 			  size_t size)
 {
 	if (unlikely(last == from->tail)) {
 		qlist_move_all(from, to);
 		return;
 	}
-	if (empty_qlist(to))
+	if (qlist_empty(to))
 		to->head = from->head;
 	else
 		*to->tail = from->head;
@@ -143,12 +126,12 @@ static unsigned long quarantine_size;
 #define QUARANTINE_LOW_SIZE (smp_load_acquire(&quarantine_size) * 3 / 4)
 #define QUARANTINE_PERCPU_SIZE (1 << 20)
 
-static inline struct kmem_cache *qlink_to_cache(void **qlink)
+static struct kmem_cache *qlink_to_cache(void **qlink)
 {
 	return virt_to_head_page(qlink)->slab_cache;
 }
 
-static inline void *qlink_to_object(void **qlink, struct kmem_cache *cache)
+static void *qlink_to_object(void **qlink, struct kmem_cache *cache)
 {
 	struct kasan_free_meta *free_info =
 		container_of((void ***)qlink, struct kasan_free_meta,
@@ -157,7 +140,7 @@ static inline void *qlink_to_object(void
 	return ((void *)free_info) - cache->kasan_info.free_meta_offset;
 }
 
-static inline void qlink_free(void **qlink, struct kmem_cache *cache)
+static void qlink_free(void **qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
 	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
@@ -169,11 +152,11 @@ static inline void qlink_free(void **qli
 	local_irq_restore(flags);
 }
 
-static inline void qlist_free_all(struct qlist *q, struct kmem_cache *cache)
+static void qlist_free_all(struct qlist *q, struct kmem_cache *cache)
 {
 	void **qlink;
 
-	if (unlikely(empty_qlist(q)))
+	if (unlikely(qlist_empty(q)))
 		return;
 
 	qlink = q->head;
@@ -185,7 +168,7 @@ static inline void qlist_free_all(struct
 		qlink_free(qlink, obj_cache);
 		qlink = next;
 	}
-	init_qlist(q);
+	qlist_init(q);
 }
 
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
@@ -203,7 +186,7 @@ void quarantine_put(struct kasan_free_me
 
 	local_irq_restore(flags);
 
-	if (unlikely(!empty_qlist(&temp))) {
+	if (unlikely(!qlist_empty(&temp))) {
 		spin_lock_irqsave(&quarantine_lock, flags);
 		qlist_move_all(&temp, &global_quarantine);
 		spin_unlock_irqrestore(&quarantine_lock, flags);
@@ -251,13 +234,13 @@ void quarantine_reduce(void)
 	qlist_free_all(&to_free, NULL);
 }
 
-static inline void qlist_move_cache(struct qlist *from,
+static void qlist_move_cache(struct qlist *from,
 				   struct qlist *to,
 				   struct kmem_cache *cache)
 {
 	void ***prev;
 
-	if (unlikely(empty_qlist(from)))
+	if (unlikely(qlist_empty(from)))
 		return;
 
 	prev = &from->head;
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v9.patch
mm-kasan-dont-call-kasan_krealloc-from-ksize.patch
mm-kasan-add-a-ksize-test.patch

