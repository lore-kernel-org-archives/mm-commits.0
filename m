From: akpm@linux-foundation.org
Subject: - x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch removed from -mm tree
Date: Sat, 16 Feb 2008 10:56:51 -0800
Message-ID: <200802161856.m1GIupqX005081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbYBPS5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 13:57:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: remove pt_regs arg from smp_thermal_interrupt
has been removed from the -mm tree.  Its filename was
     x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove pt_regs arg from smp_thermal_interrupt
From: Harvey Harrison <harvey.harrison@gmail.com>

The pt_regs arg is never used, make it agree with the other
definitions of smp_thermal_interrupt.

It doesn't look like smp_thermal_interrupt is even called on
32-bit...

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/p4.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/p4.c~x86-remove-pt_regs-arg-from-smp_thermal_interrupt arch/x86/kernel/cpu/mcheck/p4.c
--- a/arch/x86/kernel/cpu/mcheck/p4.c~x86-remove-pt_regs-arg-from-smp_thermal_interrupt
+++ a/arch/x86/kernel/cpu/mcheck/p4.c
@@ -36,7 +36,7 @@ static int mce_num_extended_msrs = 0;
 
 
 #ifdef CONFIG_X86_MCE_P4THERMAL
-static void unexpected_thermal_interrupt(struct pt_regs *regs)
+static void unexpected_thermal_interrupt(void)
 {	
 	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
 			smp_processor_id());
@@ -44,7 +44,7 @@ static void unexpected_thermal_interrupt
 }
 
 /* P4/Xeon Thermal transition interrupt handler */
-static void intel_thermal_interrupt(struct pt_regs *regs)
+static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
@@ -55,12 +55,12 @@ static void intel_thermal_interrupt(stru
 }
 
 /* Thermal interrupt handler for this CPU setup */
-static void (*vendor_thermal_interrupt)(struct pt_regs *regs) = unexpected_thermal_interrupt;
+static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
 
-void __attribute__((weak)) smp_thermal_interrupt(struct pt_regs *regs)
+void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 	irq_enter();
-	vendor_thermal_interrupt(regs);
+	vendor_thermal_interrupt();
 	__get_cpu_var(irq_stat).irq_thermal_count++;
 	irq_exit();
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
git-ubi.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
