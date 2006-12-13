From: akpm@osdl.org
Subject: - updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:21 -0800
Message-ID: <200612132249.kBDMnLhk023150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbWLMWtc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     clockevents: i8253.c, remove HPET dependencies
has been removed from the -mm tree.  Its filename was
     updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies.patch

This patch was dropped because it is obsolete

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

