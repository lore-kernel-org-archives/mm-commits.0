From: akpm@osdl.org
Subject: + hrtimers-add-high-resolution-timer-support.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:37:03 -0800
Message-ID: <200701250637.l0P6b3vj008409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50418 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965561AbXAYGhg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:37:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     hrtimers: add high resolution timer support
has been added to the -mm tree.  Its filename is
     hrtimers-add-high-resolution-timer-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hrtimers: add high resolution timer support
From: Thomas Gleixner <tglx@linutronix.de>

Implement high resolution timers on top of the hrtimers infrastructure and the
clockevents / tick-management framework.  This provides accurate timers for
all hrtimer subsystem users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    4 
 include/linux/hrtimer.h             |  116 +++++
 include/linux/interrupt.h           |    3 
 include/linux/ktime.h               |    3 
 kernel/hrtimer.c                    |  572 +++++++++++++++++++++++---
 kernel/itimer.c                     |    2 
 kernel/posix-timers.c               |    2 
 kernel/time/Kconfig                 |   10 
 8 files changed, 652 insertions(+), 60 deletions(-)

diff -puN Documentation/kernel-parameters.txt~hrtimers-add-high-resolution-timer-support Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~hrtimers-add-high-resolution-timer-support
+++ a/Documentation/kernel-parameters.txt
@@ -610,6 +610,10 @@ and is between 256 and 4096 characters. 
 			highmem otherwise. This also works to reduce highmem
 			size on bigger boxes.
 
+	highres=	[KNL] Enable/disable high resolution timer mode.
+			Valid parameters: "on", "off"
+			Default: "on"
+
 	hisax=		[HW,ISDN]
 			See Documentation/isdn/README.HiSax.
 
