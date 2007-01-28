From: akpm@osdl.org
Subject: - hrt-dynticks-hotplug-fix.patch removed from -mm tree
Date: Sun, 28 Jan 2007 15:35:56 -0800
Message-ID: <200701282335.l0SNZuZN006046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41837 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbXA1Xg3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:36:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrt/dynticks hotplug fix
has been removed from the -mm tree.  Its filename was
     hrt-dynticks-hotplug-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: hrt/dynticks hotplug fix
From: Thomas Gleixner <tglx@linutronix.de>

The clockevents code didn't do CPU hotplug (and thus SMP resume/suspend)
logistics properly.  [read: resume under highres+dynticks didnt work] There
were multiple problems:

 - the local APIC clockevents driver was not unregistered on CPU-down, 
   but the CPU bootup sequence reinitialized it. This was mostly latent
   before but now that it's list managed it became a double list_add():

    [<c023b8fb>] list_add+0xa/0xf
    [<c01420ff>] clockevents_register_device+0x4e/0x6b
    [<c0119793>] setup_APIC_timer+0x47/0x4c
    [<c01197a0>] setup_secondary_APIC_clock+0x8/0xa
    [<c0118964>] start_secondary+0xe4/0x346

 - secondly, when bringing a CPU down we didnt clear its scheduler-tick 
   hrtimer status, which on one box resulted in a NULL pointer 
   dereference during CPU hot-unplug:

   EIP is at clockevents_program_event+0x38/0xac
   Call Trace:
     [<c0142df1>] tick_program_event+0x2d/0x55
     [<c013ed19>] hrtimer_reprogram+0x60/0x84
     [<c013edd5>] enqueue_hrtimer+0x98/0x11e
     [<c013f866>] hrtimer_start+0xdd/0xf4
     [<c01435a4>] tick_nohz_stop_sched_tick+0x179/0x1f2
     [<c012e83d>] irq_exit+0x76/0x83
     [<c010671b>] do_IRQ+0xf3/0x10c
     [<c0104a76>] common_interrupt+0x2e/0x34
     [<c011f88f>] native_safe_halt+0x5/0x7
     [<c0102e9c>] cpu_idle+0xca/0x143
     [<c0118bbe>] start_secondary+0x33e/0x346

 - thirdly, the double hrtimer init also resulted in the sched-tick 
   hrtimer expiry being executed in softirq context, which is bad 
   locking-wise and lockdep warned about that:

    =================================
    [ INFO: inconsistent lock state ]
    [ 2.6.20-rc6-rt2 #26
    ---------------------------------
    inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
    softirq-timer/1/2031 [HC0[0]:SC0[0]:HE1:SE1] takes:
     (xtime_lock){+...}, at: [<c0143217>] tick_do_update_jiffies64+0x17/0xd0

All these problems are gone with this patch, we now properly get notified of
CPU dead events and properly use/unuse register/unregister the clockevent
devices.  The suspend/resume bits of the clockevents code survived from a
really old version and only worked by miracle.  It's now pretty OK. 
Suspend/resume with high-res and dynticks enabled was successfully tested on
multiple boxes, including SMP ones.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clockchips.h   |    2 -
 kernel/hrtimer.c             |    1 
 kernel/time/clockevents.c    |   35 ++++++++++++-----------
 kernel/time/tick-broadcast.c |   49 ++++++++++++++++++++++-----------
 kernel/time/tick-common.c    |   28 ++++++++++++++++--
 kernel/time/tick-internal.h  |   20 +++----------
 kernel/time/tick-sched.c     |    2 +
 kernel/timer.c               |    2 -
 8 files changed, 86 insertions(+), 53 deletions(-)

diff -puN include/linux/clockchips.h~hrt-dynticks-hotplug-fix include/linux/clockchips.h
--- a/include/linux/clockchips.h~hrt-dynticks-hotplug-fix
+++ a/include/linux/clockchips.h
@@ -34,6 +34,7 @@ enum clock_event_nofitiers {
 	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
 	CLOCK_EVT_NOTIFY_SUSPEND,
 	CLOCK_EVT_NOTIFY_RESUME,
+	CLOCK_EVT_NOTIFY_CPU_DEAD,
 };
 
 /*
@@ -129,7 +130,6 @@ extern void clockevents_unregister_notif
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires);
 
-extern void clockevents_resume_events(void);
 extern void clockevents_notify(unsigned long reason, void *arg);
 
 #else
diff -puN kernel/hrtimer.c~hrt-dynticks-hotplug-fix kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrt-dynticks-hotplug-fix
+++ a/kernel/hrtimer.c
@@ -1384,6 +1384,7 @@ static int __cpuinit hrtimer_cpu_notify(
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
 		migrate_hrtimers(cpu);
 		break;
 #endif
diff -puN kernel/time/clockevents.c~hrt-dynticks-hotplug-fix kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~hrt-dynticks-hotplug-fix
+++ a/kernel/time/clockevents.c
@@ -248,26 +248,27 @@ void clockevents_notify(unsigned long re
 {
 	spin_lock(&clockevents_lock);
 	clockevents_do_notify(reason, arg);
-	spin_unlock(&clockevents_lock);
-}
-EXPORT_SYMBOL_GPL(clockevents_notify);
 
-void clockevents_do_resume_events(void *arg)
-{
-	spin_lock(&clockevents_lock);
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	switch (reason) {
+	case CLOCK_EVT_NOTIFY_CPU_DEAD:
+		/*
+		 * Unregister the clock event devices which were
+		 * released from the users in the notify chain.
+		 */
+		while (!list_empty(&clockevents_released)) {
+			struct clock_event_device *dev;
+
+			dev = list_entry(clockevents_released.next,
+					 struct clock_event_device, list);
+			list_del(&dev->list);
+		}
+		break;
+	default:
+		break;
+	}
 	spin_unlock(&clockevents_lock);
 }
