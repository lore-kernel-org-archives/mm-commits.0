Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD67762F
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mWX7kCe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DC2C433C7;
	Thu, 21 Dec 2023 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194685;
	bh=JpSDMRlB0ad3fviL5D08JxLevWL0fGdY+HRTh0+vLWo=;
	h=Date:To:From:Subject:From;
	b=mWX7kCe3AeXwmNgdcbHlXHnsiZWLP237jT72uyRKOJfVwiW6OVorE7r/upaGtmDRL
	 FEcY+MyDma65jSDny6xiSq4Txrk25JTQHsHpMG/1frE5Po5j5HgVnqwC2x+QxdSD7c
	 gfFYE1rpJw2SzP3luurnuuTixeS8s1MAsOd76Z5c=
Date: Thu, 21 Dec 2023 13:38:04 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests.patch added to mm-unstable branch
Message-Id: <20231221213805.94DC2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: remove SLUB checks for page_alloc fallbacks in tests
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: remove SLUB checks for page_alloc fallbacks in tests
Date: Thu, 21 Dec 2023 21:04:52 +0100

A number of KASAN tests rely on the fact that calling kmalloc with a size
larger than an order-1 page falls back onto page_alloc.

This fallback was originally only implemented for SLUB, but since commit
d6a71648dbc0 ("mm/slab: kmalloc: pass requests larger than order-1 page to
page allocator"), it is also implemented for SLAB.

Thus, drop the SLUB checks from the tests.

Link: https://lkml.kernel.org/r/c82099b6fb365b6f4c2c21b112d4abb4dfd83e53.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |   26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests
+++ a/mm/kasan/kasan_test.c
@@ -215,7 +215,7 @@ static void kmalloc_node_oob_right(struc
 
 /*
  * Check that KASAN detects an out-of-bounds access for a big object allocated
- * via kmalloc(). But not as big as to trigger the page_alloc fallback for SLUB.
+ * via kmalloc(). But not as big as to trigger the page_alloc fallback.
  */
 static void kmalloc_big_oob_right(struct kunit *test)
 {
@@ -233,8 +233,7 @@ static void kmalloc_big_oob_right(struct
 /*
  * The kmalloc_large_* tests below use kmalloc() to allocate a memory chunk
  * that does not fit into the largest slab cache and therefore is allocated via
- * the page_alloc fallback for SLUB. SLAB has no such fallback, and thus these
- * tests are not supported for it.
+ * the page_alloc fallback.
  */
 
 static void kmalloc_large_oob_right(struct kunit *test)
@@ -242,8 +241,6 @@ static void kmalloc_large_oob_right(stru
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -258,8 +255,6 @@ static void kmalloc_large_uaf(struct kun
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	kfree(ptr);
@@ -272,8 +267,6 @@ static void kmalloc_large_invalid_free(s
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -407,18 +400,12 @@ static void krealloc_less_oob(struct kun
 
 static void krealloc_large_more_oob(struct kunit *test)
 {
-	/* page_alloc fallback is only implemented for SLUB. */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	krealloc_more_oob_helper(test, KMALLOC_MAX_CACHE_SIZE + 201,
 					KMALLOC_MAX_CACHE_SIZE + 235);
 }
 
 static void krealloc_large_less_oob(struct kunit *test)
 {
-	/* page_alloc fallback is only implemented for SLUB. */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	krealloc_less_oob_helper(test, KMALLOC_MAX_CACHE_SIZE + 235,
 					KMALLOC_MAX_CACHE_SIZE + 201);
 }
@@ -1156,9 +1143,6 @@ static void mempool_kmalloc_large_uaf(st
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
 	void *extra_elem;
 
-	/* page_alloc fallback is only implemented for SLUB. */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
 
 	mempool_uaf_helper(test, &pool, false);
@@ -1227,9 +1211,6 @@ static void mempool_kmalloc_large_double
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
 	char *extra_elem;
 
-	/* page_alloc fallback is only implemented for SLUB. */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
 
 	mempool_double_free_helper(test, &pool);
@@ -1284,9 +1265,6 @@ static void mempool_kmalloc_large_invali
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
 	char *extra_elem;
 
-	/* page_alloc fallback is only implemented for SLUB. */
-	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
-
 	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
 
 	mempool_kmalloc_invalid_free_helper(test, &pool);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch
kasan-move-kasan_mempool_poison_object.patch
kasan-document-kasan_mempool_poison_object.patch
kasan-add-return-value-for-kasan_mempool_poison_object.patch
kasan-introduce-kasan_mempool_unpoison_object.patch
kasan-introduce-kasan_mempool_poison_pages.patch
kasan-introduce-kasan_mempool_unpoison_pages.patch
kasan-clean-up-__kasan_mempool_poison_object.patch
kasan-save-free-stack-traces-for-slab-mempools.patch
kasan-clean-up-and-rename-____kasan_kmalloc.patch
kasan-introduce-poison_kmalloc_large_redzone.patch
kasan-save-alloc-stack-traces-for-mempool.patch
mempool-skip-slub_debug-poisoning-when-kasan-is-enabled.patch
mempool-use-new-mempool-kasan-hooks.patch
mempool-introduce-mempool_use_prealloc_only.patch
kasan-add-mempool-tests.patch
kasan-rename-pagealloc-tests.patch
kasan-reorder-tests.patch
kasan-rename-and-document-kasan_unpoison_object_data.patch
skbuff-use-mempool-kasan-hooks.patch
io_uring-use-mempool-kasan-hook.patch
lib-stackdepot-add-printk_deferred_enter-exit-guards.patch
kasan-handle-concurrent-kasan_record_aux_stack-calls.patch
kasan-memset-free-track-in-qlink_free.patch
lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch
kasan-arm64-improve-comments-for-kasan_shadow_start-end.patch
mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch
kasan-improve-kasan_non_canonical_hook.patch
kasan-clean-up-kasan_requires_meta.patch
kasan-update-kasan_poison-documentation-comment.patch
kasan-clean-up-is_kfence_address-checks.patch
kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch
kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch
kasan-export-kasan_poison-as-gpl.patch
kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests.patch
kasan-speed-up-match_all_mem_tag-test-for-sw_tags.patch

