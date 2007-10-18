From: akpm@linux-foundation.org
Subject: - i386-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:57 -0700
Message-ID: <200710180707.l9I77vpp031743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759521AbXJRHIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     i386-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/i8259_32.c    |    6 +++++-
 arch/x86/mach-default/setup.c |    6 +++++-
 arch/x86/mach-voyager/setup.c |    6 +++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/i8259_32.c~i386-cleanup-struct-irqaction-initializers arch/x86/kernel/i8259_32.c
--- a/arch/x86/kernel/i8259_32.c~i386-cleanup-struct-irqaction-initializers
+++ a/arch/x86/kernel/i8259_32.c
@@ -349,7 +349,11 @@ static irqreturn_t math_error_irq(int cp
  * New motherboards sometimes make IRQ 13 be a PCI interrupt,
  * so allow interrupt sharing.
  */
-static struct irqaction fpu_irq = { math_error_irq, 0, CPU_MASK_NONE, "fpu", NULL, NULL };
+static struct irqaction fpu_irq = {
+	.handler = math_error_irq,
+	.mask = CPU_MASK_NONE,
+	.name = "fpu",
+};
 
 void __init init_ISA_irqs (void)
 {
diff -puN arch/x86/mach-default/setup.c~i386-cleanup-struct-irqaction-initializers arch/x86/mach-default/setup.c
--- a/arch/x86/mach-default/setup.c~i386-cleanup-struct-irqaction-initializers
+++ a/arch/x86/mach-default/setup.c
@@ -35,7 +35,11 @@ void __init pre_intr_init_hook(void)
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
-static struct irqaction irq2 = { no_action, 0, CPU_MASK_NONE, "cascade", NULL, NULL};
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
 
 /**
  * intr_init_hook - post gate setup interrupt initialisation
diff -puN arch/x86/mach-voyager/setup.c~i386-cleanup-struct-irqaction-initializers arch/x86/mach-voyager/setup.c
--- a/arch/x86/mach-voyager/setup.c~i386-cleanup-struct-irqaction-initializers
+++ a/arch/x86/mach-voyager/setup.c
@@ -18,7 +18,11 @@ void __init pre_intr_init_hook(void)
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
-static struct irqaction irq2 = { no_action, 0, CPU_MASK_NONE, "cascade", NULL, NULL};
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
 
 void __init intr_init_hook(void)
 {
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-x86.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
i386-paravirt-boot-sequence.patch
revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
