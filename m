From: akpm@linux-foundation.org
Subject: - hrtimers-namespace-and-enum-cleanup.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:22 -0800
Message-ID: <200702170714.l1H7EM53021521@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51567 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946464AbXBQH1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, dtor@mail.ru, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrtimers: namespace and enum cleanup
has been removed from the -mm tree.  Its filename was
     hrtimers-namespace-and-enum-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimers: namespace and enum cleanup
From: Thomas Gleixner <tglx@linutronix.de>

- hrtimers did not use the hrtimer_restart enum and relied on the implict
  int representation. Fix the prototypes and the functions using the enums.
- Use seperate name spaces for the enumerations
- Convert hrtimer_restart macro to inline function
- Add comments

No functional changes.

[akpm@osdl.org: fix input driver]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |   11 ++++++-----
 include/linux/hrtimer.h             |   20 ++++++++++++--------
 include/linux/timer.h               |    2 +-
 kernel/fork.c                       |    2 +-
 kernel/futex.c                      |    2 +-
 kernel/hrtimer.c                    |   18 +++++++++---------
 kernel/itimer.c                     |    4 ++--
 kernel/posix-timers.c               |   13 +++++++------
 kernel/rtmutex.c                    |    2 +-
 9 files changed, 40 insertions(+), 34 deletions(-)

diff -puN drivers/input/touchscreen/ads7846.c~hrtimers-namespace-and-enum-cleanup drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~hrtimers-namespace-and-enum-cleanup
+++ a/drivers/input/touchscreen/ads7846.c
@@ -546,7 +546,7 @@ static void ads7846_rx(void *ads)
 			ts->spi->dev.bus_id, ts->tc.ignore, Rt);
 #endif
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			      HRTIMER_REL);
+			      HRTIMER_MODE_REL);
 		return;
 	}
 
@@ -578,7 +578,8 @@ static void ads7846_rx(void *ads)
 #endif
 	}
 
-	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD), HRTIMER_REL);
+	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
+			HRTIMER_MODE_REL);
 }
 
 static int ads7846_debounce(void *ads, int data_idx, int *val)
@@ -667,7 +668,7 @@ static void ads7846_rx_val(void *ads)
 				status);
 }
 
-static int ads7846_timer(struct hrtimer *handle)
+static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 {
 	struct ads7846	*ts = container_of(handle, struct ads7846, timer);
 	int		status = 0;
@@ -724,7 +725,7 @@ static irqreturn_t ads7846_irq(int irq, 
 			disable_irq(ts->spi->irq);
 			ts->pending = 1;
 			hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
-					HRTIMER_REL);
+					HRTIMER_MODE_REL);
 		}
 	}
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -862,7 +863,7 @@ static int __devinit ads7846_probe(struc
 	ts->spi = spi;
 	ts->input = input_dev;
 
-	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_REL);
+	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ts->timer.function = ads7846_timer;
 
 	spin_lock_init(&ts->lock);
diff -puN include/linux/hrtimer.h~hrtimers-namespace-and-enum-cleanup include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-namespace-and-enum-cleanup
+++ a/include/linux/hrtimer.h
@@ -25,17 +25,18 @@
  * Mode arguments of xxx_hrtimer functions:
  */
 enum hrtimer_mode {
-	HRTIMER_ABS,	/* Time value is absolute */
-	HRTIMER_REL,	/* Time value is relative to now */
+	HRTIMER_MODE_ABS,	/* Time value is absolute */
+	HRTIMER_MODE_REL,	/* Time value is relative to now */
 };
 
+/*
+ * Return values for the callback function
+ */
 enum hrtimer_restart {
-	HRTIMER_NORESTART,
-	HRTIMER_RESTART,
+	HRTIMER_NORESTART,	/* Timer is not restarted */
+	HRTIMER_RESTART,	/* Timer must be restarted */
 };
 
-#define HRTIMER_INACTIVE	((void *)1UL)
-
 struct hrtimer_base;
 
 /**
@@ -52,7 +53,7 @@ struct hrtimer_base;
 struct hrtimer {
 	struct rb_node		node;
 	ktime_t			expires;
-	int			(*function)(struct hrtimer *);
+	enum hrtimer_restart	(*function)(struct hrtimer *);
 	struct hrtimer_base	*base;
 };
 
@@ -114,7 +115,10 @@ extern int hrtimer_start(struct hrtimer 
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
-#define hrtimer_restart(timer) hrtimer_start((timer), (timer)->expires, HRTIMER_ABS)
+static inline int hrtimer_restart(struct hrtimer *timer)
+{
+	return hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
+}
 
 /* Query timers: */
 extern ktime_t hrtimer_get_remaining(const struct hrtimer *timer);
