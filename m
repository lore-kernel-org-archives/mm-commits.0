From: akpm@linux-foundation.org
Subject: + x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch added to -mm tree
Date: Sat, 02 Feb 2008 18:02:25 -0800
Message-ID: <200802030202.m13226Yu026571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbYBCCCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Feb 2008 21:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: remove pt_regs arg from smp_thermal_interrupt
has been added to the -mm tree.  Its filename is
     x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
mm-remove-fastcall-from-mm.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
asm-generic-remove-fastcall.patch
misc-removal-of-final-callers-using-fastcall.patch
