Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8353C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B39F207E8
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSM2rc9N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbgKJXF1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKJXF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 18:05:26 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F2CE20679;
        Tue, 10 Nov 2020 23:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049525;
        bh=dqGlctN8DKtUdOa+V0NQV/AITBEdbGlmvx8N7CHxG9E=;
        h=Date:From:To:Subject:From;
        b=rSM2rc9NkH7XcSeU0R4PSDMtahSwoXRjtX8DMdPW9DqLj8tP6XjN+KHXeSYZoD6sC
         +KRnNBa+LloejB0y4jtLeHFIqL9qAzq03ntDIGsHSrkuM/c9ccZjSDzh3RiHHE8G4e
         w4HSiYmDrcaG3U80IU3NxZKxBkDE283fLNQQYaqc=
Date:   Tue, 10 Nov 2020 15:05:24 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch added to -mm
 tree
Message-ID: <20201110230524.EunK_if1j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: unpoison stack only with CONFIG_KASAN_STACK
has been added to the -mm tree.  Its filename is
     kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: unpoison stack only with CONFIG_KASAN_STACK

There's a config option CONFIG_KASAN_STACK that has to be enabled for
KASAN to use stack instrumentation and perform validity checks for
stack variables.

There's no need to unpoison stack when CONFIG_KASAN_STACK is not enabled.
Only call kasan_unpoison_task_stack[_below]() when CONFIG_KASAN_STACK is
enabled.

Note, that CONFIG_KASAN_STACK is an option that is currently always
defined when CONFIG_KASAN is enabled, and therefore has to be tested
with #if instead of #ifdef.

Link: https://lkml.kernel.org/r/7e95d4739f5617b2c1acf52f37e01f1ca83750b5.1605046662.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/If8a891e9fe01ea543e00b576852685afec0887e3
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/sleep.S        |    2 +-
 arch/x86/kernel/acpi/wakeup_64.S |    2 +-
 include/linux/kasan.h            |   10 ++++++----
 mm/kasan/common.c                |    2 ++
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/sleep.S~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/arch/arm64/kernel/sleep.S
@@ -133,7 +133,7 @@ SYM_FUNC_START(_cpu_resume)
 	 */
 	bl	cpu_do_resume
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
 	mov	x0, sp
 	bl	kasan_unpoison_task_stack_below
 #endif
--- a/arch/x86/kernel/acpi/wakeup_64.S~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/arch/x86/kernel/acpi/wakeup_64.S
@@ -112,7 +112,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	movq	pt_regs_r14(%rax), %r14
 	movq	pt_regs_r15(%rax), %r15
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
 	/*
 	 * The suspend path may have poisoned some areas deeper in the stack,
 	 * which we now need to unpoison.
--- a/include/linux/kasan.h~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/include/linux/kasan.h
@@ -76,8 +76,6 @@ static inline void kasan_disable_current
 
 void kasan_unpoison_memory(const void *address, size_t size);
 
-void kasan_unpoison_task_stack(struct task_struct *task);
-
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
 
@@ -122,8 +120,6 @@ void kasan_restore_multi_shot(bool enabl
 
 static inline void kasan_unpoison_memory(const void *address, size_t size) {}
 
-static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
-
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 
@@ -175,6 +171,12 @@ static inline size_t kasan_metadata_size
 
 #endif /* CONFIG_KASAN */
 
+#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+void kasan_unpoison_task_stack(struct task_struct *task);
+#else
+static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
+#endif
+
 #ifdef CONFIG_KASAN_GENERIC
 
 void kasan_cache_shrink(struct kmem_cache *cache);
--- a/mm/kasan/common.c~kasan-arm64-unpoison-stack-only-with-config_kasan_stack
+++ a/mm/kasan/common.c
@@ -59,6 +59,7 @@ void kasan_disable_current(void)
 }
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
+#if CONFIG_KASAN_STACK
 static void __kasan_unpoison_stack(struct task_struct *task, const void *sp)
 {
 	void *base = task_stack_page(task);
@@ -85,6 +86,7 @@ asmlinkage void kasan_unpoison_task_stac
 
 	kasan_unpoison_memory(base, watermark - base);
 }
+#endif /* CONFIG_KASAN_STACK */
 
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
s390-kasan-include-asm-pageh-from-asm-kasanh.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_memory.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_granule_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-kasan_non_canonical_hook-only-for-software-modes.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch
kasan-simplify-quarantine_put-call-site.patch
kasan-rename-get_alloc-free_info.patch
kasan-introduce-set_alloc_info.patch
kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
kasan-allow-vmap_stack-for-hw_tags-mode.patch
kasan-remove-__kasan_unpoison_stack.patch
kasan-inline-kasan_reset_tag-for-tag-based-modes.patch
kasan-inline-random_tag-for-hw_tags.patch
kasan-inline-kasan_poison_memory-and-check_invalid_free.patch
kasan-inline-and-rename-kasan_unpoison_memory.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-simplify-kasan_poison_kfree.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-clean-up-metadata-allocation-and-usage.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch

