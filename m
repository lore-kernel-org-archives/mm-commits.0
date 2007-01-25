From: akpm@osdl.org
Subject: + tick-management-core-functionality.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:47 -0800
Message-ID: <200701250636.l0P6alqE008370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50762 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965623AbXAYGps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     tick-management: core functionality
has been added to the -mm tree.  Its filename is
     tick-management-core-functionality.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tick-management: core functionality
From: Thomas Gleixner <tglx@linutronix.de>,
      Ingo Molnar <mingo@elte.hu>

The tick-management code is the first user of the clockevents layer.  It takes
clock event devices from the clock events core and uses them to provide the
periodic tick.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/tick.h      |   25 +++
 init/main.c               |    2 
 kernel/time/Makefile      |    3 
 kernel/time/tick-common.c |  273 ++++++++++++++++++++++++++++++++++++
 4 files changed, 302 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/tick.h
--- /dev/null
+++ a/include/linux/tick.h
@@ -0,0 +1,25 @@
+/*  linux/include/linux/tick.h
+ *
+ *  This file contains the structure definitions for tick related functions
+ *
+ */
+#ifndef _LINUX_TICK_H
+#define _LINUX_TICK_H
+
+#include <linux/clockchips.h>
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+enum tick_device_mode {
+	TICKDEV_MODE_PERIODIC,
+	TICKDEV_MODE_ONESHOT,
+};
+
+struct tick_device {
+	struct clock_event_device *evtdev;
+	enum tick_device_mode mode;
+};
+
+extern void __init tick_init(void);
+
+#endif
diff -puN init/main.c~tick-management-core-functionality init/main.c
--- a/init/main.c~tick-management-core-functionality
+++ a/init/main.c
@@ -40,6 +40,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/efi.h>
+#include <linux/tick.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
 #include <linux/unistd.h>
