Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35813C6FA89
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiIEWtO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiIEWsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5587F67C80
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C4160ECE
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440B9C433D7;
        Mon,  5 Sep 2022 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418131;
        bh=a3g+lXMdFK1qq8ZFQpcNxrFg0da/pHZR5Vj3BFC8bx0=;
        h=Date:To:From:Subject:From;
        b=If5s33zQZENvg6/A9kSl0wHl4ym3k4p2HzY4xQxMy7blsxJqg6Y5Ps0TtiC9M2hFJ
         i36mclAu9qzE1KqMJ789C++4yjBiWHpulD+L2PdC62urdSbM/VWMCCFMBRjD2sQZo8
         Uu2BQzmNL7QOhtRy7h3MiiHTZV4F1xUH8Hsn5u6w=
Date:   Mon, 05 Sep 2022 15:48:50 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-support-kasanstacktrace-for-sw_tags.patch added to mm-unstable branch
Message-Id: <20220905224851.440B9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: support kasan.stacktrace for SW_TAGS
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-support-kasanstacktrace-for-sw_tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-support-kasanstacktrace-for-sw_tags.patch

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
Subject: kasan: support kasan.stacktrace for SW_TAGS
Date: Mon, 5 Sep 2022 23:05:46 +0200

Add support for the kasan.stacktrace command-line argument for Software
Tag-Based KASAN.

The following patch adds a command-line argument for selecting the stack
ring size, and, as the stack ring is supported by both the Software and
the Hardware Tag-Based KASAN modes, it is natural that both of them have
support for kasan.stacktrace too.

Link: https://lkml.kernel.org/r/3b43059103faa7f8796017847b7d674b658f11b5.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   15 +++++----
 mm/kasan/hw_tags.c                |   39 -------------------------
 mm/kasan/kasan.h                  |   36 +++++++++++++++--------
 mm/kasan/sw_tags.c                |    5 ++-
 mm/kasan/tags.c                   |   43 ++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 57 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-support-kasanstacktrace-for-sw_tags
+++ a/Documentation/dev-tools/kasan.rst
@@ -111,9 +111,15 @@ parameter can be used to control panic a
   report or also panic the kernel (default: ``report``). The panic happens even
   if ``kasan_multi_shot`` is enabled.
 
-Hardware Tag-Based KASAN mode (see the section about various modes below) is
-intended for use in production as a security mitigation. Therefore, it supports
-additional boot parameters that allow disabling KASAN or controlling features:
+Software and Hardware Tag-Based KASAN modes (see the section about various
+modes below) support disabling stack trace collection:
+
+- ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
+  traces collection (default: ``on``).
+
+Hardware Tag-Based KASAN mode is intended for use in production as a security
+mitigation. Therefore, it supports additional boot parameters that allow
+disabling KASAN altogether or controlling its features:
 
 - ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
@@ -132,9 +138,6 @@ additional boot parameters that allow di
 - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
   allocations (default: ``on``).
 
-- ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
-  traces collection (default: ``on``).
-
 Error reports
 ~~~~~~~~~~~~~
 
--- a/mm/kasan/hw_tags.c~kasan-support-kasanstacktrace-for-sw_tags
+++ a/mm/kasan/hw_tags.c
@@ -38,16 +38,9 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
-enum kasan_arg_stacktrace {
-	KASAN_ARG_STACKTRACE_DEFAULT,
-	KASAN_ARG_STACKTRACE_OFF,
-	KASAN_ARG_STACKTRACE_ON,
-};
-
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
-static enum kasan_arg_stacktrace kasan_arg_stacktrace __initdata;
 
 /*
  * Whether KASAN is enabled at all.
@@ -66,9 +59,6 @@ EXPORT_SYMBOL_GPL(kasan_mode);
 /* Whether to enable vmalloc tagging. */
 DEFINE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
 
-/* Whether to collect alloc/free stack traces. */
-DEFINE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
-
 /* kasan=off/on */
 static int __init early_kasan_flag(char *arg)
 {
@@ -122,23 +112,6 @@ static int __init early_kasan_flag_vmall
 }
 early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
 
