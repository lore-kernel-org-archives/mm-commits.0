Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A43AC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243495AbiDAA0s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243518AbiDAA0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:26:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C33C2414F9
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B96B82294
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BE2C340F0;
        Fri,  1 Apr 2022 00:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772696;
        bh=69FEFF66bZBc/XSDfShRbvj5HqBbT+Hg57vRoQ/C8LQ=;
        h=Date:To:From:Subject:From;
        b=ZEy0bKS+BcEH8pmgvepNpkBiK6Dl6KZ/ovsA97ELZDy84x7Wk0Fwhj7Ziyf0bsKh5
         SGq82GHkHC8kBaJUrLYmafU/7WXBUbbr+7Xc4nWQ7eNT96jx3kng47MR3xhnNJ+vzP
         jiNGm2V+f1kNAyY8AG/IGxBCOTmwMweehk/A4de4=
Date:   Thu, 31 Mar 2022 17:24:55 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sfr@canb.auug.org.au,
        samitolvanen@google.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, fmayer@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] stacktrace-add-interface-based-on-shadow-call-stack.patch removed from -mm tree
Message-Id: <20220401002456.78BE2C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stacktrace: add interface based on shadow call stack
has been removed from the -mm tree.  Its filename was
     stacktrace-add-interface-based-on-shadow-call-stack.patch

This patch was dropped because an updated version will be merged

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
@@ -1035,6 +1035,12 @@ config HAVE_RELIABLE_STACKTRACE
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

mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

