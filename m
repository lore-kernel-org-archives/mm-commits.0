From: akpm@linux-foundation.org
Subject: - timekeeping-prevent-time-going-backwards-on-resume-v2.patch removed from -mm tree
Date: Sat, 15 Sep 2007 15:03:43 -0700
Message-ID: <200709152203.l8FM3hWL019835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbXIOWEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 18:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, marcelo@kvack.org, mm-commits@vger.kernel.org


The patch titled
     timekeeping: prevent time going backwards on resume (V2)
has been removed from the -mm tree.  Its filename was
     timekeeping-prevent-time-going-backwards-on-resume-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: timekeeping: prevent time going backwards on resume (V2)
From: Thomas Gleixner <tglx@linutronix.de>

Timekeeping resume adjusts xtime by adding the slept time in seconds and
resets the reference value of the clock source (clock->cycle_last).
clock->cycle last is used to calculate the delta between the last xtime
update and the readout of the clock source in __get_nsec_offset(). xtime
plus the offset is the current time. The resume code ignores the delta
which had already elapsed between the last xtime update and the actual
time of suspend. If the suspend time is short, then we can see time
going backwards on resume.

Suspend:
offs_s = clock->read() - clock->cycle_last;
now = xtime + offs_s;
timekeeping_suspend_time = read_rtc();

Resume:
sleep_time = read_rtc() - timekeeping_suspend_time;
xtime.tv_sec += sleep_time;
clock->cycle_last = clock->read();
offs_r = clock->read() - clock->cycle_last;
now = xtime + offs_r;

if sleep_time_seconds == 0 and offs_r < offs_s, then time goes
backwards.

Fix this by storing the offset from the last xtime update and add it to
xtime during resume, when we reset clock->cycle_last:

sleep_time = read_rtc() - timekeeping_suspend_time;
xtime.tv_sec += sleep_time;
xtime += offs_s;        /* Fixup xtime offset at suspend time */
clock->cycle_last = clock->read();
offs_r = clock->read() - clock->cycle_last;
now = xtime + offs_r;

Thanks to Marcelo for tracking this down on the OLPC and providing the
necessary details to analyze the root cause.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/time/timekeeping.c~timekeeping-prevent-time-going-backwards-on-resume-v2 kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-prevent-time-going-backwards-on-resume-v2
+++ a/kernel/time/timekeeping.c
@@ -217,6 +217,7 @@ static void change_clocksource(void)
 }
 #else
 static inline void change_clocksource(void) { }
+static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -281,7 +282,7 @@ static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
 /* xtime offset when we went into suspend */
-static s64 timekeeping_suspend_offset;
+static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -308,7 +309,7 @@ static int timekeeping_resume(struct sys
 		total_sleep_time += sleep_length;
 	}
 	/* Make sure that we have the correct xtime reference */
-	timespec_add_ns(&xtime, timekeeping_suspend_offset);
+	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
@@ -330,9 +331,9 @@ static int timekeeping_suspend(struct sy
 	unsigned long flags;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	timekeeping_suspended = 1;
 	/* Get the current xtime offset */
-	timekeeping_suspend_offset = __get_nsec_offset();
+	timekeeping_suspend_nsecs = __get_nsec_offset();
+	timekeeping_suspended = 1;
 	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

futex_compat-fix-list-traversal-bugs.patch
fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch
timekeeping-prevent-time-going-backwards-on-resume-v2.patch
cpu-hotplug-support-broken.patch
git-acpi.patch
arm-cleanup-struct-irqaction-initializers.patch
git-mips.patch
sh-cleanup-struct-irqaction-initializers.patch
sh64-cleanup-struct-irqaction-initializers.patch
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
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
frv-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
v850-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
