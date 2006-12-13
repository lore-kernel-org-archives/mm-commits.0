From: akpm@osdl.org
Subject: - updated-gtod-mark-tsc-unusable-for-highres-timers.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:41 -0800
Message-ID: <200612132249.kBDMnfdZ023169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53067 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbWLMWuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     GTOD: Mark TSC unusable for highres timers
has been removed from the -mm tree.  Its filename was
     updated-gtod-mark-tsc-unusable-for-highres-timers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: GTOD: Mark TSC unusable for highres timers
From: Thomas Gleixner <tglx@linutronix.de>

The TSC is too unstable and unreliable to be used with high resolution timers.
 The automatic detection of TSC unstability fails once we switched to high
resolution mode, because the tick emulation would use the TSC as reference. 
This results in a circular dependency.  Mark it unusable for high res upfront.

[akpm@osdl.org: updated for i386-time-avoid-pit-smp-lockups.patch]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/tsc.c~updated-gtod-mark-tsc-unusable-for-highres-timers arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~updated-gtod-mark-tsc-unusable-for-highres-timers
+++ a/arch/i386/kernel/tsc.c
@@ -458,10 +458,23 @@ static int __init init_tsc_clocksource(v
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
+#ifndef CONFIG_HIGH_RES_TIMERS
 		/* lower the rating if we already know its unstable: */
 		if (check_tsc_unstable())
 			clocksource_tsc.rating = 0;
-
+#else
+		/*
+		 * Mark TSC unsuitable for high resolution timers. TSC has so
+		 * many pitfalls: frequency changes, stop in idle ...  When we
+		 * switch to high resolution mode we can not longer detect a
+		 * firmware caused frequency change, as the emulated tick uses
+		 * TSC as reference. This results in a circular dependency.
+		 * Switch only to high resolution mode, if pm_timer or such
+		 * is available.
+		 */
+		clocksource_tsc.rating = 50;
+		clocksource_tsc.is_continuous = 0;
+#endif
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

