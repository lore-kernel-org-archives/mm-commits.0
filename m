From: akpm@osdl.org
Subject: - high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:12:44 -0800
Message-ID: <200701250612.l0P6Ci6S007849@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49178 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbXAYGMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:12:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     high-res timers: allow TSC clocksource if pmtimer present
has been removed from the -mm tree.  Its filename was
     high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch

This patch was dropped because an updated version will be merged

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
@@ -396,44 +397,55 @@ static struct dmi_system_id __initdata b
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
@@ -472,6 +484,21 @@ static int __init init_tsc_clocksource(v
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
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
