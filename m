From: akpm@osdl.org
Subject: + hrtimers-cleanup-locking.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:29 -0800
Message-ID: <200701250636.l0P6aTbw008340@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654AbXAYGzO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:55:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, akpm@osdl.org, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     hrtimers: cleanup locking
has been added to the -mm tree.  Its filename is
     hrtimers-cleanup-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hrtimers: cleanup locking
From: Thomas Gleixner <tglx@linutronix.de>

Improve kernel/hrtimers.c locking: use a per-CPU base with a lock to control
locking of all clocks belonging to a CPU.  This simplifies code that needs to
lock all clocks at once.  This makes life easier for high-res timers and
dyntick.

No functional changes.

[ optimization change from Andrew Morton <akpm@osdl.org> ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |   43 +++++---
 kernel/hrtimer.c        |  184 ++++++++++++++++++++------------------
 2 files changed, 126 insertions(+), 101 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimers-cleanup-locking include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-cleanup-locking
+++ a/include/linux/hrtimer.h
@@ -21,6 +21,9 @@
 #include <linux/list.h>
 #include <linux/wait.h>
 
+struct hrtimer_clock_base;
+struct hrtimer_cpu_base;
+
 /*
  * Mode arguments of xxx_hrtimer functions:
  */
@@ -37,8 +40,6 @@ enum hrtimer_restart {
 	HRTIMER_RESTART,	/* Timer must be restarted */
 };
 
-struct hrtimer_base;
-
 /**
  * struct hrtimer - the basic hrtimer structure
  * @node:	red black tree node for time ordered insertion
@@ -51,10 +52,10 @@ struct hrtimer_base;
  * The hrtimer structure must be initialized by init_hrtimer_#CLOCKTYPE()
  */
 struct hrtimer {
-	struct rb_node		node;
-	ktime_t			expires;
-	enum hrtimer_restart	(*function)(struct hrtimer *);
-	struct hrtimer_base	*base;
+	struct rb_node			node;
+	ktime_t				expires;
+	enum hrtimer_restart		(*function)(struct hrtimer *);
+	struct hrtimer_clock_base	*base;
 };
 
 /**
@@ -71,29 +72,41 @@ struct hrtimer_sleeper {
 
 /**
  * struct hrtimer_base - the timer base for a specific clock
- * @index:		clock type index for per_cpu support when moving a timer
- *			to a base on another cpu.
- * @lock:		lock protecting the base and associated timers
+ * @index:		clock type index for per_cpu support when moving a
+ *			timer to a base on another cpu.
  * @active:		red black tree root node for the active timers
  * @first:		pointer to the timer node which expires first
  * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
  * @get_softirq_time:	function to retrieve the current time from the softirq
- * @curr_timer:		the timer which is executing a callback right now
  * @softirq_time:	the time when running the hrtimer queue in the softirq
- * @lock_key:		the lock_class_key for use with lockdep
  */
-struct hrtimer_base {
+struct hrtimer_clock_base {
+	struct hrtimer_cpu_base	*cpu_base;
 	clockid_t		index;
-	spinlock_t		lock;
 	struct rb_root		active;
 	struct rb_node		*first;
 	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
 	ktime_t			(*get_softirq_time)(void);
-	struct hrtimer		*curr_timer;
 	ktime_t			softirq_time;
-	struct lock_class_key lock_key;
+};
+
+#define HRTIMER_MAX_CLOCK_BASES 2
+
+/*
+ * struct hrtimer_cpu_base - the per cpu clock bases
+ * @lock:		lock protecting the base and associated clock bases
+ *			and timers
+ * @lock_key:		the lock_class_key for use with lockdep
+ * @clock_base:		array of clock bases for this cpu
+ * @curr_timer:		the timer which is executing a callback right now
+ */
+struct hrtimer_cpu_base {
+	spinlock_t			lock;
+	struct lock_class_key		lock_key;
+	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
+	struct hrtimer			*curr_timer;
 };
 
 /*
diff -puN kernel/hrtimer.c~hrtimers-cleanup-locking kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-cleanup-locking
+++ a/kernel/hrtimer.c
@@ -1,8 +1,9 @@
 /*
  *  linux/kernel/hrtimer.c
  *
- *  Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
- *  Copyright(C) 2005, Red Hat, Inc., Ingo Molnar
+ *  Copyright(C) 2005-2006, Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2005-2006, Red Hat, Inc., Ingo Molnar
+ *  Copyright(C) 2006	    Timesys Corp., Thomas Gleixner <tglx@timesys.com>
  *
  *  High-resolution kernel timers
  *
@@ -79,21 +80,22 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  * This ensures that we capture erroneous accesses to these clock ids
  * rather than moving them into the range of valid clock id's.
  */
-
-#define MAX_HRTIMER_BASES 2
-
-static DEFINE_PER_CPU(struct hrtimer_base, hrtimer_bases[MAX_HRTIMER_BASES]) =
+static DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
+
+	.clock_base =
 	{
-		.index = CLOCK_REALTIME,
-		.get_time = &ktime_get_real,
-		.resolution = KTIME_REALTIME_RES,
-	},
-	{
-		.index = CLOCK_MONOTONIC,
-		.get_time = &ktime_get,
-		.resolution = KTIME_MONOTONIC_RES,
-	},
+		{
+			.index = CLOCK_REALTIME,
+			.get_time = &ktime_get_real,
+			.resolution = KTIME_REALTIME_RES,
+		},
+		{
+			.index = CLOCK_MONOTONIC,
+			.get_time = &ktime_get,
+			.resolution = KTIME_MONOTONIC_RES,
+		},
+	}
 };
 
 /**
@@ -125,7 +127,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
  * Get the coarse grained time at the softirq based on xtime and
  * wall_to_monotonic.
  */
