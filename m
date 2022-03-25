Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4359BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiCYUpw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiCYUpt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:45:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC1832061
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 13:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F099861D40
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55760C004DD;
        Fri, 25 Mar 2022 20:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648241052;
        bh=zmmCtgE9suKNrf+Ce+locR/ECx8QAJZJHL9QDBJvqbM=;
        h=Date:To:From:Subject:From;
        b=wt7ShDJKj+8DcrAV0ynbz6q6Afg1bM/XkiHPfvkfEO79kn1EMidF+S9GZyg85cR7S
         IZgDnkrvDl8gPFmOoWdBWIw6ACfL4loi6MlM8iA8G3oz0ktrzuyl3igwyPBx8pF4dF
         hMd1dvytQ8v0BcYhZFaEOPU/4vIECdYNwspm98Qo=
Date:   Fri, 25 Mar 2022 13:44:11 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, samitolvanen@google.com,
        ryabinin.a.a@gmail.com, pcc@google.com, mark.rutland@arm.com,
        glider@google.com, fmayer@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch added to -mm tree
Message-Id: <20220325204412.55760C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64, scs: save scs_sp values per-cpu when switching stacks
has been added to the -mm tree.  Its filename is
     arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch

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
Subject: arm64, scs: save scs_sp values per-cpu when switching stacks

When an interrupt happens, the current Shadow Call Stack (SCS) pointer is
switched to a per-interrupt one stored in a per-CPU variable.  The old
pointer is then saved on the normal stack and restored when the interrupt
is handled.

To collect the current stack trace based on SCS when the interrupt is
being handled, we need to know the SCS pointers that belonged to the task
and potentially other interrupts that were interrupted.

Instead of trying to retrieve the SCS pointers from the stack, change
interrupt handlers (for hard IRQ, Normal and Critical SDEI) to save the
previous SCS pointer in a per-CPU variable.

Note that interrupts stack.  A task can be interrupted by a hard IRQ,
which then can interrupted by a normal SDEI, etc.  This is handled by
using a separate per-CPU variable for each interrupt type.

Also reset the saved SCS pointer when exiting the interrupt.  This allows
checking whether we should include any interrupt frames when collecting
the stack trace.  While we could use in_hardirq(), there seems to be no
easy way to check whether we are in an SDEI handler.  Directly checking
the per-CPU variables for being non-zero is more resilient.

Also expose both the the added saved SCS variables and the existing SCS
base variables in arch/arm64/include/asm/scs.h so that the stack trace
collection impementation can use them.

Link: https://lkml.kernel.org/r/f75c58b17bfaa419f84286cd174e3a08f971b779.1648049113.git.andreyknvl@google.com
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

 arch/arm64/include/asm/assembler.h |   12 +++++++++++
 arch/arm64/include/asm/scs.h       |   13 +++++++++++-
 arch/arm64/kernel/entry.S          |   28 +++++++++++++++++++++++----
 arch/arm64/kernel/irq.c            |    4 ---
 arch/arm64/kernel/sdei.c           |    5 +---
 5 files changed, 51 insertions(+), 11 deletions(-)

--- a/arch/arm64/include/asm/assembler.h~arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks
+++ a/arch/arm64/include/asm/assembler.h
@@ -270,6 +270,18 @@ alternative_endif
 	ldr	\dst, [\dst, \tmp]
 	.endm
 
+	/*
+	 * @src: Register whose value gets stored in sym
+	 * @sym: The name of the per-cpu variable
+	 * @tmp0: Scratch register
+	 * @tmp1: Another scratch register
+	 */
+	.macro str_this_cpu src, sym, tmp0, tmp1
+	adr_l	\tmp0, \sym
+	get_this_cpu_offset \tmp1
+	str	\src, [\tmp0, \tmp1]
+	.endm
+
 /*
  * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
  */
--- a/arch/arm64/include/asm/scs.h~arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks
+++ a/arch/arm64/include/asm/scs.h
@@ -24,6 +24,17 @@
 	.endm
 #endif /* CONFIG_SHADOW_CALL_STACK */
 
-#endif /* __ASSEMBLY __ */
+#else /* __ASSEMBLY__ */
+
+#include <linux/percpu.h>
+
+DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
+DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_saved_ptr);
+DECLARE_PER_CPU(unsigned long *, sdei_shadow_call_stack_normal_ptr);
+DECLARE_PER_CPU(unsigned long *, sdei_shadow_call_stack_normal_saved_ptr);
+DECLARE_PER_CPU(unsigned long *, sdei_shadow_call_stack_critical_ptr);
+DECLARE_PER_CPU(unsigned long *, sdei_shadow_call_stack_critical_saved_ptr);
+
+#endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_SCS_H */
--- a/arch/arm64/kernel/entry.S~arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks
+++ a/arch/arm64/kernel/entry.S
@@ -880,7 +880,8 @@ NOKPROBE(ret_from_fork)
  */
 SYM_FUNC_START(call_on_irq_stack)
 #ifdef CONFIG_SHADOW_CALL_STACK
