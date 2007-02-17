From: akpm@linux-foundation.org
Subject: - tick-management-dyntick--highres-functionality.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:55 -0800
Message-ID: <200702170714.l1H7EtP7021561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946477AbXBQHQK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     tick-management: dyntick / highres functionality
has been removed from the -mm tree.  Its filename was
     tick-management-dyntick--highres-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tick-management: dyntick / highres functionality
From: Thomas Gleixner <tglx@linutronix.de>,
      Ingo Molnar <mingo@elte.hu>

Add functions to provide dynamic ticks and high resolution timers.  The code
which keeps track of jiffies and handles the long idle periods is shared
between tick based and high resolution timer based dynticks.  The dyntick
functionality can be disabled on the kernel commandline.  Provide also the
infrastructure to support high resolution timers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 
 include/linux/hardirq.h             |   12 
 include/linux/hrtimer.h             |    6 
 include/linux/tick.h                |   71 +++
 kernel/hrtimer.c                    |   20 
 kernel/softirq.c                    |   15 
 kernel/time/Kconfig                 |   15 
 kernel/time/Makefile                |    2 
 kernel/time/clocksource.c           |    8 
 kernel/time/tick-broadcast.c        |  191 ++++++++
 kernel/time/tick-common.c           |   26 +
 kernel/time/tick-internal.h         |   49 ++
 kernel/time/tick-oneshot.c          |   84 +++
 kernel/time/tick-sched.c            |  558 ++++++++++++++++++++++++++
 kernel/timer.c                      |    5 
 15 files changed, 1049 insertions(+), 17 deletions(-)

diff -puN Documentation/kernel-parameters.txt~tick-management-dyntick--highres-functionality Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~tick-management-dyntick--highres-functionality
+++ a/Documentation/kernel-parameters.txt
@@ -1078,6 +1078,10 @@ and is between 256 and 4096 characters. 
 			in certain environments such as networked servers or
 			real-time systems.
 
+	nohz=		[KNL] Boottime enable/disable dynamic ticks
+			Valid arguments: on, off
+			Default: on
+
 	noirqbalance	[IA-32,SMP,KNL] Disable kernel irq balancing
 
 	noirqdebug	[IA-32] Disables the code which attempts to detect and