diff -puN include/linux/timer.h~hrtimers-namespace-and-enum-cleanup include/linux/timer.h
--- a/include/linux/timer.h~hrtimers-namespace-and-enum-cleanup
+++ a/include/linux/timer.h
@@ -106,7 +106,7 @@ static inline void add_timer(struct time
 extern void init_timers(void);
 extern void run_local_timers(void);
 struct hrtimer;
-extern int it_real_fn(struct hrtimer *);
+extern enum hrtimer_restart it_real_fn(struct hrtimer *);
 
 unsigned long __round_jiffies(unsigned long j, int cpu);
 unsigned long __round_jiffies_relative(unsigned long j, int cpu);
diff -puN kernel/fork.c~hrtimers-namespace-and-enum-cleanup kernel/fork.c
--- a/kernel/fork.c~hrtimers-namespace-and-enum-cleanup
+++ a/kernel/fork.c
@@ -858,7 +858,7 @@ static inline int copy_signal(unsigned l
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
-	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_REL);
+	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
 	sig->tsk = tsk;
diff -puN kernel/futex.c~hrtimers-namespace-and-enum-cleanup kernel/futex.c
--- a/kernel/futex.c~hrtimers-namespace-and-enum-cleanup
+++ a/kernel/futex.c
@@ -1134,7 +1134,7 @@ static int futex_lock_pi(u32 __user *uad
 
 	if (sec != MAX_SCHEDULE_TIMEOUT) {
 		to = &timeout;
-		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_ABS);
+		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		to->timer.expires = ktime_set(sec, nsec);
 	}
diff -puN kernel/hrtimer.c~hrtimers-namespace-and-enum-cleanup kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-namespace-and-enum-cleanup
+++ a/kernel/hrtimer.c
@@ -444,7 +444,7 @@ hrtimer_start(struct hrtimer *timer, kti
 	/* Switch the timer base, if necessary: */
 	new_base = switch_hrtimer_base(timer, base);
 
-	if (mode == HRTIMER_REL) {
+	if (mode == HRTIMER_MODE_REL) {
 		tim = ktime_add(tim, new_base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
@@ -583,7 +583,7 @@ void hrtimer_init(struct hrtimer *timer,
 
 	bases = __raw_get_cpu_var(hrtimer_bases);
 
-	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_ABS)
+	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &bases[clock_id];
@@ -627,7 +627,7 @@ static inline void run_hrtimer_queue(str
 
 	while ((node = base->first)) {
 		struct hrtimer *timer;
-		int (*fn)(struct hrtimer *);
+		enum hrtimer_restart (*fn)(struct hrtimer *);
 		int restart;
 
 		timer = rb_entry(node, struct hrtimer, node);
@@ -669,7 +669,7 @@ void hrtimer_run_queues(void)
 /*
  * Sleep related functions:
  */
-static int hrtimer_wakeup(struct hrtimer *timer)
+static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
 {
 	struct hrtimer_sleeper *t =
 		container_of(timer, struct hrtimer_sleeper, timer);
@@ -699,7 +699,7 @@ static int __sched do_nanosleep(struct h
 		schedule();
 
 		hrtimer_cancel(&t->timer);
-		mode = HRTIMER_ABS;
+		mode = HRTIMER_MODE_ABS;
 
 	} while (t->task && !signal_pending(current));
 
@@ -715,10 +715,10 @@ long __sched hrtimer_nanosleep_restart(s
 
 	restart->fn = do_no_restart_syscall;
 
-	hrtimer_init(&t.timer, restart->arg0, HRTIMER_ABS);
+	hrtimer_init(&t.timer, restart->arg0, HRTIMER_MODE_ABS);
 	t.timer.expires.tv64 = ((u64)restart->arg3 << 32) | (u64) restart->arg2;
 
-	if (do_nanosleep(&t, HRTIMER_ABS))
+	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
 		return 0;
 
 	rmtp = (struct timespec __user *) restart->arg1;
@@ -751,7 +751,7 @@ long hrtimer_nanosleep(struct timespec *
 		return 0;
 
 	/* Absolute timers do not update the rmtp value and restart: */
-	if (mode == HRTIMER_ABS)
+	if (mode == HRTIMER_MODE_ABS)
 		return -ERESTARTNOHAND;
 
 	if (rmtp) {
@@ -784,7 +784,7 @@ sys_nanosleep(struct timespec __user *rq
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
-	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_REL, CLOCK_MONOTONIC);
+	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
 /*
diff -puN kernel/itimer.c~hrtimers-namespace-and-enum-cleanup kernel/itimer.c
--- a/kernel/itimer.c~hrtimers-namespace-and-enum-cleanup
+++ a/kernel/itimer.c
@@ -128,7 +128,7 @@ asmlinkage long sys_getitimer(int which,
 /*
  * The timer is automagically restarted, when interval != 0
  */
-int it_real_fn(struct hrtimer *timer)
+enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 {
 	struct signal_struct *sig =
 	    container_of(timer, struct signal_struct, real_timer);
@@ -235,7 +235,7 @@ again:
 			timeval_to_ktime(value->it_interval);
 		expires = timeval_to_ktime(value->it_value);
 		if (expires.tv64 != 0)
-			hrtimer_start(timer, expires, HRTIMER_REL);
+			hrtimer_start(timer, expires, HRTIMER_MODE_REL);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
diff -puN kernel/posix-timers.c~hrtimers-namespace-and-enum-cleanup kernel/posix-timers.c
--- a/kernel/posix-timers.c~hrtimers-namespace-and-enum-cleanup
+++ a/kernel/posix-timers.c
@@ -145,7 +145,7 @@ static int common_timer_set(struct k_iti
 			    struct itimerspec *, struct itimerspec *);
 static int common_timer_del(struct k_itimer *timer);
 
-static int posix_timer_fn(struct hrtimer *data);
+static enum hrtimer_restart posix_timer_fn(struct hrtimer *data);
 
 static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags);
 
@@ -334,12 +334,12 @@ EXPORT_SYMBOL_GPL(posix_timer_event);
 
  * This code is for CLOCK_REALTIME* and CLOCK_MONOTONIC* timers.
  */
-static int posix_timer_fn(struct hrtimer *timer)
+static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 {
 	struct k_itimer *timr;
 	unsigned long flags;
 	int si_private = 0;
-	int ret = HRTIMER_NORESTART;
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
 	timr = container_of(timer, struct k_itimer, it.real.timer);
 	spin_lock_irqsave(&timr->it_lock, flags);
@@ -722,7 +722,7 @@ common_timer_set(struct k_itimer *timr, 
 	if (!new_setting->it_value.tv_sec && !new_setting->it_value.tv_nsec)
 		return 0;
 
-	mode = flags & TIMER_ABSTIME ? HRTIMER_ABS : HRTIMER_REL;
+	mode = flags & TIMER_ABSTIME ? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
 	hrtimer_init(&timr->it.real.timer, timr->it_clock, mode);
 	timr->it.real.timer.function = posix_timer_fn;
 
@@ -734,7 +734,7 @@ common_timer_set(struct k_itimer *timr, 
 	/* SIGEV_NONE timers are not queued ! See common_timer_get */
 	if (((timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
 		/* Setup correct expiry time for relative timers */
-		if (mode == HRTIMER_REL)
+		if (mode == HRTIMER_MODE_REL)
 			timer->expires = ktime_add(timer->expires,
 						   timer->base->get_time());
 		return 0;
@@ -950,7 +950,8 @@ static int common_nsleep(const clockid_t
 			 struct timespec *tsave, struct timespec __user *rmtp)
 {
 	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
-				 HRTIMER_ABS : HRTIMER_REL, which_clock);
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+				 which_clock);
 }
 
 asmlinkage long
diff -puN kernel/rtmutex.c~hrtimers-namespace-and-enum-cleanup kernel/rtmutex.c
--- a/kernel/rtmutex.c~hrtimers-namespace-and-enum-cleanup
+++ a/kernel/rtmutex.c
@@ -625,7 +625,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	/* Setup the timer, when timeout != NULL */
 	if (unlikely(timeout))
 		hrtimer_start(&timeout->timer, timeout->timer.expires,
-			      HRTIMER_ABS);
+			      HRTIMER_MODE_ABS);
 
 	for (;;) {
 		/* Try to acquire the lock: */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
