From: akpm@linux-foundation.org
Subject: - x86_64-preparatory-apic-set-lvtt.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:01 -0700
Message-ID: <200710150918.l9F9I1lv027344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755660AbXJOJYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: prepare apic code for clock events
has been removed from the -mm tree.  Its filename was
     x86_64-preparatory-apic-set-lvtt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: prepare apic code for clock events
From: Thomas Gleixner <tglx@linutronix.de>

Change __setup_APIC_LVTT so it takes the arguments which are necessary for the
later clock events switch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-preparatory-apic-set-lvtt arch/x86_64/kernel/apic.c
--- a/arch/x86/kernel/apic_64.c~x86_64-preparatory-apic-set-lvtt
+++ a/arch/x86/kernel/apic_64.c
@@ -739,14 +739,14 @@ void __init init_apic_mappings(void)
 
 #define APIC_DIVISOR 16
 
-static void __setup_APIC_LVTT(unsigned int clocks)
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
-	int cpu = smp_processor_id();
-
-	lvtt_value = APIC_LVT_TIMER_PERIODIC | LOCAL_TIMER_VECTOR;
 
-	if (cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask))
+	lvtt_value = LOCAL_TIMER_VECTOR;
+	if (!oneshot)
+		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
 	apic_write(APIC_LVTT, lvtt_value);
@@ -759,12 +759,14 @@ static void __setup_APIC_LVTT(unsigned i
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
-	apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+	if (!oneshot)
+		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
 static void setup_APIC_timer(unsigned int clocks)
 {
 	unsigned long flags;
+	int irqen;
 
 	local_irq_save(flags);
 
@@ -785,7 +787,10 @@ static void setup_APIC_timer(unsigned in
 			c2 |= inb_p(0x40) << 8;
 		} while (c2 - c1 < 300);
 	}
-	__setup_APIC_LVTT(clocks);
+
+	irqen = ! cpu_isset(smp_processor_id(),
+			    timer_interrupt_broadcast_ipi_mask);
+	__setup_APIC_LVTT(clocks, 0, irqen);
 	/* Turn off PIT interrupt if we use APIC timer as main timer.
 	   Only works with the PM timer right now
 	   TBD fix it for HPET too. */
@@ -823,8 +828,10 @@ static int __init calibrate_APIC_clock(v
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
+	 *
+	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(4000000000);
+	__setup_APIC_LVTT(4000000000, 0, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
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
