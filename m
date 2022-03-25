Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B72C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiCYUpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiCYUpq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:45:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA57E377EF
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 13:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64DE561D49
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC13C004DD;
        Fri, 25 Mar 2022 20:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648241049;
        bh=ZVfaHUD3qqhqZ02qewoXeL8Awh6zgQkA18HjReoSNRg=;
        h=Date:To:From:Subject:From;
        b=NKWDMWJtmaWniyzpjDoGLtFhmaVB/aF2aCNT8WDHGURsawx3WKnE2Z3yOGHHkWJc/
         fZelNyyk0hBcM2Oq6hOeGqD9nov5Ym3rxmhuqRkhONA8q83CMFXEGV1qPJc1Cj3MKM
         PYhWgpH+tzVf1Pxf7PNy69+qXvqY34Adr0XykEmc=
Date:   Fri, 25 Mar 2022 13:44:08 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, samitolvanen@google.com,
        ryabinin.a.a@gmail.com, pcc@google.com, mark.rutland@arm.com,
        glider@google.com, fmayer@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + stacktrace-add-interface-based-on-shadow-call-stack.patch added to -mm tree
Message-Id: <20220325204409.9DC13C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stacktrace: add interface based on shadow call stack
has been added to the -mm tree.  Its filename is
     stacktrace-add-interface-based-on-shadow-call-stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stacktrace-add-interface-based-on-shadow-call-stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stacktrace-add-interface-based-on-shadow-call-stack.patch

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
Subject: stacktrace: add interface based on shadow call stack

Patch series "kasan, arm64, scs, stacktrace: collect stack traces from Shadow Call Stack", v2.

Currently, KASAN always uses the normal stack trace collection routines,
which rely on the unwinder, when saving alloc and free stack traces.

Instead of invoking the unwinder, collect the stack trace by copying
frames from the Shadow Call Stack whenever it is enabled.  This reduces
boot time by 30% for all KASAN modes when Shadow Call Stack is enabled.

Stack staces are collected from the Shadow Call Stack via a new
stack_trace_save_shadow() interface.

Note that the frame of the interrupted function is not included into the
stack trace, as it is not yet saved on the SCS when an interrupt happens.


This patch (of 4):

Add a new interface stack_trace_save_shadow() for collecting stack traces
by copying frames from the Shadow Call Stack.

Collecting stack traces this way is significantly faster: boot time of a
defconfig build with KASAN enabled gets descreased by ~30%.

The few patches following this one add an implementation of
stack_trace_save_shadow() for arm64.

The implementation of the added interface is not meant to use
stack_trace_consume_fn to avoid making a function call for each collected
frame to further improve performance.

Link: https://lkml.kernel.org/r/cover.1648049113.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/21e3e20ea58e242e3c82c19abbfe65b579e0e4b8.1648049113.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Florian Mayer <fmayer@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig               |    6 ++++++
 include/linux/stacktrace.h |   15 +++++++++++++++
 kernel/stacktrace.c        |   21 +++++++++++++++++++++
 3 files changed, 42 insertions(+)

--- a/arch/Kconfig~stacktrace-add-interface-based-on-shadow-call-stack
+++ a/arch/Kconfig
@@ -1036,6 +1036,12 @@ config HAVE_RELIABLE_STACKTRACE
 	  arch_stack_walk_reliable() function which only returns a stack trace
 	  if it can guarantee the trace is reliable.
 
+config HAVE_SHADOW_STACKTRACE
+	bool
+	help
+	  If this is set, the architecture provides the arch_stack_walk_shadow()
+	  function, which collects the stack trace from the shadow call stack.
+
 config HAVE_ARCH_HASH
 	bool
 	default n
--- a/include/linux/stacktrace.h~stacktrace-add-interface-based-on-shadow-call-stack
+++ a/include/linux/stacktrace.h
@@ -60,6 +60,9 @@ int arch_stack_walk_reliable(stack_trace
 
 void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 			  const struct pt_regs *regs);
+
+int arch_stack_walk_shadow(unsigned long *store, unsigned int size,
+			   unsigned int skipnr);
 #endif /* CONFIG_ARCH_STACKWALK */
 
 #ifdef CONFIG_STACKTRACE
@@ -106,6 +109,18 @@ static inline int stack_trace_save_tsk_r
 {
 	return -ENOSYS;
 }
+#endif
+
+#if defined(CONFIG_STACKTRACE) && defined(CONFIG_HAVE_SHADOW_STACKTRACE)
+int stack_trace_save_shadow(unsigned long *store, unsigned int size,
+			    unsigned int skipnr);
+#else
+static inline int stack_trace_save_shadow(unsigned long *store,
+					  unsigned int size,
+					  unsigned int skipnr)
+{
+	return -ENOSYS;
+}
 #endif
 
 #endif /* __LINUX_STACKTRACE_H */
--- a/kernel/stacktrace.c~stacktrace-add-interface-based-on-shadow-call-stack
+++ a/kernel/stacktrace.c
@@ -237,6 +237,27 @@ unsigned int stack_trace_save_user(unsig
 }
 #endif
 
+#ifdef CONFIG_HAVE_SHADOW_STACKTRACE
+/**
+ * stack_trace_save_shadow - Save a stack trace based on shadow call stack
+ * @store:	Pointer to the storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ *
+ * Return: Number of trace entries stored.
+ */
+int stack_trace_save_shadow(unsigned long *store, unsigned int size,
+			    unsigned int skipnr)
+{
+	/*
+	 * Do not use stack_trace_consume_fn to avoid making a function
+	 * call for each collected frame to improve performance.
+	 * Skip + 1 frame to skip stack_trace_save_shadow.
+	 */
+	return arch_stack_walk_shadow(store, size, skipnr + 1);
+}
+#endif
+
 #else /* CONFIG_ARCH_STACKWALK */
 
 /*
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
kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch
kasan-print-virtual-mapping-info-in-reports.patch
kasan-drop-addr-check-from-describe_object_addr.patch
kasan-more-line-breaks-in-reports.patch
kasan-rearrange-stack-frame-info-in-reports.patch
kasan-improve-stack-frame-info-in-reports.patch
kasan-print-basic-stack-frame-info-for-sw_tags.patch
kasan-simplify-async-check-in-end_report.patch
kasan-simplify-kasan_update_kunit_status-and-call-sites.patch
kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch
kasan-move-update_kunit_status-to-start_report.patch
kasan-move-disable_trace_on_warning-to-start_report.patch
kasan-split-out-print_report-from-__kasan_report.patch
kasan-simplify-kasan_find_first_bad_addr-call-sites.patch
kasan-restructure-kasan_report.patch
kasan-merge-__kasan_report-into-kasan_report.patch
kasan-call-print_report-from-kasan_report_invalid_free.patch
kasan-move-and-simplify-kasan_report_async.patch
kasan-rename-kasan_access_info-to-kasan_report_info.patch
kasan-add-comment-about-uaccess-regions-to-kasan_report.patch
kasan-respect-kasan_bit_reported-in-all-reporting-routines.patch
kasan-reorder-reporting-functions.patch
kasan-move-and-hide-kasan_save_enable-restore_multi_shot.patch
kasan-disable-lockdep-when-printing-reports.patch
stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