diff -puN include/linux/hrtimer.h~hrtimers-add-high-resolution-timer-support include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-add-high-resolution-timer-support
+++ a/include/linux/hrtimer.h
@@ -41,16 +41,35 @@ enum hrtimer_restart {
 };
 
 /*
- * Bit values to track state of the timer
+ * hrtimer callback modes:
+ *
+ *	HRTIMER_CB_SOFTIRQ:		Callback must run in softirq context
+ *	HRTIMER_CB_IRQSAFE:		Callback may run in hardirq context
+ *	HRTIMER_CB_IRQSAFE_NO_RESTART:	Callback may run in hardirq context and
+ *					does not restart the timer
+ *	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:	Callback must run in softirq context
+ *					Special mode for tick emultation
+ */
+enum hrtimer_cb_mode {
+	HRTIMER_CB_SOFTIRQ,
+	HRTIMER_CB_IRQSAFE,
+	HRTIMER_CB_IRQSAFE_NO_RESTART,
+	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ,
+};
+
+/*
+ * Values to track state of the timer
  *
  * Possible states:
  *
  * 0x00		inactive
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
+ * 0x04		callback pending (high resolution mode)
+ *
+ * Special case:
  * 0x03		callback function running and enqueued
  *		(was requeued on another CPU)
- *
  * The "callback function running and enqueued" status is only possible on
  * SMP. It happens for example when a posix timer expired and the callback
  * queued a signal. Between dropping the lock which protects the posix timer
@@ -67,6 +86,7 @@ enum hrtimer_restart {
 #define HRTIMER_STATE_INACTIVE	0x00
 #define HRTIMER_STATE_ENQUEUED	0x01
 #define HRTIMER_STATE_CALLBACK	0x02
+#define HRTIMER_STATE_PENDING	0x04
 
 /**
  * struct hrtimer - the basic hrtimer structure
@@ -77,8 +97,17 @@ enum hrtimer_restart {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
+ * @cb_mode:	high resolution timer feature to select the callback execution
+ *		 mode
+ * @cb_entry:	list head to enqueue an expired timer into the callback list
+ * @start_site:	timer statistics field to store the site where the timer
+ *		was started
+ * @start_comm: timer statistics field to store the name of the process which
+ *		started the timer
+ * @start_pid: timer statistics field to store the pid of the task which
+ *		started the timer
  *
- * The hrtimer structure must be initialized by init_hrtimer_#CLOCKTYPE()
+ * The hrtimer structure must be initialized by hrtimer_init()
  */
 struct hrtimer {
 	struct rb_node			node;
@@ -86,6 +115,10 @@ struct hrtimer {
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
+#ifdef CONFIG_HIGH_RES_TIMERS
+	enum hrtimer_cb_mode		cb_mode;
+	struct list_head		cb_entry;
+#endif
 };
 
 /**
@@ -110,6 +143,9 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @get_softirq_time:	function to retrieve the current time from the softirq
  * @softirq_time:	the time when running the hrtimer queue in the softirq
+ * @cb_pending:		list of timers where the callback is pending
+ * @offset:		offset of this clock to the monotonic base
+ * @reprogram:		function to reprogram the timer event
  */
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
@@ -120,6 +156,12 @@ struct hrtimer_clock_base {
 	ktime_t			(*get_time)(void);
 	ktime_t			(*get_softirq_time)(void);
 	ktime_t			softirq_time;
+#ifdef CONFIG_HIGH_RES_TIMERS
+	ktime_t			offset;
+	int			(*reprogram)(struct hrtimer *t,
+					     struct hrtimer_clock_base *b,
+					     ktime_t n);
+#endif
 };
 
 #define HRTIMER_MAX_CLOCK_BASES 2
@@ -131,19 +173,74 @@ struct hrtimer_clock_base {
  * @lock_key:		the lock_class_key for use with lockdep
  * @clock_base:		array of clock bases for this cpu
  * @curr_timer:		the timer which is executing a callback right now
+ * @expires_next:	absolute time of the next event which was scheduled
+ *			via clock_set_next_event()
+ * @hres_active:	State of high resolution mode
+ * @check_clocks:	Indictator, when set evaluate time source and clock
+ *			event devices whether high resolution mode can be
+ *			activated.
+ * @cb_pending:		Expired timers are moved from the rbtree to this
+ *			list in the timer interrupt. The list is processed
+ *			in the softirq.
+ * @nr_events:		Total number of timer interrupt events
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
+#ifdef CONFIG_HIGH_RES_TIMERS
+	ktime_t				expires_next;
+	int				hres_active;
+	struct list_head		cb_pending;
+	unsigned long			nr_events;
+#endif
 };
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+struct clock_event_device;
+
+extern void clock_was_set(void);
+extern void hrtimer_interrupt(struct clock_event_device *dev);
+
+/*
+ * In high resolution mode the time reference must be read accurate
+ */
+static inline ktime_t hrtimer_cb_get_time(struct hrtimer *timer)
+{
+	return timer->base->get_time();
+}
+
+/*
+ * The resolution of the clocks. The resolution value is returned in
+ * the clock_getres() system call to give application programmers an
+ * idea of the (in)accuracy of timers. Timer values are rounded up to
+ * this resolution values.
+ */
+# define KTIME_HIGH_RES		(ktime_t) { .tv64 = 1 }
+# define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
+
+#else
+
+# define KTIME_MONOTONIC_RES	KTIME_LOW_RES
+
 /*
  * clock_was_set() is a NOP for non- high-resolution systems. The
  * time-sorted order guarantees that a timer does not expire early and
  * is expired in the next softirq when the clock was advanced.
  */
-#define clock_was_set()		do { } while (0)
+static inline void clock_was_set(void) { }
+
+/*
+ * In non high resolution mode the time reference is taken from
+ * the base softirq time variable.
+ */
+static inline ktime_t hrtimer_cb_get_time(struct hrtimer *timer)
+{
+	return timer->base->softirq_time;
+}
+
+#endif
+
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 
@@ -168,9 +265,7 @@ static inline int hrtimer_restart(struct
 extern ktime_t hrtimer_get_remaining(const struct hrtimer *timer);
 extern int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp);
 
-#ifdef CONFIG_NO_IDLE_HZ
 extern ktime_t hrtimer_get_next_event(void);
-#endif
 
 /*
  * A timer is active, when it is enqueued into the rbtree or the callback
@@ -181,6 +276,15 @@ static inline int hrtimer_active(const s
 	return timer->state != HRTIMER_STATE_INACTIVE;
 }
 
+/*
+ * Helper function to check, whether the timer is on one of the queues
+ */
+static inline int hrtimer_is_queued(struct hrtimer *timer)
+{
+	return timer->state &
+		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
+}
+
 /* Forward a hrtimer so it expires after now: */
 extern unsigned long
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
diff -puN include/linux/interrupt.h~hrtimers-add-high-resolution-timer-support include/linux/interrupt.h
--- a/include/linux/interrupt.h~hrtimers-add-high-resolution-timer-support
+++ a/include/linux/interrupt.h
@@ -236,6 +236,9 @@ enum
 	BLOCK_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
+#ifdef CONFIG_HIGH_RES_TIMERS
+	HRTIMER_SOFTIRQ,
+#endif
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff -puN include/linux/ktime.h~hrtimers-add-high-resolution-timer-support include/linux/ktime.h
--- a/include/linux/ktime.h~hrtimers-add-high-resolution-timer-support
+++ a/include/linux/ktime.h
@@ -261,8 +261,7 @@ static inline s64 ktime_to_ns(const ktim
  * idea of the (in)accuracy of timers. Timer values are rounded up to
  * this resolution values.
  */
-#define KTIME_REALTIME_RES	(ktime_t){ .tv64 = TICK_NSEC }
-#define KTIME_MONOTONIC_RES	(ktime_t){ .tv64 = TICK_NSEC }
+#define KTIME_LOW_RES		(ktime_t){ .tv64 = TICK_NSEC }
 
 /* Get the monotonic time in timespec format: */
 extern void ktime_get_ts(struct timespec *ts);
diff -puN kernel/hrtimer.c~hrtimers-add-high-resolution-timer-support kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-add-high-resolution-timer-support
+++ a/kernel/hrtimer.c
@@ -3,7 +3,7 @@
  *
  *  Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
  *  Copyright(C) 2005-2007, Red Hat, Inc., Ingo Molnar
- *  Copyright(C) 2006-2007  Timesys Corp., Thomas Gleixner <tglx@timesys.com>
+ *  Copyright(C) 2006-2007  Timesys Corp., Thomas Gleixner
  *
  *  High-resolution kernel timers
  *
@@ -32,13 +32,17 @@
  */
 
 #include <linux/cpu.h>
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
 #include <linux/notifier.h>
 #include <linux/syscalls.h>
+#include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/tick.h>
+#include <linux/seq_file.h>
+#include <linux/err.h>
 
 #include <asm/uaccess.h>
 
@@ -81,7 +85,7 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  * This ensures that we capture erroneous accesses to these clock ids
  * rather than moving them into the range of valid clock id's.
  */
-static DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
+DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
 
 	.clock_base =
@@ -89,12 +93,12 @@ static DEFINE_PER_CPU(struct hrtimer_cpu
 		{
 			.index = CLOCK_REALTIME,
 			.get_time = &ktime_get_real,
-			.resolution = KTIME_REALTIME_RES,
+			.resolution = KTIME_LOW_RES,
 		},
 		{
 			.index = CLOCK_MONOTONIC,
 			.get_time = &ktime_get,
-			.resolution = KTIME_MONOTONIC_RES,
+			.resolution = KTIME_LOW_RES,
 		},
 	}
 };
@@ -151,14 +155,6 @@ static void hrtimer_get_softirq_time(str
 }
 
 /*
- * Helper function to check, whether the timer is on one of the queues
- */
-static inline int hrtimer_is_queued(struct hrtimer *timer)
-{
-	return timer->state & HRTIMER_STATE_ENQUEUED;
-}
-
-/*
  * Helper function to check, whether the timer is running the callback
  * function
  */
@@ -226,7 +222,7 @@ switch_hrtimer_base(struct hrtimer *time
 		 * completed. There is no conflict as we hold the lock until
 		 * the timer is enqueued.
 		 */
-		if (unlikely(timer->state & HRTIMER_STATE_CALLBACK))
+		if (unlikely(hrtimer_callback_running(timer)))
 			return base;
 
 		/* See the comment in lock_timer_base() */
@@ -250,7 +246,7 @@ lock_hrtimer_base(const struct hrtimer *
 	return base;
 }
 
-#define switch_hrtimer_base(t, b)	(b)
+# define switch_hrtimer_base(t, b)	(b)
 
 #endif	/* !CONFIG_SMP */
 
@@ -281,9 +277,6 @@ ktime_t ktime_add_ns(const ktime_t kt, u
 
 	return ktime_add(kt, tmp);
 }
-
-#else /* CONFIG_KTIME_SCALAR */
-
 # endif /* !CONFIG_KTIME_SCALAR */
 
 /*
@@ -308,6 +301,290 @@ unsigned long ktime_divns(const ktime_t 
 }
 #endif /* BITS_PER_LONG >= 64 */
 
+/* High resolution timer related functions */
+#ifdef CONFIG_HIGH_RES_TIMERS
+
+/*
+ * High resolution timer enabled ?
+ */
+static int hrtimer_hres_enabled __read_mostly  = 1;
+
+/*
+ * Enable / Disable high resolution mode
+ */
+static int __init setup_hrtimer_hres(char *str)
+{
+	if (!strcmp(str, "off"))
+		hrtimer_hres_enabled = 0;
+	else if (!strcmp(str, "on"))
+		hrtimer_hres_enabled = 1;
+	else
+		return 0;
+	return 1;
+}
+
+__setup("highres=", setup_hrtimer_hres);
+
+/*
+ * hrtimer_high_res_enabled - query, if the highres mode is enabled
+ */
+static inline int hrtimer_is_hres_enabled(void)
+{
+	return hrtimer_hres_enabled;
+}
+
+/*
+ * Is the high resolution mode active ?
+ */
+static inline int hrtimer_hres_active(void)
+{
+	return __get_cpu_var(hrtimer_bases).hres_active;
+}
+
+/*
+ * Reprogram the event source with checking both queues for the
+ * next event
+ * Called with interrupts disabled and base->lock held
+ */
+static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
+{
+	int i;
+	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	ktime_t expires;
+
+	cpu_base->expires_next.tv64 = KTIME_MAX;
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		struct hrtimer *timer;
+
+		if (!base->first)
+			continue;
+		timer = rb_entry(base->first, struct hrtimer, node);
+		expires = ktime_sub(timer->expires, base->offset);
+		if (expires.tv64 < cpu_base->expires_next.tv64)
+			cpu_base->expires_next = expires;
+	}
+
+	if (cpu_base->expires_next.tv64 != KTIME_MAX)
+		tick_program_event(cpu_base->expires_next, 1);
+}
+
+/*
+ * Shared reprogramming for clock_realtime and clock_monotonic
+ *
+ * When a timer is enqueued and expires earlier than the already enqueued
+ * timers, we have to check, whether it expires earlier than the timer for
+ * which the clock event device was armed.
+ *
+ * Called with interrupts disabled and base->cpu_base.lock held
+ */
+static int hrtimer_reprogram(struct hrtimer *timer,
+			     struct hrtimer_clock_base *base)
+{
+	ktime_t *expires_next = &__get_cpu_var(hrtimer_bases).expires_next;
+	ktime_t expires = ktime_sub(timer->expires, base->offset);
+	int res;
+
+	/*
+	 * When the callback is running, we do not reprogram the clock event
+	 * device. The timer callback is either running on a different CPU or
+	 * the callback is executed in the hrtimer_interupt context. The
+	 * reprogramming is handled either by the softirq, which called the
+	 * callback or at the end of the hrtimer_interrupt.
+	 */
+	if (hrtimer_callback_running(timer))
+		return 0;
+
+	if (expires.tv64 >= expires_next->tv64)
+		return 0;
+
+	/*
+	 * Clockevents returns -ETIME, when the event was in the past.
+	 */
+	res = tick_program_event(expires, 0);
+	if (!IS_ERR_VALUE(res))
+		*expires_next = expires;
+	return res;
+}
+
+
+/*
+ * Retrigger next event is called after clock was set
+ *
+ * Called with interrupts disabled via on_each_cpu()
+ */
+static void retrigger_next_event(void *arg)
+{
+	struct hrtimer_cpu_base *base;
+	struct timespec realtime_offset;
+	unsigned long seq;
+
+	if (!hrtimer_hres_active())
+		return;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		set_normalized_timespec(&realtime_offset,
+					-wall_to_monotonic.tv_sec,
+					-wall_to_monotonic.tv_nsec);
+	} while (read_seqretry(&xtime_lock, seq));
+
+	base = &__get_cpu_var(hrtimer_bases);
+
+	/* Adjust CLOCK_REALTIME offset */
+	spin_lock(&base->lock);
+	base->clock_base[CLOCK_REALTIME].offset =
+		timespec_to_ktime(realtime_offset);
+
+	hrtimer_force_reprogram(base);
+	spin_unlock(&base->lock);
+}
+
+/*
+ * Clock realtime was set
+ *
+ * Change the offset of the realtime clock vs. the monotonic
+ * clock.
+ *
+ * We might have to reprogram the high resolution timer interrupt. On
+ * SMP we call the architecture specific code to retrigger _all_ high
+ * resolution timer interrupts. On UP we just disable interrupts and
+ * call the high resolution interrupt code.
+ */
+void clock_was_set(void)
+{
+	/* Retrigger the CPU local events everywhere */
+	on_each_cpu(retrigger_next_event, NULL, 0, 1);
+}
+
+/*
+ * Check, whether the timer is on the callback pending list
+ */
+static inline int hrtimer_cb_pending(const struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_PENDING;
+}
+
+/*
+ * Remove a timer from the callback pending list
+ */
+static inline void hrtimer_remove_cb_pending(struct hrtimer *timer)
+{
+	list_del_init(&timer->cb_entry);
+}
+
+/*
+ * Initialize the high resolution related parts of cpu_base
+ */
+static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
+{
+	base->expires_next.tv64 = KTIME_MAX;
+	base->hres_active = 0;
+	INIT_LIST_HEAD(&base->cb_pending);
+}
+
+/*
+ * Initialize the high resolution related parts of a hrtimer
+ */
+static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
+{
+	INIT_LIST_HEAD(&timer->cb_entry);
+}
+
+/*
+ * When High resolution timers are active, try to reprogram. Note, that in case
+ * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
+ * check happens. The timer gets enqueued into the rbtree. The reprogramming
+ * and expiry check is done in the hrtimer_interrupt or in the softirq.
+ */
+static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
+					    struct hrtimer_clock_base *base)
+{
+	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
+
+		/* Timer is expired, act upon the callback mode */
+		switch(timer->cb_mode) {
+		case HRTIMER_CB_IRQSAFE_NO_RESTART:
+			/*
+			 * We can call the callback from here. No restart
+			 * happens, so no danger of recursion
+			 */
+			BUG_ON(timer->function(timer) != HRTIMER_NORESTART);
+			return 1;
+		case HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:
+			/*
+			 * This is solely for the sched tick emulation with
+			 * dynamic tick support to ensure that we do not
+			 * restart the tick right on the edge and end up with
+			 * the tick timer in the softirq ! The calling site
+			 * takes care of this.
+			 */
+			return 1;
+		case HRTIMER_CB_IRQSAFE:
+		case HRTIMER_CB_SOFTIRQ:
+			/*
+			 * Move everything else into the softirq pending list !
+			 */
+			list_add_tail(&timer->cb_entry,
+				      &base->cpu_base->cb_pending);
+			timer->state = HRTIMER_STATE_PENDING;
+			raise_softirq(HRTIMER_SOFTIRQ);
+			return 1;
+		default:
+			BUG();
+		}
+	}
+	return 0;
+}
+
+/*
+ * Switch to high resolution mode
+ */
+static void hrtimer_switch_to_hres(void)
+{
+	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	unsigned long flags;
+
+	if (base->hres_active)
+		return;
+
+	local_irq_save(flags);
+
+	if (tick_init_highres()) {
+		local_irq_restore(flags);
+		return;
+	}
+	base->hres_active = 1;
+	base->clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES;
+	base->clock_base[CLOCK_MONOTONIC].resolution = KTIME_HIGH_RES;
+
+	tick_setup_sched_timer();
+
+	/* "Retrigger" the interrupt to get things going */
+	retrigger_next_event(NULL);
+	local_irq_restore(flags);
+	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
+	       smp_processor_id());
+}
+
+#else
+
+static inline int hrtimer_hres_active(void) { return 0; }
+static inline int hrtimer_is_hres_enabled(void) { return 0; }
+static inline void hrtimer_switch_to_hres(void) { }
+static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
+static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
+					    struct hrtimer_clock_base *base)
+{
+	return 0;
+}
+static inline int hrtimer_cb_pending(struct hrtimer *timer) { return 0; }
+static inline void hrtimer_remove_cb_pending(struct hrtimer *timer) { }
+static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
+static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
+
+#endif /* CONFIG_HIGH_RES_TIMERS */
+
 /*
  * Counterpart to lock_timer_base above:
  */
