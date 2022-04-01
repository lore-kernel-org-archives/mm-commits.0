Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77910C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243518AbiDAA0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbiDAA0s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:26:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E254224CEC8
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 712C96187A
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C791AC340EE;
        Fri,  1 Apr 2022 00:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772698;
        bh=f8dGEOkuxvMyeF3N5qwBaEaSWmx9yPkZExPLxxjaSvQ=;
        h=Date:To:From:Subject:From;
        b=fNojWjhuYL6LeGaWOGp9WxMZr6c5Ay8zeG38B6d92bqRBpEmNott55WFS38U1zeYM
         n/xcaggYkEU7rwDbYZOhAX5LTlPHsAVHPnb9Dt1Fuf/VZkN4d6pJtGJOJw8Sb7ewCG
         5NL2tOUJsR6TcKxLuoY//Q7elmGiq3Kkwzx68xK4=
Date:   Thu, 31 Mar 2022 17:24:58 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sfr@canb.auug.org.au,
        samitolvanen@google.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, fmayer@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-implement-stack_trace_save_shadow.patch removed from -mm tree
Message-Id: <20220401002458.C791AC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: implement stack_trace_save_shadow
has been removed from the -mm tree.  Its filename was
     arm64-implement-stack_trace_save_shadow.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64: implement stack_trace_save_shadow

Implement the stack_trace_save_shadow() interface that collects stack
traces based on the Shadow Call Stack (SCS) for arm64.

The implementation walks through available SCS pointers (the per-task one
and the per-interrupt-type ones) and copies the frames.

Note that the frame of the interrupted function is not included into the
stack trace, as it is not yet saved on the SCS when an interrupt happens.

[akpm@linux-foundation.org: add ifdefs to arch/arm64/kernel/stacktrace.c]
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
 arch/arm64/kernel/stacktrace.c |   85 +++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

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
 
@@ -210,3 +212,86 @@ noinline notrace void arch_stack_walk(st
 
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
+
+#ifdef CONFIG_SHADOW_CALL_STACK
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
+#endif		/* CONFIG_SHADOW_CALL_STACK */
_

Patches currently in -mm which might be from andreyknvl@google.com are

mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch
kasan-use-stack_trace_save_shadow.patch

