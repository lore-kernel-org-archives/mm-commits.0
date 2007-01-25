From: akpm@osdl.org
Subject: + hrtimers-namespace-and-enum-cleanup.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:25 -0800
Message-ID: <200701250636.l0P6aP5d008334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965568AbXAYGhh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:37:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     hrtimers: namespace and enum cleanup
has been added to the -mm tree.  Its filename is
     hrtimers-namespace-and-enum-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hrtimers: namespace and enum cleanup
From: Thomas Gleixner <tglx@linutronix.de>

- hrtimers did not use the hrtimer_restart enum and relied on the implict
  int representation. Fix the prototypes and the functions using the enums.
- Use seperate name spaces for the enumerations
- Convert hrtimer_restart macro to inline function
- Add comments

No functional changes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |   20 ++++++++++++--------
 include/linux/timer.h   |    2 +-
 kernel/fork.c           |    2 +-
 kernel/futex.c          |    2 +-
 kernel/hrtimer.c        |   18 +++++++++---------
 kernel/itimer.c         |    4 ++--
 kernel/posix-timers.c   |   13 +++++++------
 kernel/rtmutex.c        |    2 +-
 8 files changed, 34 insertions(+), 29 deletions(-)

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
