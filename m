From: akpm@osdl.org
Subject: + tick-management-broadcast-functionality.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:49 -0800
Message-ID: <200701250636.l0P6an5R008373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965576AbXAYGit (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     tick-management: broadcast functionality
has been added to the -mm tree.  Its filename is
     tick-management-broadcast-functionality.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tick-management: broadcast functionality
From: Thomas Gleixner <tglx@linutronix.de>,
      Ingo Molnar <mingo@elte.hu>

Add broadcast functionality, so per cpu clock event devices can be registered
as dummy devices or switched from/to broadcast on demand.  The broadcast
function distributes the events via the broadcast function of the clock event
device.  This is primarily designed to replace the switch apic timer to / from
IPI in power states, where the apic stops.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/Makefile         |    5 
 kernel/time/tick-broadcast.c |  258 +++++++++++++++++++++++++++++++++
 kernel/time/tick-common.c    |   63 +++++---
 kernel/time/tick-internal.h  |   74 +++++++++
 4 files changed, 378 insertions(+), 22 deletions(-)

diff -puN kernel/time/Makefile~tick-management-broadcast-functionality kernel/time/Makefile
--- a/kernel/time/Makefile~tick-management-broadcast-functionality
+++ a/kernel/time/Makefile
@@ -1,4 +1,5 @@
 obj-y += ntp.o clocksource.o jiffies.o
 
-obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= clockevents.o
-obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= tick-common.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= clockevents.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
diff -puN /dev/null kernel/time/tick-broadcast.c
--- /dev/null
+++ a/kernel/time/tick-broadcast.c
@@ -0,0 +1,258 @@
+/*
+ * linux/kernel/time/tick-broadcast.c
+ *
+ * This file contains functions which emulate a local clock-event
+ * device via a broadcast event source.
+ *
+ * Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
+ * Copyright(C) 2006-2007, Timesys Corp., Thomas Gleixner
+ *
+ * This code is licenced under the GPL version 2. For details see
+ * kernel-base/COPYING.
+ */
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/hrtimer.h>
+#include <linux/irq.h>
+#include <linux/percpu.h>
+#include <linux/profile.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
+
+#include "tick-internal.h"
+
+/*
+ * Broadcast support for broken x86 hardware, where the local apic
+ * timer stops in C3 state.
+ */
+
+struct tick_device tick_broadcast_device;
+static cpumask_t tick_broadcast_mask;
+DEFINE_SPINLOCK(tick_broadcast_lock);
+
+/*
+ * Start the device in periodic mode
+ */
+static void tick_broadcast_start_periodic(struct clock_event_device *bc)
+{
+	if (bc && bc->mode == CLOCK_EVT_MODE_SHUTDOWN)
+		tick_setup_periodic(bc, 1);
+}
+
+/*
+ * Check, if the device can be utilized as broadcast device:
+ */
+int tick_check_broadcast_device(struct clock_event_device *dev)
+{
+	if (tick_broadcast_device.evtdev ||
+	    (dev->features & CLOCK_EVT_FEAT_C3STOP))
+		return 0;
+
+	clockevents_exchange_device(NULL, dev);
+	tick_broadcast_device.evtdev = dev;
+	if (!cpus_empty(tick_broadcast_mask))
+		tick_broadcast_start_periodic(dev);
+	return 1;
+}
+
+/*
+ * Check, if the device is the broadcast device
+ */
+int tick_is_broadcast_device(struct clock_event_device *dev)
+{
+	return (dev && tick_broadcast_device.evtdev == dev);
+}
+
+/*
+ * Check, if the device is disfunctional and a place holder, which
+ * needs to be handled by the broadcast device.
+ */
+int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	/*
+	 * Devices might be registered with both periodic and oneshot
+	 * mode disabled. This signals, that the device needs to be
+	 * operated from the broadcast device and is a placeholder for
+	 * the cpu local device.
+	 */
+	if (!tick_device_is_functional(dev)) {
+		dev->event_handler = tick_handle_periodic;
+		cpu_set(cpu, tick_broadcast_mask);
+		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
+		ret = 1;
+	}
+
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	return ret;
+}
+
+/*
+ * Broadcast the event to the cpus, which are set in the mask
+ */
+int tick_do_broadcast(cpumask_t mask)
+{
+	int ret = 0, cpu = smp_processor_id();
+	struct tick_device *td;
+
+	/*
+	 * Check, if the current cpu is in the mask
+	 */
+	if (cpu_isset(cpu, mask)) {
+		cpu_clear(cpu, mask);
+		td = &per_cpu(tick_cpu_device, cpu);
+		td->evtdev->event_handler(td->evtdev);
+		ret = 1;
+	}
+
+	if (!cpus_empty(mask)) {
+		/*
+		 * It might be necessary to actually check whether the devices
+		 * have different broadcast functions. For now, just use the
+		 * one of the first device. This works as long as we have this
+		 * misfeature only on x86 (lapic)
+		 */
+		cpu = first_cpu(mask);
+		td = &per_cpu(tick_cpu_device, cpu);
+		td->evtdev->broadcast(mask);
+		ret = 1;
+	}
+	return ret;
+}
+
+/*
+ * Periodic broadcast:
+ * - invoke the broadcast handlers
+ */
+static void tick_do_periodic_broadcast(void)
+{
+	cpumask_t mask;
+
+	spin_lock(&tick_broadcast_lock);
+
+	cpus_and(mask, cpu_online_map, tick_broadcast_mask);
+	tick_do_broadcast(mask);
+
+	spin_unlock(&tick_broadcast_lock);
+}
+
+/*
+ * Event handler for periodic broadcast ticks
+ */
+static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
+{
+	tick_do_periodic_broadcast();
+
+	/*
+	 * The device is in periodic mode. No reprogramming necessary:
+	 */
+	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
+		return;
+
+	/*
+	 * Setup the next period for devices, which do not have
+	 * periodic mode:
+	 */
+	for (;;) {
+		ktime_t next = ktime_add(dev->next_event, tick_period);
+
+		if (!clockevents_program_event(dev, next))
+			return;
+		tick_do_periodic_broadcast();
+	}
+}
+
+/*
+ * Powerstate information: The system enters/leaves a state, where
+ * affected devices might stop
+ */
+static void tick_do_broadcast_on_off(void *why)
+{
+	struct clock_event_device *bc, *dev;
+	struct tick_device *td;
+	unsigned long flags, *reason = why;
+	int cpu;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	cpu = smp_processor_id();
+	td = &per_cpu(tick_cpu_device, cpu);
+	dev = td->evtdev;
+	bc = tick_broadcast_device.evtdev;
+
+	/*
+	 * Is the device in broadcast mode forever or is it not
+	 * affected by the powerstate ?
+	 */
+	if (!dev || !tick_device_is_functional(dev) ||
+	    !(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		goto out;
+
+	if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_ON) {
+		if (!cpu_isset(cpu, tick_broadcast_mask)) {
+			cpu_set(cpu, tick_broadcast_mask);
+			if (td->mode == TICKDEV_MODE_PERIODIC)
+				clockevents_set_mode(dev,
+						     CLOCK_EVT_MODE_SHUTDOWN);
+		}
+	} else {
+		if (cpu_isset(cpu, tick_broadcast_mask)) {
+			cpu_clear(cpu, tick_broadcast_mask);
+			if (td->mode == TICKDEV_MODE_PERIODIC)
+				tick_setup_periodic(dev, 0);
+		}
+	}
+
+	if (cpus_empty(tick_broadcast_mask))
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	else {
+		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+			tick_broadcast_start_periodic(bc);
+	}
+out:
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+/*
+ * Powerstate information: The system enters/leaves a state, where
+ * affected devices might stop.
+ */
+void tick_broadcast_on_off(unsigned long reason, int *oncpu)
+{
+	int cpu = get_cpu();
+
+	if (cpu == *oncpu)
+		tick_do_broadcast_on_off(&reason);
+	else
+		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
+					 &reason, 1, 1);
+	put_cpu();
+}
+
+/*
+ * Set the periodic handler depending on broadcast on/off
+ */
+void tick_set_periodic_handler(struct clock_event_device *dev, int broadcast)
+{
+	if (!broadcast)
+		dev->event_handler = tick_handle_periodic;
+	else
+		dev->event_handler = tick_handle_periodic_broadcast;
+}
+
+/*
+ * Called with irqs disabled
+ */
+void tick_do_resume(int cpu)
+{
+	unsigned long reason;
+
+	reason = cpu_isset(cpu, tick_broadcast_mask) ?
+		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
+	tick_do_broadcast_on_off(&reason);
+}
diff -puN kernel/time/tick-common.c~tick-management-broadcast-functionality kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~tick-management-broadcast-functionality
+++ a/kernel/time/tick-common.c
@@ -20,17 +20,19 @@
 #include <linux/sched.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /*
  * Tick devices
  */
-static DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
+DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
 /*
  * Tick next event: keeps track of the tick time
  */
-static ktime_t tick_next_period;
-static ktime_t tick_period;
+ktime_t tick_next_period;
+ktime_t tick_period;
 static int tick_do_timer_cpu = -1;
-static DEFINE_SPINLOCK(tick_device_lock);
+DEFINE_SPINLOCK(tick_device_lock);
 
 /*
  * Periodic tick
@@ -78,9 +80,13 @@ void tick_handle_periodic(struct clock_e
 /*
  * Setup the device for a periodic tick
  */
-void tick_setup_periodic(struct clock_event_device *dev)
+void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 {
-	dev->event_handler = tick_handle_periodic;
+	tick_set_periodic_handler(dev, broadcast);
+
+	/* Broadcast setup ? */
+	if (!tick_device_is_functional(dev))
+		return;
 
 	if (dev->features & CLOCK_EVT_FEAT_PERIODIC) {
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_PERIODIC);
@@ -145,6 +151,15 @@ static void tick_setup_device(struct tic
 	if (!cpus_equal(newdev->cpumask, cpumask))
 		irq_set_affinity(newdev->irq, cpumask);
 
+	/*
+	 * When global broadcasting is active, check if the current
+	 * device is registered as a placeholder for broadcast mode.
+	 * This allows us to handle this x86 misfeature in a generic
+	 * way.
+	 */
+	if (tick_device_uses_broadcast(newdev, cpu))
+		return;
+
 	if (td->mode == TICKDEV_MODE_PERIODIC)
 		tick_setup_periodic(newdev, 0);
 }
@@ -197,31 +212,34 @@ static int tick_check_new_device(struct 
 		 * Check the rating
 		 */
 		if (curdev->rating >= newdev->rating)
-			goto out;
+			goto out_bc;
 	}
 
 	/*
 	 * Replace the eventually existing device by the new
-	 * device.
+	 * device. If the current device is the broadcast device, do
+	 * not give it back to the clockevents layer !
 	 */
+	if (tick_is_broadcast_device(curdev)) {
+		clockevents_set_mode(curdev, CLOCK_EVT_MODE_SHUTDOWN);
+		curdev = NULL;
+	}
 	clockevents_exchange_device(curdev, newdev);
 	tick_setup_device(td, newdev, cpu, cpumask);
-	ret = NOTIFY_STOP;
 
-out:
 	spin_unlock_irqrestore(&tick_device_lock, flags);
-	return ret;
-}
+	return NOTIFY_STOP;
 
-/*
- * Called with irqs disabled
- */
-static inline void tick_do_resume(int cpu)
-{
-	struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
+out_bc:
+	/*
+	 * Can the new device be used as a broadcast device ?
+	 */
+	if (tick_check_broadcast_device(newdev))
+		ret = NOTIFY_STOP;
+out:
+	spin_unlock_irqrestore(&tick_device_lock, flags);
 
-	if (td->mode == TICKDEV_MODE_PERIODIC)
-		tick_setup_periodic(td->evtdev, 0);
+	return ret;
 }
 
 /*
@@ -247,6 +265,11 @@ static int tick_notify(struct notifier_b
 	case CLOCK_EVT_NOTIFY_ADD:
 		return tick_check_new_device(dev);
 
+	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
+	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
+		tick_broadcast_on_off(reason, dev);
+		break;
+
 	case CLOCK_EVT_NOTIFY_RESUME:
 		tick_resume();
 		break;
diff -puN /dev/null kernel/time/tick-internal.h
--- /dev/null
+++ a/kernel/time/tick-internal.h
@@ -0,0 +1,74 @@
+/*
+ * tick internal variable and functions used by low/high res code
+ */
+DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
+extern spinlock_t tick_device_lock;
+extern ktime_t tick_next_period;
+extern ktime_t tick_period;
+
+extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
+extern void tick_handle_periodic(struct clock_event_device *dev);
+
+/*
+ * Broadcasting support
+ */
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+extern int tick_do_broadcast(cpumask_t mask);
+extern struct tick_device tick_broadcast_device;
+extern spinlock_t tick_broadcast_lock;
+
+extern int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu);
+extern int tick_check_broadcast_device(struct clock_event_device *dev);
+extern int tick_is_broadcast_device(struct clock_event_device *dev);
+extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
+
+extern void
+tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
+extern void tick_do_resume(int cpu);
+
+#else /* !BROADCAST */
+
+static inline int tick_check_broadcast_device(struct clock_event_device *dev)
+{
+	return 0;
+}
+
+static inline int tick_is_broadcast_device(struct clock_event_device *dev)
+{
+	return 0;
+}
+static inline int tick_device_uses_broadcast(struct clock_event_device *dev,
+					     int cpu)
+{
+	return 0;
+}
+static inline void tick_do_periodic_broadcast(struct clock_event_device *d) { }
+static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
+
+/*
+ * Set the periodic handler in non broadcast mode
+ */
+static inline void tick_set_periodic_handler(struct clock_event_device *dev,
+					     int broadcast)
+{
+	dev->event_handler = tick_handle_periodic;
+}
+/*
+ * Called with irqs disabled
+ */
+static inline void tick_do_resume(int cpu)
+{
+	struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
+
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(td->evtdev, 0);
+}
+#endif /* !BROADCAST */
+
+/*
+ * Check, if the device is functional or a dummy for broadcast
+ */
+static inline int tick_device_is_functional(struct clock_event_device *dev)
+{
+	return !(dev->features & CLOCK_EVT_FEAT_DUMMY);
+}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
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
clocksource-add-verification-watchdog-helper-fix.patch
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