diff -puN include/linux/hardirq.h~tick-management-dyntick--highres-functionality include/linux/hardirq.h
--- a/include/linux/hardirq.h~tick-management-dyntick--highres-functionality
+++ a/include/linux/hardirq.h
@@ -106,6 +106,16 @@ static inline void account_system_vtime(
  * always balanced, so the interrupted value of ->hardirq_context
  * will always be restored.
  */
+#define __irq_enter()					\
+	do {						\
+		account_system_vtime(current);		\
+		add_preempt_count(HARDIRQ_OFFSET);	\
+		trace_hardirq_enter();			\
+	} while (0)
+
+/*
+ * Enter irq context (on NO_HZ, update jiffies):
+ */
 extern void irq_enter(void);
 
 /*
@@ -123,7 +133,7 @@ extern void irq_enter(void);
  */
 extern void irq_exit(void);
 
-#define nmi_enter()		do { lockdep_off(); irq_enter(); } while (0)
+#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
 #define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
 
 #endif /* LINUX_HARDIRQ_H */
diff -puN include/linux/hrtimer.h~tick-management-dyntick--highres-functionality include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~tick-management-dyntick--highres-functionality
+++ a/include/linux/hrtimer.h
@@ -201,4 +201,10 @@ extern void hrtimer_run_queues(void);
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
+#if BITS_PER_LONG < 64
+extern unsigned long ktime_divns(const ktime_t kt, s64 div);
+#else /* BITS_PER_LONG < 64 */
+# define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
+#endif
+
 #endif
diff -puN include/linux/tick.h~tick-management-dyntick--highres-functionality include/linux/tick.h
--- a/include/linux/tick.h~tick-management-dyntick--highres-functionality
+++ a/include/linux/tick.h
@@ -20,12 +20,79 @@ struct tick_device {
 	enum tick_device_mode mode;
 };
 
+enum tick_nohz_mode {
+	NOHZ_MODE_INACTIVE,
+	NOHZ_MODE_LOWRES,
+	NOHZ_MODE_HIGHRES,
+};
+
+/**
+ * struct tick_sched - sched tick emulation and no idle tick control/stats
+ * @sched_timer:	hrtimer to schedule the periodic tick in high
+ *			resolution mode
+ * @idle_tick:		Store the last idle tick expiry time when the tick
+ *			timer is modified for idle sleeps. This is necessary
+ *			to resume the tick timer operation in the timeline
+ *			when the CPU returns from idle
+ * @tick_stopped:	Indicator that the idle tick has been stopped
+ * @idle_jiffies:	jiffies at the entry to idle for idle time accounting
+ * @idle_calls:		Total number of idle calls
+ * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
+ * @idle_entrytime:	Time when the idle call was entered
+ * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
+ */
+struct tick_sched {
+	struct hrtimer			sched_timer;
+	unsigned long			check_clocks;
+	enum tick_nohz_mode		nohz_mode;
+	ktime_t				idle_tick;
+	int				tick_stopped;
+	unsigned long			idle_jiffies;
+	unsigned long			idle_calls;
+	unsigned long			idle_sleeps;
+	ktime_t				idle_entrytime;
+	ktime_t				idle_sleeptime;
+	unsigned long			last_jiffies;
+	unsigned long			next_jiffies;
+	ktime_t				idle_expires;
+};
+
 extern void __init tick_init(void);
+extern int tick_is_oneshot_available(void);
+
+# ifdef CONFIG_HIGH_RES_TIMERS
+extern int tick_init_highres(void);
+extern int tick_program_event(ktime_t expires, int force);
+extern void tick_setup_sched_timer(void);
+extern void tick_cancel_sched_timer(int cpu);
+# else
+static inline void tick_cancel_sched_timer(int cpu) { }
+# endif /* HIGHRES */
 
-#else
+# ifdef CONFIG_TICK_ONESHOT
+extern void tick_clock_notify(void);
+extern int tick_check_oneshot_change(int allow_nohz);
+extern struct tick_sched *tick_get_tick_sched(int cpu);
+# else
+static inline void tick_clock_notify(void) { }
+static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
+# endif
 
+#else /* CONFIG_GENERIC_CLOCKEVENTS */
 static inline void tick_init(void) { }
+static inline void tick_cancel_sched_timer(int cpu) { }
+static inline void tick_clock_notify(void) { }
+static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
+#endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
-#endif
+# ifdef CONFIG_NO_HZ
+extern void tick_nohz_stop_sched_tick(void);
+extern void tick_nohz_restart_sched_tick(void);
+extern void tick_nohz_update_jiffies(void);
+# else
+static inline void tick_nohz_stop_sched_tick(void) { }
+static inline void tick_nohz_restart_sched_tick(void) { }
+static inline void tick_nohz_update_jiffies(void) { }
+# endif /* !NO_HZ */
 
 #endif
diff -puN kernel/hrtimer.c~tick-management-dyntick--highres-functionality kernel/hrtimer.c
--- a/kernel/hrtimer.c~tick-management-dyntick--highres-functionality
+++ a/kernel/hrtimer.c
@@ -2,8 +2,8 @@
  *  linux/kernel/hrtimer.c
  *
  *  Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
- *  Copyright(C) 2005-2006, Red Hat, Inc., Ingo Molnar
- *  Copyright(C) 2006	    Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *  Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
+ *  Copyright(C) 2006-2007  Timesys Corp., Thomas Gleixner <tglx@timesys.com>
  *
  *  High-resolution kernel timers
  *
@@ -38,6 +38,7 @@
 #include <linux/notifier.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 
@@ -288,7 +289,7 @@ ktime_t ktime_add_ns(const ktime_t kt, u
 /*
  * Divide a ktime value by a nanosecond value
  */
-static unsigned long ktime_divns(const ktime_t kt, s64 div)
+unsigned long ktime_divns(const ktime_t kt, s64 div)
 {
 	u64 dclc, inc, dns;
 	int sft = 0;
@@ -305,9 +306,6 @@ static unsigned long ktime_divns(const k
 
 	return (unsigned long) dclc;
 }
-
-#else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
@@ -682,6 +680,16 @@ void hrtimer_run_queues(void)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	int i;
 
+	/*
+	 * This _is_ ugly: We have to check in the softirq context,
+	 * whether we can switch to highres and / or nohz mode. The
+	 * clocksource switch happens in the timer interrupt with
+	 * xtime_lock held. Notification from there only sets the
+	 * check bit in the tick_oneshot code, otherwise we might
+	 * deadlock vs. xtime_lock.
+	 */
+	tick_check_oneshot_change(1);
+
 	hrtimer_get_softirq_time(cpu_base);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
diff -puN kernel/softirq.c~tick-management-dyntick--highres-functionality kernel/softirq.c
--- a/kernel/softirq.c~tick-management-dyntick--highres-functionality
+++ a/kernel/softirq.c
@@ -17,6 +17,7 @@
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
+#include <linux/tick.h>
 
 #include <asm/irq.h>
 /*
@@ -278,9 +279,11 @@ EXPORT_SYMBOL(do_softirq);
  */
 void irq_enter(void)
 {
-	account_system_vtime(current);
-	add_preempt_count(HARDIRQ_OFFSET);
-	trace_hardirq_enter();
+	__irq_enter();
+#ifdef CONFIG_NO_HZ
+	if (idle_cpu(smp_processor_id()))
+		tick_nohz_update_jiffies();
+#endif
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
@@ -299,6 +302,12 @@ void irq_exit(void)
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
+
+#ifdef CONFIG_NO_HZ
+	/* Make sure that timer wheel updates are propagated */
+	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
+		tick_nohz_stop_sched_tick();
+#endif
 	preempt_enable_no_resched();
 }
 
diff -puN /dev/null kernel/time/Kconfig
--- /dev/null
+++ a/kernel/time/Kconfig
@@ -0,0 +1,15 @@
+#
+# Timer subsystem related configuration options
+#
+config TICK_ONESHOT
+	bool
+	default n
+
+config NO_HZ
+	bool "Tickless System (Dynamic Ticks)"
+	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	select TICK_ONESHOT
+	help
+	  This option enables a tickless system: timer interrupts will
+	  only trigger on an as-needed basis both when the system is
+	  busy and when the system is idle.
diff -puN kernel/time/Makefile~tick-management-dyntick--highres-functionality kernel/time/Makefile
--- a/kernel/time/Makefile~tick-management-dyntick--highres-functionality
+++ a/kernel/time/Makefile
@@ -3,3 +3,5 @@ obj-y += ntp.o clocksource.o jiffies.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
+obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
+obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
diff -puN kernel/time/clocksource.c~tick-management-dyntick--highres-functionality kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~tick-management-dyntick--highres-functionality
+++ a/kernel/time/clocksource.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
+#include <linux/tick.h>
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
@@ -109,6 +110,13 @@ static void clocksource_watchdog(unsigne
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
 			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
 				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+				/*
+				 * We just marked the clocksource as
+				 * highres-capable, notify the rest of the
+				 * system as well so that we transition
+				 * into high-res mode:
+				 */
+				tick_clock_notify();
 			}
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = csnow;
diff -puN kernel/time/tick-broadcast.c~tick-management-dyntick--highres-functionality kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~tick-management-dyntick--highres-functionality
+++ a/kernel/time/tick-broadcast.c
@@ -29,7 +29,7 @@
 
 struct tick_device tick_broadcast_device;
 static cpumask_t tick_broadcast_mask;
-DEFINE_SPINLOCK(tick_broadcast_lock);
+static DEFINE_SPINLOCK(tick_broadcast_lock);
 
 /*
  * Start the device in periodic mode
@@ -215,6 +215,8 @@ static void tick_do_broadcast_on_off(voi
 	else {
 		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 			tick_broadcast_start_periodic(bc);
+		else
+			tick_broadcast_setup_oneshot(bc);
 	}
 out:
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -268,3 +270,190 @@ void tick_shutdown_broadcast(unsigned in
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
+
+#ifdef CONFIG_TICK_ONESHOT
+
+static cpumask_t tick_broadcast_oneshot_mask;
+
+static int tick_broadcast_set_event(ktime_t expires, int force)
+{
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	ktime_t now = ktime_get();
+	int res;
+
+	for(;;) {
+		res = clockevents_program_event(bc, expires, now);
+		if (!res || !force)
+			return res;
+		now = ktime_get();
+		expires = ktime_add(now, ktime_set(0, bc->min_delta_ns));
+	}
+}
+
+/*
+ * Reprogram the broadcast device:
+ *
+ * Called with tick_broadcast_lock held and interrupts disabled.
+ */
+static int tick_broadcast_reprogram(void)
+{
+	ktime_t expires = { .tv64 = KTIME_MAX };
+	struct tick_device *td;
+	int cpu;
+
+	/*
+	 * Find the event which expires next:
+	 */
+	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
+		td = &per_cpu(tick_cpu_device, cpu);
+		if (td->evtdev->next_event.tv64 < expires.tv64)
+			expires = td->evtdev->next_event;
+	}
+
+	if (expires.tv64 == KTIME_MAX)
+		return 0;
+
+	return tick_broadcast_set_event(expires, 0);
+}
+
+/*
+ * Handle oneshot mode broadcasting
+ */
+static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
+{
+	struct tick_device *td;
+	cpumask_t mask;
+	ktime_t now;
+	int cpu;
+
+	spin_lock(&tick_broadcast_lock);
+again:
+	dev->next_event.tv64 = KTIME_MAX;
+	mask = CPU_MASK_NONE;
+	now = ktime_get();
+	/* Find all expired events */
+	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
+		td = &per_cpu(tick_cpu_device, cpu);
+		if (td->evtdev->next_event.tv64 <= now.tv64)
+			cpu_set(cpu, mask);
+	}
+
+	/*
+	 * Wakeup the cpus which have an expired event. The broadcast
+	 * device is reprogrammed in the return from idle code.
+	 */
+	if (!tick_do_broadcast(mask)) {
+		/*
+		 * The global event did not expire any CPU local
+		 * events. This happens in dyntick mode, as the
+		 * maximum PIT delta is quite small.
+		 */
+		if (tick_broadcast_reprogram())
+			goto again;
+	}
+	spin_unlock(&tick_broadcast_lock);
+}
+
+/*
+ * Powerstate information: The system enters/leaves a state, where
+ * affected devices might stop
+ */
+void tick_broadcast_oneshot_control(unsigned long reason)
+{
+	struct clock_event_device *bc, *dev;
+	struct tick_device *td;
+	unsigned long flags;
+	int cpu;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	/*
+	 * Periodic mode does not care about the enter/exit of power
+	 * states
+	 */
+	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+		goto out;
+
+	bc = tick_broadcast_device.evtdev;
+	cpu = smp_processor_id();
+	td = &per_cpu(tick_cpu_device, cpu);
+	dev = td->evtdev;
+
+	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		goto out;
+
+	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
+		if (!cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
+			cpu_set(cpu, tick_broadcast_oneshot_mask);
+			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+			if (dev->next_event.tv64 < bc->next_event.tv64)
+				tick_broadcast_set_event(dev->next_event, 1);
+		}
+	} else {
+		if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
+			cpu_clear(cpu, tick_broadcast_oneshot_mask);
+			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+			if (dev->next_event.tv64 != KTIME_MAX)
+				tick_program_event(dev->next_event, 1);
+		}
+	}
+
+out:
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+/**
+ * tick_broadcast_setup_highres - setup the broadcast device for highres
+ */
+void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
+{
+	if (bc->mode != CLOCK_EVT_MODE_ONESHOT) {
+		bc->event_handler = tick_handle_oneshot_broadcast;
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+		bc->next_event.tv64 = KTIME_MAX;
+	}
+}
+
+/*
+ * Select oneshot operating mode for the broadcast device
+ */
+void tick_broadcast_switch_to_oneshot(void)
+{
+	struct clock_event_device *bc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
+	bc = tick_broadcast_device.evtdev;
+	if (bc)
+		tick_broadcast_setup_oneshot(bc);
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+
+/*
+ * Remove a dead CPU from broadcasting
+ */
+void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
+{
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
+
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+#endif
diff -puN kernel/time/tick-common.c~tick-management-dyntick--highres-functionality kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~tick-management-dyntick--highres-functionality
+++ a/kernel/time/tick-common.c
@@ -34,6 +34,16 @@ ktime_t tick_period;
 static int tick_do_timer_cpu = -1;
 DEFINE_SPINLOCK(tick_device_lock);
 
+/**
+ * tick_is_oneshot_available - check for a oneshot capable event device
+ */
+int tick_is_oneshot_available(void)
+{
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+
+	return dev && (dev->features & CLOCK_EVT_FEAT_ONESHOT);
+}
+
 /*
  * Periodic tick
  */
@@ -162,6 +172,8 @@ static void tick_setup_device(struct tic
 
 	if (td->mode == TICKDEV_MODE_PERIODIC)
 		tick_setup_periodic(newdev, 0);
+	else
+		tick_setup_oneshot(newdev, handler, next_event);
 }
 
 /*
@@ -209,6 +221,12 @@ static int tick_check_new_device(struct 
 	 */
 	if (curdev) {
 		/*
+		 * Prefer one shot capable devices !
+		 */
+		if ((curdev->features & CLOCK_EVT_FEAT_ONESHOT) &&
+		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
+			goto out_bc;
+		/*
 		 * Check the rating
 		 */
 		if (curdev->rating >= newdev->rating)
@@ -226,6 +244,8 @@ static int tick_check_new_device(struct 
 	}
 	clockevents_exchange_device(curdev, newdev);
 	tick_setup_device(td, newdev, cpu, cpumask);
+	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
+		tick_oneshot_notify();
 
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 	return NOTIFY_STOP;
@@ -285,7 +305,13 @@ static int tick_notify(struct notifier_b
 		tick_broadcast_on_off(reason, dev);
 		break;
 
+	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
+	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
+		tick_broadcast_oneshot_control(reason);
+		break;
+
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
+		tick_shutdown_broadcast_oneshot(dev);
 		tick_shutdown_broadcast(dev);
 		tick_shutdown(dev);
 		break;
diff -puN kernel/time/tick-internal.h~tick-management-dyntick--highres-functionality kernel/time/tick-internal.h
--- a/kernel/time/tick-internal.h~tick-management-dyntick--highres-functionality
+++ a/kernel/time/tick-internal.h
@@ -10,12 +10,57 @@ extern void tick_setup_periodic(struct c
 extern void tick_handle_periodic(struct clock_event_device *dev);
 
 /*
+ * NO_HZ / high resolution timer shared code
+ */
+#ifdef CONFIG_TICK_ONESHOT
+extern void tick_setup_oneshot(struct clock_event_device *newdev,
+			       void (*handler)(struct clock_event_device *),
+			       ktime_t nextevt);
+extern int tick_program_event(ktime_t expires, int force);
+extern void tick_oneshot_notify(void);
+extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
+
+# ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
+extern void tick_broadcast_oneshot_control(unsigned long reason);
+extern void tick_broadcast_switch_to_oneshot(void);
+extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
+# else /* BROADCAST */
+static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
+{
+	BUG();
+}
+static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline void tick_broadcast_switch_to_oneshot(void) { }
+static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+# endif /* !BROADCAST */
+
+#else /* !ONESHOT */
+static inline
+void tick_setup_oneshot(struct clock_event_device *newdev,
+			void (*handler)(struct clock_event_device *),
+			ktime_t nextevt)
+{
+	BUG();
+}
+static inline int tick_program_event(ktime_t expires, int force)
+{
+	return 0;
+}
+static inline void tick_oneshot_notify(void) { }
+static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
+{
+	BUG();
+}
+static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+#endif /* !TICK_ONESHOT */
+
+/*
  * Broadcasting support
  */
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern int tick_do_broadcast(cpumask_t mask);
-extern struct tick_device tick_broadcast_device;
-extern spinlock_t tick_broadcast_lock;
 
 extern int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu);
 extern int tick_check_broadcast_device(struct clock_event_device *dev);
diff -puN /dev/null kernel/time/tick-oneshot.c
--- /dev/null
+++ a/kernel/time/tick-oneshot.c
@@ -0,0 +1,84 @@
+/*
+ * linux/kernel/time/tick-oneshot.c
+ *
+ * This file contains functions which manage high resolution tick
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
+#include "tick-internal.h"
+
+/**
+ * tick_program_event
+ */
+int tick_program_event(ktime_t expires, int force)
+{
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	ktime_t now = ktime_get();
+
+	while (1) {
+		int ret = clockevents_program_event(dev, expires, now);
+
+		if (!ret || !force)
+			return ret;
+		now = ktime_get();
+		expires = ktime_add(now, ktime_set(0, dev->min_delta_ns));
+	}
+}
+
+/**
+ * tick_setup_oneshot - setup the event device for oneshot mode (hres or nohz)
+ */
+void tick_setup_oneshot(struct clock_event_device *newdev,
+			void (*handler)(struct clock_event_device *),
+			ktime_t next_event)
+{
+	newdev->event_handler = handler;
+	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
+	clockevents_program_event(newdev, next_event, ktime_get());
+}
+
+/**
+ * tick_switch_to_oneshot - switch to oneshot mode
+ */
+int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct clock_event_device *dev = td->evtdev;
+
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
+	    !tick_device_is_functional(dev))
+		return -EINVAL;
+
+	td->mode = TICKDEV_MODE_ONESHOT;
+	dev->event_handler = handler;
+	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+	tick_broadcast_switch_to_oneshot();
+	return 0;
+}
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+/**
+ * tick_init_highres - switch to high resolution mode
+ *
+ * Called with interrupts disabled.
+ */
+int tick_init_highres(void)
+{
+	return tick_switch_to_oneshot(hrtimer_interrupt);
+}
+#endif
diff -puN /dev/null kernel/time/tick-sched.c
--- /dev/null
+++ a/kernel/time/tick-sched.c
@@ -0,0 +1,558 @@
+/*
+ *  linux/kernel/time/tick-sched.c
+ *
+ *  Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
+ *  Copyright(C) 2006-2007  Timesys Corp., Thomas Gleixner
+ *
+ *  No idle tick implementation for low and high resolution timers
+ *
+ *  Started by: Thomas Gleixner and Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/hrtimer.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/percpu.h>
+#include <linux/profile.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
+
+#include "tick-internal.h"
+
+/*
+ * Per cpu nohz control structure
+ */
+static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
+
+/*
+ * The time, when the last jiffy update happened. Protected by xtime_lock.
+ */
+static ktime_t last_jiffies_update;
+
+/*
+ * Must be called with interrupts disabled !
+ */
+static void tick_do_update_jiffies64(ktime_t now)
+{
+	unsigned long ticks = 0;
+	ktime_t delta;
+
+	/* Reevalute with xtime_lock held */
+	write_seqlock(&xtime_lock);
+
+	delta = ktime_sub(now, last_jiffies_update);
+	if (delta.tv64 >= tick_period.tv64) {
+
+		delta = ktime_sub(delta, tick_period);
+		last_jiffies_update = ktime_add(last_jiffies_update,
+						tick_period);
+
+		/* Slow path for long timeouts */
+		if (unlikely(delta.tv64 >= tick_period.tv64)) {
+			s64 incr = ktime_to_ns(tick_period);
+
+			ticks = ktime_divns(delta, incr);
+
+			last_jiffies_update = ktime_add_ns(last_jiffies_update,
+							   incr * ticks);
+		}
+		do_timer(++ticks);
+	}
+	write_sequnlock(&xtime_lock);
+}
+
+/*
+ * Initialize and return retrieve the jiffies update.
+ */
+static ktime_t tick_init_jiffy_update(void)
+{
+	ktime_t period;
+
+	write_seqlock(&xtime_lock);
+	/* Did we start the jiffies update yet ? */
+	if (last_jiffies_update.tv64 == 0)
+		last_jiffies_update = tick_next_period;
+	period = last_jiffies_update;
+	write_sequnlock(&xtime_lock);
+	return period;
+}
+
+/*
+ * NOHZ - aka dynamic tick functionality
+ */
+#ifdef CONFIG_NO_HZ
+/*
+ * NO HZ enabled ?
+ */
+static int tick_nohz_enabled __read_mostly  = 1;
+
+/*
+ * Enable / Disable tickless mode
+ */
+static int __init setup_tick_nohz(char *str)
+{
+	if (!strcmp(str, "off"))
+		tick_nohz_enabled = 0;
+	else if (!strcmp(str, "on"))
+		tick_nohz_enabled = 1;
+	else
+		return 0;
+	return 1;
+}
+
+__setup("nohz=", setup_tick_nohz);
+
+/**
+ * tick_nohz_update_jiffies - update jiffies when idle was interrupted
+ *
+ * Called from interrupt entry when the CPU was idle
+ *
+ * In case the sched_tick was stopped on this CPU, we have to check if jiffies
+ * must be updated. Otherwise an interrupt handler could use a stale jiffy
+ * value. We do this unconditionally on any cpu, as we don't know whether the
+ * cpu, which has the update task assigned is in a long sleep.
+ */
+void tick_nohz_update_jiffies(void)
+{
+	int cpu = smp_processor_id();
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	unsigned long flags;
+	ktime_t now;
+
+	if (!ts->tick_stopped)
+		return;
+
+	cpu_clear(cpu, nohz_cpu_mask);
+	now = ktime_get();
+
+	local_irq_save(flags);
+	tick_do_update_jiffies64(now);
+	local_irq_restore(flags);
+}
+
+/**
+ * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
+ *
+ * When the next event is more than a tick into the future, stop the idle tick
+ * Called either from the idle loop or from irq_exit() when an idle period was
+ * just interrupted by an interrupt which did not cause a reschedule.
+ */
+void tick_nohz_stop_sched_tick(void)
+{
+	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
+	struct tick_sched *ts;
+	ktime_t last_update, expires, now, delta;
+	int cpu;
+
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+		goto end;
+
+	if (need_resched())
+		goto end;
+
+	cpu = smp_processor_id();
+	BUG_ON(local_softirq_pending());
+
+	now = ktime_get();
+	/*
+	 * When called from irq_exit we need to account the idle sleep time
+	 * correctly.
+	 */
+	if (ts->tick_stopped) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
+
+	ts->idle_entrytime = now;
+	ts->idle_calls++;
+
+	/* Read jiffies and the time when jiffies were updated last */
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		last_update = last_jiffies_update;
+		last_jiffies = jiffies;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	/* Get the next timer wheel timer */
+	next_jiffies = get_next_timer_interrupt(last_jiffies);
+	delta_jiffies = next_jiffies - last_jiffies;
+
+	/*
+	 * Do not stop the tick, if we are only one off
+	 * or if the cpu is required for rcu
+	 */
+	if (!ts->tick_stopped && (delta_jiffies == 1 || rcu_needs_cpu(cpu)))
+		goto out;
+
+	/* Schedule the tick, if we are at least one jiffie off */
+	if ((long)delta_jiffies >= 1) {
+
+		if (rcu_needs_cpu(cpu))
+			delta_jiffies = 1;
+		else
+			cpu_set(cpu, nohz_cpu_mask);
+		/*
+		 * nohz_stop_sched_tick can be called several times before
+		 * the nohz_restart_sched_tick is called. This happens when
+		 * interrupts arrive which do not cause a reschedule. In the
+		 * first call we save the current tick time, so we can restart
+		 * the scheduler tick in nohz_restart_sched_tick.
+		 */
+		if (!ts->tick_stopped) {
+			ts->idle_tick = ts->sched_timer.expires;
+			ts->tick_stopped = 1;
+			ts->idle_jiffies = last_jiffies;
+		}
+		/*
+		 * calculate the expiry time for the next timer wheel
+		 * timer
+		 */
+		expires = ktime_add_ns(last_update, tick_period.tv64 *
+				       delta_jiffies);
+		ts->idle_expires = expires;
+		ts->idle_sleeps++;
+
+		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
+			hrtimer_start(&ts->sched_timer, expires,
+				      HRTIMER_MODE_ABS);
+			/* Check, if the timer was already in the past */
+			if (hrtimer_active(&ts->sched_timer))
+				goto out;
+		} else if(!tick_program_event(expires, 0))
+				goto out;
+		/*
+		 * We are past the event already. So we crossed a
+		 * jiffie boundary. Update jiffies and raise the
+		 * softirq.
+		 */
+		tick_do_update_jiffies64(ktime_get());
+		cpu_clear(cpu, nohz_cpu_mask);
+	}
+	raise_softirq_irqoff(TIMER_SOFTIRQ);
+out:
+	ts->next_jiffies = next_jiffies;
+	ts->last_jiffies = last_jiffies;
+end:
+	local_irq_restore(flags);
+}
+
+/**
+ * nohz_restart_sched_tick - restart the idle tick from the idle task
+ *
+ * Restart the idle tick when the CPU is woken up from idle
+ */
+void tick_nohz_restart_sched_tick(void)
+{
+	int cpu = smp_processor_id();
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	unsigned long ticks;
+	ktime_t now, delta;
+
+	if (!ts->tick_stopped)
+		return;
+
+	/* Update jiffies first */
+	now = ktime_get();
+
+	local_irq_disable();
+	tick_do_update_jiffies64(now);
+	cpu_clear(cpu, nohz_cpu_mask);
+
+	/* Account the idle time */
+	delta = ktime_sub(now, ts->idle_entrytime);
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+
+	/*
+	 * We stopped the tick in idle. Update process times would miss the
+	 * time we slept as update_process_times does only a 1 tick
+	 * accounting. Enforce that this is accounted to idle !
+	 */
+	ticks = jiffies - ts->idle_jiffies;
+	/*
+	 * We might be one off. Do not randomly account a huge number of ticks!
+	 */
+	if (ticks && ticks < LONG_MAX) {
+		add_preempt_count(HARDIRQ_OFFSET);
+		account_system_time(current, HARDIRQ_OFFSET,
+				    jiffies_to_cputime(ticks));
+		sub_preempt_count(HARDIRQ_OFFSET);
+	}
+
+	/*
+	 * Cancel the scheduled timer and restore the tick
+	 */
+	ts->tick_stopped  = 0;
+	hrtimer_cancel(&ts->sched_timer);
+	ts->sched_timer.expires = ts->idle_tick;
+
+	while (1) {
+		/* Forward the time to expire in the future */
+		hrtimer_forward(&ts->sched_timer, now, tick_period);
+
+		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
+			hrtimer_start(&ts->sched_timer,
+				      ts->sched_timer.expires,
+				      HRTIMER_MODE_ABS);
+			/* Check, if the timer was already in the past */
+			if (hrtimer_active(&ts->sched_timer))
+				break;
+		} else {
+			if (!tick_program_event(ts->sched_timer.expires, 0))
+				break;
+		}
+		/* Update jiffies and reread time */
+		tick_do_update_jiffies64(now);
+		now = ktime_get();
+	}
+	local_irq_enable();
+}
+
+static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
+{
+	hrtimer_forward(&ts->sched_timer, now, tick_period);
+	return tick_program_event(ts->sched_timer.expires, 0);
+}
+
+/*
+ * The nohz low res interrupt handler
+ */
+static void tick_nohz_handler(struct clock_event_device *dev)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct pt_regs *regs = get_irq_regs();
+	ktime_t now = ktime_get();
+
+	dev->next_event.tv64 = KTIME_MAX;
+
+	/* Check, if the jiffies need an update */
+	tick_do_update_jiffies64(now);
+
+	/*
+	 * When we are idle and the tick is stopped, we have to touch
+	 * the watchdog as we might not schedule for a really long
+	 * time. This happens on complete idle SMP systems while
+	 * waiting on the login prompt. We also increment the "start
+	 * of idle" jiffy stamp so the idle accounting adjustment we
+	 * do when we go busy again does not account too much ticks.
+	 */
+	if (ts->tick_stopped) {
+		touch_softlockup_watchdog();
+		ts->idle_jiffies++;
+	}
+
+	update_process_times(user_mode(regs));
+	profile_tick(CPU_PROFILING);
+
+	/* Do not restart, when we are in the idle loop */
+	if (ts->tick_stopped)
+		return;
+
+	while (tick_nohz_reprogram(ts, now)) {
+		now = ktime_get();
+		tick_do_update_jiffies64(now);
+	}
+}
+
+/**
+ * tick_nohz_switch_to_nohz - switch to nohz mode
+ */
+static void tick_nohz_switch_to_nohz(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	ktime_t next;
+
+	if (!tick_nohz_enabled)
+		return;
+
+	local_irq_disable();
+	if (tick_switch_to_oneshot(tick_nohz_handler)) {
+		local_irq_enable();
+		return;
+	}
+
+	ts->nohz_mode = NOHZ_MODE_LOWRES;
+
+	/*
+	 * Recycle the hrtimer in ts, so we can share the
+	 * hrtimer_forward with the highres code.
+	 */
+	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	/* Get the next period */
+	next = tick_init_jiffy_update();
+
+	for (;;) {
+		ts->sched_timer.expires = next;
+		if (!tick_program_event(next, 0))
+			break;
+		next = ktime_add(next, tick_period);
+	}
+	local_irq_enable();
+
+	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n",
+	       smp_processor_id());
+}
+
+#else
+
+static inline void tick_nohz_switch_to_nohz(void) { }
+
+#endif /* NO_HZ */
+
+/*
+ * High resolution timer specific code
+ */
+#ifdef CONFIG_HIGH_RES_TIMERS
+/*
+ * We rearm the timer until we get disabled by the idle code
+ * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ */
+static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
+{
+	struct tick_sched *ts =
+		container_of(timer, struct tick_sched, sched_timer);
+	struct hrtimer_cpu_base *base = timer->base->cpu_base;
+	struct pt_regs *regs = get_irq_regs();
+	ktime_t now = ktime_get();
+
+	/* Check, if the jiffies need an update */
+	tick_do_update_jiffies64(now);
+
+	/*
+	 * Do not call, when we are not in irq context and have
+	 * no valid regs pointer
+	 */
+	if (regs) {
+		/*
+		 * When we are idle and the tick is stopped, we have to touch
+		 * the watchdog as we might not schedule for a really long
+		 * time. This happens on complete idle SMP systems while
+		 * waiting on the login prompt. We also increment the "start of
+		 * idle" jiffy stamp so the idle accounting adjustment we do
+		 * when we go busy again does not account too much ticks.
+		 */
+		if (ts->tick_stopped) {
+			touch_softlockup_watchdog();
+			ts->idle_jiffies++;
+		}
+		/*
+		 * update_process_times() might take tasklist_lock, hence
+		 * drop the base lock. sched-tick hrtimers are per-CPU and
+		 * never accessible by userspace APIs, so this is safe to do.
+		 */
+		spin_unlock(&base->lock);
+		update_process_times(user_mode(regs));
+		profile_tick(CPU_PROFILING);
+		spin_lock(&base->lock);
+	}
+
+	/* Do not restart, when we are in the idle loop */
+	if (ts->tick_stopped)
+		return HRTIMER_NORESTART;
+
+	hrtimer_forward(timer, now, tick_period);
+
+	return HRTIMER_RESTART;
+}
+
+/**
+ * tick_setup_sched_timer - setup the tick emulation timer
+ */
+void tick_setup_sched_timer(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	ktime_t now = ktime_get();
+
+	/*
+	 * Emulate tick processing via per-CPU hrtimers:
+	 */
+	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	ts->sched_timer.function = tick_sched_timer;
+	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+
+	/* Get the next period */
+	ts->sched_timer.expires = tick_init_jiffy_update();
+
+	for (;;) {
+		hrtimer_forward(&ts->sched_timer, now, tick_period);
+		hrtimer_start(&ts->sched_timer, ts->sched_timer.expires,
+			      HRTIMER_MODE_ABS);
+		/* Check, if the timer was already in the past */
+		if (hrtimer_active(&ts->sched_timer))
+			break;
+		now = ktime_get();
+	}
+
+#ifdef CONFIG_NO_HZ
+	if (tick_nohz_enabled)
+		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+#endif
+}
+
+void tick_cancel_sched_timer(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (ts->sched_timer.base)
+		hrtimer_cancel(&ts->sched_timer);
+	ts->tick_stopped = 0;
+	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+}
+#endif /* HIGH_RES_TIMERS */
+
+/**
+ * Async notification about clocksource changes
+ */
+void tick_clock_notify(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		set_bit(0, &per_cpu(tick_cpu_sched, cpu).check_clocks);
+}
+
+/*
+ * Async notification about clock event changes
+ */
+void tick_oneshot_notify(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	set_bit(0, &ts->check_clocks);
+}
+
+/**
+ * Check, if a change happened, which makes oneshot possible.
+ *
+ * Called cyclic from the hrtimer softirq (driven by the timer
+ * softirq) allow_nohz signals, that we can switch into low-res nohz
+ * mode, because high resolution timers are disabled (either compile
+ * or runtime).
+ */
+int tick_check_oneshot_change(int allow_nohz)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (!test_and_clear_bit(0, &ts->check_clocks))
+		return 0;
+
+	if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
+		return 0;
+
+	if (!timekeeping_is_continuous() || !tick_is_oneshot_available())
+		return 0;
+
+	if (!allow_nohz)
+		return 1;
+
+	tick_nohz_switch_to_nohz();
+	return 0;
+}
diff -puN kernel/timer.c~tick-management-dyntick--highres-functionality kernel/timer.c
--- a/kernel/timer.c~tick-management-dyntick--highres-functionality
+++ a/kernel/timer.c
@@ -34,7 +34,7 @@
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
 #include <linux/delay.h>
-#include <linux/clockchips.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -874,6 +874,8 @@ static void change_clocksource(void)
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
+	tick_clock_notify();
+
 	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 	       clock->name);
 }
@@ -937,7 +939,6 @@ void __init timekeeping_init(void)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
-
 /* flag for if timekeeping is suspended */
 static int timekeeping_suspended;
 /* time in seconds when suspend began */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
