From: akpm@linux-foundation.org
Subject: - cris-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:41 -0700
Message-ID: <200710162036.l9GKafW9015205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935944AbXJPVIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     cris-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRIS: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/time.c |    8 ++++++--
 arch/cris/arch-v32/kernel/smp.c  |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/cris/arch-v10/kernel/time.c~cris-cleanup-struct-irqaction-initializers arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~cris-cleanup-struct-irqaction-initializers
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -254,8 +254,12 @@ timer_interrupt(int irq, void *dev_id, s
  * it needs to be IRQF_DISABLED to make the jiffies update work properly
  */
 
-static struct irqaction irq2  = { timer_interrupt, IRQF_SHARED | IRQF_DISABLED,
-				  CPU_MASK_NONE, "timer", NULL, NULL};
+static struct irqaction irq2  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "timer",
+};
 
 void __init
 time_init(void)
diff -puN arch/cris/arch-v32/kernel/smp.c~cris-cleanup-struct-irqaction-initializers arch/cris/arch-v32/kernel/smp.c
--- a/arch/cris/arch-v32/kernel/smp.c~cris-cleanup-struct-irqaction-initializers
+++ a/arch/cris/arch-v32/kernel/smp.c
@@ -63,8 +63,12 @@ static unsigned long irq_regs[NR_CPUS] =
 
 static irqreturn_t crisv32_ipi_interrupt(int irq, void *dev_id, struct pt_regs *regs);
 static int send_ipi(int vector, int wait, cpumask_t cpu_mask);
-static struct irqaction irq_ipi  = { crisv32_ipi_interrupt, IRQF_DISABLED,
-                                     CPU_MASK_NONE, "ipi", NULL, NULL};
+static struct irqaction irq_ipi  = {
+	.handler = crisv32_ipi_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "ipi",
+};
 
 extern void cris_mmu_init(void);
 extern void cris_timer_init(void);
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
