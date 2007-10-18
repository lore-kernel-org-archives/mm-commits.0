From: akpm@linux-foundation.org
Subject: - x86_64-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:59 -0700
Message-ID: <200710180707.l9I77x5n031748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537AbXJRHIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     X86_64: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     x86_64-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: X86_64: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/i8259.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/i8259.c~x86_64-cleanup-struct-irqaction-initializers arch/x86_64/kernel/i8259.c
--- a/arch/x86/kernel/i8259_64.c~x86_64-cleanup-struct-irqaction-initializers
+++ a/arch/x86/kernel/i8259_64.c
@@ -395,7 +395,11 @@ device_initcall(i8259A_init_sysfs);
  * IRQ2 is cascade interrupt to second interrupt controller
  */
 
-static struct irqaction irq2 = { no_action, 0, CPU_MASK_NONE, "cascade", NULL, NULL};
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[0 ... IRQ0_VECTOR - 1] = -1,
 	[IRQ0_VECTOR] = 0,
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