-/* kasan.stacktrace=off/on */
-static int __init early_kasan_flag_stacktrace(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcmp(arg, "off"))
-		kasan_arg_stacktrace = KASAN_ARG_STACKTRACE_OFF;
-	else if (!strcmp(arg, "on"))
-		kasan_arg_stacktrace = KASAN_ARG_STACKTRACE_ON;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-early_param("kasan.stacktrace", early_kasan_flag_stacktrace);
-
 static inline const char *kasan_mode_info(void)
 {
 	if (kasan_mode == KASAN_MODE_ASYNC)
@@ -213,17 +186,7 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
-	switch (kasan_arg_stacktrace) {
-	case KASAN_ARG_STACKTRACE_DEFAULT:
-		/* Default is specified by kasan_flag_stacktrace definition. */
-		break;
-	case KASAN_ARG_STACKTRACE_OFF:
-		static_branch_disable(&kasan_flag_stacktrace);
-		break;
-	case KASAN_ARG_STACKTRACE_ON:
-		static_branch_enable(&kasan_flag_stacktrace);
-		break;
-	}
+	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
 	static_branch_enable(&kasan_flag_enabled);
--- a/mm/kasan/kasan.h~kasan-support-kasanstacktrace-for-sw_tags
+++ a/mm/kasan/kasan.h
@@ -8,13 +8,31 @@
 #include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
-#ifdef CONFIG_KASAN_HW_TAGS
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 #include <linux/static_key.h>
+
+DECLARE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
+
+static inline bool kasan_stack_collection_enabled(void)
+{
+	return static_branch_unlikely(&kasan_flag_stacktrace);
+}
+
+#else /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
+
+static inline bool kasan_stack_collection_enabled(void)
+{
+	return true;
+}
+
+#endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
+
+#ifdef CONFIG_KASAN_HW_TAGS
+
 #include "../slab.h"
 
 DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
-DECLARE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
 
 enum kasan_mode {
 	KASAN_MODE_SYNC,
@@ -29,11 +47,6 @@ static inline bool kasan_vmalloc_enabled
 	return static_branch_likely(&kasan_flag_vmalloc);
 }
 
-static inline bool kasan_stack_collection_enabled(void)
-{
-	return static_branch_unlikely(&kasan_flag_stacktrace);
-}
-
 static inline bool kasan_async_fault_possible(void)
 {
 	return kasan_mode == KASAN_MODE_ASYNC || kasan_mode == KASAN_MODE_ASYMM;
@@ -46,11 +59,6 @@ static inline bool kasan_sync_fault_poss
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-static inline bool kasan_stack_collection_enabled(void)
-{
-	return true;
-}
-
 static inline bool kasan_async_fault_possible(void)
 {
 	return false;
@@ -410,6 +418,10 @@ static inline void kasan_enable_tagging(
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+void __init kasan_init_tags(void);
+#endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
+
 #if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_force_async_fault(void);
--- a/mm/kasan/sw_tags.c~kasan-support-kasanstacktrace-for-sw_tags
+++ a/mm/kasan/sw_tags.c
@@ -42,7 +42,10 @@ void __init kasan_init_sw_tags(void)
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
-	pr_info("KernelAddressSanitizer initialized (sw-tags)\n");
+	kasan_init_tags();
+
+	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
+		kasan_stack_collection_enabled() ? "on" : "off");
 }
 
 /*
--- a/mm/kasan/tags.c~kasan-support-kasanstacktrace-for-sw_tags
+++ a/mm/kasan/tags.c
@@ -19,11 +19,54 @@
 #include "kasan.h"
 #include "../slab.h"
 
+enum kasan_arg_stacktrace {
+	KASAN_ARG_STACKTRACE_DEFAULT,
+	KASAN_ARG_STACKTRACE_OFF,
+	KASAN_ARG_STACKTRACE_ON,
+};
+
+static enum kasan_arg_stacktrace kasan_arg_stacktrace __initdata;
+
+/* Whether to collect alloc/free stack traces. */
+DEFINE_STATIC_KEY_TRUE(kasan_flag_stacktrace);
+
 /* Non-zero, as initial pointer values are 0. */
 #define STACK_RING_BUSY_PTR ((void *)1)
 
 struct kasan_stack_ring stack_ring;
 
+/* kasan.stacktrace=off/on */
+static int __init early_kasan_flag_stacktrace(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_stacktrace = KASAN_ARG_STACKTRACE_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_stacktrace = KASAN_ARG_STACKTRACE_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.stacktrace", early_kasan_flag_stacktrace);
+
+void __init kasan_init_tags(void)
+{
+	switch (kasan_arg_stacktrace) {
+	case KASAN_ARG_STACKTRACE_DEFAULT:
+		/* Default is specified by kasan_flag_stacktrace definition. */
+		break;
+	case KASAN_ARG_STACKTRACE_OFF:
+		static_branch_disable(&kasan_flag_stacktrace);
+		break;
+	case KASAN_ARG_STACKTRACE_ON:
+		static_branch_enable(&kasan_flag_stacktrace);
+		break;
+	}
+}
+
 static void save_stack_info(struct kmem_cache *cache, void *object,
 			gfp_t gfp_flags, bool is_free)
 {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch

