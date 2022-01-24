Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880CAC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386959AbiAYDqG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415136AbiAYA53 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B890C07596C
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 14:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35B6B81255
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1854DC340E4;
        Mon, 24 Jan 2022 22:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064201;
        bh=TRedIbpwrdi5tJqUhLNgN0PMQ5/breTXcAf8bVOk8aE=;
        h=Date:From:To:Subject:From;
        b=QXhs1OiiUG5i8scXr+9jgvFYcO1G3S/dVeSMPR4Zsc1tLkyURE9Q/SGj/TzYkjH56
         GIDch+68EGv8H3vjAJZkFhN1A5Qbw1EgkLrWkAeAZCrd+VeNBFvCk7e/8k7KBR2CAl
         xwxngTuuA9i3GnYdrkfOziSepPy6MgsVbtmdRu8c=
Date:   Mon, 24 Jan 2022 14:43:20 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  + kasan-clean-up-feature-flags-for-hw_tags-mode.patch
 added to -mm tree
Message-ID: <20220124224320.n0TyJC_3H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clean up feature flags for HW_TAGS mode
has been added to the -mm tree.  Its filename is
     kasan-clean-up-feature-flags-for-hw_tags-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-clean-up-feature-flags-for-hw_tags-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-clean-up-feature-flags-for-hw_tags-mode.patch

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
Subject: kasan: clean up feature flags for HW_TAGS mode

- Untie kasan_init_hw_tags() code from the default values of
  kasan_arg_mode and kasan_arg_stacktrace.

- Move static_branch_enable(&kasan_flag_enabled) to the end of
  kasan_init_hw_tags_cpu().

- Remove excessive comments in kasan_arg_mode switch.

- Add new comments.

Link: https://lkml.kernel.org/r/76ebb340265be57a218564a497e1f52ff36a3879.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |   38 +++++++++++++++++++++-----------------
 mm/kasan/kasan.h   |    2 +-
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-clean-up-feature-flags-for-hw_tags-mode
+++ a/mm/kasan/hw_tags.c
@@ -42,16 +42,22 @@ static enum kasan_arg kasan_arg __ro_aft
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_stacktrace kasan_arg_stacktrace __initdata;
 
-/* Whether KASAN is enabled at all. */
+/*
+ * Whether KASAN is enabled at all.
+ * The value remains false until KASAN is initialized by kasan_init_hw_tags().
+ */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
 EXPORT_SYMBOL(kasan_flag_enabled);
 
-/* Whether the selected mode is synchronous/asynchronous/asymmetric.*/
+/*
+ * Whether the selected mode is synchronous, asynchronous, or asymmetric.
+ * Defaults to KASAN_MODE_SYNC.
+ */
 enum kasan_mode kasan_mode __ro_after_init;
 EXPORT_SYMBOL_GPL(kasan_mode);
 
 /* Whether to collect alloc/free stack traces. */
-DEFINE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
+DEFINE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
 /* kasan=off/on */
 static int __init early_kasan_flag(char *arg)
@@ -127,7 +133,11 @@ void kasan_init_hw_tags_cpu(void)
 	 * as this function is only called for MTE-capable hardware.
 	 */
 
-	/* If KASAN is disabled via command line, don't initialize it. */
+	/*
+	 * If KASAN is disabled via command line, don't initialize it.
+	 * When this function is called, kasan_flag_enabled is not yet
+	 * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
+	 */
 	if (kasan_arg == KASAN_ARG_OFF)
 		return;
 
@@ -154,42 +164,36 @@ void __init kasan_init_hw_tags(void)
 	if (kasan_arg == KASAN_ARG_OFF)
 		return;
 
