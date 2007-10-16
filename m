From: akpm@linux-foundation.org
Subject: - v850-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:16 -0700
Message-ID: <200710162039.l9GKdGKZ015528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935170AbXJPVIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, miles@gnu.org, mm-commits@vger.kernel.org


The patch titled
     V850: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     v850-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: V850: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Miles Bader <miles@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/v850/kernel/fpga85e2c.c |    5 ++++-
 arch/v850/kernel/time.c      |   11 +++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/v850/kernel/fpga85e2c.c~v850-cleanup-struct-irqaction-initializers arch/v850/kernel/fpga85e2c.c
--- a/arch/v850/kernel/fpga85e2c.c~v850-cleanup-struct-irqaction-initializers
+++ a/arch/v850/kernel/fpga85e2c.c
@@ -160,5 +160,8 @@ static void make_reg_snap (int irq, void
 
 static int reg_snap_dev_id;
 static struct irqaction reg_snap_action = {
-	make_reg_snap, 0, CPU_MASK_NONE, "reg_snap", &reg_snap_dev_id, 0
+	.handler = make_reg_snap,
+	.mask = CPU_MASK_NONE,
+	.name = "reg_snap",
+	.dev_id = &reg_snap_dev_id,
 };
diff -puN arch/v850/kernel/time.c~v850-cleanup-struct-irqaction-initializers arch/v850/kernel/time.c
--- a/arch/v850/kernel/time.c~v850-cleanup-struct-irqaction-initializers
+++ a/arch/v850/kernel/time.c
@@ -92,12 +92,11 @@ static irqreturn_t timer_interrupt (int 
 
 static int timer_dev_id;
 static struct irqaction timer_irqaction = {
-	timer_interrupt,
-	IRQF_DISABLED,
-	CPU_MASK_NONE,
-	"timer",
-	&timer_dev_id,
-	NULL
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "timer",
+	.dev_id = &timer_dev_id,
 };
 
 void time_init (void)
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