@@ -365,7 +642,7 @@ hrtimer_forward(struct hrtimer *timer, k
  * red black tree is O(log(n)). Must hold the base lock.
  */
 static void enqueue_hrtimer(struct hrtimer *timer,
-			    struct hrtimer_clock_base *base)
+			    struct hrtimer_clock_base *base, int reprogram)
 {
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
@@ -391,6 +668,22 @@ static void enqueue_hrtimer(struct hrtim
 	 * Insert the timer to the rbtree and check whether it
 	 * replaces the first pending timer
 	 */
+	if (!base->first || timer->expires.tv64 <
+	    rb_entry(base->first, struct hrtimer, node)->expires.tv64) {
+		/*
+		 * Reprogram the clock event device. When the timer is already
+		 * expired hrtimer_enqueue_reprogram has either called the
+		 * callback or added it to the pending list and raised the
+		 * softirq.
+		 *
+		 * This is a NOP for !HIGHRES
+		 */
+		if (reprogram && hrtimer_enqueue_reprogram(timer, base))
+			return;
+
+		base->first = &timer->node;
+	}
+
 	rb_link_node(&timer->node, parent, link);
 	rb_insert_color(&timer->node, &base->active);
 	/*
@@ -398,28 +691,38 @@ static void enqueue_hrtimer(struct hrtim
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
-
-	if (!base->first || timer->expires.tv64 <
-	    rb_entry(base->first, struct hrtimer, node)->expires.tv64)
-		base->first = &timer->node;
 }
 
 /*
  * __remove_hrtimer - internal function to remove a timer
  *
  * Caller must hold the base lock.
+ *
+ * High resolution timer mode reprograms the clock event device when the
+ * timer is the one which expires next. The caller can disable this by setting
+ * reprogram to zero. This is useful, when the context does a reprogramming
+ * anyway (e.g. timer interrupt)
  */
 static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
-			     unsigned long newstate)
+			     unsigned long newstate, int reprogram)
 {
-	/*
-	 * Remove the timer from the rbtree and replace the
-	 * first entry pointer if necessary.
-	 */
-	if (base->first == &timer->node)
-		base->first = rb_next(&timer->node);
-	rb_erase(&timer->node, &base->active);
+	/* High res. callback list. NOP for !HIGHRES */
+	if (hrtimer_cb_pending(timer))
+		hrtimer_remove_cb_pending(timer);
+	else {
+		/*
+		 * Remove the timer from the rbtree and replace the
+		 * first entry pointer if necessary.
+		 */
+		if (base->first == &timer->node) {
+			base->first = rb_next(&timer->node);
+			/* Reprogram the clock event device. if enabled */
+			if (reprogram && hrtimer_hres_active())
+				hrtimer_force_reprogram(base->cpu_base);
+		}
+		rb_erase(&timer->node, &base->active);
+	}
 	timer->state = newstate;
 }
 