-	/* Enable KASAN. */
-	static_branch_enable(&kasan_flag_enabled);
-
 	switch (kasan_arg_mode) {
 	case KASAN_ARG_MODE_DEFAULT:
-		/*
-		 * Default to sync mode.
-		 */
-		fallthrough;
+		/* Default is specified by kasan_mode definition. */
+		break;
 	case KASAN_ARG_MODE_SYNC:
-		/* Sync mode enabled. */
 		kasan_mode = KASAN_MODE_SYNC;
 		break;
 	case KASAN_ARG_MODE_ASYNC:
-		/* Async mode enabled. */
 		kasan_mode = KASAN_MODE_ASYNC;
 		break;
 	case KASAN_ARG_MODE_ASYMM:
-		/* Asymm mode enabled. */
 		kasan_mode = KASAN_MODE_ASYMM;
 		break;
 	}
 
 	switch (kasan_arg_stacktrace) {
 	case KASAN_ARG_STACKTRACE_DEFAULT:
-		/* Default to enabling stack trace collection. */
-		static_branch_enable(&kasan_flag_stacktrace);
+		/* Default is specified by kasan_flag_stacktrace definition. */
 		break;
 	case KASAN_ARG_STACKTRACE_OFF:
-		/* Do nothing, kasan_flag_stacktrace keeps its default value. */
+		static_branch_disable(&kasan_flag_stacktrace);
 		break;
 	case KASAN_ARG_STACKTRACE_ON:
 		static_branch_enable(&kasan_flag_stacktrace);
 		break;
 	}
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, stacktrace=%s)\n",
 		kasan_mode_info(),
 		kasan_stack_collection_enabled() ? "on" : "off");
--- a/mm/kasan/kasan.h~kasan-clean-up-feature-flags-for-hw_tags-mode
+++ a/mm/kasan/kasan.h
@@ -12,7 +12,7 @@
 #include <linux/static_key.h>
 #include "../slab.h"
 
-DECLARE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
+DECLARE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
 enum kasan_mode {
 	KASAN_MODE_SYNC,
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch
kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages.patch
kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare.patch
kasan-page_alloc-simplify-kasan_poison_pages-call-site.patch
kasan-page_alloc-init-memory-of-skipped-pages-on-free.patch
kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch
mm-clarify-__gfp_zerotags-comment.patch
kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed.patch
kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch
kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook.patch
kasan-page_alloc-combine-tag_clear_highpage-calls-in-post_alloc_hook.patch
kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook.patch
kasan-page_alloc-move-kernel_init_free_pages-in-post_alloc_hook.patch
kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch
kasan-clean-up-metadata-byte-definitions.patch
kasan-define-kasan_vmalloc_invalid-for-sw_tags.patch
kasan-x86-arm64-s390-rename-functions-for-modules-shadow.patch
kasan-vmalloc-drop-outdated-vm_kasan-comment.patch
kasan-reorder-vmalloc-hooks.patch
kasan-add-wrappers-for-vmalloc-hooks.patch
kasan-vmalloc-reset-tags-in-vmalloc-functions.patch
kasan-fork-reset-pointer-tags-of-vmapped-stacks.patch
kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch
kasan-vmalloc-add-vmalloc-tagging-for-sw_tags.patch
kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch
kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch
kasan-mm-only-define-___gfp_skip_kasan_poison-with-hw_tags.patch
kasan-page_alloc-allow-skipping-unpoisoning-for-hw_tags.patch
kasan-page_alloc-allow-skipping-memory-init-for-hw_tags.patch
kasan-vmalloc-add-vmalloc-tagging-for-hw_tags.patch
kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch
kasan-arm64-dont-tag-executable-vmalloc-allocations.patch
kasan-mark-kasan_arg_stacktrace-as-__initdata.patch
kasan-clean-up-feature-flags-for-hw_tags-mode.patch
kasan-add-kasanvmalloc-command-line-flag.patch
kasan-allow-enabling-kasan_vmalloc-and-sw-hw_tags.patch
arm64-select-kasan_vmalloc-for-sw-hw_tags-modes.patch
kasan-documentation-updates.patch
kasan-improve-vmalloc-tests.patch