@@ -498,6 +499,7 @@ asmlinkage void __init start_kernel(void
  * enable them
  */
 	lock_kernel();
+	tick_init();
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
diff -puN kernel/time/Makefile~tick-management-core-functionality kernel/time/Makefile
--- a/kernel/time/Makefile~tick-management-core-functionality
+++ a/kernel/time/Makefile
@@ -1,3 +1,4 @@
 obj-y += ntp.o clocksource.o jiffies.o
 
-obj-$(CONFIG_GENERIC_CLOCKEVENTS) += clockevents.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= clockevents.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= tick-common.o
diff -puN /dev/null kernel/time/tick-common.c
--- /dev/null
+++ a/kernel/time/tick-common.c
@@ -0,0 +1,273 @@
+/*
+ * linux/kernel/time/tick-common.c
+ *
+ * This file contains the base functions to manage periodic tick
+ * related events.
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
+/*
+ * Tick devices
+ */
+static DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
+/*
+ * Tick next event: keeps track of the tick time
+ */
+static ktime_t tick_next_period;
+static ktime_t tick_period;
+static int tick_do_timer_cpu = -1;
+static DEFINE_SPINLOCK(tick_device_lock);
+
+/*
+ * Periodic tick
+ */
+static void tick_periodic(int cpu)
+{
+	if (tick_do_timer_cpu == cpu) {
+		write_seqlock(&xtime_lock);
+
+		/* Keep track of the next tick event */
+		tick_next_period = ktime_add(tick_next_period, tick_period);
+
+		do_timer(1);
+		write_sequnlock(&xtime_lock);
+	}
+
+	update_process_times(user_mode(get_irq_regs()));
+	profile_tick(CPU_PROFILING);
+}
+
+/*
+ * Event handler for periodic ticks
+ */
+void tick_handle_periodic(struct clock_event_device *dev)
+{
+	int cpu = smp_processor_id();
+
+	tick_periodic(cpu);
+
+	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
+		return;
+	/*
+	 * Setup the next period for devices, which do not have
+	 * periodic mode:
+	 */
+	for (;;) {
+		ktime_t next = ktime_add(dev->next_event, tick_period);
+
+		if (!clockevents_program_event(dev, next))
+			return;
+		tick_periodic(cpu);
+	}
+}
+
+/*
+ * Setup the device for a periodic tick
+ */
+void tick_setup_periodic(struct clock_event_device *dev)
+{
+	dev->event_handler = tick_handle_periodic;
+
+	if (dev->features & CLOCK_EVT_FEAT_PERIODIC) {
+		clockevents_set_mode(dev, CLOCK_EVT_MODE_PERIODIC);
+	} else {
+		unsigned long seq;
+		ktime_t next;
+
+		do {
+			seq = read_seqbegin(&xtime_lock);
+			next = tick_next_period;
+		} while (read_seqretry(&xtime_lock, seq));
+
+		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+
+		for (;;) {
+			if (!clockevents_program_event(dev, next))
+				return;
+			next = ktime_add(next, tick_period);
+		}
+	}
+}
+
+/*
+ * Setup the tick device
+ */
+static void tick_setup_device(struct tick_device *td,
+			      struct clock_event_device *newdev, int cpu,
+			      cpumask_t cpumask)
+{
+	ktime_t next_event;
+	void (*handler)(struct clock_event_device *) = NULL;
+
+	/*
+	 * First device setup ?
+	 */
+	if (!td->evtdev) {
+		/*
+		 * If no cpu took the do_timer update, assign it to
+		 * this cpu:
+		 */
+		if (tick_do_timer_cpu == -1) {
+			tick_do_timer_cpu = cpu;
+			tick_next_period = ktime_get();
+			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
+		}
+
+		/*
+		 * Startup in periodic mode first.
+		 */
+		td->mode = TICKDEV_MODE_PERIODIC;
+	} else {
+		handler = td->evtdev->event_handler;
+		next_event = td->evtdev->next_event;
+	}
+
+	td->evtdev = newdev;
+
+	/*
+	 * When the device is not per cpu, pin the interrupt to the
+	 * current cpu:
+	 */
+	if (!cpus_equal(newdev->cpumask, cpumask))
+		irq_set_affinity(newdev->irq, cpumask);
+
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(newdev, 0);
+}
+
+/*
+ * Check, if the new registered device should be used.
+ */
+static int tick_check_new_device(struct clock_event_device *newdev)
+{
+	struct clock_event_device *curdev;
+	struct tick_device *td;
+	int cpu, ret = NOTIFY_OK;
+	unsigned long flags;
+	cpumask_t cpumask;
+
+	spin_lock_irqsave(&tick_device_lock, flags);
+
+	cpu = smp_processor_id();
+	if (!cpu_isset(cpu, newdev->cpumask))
+		goto out;
+
+	td = &per_cpu(tick_cpu_device, cpu);
+	curdev = td->evtdev;
+	cpumask = cpumask_of_cpu(cpu);
+
+	/* cpu local device ? */
+	if (!cpus_equal(newdev->cpumask, cpumask)) {
+
+		/*
+		 * If the cpu affinity of the device interrupt can not
+		 * be set, ignore it.
+		 */
+		if (!irq_can_set_affinity(newdev->irq))
+			goto out_bc;
+
+		/*
+		 * If we have a cpu local device already, do not replace it
+		 * by a non cpu local device
+		 */
+		if (curdev && cpus_equal(curdev->cpumask, cpumask))
+			goto out_bc;
+	}
+
+	/*
+	 * If we have an active device, then check the rating and the oneshot
+	 * feature.
+	 */
+	if (curdev) {
+		/*
+		 * Check the rating
+		 */
+		if (curdev->rating >= newdev->rating)
+			goto out;
+	}
+
+	/*
+	 * Replace the eventually existing device by the new
+	 * device.
+	 */
+	clockevents_exchange_device(curdev, newdev);
+	tick_setup_device(td, newdev, cpu, cpumask);
+	ret = NOTIFY_STOP;
+
+out:
+	spin_unlock_irqrestore(&tick_device_lock, flags);
+	return ret;
+}
+
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
+
+/*
+ * Resume tick devices
+ */
+static void tick_resume(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_device_lock, flags);
+	tick_do_resume(smp_processor_id());
+	spin_unlock_irqrestore(&tick_device_lock, flags);
+}
+
+/*
+ * Notification about clock event devices
+ */
+static int tick_notify(struct notifier_block *nb, unsigned long reason,
+			       void *dev)
+{
+	switch (reason) {
+
+	case CLOCK_EVT_NOTIFY_ADD:
+		return tick_check_new_device(dev);
+
+	case CLOCK_EVT_NOTIFY_RESUME:
+		tick_resume();
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tick_notifier = {
+	.notifier_call = tick_notify,
+};
+
+/**
+ * tick_init - initialize the tick control
+ *
+ * Register the notifier with the clockevents framework
+ */
+void __init tick_init(void)
+{
+	clockevents_register_notifier(&tick_notifier);
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
