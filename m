From: akpm@osdl.org
Subject: + clockevents-core.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:16 -0800
Message-ID: <200612132244.kBDMiGfl022876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbWLMWor (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     clockevents: core
has been added to the -mm tree.  Its filename is
     clockevents-core.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: core
From: Thomas Gleixner <tglx@linutronix.de>

We add two types of clock event devices:
- global events (one device per system)
- local events (one device per cpu)

We assign the various time(r) related interrupts to those devices:

- global tick (advances jiffies)
- update process times (per cpu)
- profiling (per cpu)
- next timer events (per cpu)

Architectures register their clock event devices, with specific
capability bits set, and the framework code assigns the appropriate
event handler to the event device.  The functionality is assigned via an
event handler to avoid runtime evalutation of the assigned function
bits.

This allows to control the clock event devices without the architectures
having to worry about the details of function assignment.  This is also
a preliminary for high resolution timers and dynamic ticks to allow the
core code to control the clock functionality without intrusive changes
to the architecture code.

For x86 based systems the code provides the ability to broadcast timer
events. This is necessary due to the fact, that the per CPU local APIC
timers are stopped in power saving states.

When high resolution timers and dynamic ticks are disabled, there is no
change in the behaviour of the system.

[Fixes-by: Ingo Molnar <mingo@elte.hu>]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clockchips.h |  168 +++++++
 include/linux/hrtimer.h    |    3 
 init/main.c                |    2 
 kernel/hrtimer.c           |    6 
 kernel/time/Makefile       |    2 
 kernel/time/clockevents.c  |  762 +++++++++++++++++++++++++++++++++++
 6 files changed, 941 insertions(+), 2 deletions(-)

diff -puN /dev/null include/linux/clockchips.h
--- /dev/null
+++ a/include/linux/clockchips.h
@@ -0,0 +1,168 @@
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
+#include <linux/interrupt.h>
+#include <linux/cpumask.h>
+
+struct clock_event_device;
+
+/* Clock event mode commands */
+enum clock_event_mode {
+	CLOCK_EVT_PERIODIC,
+	CLOCK_EVT_ONESHOT,
+	CLOCK_EVT_SHUTDOWN,
+};
+
+/*
+ * Clock event capability flags:
+ *
+ * CAP_TICK:	The event source should be used for the periodic tick
+ * CAP_UPDATE:	The event source handler should call update_process_times()
+ * CAP_PROFILE: The event source handler should call profile_tick()
+ * CAP_NEXTEVT:	The event source can be reprogrammed in oneshot mode and is
+ *		a per cpu event source.
+ *
+ * The capability flags are used to select the appropriate handler for an event
+ * source. On an i386 UP system the PIT can serve all of the functionalities,
+ * while on a SMP system the PIT is solely used for the periodic tick and the
+ * local APIC timers are used for UPDATE / PROFILE / NEXTEVT. To avoid the run
+ * time query of those flags, the clock events layer assigns the appropriate
+ * event handler function, which contains only the selected calls, to the
+ * event.
+ */
+#define CLOCK_CAP_TICK		0x000001
+#define CLOCK_CAP_UPDATE	0x000002
+#define CLOCK_CAP_PROFILE	0x000004
+#ifdef CONFIG_HIGH_RES_TIMERS
+# define CLOCK_CAP_NEXTEVT	0x000008
+#else
+# define CLOCK_CAP_NEXTEVT	0x000000
+#endif
+
+#define CLOCK_BASE_CAPS_MASK	(CLOCK_CAP_TICK | CLOCK_CAP_PROFILE | \
+				 CLOCK_CAP_UPDATE)
+#define CLOCK_CAPS_MASK		(CLOCK_BASE_CAPS_MASK | CLOCK_CAP_NEXTEVT)
+
+/**
+ * struct clock_event_device - clock event descriptor
+ *
+ * @name:		ptr to clock event name
+ * @capabilities:	capabilities of the event chip
+ * @max_delta_ns:	maximum delta value in ns
+ * @min_delta_ns:	minimum delta value in ns
+ * @mult:		nanosecond to cycles multiplier
+ * @shift:		nanoseconds to cycles divisor (power of two)
+ * @set_next_event:	set next event
+ * @set_mode:		set mode function
+ * @suspend:		suspend function (optional)
+ * @resume:		resume function (optional)
+ * @evthandler:		Assigned by the framework to be called by the low
+ *			level handler of the event source
+ */
+struct clock_event_device {
+	const char	*name;
+	unsigned int	capabilities;
+	unsigned long	max_delta_ns;
+	unsigned long	min_delta_ns;
+	unsigned long	mult;
+	int		shift;
+	void		(*set_next_event)(unsigned long evt,
+					  struct clock_event_device *);
+	void		(*set_mode)(enum clock_event_mode mode,
+				    struct clock_event_device *);
+	void		(*event_handler)(void);
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
+#define MAX_CLOCK_EVENTS	4
+#define GLOBAL_CLOCK_EVENT	MAX_CLOCK_EVENTS
+
+struct event_descr {
+	struct clock_event_device *event;
+	unsigned int mode;
+	unsigned int real_caps;
+	struct irqaction action;
+};
+
+struct local_events {
+	int installed;
+	struct event_descr events[MAX_CLOCK_EVENTS];
+	struct clock_event_device *nextevt;
+	ktime_t	expires_next;
+};
+
+extern struct event_descr global_eventdevice;
+
+DECLARE_PER_CPU(struct local_events, local_eventdevices);
+
+/* Clock event layer functions */
+extern int register_local_clockevent(struct clock_event_device *);
+extern int register_global_clockevent(struct clock_event_device *);
+extern unsigned long clockevent_delta2ns(unsigned long latch,
+					 struct clock_event_device *evt);
+extern void clockevents_init(void);
+
+extern int clockevents_init_next_event(void);
+extern int clockevents_set_next_event(ktime_t expires, int force);
+extern int clockevents_next_event_available(void);
+extern void clockevents_resume_events(void);
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+extern void clockevents_set_broadcast(struct clock_event_device *evt,
+				      int broadcast);
+extern void clockevents_set_global_broadcast(struct clock_event_device *evt,
+					     int broadcast);
+extern int clockevents_register_broadcast(void (*fun)(cpumask_t *mask));
+extern cpumask_t tick_broadcast_mask;
+extern cpumask_t event_broadcast_mask;
+
+#else
+static inline void clockevents_set_broadcast(struct clock_event_device *evt,
+					     int broadcast)
+{
+}
+#endif
+
+#else
+
+# define clockevents_init()		do { } while(0)
+# define clockevents_resume_events()	do { } while(0)
+
+struct clock_event_device;
+static inline void clockevents_set_broadcast(struct clock_event_device *evt,
+					     int broadcast)
+{
+}
+
+#endif
+
+#endif
diff -puN include/linux/hrtimer.h~clockevents-core include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~clockevents-core
+++ a/include/linux/hrtimer.h
@@ -144,6 +144,9 @@ struct hrtimer_cpu_base {
  * is expired in the next softirq when the clock was advanced.
  */
 #define clock_was_set()		do { } while (0)
+#define hrtimer_clock_notify()	do { } while (0)
+extern ktime_t ktime_get(void);
+extern ktime_t ktime_get_real(void);
 
 /* Exported timer functions: */
 
diff -puN init/main.c~clockevents-core init/main.c
--- a/init/main.c~clockevents-core
+++ a/init/main.c
@@ -37,6 +37,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
 #include <linux/writeback.h>
+#include <linux/clockchips.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/efi.h>
@@ -544,6 +545,7 @@ asmlinkage void __init start_kernel(void
 	rcu_init();
 	init_IRQ();
 	pidhash_init();
+	clockevents_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();
diff -puN kernel/hrtimer.c~clockevents-core kernel/hrtimer.c
--- a/kernel/hrtimer.c~clockevents-core
+++ a/kernel/hrtimer.c
@@ -31,6 +31,7 @@
  *  For licencing details see kernel-base/COPYING
  */
 
+#include <linux/clockchips.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
@@ -46,7 +47,7 @@
  *
  * returns the time in ktime_t format
  */
-static ktime_t ktime_get(void)
+ktime_t ktime_get(void)
 {
 	struct timespec now;
 
@@ -60,7 +61,7 @@ static ktime_t ktime_get(void)
  *
  * returns the time in ktime_t format
  */
-static ktime_t ktime_get_real(void)
+ktime_t ktime_get_real(void)
 {
 	struct timespec now;
 
@@ -310,6 +311,7 @@ static unsigned long ktime_divns(const k
  */
 void hrtimer_notify_resume(void)
 {
+	clockevents_resume_events();
 	clock_was_set();
 }
 
diff -puN kernel/time/Makefile~clockevents-core kernel/time/Makefile
--- a/kernel/time/Makefile~clockevents-core
+++ a/kernel/time/Makefile
@@ -1 +1,3 @@
 obj-y += ntp.o clocksource.o jiffies.o
+
+obj-$(CONFIG_GENERIC_CLOCKEVENTS) += clockevents.o
diff -puN /dev/null kernel/time/clockevents.c
--- /dev/null
+++ a/kernel/time/clockevents.c
@@ -0,0 +1,762 @@
+/*
+ * linux/kernel/time/clockevents.c
+ *
+ * This file contains functions which manage clock event drivers.
+ *
+ * Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2005-2006, Red Hat, Inc., Ingo Molnar
+ *
+ * We have two types of clock event devices:
+ * - global events (one device per system)
+ * - local events (one device per cpu)
+ *
+ * We assign the various time(r) related interrupts to those devices
+ *
+ * - global tick
+ * - profiling (per cpu)
+ * - next timer events (per cpu)
+ *
+ * TODO:
+ * - implement variable frequency profiling
+ *
+ * This code is licenced under the GPL version 2. For details see
+ * kernel-base/COPYING.
+ */
+
+#include <linux/clockchips.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/hrtimer.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/profile.h>
+#include <linux/sysdev.h>
+
+/* Variables related to the global event device */
+__read_mostly struct event_descr global_eventdevice;
+
+/*
+ * Lock to protect the above.
+ *
+ * Only the public management functions have to take this lock. The fast path
+ * of the framework, e.g. reprogramming the next event device is lockless as
+ * it is per cpu.
+ */
+static DEFINE_SPINLOCK(events_lock);
+
+/* Variables related to the per cpu local event devices */
+DEFINE_PER_CPU(struct local_events, local_eventdevices);
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+static void clockevents_check_broadcast(struct event_descr *descr);
+#else
+static inline void clockevents_check_broadcast(struct event_descr *descr) { }
+#endif
+
+/*
+ * Math helper. Convert a latch value (device ticks) to nanoseconds
+ */
+unsigned long clockevent_delta2ns(unsigned long latch,
+				  struct clock_event_device *evt)
+{
+	u64 clc = ((u64) latch << evt->shift);
+
+	do_div(clc, evt->mult);
+	if (clc < KTIME_MONOTONIC_RES.tv64)
+		clc = KTIME_MONOTONIC_RES.tv64;
+	if (clc > LONG_MAX)
+		clc = LONG_MAX;
+
+	return (unsigned long) clc;
+}
+
+/*
+ * Bootup and lowres handler: ticks only
+ */
+static void handle_tick(void)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(1);
+	write_sequnlock(&xtime_lock);
+}
+
+/*
+ * Bootup and lowres handler: ticks and update_process_times
+ */
+static void handle_tick_update(void)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(1);
+	write_sequnlock(&xtime_lock);
+
+	update_process_times(user_mode(get_irq_regs()));
+}
+
+/*
+ * Bootup and lowres handler: ticks and profileing
+ */
+static void handle_tick_profile(void)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(1);
+	write_sequnlock(&xtime_lock);
+
+	profile_tick(CPU_PROFILING);
+}
+
+/*
+ * Bootup and lowres handler: ticks, update_process_times and profiling
+ */
+static void handle_tick_update_profile(void)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(1);
+	write_sequnlock(&xtime_lock);
+
+	update_process_times(user_mode(get_irq_regs()));
+	profile_tick(CPU_PROFILING);
+}
+
+/*
+ * Bootup and lowres handler: update_process_times
+ */
+static void handle_update(void)
+{
+	update_process_times(user_mode(get_irq_regs()));
+}
+
+/*
+ * Bootup and lowres handler: update_process_times and profiling
+ */
+static void handle_update_profile(void)
+{
+	update_process_times(user_mode(get_irq_regs()));
+	profile_tick(CPU_PROFILING);
+}
+
+/*
+ * Bootup and lowres handler: profiling
+ */
+static void handle_profile(void)
+{
+	profile_tick(CPU_PROFILING);
+}
+
+/*
+ * Noop handler when we shut down an event device
+ */
+static void handle_noop(void)
+{
+}
+
+/*
+ * Lookup table for bootup and lowres event assignment
+ *
+ * The event handler is choosen by the capability flags of the clock event
+ * device.
+ */
+static void __read_mostly *event_handlers[] = {
+	handle_noop,			/* 0: No capability selected */
+	handle_tick,			/* 1: Tick only	*/
+	handle_update,			/* 2: Update process times */
+	handle_tick_update,		/* 3: Tick + update process times */
+	handle_profile,			/* 4: Profiling int */
+	handle_tick_profile,		/* 5: Tick + Profiling int */
+	handle_update_profile,		/* 6: Update process times +
+					      profiling */
+	handle_tick_update_profile,	/* 7: Tick + update process times +
+					      profiling */
+#ifdef CONFIG_HIGH_RES_TIMERS
+	hrtimer_interrupt,		/* 8: Reprogrammable event device */
+#endif
+};
+
+/*
+ * Start up an event device
+ */
+static void startup_event(struct clock_event_device *evt, unsigned int caps)
+{
+	int mode;
+
+	if (caps == CLOCK_CAP_NEXTEVT)
+		mode = CLOCK_EVT_ONESHOT;
+	else
+		mode = CLOCK_EVT_PERIODIC;
+
+	evt->set_mode(mode, evt);
+}
+
+/*
+ * Setup an event device. Assign an handler and start it up
+ */
+static void setup_event(struct event_descr *descr,
+			struct clock_event_device *evt, unsigned int caps)
+{
+	void *handler = event_handlers[caps];
+
+	/* Set the event handler */
+	evt->event_handler = handler;
+
+	/* Store all relevant information */
+	descr->real_caps = caps;
+
+	startup_event(evt, caps);
+
+	printk(KERN_INFO "Clock event device %s configured with caps set: "
+	       "%02x\n", evt->name, descr->real_caps);
+}
+
+/**
+ * register_global_clockevent - register the device which generates
+ *			     global clock events
+ * @evt:	The device which generates global clock events (ticks)
+ *
+ * This can be a device which is only necessary for bootup. On UP systems this
+ * might be the only event device which is used for everything including
+ * high resolution events.
+ *
+ * When a cpu local event device is installed the global event device is
+ * switched off in the high resolution timer / tickless mode.
+ */
+int __init register_global_clockevent(struct clock_event_device *evt)
+{
+	/* Already installed? */
+	if (global_eventdevice.event) {
+		printk(KERN_ERR "Global clock event device already installed: "
+		       "%s. Ignoring new global eventsoruce %s\n",
+		       global_eventdevice.event->name,
+		       evt->name);
+		return -EBUSY;
+	}
+
+	/* Preset the handler in any case */
+	evt->event_handler = handle_noop;
+
+	/*
+	 * Check, whether it is a valid global event device
+	 */
+	if (!(evt->capabilities & CLOCK_BASE_CAPS_MASK)) {
+		printk(KERN_ERR "Unsupported clock event device %s\n",
+		       evt->name);
+		return -EINVAL;
+	}
+
+	/*
+	 * On UP systems the global clock event device can be used as the next
+	 * event device. On SMP this is disabled because the next event device
+	 * must be per CPU.
+	 */
+	if (num_possible_cpus() > 1)
+		evt->capabilities &= ~CLOCK_CAP_NEXTEVT;
+
+
+	/* Mask out high resolution capabilities for now */
+	global_eventdevice.event = evt;
+	setup_event(&global_eventdevice, evt,
+		    evt->capabilities & CLOCK_BASE_CAPS_MASK);
+	return 0;
+}
+
+/*
+ * Mask out the functionality which is covered by the new event device
+ * and assign a new event handler.
+ */
+static void recalc_active_event(struct event_descr *descr,
+				unsigned int newcaps)
+{
+	unsigned int caps;
+
+	if (!descr->real_caps)
+		return;
+
+	/* Mask the overlapping bits */
+	caps = descr->real_caps & ~newcaps;
+
+	/* Assign the new event handler */
+	if (caps) {
+		descr->event->event_handler = event_handlers[caps];
+		printk(KERN_INFO "Clock event device %s new caps set: %02x\n" ,
+		       descr->event->name, caps);
+	} else {
+		descr->event->event_handler = handle_noop;
+
+		if (descr->event->set_mode)
+			descr->event->set_mode(CLOCK_EVT_SHUTDOWN,
+					       descr->event);
+
+		printk(KERN_INFO "Clock event device %s disabled\n" ,
+		       descr->event->name);
+	}
+	descr->real_caps = caps;
+	clockevents_check_broadcast(descr);
+}
+
+/*
+ * Recalc the events and reassign the handlers if necessary
+ *
+ * Called with event_lock held to protect the global event device.
+ */
+static int recalc_events(struct local_events *devices,
+			 struct event_descr *descr,
+			 struct clock_event_device *evt, unsigned int caps)
+{
+	int i;
+
+	if (!descr && devices->installed == MAX_CLOCK_EVENTS)
+		return -ENOSPC;
+
+	/*
+	 * If there is no handler and this is not a next-event capable
+	 * event device, refuse to handle it
+	 */
+	if (!(evt->capabilities & CLOCK_CAP_NEXTEVT) && !event_handlers[caps]) {
+		printk(KERN_ERR "Unsupported clock event device %s\n",
+		       evt->name);
+		return -EINVAL;
+	}
+
+	if (caps) {
+		if (global_eventdevice.event && descr != &global_eventdevice)
+			recalc_active_event(&global_eventdevice, caps);
+
+		for (i = 0; i < devices->installed; i++) {
+			if (&devices->events[i] != descr)
+				recalc_active_event(&devices->events[i], caps);
+		}
+	}
+
+	/* New device ? */
+	if (!descr) {
+		descr = &devices->events[devices->installed++];
+		descr->event = evt;
+	}
+
+	if (caps) {
+		/* Is next_event event device going to be installed? */
+		if (caps & CLOCK_CAP_NEXTEVT)
+			caps = CLOCK_CAP_NEXTEVT;
+
+		setup_event(descr, evt, caps);
+	} else
+		printk(KERN_INFO "Inactive clock event device %s registered\n",
+		       evt->name);
+
+	return 0;
+}
+
+/**
+ * register_local_clockevent - Set up a cpu local clock event device
+ * @evt:	event device to be registered
+ */
+int register_local_clockevent(struct clock_event_device *evt)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&events_lock, flags);
+
+	/* Preset the handler in any case */
+	evt->event_handler = handle_noop;
+
+	/* Recalc event devices and maybe reassign handlers */
+	ret = recalc_events(devices, NULL, evt,
+			    evt->capabilities & CLOCK_BASE_CAPS_MASK);
+
+	spin_unlock_irqrestore(&events_lock, flags);
+
+	/*
+	 * Trigger hrtimers, when the event device is next-event
+	 * capable
+	 */
+	if (!ret && (evt->capabilities & CLOCK_CAP_NEXTEVT))
+		hrtimer_clock_notify();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_local_clockevent);
+
+/*
+ * Find a next-event capable event device
+ *
+ * Called with event_lock held to protect the global event device.
+ */
+static int get_next_event_device(void)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	int i;
+
+	for (i = 0; i < devices->installed; i++) {
+		struct clock_event_device *evt;
+
+		evt = devices->events[i].event;
+		if (evt->capabilities & CLOCK_CAP_NEXTEVT)
+			return i;
+	}
+
+	if (global_eventdevice.event->capabilities & CLOCK_CAP_NEXTEVT)
+		return GLOBAL_CLOCK_EVENT;
+
+	return -ENODEV;
+}
+
+/**
+ * clockevents_next_event_available - Check for a installed next-event device
+ *
+ * Returns 1, when such a device exists, otherwise 0
+ */
+int clockevents_next_event_available(void)
+{
+	unsigned long flags;
+	int idx;
+
+	spin_lock_irqsave(&events_lock, flags);
+	idx = get_next_event_device();
+	spin_unlock_irqrestore(&events_lock, flags);
+
+	return IS_ERR_VALUE(idx) ? 0 : 1;
+}
+
+/**
+ * clockevents_init_next_event - switch to next event (oneshot) mode
+ *
+ * Switch to one shot mode. On SMP systems the global event (tick) device is
+ * switched off. It is replaced by a hrtimer. On UP systems the global event
+ * device might be the only one and can be used as the next event device too.
+ *
+ * Returns 0 on success, otherwise an error code.
+ */
+int clockevents_init_next_event(void)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	struct event_descr *nextevt;
+	unsigned long flags;
+	int idx, ret = -ENODEV;
+
+	if (devices->nextevt)
+		return -EBUSY;
+
+	spin_lock_irqsave(&events_lock, flags);
+
+	idx = get_next_event_device();
+	if (IS_ERR_VALUE(idx))
+		goto out_unlock;
+
+	if (idx == GLOBAL_CLOCK_EVENT)
+		nextevt = &global_eventdevice;
+	else
+		nextevt = &devices->events[idx];
+
+	ret = recalc_events(devices, nextevt, nextevt->event, CLOCK_CAPS_MASK);
+	if (!ret)
+		devices->nextevt = nextevt->event;
+ out_unlock:
+	spin_unlock_irqrestore(&events_lock, flags);
+
+	return ret;
+}
+
+/*
+ * Reprogram the clock event device. Internal helper function
+ */
+static void do_clockevents_set_next_event(struct clock_event_device *nextevt,
+					 int64_t delta)
+{
+	unsigned long long clc;
+
+	if (delta > nextevt->max_delta_ns)
+		delta = nextevt->max_delta_ns;
+	if (delta < nextevt->min_delta_ns)
+		delta = nextevt->min_delta_ns;
+
+	clc = delta * nextevt->mult;
+	clc >>= nextevt->shift;
+	nextevt->set_next_event((unsigned long)clc, nextevt);
+}
+
+/**
+ * clockevents_set_next_event - Reprogram the clock event device.
+ * @expires:	absolute expiry time (monotonic clock)
+ * @force:	when set, enforce reprogramming, even if the event is in the
+ *		past
+ *
+ * Returns 0 on success, -ETIME when the event is in the past and force is not
+ * set.
+ * Called with interrupts disabled.
+ */
+int clockevents_set_next_event(ktime_t expires, int force)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	struct clock_event_device *nextevt = devices->nextevt;
+	int64_t delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
+
+	if (delta <= 0 && !force)
+		return -ETIME;
+
+	devices->expires_next = expires;
+
+	do_clockevents_set_next_event(nextevt, delta);
+
+	return 0;
+}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+
+cpumask_t tick_broadcast_mask;
+cpumask_t event_broadcast_mask;
+static void (*broadcast_function)(cpumask_t *mask);
+static void (*global_event_handler)(void);
+
+/*
+ * Reprogram the broadcast device:
+ *
+ * Called with events_lock held and interrupts disabled.
+ */
+static void clockevents_reprogram_broadcast(void)
+{
+	struct clock_event_device *glblevt = global_eventdevice.event;
+	ktime_t expires = { .tv64 = KTIME_MAX };
+	struct local_events *dev;
+	int64_t delta;
+	int cpu;
+
+	for (cpu = first_cpu(event_broadcast_mask); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, event_broadcast_mask)) {
+		dev = &per_cpu(local_eventdevices, cpu);
+		if (dev->expires_next.tv64 < expires.tv64)
+			expires = dev->expires_next;
+	}
+
+	if (expires.tv64 != KTIME_MAX) {
+		delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
+		do_clockevents_set_next_event(glblevt, delta);
+	}
+}
+
+/**
+ * clockevents_set_broadcast - switch next event device from/to broadcast mode
+ *
+ * Called, when the PM code enters a state, where the next event device is
+ * switched off or comes back from this state.
+ */
+void clockevents_set_broadcast(struct clock_event_device *evt, int broadcast)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	int cpu = smp_processor_id();
+	unsigned long flags;
+
+	if (devices->nextevt != evt)
+		return;
+
+	spin_lock_irqsave(&events_lock, flags);
+
+	if (broadcast) {
+		cpu_set(cpu, event_broadcast_mask);
+		evt->set_mode(CLOCK_EVT_SHUTDOWN, evt);
+	} else {
+		cpu_clear(cpu, event_broadcast_mask);
+		evt->set_mode(CLOCK_EVT_ONESHOT, evt);
+		if (devices->expires_next.tv64 != KTIME_MAX)
+			clockevents_set_next_event(devices->expires_next, 1);
+	}
+	clockevents_reprogram_broadcast();
+
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+/**
+ * clockevents_set_global_broadcast - mark event device for global broadcast
+ *
+ * Switch an event device from / to global broadcasting. This is only relevant
+ * when the system has not switched to high resolution mode.
+ */
+void clockevents_set_global_broadcast(struct clock_event_device *evt,
+				      int broadcast)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	int cpu = smp_processor_id();
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+
+	if (broadcast) {
+		if (!cpu_isset(cpu, tick_broadcast_mask)) {
+			cpu_set(cpu, tick_broadcast_mask);
+			if (devices->nextevt != evt)
+				evt->set_mode(CLOCK_EVT_SHUTDOWN, evt);
+		}
+	} else {
+		if (cpu_isset(cpu, tick_broadcast_mask)) {
+			cpu_clear(cpu, tick_broadcast_mask);
+			if (devices->nextevt != evt)
+				evt->set_mode(CLOCK_EVT_PERIODIC, evt);
+		}
+	}
+
+	spin_unlock_irqrestore(&events_lock, flags);
+}
+
+/*
+ * Broadcast tick handler:
+ */
+static void handle_tick_broadcast(void)
+{
+	/* Call the original handler global tick handler */
+	global_event_handler();
+	broadcast_function(&tick_broadcast_mask);
+}
+
+/*
+ * Broadcast next event handler:
+ */
+static void handle_nextevt_broadcast(void)
+{
+	struct local_events *devices;
+	ktime_t now = ktime_get();
+	cpumask_t mask;
+	int cpu;
+
+	spin_lock(&events_lock);
+	/* Find all expired events */
+	for (cpu = first_cpu(event_broadcast_mask); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, event_broadcast_mask)) {
+		devices = &per_cpu(local_eventdevices, cpu);
+		if (devices->expires_next.tv64 <= now.tv64) {
+			devices->expires_next.tv64 = KTIME_MAX;
+			cpu_set(cpu, mask);
+		}
+	}
+	if (!cpus_empty(mask)) {
+		/*
+		 * Wakeup the cpus which have an expired event. The
+		 * global event is reprogrammed in the return from
+		 * idle code.
+		 */
+		broadcast_function(&mask);
+	} else {
+		/*
+		 * The global event did not expire any CPU local
+		 * events. This happens in dyntick mode, as the
+		 * maximum PIT delta is quite small.
+		 */
+		clockevents_reprogram_broadcast();
+	}
+	spin_unlock(&events_lock);
+}
+
+/*
+ * Check, if the reconfigured event device is the global broadcast device.
+ *
+ * Called with interrupts disabled and events_lock held
+ */
+static void clockevents_check_broadcast(struct event_descr *descr)
+{
+	if (descr != &global_eventdevice)
+		return;
+
+	/* The device was disabled. switch it to oneshot mode instead */
+	if (!descr->real_caps) {
+		global_event_handler = NULL;
+		descr->event->set_mode(CLOCK_EVT_ONESHOT, descr->event);
+		descr->event->event_handler = handle_nextevt_broadcast;
+	} else {
+		global_event_handler = descr->event->event_handler;
+		descr->event->event_handler = handle_tick_broadcast;
+	}
+
+}
+
+/*
+ * Install a broadcast function
+ */
+int clockevents_register_broadcast(void (*fun)(cpumask_t *mask))
+{
+	unsigned long flags;
+
+	if (broadcast_function)
+		return -EBUSY;
+
+	spin_lock_irqsave(&events_lock, flags);
+	broadcast_function = fun;
+	clockevents_check_broadcast(&global_eventdevice);
+	spin_unlock_irqrestore(&events_lock, flags);
+
+	return 0;
+}
+
+#endif
+
+/*
+ * Resume the cpu local clock events
+ */
+static void clockevents_resume_local_events(void *arg)
+{
+	struct local_events *devices = &__get_cpu_var(local_eventdevices);
+	int i;
+
+	for (i = 0; i < devices->installed; i++) {
+		if (devices->events[i].real_caps)
+			startup_event(devices->events[i].event,
+				      devices->events[i].real_caps);
+	}
+	touch_softlockup_watchdog();
+}
+
+/**
+ * clockevents_resume_events - resume the active clock devices
+ *
+ * Called after timekeeping is functional again
+ */
+void clockevents_resume_events(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/* Resume global event device */
+	if (global_eventdevice.real_caps)
+		startup_event(global_eventdevice.event,
+			      global_eventdevice.real_caps);
+
+	local_irq_restore(flags);
+
+	/* Restart the CPU local events everywhere */
+	on_each_cpu(clockevents_resume_local_events, NULL, 0, 1);
+}
+
+/*
+ * Functions related to initialization and hotplug
+ */
+static int clockevents_cpu_notify(struct notifier_block *self,
+				  unsigned long action, void *hcpu)
+{
+	switch(action) {
+	case CPU_UP_PREPARE:
+		break;
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_DEAD:
+		/*
+		 * Do something sensible here !
+		 * Disable the cpu local clock event devices ???
+		 */
+		break;
+#endif
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __devinitdata clockevents_nb = {
+	.notifier_call	= clockevents_cpu_notify,
+};
+
+void __init clockevents_init(void)
+{
+	clockevents_cpu_notify(&clockevents_nb, (unsigned long)CPU_UP_PREPARE,
+				(void *)(long)smp_processor_id());
+	register_cpu_notifier(&clockevents_nb);
+}
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

