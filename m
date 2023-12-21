Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E276DD8
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZuTkWmlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144CEC433C9;
	Thu, 21 Dec 2023 21:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194683;
	bh=yVnTPlSJRd7TJ26I3SM14vjnEJKnsYFiDI4D8nnmX0A=;
	h=Date:To:From:Subject:From;
	b=ZuTkWmlT5kEJ5Tdavcx2FD1rFXJpHKQrruEQVgmo3ouGvNwaMSQOC8ksEQ4OMYzJH
	 LR1+yxPOlQr3hv7I1Dc9KYXK7yqR/fV1bc39ERb1+j/gG7CV3LIZEXgzqLT3kFzwnV
	 TDA/VisZWuqbTcgaqBfD5HsbQlL546y+1LD+wX9U=
Date: Thu, 21 Dec 2023 13:38:01 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch added to mm-unstable branch
Message-Id: <20231221213803.144CEC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: check kasan_vmalloc_enabled in vmalloc tests
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch

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
Subject: kasan: check kasan_vmalloc_enabled in vmalloc tests
Date: Thu, 21 Dec 2023 21:04:50 +0100

Check that vmalloc poisoning is not disabled via command line when running
the vmalloc-related KASAN tests.  Skip the tests otherwise.

Link: https://lkml.kernel.org/r/954456e50ac98519910c3e24a479a18eae62f8dd.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c    |    1 +
 mm/kasan/kasan.h      |    5 +++++
 mm/kasan/kasan_test.c |   11 ++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

--- a/mm/kasan/hw_tags.c~kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests
+++ a/mm/kasan/hw_tags.c
@@ -62,6 +62,7 @@ DEFINE_STATIC_KEY_TRUE(kasan_flag_vmallo
 #else
 DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
 #endif
+EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
--- a/mm/kasan/kasan.h~kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests
+++ a/mm/kasan/kasan.h
@@ -83,6 +83,11 @@ static inline bool kasan_sample_page_all
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
+static inline bool kasan_vmalloc_enabled(void)
+{
+	return IS_ENABLED(CONFIG_KASAN_VMALLOC);
+}
+
 static inline bool kasan_async_fault_possible(void)
 {
 	return false;
--- a/mm/kasan/kasan_test.c~kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests
+++ a/mm/kasan/kasan_test.c
@@ -1552,6 +1552,9 @@ static void vmalloc_helpers_tags(struct
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=on");
+
 	ptr = vmalloc(PAGE_SIZE);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -1586,6 +1589,9 @@ static void vmalloc_oob(struct kunit *te
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=on");
+
 	v_ptr = vmalloc(size);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
@@ -1639,6 +1645,9 @@ static void vmap_tags(struct kunit *test
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=on");
+
 	p_page = alloc_pages(GFP_KERNEL, 1);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_page);
 	p_ptr = page_address(p_page);
@@ -1757,7 +1766,7 @@ static void match_all_not_assigned(struc
 		free_pages((unsigned long)ptr, order);
 	}
 
-	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (!kasan_vmalloc_enabled())
 		return;
 
 	for (i = 0; i < 256; i++) {
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

