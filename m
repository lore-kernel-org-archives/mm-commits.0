From: akpm@linux-foundation.org
Subject: + mm-mempool-kasan-poison-mempool-elements.patch added to -mm
 tree
Date: Fri, 03 Apr 2015 15:07:23 -0700
Message-ID: <551f0f1b.A9NkENMtV9Aa9VYS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbDCWHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 18:07:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, catalin.marinas@arm.com, drcheren@gmail.com, dvyukov@google.com, glider@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool.c: kasan: poison mempool elements
has been added to the -mm tree.  Its filename is
     mm-mempool-kasan-poison-mempool-elements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-kasan-poison-mempool-elements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-kasan-poison-mempool-elements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Rientjes <rientjes@google.com>
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
@@ -11,6 +11,7 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/kasan.h>
 #include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
@@ -100,10 +101,31 @@ static inline void poison_element(mempoo
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
 
@@ -113,6 +135,7 @@ static void *remove_element(mempool_t *p
 
 	BUG_ON(pool->curr_nr < 0);
 	check_element(pool, element);
+	kasan_unpoison_element(pool, element);
 	return element;
 }
 
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch
mm-mempool-kasan-poison-mempool-elements.patch
gcov-fix-softlockups.patch
linux-next.patch

