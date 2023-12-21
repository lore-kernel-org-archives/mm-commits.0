Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7585376DDD
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B135xEb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB639C433C7;
	Thu, 21 Dec 2023 21:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194681;
	bh=qzgf2Bae/lP6tSyN+osifDUCiY/r6UawT696+RUyMSc=;
	h=Date:To:From:Subject:From;
	b=B135xEb4WE4Im2oezsmihonOvSr6RMFLfOqo+hmLLFcZniomtcZdCJy2y723FmH0o
	 99fWmuaW0Qcu7Fw9lJp6RG3s/GxLLHT1okGkLZ4YcBaN0ziSgeDV3fEmgRJS0XJCWU
	 epn8TlqbQqgx375Q8scqqskvd/+1njkS8bky9Z88=
Date: Thu, 21 Dec 2023 13:38:00 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch added to mm-unstable branch
Message-Id: <20231221213801.DB639C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: respect CONFIG_KASAN_VMALLOC for kasan_flag_vmalloc
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch

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
Subject: kasan: respect CONFIG_KASAN_VMALLOC for kasan_flag_vmalloc
Date: Thu, 21 Dec 2023 21:04:49 +0100

Never enable the kasan_flag_vmalloc static branch unless
CONFIG_KASAN_VMALLOC is enabled.

This does not fix any observable bugs (vmalloc annotations for the HW_TAGS
mode are no-op with CONFIG_KASAN_VMALLOC disabled) but rather just cleans
up the code.

Link: https://lkml.kernel.org/r/3e5c933c8f6b59bd587efb05c407964be951772c.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    7 +++++++
 mm/kasan/kasan.h   |    1 +
 2 files changed, 8 insertions(+)

--- a/mm/kasan/hw_tags.c~kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc
+++ a/mm/kasan/hw_tags.c
@@ -57,7 +57,11 @@ enum kasan_mode kasan_mode __ro_after_in
 EXPORT_SYMBOL_GPL(kasan_mode);
 
 /* Whether to enable vmalloc tagging. */
+#ifdef CONFIG_KASAN_VMALLOC
 DEFINE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
+#else
+DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
+#endif
 
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
@@ -119,6 +123,9 @@ static int __init early_kasan_flag_vmall
 	if (!arg)
 		return -EINVAL;
 
+	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC))
+		return 0;
+
 	if (!strcmp(arg, "off"))
 		kasan_arg_vmalloc = KASAN_ARG_VMALLOC_OFF;
 	else if (!strcmp(arg, "on"))
--- a/mm/kasan/kasan.h~kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc
+++ a/mm/kasan/kasan.h
@@ -49,6 +49,7 @@ DECLARE_PER_CPU(long, kasan_page_alloc_s
 
 static inline bool kasan_vmalloc_enabled(void)
 {
+	/* Static branch is never enabled with CONFIG_KASAN_VMALLOC disabled. */
 	return static_branch_likely(&kasan_flag_vmalloc);
 }
 
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

