Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF07FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiCYUpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbiCYUpv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5322FFE9
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 13:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE2BA61D40
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD87C004DD;
        Fri, 25 Mar 2022 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648241055;
        bh=tJKpz3rjtGn4XmWxjkZaHwtmgTYyLePykHe9Gqy7HPE=;
        h=Date:To:From:Subject:From;
        b=Rs2BFJJa7sGju2WAnk4Tz8YkZ00px9Up5/5POEq8hd5jF+0lKUBAg2WdGfaoUGM/J
         +ckzOxQ6lmS1G60OnsoZNigN2PEAbznamqBtUuvypbt9gIGLt9NBrR/r+kMIiYAOr9
         tpQxXJmj2I7gFNSolOwqz2C2D8nec/+QCH5PYOK4=
Date:   Fri, 25 Mar 2022 13:44:14 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, samitolvanen@google.com,
        ryabinin.a.a@gmail.com, pcc@google.com, mark.rutland@arm.com,
        glider@google.com, fmayer@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-implement-stack_trace_save_shadow.patch added to -mm tree
Message-Id: <20220325204415.4FD87C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: implement stack_trace_save_shadow
has been added to the -mm tree.  Its filename is
     arm64-implement-stack_trace_save_shadow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-implement-stack_trace_save_shadow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-implement-stack_trace_save_shadow.patch

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
Subject: arm64: implement stack_trace_save_shadow

Implement the stack_trace_save_shadow() interface that collects stack
traces based on the Shadow Call Stack (SCS) for arm64.

The implementation walks through available SCS pointers (the per-task one
and the per-interrupt-type ones) and copies the frames.

Note that the frame of the interrupted function is not included into the
stack trace, as it is not yet saved on the SCS when an interrupt happens.

Link: https://lkml.kernel.org/r/0bb72ea8fa88ef9ae3508c23d993952a0ae6f0f9.1648049113.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Florian Mayer <fmayer@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig             |    1 
 arch/arm64/kernel/stacktrace.c |   83 +++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

--- a/arch/arm64/Kconfig~arm64-implement-stack_trace_save_shadow
+++ a/arch/arm64/Kconfig
@@ -200,6 +200,7 @@ config ARM64
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select MMU_GATHER_RCU_TABLE_FREE
 	select HAVE_RSEQ
+	select HAVE_SHADOW_STACKTRACE
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
--- a/arch/arm64/kernel/stacktrace.c~arm64-implement-stack_trace_save_shadow
+++ a/arch/arm64/kernel/stacktrace.c
@@ -12,9 +12,11 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
+#include <linux/scs.h>
 
 #include <asm/irq.h>
 #include <asm/pointer_auth.h>
+#include <asm/scs.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
@@ -210,3 +212,84 @@ noinline notrace void arch_stack_walk(st
 
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
+
+static const struct {
+	unsigned long ** __percpu saved;
+	unsigned long ** __percpu base;
+} scs_parts[] = {
+#ifdef CONFIG_ARM_SDE_INTERFACE
+	{
+		.saved = &sdei_shadow_call_stack_critical_saved_ptr,
+		.base = &sdei_shadow_call_stack_critical_ptr,
+	},
+	{
+		.saved = &sdei_shadow_call_stack_normal_saved_ptr,
+		.base = &sdei_shadow_call_stack_normal_ptr,
+	},
+#endif /* CONFIG_ARM_SDE_INTERFACE */
+	{
+		.saved = &irq_shadow_call_stack_saved_ptr,
+		.base = &irq_shadow_call_stack_ptr,
+	},
+};
+
+static inline bool walk_shadow_stack_part(
+				unsigned long *scs_top, unsigned long *scs_base,
+				unsigned long *store, unsigned int size,
+				unsigned int *skipnr, unsigned int *len)
+{
+	unsigned long *frame;
+
+	for (frame = scs_top; frame >= scs_base; frame--) {
+		if (*skipnr > 0) {
+			(*skipnr)--;
+			continue;
+		}
+		/*
+		 * Do not leak PTR_AUTH tags in stack traces.
+		 * Use READ_ONCE_NOCHECK as SCS is poisoned with Generic KASAN.
+		 */
+		store[(*len)++] =
+			ptrauth_strip_insn_pac(READ_ONCE_NOCHECK(*frame));
+		if (*len >= size)
+			return true;
+	}
+
+	return false;
+}
+
+noinline notrace int arch_stack_walk_shadow(unsigned long *store,
+					    unsigned int size,
+					    unsigned int skipnr)
+{
+	unsigned long *scs_top, *scs_base, *scs_next;
+	unsigned int len = 0, part;
+
+	preempt_disable();
+
+	/* Get the SCS pointer. */
+	asm volatile("mov %0, x18" : "=&r" (scs_top));
+
+	/* The top SCS slot is empty. */
+	scs_top -= 1;
+
+	/* Handle SDEI and hardirq frames. */
+	for (part = 0; part < ARRAY_SIZE(scs_parts); part++) {
+		scs_next = *this_cpu_ptr(scs_parts[part].saved);
+		if (scs_next) {
+			scs_base = *this_cpu_ptr(scs_parts[part].base);
+			if (walk_shadow_stack_part(scs_top, scs_base, store,
+						   size, &skipnr, &len))
+				goto out;
+			scs_top = scs_next;
+		}
+	}
+
+	/* Handle task and softirq frames. */
+	scs_base = task_scs(current);
+	walk_shadow_stack_part(scs_top, scs_base, store, size, &skipnr, &len);
+
+out:
+	preempt_enable();
+	return len;
+}
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

