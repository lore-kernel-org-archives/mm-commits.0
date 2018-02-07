From: akpm@linux-foundation.org
Subject: [merged]
 kasan-detect-invalid-frees-for-large-objects.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:55:22 -0800
Message-ID: <20180207195522.7-GnuhX0p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754320AbeBGTzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: detect invalid frees for large objects
has been removed from the -mm tree.  Its filename was
     kasan-detect-invalid-frees-for-large-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: detect invalid frees for large objects

Patch series "kasan: detect invalid frees".

KASAN detects double-frees, but does not detect invalid-frees (when a
pointer into a middle of heap object is passed to free).  We recently had
a very unpleasant case in crypto code which freed an inner object inside
of a heap allocation.  This left unnoticed during free, but totally
corrupted heap and later lead to a bunch of random crashes all over kernel
code.

Detect invalid frees.


This patch (of 5):

Detect frees of pointers into middle of large heap objects.

I dropped const from kasan_kfree_large() because it starts propagating
through a bunch of functions in kasan_report.c, slab/slub nearest_obj(),
all of their local variables, fixup_red_left(), etc.

Link: http://lkml.kernel.org/r/1b45b4fe1d20fc0de1329aab674c1dd973fee723.1514378558.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    4 ++--
 lib/test_kasan.c      |   33 +++++++++++++++++++++++++++++++++
 mm/kasan/kasan.c      |   12 +++++-------
 mm/kasan/kasan.h      |    3 +--
 mm/kasan/report.c     |    3 +--
 mm/slub.c             |    4 ++--
 6 files changed, 44 insertions(+), 15 deletions(-)

diff -puN include/linux/kasan.h~kasan-detect-invalid-frees-for-large-objects include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-detect-invalid-frees-for-large-objects
+++ a/include/linux/kasan.h
@@ -56,7 +56,7 @@ void kasan_poison_object_data(struct kme
 void kasan_init_slab_obj(struct kmem_cache *cache, const void *object);
 
 void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
-void kasan_kfree_large(const void *ptr);
+void kasan_kfree_large(void *ptr);
 void kasan_poison_kfree(void *ptr);
 void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size,
 		  gfp_t flags);
@@ -108,7 +108,7 @@ static inline void kasan_init_slab_obj(s
 				const void *object) {}
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
-static inline void kasan_kfree_large(const void *ptr) {}
+static inline void kasan_kfree_large(void *ptr) {}
 static inline void kasan_poison_kfree(void *ptr) {}
 static inline void kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size, gfp_t flags) {}
diff -puN lib/test_kasan.c~kasan-detect-invalid-frees-for-large-objects lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-detect-invalid-frees-for-large-objects
+++ a/lib/test_kasan.c
@@ -94,6 +94,37 @@ static noinline void __init kmalloc_page
 	ptr[size] = 0;
 	kfree(ptr);
 }
+
+static noinline void __init kmalloc_pagealloc_uaf(void)
+{
+	char *ptr;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
+
+	pr_info("kmalloc pagealloc allocation: use-after-free\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	kfree(ptr);
+	ptr[0] = 0;
+}
+
+static noinline void __init kmalloc_pagealloc_invalid_free(void)
+{
+	char *ptr;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
+
+	pr_info("kmalloc pagealloc allocation: invalid-free\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	kfree(ptr + 1);
+}
 #endif
 
 static noinline void __init kmalloc_large_oob_right(void)
@@ -505,6 +536,8 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_node_oob_right();
 #ifdef CONFIG_SLUB
 	kmalloc_pagealloc_oob_right();
+	kmalloc_pagealloc_uaf();
+	kmalloc_pagealloc_invalid_free();
 #endif
 	kmalloc_large_oob_right();
 	kmalloc_oob_krealloc_more();
diff -puN mm/kasan/kasan.c~kasan-detect-invalid-frees-for-large-objects mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-detect-invalid-frees-for-large-objects
+++ a/mm/kasan/kasan.c
@@ -511,8 +511,7 @@ bool kasan_slab_free(struct kmem_cache *
 
 	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(object));
 	if (shadow_byte < 0 || shadow_byte >= KASAN_SHADOW_SCALE_SIZE) {
-		kasan_report_double_free(cache, object,
-				__builtin_return_address(1));
+		kasan_report_invalid_free(object, __builtin_return_address(1));
 		return true;
 	}
 
@@ -602,12 +601,11 @@ void kasan_poison_kfree(void *ptr)
 		kasan_poison_slab_free(page->slab_cache, ptr);
 }
 
-void kasan_kfree_large(const void *ptr)
+void kasan_kfree_large(void *ptr)
 {
-	struct page *page = virt_to_page(ptr);
-
-	kasan_poison_shadow(ptr, PAGE_SIZE << compound_order(page),
-			KASAN_FREE_PAGE);
+	if (ptr != page_address(virt_to_head_page(ptr)))
+		kasan_report_invalid_free(ptr, __builtin_return_address(1));
+	/* The object will be poisoned by page_alloc. */
 }
 
 int kasan_module_alloc(void *addr, size_t size)
diff -puN mm/kasan/kasan.h~kasan-detect-invalid-frees-for-large-objects mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-detect-invalid-frees-for-large-objects
+++ a/mm/kasan/kasan.h
@@ -107,8 +107,7 @@ static inline const void *kasan_shadow_t
 
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
-void kasan_report_double_free(struct kmem_cache *cache, void *object,
-					void *ip);
+void kasan_report_invalid_free(void *object, void *ip);
 
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
diff -puN mm/kasan/report.c~kasan-detect-invalid-frees-for-large-objects mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-detect-invalid-frees-for-large-objects
+++ a/mm/kasan/report.c
@@ -326,8 +326,7 @@ static void print_shadow_for_address(con
 	}
 }
 
-void kasan_report_double_free(struct kmem_cache *cache, void *object,
-				void *ip)
+void kasan_report_invalid_free(void *object, void *ip)
 {
 	unsigned long flags;
 
diff -puN mm/slub.c~kasan-detect-invalid-frees-for-large-objects mm/slub.c
--- a/mm/slub.c~kasan-detect-invalid-frees-for-large-objects
+++ a/mm/slub.c
@@ -1356,7 +1356,7 @@ static inline void kmalloc_large_node_ho
 	kasan_kmalloc_large(ptr, size, flags);
 }
 
-static inline void kfree_hook(const void *x)
+static inline void kfree_hook(void *x)
 {
 	kmemleak_free(x);
 	kasan_kfree_large(x);
@@ -3910,7 +3910,7 @@ void kfree(const void *x)
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
-		kfree_hook(x);
+		kfree_hook(object);
 		__free_pages(page, compound_order(page));
 		return;
 	}
_

Patches currently in -mm which might be from dvyukov@google.com are


