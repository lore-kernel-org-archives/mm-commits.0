From: akpm@linux-foundation.org
Subject: [merged] mm-mempool-kasan-poison-mempool-elements.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:53:02 -0700
Message-ID: <552fe8ee.yTI3cip+FvKrCqlA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, catalin.marinas@arm.com, drcheren@gmail.com, dvyukov@google.com, glider@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool.c: kasan: poison mempool elements
has been removed from the -mm tree.  Its filename was
     mm-mempool-kasan-poison-mempool-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm/mempool.c: kasan: poison mempool elements

Mempools keep allocated objects in reserved for situations when ordinary
allocation may not be possible to satisfy.  These objects shouldn't be
accessed before they leave the pool.

This patch poison elements when get into the pool and unpoison when they
leave it.  This will let KASan to detect use-after-free of mempool's
elements.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Chernenkov <drcheren@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    2 ++
 mm/kasan/kasan.c      |   13 +++++++++++++
 mm/mempool.c          |   23 +++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff -puN include/linux/kasan.h~mm-mempool-kasan-poison-mempool-elements include/linux/kasan.h
--- a/include/linux/kasan.h~mm-mempool-kasan-poison-mempool-elements
+++ a/include/linux/kasan.h
@@ -44,6 +44,7 @@ void kasan_poison_object_data(struct kme
 
 void kasan_kmalloc_large(const void *ptr, size_t size);
 void kasan_kfree_large(const void *ptr);
+void kasan_kfree(void *ptr);
 void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size);
 void kasan_krealloc(const void *object, size_t new_size);
 
@@ -71,6 +72,7 @@ static inline void kasan_poison_object_d
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size) {}
 static inline void kasan_kfree_large(const void *ptr) {}
+static inline void kasan_kfree(void *ptr) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size) {}
 static inline void kasan_krealloc(const void *object, size_t new_size) {}
diff -puN mm/kasan/kasan.c~mm-mempool-kasan-poison-mempool-elements mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-mempool-kasan-poison-mempool-elements
+++ a/mm/kasan/kasan.c
@@ -389,6 +389,19 @@ void kasan_krealloc(const void *object,
 		kasan_kmalloc(page->slab_cache, object, size);
 }
 
+void kasan_kfree(void *ptr)
+{
+	struct page *page;
+
+	page = virt_to_head_page(ptr);
+
+	if (unlikely(!PageSlab(page)))
+		kasan_poison_shadow(ptr, PAGE_SIZE << compound_order(page),
+				KASAN_FREE_PAGE);
+	else
+		kasan_slab_free(page->slab_cache, ptr);
+}
+
 void kasan_kfree_large(const void *ptr)
 {
 	struct page *page = virt_to_page(ptr);
diff -puN mm/mempool.c~mm-mempool-kasan-poison-mempool-elements mm/mempool.c
--- a/mm/mempool.c~mm-mempool-kasan-poison-mempool-elements
+++ a/mm/mempool.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/kasan.h>
 #include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
@@ -101,10 +102,31 @@ static inline void poison_element(mempoo
 }
 #endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
 
+static void kasan_poison_element(mempool_t *pool, void *element)
+{
+	if (pool->alloc == mempool_alloc_slab)
+		kasan_slab_free(pool->pool_data, element);
+	if (pool->alloc == mempool_kmalloc)
+		kasan_kfree(element);
+	if (pool->alloc == mempool_alloc_pages)
+		kasan_free_pages(element, (unsigned long)pool->pool_data);
+}
+
+static void kasan_unpoison_element(mempool_t *pool, void *element)
+{
+	if (pool->alloc == mempool_alloc_slab)
+		kasan_slab_alloc(pool->pool_data, element);
+	if (pool->alloc == mempool_kmalloc)
+		kasan_krealloc(element, (size_t)pool->pool_data);
+	if (pool->alloc == mempool_alloc_pages)
+		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
+}
+
 static void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
 	poison_element(pool, element);
+	kasan_poison_element(pool, element);
 	pool->elements[pool->curr_nr++] = element;
 }
 
@@ -114,6 +136,7 @@ static void *remove_element(mempool_t *p
 
 	BUG_ON(pool->curr_nr < 0);
 	check_element(pool, element);
+	kasan_unpoison_element(pool, element);
 	return element;
 }
 
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
kasan-makefile-shut-up-warnings-if-config_compile_test=y.patch
gcov-fix-softlockups.patch
linux-next.patch

