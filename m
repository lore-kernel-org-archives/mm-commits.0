From: akpm@osdl.org
Subject: - high-res-timers-utilize-tsc-clocksource-again.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:44 -0800
Message-ID: <200612132249.kBDMniVB023174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbWLMWt7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     high-res timers: utilize TSC clocksource again
has been removed from the -mm tree.  Its filename was
     high-res-timers-utilize-tsc-clocksource-again.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: high-res timers: utilize TSC clocksource again
From: Thomas Gleixner <tglx@linutronix.de>

Utilize the TSC clocksource again on high-res timers.  (dependent on the
existence of pmtimer as a fallback to resync across TSC-destructive
resume/halt/cpufreq events, but that is normally available.)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c |   50 ++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff -puN arch/i386/kernel/tsc.c~high-res-timers-utilize-tsc-clocksource-again arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~high-res-timers-utilize-tsc-clocksource-again
+++ a/arch/i386/kernel/tsc.c
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/acpi_pmtmr.h>
 
 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -388,42 +389,51 @@ static struct dmi_system_id __initdata b
 
 #define TSC_FREQ_CHECK_INTERVAL (10*MSEC_PER_SEC) /* 10sec in MS */
 static struct timer_list verify_tsc_freq_timer;
+static unsigned long pm_multiplier;
 
 /* XXX - Probably should add locking */
 static void verify_tsc_freq(unsigned long unused)
 {
 	static u64 last_tsc;
-	static unsigned long last_jiffies;
+	static unsigned long last_jiffies, last_pm;
 
 	u64 now_tsc, interval_tsc;
-	unsigned long now_jiffies, interval_jiffies;
-
+	unsigned long now_jiffies, interval_jiffies, pm, pm_delta;
 
 	if (check_tsc_unstable())
 		return;
 
 	rdtscll(now_tsc);
 	now_jiffies = jiffies;
+	pm = acpi_pm_read_early();
 
-	if (!last_jiffies) {
+	if (!last_jiffies)
 		goto out;
-	}
 
 	interval_jiffies = now_jiffies - last_jiffies;
-	interval_tsc = now_tsc - last_tsc;
-	interval_tsc *= HZ;
-	do_div(interval_tsc, cpu_khz*1000);
+
+	if (pm == last_pm) {
+		interval_tsc = now_tsc - last_tsc;
+		interval_tsc *= HZ;
+		do_div(interval_tsc, cpu_khz*1000);
+	} else {
+		if (pm < last_pm)
+			pm += ACPI_PM_OVRRUN;
+		pm_delta = pm - last_pm;
+		interval_tsc = (((u64) pm_delta) * pm_multiplier) >> 22;
+		do_div(interval_tsc, TICK_NSEC);
+	}
 
 	if (interval_tsc < (interval_jiffies * 3 / 4)) {
 		printk("TSC appears to be running slowly. "
-			"Marking it as unstable\n");
+		       "Marking it as unstable\n");
 		mark_tsc_unstable();
 		return;
 	}
-
 out:
 	last_tsc = now_tsc;
 	last_jiffies = now_jiffies;
+	last_pm = pm;
 	/* set us up to go off on the next interval: */
 	mod_timer(&verify_tsc_freq_timer,
 		jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL));
@@ -458,23 +468,25 @@ static int __init init_tsc_clocksource(v
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
-#ifndef CONFIG_HIGH_RES_TIMERS
 		/* lower the rating if we already know its unstable: */
 		if (check_tsc_unstable())
 			clocksource_tsc.rating = 0;
-#else
+
 		/*
-		 * Mark TSC unsuitable for high resolution timers. TSC has so
-		 * many pitfalls: frequency changes, stop in idle ...  When we
+		 * Mark TSC unsuitable for high resolution timers, when
+		 * pm_timer is not available as a fallback. TSC has so many
+		 * pitfalls: frequency changes, stop in idle ...  When we
 		 * switch to high resolution mode we can not longer detect a
 		 * firmware caused frequency change, as the emulated tick uses
 		 * TSC as reference. This results in a circular dependency.
-		 * Switch only to high resolution mode, if pm_timer or such
-		 * is available.
+		 * Switch only to high resolution mode, if pm_timer or such is
+		 * available.
 		 */
-		clocksource_tsc.rating = 50;
-		clocksource_tsc.is_continuous = 0;
-#endif
+		if (!pmtmr_ioport || !clocksource_tsc.rating)
+			clocksource_tsc.is_continuous = 0;
+
+		pm_multiplier = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
 		init_timer(&verify_tsc_freq_timer);
 		verify_tsc_freq_timer.function = verify_tsc_freq;
 		verify_tsc_freq_timer.expires =
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