@@ -430,7 +733,19 @@ static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
-		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE);
+		int reprogram;
+
+		/*
+		 * Remove the timer and force reprogramming when high
+		 * resolution mode is active and the timer is on the current
+		 * CPU. If we remove a timer on another CPU, reprogramming is
+		 * skipped. The interrupt event on this CPU is fired and
+		 * reprogramming happens in the interrupt handler. This is a
+		 * rare case and less expensive than a smp call.
+		 */
+		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
+		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
+				 reprogram);
 		return 1;
 	}
 	return 0;
@@ -476,7 +791,7 @@ hrtimer_start(struct hrtimer *timer, kti
 	}
 	timer->expires = tim;
 
-	enqueue_hrtimer(timer, new_base);
+	enqueue_hrtimer(timer, new_base, base == new_base);
 
 	unlock_hrtimer_base(timer, &flags);
 
@@ -567,17 +882,19 @@ ktime_t hrtimer_get_next_event(void)
 
 	spin_lock_irqsave(&cpu_base->lock, flags);
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-		struct hrtimer *timer;
-
-		if (!base->first)
-			continue;
-
-		timer = rb_entry(base->first, struct hrtimer, node);
-		delta.tv64 = timer->expires.tv64;
-		delta = ktime_sub(delta, base->get_time());
-		if (delta.tv64 < mindelta.tv64)
-			mindelta.tv64 = delta.tv64;
+	if (!hrtimer_hres_active()) {
+		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+			struct hrtimer *timer;
+
+			if (!base->first)
+				continue;
+
+			timer = rb_entry(base->first, struct hrtimer, node);
+			delta.tv64 = timer->expires.tv64;
+			delta = ktime_sub(delta, base->get_time());
+			if (delta.tv64 < mindelta.tv64)
+				mindelta.tv64 = delta.tv64;
+		}
 	}
 
 	spin_unlock_irqrestore(&cpu_base->lock, flags);