-	stp	scs_sp, xzr, [sp, #-16]!
+	/* Save the current SCS pointer and load the per-IRQ one. */
+	str_this_cpu scs_sp, irq_shadow_call_stack_saved_ptr, x15, x17
 	ldr_this_cpu scs_sp, irq_shadow_call_stack_ptr, x17
 #endif
 	/* Create a frame record to save our LR and SP (implicit in FP) */
@@ -902,7 +903,9 @@ SYM_FUNC_START(call_on_irq_stack)
 	mov	sp, x29
 	ldp	x29, x30, [sp], #16
 #ifdef CONFIG_SHADOW_CALL_STACK
-	ldp	scs_sp, xzr, [sp], #16
+	/* Restore saved SCS pointer and reset the saved value. */
+	ldr_this_cpu scs_sp, irq_shadow_call_stack_saved_ptr, x17
+	str_this_cpu xzr, irq_shadow_call_stack_saved_ptr, x15, x17
 #endif
 	ret
 SYM_FUNC_END(call_on_irq_stack)
@@ -1024,11 +1027,16 @@ SYM_CODE_START(__sdei_asm_handler)
 #endif
 
 #ifdef CONFIG_SHADOW_CALL_STACK
-	/* Use a separate shadow call stack for normal and critical events */
+	/*
+	 * Use a separate shadow call stack for normal and critical events.
+	 * Save the current SCS pointer and load the per-SDEI one.
+	 */
 	cbnz	w4, 3f
+	str_this_cpu src=scs_sp, sym=sdei_shadow_call_stack_normal_saved_ptr, tmp0=x5, tmp1=x6
 	ldr_this_cpu dst=scs_sp, sym=sdei_shadow_call_stack_normal_ptr, tmp=x6
 	b	4f
-3:	ldr_this_cpu dst=scs_sp, sym=sdei_shadow_call_stack_critical_ptr, tmp=x6
+3:	str_this_cpu src=scs_sp, sym=sdei_shadow_call_stack_critical_saved_ptr, tmp0=x5, tmp1=x6
+	ldr_this_cpu dst=scs_sp, sym=sdei_shadow_call_stack_critical_ptr, tmp=x6
 4:
 #endif
 
@@ -1062,6 +1070,18 @@ SYM_CODE_START(__sdei_asm_handler)
 	ldp	lr, x1, [x4, #SDEI_EVENT_INTREGS + S_LR]
 	mov	sp, x1
 
+#ifdef CONFIG_SHADOW_CALL_STACK
+	/* Restore saved SCS pointer and reset the saved value. */
+	ldrb	w5, [x4, #SDEI_EVENT_PRIORITY]
+	cbnz	w5, 5f
+	ldr_this_cpu dst=scs_sp, sym=sdei_shadow_call_stack_normal_saved_ptr, tmp=x6
+	str_this_cpu src=xzr, sym=sdei_shadow_call_stack_normal_saved_ptr, tmp0=x5, tmp1=x6
+	b	6f
+5:	ldr_this_cpu dst=scs_sp, sym=sdei_shadow_call_stack_critical_saved_ptr, tmp=x6
+	str_this_cpu src=xzr, sym=sdei_shadow_call_stack_critical_saved_ptr, tmp0=x5, tmp1=x6
+6:
+#endif
+
 	mov	x1, x0			// address to complete_and_resume
 	/* x0 = (x0 <= SDEI_EV_FAILED) ?
 	 * EVENT_COMPLETE:EVENT_COMPLETE_AND_RESUME
--- a/arch/arm64/kernel/irq.c~arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks
+++ a/arch/arm64/kernel/irq.c
@@ -28,11 +28,9 @@ DEFINE_PER_CPU(struct nmi_ctx, nmi_conte
 
 DEFINE_PER_CPU(unsigned long *, irq_stack_ptr);
 
-
-DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
-
 #ifdef CONFIG_SHADOW_CALL_STACK
 DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
+DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_saved_ptr);
 #endif
 
 static void init_irq_scs(void)
--- a/arch/arm64/kernel/sdei.c~arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks
+++ a/arch/arm64/kernel/sdei.c
@@ -39,12 +39,11 @@ DEFINE_PER_CPU(unsigned long *, sdei_sta
 DEFINE_PER_CPU(unsigned long *, sdei_stack_critical_ptr);
 #endif
 
-DECLARE_PER_CPU(unsigned long *, sdei_shadow_call_stack_normal_ptr);
-DECLARE_PER_CPU(unsigned long *, sdei_shadow_call_stack_critical_ptr);
-
 #ifdef CONFIG_SHADOW_CALL_STACK
 DEFINE_PER_CPU(unsigned long *, sdei_shadow_call_stack_normal_ptr);
+DEFINE_PER_CPU(unsigned long *, sdei_shadow_call_stack_normal_saved_ptr);
 DEFINE_PER_CPU(unsigned long *, sdei_shadow_call_stack_critical_ptr);
+DEFINE_PER_CPU(unsigned long *, sdei_shadow_call_stack_critical_saved_ptr);
 #endif
 
 static void _free_sdei_stack(unsigned long * __percpu *ptr, int cpu)
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

