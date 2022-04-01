Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E16C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243523AbiDAA0s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243495AbiDAA0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C3623FF00
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5853C61881
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E0CC340EE;
        Fri,  1 Apr 2022 00:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772697;
        bh=WQhFvWf7TpXPXsGCFDmnIf4y/nw/9Re+ReCH1D4sVfg=;
        h=Date:To:From:Subject:From;
        b=ejhlPK8uR6DvzZgIqKaS0VFyc56oRF3Mlo/eUKE9h1k+NFITwYu+UW1TWk4WtFgXZ
         u1WHzsku9fxGXVUhA0/JGJQdjwgOrypGkLya5HfQ0/QhuBjDh11DeOCeDmMcJVRBVz
         Zd4ixQhTDsZBWmsnFGhH/DzmKGM1kiDcP5+Z82qU=
Date:   Thu, 31 Mar 2022 17:24:57 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sfr@canb.auug.org.au,
        samitolvanen@google.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, fmayer@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch removed from -mm tree
Message-Id: <20220401002457.A7E0CC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64, scs: save scs_sp values per-cpu when switching stacks
has been removed from the -mm tree.  Its filename was
     arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch

This patch was dropped because an updated version will be merged

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

Also expose both the added saved SCS variables and the existing SCS base
variables in arch/arm64/include/asm/scs.h so that the stack trace
collection impementation can use them.

[sfr@canb.auug.org.au: arch/arm64/kernel/irq.c needs asm/scs.h]
  Link: https://lkml.kernel.org/r/20220331141858.46b4df12@canb.auug.org.au
Link: https://lkml.kernel.org/r/f75c58b17bfaa419f84286cd174e3a08f971b779.1648049113.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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
 arch/arm64/kernel/irq.c            |    5 +---
 arch/arm64/kernel/sdei.c           |    5 +---
 5 files changed, 52 insertions(+), 11 deletions(-)

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
@@ -22,17 +22,16 @@
 #include <linux/vmalloc.h>
 #include <asm/daifflags.h>
 #include <asm/vmap_stack.h>
+#include <asm/scs.h>
 
 /* Only access this in an NMI enter/exit */
 DEFINE_PER_CPU(struct nmi_ctx, nmi_contexts);
 
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

mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