@@ -607,6 +924,7 @@ void hrtimer_init(struct hrtimer *timer,
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &cpu_base->clock_base[clock_id];
+	hrtimer_init_timer_hres(timer);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
@@ -629,6 +947,139 @@ int hrtimer_get_res(const clockid_t whic
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+
+/*
+ * High resolution timer interrupt
+ * Called with interrupts disabled
+ */
+void hrtimer_interrupt(struct clock_event_device *dev)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base;
+	ktime_t expires_next, now;
+	int i, raise = 0;
+
+	BUG_ON(!cpu_base->hres_active);
+	cpu_base->nr_events++;
+	dev->next_event.tv64 = KTIME_MAX;
+
+ retry:
+	now = ktime_get();
+
+	expires_next.tv64 = KTIME_MAX;
+
+	base = cpu_base->clock_base;
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+		ktime_t basenow;
+		struct rb_node *node;
+
+		spin_lock(&cpu_base->lock);
+
+		basenow = ktime_add(now, base->offset);
+
+		while ((node = base->first)) {
+			struct hrtimer *timer;
+
+			timer = rb_entry(node, struct hrtimer, node);
+
+			if (basenow.tv64 < timer->expires.tv64) {
+				ktime_t expires;
+
+				expires = ktime_sub(timer->expires,
+						    base->offset);
+				if (expires.tv64 < expires_next.tv64)
+					expires_next = expires;
+				break;
+			}
+
+			/* Move softirq callbacks to the pending list */
+			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
+				__remove_hrtimer(timer, base,
+						 HRTIMER_STATE_PENDING, 0);
+				list_add_tail(&timer->cb_entry,
+					      &base->cpu_base->cb_pending);
+				raise = 1;
+				continue;
+			}
+
+			__remove_hrtimer(timer, base,
+					 HRTIMER_STATE_CALLBACK, 0);
+
+			/*
+			 * Note: We clear the CALLBACK bit after
+			 * enqueue_hrtimer to avoid reprogramming of
+			 * the event hardware. This happens at the end
+			 * of this function anyway.
+			 */
+			if (timer->function(timer) != HRTIMER_NORESTART) {
+				BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+				enqueue_hrtimer(timer, base, 0);
+			}
+			timer->state &= ~HRTIMER_STATE_CALLBACK;
+		}
+		spin_unlock(&cpu_base->lock);
+		base++;
+	}
+
+	cpu_base->expires_next = expires_next;
+
+	/* Reprogramming necessary ? */
+	if (expires_next.tv64 != KTIME_MAX) {
+		if (tick_program_event(expires_next, 0))
+			goto retry;
+	}
+
+	/* Raise softirq ? */
+	if (raise)
+		raise_softirq(HRTIMER_SOFTIRQ);
+}
+
+static void run_hrtimer_softirq(struct softirq_action *h)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	spin_lock_irq(&cpu_base->lock);
+
+	while (!list_empty(&cpu_base->cb_pending)) {
+		enum hrtimer_restart (*fn)(struct hrtimer *);
+		struct hrtimer *timer;
+		int restart;
+
+		timer = list_entry(cpu_base->cb_pending.next,
+				   struct hrtimer, cb_entry);
+
+		fn = timer->function;
+		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
+		spin_unlock_irq(&cpu_base->lock);
+
+		restart = fn(timer);
+
+		spin_lock_irq(&cpu_base->lock);
+
+		timer->state &= ~HRTIMER_STATE_CALLBACK;
+		if (restart == HRTIMER_RESTART) {
+			BUG_ON(hrtimer_active(timer));
+			/*
+			 * Enqueue the timer, allow reprogramming of the event
+			 * device
+			 */
+			enqueue_hrtimer(timer, timer->base, 1);
+		} else if (hrtimer_active(timer)) {
+			/*
+			 * If the timer was rearmed on another CPU, reprogram
+			 * the event device.
+			 */
+			if (timer->base->first == &timer->node)
+				hrtimer_reprogram(timer, timer->base);
+		}
+	}
+	spin_unlock_irq(&cpu_base->lock);
+}
+
+#endif	/* CONFIG_HIGH_RES_TIMERS */
+
 /*
  * Expire the per base hrtimer-queue:
  */
