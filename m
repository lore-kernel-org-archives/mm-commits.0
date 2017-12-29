From: akpm@linux-foundation.org
Subject: + kasan-detect-invalid-frees.patch added to -mm tree
Date: Thu, 28 Dec 2017 16:06:44 -0800
Message-ID: <5a458714.Cf6FW9kc3XSZ5uZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdL2AGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 19:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: detect invalid frees
has been added to the -mm tree.  Its filename is
     kasan-detect-invalid-frees.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-detect-invalid-frees.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-detect-invalid-frees.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from dvyukov@google.com are

kasan-detect-invalid-frees-for-large-objects.patch
kasan-dont-use-__builtin_return_address1.patch
kasan-detect-invalid-frees-for-large-mempool-objects.patch
kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
kasan-detect-invalid-frees.patch