-
-/**
- * clockevents_resume_events - resume the active clock devices
- *
- * Called after timekeeping is functional again
- */
-void clockevents_resume_events(void)
-{
-	on_each_cpu(clockevents_do_resume_events, NULL, 0, 1);
-}
+EXPORT_SYMBOL_GPL(clockevents_notify);
 
 #ifdef CONFIG_SYSFS
 
diff -puN kernel/timer.c~hrt-dynticks-hotplug-fix kernel/timer.c
--- a/kernel/timer.c~hrt-dynticks-hotplug-fix
+++ a/kernel/timer.c
@@ -995,7 +995,7 @@ static int timekeeping_resume(struct sys
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
-	clockevents_resume_events();
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 	/* Resume hrtimers */
 	clock_was_set();
 
diff -puN kernel/time/tick-broadcast.c~hrt-dynticks-hotplug-fix kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~hrt-dynticks-hotplug-fix
+++ a/kernel/time/tick-broadcast.c
@@ -261,17 +261,25 @@ void tick_set_periodic_handler(struct cl
 }
 
 /*
- * Called with irqs disabled
+ * Remove a CPU from broadcasting
  */
-void tick_do_resume(int cpu)
+void tick_shutdown_broadcast(unsigned int *cpup)
 {
-	unsigned long reason;
+	struct clock_event_device *bc;
+	unsigned long flags;
+	unsigned int cpu = *cpup;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
-	reason = cpu_isset(cpu, tick_broadcast_mask) ?
-		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
-	tick_do_broadcast_on_off(&reason);
+	bc = tick_broadcast_device.evtdev;
+	cpu_clear(cpu, tick_broadcast_mask);
 
-	tick_oneshot_resume(cpu);
+	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
+		if (bc && cpus_empty(tick_broadcast_mask))
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	}
+
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
 #ifdef CONFIG_TICK_ONESHOT
@@ -434,16 +442,27 @@ void tick_broadcast_switch_to_oneshot(vo
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-/**
- * Called with irqs disabled
+
+/*
+ * Remove a dead CPU from broadcasting
  */
-void tick_oneshot_resume(int cpu)
+void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 {
-	unsigned long reason;
+	struct clock_event_device *bc;
+	unsigned long flags;
+	unsigned int cpu = *cpup;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	bc = tick_broadcast_device.evtdev;
+	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+
+	if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT) {
+		if (bc && cpus_empty(tick_broadcast_oneshot_mask))
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	}
 
-	reason = cpu_isset(cpu, tick_broadcast_oneshot_mask) ?
-		CLOCK_EVT_NOTIFY_BROADCAST_ENTER :
-		CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
-	tick_broadcast_oneshot_control(reason);
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
+
 #endif
diff -puN kernel/time/tick-common.c~hrt-dynticks-hotplug-fix kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~hrt-dynticks-hotplug-fix
+++ a/kernel/time/tick-common.c
@@ -271,14 +271,29 @@ out:
 }
 
 /*
- * Resume tick devices
+ * Shutdown an event device on a given cpu:
+ *
+ * This is called on a life CPU, when a CPU is dead. So we cannot
+ * access the hardware device itself.
+ * We just set the mode and remove it from the lists.
  */
-static void tick_resume(void)
+static void tick_shutdown(unsigned int *cpup)
 {
+	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
+	struct clock_event_device *dev = td->evtdev;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	tick_do_resume(smp_processor_id());
+	td->mode = TICKDEV_MODE_PERIODIC;
+	if (dev) {
+		/*
+		 * Prevent that the clock events layer tries to call
+		 * the set mode function!
+		 */
+		dev->mode = CLOCK_EVT_MODE_UNUSED;
+		clockevents_exchange_device(dev, NULL);
+		td->evtdev = NULL;
+	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -305,7 +320,12 @@ static int tick_notify(struct notifier_b
 
 	case CLOCK_EVT_NOTIFY_RESUME:
 		tick_resume_jiffy_update();
-		tick_resume();
+		break;
+
+	case CLOCK_EVT_NOTIFY_CPU_DEAD:
+		tick_shutdown_broadcast_oneshot(dev);
+		tick_shutdown_broadcast(dev);
+		tick_shutdown(dev);
 		break;
 
 	default:
diff -puN kernel/time/tick-internal.h~hrt-dynticks-hotplug-fix kernel/time/tick-internal.h
--- a/kernel/time/tick-internal.h~hrt-dynticks-hotplug-fix
+++ a/kernel/time/tick-internal.h
@@ -20,12 +20,12 @@ extern void tick_resume_jiffy_update(voi
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
-extern void tick_oneshot_resume(int cpu);
 
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
 extern void tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
+extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -33,6 +33,7 @@ static inline void tick_broadcast_setup_
 }
 static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
+static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -48,13 +49,13 @@ static inline int tick_program_event(kti
 	return 0;
 }
 static inline void tick_resume_jiffy_update(void) { }
-static inline void tick_oneshot_resume(int cpu) { }
 static inline void tick_oneshot_notify(void) { }
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
 static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 #endif /* !TICK_ONESHOT */
 
 /*
@@ -67,10 +68,10 @@ extern int tick_device_uses_broadcast(st
 extern int tick_check_broadcast_device(struct clock_event_device *dev);
 extern int tick_is_broadcast_device(struct clock_event_device *dev);
 extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
+extern void tick_shutdown_broadcast(unsigned int *cpup);
 
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
-extern void tick_do_resume(int cpu);
 
 #else /* !BROADCAST */
 
@@ -90,6 +91,7 @@ static inline int tick_device_uses_broad
 }
 static inline void tick_do_periodic_broadcast(struct clock_event_device *d) { }
 static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
+static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
 
 /*
  * Set the periodic handler in non broadcast mode
@@ -99,18 +101,6 @@ static inline void tick_set_periodic_han
 {
 	dev->event_handler = tick_handle_periodic;
 }
-/*
- * Called with irqs disabled
- */
-static inline void tick_do_resume(int cpu)
-{
-	struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
-
-	if (td->mode == TICKDEV_MODE_PERIODIC)
-		tick_setup_periodic(td->evtdev, 0);
-	else
-		tick_oneshot_resume(cpu);
-}
 #endif /* !BROADCAST */
 
 /*
diff -puN kernel/time/tick-sched.c~hrt-dynticks-hotplug-fix kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~hrt-dynticks-hotplug-fix
+++ a/kernel/time/tick-sched.c
@@ -502,6 +502,8 @@ void tick_cancel_sched_timer(int cpu)
 
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
+	ts->tick_stopped = 0;
+	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

bugfixes-pci-devices-get-assigned-redundant-irqs.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
hrt-dynticks-hotplug-fix.patch
hrt-dynticks-hotplug-fix-fix.patch
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
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
