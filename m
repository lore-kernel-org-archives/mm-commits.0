From: akpm@linux-foundation.org
Subject: [merged] mm-kasan-added-gfp-flags-to-kasan-api.patch removed from -mm tree
Date: Sat, 26 Mar 2016 20:31:21 -0700
Message-ID: <56f75409.utjC3I88F0VJ+RDf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0DbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:31:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: add GFP flags to KASAN API
has been removed from the -mm tree.  Its filename was
     mm-kasan-added-gfp-flags-to-kasan-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: add GFP flags to KASAN API

Add GFP flags to KASAN hooks for future patches to use.

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

 include/linux/kasan.h |   19 +++++++++++--------
 include/linux/slab.h  |    4 ++--
 mm/kasan/kasan.c      |   15 ++++++++-------
 mm/mempool.c          |   16 ++++++++--------
 mm/slab.c             |   15 ++++++++-------
 mm/slab.h             |    2 +-
 mm/slab_common.c      |    4 ++--
 mm/slub.c             |   15 ++++++++-------
 8 files changed, 48 insertions(+), 42 deletions(-)

diff -puN include/linux/kasan.h~mm-kasan-added-gfp-flags-to-kasan-api include/linux/kasan.h
--- a/include/linux/kasan.h~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/include/linux/kasan.h
@@ -55,13 +55,14 @@ void kasan_poison_slab(struct page *page
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
 void kasan_poison_object_data(struct kmem_cache *cache, void *object);
 
-void kasan_kmalloc_large(const void *ptr, size_t size);
+void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
 void kasan_kfree_large(const void *ptr);
 void kasan_kfree(void *ptr);
-void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size);
-void kasan_krealloc(const void *object, size_t new_size);
+void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size,
+		  gfp_t flags);
+void kasan_krealloc(const void *object, size_t new_size, gfp_t flags);
 
-void kasan_slab_alloc(struct kmem_cache *s, void *object);
+void kasan_slab_alloc(struct kmem_cache *s, void *object, gfp_t flags);
 void kasan_slab_free(struct kmem_cache *s, void *object);
 
 struct kasan_cache {
@@ -94,14 +95,16 @@ static inline void kasan_unpoison_object
 static inline void kasan_poison_object_data(struct kmem_cache *cache,
 					void *object) {}
 
-static inline void kasan_kmalloc_large(void *ptr, size_t size) {}
+static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
 static inline void kasan_kfree_large(const void *ptr) {}
 static inline void kasan_kfree(void *ptr) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
-				size_t size) {}
-static inline void kasan_krealloc(const void *object, size_t new_size) {}
+				size_t size, gfp_t flags) {}
+static inline void kasan_krealloc(const void *object, size_t new_size,
+				 gfp_t flags) {}
 
-static inline void kasan_slab_alloc(struct kmem_cache *s, void *object) {}
+static inline void kasan_slab_alloc(struct kmem_cache *s, void *object,
+				   gfp_t flags) {}
 static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
 
 static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
diff -puN include/linux/slab.h~mm-kasan-added-gfp-flags-to-kasan-api include/linux/slab.h
--- a/include/linux/slab.h~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/include/linux/slab.h
@@ -376,7 +376,7 @@ static __always_inline void *kmem_cache_
 {
 	void *ret = kmem_cache_alloc(s, flags);
 
-	kasan_kmalloc(s, ret, size);
+	kasan_kmalloc(s, ret, size, flags);
 	return ret;
 }
 
@@ -387,7 +387,7 @@ kmem_cache_alloc_node_trace(struct kmem_
 {
 	void *ret = kmem_cache_alloc_node(s, gfpflags, node);
 
-	kasan_kmalloc(s, ret, size);
+	kasan_kmalloc(s, ret, size, gfpflags);
 	return ret;
 }
 #endif /* CONFIG_TRACING */
diff -puN mm/kasan/kasan.c~mm-kasan-added-gfp-flags-to-kasan-api mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/mm/kasan/kasan.c
@@ -434,9 +434,9 @@ struct kasan_free_meta *get_free_info(st
 }
 #endif
 
-void kasan_slab_alloc(struct kmem_cache *cache, void *object)
+void kasan_slab_alloc(struct kmem_cache *cache, void *object, gfp_t flags)
 {
-	kasan_kmalloc(cache, object, cache->object_size);
+	kasan_kmalloc(cache, object, cache->object_size, flags);
 }
 
 void kasan_slab_free(struct kmem_cache *cache, void *object)
@@ -462,7 +462,8 @@ void kasan_slab_free(struct kmem_cache *
 	kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
 }
 
-void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size)
+void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size,
+		   gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
@@ -491,7 +492,7 @@ void kasan_kmalloc(struct kmem_cache *ca
 }
 EXPORT_SYMBOL(kasan_kmalloc);
 
-void kasan_kmalloc_large(const void *ptr, size_t size)
+void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags)
 {
 	struct page *page;
 	unsigned long redzone_start;
@@ -510,7 +511,7 @@ void kasan_kmalloc_large(const void *ptr
 		KASAN_PAGE_REDZONE);
 }
 
