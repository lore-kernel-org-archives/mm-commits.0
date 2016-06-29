From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine.patch removed from -mm tree
Date: Tue, 28 Jun 2016 19:02:30 -0700
Message-ID: <57732c36./dh3Hh9L4Jkgovqm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbcF2CK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, kcc@google.com, kuthonuzo.luruo@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempool: kasan: don't poot mempool objects in quarantine
has been removed from the -mm tree.  Its filename was
     mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: mempool: kasan: don't poot mempool objects in quarantine

Currently we may put reserved by mempool elements into quarantine via
kasan_kfree().  This is totally wrong since quarantine may really free
these objects.  So when mempool will try to use such element,
use-after-free will happen.  Or mempool may decide that it no longer need
that element and double-free it.

So don't put object into quarantine in kasan_kfree(), just poison it. 
Rename kasan_kfree() to kasan_poison_kfree() to respect that.

Also, we shouldn't use kasan_slab_alloc()/kasan_krealloc() in
kasan_unpoison_element() because those functions may update allocation
stacktrace.  This would be wrong for the most of the remove_element call
sites.

(The only call site where we may want to update alloc stacktrace is
 in mempool_alloc(). Kmemleak solves this by calling
 kmemleak_update_trace(), so we could make something like that too.
 But this is out of scope of this patch).

Fixes: 55834c59098d ("mm: kasan: initial memory quarantine implementation")
Link: http://lkml.kernel.org/r/575977C3.1010905@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Kuthonuzo Luruo <kuthonuzo.luruo@hpe.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   11 +++++++----
 mm/kasan/kasan.c      |    6 +++---
 mm/mempool.c          |   12 ++++--------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff -puN include/linux/kasan.h~mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine include/linux/kasan.h
--- a/include/linux/kasan.h~mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine
+++ a/include/linux/kasan.h
@@ -59,14 +59,13 @@ void kasan_poison_object_data(struct kme
 
 void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
 void kasan_kfree_large(const void *ptr);
-void kasan_kfree(void *ptr);
+void kasan_poison_kfree(void *ptr);
 void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size,
 		  gfp_t flags);
 void kasan_krealloc(const void *object, size_t new_size, gfp_t flags);
 
 void kasan_slab_alloc(struct kmem_cache *s, void *object, gfp_t flags);
 bool kasan_slab_free(struct kmem_cache *s, void *object);
-void kasan_poison_slab_free(struct kmem_cache *s, void *object);
 
 struct kasan_cache {
 	int alloc_meta_offset;
@@ -76,6 +75,9 @@ struct kasan_cache {
 int kasan_module_alloc(void *addr, size_t size);
 void kasan_free_shadow(const struct vm_struct *vm);
 
+size_t ksize(const void *);
+static inline void kasan_unpoison_slab(const void *ptr) { ksize(ptr); }
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -102,7 +104,7 @@ static inline void kasan_poison_object_d
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
 static inline void kasan_kfree_large(const void *ptr) {}
-static inline void kasan_kfree(void *ptr) {}
+static inline void kasan_poison_kfree(void *ptr) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size, gfp_t flags) {}
 static inline void kasan_krealloc(const void *object, size_t new_size,
@@ -114,11 +116,12 @@ static inline bool kasan_slab_free(struc
 {
 	return false;
 }
-static inline void kasan_poison_slab_free(struct kmem_cache *s, void *object) {}
 
 static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
 static inline void kasan_free_shadow(const struct vm_struct *vm) {}
 
+static inline void kasan_unpoison_slab(const void *ptr) { }
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff -puN mm/kasan/kasan.c~mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine
+++ a/mm/kasan/kasan.c
@@ -508,7 +508,7 @@ void kasan_slab_alloc(struct kmem_cache
 	kasan_kmalloc(cache, object, cache->object_size, flags);
 }
 
-void kasan_poison_slab_free(struct kmem_cache *cache, void *object)
+static void kasan_poison_slab_free(struct kmem_cache *cache, void *object)
 {
 	unsigned long size = cache->object_size;
 	unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
@@ -626,7 +626,7 @@ void kasan_krealloc(const void *object,
 		kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
-void kasan_kfree(void *ptr)
+void kasan_poison_kfree(void *ptr)
 {
 	struct page *page;
 
@@ -636,7 +636,7 @@ void kasan_kfree(void *ptr)
 		kasan_poison_shadow(ptr, PAGE_SIZE << compound_order(page),
 				KASAN_FREE_PAGE);
 	else
-		kasan_slab_free(page->slab_cache, ptr);
+		kasan_poison_slab_free(page->slab_cache, ptr);
 }
 
 void kasan_kfree_large(const void *ptr)
diff -puN mm/mempool.c~mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine mm/mempool.c
--- a/mm/mempool.c~mm-mempool-kasan-dont-poot-mempool-objects-in-quarantine
+++ a/mm/mempool.c
@@ -104,20 +104,16 @@ static inline void poison_element(mempoo
 
 static void kasan_poison_element(mempool_t *pool, void *element)
 {
-	if (pool->alloc == mempool_alloc_slab)
-		kasan_poison_slab_free(pool->pool_data, element);
-	if (pool->alloc == mempool_kmalloc)
-		kasan_kfree(element);
+	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+		kasan_poison_kfree(element);
 	if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
 
 static void kasan_unpoison_element(mempool_t *pool, void *element, gfp_t flags)
 {
-	if (pool->alloc == mempool_alloc_slab)
-		kasan_slab_alloc(pool->pool_data, element, flags);
-	if (pool->alloc == mempool_kmalloc)
-		kasan_krealloc(element, (size_t)pool->pool_data, flags);
+	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+		kasan_unpoison_slab(element);
 	if (pool->alloc == mempool_alloc_pages)
 		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
 }
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


