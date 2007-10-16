From: akpm@linux-foundation.org
Subject: - frv-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:20 -0700
Message-ID: <200710162036.l9GKaKoD015176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933821AbXJPVeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     frv-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/time.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/frv/kernel/time.c~frv-cleanup-struct-irqaction-initializers arch/frv/kernel/time.c
--- a/arch/frv/kernel/time.c~frv-cleanup-struct-irqaction-initializers
+++ a/arch/frv/kernel/time.c
@@ -43,7 +43,10 @@ unsigned long __delay_loops_MHz;
 static irqreturn_t timer_interrupt(int irq, void *dummy);
 
 static struct irqaction timer_irq  = {
-	timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "timer",
 };
 
 static inline int set_rtc_mmss(unsigned long nowtime)
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
