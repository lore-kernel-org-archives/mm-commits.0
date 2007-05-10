From: akpm@linux-foundation.org
Subject: + powerpc-fixup-hard_irq_disable-semantics.patch added to -mm tree
Date: Wed, 09 May 2007 22:43:07 -0700
Message-ID: <200705100543.l4A5h7gc013246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbXEJFnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au


The patch titled
     powerpc: fixup hard_irq_disable semantics
has been added to the -mm tree.  Its filename is
     powerpc-fixup-hard_irq_disable-semantics.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: fixup hard_irq_disable semantics
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch renames the raw hard_irq_{enable,disable} into
__hard_irq_{enable,disable} and introduces a higher level hard_irq_disable()
function that can be used by any code to enforce that IRQs are fully disabled,
not only lazy disabled.

The difference with the __ versions is that it will update some per-processor
fields so that the kernel keeps track and properly re-enables them in the next
local_irq_disable();

This prepares powerpc for my next patch that introduces hard_irq_disable()
generically.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/irq.c               |    2 +-
 arch/powerpc/kernel/swsusp.c            |    4 ----
 arch/powerpc/platforms/cell/pervasive.c |    6 ++----
 include/asm-powerpc/hw_irq.h            |   11 +++++++++--
 4 files changed, 12 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/kernel/irq.c~powerpc-fixup-hard_irq_disable-semantics arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~powerpc-fixup-hard_irq_disable-semantics
+++ a/arch/powerpc/kernel/irq.c
@@ -173,7 +173,7 @@ void local_irq_restore(unsigned long en)
 		lv1_get_version_info(&tmp);
 	}
 
-	hard_irq_enable();
+	__hard_irq_enable();
 }
 #endif /* CONFIG_PPC64 */
 
diff -puN arch/powerpc/kernel/swsusp.c~powerpc-fixup-hard_irq_disable-semantics arch/powerpc/kernel/swsusp.c
--- a/arch/powerpc/kernel/swsusp.c~powerpc-fixup-hard_irq_disable-semantics
+++ a/arch/powerpc/kernel/swsusp.c
@@ -36,8 +36,4 @@ void restore_processor_state(void)
 #ifdef CONFIG_PPC32
 	set_context(current->active_mm->context.id, current->active_mm->pgd);
 #endif
-
-#ifdef CONFIG_PPC64
-	hard_irq_enable();
-#endif
 }
diff -puN arch/powerpc/platforms/cell/pervasive.c~powerpc-fixup-hard_irq_disable-semantics arch/powerpc/platforms/cell/pervasive.c
--- a/arch/powerpc/platforms/cell/pervasive.c~powerpc-fixup-hard_irq_disable-semantics
+++ a/arch/powerpc/platforms/cell/pervasive.c
@@ -43,12 +43,10 @@ static void cbe_power_save(void)
 	unsigned long ctrl, thread_switch_control;
 
 	/*
-	 * We need to hard disable interrupts, but we also need to mark them
-	 * hard disabled in the PACA so that the local_irq_enable() done by
-	 * our caller upon return propertly hard enables.
+	 * We need to hard disable interrupts, the local_irq_enable() done by
+	 * our caller upon return will hard re-enable.
 	 */
 	hard_irq_disable();
-	get_paca()->hard_enabled = 0;
 
 	ctrl = mfspr(SPRN_CTRLF);
 
diff -puN include/asm-powerpc/hw_irq.h~powerpc-fixup-hard_irq_disable-semantics include/asm-powerpc/hw_irq.h
--- a/include/asm-powerpc/hw_irq.h~powerpc-fixup-hard_irq_disable-semantics
+++ a/include/asm-powerpc/hw_irq.h
@@ -48,8 +48,15 @@ extern void iseries_handle_interrupts(vo
 
 #define irqs_disabled()		(local_get_flags() == 0)
 
-#define hard_irq_enable()	__mtmsrd(mfmsr() | MSR_EE, 1)
-#define hard_irq_disable()	__mtmsrd(mfmsr() & ~MSR_EE, 1)
+#define __hard_irq_enable()	__mtmsrd(mfmsr() | MSR_EE, 1)
+#define __hard_irq_disable()	__mtmsrd(mfmsr() & ~MSR_EE, 1)
+
+#define  hard_irq_disable()			\
+	do {					\
+		__hard_irq_disable();		\
+		get_paca()->soft_enabled = 0;	\
+		get_paca()->hard_enabled = 0;	\
+	} while(0)
 
 #else
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
do-not-select-macintosh-drivers-by-default.patch
introduce-freezer-flags-rev-2.patch
powerpc-fixup-hard_irq_disable-semantics.patch
add-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-fix.patch
