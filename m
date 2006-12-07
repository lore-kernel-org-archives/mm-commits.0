From: akpm@osdl.org
Subject: - ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:54 -0800
Message-ID: <200612072304.kB7N4swG030096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52338 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163889AbWLGXFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, Helmut.Duregger@student.uibk.ac.at, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ktime: Fix signed / unsigned mismatch in ktime_to_ns
has been removed from the -mm tree.  Its filename was
     ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ktime: Fix signed / unsigned mismatch in ktime_to_ns
From: Thomas Gleixner <tglx@linutronix.de>

The 32 bit implementation of ktime_to_ns returns unsigned value, while the
64 bit version correctly returns an signed value.  There is no current user
affected by this, but it has to be fixed, as ktime values can be negative.

Pointed-out-by: Helmut Duregger <Helmut.Duregger@student.uibk.ac.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/ktime.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ktime.h~ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns include/linux/ktime.h
--- a/include/linux/ktime.h~ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns
+++ a/include/linux/ktime.h
@@ -248,9 +248,9 @@ static inline struct timeval ktime_to_ti
  *
  * Returns the scalar nanoseconds representation of kt
  */
-static inline u64 ktime_to_ns(const ktime_t kt)
+static inline s64 ktime_to_ns(const ktime_t kt)
 {
-	return (u64) kt.tv.sec * NSEC_PER_SEC + kt.tv.nsec;
+	return (s64) kt.tv.sec * NSEC_PER_SEC + kt.tv.nsec;
 }
 
 #endif
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch
time-re-add-verify_pmtmr_rate.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch

