From: akpm@linux-foundation.org
Subject: [patch 011/114] kasan: detect invalid frees
Date: Tue, 06 Feb 2018 15:36:37 -0800
Message-ID: <20180206233637.f1v7qVJTb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754138AbeBFXgj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: detect invalid frees

Detect frees of pointers into middle of heap objects.

Link: http://lkml.kernel.org/r/cb569193190356beb018a03bb8d6fbae67e7adbc.1514378558.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.c |    6 +++++
 2 files changed, 56 insertions(+)

diff -puN lib/test_kasan.c~kasan-detect-invalid-frees lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-detect-invalid-frees
+++ a/lib/test_kasan.c
@@ -523,6 +523,54 @@ static noinline void __init kasan_alloca
 	*(volatile char *)p;
 }
 
+static noinline void __init kmem_cache_double_free(void)
+{
+	char *p;
+	size_t size = 200;
+	struct kmem_cache *cache;
+
+	cache = kmem_cache_create("test_cache", size, 0, 0, NULL);
+	if (!cache) {
+		pr_err("Cache allocation failed\n");
+		return;
+	}
+	pr_info("double-free on heap object\n");
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		pr_err("Allocation failed\n");
+		kmem_cache_destroy(cache);
+		return;
+	}
+
+	kmem_cache_free(cache, p);
+	kmem_cache_free(cache, p);
+	kmem_cache_destroy(cache);
+}
+
+static noinline void __init kmem_cache_invalid_free(void)
+{
+	char *p;
+	size_t size = 200;
+	struct kmem_cache *cache;
+
+	cache = kmem_cache_create("test_cache", size, 0, SLAB_TYPESAFE_BY_RCU,
+				  NULL);
+	if (!cache) {
+		pr_err("Cache allocation failed\n");
+		return;
+	}
+	pr_info("invalid-free of heap object\n");
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		pr_err("Allocation failed\n");
+		kmem_cache_destroy(cache);
+		return;
+	}
+
+	kmem_cache_free(cache, p + 1);
+	kmem_cache_destroy(cache);
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	/*
@@ -560,6 +608,8 @@ static int __init kmalloc_tests_init(voi
 	ksize_unpoisons_memory();
 	copy_user_test();
 	use_after_scope_test();
+	kmem_cache_double_free();
+	kmem_cache_invalid_free();
 
 	kasan_restore_multi_shot(multishot);
 
diff -puN mm/kasan/kasan.c~kasan-detect-invalid-frees mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-detect-invalid-frees
+++ a/mm/kasan/kasan.c
@@ -495,6 +495,12 @@ static bool __kasan_slab_free(struct kme
 	s8 shadow_byte;
 	unsigned long rounded_up_size;
 
+	if (unlikely(nearest_obj(cache, virt_to_head_page(object), object) !=
+	    object)) {
+		kasan_report_invalid_free(object, ip);
+		return true;
+	}
+
 	/* RCU slabs could be legally used after free within the RCU period */
 	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
 		return false;
_
