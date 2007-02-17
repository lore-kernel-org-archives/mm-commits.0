From: akpm@linux-foundation.org
Subject: - clockevents-add-core-functionality.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:43 -0800
Message-ID: <200702170714.l1H7EhmS021546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50962 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946429AbXBQHPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clockevents: add core functionality
has been removed from the -mm tree.  Its filename was
     clockevents-add-core-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clockevents: add core functionality
From: Thomas Gleixner <tglx@linutronix.de>

Architectures register their clock event devices, in the clock events core. 
Users of the clockevents core can get clock event devices for their use.  The
clockevents core code provides notification mechanisms for various clock
related management events.

This allows to control the clock event devices without the architectures
having to worry about the details of function assignment.  This is also a
preliminary for high resolution timers and dynamic ticks to allow the core
code to control the clock functionality without intrusive changes to the
architecture code.

[Fixes-by: Ingo Molnar <mingo@elte.hu>]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clockchips.h |  142 ++++++++++++++
 include/linux/hrtimer.h    |    5 
 kernel/hrtimer.c           |   13 -
 kernel/time/Makefile       |    2 
 kernel/time/clockevents.c  |  345 +++++++++++++++++++++++++++++++++++
 kernel/timer.c             |    4 
 6 files changed, 497 insertions(+), 14 deletions(-)