-static void hrtimer_get_softirq_time(struct hrtimer_base *base)
+static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
 	ktime_t xtim, tomono;
 	struct timespec xts;
@@ -142,8 +144,9 @@ static void hrtimer_get_softirq_time(str
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(wall_to_monotonic);
-	base[CLOCK_REALTIME].softirq_time = xtim;
-	base[CLOCK_MONOTONIC].softirq_time = ktime_add(xtim, tomono);
+	base->clock_base[CLOCK_REALTIME].softirq_time = xtim;
+	base->clock_base[CLOCK_MONOTONIC].softirq_time =
+		ktime_add(xtim, tomono);
 }
 
 /*
@@ -166,19 +169,20 @@ static void hrtimer_get_softirq_time(str
  * possible to set timer->base = NULL and drop the lock: the timer remains
  * locked.
  */
-static struct hrtimer_base *lock_hrtimer_base(const struct hrtimer *timer,
-					      unsigned long *flags)
+static
+struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
+					     unsigned long *flags)
 {
-	struct hrtimer_base *base;
+	struct hrtimer_clock_base *base;
 
 	for (;;) {
 		base = timer->base;
 		if (likely(base != NULL)) {
-			spin_lock_irqsave(&base->lock, *flags);
+			spin_lock_irqsave(&base->cpu_base->lock, *flags);
 			if (likely(base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU: */
-			spin_unlock_irqrestore(&base->lock, *flags);
+			spin_unlock_irqrestore(&base->cpu_base->lock, *flags);
 		}
 		cpu_relax();
 	}
@@ -187,12 +191,14 @@ static struct hrtimer_base *lock_hrtimer
 /*
  * Switch the timer base to the current CPU when possible.
  */
-static inline struct hrtimer_base *
-switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_base *base)
+static inline struct hrtimer_clock_base *
+switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
-	struct hrtimer_base *new_base;
+	struct hrtimer_clock_base *new_base;
+	struct hrtimer_cpu_base *new_cpu_base;
 
-	new_base = &__get_cpu_var(hrtimer_bases)[base->index];
+	new_cpu_base = &__get_cpu_var(hrtimer_bases);
+	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
 		/*
@@ -204,13 +210,13 @@ switch_hrtimer_base(struct hrtimer *time
 		 * completed. There is no conflict as we hold the lock until
 		 * the timer is enqueued.
 		 */
-		if (unlikely(base->curr_timer == timer))
+		if (unlikely(base->cpu_base->curr_timer == timer))
 			return base;
 
 		/* See the comment in lock_timer_base() */
 		timer->base = NULL;
-		spin_unlock(&base->lock);
-		spin_lock(&new_base->lock);
+		spin_unlock(&base->cpu_base->lock);
+		spin_lock(&new_base->cpu_base->lock);
 		timer->base = new_base;
 	}
 	return new_base;
@@ -220,12 +226,12 @@ switch_hrtimer_base(struct hrtimer *time
 
 #define set_curr_timer(b, t)		do { } while (0)
 
-static inline struct hrtimer_base *
+static inline struct hrtimer_clock_base *
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
-	struct hrtimer_base *base = timer->base;
+	struct hrtimer_clock_base *base = timer->base;
 
-	spin_lock_irqsave(&base->lock, *flags);
+	spin_lock_irqsave(&base->cpu_base->lock, *flags);
 
 	return base;
 }
@@ -305,7 +311,7 @@ void hrtimer_notify_resume(void)
 static inline
 void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
-	spin_unlock_irqrestore(&timer->base->lock, *flags);
+	spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
 }
 
 /**
@@ -355,7 +361,8 @@ hrtimer_forward(struct hrtimer *timer, k
  * The timer is inserted in expiry order. Insertion into the
  * red black tree is O(log(n)). Must hold the base lock.
  */
