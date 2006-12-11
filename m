From: akpm@osdl.org
Subject: + updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies.patch added to -mm tree
Date: Mon, 11 Dec 2006 13:37:06 -0800
Message-ID: <200612112137.kBBLb6EN008401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39083 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937052AbWLKVhQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 16:37:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     clockevents: i8253.c, remove HPET dependencies
has been added to the -mm tree.  Its filename is
     updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: i8253.c, remove HPET dependencies
From: Thomas Gleixner <tglx@linutronix.de>

Remove HPET dependencies from the PIT driver.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/i8253.c |    4 ----
 include/asm-i386/i8253.h |    5 -----
 2 files changed, 9 deletions(-)

diff -puN arch/i386/kernel/i8253.c~updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies
+++ a/arch/i386/kernel/i8253.c
@@ -19,13 +19,11 @@
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
-#ifdef CONFIG_HPET_TIMER
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
  * the two timers is used
  */
 struct clock_event_device *global_clock_event;
-#endif
 
 /*
  * Initialize the PIT timer.
@@ -103,9 +101,7 @@ void __init setup_pit_timer(void)
 	pit_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &pit_clockevent);
 	register_global_clockevent(&pit_clockevent);
-#ifdef CONFIG_HPET_TIMER
 	global_clock_event = &pit_clockevent;
-#endif
 }
 
 /*
diff -puN include/asm-i386/i8253.h~updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies include/asm-i386/i8253.h
--- a/include/asm-i386/i8253.h~updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies
+++ a/include/asm-i386/i8253.h
@@ -5,12 +5,7 @@
 
 extern spinlock_t i8253_lock;
 
-#ifdef CONFIG_HPET_TIMER
 extern struct clock_event_device *global_clock_event;
-#else
-extern struct clock_event_device pit_clockevent;
-# define global_clock_event (&pit_clockevent)
-#endif
 
 /**
  * pit_interrupt_hook - hook into timer tick
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
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
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-high-res-timers-core-cleanup-state-tracking-update.patch
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
clockevents-convert-hpet-to-clockevents.patch
clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch
clockevents-remove-ptregs-argument-from-handlers.patch

