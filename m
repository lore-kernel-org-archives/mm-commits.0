From: akpm@linux-foundation.org
Subject: - m32r-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:35 -0700
Message-ID: <200710162036.l9GKaZ1b015194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965542AbXJPVeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     M32R: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     m32r-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: M32R: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/time.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/m32r/kernel/time.c~m32r-cleanup-struct-irqaction-initializers arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~m32r-cleanup-struct-irqaction-initializers
+++ a/arch/m32r/kernel/time.c
@@ -228,8 +228,12 @@ irqreturn_t timer_interrupt(int irq, voi
 	return IRQ_HANDLED;
 }
 
-struct irqaction irq0 = { timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE,
-			  "MFT2", NULL, NULL };
+struct irqaction irq0 = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "MFT2",
+};
 
 void __init time_init(void)
 {
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch
replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch
powerpc-add-altivec-vmx-state-to-coredumps.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
spin_lock_unlocked-cleanups.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