-static void enqueue_hrtimer(struct hrtimer *timer, struct hrtimer_base *base)
+static void enqueue_hrtimer(struct hrtimer *timer,
+			    struct hrtimer_clock_base *base)
 {
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
@@ -394,7 +401,8 @@ static void enqueue_hrtimer(struct hrtim
  *
  * Caller must hold the base lock.
  */
-static void __remove_hrtimer(struct hrtimer *timer, struct hrtimer_base *base)
+static void __remove_hrtimer(struct hrtimer *timer,
+			     struct hrtimer_clock_base *base)
 {
 	/*
 	 * Remove the timer from the rbtree and replace the
@@ -410,7 +418,7 @@ static void __remove_hrtimer(struct hrti
  * remove hrtimer, called with base lock held
  */
 static inline int
-remove_hrtimer(struct hrtimer *timer, struct hrtimer_base *base)
+remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_active(timer)) {
 		__remove_hrtimer(timer, base);
@@ -432,7 +440,7 @@ remove_hrtimer(struct hrtimer *timer, st
 int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
-	struct hrtimer_base *base, *new_base;
+	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
 	int ret;
 
@@ -479,13 +487,13 @@ EXPORT_SYMBOL_GPL(hrtimer_start);
  */
 int hrtimer_try_to_cancel(struct hrtimer *timer)
 {
-	struct hrtimer_base *base;
+	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	int ret = -1;
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (base->curr_timer != timer)
+	if (base->cpu_base->curr_timer != timer)
 		ret = remove_hrtimer(timer, base);
 
 	unlock_hrtimer_base(timer, &flags);
@@ -521,12 +529,12 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
  */
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
-	struct hrtimer_base *base;
+	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	ktime_t rem;
 
 	base = lock_hrtimer_base(timer, &flags);
-	rem = ktime_sub(timer->expires, timer->base->get_time());
+	rem = ktime_sub(timer->expires, base->get_time());
 	unlock_hrtimer_base(timer, &flags);
 
 	return rem;
@@ -542,26 +550,29 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
  */
 ktime_t hrtimer_get_next_event(void)
 {
-	struct hrtimer_base *base = __get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
 	int i;
 
-	for (i = 0; i < MAX_HRTIMER_BASES; i++, base++) {
+	spin_lock_irqsave(&cpu_base->lock, flags);
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
 
-		spin_lock_irqsave(&base->lock, flags);
-		if (!base->first) {
-			spin_unlock_irqrestore(&base->lock, flags);
+		if (!base->first)
 			continue;
-		}
+
 		timer = rb_entry(base->first, struct hrtimer, node);
 		delta.tv64 = timer->expires.tv64;
-		spin_unlock_irqrestore(&base->lock, flags);
 		delta = ktime_sub(delta, base->get_time());
 		if (delta.tv64 < mindelta.tv64)
 			mindelta.tv64 = delta.tv64;
 	}
+
+	spin_unlock_irqrestore(&cpu_base->lock, flags);
+
 	if (mindelta.tv64 < 0)
 		mindelta.tv64 = 0;
 	return mindelta;
@@ -577,16 +588,16 @@ ktime_t hrtimer_get_next_event(void)
 void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		  enum hrtimer_mode mode)
 {
-	struct hrtimer_base *bases;
+	struct hrtimer_cpu_base *cpu_base;
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
-	bases = __raw_get_cpu_var(hrtimer_bases);
+	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
 
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
 
-	timer->base = &bases[clock_id];
+	timer->base = &cpu_base->clock_base[clock_id];
 	rb_set_parent(&timer->node, &timer->node);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
@@ -601,10 +612,10 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
  */
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
-	struct hrtimer_base *bases;
+	struct hrtimer_cpu_base *cpu_base;
 
-	bases = __raw_get_cpu_var(hrtimer_bases);
-	*tp = ktime_to_timespec(bases[which_clock].resolution);
+	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	*tp = ktime_to_timespec(cpu_base->clock_base[which_clock].resolution);
 
 	return 0;
 }
@@ -613,9 +624,11 @@ EXPORT_SYMBOL_GPL(hrtimer_get_res);
 /*
  * Expire the per base hrtimer-queue:
  */
-static inline void run_hrtimer_queue(struct hrtimer_base *base)
+static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
+				     int index)
 {
 	struct rb_node *node;
+	struct hrtimer_clock_base *base = &cpu_base->clock_base[index];
 
 	if (!base->first)
 		return;
@@ -623,7 +636,7 @@ static inline void run_hrtimer_queue(str
 	if (base->get_softirq_time)
 		base->softirq_time = base->get_softirq_time();
 
-	spin_lock_irq(&base->lock);
+	spin_lock_irq(&cpu_base->lock);
 
 	while ((node = base->first)) {
 		struct hrtimer *timer;
@@ -635,21 +648,21 @@ static inline void run_hrtimer_queue(str
 			break;
 
 		fn = timer->function;
-		set_curr_timer(base, timer);
+		set_curr_timer(cpu_base, timer);
 		__remove_hrtimer(timer, base);
-		spin_unlock_irq(&base->lock);
+		spin_unlock_irq(&cpu_base->lock);
 
 		restart = fn(timer);
 
-		spin_lock_irq(&base->lock);
+		spin_lock_irq(&cpu_base->lock);
 
 		if (restart != HRTIMER_NORESTART) {
 			BUG_ON(hrtimer_active(timer));
 			enqueue_hrtimer(timer, base);
 		}
 	}
-	set_curr_timer(base, NULL);
-	spin_unlock_irq(&base->lock);
+	set_curr_timer(cpu_base, NULL);
+	spin_unlock_irq(&cpu_base->lock);
 }
 
 /*
@@ -657,13 +670,13 @@ static inline void run_hrtimer_queue(str
  */
 void hrtimer_run_queues(void)
 {
-	struct hrtimer_base *base = __get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	int i;
 
-	hrtimer_get_softirq_time(base);
+	hrtimer_get_softirq_time(cpu_base);
 
-	for (i = 0; i < MAX_HRTIMER_BASES; i++)
-		run_hrtimer_queue(&base[i]);
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
+		run_hrtimer_queue(cpu_base, i);
 }
 
 /*
@@ -792,19 +805,21 @@ sys_nanosleep(struct timespec __user *rq
  */
 static void __devinit init_hrtimers_cpu(int cpu)
 {
-	struct hrtimer_base *base = per_cpu(hrtimer_bases, cpu);
+	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	for (i = 0; i < MAX_HRTIMER_BASES; i++, base++) {
-		spin_lock_init(&base->lock);
-		lockdep_set_class(&base->lock, &base->lock_key);
-	}
+	spin_lock_init(&cpu_base->lock);
+	lockdep_set_class(&cpu_base->lock, &cpu_base->lock_key);
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
+		cpu_base->clock_base[i].cpu_base = cpu_base;
+
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static void migrate_hrtimer_list(struct hrtimer_base *old_base,
-				struct hrtimer_base *new_base)
+static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
+				struct hrtimer_clock_base *new_base)
 {
 	struct hrtimer *timer;
 	struct rb_node *node;
@@ -819,29 +834,26 @@ static void migrate_hrtimer_list(struct 
 
 static void migrate_hrtimers(int cpu)
 {
-	struct hrtimer_base *old_base, *new_base;
+	struct hrtimer_cpu_base *old_base, *new_base;
 	int i;
 
 	BUG_ON(cpu_online(cpu));
-	old_base = per_cpu(hrtimer_bases, cpu);
-	new_base = get_cpu_var(hrtimer_bases);
+	old_base = &per_cpu(hrtimer_bases, cpu);
+	new_base = &get_cpu_var(hrtimer_bases);
 
 	local_irq_disable();
 
-	for (i = 0; i < MAX_HRTIMER_BASES; i++) {
-
-		spin_lock(&new_base->lock);
-		spin_lock(&old_base->lock);
+	spin_lock(&new_base->lock);
+	spin_lock(&old_base->lock);
 
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		BUG_ON(old_base->curr_timer);
 
-		migrate_hrtimer_list(old_base, new_base);
-
-		spin_unlock(&old_base->lock);
-		spin_unlock(&new_base->lock);
-		old_base++;
-		new_base++;
+		migrate_hrtimer_list(&old_base->clock_base[i],
+				     &new_base->clock_base[i]);
 	}
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
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