@@ -656,7 +1107,7 @@ static inline void run_hrtimer_queue(str
 			break;
 
 		fn = timer->function;
-		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
+		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 		spin_unlock_irq(&cpu_base->lock);
 
 		restart = fn(timer);
@@ -666,7 +1117,7 @@ static inline void run_hrtimer_queue(str
 		timer->state &= ~HRTIMER_STATE_CALLBACK;
 		if (restart != HRTIMER_NORESTART) {
 			BUG_ON(hrtimer_active(timer));
-			enqueue_hrtimer(timer, base);
+			enqueue_hrtimer(timer, base, 0);
 		}
 	}
 	spin_unlock_irq(&cpu_base->lock);
@@ -674,12 +1125,19 @@ static inline void run_hrtimer_queue(str
 
 /*
  * Called from timer softirq every jiffy, expire hrtimers:
+ *
+ * For HRT its the fall back code to run the softirq in the timer
+ * softirq context in case the hrtimer initialization failed or has
+ * not been done yet.
  */
 void hrtimer_run_queues(void)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	int i;
 
+	if (hrtimer_hres_active())
+		return;
+
 	/*
 	 * This _is_ ugly: We have to check in the softirq context,
 	 * whether we can switch to highres and / or nohz mode. The
@@ -688,7 +1146,8 @@ void hrtimer_run_queues(void)
 	 * check bit in the tick_oneshot code, otherwise we might
 	 * deadlock vs. xtime_lock.
 	 */
-	tick_check_oneshot_change(1);
+	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
+		hrtimer_switch_to_hres();
 
 	hrtimer_get_softirq_time(cpu_base);
 
@@ -716,6 +1175,9 @@ void hrtimer_init_sleeper(struct hrtimer
 {
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
+#ifdef CONFIG_HIGH_RES_TIMERS
+	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_RESTART;
+#endif
 }
 
 static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
@@ -726,7 +1188,8 @@ static int __sched do_nanosleep(struct h
 		set_current_state(TASK_INTERRUPTIBLE);
 		hrtimer_start(&t->timer, t->timer.expires, mode);
 
-		schedule();
+		if (likely(t->task))
+			schedule();
 
 		hrtimer_cancel(&t->timer);
 		mode = HRTIMER_MODE_ABS;
@@ -831,6 +1294,7 @@ static void __devinit init_hrtimers_cpu(
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 
+	hrtimer_init_hres(cpu_base);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -843,10 +1307,13 @@ static void migrate_hrtimer_list(struct 
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
-		BUG_ON(timer->state & HRTIMER_STATE_CALLBACK);
-		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE);
+		BUG_ON(hrtimer_callback_running(timer));
+		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE, 0);
 		timer->base = new_base;
-		enqueue_hrtimer(timer, new_base);
+		/*
+		 * Enqueue the timer. Allow reprogramming of the event device
+		 */
+		enqueue_hrtimer(timer, new_base, 1);
 	}
 }
 
@@ -859,6 +1326,8 @@ static void migrate_hrtimers(int cpu)
 	old_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &get_cpu_var(hrtimer_bases);
 
+	tick_cancel_sched_timer(cpu);
+
 	local_irq_disable();
 
 	spin_lock(&new_base->lock);
@@ -909,5 +1378,8 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
+#ifdef CONFIG_HIGH_RES_TIMERS
+	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
+#endif
 }
 
diff -puN kernel/itimer.c~hrtimers-add-high-resolution-timer-support kernel/itimer.c
--- a/kernel/itimer.c~hrtimers-add-high-resolution-timer-support
+++ a/kernel/itimer.c
@@ -136,7 +136,7 @@ enum hrtimer_restart it_real_fn(struct h
 	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
 
 	if (sig->it_real_incr.tv64 != 0) {
-		hrtimer_forward(timer, timer->base->softirq_time,
+		hrtimer_forward(timer, hrtimer_cb_get_time(timer),
 				sig->it_real_incr);
 		return HRTIMER_RESTART;
 	}
diff -puN kernel/posix-timers.c~hrtimers-add-high-resolution-timer-support kernel/posix-timers.c
--- a/kernel/posix-timers.c~hrtimers-add-high-resolution-timer-support
+++ a/kernel/posix-timers.c
@@ -356,7 +356,7 @@ static enum hrtimer_restart posix_timer_
 		if (timr->it.real.interval.tv64 != 0) {
 			timr->it_overrun +=
 				hrtimer_forward(timer,
-						timer->base->softirq_time,
+						hrtimer_cb_get_time(timer),
 						timr->it.real.interval);
 			ret = HRTIMER_RESTART;
 			++timr->it_requeue_pending;
diff -puN kernel/time/Kconfig~hrtimers-add-high-resolution-timer-support kernel/time/Kconfig
--- a/kernel/time/Kconfig~hrtimers-add-high-resolution-timer-support
+++ a/kernel/time/Kconfig
@@ -13,3 +13,13 @@ config NO_HZ
 	  This option enables a tickless system: timer interrupts will
 	  only trigger on an as-needed basis both when the system is
 	  busy and when the system is idle.
+
+config HIGH_RES_TIMERS
+	bool "High Resolution Timer Support"
+	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	select TICK_ONESHOT
+	help
+	  This option enables high resolution timer support. If your
+	  hardware is not capable then this option only increases
+	  the size of the kernel image.
+
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
