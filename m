From: akpm@linux-foundation.org
Subject: + x86_64-consolidate-tsc-calibration.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:45 -0700
Message-ID: <200708242204.l7OM4jnk016981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbXHXWGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, mingo@elte.hu


The patch titled
     x86_64: Consolidate tsc calibration
has been added to the -mm tree.  Its filename is
     x86_64-consolidate-tsc-calibration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: Consolidate tsc calibration
From: Thomas Gleixner <tglx@linutronix.de>

Move the TSC calibration code to tsc.c. Reimplement it so the
pm timer can be used as a reference as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/hpet.c |   49 -------------------
 arch/x86_64/kernel/time.c |   33 -------------
 arch/x86_64/kernel/tsc.c  |   90 ++++++++++++++++++++++++++++++++++++
 include/asm-i386/tsc.h    |    4 +
 4 files changed, 96 insertions(+), 80 deletions(-)

diff -puN arch/x86_64/kernel/hpet.c~x86_64-consolidate-tsc-calibration arch/x86_64/kernel/hpet.c
--- a/arch/x86_64/kernel/hpet.c~x86_64-consolidate-tsc-calibration
+++ a/arch/x86_64/kernel/hpet.c
@@ -184,55 +184,6 @@ int hpet_reenable(void)
 	return hpet_timer_stop_set_go(hpet_tick);
 }
 
-/*
- * calibrate_tsc() calibrates the processor TSC in a very simple way, comparing
- * it to the HPET timer of known frequency.
- */
-
-#define TICK_COUNT 100000000
-#define SMI_THRESHOLD 50000
-#define MAX_TRIES  5
-
-/*
- * Some platforms take periodic SMI interrupts with 5ms duration. Make sure none
- * occurs between the reads of the hpet & TSC.
- */
-static void __init read_hpet_tsc(int *hpet, int *tsc)
-{
-	int tsc1, tsc2, hpet1, i;
-
-	for (i = 0; i < MAX_TRIES; i++) {
-		tsc1 = get_cycles_sync();
-		hpet1 = hpet_readl(HPET_COUNTER);
-		tsc2 = get_cycles_sync();
-		if ((tsc2 - tsc1) < SMI_THRESHOLD)
-			break;
-	}
-	*hpet = hpet1;
-	*tsc = tsc2;
-}
-
-unsigned int __init hpet_calibrate_tsc(void)
-{
-	int tsc_start, hpet_start;
-	int tsc_now, hpet_now;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	read_hpet_tsc(&hpet_start, &tsc_start);
-
-	do {
-		local_irq_disable();
-		read_hpet_tsc(&hpet_now, &tsc_now);
-		local_irq_restore(flags);
-	} while ((tsc_now - tsc_start) < TICK_COUNT &&
-		(hpet_now - hpet_start) < TICK_COUNT);
-
-	return (tsc_now - tsc_start) * 1000000000L
-		/ ((hpet_now - hpet_start) * hpet_period / 1000);
-}
-
 #ifdef CONFIG_HPET_EMULATE_RTC
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
  * is enabled, we support RTC interrupt functionality in software.