diff -puN /dev/null include/linux/clockchips.h
--- /dev/null
+++ a/include/linux/clockchips.h
@@ -0,0 +1,142 @@
+/*  linux/include/linux/clockchips.h
+ *
+ *  This file contains the structure definitions for clockchips.
+ *
+ *  If you are not a clockchip, or the time of day code, you should
+ *  not be including this file!
+ */
+#ifndef _LINUX_CLOCKCHIPS_H
+#define _LINUX_CLOCKCHIPS_H
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+#include <linux/clocksource.h>
+#include <linux/cpumask.h>
+#include <linux/ktime.h>
+#include <linux/notifier.h>
+
+struct clock_event_device;
+
+/* Clock event mode commands */
+enum clock_event_mode {
+	CLOCK_EVT_MODE_UNUSED = 0,
+	CLOCK_EVT_MODE_SHUTDOWN,
+	CLOCK_EVT_MODE_PERIODIC,
+	CLOCK_EVT_MODE_ONESHOT,
+};
+
+/* Clock event notification values */
+enum clock_event_nofitiers {
+	CLOCK_EVT_NOTIFY_ADD,
+	CLOCK_EVT_NOTIFY_BROADCAST_ON,
+	CLOCK_EVT_NOTIFY_BROADCAST_OFF,
+	CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
+	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
+	CLOCK_EVT_NOTIFY_SUSPEND,
+	CLOCK_EVT_NOTIFY_RESUME,
+	CLOCK_EVT_NOTIFY_CPU_DEAD,
+};
+
+/*
+ * Clock event features
+ */
+#define CLOCK_EVT_FEAT_PERIODIC		0x000001
+#define CLOCK_EVT_FEAT_ONESHOT		0x000002
+/*
+ * x86(64) specific misfeatures:
+ *
+ * - Clockevent source stops in C3 State and needs broadcast support.
+ * - Local APIC timer is used as a dummy device.
+ */
+#define CLOCK_EVT_FEAT_C3STOP		0x000004
+#define CLOCK_EVT_FEAT_DUMMY		0x000008
+
+/**
+ * struct clock_event_device - clock event device descriptor
+ * @name:		ptr to clock event name
+ * @hints:		usage hints
+ * @max_delta_ns:	maximum delta value in ns
+ * @min_delta_ns:	minimum delta value in ns
+ * @mult:		nanosecond to cycles multiplier
+ * @shift:		nanoseconds to cycles divisor (power of two)
+ * @rating:		variable to rate clock event devices
+ * @irq:		irq number (only for non cpu local devices)
+ * @cpumask:		cpumask to indicate for which cpus this device works
+ * @set_next_event:	set next event
+ * @set_mode:		set mode function
+ * @evthandler:		Assigned by the framework to be called by the low
+ *			level handler of the event source
+ * @broadcast:		function to broadcast events
+ * @list:		list head for the management code
+ * @mode:		operating mode assigned by the management code
+ * @next_event:		local storage for the next event in oneshot mode
+ */
+struct clock_event_device {
+	const char		*name;
+	unsigned int		features;
+	unsigned long		max_delta_ns;
+	unsigned long		min_delta_ns;
+	unsigned long		mult;
+	int			shift;
+	int			rating;
+	int			irq;
+	cpumask_t		cpumask;
+	int			(*set_next_event)(unsigned long evt,
+						  struct clock_event_device *);
+	void			(*set_mode)(enum clock_event_mode mode,
+					    struct clock_event_device *);
+	void			(*event_handler)(struct clock_event_device *);
+	void			(*broadcast)(cpumask_t mask);
+	struct list_head	list;
+	enum clock_event_mode	mode;
+	ktime_t			next_event;
+};
+
+/*
+ * Calculate a multiplication factor for scaled math, which is used to convert
+ * nanoseconds based values to clock ticks:
+ *
+ * clock_ticks = (nanoseconds * factor) >> shift.
+ *
+ * div_sc is the rearranged equation to calculate a factor from a given clock
+ * ticks / nanoseconds ratio:
+ *
+ * factor = (clock_ticks << shift) / nanoseconds
+ */
+static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
+				   int shift)
+{
+	uint64_t tmp = ((uint64_t)ticks) << shift;
+
+	do_div(tmp, nsec);
+	return (unsigned long) tmp;
+}
+
+/* Clock event layer functions */
+extern unsigned long clockevent_delta2ns(unsigned long latch,
+					 struct clock_event_device *evt);
+extern void clockevents_register_device(struct clock_event_device *dev);
+
+extern void clockevents_exchange_device(struct clock_event_device *old,
+					struct clock_event_device *new);
+extern
+struct clock_event_device *clockevents_request_device(unsigned int features,
+						      cpumask_t cpumask);
+extern void clockevents_release_device(struct clock_event_device *dev);
+extern void clockevents_set_mode(struct clock_event_device *dev,
+				 enum clock_event_mode mode);
+extern int clockevents_register_notifier(struct notifier_block *nb);
+extern void clockevents_unregister_notifier(struct notifier_block *nb);
+extern int clockevents_program_event(struct clock_event_device *dev,
+				     ktime_t expires, ktime_t now);
+
+extern void clockevents_notify(unsigned long reason, void *arg);
+
+#else
+
+static inline void clockevents_resume_events(void) { }
+#define clockevents_notify(reason, arg) do { } while (0)
+
+#endif
+
+#endif
diff -puN include/linux/hrtimer.h~clockevents-add-core-functionality include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~clockevents-add-core-functionality
+++ a/include/linux/hrtimer.h
@@ -144,6 +144,8 @@ struct hrtimer_cpu_base {
  * is expired in the next softirq when the clock was advanced.
  */
 #define clock_was_set()		do { } while (0)
+extern ktime_t ktime_get(void);
+extern ktime_t ktime_get_real(void);
 
 /* Exported timer functions: */
 
@@ -196,9 +198,6 @@ extern void hrtimer_init_sleeper(struct 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
 
-/* Resume notification */
-void hrtimer_notify_resume(void);
-
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
diff -puN kernel/hrtimer.c~clockevents-add-core-functionality kernel/hrtimer.c
--- a/kernel/hrtimer.c~clockevents-add-core-functionality
+++ a/kernel/hrtimer.c
@@ -46,7 +46,7 @@
  *
  * returns the time in ktime_t format
  */
-static ktime_t ktime_get(void)
+ktime_t ktime_get(void)
 {
 	struct timespec now;
 
@@ -60,7 +60,7 @@ static ktime_t ktime_get(void)
  *
  * returns the time in ktime_t format
  */
-static ktime_t ktime_get_real(void)
+ktime_t ktime_get_real(void)
 {
 	struct timespec now;
 
@@ -311,14 +311,6 @@ static unsigned long ktime_divns(const k
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
- * Timekeeping resumed notification
- */
-void hrtimer_notify_resume(void)
-{
-	clock_was_set();
-}
-
-/*
  * Counterpart to lock_timer_base above:
  */
 static inline
@@ -889,6 +881,7 @@ static int __cpuinit hrtimer_cpu_notify(
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
 		migrate_hrtimers(cpu);
 		break;
 #endif
diff -puN kernel/time/Makefile~clockevents-add-core-functionality kernel/time/Makefile
--- a/kernel/time/Makefile~clockevents-add-core-functionality
+++ a/kernel/time/Makefile
@@ -1 +1,3 @@
 obj-y += ntp.o clocksource.o jiffies.o
+
+obj-$(CONFIG_GENERIC_CLOCKEVENTS) += clockevents.o
diff -puN /dev/null kernel/time/clockevents.c
--- /dev/null
+++ a/kernel/time/clockevents.c
@@ -0,0 +1,345 @@
+/*
+ * linux/kernel/time/clockevents.c
+ *
+ * This file contains functions which manage clock event devices.
+ *
+ * Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
+ * Copyright(C) 2006-2007, Timesys Corp., Thomas Gleixner
+ *
+ * This code is licenced under the GPL version 2. For details see
+ * kernel-base/COPYING.
+ */
+
+#include <linux/clockchips.h>
+#include <linux/hrtimer.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/smp.h>
+#include <linux/sysdev.h>
+
+/* The registered clock event devices */
+static LIST_HEAD(clockevent_devices);
+static LIST_HEAD(clockevents_released);
+
+/* Notification for clock events */
+static RAW_NOTIFIER_HEAD(clockevents_chain);
+
+/* Protection for the above */
+static DEFINE_SPINLOCK(clockevents_lock);
+
+/**
+ * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
+ * @latch:	value to convert
+ * @evt:	pointer to clock event device descriptor
+ *
+ * Math helper, returns latch value converted to nanoseconds (bound checked)
+ */
+unsigned long clockevent_delta2ns(unsigned long latch,
+				  struct clock_event_device *evt)
+{
+	u64 clc = ((u64) latch << evt->shift);
+
+	do_div(clc, evt->mult);
+	if (clc < 1000)
+		clc = 1000;
+	if (clc > LONG_MAX)
+		clc = LONG_MAX;
+
+	return (unsigned long) clc;
+}
+
+/**
+ * clockevents_set_mode - set the operating mode of a clock event device
+ * @dev:	device to modify
+ * @mode:	new mode
+ *
+ * Must be called with interrupts disabled !
+ */
+void clockevents_set_mode(struct clock_event_device *dev,
+				 enum clock_event_mode mode)
+{
+	if (dev->mode != mode) {
+		dev->set_mode(mode, dev);
+		dev->mode = mode;
+	}
+}
+
+/**
+ * clockevents_program_event - Reprogram the clock event device.
+ * @expires:	absolute expiry time (monotonic clock)
+ *
+ * Returns 0 on success, -ETIME when the event is in the past.
+ */
+int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
+			      ktime_t now)
+{
+	unsigned long long clc;
+	int64_t delta;
+
+	delta = ktime_to_ns(ktime_sub(expires, now));
+
+	if (delta <= 0)
+		return -ETIME;
+
+	dev->next_event = expires;
+
+	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
+		return 0;
+
+	if (delta > dev->max_delta_ns)
+		delta = dev->max_delta_ns;
+	if (delta < dev->min_delta_ns)
+		delta = dev->min_delta_ns;
+
+	clc = delta * dev->mult;
+	clc >>= dev->shift;
+
+	return dev->set_next_event((unsigned long) clc, dev);
+}
+
+/**
+ * clockevents_register_notifier - register a clock events change listener
+ */
+int clockevents_register_notifier(struct notifier_block *nb)
+{
+	int ret;
+
+	spin_lock(&clockevents_lock);
+	ret = raw_notifier_chain_register(&clockevents_chain, nb);
+	spin_unlock(&clockevents_lock);
+
+	return ret;
+}
+
+/**
+ * clockevents_unregister_notifier - unregister a clock events change listener
+ */
+void clockevents_unregister_notifier(struct notifier_block *nb)
+{
+	spin_lock(&clockevents_lock);
+	raw_notifier_chain_unregister(&clockevents_chain, nb);
+	spin_unlock(&clockevents_lock);
+}
+
+/*
+ * Notify about a clock event change. Called with clockevents_lock
+ * held.
+ */
+static void clockevents_do_notify(unsigned long reason, void *dev)
+{
+	raw_notifier_call_chain(&clockevents_chain, reason, dev);
+}
+
+/*
+ * Called after a notify add to make devices availble which were
+ * released from the notifier call.
+ */
+static void clockevents_notify_released(void)
+{
+	struct clock_event_device *dev;
+
+	while (!list_empty(&clockevents_released)) {
+		dev = list_entry(clockevents_released.next,
+				 struct clock_event_device, list);
+		list_del(&dev->list);
+		list_add(&dev->list, &clockevent_devices);
+		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+	}
+}
+
+/**
+ * clockevents_register_device - register a clock event device
+ * @dev:	device to register
+ */
+void clockevents_register_device(struct clock_event_device *dev)
+{
+	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
+
+	spin_lock(&clockevents_lock);
+
+	list_add(&dev->list, &clockevent_devices);
+	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+	clockevents_notify_released();
+
+	spin_unlock(&clockevents_lock);
+}
+
+/*
+ * Noop handler when we shut down an event device
+ */
+static void clockevents_handle_noop(struct clock_event_device *dev)
+{
+}
+
+/**
+ * clockevents_exchange_device - release and request clock devices
+ * @old:	device to release (can be NULL)
+ * @new:	device to request (can be NULL)
+ *
+ * Called from the notifier chain. clockevents_lock is held already
+ */
+void clockevents_exchange_device(struct clock_event_device *old,
+				 struct clock_event_device *new)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	/*
+	 * Caller releases a clock event device. We queue it into the
+	 * released list and do a notify add later.
+	 */
+	if (old) {
+		old->event_handler = clockevents_handle_noop;
+		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
+		list_del(&old->list);
+		list_add(&old->list, &clockevents_released);
+	}
+
+	if (new) {
+		BUG_ON(new->mode != CLOCK_EVT_MODE_UNUSED);
+		clockevents_set_mode(new, CLOCK_EVT_MODE_SHUTDOWN);
+	}
+	local_irq_restore(flags);
+}
+
+/**
+ * clockevents_request_device
+ */
+struct clock_event_device *clockevents_request_device(unsigned int features,
+						      cpumask_t cpumask)
+{
+	struct clock_event_device *cur, *dev = NULL;
+	struct list_head *tmp;
+
+	spin_lock(&clockevents_lock);
+
+	list_for_each(tmp, &clockevent_devices) {
+		cur = list_entry(tmp, struct clock_event_device, list);
+
+		if ((cur->features & features) == features &&
+		    cpus_equal(cpumask, cur->cpumask)) {
+			if (!dev || dev->rating < cur->rating)
+				dev = cur;
+		}
+	}
+
+	clockevents_exchange_device(NULL, dev);
+
+	spin_unlock(&clockevents_lock);
+
+	return dev;
+}
+
+/**
+ * clockevents_release_device
+ */
+void clockevents_release_device(struct clock_event_device *dev)
+{
+	spin_lock(&clockevents_lock);
+
+	clockevents_exchange_device(dev, NULL);
+	clockevents_notify_released();
+
+	spin_unlock(&clockevents_lock);
+}
+
+/**
+ * clockevents_notify - notification about relevant events
+ */
+void clockevents_notify(unsigned long reason, void *arg)
+{
+	spin_lock(&clockevents_lock);
+	clockevents_do_notify(reason, arg);
+
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
+	spin_unlock(&clockevents_lock);
+}
+EXPORT_SYMBOL_GPL(clockevents_notify);
+
+#ifdef CONFIG_SYSFS
+
+/**
+ * clockevents_show_registered - sysfs interface for listing clockevents
+ * @dev:	unused
+ * @buf:	char buffer to be filled with clock events list
+ *
+ * Provides sysfs interface for listing registered clock event devices
+ */
+static ssize_t clockevents_show_registered(struct sys_device *dev, char *buf)
+{
+	struct list_head *tmp;
+	char *p = buf;
+	int cpu;
+
+	spin_lock(&clockevents_lock);
+
+	list_for_each(tmp, &clockevent_devices) {
+		struct clock_event_device *ce;
+
+		ce = list_entry(tmp, struct clock_event_device, list);
+		p += sprintf(p, "%-20s F:%04x M:%d", ce->name,
+			     ce->features, ce->mode);
+		p += sprintf(p, " C:");
+		if (!cpus_equal(ce->cpumask, cpu_possible_map)) {
+			for_each_cpu_mask(cpu, ce->cpumask)
+				p += sprintf(p, " %d", cpu);
+		} else {
+			/*
+			 * FIXME: Add the cpu which is handling this sucker
+			 */
+		}
+		p += sprintf(p, "\n");
+	}
+
+	spin_unlock(&clockevents_lock);
+
+	return p - buf;
+}
+
+/*
+ * Sysfs setup bits:
+ */
+static SYSDEV_ATTR(registered, 0600,
+		   clockevents_show_registered, NULL);
+
+static struct sysdev_class clockevents_sysclass = {
+	set_kset_name("clockevents"),
+};
+
+static struct sys_device clockevents_sys_device = {
+	.id	= 0,
+	.cls	= &clockevents_sysclass,
+};
+
+static int __init clockevents_sysfs_init(void)
+{
+	int error = sysdev_class_register(&clockevents_sysclass);
+
+	if (!error)
+		error = sysdev_register(&clockevents_sys_device);
+	if (!error)
+		error = sysdev_create_file(
+				&clockevents_sys_device,
+				&attr_registered);
+	return error;
+}
+device_initcall(clockevents_sysfs_init);
+#endif
diff -puN kernel/timer.c~clockevents-add-core-functionality kernel/timer.c
--- a/kernel/timer.c~clockevents-add-core-functionality
+++ a/kernel/timer.c
@@ -34,6 +34,7 @@
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
 #include <linux/delay.h>
+#include <linux/clockchips.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -970,7 +971,8 @@ static int timekeeping_resume(struct sys
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
-	hrtimer_notify_resume();
+	/* Resume hrtimers */
+	clock_was_set();
 
 	return 0;
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
