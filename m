From: akpm@linux-foundation.org
Subject: - x86_64-apic-remove-bogus-pit-synchronization.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:03 -0700
Message-ID: <200710150918.l9F9I3ZG027355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755290AbXJOJYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove pit synchronization
has been removed from the -mm tree.  Its filename was
     x86_64-apic-remove-bogus-pit-synchronization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove pit synchronization
From: Thomas Gleixner <tglx@linutronix.de>

The APIC timer setup code synchronizes the local APIC timer to the PIT/HPET. 
This is pointless as the PIT and the local APIC timer frequency are not
correlated and the APIC timer calibration can never be accurate enough to
avoid that the local APIC timer and the PIT/HPET drift apart.

Simply remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-remove-bogus-pit-synchronization arch/x86_64/kernel/apic.c
--- a/arch/x86/kernel/apic_64.c~x86_64-apic-remove-bogus-pit-synchronization
+++ a/arch/x86/kernel/apic_64.c
@@ -770,24 +770,6 @@ static void setup_APIC_timer(unsigned in
 
 	local_irq_save(flags);
 
-	/* wait for irq slice */
-	if (hpet_address && hpet_use_timer) {
-		u32 trigger = hpet_readl(HPET_T0_CMP);
-		while (hpet_readl(HPET_T0_CMP) == trigger)
-			/* do nothing */ ;
-	} else {
-		int c1, c2;
-		outb_p(0x00, 0x43);
-		c2 = inb_p(0x40);
-		c2 |= inb_p(0x40) << 8;
-		do {
-			c1 = c2;
-			outb_p(0x00, 0x43);
-			c2 = inb_p(0x40);
-			c2 |= inb_p(0x40) << 8;
-		} while (c2 - c1 < 300);
-	}
-
 	irqen = ! cpu_isset(smp_processor_id(),
 			    timer_interrupt_broadcast_ipi_mask);
 	__setup_APIC_LVTT(clocks, 0, irqen);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-arm.patch
git-mips.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
frv-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
v850-cleanup-struct-irqaction-initializers.patch
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
