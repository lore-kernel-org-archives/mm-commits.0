From: akpm@linux-foundation.org
Subject: + fix-suspend-resume-with-periodic-tick-devices.patch added to -mm tree
Date: Mon, 05 Mar 2007 23:41:14 -0800
Message-ID: <200703060741.l267fEAs015756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933980AbXCFHl3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 02:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     fix suspend/resume with periodic tick devices
has been added to the -mm tree.  Its filename is
     fix-suspend-resume-with-periodic-tick-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix suspend/resume with periodic tick devices
From: Thomas Gleixner <tglx@linutronix.de>

The programming of periodic tick devices needs to be saved/restored across
suspend/resume - otherwise we might end up with a system coming up that
relies on getting a PIT (or HPET) interrupt, while those devices default to
'no interrupts' after powerup.  (To confuse things it worked to a certain
degree on some systems because the lapic gets initialized as a side-effect
of SMP bootup.)

This suspend / resume thing was dropped unintentionally during the
last-minute -mm code reshuffling.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |   36 +++++++++++++++++++++++++++++++++
 kernel/time/tick-common.c    |   32 +++++++++++++++++++++++++++++
 kernel/time/tick-internal.h  |    4 +++
 kernel/timer.c               |    6 +++++
 4 files changed, 78 insertions(+)

diff -puN kernel/timer.c~fix-suspend-resume-with-periodic-tick-devices kernel/timer.c
--- a/kernel/timer.c~fix-suspend-resume-with-periodic-tick-devices
+++ a/kernel/timer.c
@@ -997,6 +997,9 @@ static int timekeeping_resume(struct sys
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+
 	/* Resume hrtimers */
 	clock_was_set();
 
@@ -1011,6 +1014,9 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspended = 1;
 	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
 	return 0;
 }
 
diff -puN kernel/time/tick-broadcast.c~fix-suspend-resume-with-periodic-tick-devices kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~fix-suspend-resume-with-periodic-tick-devices
+++ a/kernel/time/tick-broadcast.c
@@ -284,6 +284,42 @@ void tick_shutdown_broadcast(unsigned in
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+void tick_suspend_broadcast(void)
+{
+	struct clock_event_device *bc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	bc = tick_broadcast_device.evtdev;
+	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+int tick_resume_broadcast(void)
+{
+	struct clock_event_device *bc;
+	unsigned long flags;
+	int broadcast = 0;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	bc = tick_broadcast_device.evtdev;
+	if (bc) {
+		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC &&
+		    !cpus_empty(tick_broadcast_mask))
+			tick_broadcast_start_periodic(bc);
+
+		broadcast = cpu_isset(smp_processor_id(), tick_broadcast_mask);
+	}
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+
+	return broadcast;
+}
+
+
 #ifdef CONFIG_TICK_ONESHOT
 
 static cpumask_t tick_broadcast_oneshot_mask;
diff -puN kernel/time/tick-common.c~fix-suspend-resume-with-periodic-tick-devices kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~fix-suspend-resume-with-periodic-tick-devices
+++ a/kernel/time/tick-common.c
@@ -298,6 +298,28 @@ static void tick_shutdown(unsigned int *
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
+static void tick_suspend_periodic(void)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_device_lock, flags);
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
+	spin_unlock_irqrestore(&tick_device_lock, flags);
+}
+
+static void tick_resume_periodic(void)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_device_lock, flags);
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(td->evtdev, 0);
+	spin_unlock_irqrestore(&tick_device_lock, flags);
+}
+
 /*
  * Notification about clock event devices
  */
@@ -325,6 +347,16 @@ static int tick_notify(struct notifier_b
 		tick_shutdown(dev);
 		break;
 
+	case CLOCK_EVT_NOTIFY_SUSPEND:
+		tick_suspend_periodic();
+		tick_suspend_broadcast();
+		break;
+
+	case CLOCK_EVT_NOTIFY_RESUME:
+		if (!tick_resume_broadcast())
+			tick_resume_periodic();
+		break;
+
 	default:
 		break;
 	}
diff -puN kernel/time/tick-internal.h~fix-suspend-resume-with-periodic-tick-devices kernel/time/tick-internal.h
--- a/kernel/time/tick-internal.h~fix-suspend-resume-with-periodic-tick-devices
+++ a/kernel/time/tick-internal.h
@@ -67,6 +67,8 @@ extern int tick_check_broadcast_device(s
 extern int tick_is_broadcast_device(struct clock_event_device *dev);
 extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
 extern void tick_shutdown_broadcast(unsigned int *cpup);
+extern void tick_suspend_broadcast(void);
+extern int tick_resume_broadcast(void);
 
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
@@ -90,6 +92,8 @@ static inline int tick_device_uses_broad
 static inline void tick_do_periodic_broadcast(struct clock_event_device *d) { }
 static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
 static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
+static inline void tick_suspend_broadcast(void) { }
+static inline int tick_resume_broadcast(void) { return 0; }
 
 /*
  * Set the periodic handler in non broadcast mode
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
paravirt-build-fixes.patch
fix-suspend-resume-with-periodic-tick-devices.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
hrtimers-hrtimer_clock_base-description-typo.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
fix-vsyscall-settimeofday.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