-void kasan_krealloc(const void *object, size_t size)
+void kasan_krealloc(const void *object, size_t size, gfp_t flags)
 {
 	struct page *page;
 
@@ -520,9 +521,9 @@ void kasan_krealloc(const void *object,
 	page = virt_to_head_page(object);
 
 	if (unlikely(!PageSlab(page)))
-		kasan_kmalloc_large(object, size);
+		kasan_kmalloc_large(object, size, flags);
 	else
-		kasan_kmalloc(page->slab_cache, object, size);
+		kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
 void kasan_kfree(void *ptr)
diff -puN mm/mempool.c~mm-kasan-added-gfp-flags-to-kasan-api mm/mempool.c
--- a/mm/mempool.c~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/mm/mempool.c
@@ -112,12 +112,12 @@ static void kasan_poison_element(mempool
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
 
-static void kasan_unpoison_element(mempool_t *pool, void *element)
+static void kasan_unpoison_element(mempool_t *pool, void *element, gfp_t flags)
 {
 	if (pool->alloc == mempool_alloc_slab)
-		kasan_slab_alloc(pool->pool_data, element);
+		kasan_slab_alloc(pool->pool_data, element, flags);
 	if (pool->alloc == mempool_kmalloc)
-		kasan_krealloc(element, (size_t)pool->pool_data);
+		kasan_krealloc(element, (size_t)pool->pool_data, flags);
 	if (pool->alloc == mempool_alloc_pages)
 		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
 }
@@ -130,12 +130,12 @@ static void add_element(mempool_t *pool,
 	pool->elements[pool->curr_nr++] = element;
 }
 
-static void *remove_element(mempool_t *pool)
+static void *remove_element(mempool_t *pool, gfp_t flags)
 {
 	void *element = pool->elements[--pool->curr_nr];
 
 	BUG_ON(pool->curr_nr < 0);
-	kasan_unpoison_element(pool, element);
+	kasan_unpoison_element(pool, element, flags);
 	check_element(pool, element);
 	return element;
 }
@@ -154,7 +154,7 @@ void mempool_destroy(mempool_t *pool)
 		return;
 
 	while (pool->curr_nr) {
-		void *element = remove_element(pool);
+		void *element = remove_element(pool, GFP_KERNEL);
 		pool->free(element, pool->pool_data);
 	}
 	kfree(pool->elements);
@@ -250,7 +250,7 @@ int mempool_resize(mempool_t *pool, int
 	spin_lock_irqsave(&pool->lock, flags);
 	if (new_min_nr <= pool->min_nr) {
 		while (new_min_nr < pool->curr_nr) {
-			element = remove_element(pool);
+			element = remove_element(pool, GFP_KERNEL);
 			spin_unlock_irqrestore(&pool->lock, flags);
 			pool->free(element, pool->pool_data);
 			spin_lock_irqsave(&pool->lock, flags);
@@ -347,7 +347,7 @@ repeat_alloc:
 
 	spin_lock_irqsave(&pool->lock, flags);
 	if (likely(pool->curr_nr)) {
-		element = remove_element(pool);
+		element = remove_element(pool, gfp_temp);
 		spin_unlock_irqrestore(&pool->lock, flags);
 		/* paired with rmb in mempool_free(), read comment there */
 		smp_wmb();
diff -puN mm/slab.c~mm-kasan-added-gfp-flags-to-kasan-api mm/slab.c
--- a/mm/slab.c~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/mm/slab.c
@@ -3378,7 +3378,7 @@ void *kmem_cache_alloc(struct kmem_cache
 {
 	void *ret = slab_alloc(cachep, flags, _RET_IP_);
 
-	kasan_slab_alloc(cachep, ret);
+	kasan_slab_alloc(cachep, ret, flags);
 	trace_kmem_cache_alloc(_RET_IP_, ret,
 			       cachep->object_size, cachep->size, flags);
 
@@ -3444,7 +3444,7 @@ kmem_cache_alloc_trace(struct kmem_cache
 
 	ret = slab_alloc(cachep, flags, _RET_IP_);
 
-	kasan_kmalloc(cachep, ret, size);
+	kasan_kmalloc(cachep, ret, size, flags);
 	trace_kmalloc(_RET_IP_, ret,
 		      size, cachep->size, flags);
 	return ret;
@@ -3468,7 +3468,7 @@ void *kmem_cache_alloc_node(struct kmem_
 {
 	void *ret = slab_alloc_node(cachep, flags, nodeid, _RET_IP_);
 
-	kasan_slab_alloc(cachep, ret);
+	kasan_slab_alloc(cachep, ret, flags);
 	trace_kmem_cache_alloc_node(_RET_IP_, ret,
 				    cachep->object_size, cachep->size,
 				    flags, nodeid);
@@ -3486,7 +3486,8 @@ void *kmem_cache_alloc_node_trace(struct
 	void *ret;
 
 	ret = slab_alloc_node(cachep, flags, nodeid, _RET_IP_);
-	kasan_kmalloc(cachep, ret, size);
+
+	kasan_kmalloc(cachep, ret, size, flags);
 	trace_kmalloc_node(_RET_IP_, ret,
 			   size, cachep->size,
 			   flags, nodeid);
@@ -3505,7 +3506,7 @@ __do_kmalloc_node(size_t size, gfp_t fla
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
 	ret = kmem_cache_alloc_node_trace(cachep, flags, node, size);
-	kasan_kmalloc(cachep, ret, size);
+	kasan_kmalloc(cachep, ret, size, flags);
 
 	return ret;
 }
@@ -3541,7 +3542,7 @@ static __always_inline void *__do_kmallo
 		return cachep;
 	ret = slab_alloc(cachep, flags, caller);
 
-	kasan_kmalloc(cachep, ret, size);
+	kasan_kmalloc(cachep, ret, size, flags);
 	trace_kmalloc(caller, ret,
 		      size, cachep->size, flags);
 
@@ -4323,7 +4324,7 @@ size_t ksize(const void *objp)
 	/* We assume that ksize callers could use the whole allocated area,
 	 * so we need to unpoison this area.
 	 */
-	kasan_krealloc(objp, size);
+	kasan_krealloc(objp, size, GFP_NOWAIT);
 
 	return size;
 }
diff -puN mm/slab.h~mm-kasan-added-gfp-flags-to-kasan-api mm/slab.h
--- a/mm/slab.h~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/mm/slab.h
@@ -405,7 +405,7 @@ static inline void slab_post_alloc_hook(
 		kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
 		kmemleak_alloc_recursive(object, s->object_size, 1,
 					 s->flags, flags);
-		kasan_slab_alloc(s, object);
+		kasan_slab_alloc(s, object, flags);
 	}
 	memcg_kmem_put_cache(s);
 }
diff -puN mm/slab_common.c~mm-kasan-added-gfp-flags-to-kasan-api mm/slab_common.c
--- a/mm/slab_common.c~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/mm/slab_common.c
@@ -1013,7 +1013,7 @@ void *kmalloc_order(size_t size, gfp_t f
 	page = alloc_kmem_pages(flags, order);
 	ret = page ? page_address(page) : NULL;
 	kmemleak_alloc(ret, size, 1, flags);
-	kasan_kmalloc_large(ret, size);
+	kasan_kmalloc_large(ret, size, flags);
 	return ret;
 }
 EXPORT_SYMBOL(kmalloc_order);
@@ -1192,7 +1192,7 @@ static __always_inline void *__do_kreall
 		ks = ksize(p);
 
 	if (ks >= new_size) {
-		kasan_krealloc((void *)p, new_size);
+		kasan_krealloc((void *)p, new_size, flags);
 		return (void *)p;
 	}
 
diff -puN mm/slub.c~mm-kasan-added-gfp-flags-to-kasan-api mm/slub.c
--- a/mm/slub.c~mm-kasan-added-gfp-flags-to-kasan-api
+++ a/mm/slub.c
@@ -1313,7 +1313,7 @@ static inline void dec_slabs_node(struct
 static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
 {
 	kmemleak_alloc(ptr, size, 1, flags);
-	kasan_kmalloc_large(ptr, size);
+	kasan_kmalloc_large(ptr, size, flags);
 }
 
 static inline void kfree_hook(const void *x)
@@ -2596,7 +2596,7 @@ void *kmem_cache_alloc_trace(struct kmem
 {
 	void *ret = slab_alloc(s, gfpflags, _RET_IP_);
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags);
-	kasan_kmalloc(s, ret, size);
+	kasan_kmalloc(s, ret, size, gfpflags);
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_trace);
@@ -2624,7 +2624,7 @@ void *kmem_cache_alloc_node_trace(struct
 	trace_kmalloc_node(_RET_IP_, ret,
 			   size, s->size, gfpflags, node);
 
-	kasan_kmalloc(s, ret, size);
+	kasan_kmalloc(s, ret, size, gfpflags);
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
@@ -3182,7 +3182,8 @@ static void early_kmem_cache_node_alloc(
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 	init_tracking(kmem_cache_node, n);
 #endif
-	kasan_kmalloc(kmem_cache_node, n, sizeof(struct kmem_cache_node));
+	kasan_kmalloc(kmem_cache_node, n, sizeof(struct kmem_cache_node),
+		      GFP_KERNEL);
 	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
@@ -3561,7 +3562,7 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
-	kasan_kmalloc(s, ret, size);
+	kasan_kmalloc(s, ret, size, flags);
 
 	return ret;
 }
@@ -3606,7 +3607,7 @@ void *__kmalloc_node(size_t size, gfp_t
 
 	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
-	kasan_kmalloc(s, ret, size);
+	kasan_kmalloc(s, ret, size, flags);
 
 	return ret;
 }
@@ -3635,7 +3636,7 @@ size_t ksize(const void *object)
 	size_t size = __ksize(object);
 	/* We assume that ksize callers could use whole allocated area,
 	   so we need unpoison this area. */
-	kasan_krealloc(object, size);
+	kasan_krealloc(object, size, GFP_NOWAIT);
 	return size;
 }
 EXPORT_SYMBOL(ksize);
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch

