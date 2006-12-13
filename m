From: akpm@osdl.org
Subject: + high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:28 -0800
Message-ID: <200612132244.kBDMiSSp022894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbWLMWof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     high-res timers: allow TSC clocksource if pmtimer present
has been added to the -mm tree.  Its filename is
     high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: high-res timers: allow TSC clocksource if pmtimer present
From: Thomas Gleixner <tglx@linutronix.de>

allow TSC clocksource dependent on the existence of pmtimer as a fallback,
to resync across TSC-destructive resume/halt/cpufreq events.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c     |   47 +++++++++++++++++++++++++++--------
 include/linux/acpi_pmtmr.h |    2 +
 2 files changed, 39 insertions(+), 10 deletions(-)

diff -puN arch/i386/kernel/tsc.c~high-res-timers-allow-tsc-clocksource-if-pmtimer-present arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~high-res-timers-allow-tsc-clocksource-if-pmtimer-present
+++ a/arch/i386/kernel/tsc.c
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/acpi_pmtmr.h>
 
 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -386,44 +387,55 @@ static struct dmi_system_id __initdata b
 	 {}
 };
 
-#define TSC_FREQ_CHECK_INTERVAL (10*MSEC_PER_SEC) /* 10sec in MS */
+#define TSC_FREQ_CHECK_INTERVAL MSEC_PER_SEC
 static struct timer_list verify_tsc_freq_timer;
+static unsigned long pm_multiplier;
 
 /* XXX - Probably should add locking */
 static void verify_tsc_freq(unsigned long unused)
 {
 	static u64 last_tsc;
-	static unsigned long last_jiffies;
-
-	u64 now_tsc, interval_tsc;
-	unsigned long now_jiffies, interval_jiffies;
+	static unsigned long last_jiffies, last_pm;
 
+	u64 now_tsc, interval_tsc, tmp;
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
 
-	interval_jiffies = now_jiffies - last_jiffies;
 	interval_tsc = now_tsc - last_tsc;
 	interval_tsc *= HZ;
 	do_div(interval_tsc, cpu_khz*1000);
 
+	if (pm == last_pm) {
+		interval_jiffies = now_jiffies - last_jiffies;
+	} else {
+		if (pm < last_pm)
+			pm_delta = (pm + ACPI_PM_OVRRUN) - last_pm;
+		else
+			pm_delta = pm - last_pm;
+		tmp = (((u64) pm_delta) * pm_multiplier) >> 22;
+		do_div(tmp, (NSEC_PER_SEC/HZ));
+		interval_jiffies = (unsigned long) tmp;
+	}
+
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
@@ -462,6 +474,21 @@ static int __init init_tsc_clocksource(v
 		if (check_tsc_unstable())
 			clocksource_tsc.rating = 0;
 
+		/*
+		 * Mark TSC unsuitable for high resolution timers, when
+		 * pm_timer is not available as a fallback. TSC has so many
+		 * pitfalls: frequency changes, stop in idle ...  When we
+		 * switch to high resolution mode we can not longer detect a
+		 * firmware caused frequency change, as the emulated tick uses
+		 * TSC as reference. This results in a circular dependency.
+		 * Switch only to high resolution mode, if pm_timer or such is
+		 * available.
+		 */
+		if (!pmtmr_ioport || !clocksource_tsc.rating)
+			clocksource_tsc.is_continuous = 0;
+
+		pm_multiplier = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
 		init_timer(&verify_tsc_freq_timer);
 		verify_tsc_freq_timer.function = verify_tsc_freq;
 		verify_tsc_freq_timer.expires =
diff -puN include/linux/acpi_pmtmr.h~high-res-timers-allow-tsc-clocksource-if-pmtimer-present include/linux/acpi_pmtmr.h
--- a/include/linux/acpi_pmtmr.h~high-res-timers-allow-tsc-clocksource-if-pmtimer-present
+++ a/include/linux/acpi_pmtmr.h
@@ -27,6 +27,8 @@ static inline u32 acpi_pm_read_early(voi
 
 #else
 
+#define pmtmr_ioport 0
+
 static inline u32 acpi_pm_read_early(void)
 {
 	return 0;
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

