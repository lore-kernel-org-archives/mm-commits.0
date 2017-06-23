From: akpm@linux-foundation.org
Subject: [alternative-merged]
 powerpc-64-initialise-thread_info-for-emergency-stacks.patch removed from
 -mm tree
Date: Fri, 23 Jun 2017 11:49:21 -0700
Message-ID: <20170623184921.2gO7Bm-mE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754549AbdFWStW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 14:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au


The patch titled
     Subject: powerpc/64: initialise thread_info for emergency stacks
has been removed from the -mm tree.  Its filename was
     powerpc-64-initialise-thread_info-for-emergency-stacks.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64: initialise thread_info for emergency stacks

Emergency stacks have their thread_info mostly uninitialised, which in
particular means garbage preempt_count values.

Emergency stack code runs with interrupts disabled entirely, and is used
very rarely, so this has been unnoticed so far.  It was found by a
proposed new powerpc watchdog that takes a soft-NMI directly from the
masked_interrupt handler and using the emergency stack.  That crashed at
BUG_ON(in_nmi()) in nmi_enter().  preempt_count()s were found to be
garbage.

This bug looks to be breaking linux-next on some powerpc boxes due to
interaction with a proposed new powerpc watchdog driver ("powerpc/64s:
implement arch-specific hardlockup watchdog").

Link: http://lkml.kernel.org/r/20170620135801.13272-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/thread_info.h |   19 +++++++++++++++++++
 arch/powerpc/kernel/setup_64.c         |    6 +++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/include/asm/thread_info.h~powerpc-64-initialise-thread_info-for-emergency-stacks arch/powerpc/include/asm/thread_info.h
--- a/arch/powerpc/include/asm/thread_info.h~powerpc-64-initialise-thread_info-for-emergency-stacks
+++ a/arch/powerpc/include/asm/thread_info.h
@@ -54,6 +54,7 @@ struct thread_info {
 	.task =		&tsk,			\
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
+	.local_flags =	0,			\
 	.flags =	0,			\
 }
 
@@ -62,6 +63,24 @@ struct thread_info {
 
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
+/*
+ * Emergency stacks are used for a range of things, from asynchronous
+ * NMIs (system reset, machine check) to synchronous, process context.
+ * Set HARDIRQ_OFFSET because we don't know exactly what context we
+ * come from or if it had a valid stack, which is about the best we
+ * can do.
+ * TODO: what to do with accounting?
+ */
+#define emstack_init_thread_info(ti, c)		\
+do {						\
+	(ti)->task = NULL;			\
+	(ti)->cpu = (c);			\
+	(ti)->preempt_count = HARDIRQ_OFFSET;	\
+	(ti)->local_flags = 0;			\
+	(ti)->flags = 0;			\
+	klp_init_thread_info(ti);		\
+} while (0)
+
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
 {
diff -puN arch/powerpc/kernel/setup_64.c~powerpc-64-initialise-thread_info-for-emergency-stacks arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~powerpc-64-initialise-thread_info-for-emergency-stacks
+++ a/arch/powerpc/kernel/setup_64.c
@@ -639,18 +639,18 @@ void __init emergency_stack_init(void)
 	for_each_possible_cpu(i) {
 		struct thread_info *ti;
 		ti = __va(memblock_alloc_base(THREAD_SIZE, THREAD_SIZE, limit));
-		klp_init_thread_info(ti);
+		emstack_init_thread_info(ti, i);
 		paca[i].emergency_sp = (void *)ti + THREAD_SIZE;
 
 #ifdef CONFIG_PPC_BOOK3S_64
 		/* emergency stack for NMI exception handling. */
 		ti = __va(memblock_alloc_base(THREAD_SIZE, THREAD_SIZE, limit));
-		klp_init_thread_info(ti);
+		emstack_init_thread_info(ti, i);
 		paca[i].nmi_emergency_sp = (void *)ti + THREAD_SIZE;
 
 		/* emergency stack for machine check exception handling. */
 		ti = __va(memblock_alloc_base(THREAD_SIZE, THREAD_SIZE, limit));
-		klp_init_thread_info(ti);
+		emstack_init_thread_info(ti, i);
 		paca[i].mc_emergency_sp = (void *)ti + THREAD_SIZE;
 #endif
 	}
_

Patches currently in -mm which might be from npiggin@gmail.com are

watchdog-remove-unused-declaration.patch
watchdog-introduce-arch_touch_nmi_watchdog.patch
watchdog-split-up-config-options.patch
watchdog-split-up-config-options-fix.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-fix.patch

