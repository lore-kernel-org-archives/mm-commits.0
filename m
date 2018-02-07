From: akpm@linux-foundation.org
Subject: [merged]
 kasan-detect-invalid-frees-for-large-mempool-objects.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 11:55:28 -0800
Message-ID: <20180207195528.KOgQxd1cr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754087AbeBGTz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: detect invalid frees for large mempool objects
has been removed from the -mm tree.  Its filename was
     kasan-detect-invalid-frees-for-large-mempool-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: detect invalid frees for large mempool objects

Detect frees of pointers into middle of mempool objects.

I did a one-off test, but it turned out to be very tricky, so I reverted
it.  First, mempool does not call kasan_poison_kfree() unless allocation
function fails.  I stubbed an allocation function to fail on second and
subsequent allocations.  But then mempool stopped to call
kasan_poison_kfree() at all, because it does it only when allocation
function is mempool_kmalloc().  We could support this special failing test
allocation function in mempool, but it also can't live with kasan tests,
because these are in a module.

Link: http://lkml.kernel.org/r/bf7a7d035d7a5ed62d2dd0e3d2e8a4fcdf456aa7.1514378558.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    4 ++--
 mm/kasan/kasan.c      |   11 ++++++++---
 mm/mempool.c          |    6 +++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff -puN include/linux/kasan.h~kasan-detect-invalid-frees-for-large-mempool-objects include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-detect-invalid-frees-for-large-mempool-objects
+++ a/include/linux/kasan.h
@@ -57,7 +57,7 @@ void kasan_init_slab_obj(struct kmem_cac
 
 void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
 void kasan_kfree_large(void *ptr, unsigned long ip);
-void kasan_poison_kfree(void *ptr);
+void kasan_poison_kfree(void *ptr, unsigned long ip);
 void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size,
 		  gfp_t flags);
 void kasan_krealloc(const void *object, size_t new_size, gfp_t flags);
@@ -109,7 +109,7 @@ static inline void kasan_init_slab_obj(s
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
 static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
-static inline void kasan_poison_kfree(void *ptr) {}
+static inline void kasan_poison_kfree(void *ptr, unsigned long ip) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size, gfp_t flags) {}
 static inline void kasan_krealloc(const void *object, size_t new_size,
diff -puN mm/kasan/kasan.c~kasan-detect-invalid-frees-for-large-mempool-objects mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-detect-invalid-frees-for-large-mempool-objects
+++ a/mm/kasan/kasan.c
@@ -588,17 +588,22 @@ void kasan_krealloc(const void *object,
 		kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
-void kasan_poison_kfree(void *ptr)
+void kasan_poison_kfree(void *ptr, unsigned long ip)
 {
 	struct page *page;
 
 	page = virt_to_head_page(ptr);
 
-	if (unlikely(!PageSlab(page)))
+	if (unlikely(!PageSlab(page))) {
+		if (ptr != page_address(page)) {
+			kasan_report_invalid_free(ptr, ip);
+			return;
+		}
 		kasan_poison_shadow(ptr, PAGE_SIZE << compound_order(page),
 				KASAN_FREE_PAGE);
-	else
+	} else {
 		kasan_poison_slab_free(page->slab_cache, ptr);
+	}
 }
 
 void kasan_kfree_large(void *ptr, unsigned long ip)
diff -puN mm/mempool.c~kasan-detect-invalid-frees-for-large-mempool-objects mm/mempool.c
--- a/mm/mempool.c~kasan-detect-invalid-frees-for-large-mempool-objects
+++ a/mm/mempool.c
@@ -103,10 +103,10 @@ static inline void poison_element(mempoo
 }
 #endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
 
-static void kasan_poison_element(mempool_t *pool, void *element)
+static __always_inline void kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_poison_kfree(element);
+		kasan_poison_kfree(element, _RET_IP_);
 	if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
@@ -119,7 +119,7 @@ static void kasan_unpoison_element(mempo
 		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
 }
 
-static void add_element(mempool_t *pool, void *element)
+static __always_inline void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
 	poison_element(pool, element);
_

Patches currently in -mm which might be from dvyukov@google.com are