diff -puN arch/x86_64/kernel/time.c~x86_64-consolidate-tsc-calibration arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86_64-consolidate-tsc-calibration
+++ a/arch/x86_64/kernel/time.c
@@ -292,35 +292,6 @@ static unsigned int __init tsc_calibrate
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
-/*
- * pit_calibrate_tsc() uses the speaker output (channel 2) of
- * the PIT. This is better than using the timer interrupt output,
- * because we can read the value of the speaker with just one inb(),
- * where we need three i/o operations for the interrupt channel.
- * We count how many ticks the TSC does in 50 ms.
- */
-
-static unsigned int __init pit_calibrate_tsc(void)
-{
-	unsigned long start, end;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
-
-	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
-
-	outb(0xb0, 0x43);
-	outb((PIT_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-	outb((PIT_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-	start = get_cycles_sync();
-	while ((inb(0x61) & 0x20) == 0);
-	end = get_cycles_sync();
-
-	spin_unlock_irqrestore(&i8253_lock, flags);
-
-	return (end - start) / 50;
-}
-
 #define PIT_MODE 0x43
 #define PIT_CH0  0x40
 
@@ -376,14 +347,14 @@ void __init time_init(void)
 	if (hpet_use_timer) {
 		/* set tick_nsec to use the proper rate for HPET */
 		tick_nsec = TICK_NSEC_HPET;
-		tsc_khz = hpet_calibrate_tsc();
 		timename = "HPET";
 	} else {
 		pit_init();
-		tsc_khz = pit_calibrate_tsc();
 		timename = "PIT";
 	}
 
+	tsc_calibrate();
+
 	cpu_khz = tsc_khz;
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
 		boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
diff -puN arch/x86_64/kernel/tsc.c~x86_64-consolidate-tsc-calibration arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~x86_64-consolidate-tsc-calibration
+++ a/arch/x86_64/kernel/tsc.c
@@ -6,7 +6,9 @@
 #include <linux/time.h>
 #include <linux/acpi.h>
 #include <linux/cpufreq.h>
+#include <linux/acpi_pmtmr.h>
 
+#include <asm/hpet.h>
 #include <asm/timex.h>
 #include <asm/tsc.h>
 
@@ -91,6 +93,94 @@ core_initcall(cpufreq_tsc);
 
 #endif
 
+#define MAX_RETRIES	5
+#define SMI_TRESHOLD	50000
+
+/*
+ * Read TSC and the reference counters. Take care of SMI disturbance
+ */
+static unsigned long __init tsc_read_refs(unsigned long *pm,
+					  unsigned long *hpet)
+{
+	unsigned long t1, t2;
+	int i;
+
+	for (i = 0; i < MAX_RETRIES; i++) {
+		t1 = get_cycles_sync();
+		if (hpet)
+			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
+		else
+			*pm = acpi_pm_read_early();
+		t2 = get_cycles_sync();
+		if ((t2 - t1) < SMI_TRESHOLD)
+			return t2;
+	}
+	return ULONG_MAX;
+}
+
+/**
+ * tsc_calibrate - calibrate the tsc on boot
+ */
+void __init tsc_calibrate(void)
+{
+	unsigned long flags, tsc1, tsc2, tr1, tr2, pm1, pm2, hpet1, hpet2;
+	int hpet = is_hpet_enabled();
+
+	local_irq_save(flags);
+
+	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+
+	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+
+	outb(0xb0, 0x43);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
+	tr1 = get_cycles_sync();
+	while ((inb(0x61) & 0x20) == 0);
+	tr2 = get_cycles_sync();
+
+	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+
+	local_irq_restore(flags);
+
+	/*
+	 * Preset the result with the raw and inaccurate PIT
+	 * calibration value
+	 */
+	tsc_khz = (tr2 - tr1) / 50;
+
+	/* hpet or pmtimer available ? */
+	if (!hpet && !pm1 && !pm2) {
+		printk(KERN_INFO "TSC calibrated against PIT\n");
+		return;
+	}
+
+	/* Check, whether the sampling was disturbed by an SMI */
+	if (tsc1 == ULONG_MAX || tsc2 == ULONG_MAX) {
+		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
+		       "using PIT calibration result\n");
+		return;
+	}
+
+	tsc2 = (tsc2 - tsc1) * 1000000L;
+
+	if (hpet) {
+		printk(KERN_INFO "TSC calibrated against HPET\n");
+		if (hpet2 < hpet1)
+			hpet2 += 0x100000000;
+		hpet2 -= hpet1;
+		tsc1 = (hpet2 * hpet_readl(HPET_PERIOD)) / 1000000;
+	} else {
+		printk(KERN_INFO "TSC calibrated against PM_TIMER\n");
+		if (pm2 < pm1)
+			pm2 += ACPI_PM_OVRRUN;
+		pm2 -= pm1;
+		tsc1 = (pm2 * 1000000000) / PMTMR_TICKS_PER_SEC;
+	}
+
+	tsc_khz = tsc2 / tsc1;
+}
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
diff -puN include/asm-i386/tsc.h~x86_64-consolidate-tsc-calibration include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~x86_64-consolidate-tsc-calibration
+++ a/include/asm-i386/tsc.h
@@ -73,4 +73,8 @@ extern unsigned long long tsc_sched_cloc
 extern void check_tsc_sync_source(int cpu);
 extern void check_tsc_sync_target(void);
 
+#ifdef CONFIG_X86_64
+extern void tsc_calibrate(void);
+#endif
+
 #endif
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
git-acpi.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
