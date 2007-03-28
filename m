From: akpm@linux-foundation.org
Subject: + move-timekeeping-code-to-timekeepingc.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:17:38 -0700
Message-ID: <200703282317.l2SNHceL022473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35538 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbXC1X1i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Move timekeeping code to timekeeping.c
has been added to the -mm tree.  Its filename is
     move-timekeeping-code-to-timekeepingc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move timekeeping code to timekeeping.c
From: john stultz <johnstul@us.ibm.com>

Move the timekeeping code out of kernel/timer.c and into
kernel/time/timekeeping.c.  I made no cleanups or other changes in transit.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |    1 
 kernel/time/Makefile      |    2 
 kernel/time/timekeeping.c |  475 ++++++++++++++++++++++++++++++++++++
 kernel/timer.c            |  459 ----------------------------------
 4 files changed, 478 insertions(+), 459 deletions(-)

diff -puN include/linux/time.h~move-timekeeping-code-to-timekeepingc include/linux/time.h
--- a/include/linux/time.h~move-timekeeping-code-to-timekeepingc
+++ a/include/linux/time.h
@@ -119,6 +119,7 @@ extern void getnstimeofday(struct timesp
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_is_continuous(void);
+extern void update_wall_time(void);
 
 /**
  * timespec_to_ns - Convert timespec to nanoseconds
diff -puN kernel/time/Makefile~move-timekeeping-code-to-timekeepingc kernel/time/Makefile
--- a/kernel/time/Makefile~move-timekeeping-code-to-timekeepingc
+++ a/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += ntp.o clocksource.o jiffies.o timer_list.o
+obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff -puN /dev/null kernel/time/timekeeping.c
--- /dev/null
+++ a/kernel/time/timekeeping.c
@@ -0,0 +1,475 @@
+/*
+ *  linux/kernel/time/timekeeping.c
+ *
+ *  Kernel timekeeping code and accessor functions
+ *
+ *  This code was moved from linux/kernel/timer.c.
+ *  Please see that file for copyright and history logs.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/clocksource.h>
+#include <linux/jiffies.h>
+#include <linux/time.h>
+#include <linux/tick.h>
+
+
+/*
+ * This read-write spinlock protects us from races in SMP while
+ * playing with xtime and avenrun.
+ */
+__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+
+EXPORT_SYMBOL(xtime_lock);
+
+
+/*
+ * The current time
+ * wall_to_monotonic is what we need to add to xtime (or xtime corrected
+ * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
+ * at zero at system boot time, so wall_to_monotonic will be negative,
+ * however, we will ALWAYS keep the tv_nsec part positive so we can use
+ * the usual normalization.
+ */
+struct timespec xtime __attribute__ ((aligned (16)));
+struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+
+EXPORT_SYMBOL(xtime);
+
+
+static struct clocksource *clock; /* pointer to current clocksource */
+
+
+#ifdef CONFIG_GENERIC_TIME
+/**
+ * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
+ *
+ * private function, must hold xtime_lock lock when being
+ * called. Returns the number of nanoseconds since the
+ * last call to update_wall_time() (adjusted by NTP scaling)
+ */
+static inline s64 __get_nsec_offset(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	s64 ns_offset;
+
+	/* read clocksource: */
+	cycle_now = clocksource_read(clock);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+	/* convert to nanoseconds: */
+	ns_offset = cyc2ns(clock, cycle_delta);
+
+	return ns_offset;
+}
+
+/**
+ * __get_realtime_clock_ts - Returns the time of day in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec. Used by
+ * do_gettimeofday() and get_realtime_clock_ts().
+ */
+static inline void __get_realtime_clock_ts(struct timespec *ts)
+{
+	unsigned long seq;
+	s64 nsecs;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		*ts = xtime;
+		nsecs = __get_nsec_offset();
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+
+/**
+ * getnstimeofday - Returns the time of day in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ */
+void getnstimeofday(struct timespec *ts)
+{
+	__get_realtime_clock_ts(ts);
+}
+
+EXPORT_SYMBOL(getnstimeofday);
+
+/**
+ * do_gettimeofday - Returns the time of day in a timeval
+ * @tv:		pointer to the timeval to be set
+ *
+ * NOTE: Users should be converted to using get_realtime_clock_ts()
+ */
+void do_gettimeofday(struct timeval *tv)
+{
+	struct timespec now;
+
+	__get_realtime_clock_ts(&now);
+	tv->tv_sec = now.tv_sec;
+	tv->tv_usec = now.tv_nsec/1000;
+}
+
+EXPORT_SYMBOL(do_gettimeofday);
+/**
+ * do_settimeofday - Sets the time of day
+ * @tv:		pointer to the timespec variable containing the new time
+ *
+ * Sets the time of day to the new time and update NTP and notify hrtimers
+ */
+int do_settimeofday(struct timespec *tv)
+{
+	unsigned long flags;
+	time_t wtm_sec, sec = tv->tv_sec;
+	long wtm_nsec, nsec = tv->tv_nsec;
+
+	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	nsec -= __get_nsec_offset();
+
+	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
+	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
+
+	set_normalized_timespec(&xtime, sec, nsec);
+	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+
+	clock->error = 0;
+	ntp_clear();
+
+	update_vsyscall(&xtime, clock);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+
+EXPORT_SYMBOL(do_settimeofday);
+
+/**
+ * change_clocksource - Swaps clocksources if a new one is available
+ *
+ * Accumulates current time interval and initializes new clocksource
+ */
+static void change_clocksource(void)
+{
+	struct clocksource *new;
+	cycle_t now;
+	u64 nsec;
+
+	new = clocksource_get_next();
+
+	if (clock == new)
+		return;
+
+	now = clocksource_read(new);
+	nsec =  __get_nsec_offset();
+	timespec_add_ns(&xtime, nsec);
+
+	clock = new;
+	clock->cycle_last = now;
+
+	clock->error = 0;
+	clock->xtime_nsec = 0;
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+
+	tick_clock_notify();
+
+	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
+	       clock->name);
+}
+#else
+static inline void change_clocksource(void) { }
+#endif
+
+/**
+ * timekeeping_is_continuous - check to see if timekeeping is free running
+ */
+int timekeeping_is_continuous(void)
+{
+	unsigned long seq;
+	int ret;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	return ret;
+}
+
+/**
+ * read_persistent_clock -  Return time in seconds from the persistent clock.
+ *
+ * Weak dummy function for arches that do not yet support it.
+ * Returns seconds from epoch using the battery backed persistent clock.
+ * Returns zero if unsupported.
+ *
+ *  XXX - Do be sure to remove it once all arches implement it.
+ */
+unsigned long __attribute__((weak)) read_persistent_clock(void)
+{
+	return 0;
+}
+
+/*
+ * timekeeping_init - Initializes the clocksource and common timekeeping values
+ */
+void __init timekeeping_init(void)
+{
+	unsigned long flags;
+	unsigned long sec = read_persistent_clock();
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	ntp_clear();
+
+	clock = clocksource_get_next();
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	clock->cycle_last = clocksource_read(clock);
+
+	xtime.tv_sec = sec;
+	xtime.tv_nsec = 0;
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+}
+
+/* flag for if timekeeping is suspended */
+static int timekeeping_suspended;
+/* time in seconds when suspend began */
+static unsigned long timekeeping_suspend_time;
+
+/**
+ * timekeeping_resume - Resumes the generic timekeeping subsystem.
+ * @dev:	unused
+ *
+ * This is for the generic clocksource timekeeping.
+ * xtime/wall_to_monotonic/jiffies/etc are
+ * still managed by arch specific suspend/resume code.
+ */
+static int timekeeping_resume(struct sys_device *dev)
+{
+	unsigned long flags;
+	unsigned long now = read_persistent_clock();
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	if (now && (now > timekeeping_suspend_time)) {
+		unsigned long sleep_length = now - timekeeping_suspend_time;
+
+		xtime.tv_sec += sleep_length;
+		wall_to_monotonic.tv_sec -= sleep_length;
+	}
+	/* re-base the last cycle value */
+	clock->cycle_last = clocksource_read(clock);
+	clock->error = 0;
+	timekeeping_suspended = 0;
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	touch_softlockup_watchdog();
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+
+	/* Resume hrtimers */
+	clock_was_set();
+
+	return 0;
+}
+
+static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	timekeeping_suspended = 1;
+	timekeeping_suspend_time = read_persistent_clock();
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
+	return 0;
+}
+
+/* sysfs resume/suspend bits for timekeeping */
+static struct sysdev_class timekeeping_sysclass = {
+	.resume		= timekeeping_resume,
+	.suspend	= timekeeping_suspend,
+	set_kset_name("timekeeping"),
+};
+
+static struct sys_device device_timer = {
+	.id		= 0,
+	.cls		= &timekeeping_sysclass,
+};
+
+static int __init timekeeping_init_device(void)
+{
+	int error = sysdev_class_register(&timekeeping_sysclass);
+	if (!error)
+		error = sysdev_register(&device_timer);
+	return error;
+}
+
+device_initcall(timekeeping_init_device);
+
+/*
+ * If the error is already larger, we look ahead even further
+ * to compensate for late or lost adjustments.
+ */
+static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+						 s64 *offset)
+{
+	s64 tick_error, i;
+	u32 look_ahead, adj;
+	s32 error2, mult;
+
+	/*
+	 * Use the current error value to determine how much to look ahead.
+	 * The larger the error the slower we adjust for it to avoid problems
+	 * with losing too many ticks, otherwise we would overadjust and
+	 * produce an even larger error.  The smaller the adjustment the
+	 * faster we try to adjust for it, as lost ticks can do less harm
+	 * here.  This is tuned so that an error of about 1 msec is adusted
+	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
+	 */
+	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = abs(error2);
+	for (look_ahead = 0; error2 > 0; look_ahead++)
+		error2 >>= 2;
+
+	/*
+	 * Now calculate the error in (1 << look_ahead) ticks, but first
+	 * remove the single look ahead already included in the error.
+	 */
+	tick_error = current_tick_length() >>
+		(TICK_LENGTH_SHIFT - clock->shift + 1);
+	tick_error -= clock->xtime_interval >> 1;
+	error = ((error - tick_error) >> look_ahead) + tick_error;
+
+	/* Finally calculate the adjustment shift value.  */
+	i = *interval;
+	mult = 1;
+	if (error < 0) {
+		error = -error;
+		*interval = -*interval;
+		*offset = -*offset;
+		mult = -1;
+	}
+	for (adj = 0; error > i; adj++)
+		error >>= 1;
+
+	*interval <<= adj;
+	*offset <<= adj;
+	return mult << adj;
+}
+
+/*
+ * Adjust the multiplier to reduce the error value,
+ * this is optimized for the most common adjustments of -1,0,1,
+ * for other values we can do a bit more work.
+ */
+static void clocksource_adjust(struct clocksource *clock, s64 offset)
+{
+	s64 error, interval = clock->cycle_interval;
+	int adj;
+
+	error = clock->error >> (TICK_LENGTH_SHIFT - clock->shift - 1);
+	if (error > interval) {
+		error >>= 2;
+		if (likely(error <= interval))
+			adj = 1;
+		else
+			adj = clocksource_bigadjust(error, &interval, &offset);
+	} else if (error < -interval) {
+		error >>= 2;
+		if (likely(error >= -interval)) {
+			adj = -1;
+			interval = -interval;
+			offset = -offset;
+		} else
+			adj = clocksource_bigadjust(error, &interval, &offset);
+	} else
+		return;
+
+	clock->mult += adj;
+	clock->xtime_interval += interval;
+	clock->xtime_nsec -= offset;
+	clock->error -= (interval - offset) <<
+			(TICK_LENGTH_SHIFT - clock->shift);
+}
+
+/**
+ * update_wall_time - Uses the current clocksource to increment the wall time
+ *
+ * Called from the timer interrupt, must hold a write on xtime_lock.
+ */
+void update_wall_time(void)
+{
+	cycle_t offset;
+
+	/* Make sure we're fully resumed: */
+	if (unlikely(timekeeping_suspended))
+		return;
+
+#ifdef CONFIG_GENERIC_TIME
+	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+#else
+	offset = clock->cycle_interval;
+#endif
+	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
+
+	/* normally this loop will run just once, however in the
+	 * case of lost or late ticks, it will accumulate correctly.
+	 */
+	while (offset >= clock->cycle_interval) {
+		/* accumulate one interval */
+		clock->xtime_nsec += clock->xtime_interval;
+		clock->cycle_last += clock->cycle_interval;
+		offset -= clock->cycle_interval;
+
+		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
+			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+			xtime.tv_sec++;
+			second_overflow();
+		}
+
+		/* interpolator bits */
+		time_interpolator_update(clock->xtime_interval
+						>> clock->shift);
+
+		/* accumulate error between NTP and clock interval */
+		clock->error += current_tick_length();
+		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
+	}
+
+	/* correct the clock when NTP error is too big */
+	clocksource_adjust(clock, offset);
+
+	/* store full nanoseconds into xtime */
+	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
+	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
+
+	/* check to see if there is a new clocksource to use */
+	change_clocksource();
+	update_vsyscall(&xtime, clock);
+}
diff -puN kernel/timer.c~move-timekeeping-code-to-timekeepingc kernel/timer.c
--- a/kernel/timer.c~move-timekeeping-code-to-timekeepingc
+++ a/kernel/timer.c
@@ -1,7 +1,7 @@
 /*
  *  linux/kernel/timer.c
  *
- *  Kernel internal timers, kernel timekeeping, basic process system calls
+ *  Kernel internal timers, basic process system calls
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
@@ -804,455 +804,6 @@ unsigned long next_timer_interrupt(void)
 
 #endif
 
-/******************************************************************/
-
-/* 
- * The current time 
- * wall_to_monotonic is what we need to add to xtime (or xtime corrected 
- * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
- * at zero at system boot time, so wall_to_monotonic will be negative,
- * however, we will ALWAYS keep the tv_nsec part positive so we can use
- * the usual normalization.
- */
-struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-
-EXPORT_SYMBOL(xtime);
-
-
-/* XXX - all of this timekeeping code should be later moved to time.c */
-#include <linux/clocksource.h>
-static struct clocksource *clock; /* pointer to current clocksource */
-
-#ifdef CONFIG_GENERIC_TIME
-/**
- * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
- *
- * private function, must hold xtime_lock lock when being
- * called. Returns the number of nanoseconds since the
- * last call to update_wall_time() (adjusted by NTP scaling)
- */
-static inline s64 __get_nsec_offset(void)
-{
-	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
-
-	/* read clocksource: */
-	cycle_now = clocksource_read(clock);
-
-	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-	/* convert to nanoseconds: */
-	ns_offset = cyc2ns(clock, cycle_delta);
-
-	return ns_offset;
-}
-
-/**
- * __get_realtime_clock_ts - Returns the time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec. Used by
- * do_gettimeofday() and get_realtime_clock_ts().
- */
-static inline void __get_realtime_clock_ts(struct timespec *ts)
-{
-	unsigned long seq;
-	s64 nsecs;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		*ts = xtime;
-		nsecs = __get_nsec_offset();
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	timespec_add_ns(ts, nsecs);
-}
-
-/**
- * getnstimeofday - Returns the time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
- */
-void getnstimeofday(struct timespec *ts)
-{
-	__get_realtime_clock_ts(ts);
-}
-
-EXPORT_SYMBOL(getnstimeofday);
-
-/**
- * do_gettimeofday - Returns the time of day in a timeval
- * @tv:		pointer to the timeval to be set
- *
- * NOTE: Users should be converted to using get_realtime_clock_ts()
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	struct timespec now;
-
-	__get_realtime_clock_ts(&now);
-	tv->tv_sec = now.tv_sec;
-	tv->tv_usec = now.tv_nsec/1000;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-/**
- * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
- *
- * Sets the time of day to the new time and update NTP and notify hrtimers
- */
-int do_settimeofday(struct timespec *tv)
-{
-	unsigned long flags;
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	nsec -= __get_nsec_offset();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	clock->error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, clock);
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	/* signal hrtimers about time change */
-	clock_was_set();
-
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-/**
- * change_clocksource - Swaps clocksources if a new one is available
- *
- * Accumulates current time interval and initializes new clocksource
- */
-static void change_clocksource(void)
-{
-	struct clocksource *new;
-	cycle_t now;
-	u64 nsec;
-
-	new = clocksource_get_next();
-
-	if (clock == new)
-		return;
-
-	now = clocksource_read(new);
-	nsec =  __get_nsec_offset();
-	timespec_add_ns(&xtime, nsec);
-
-	clock = new;
-	clock->cycle_last = now;
-
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-
-	tick_clock_notify();
-
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
-}
-#else
-static inline void change_clocksource(void) { }
-#endif
-
-/**
- * timekeeping_is_continuous - check to see if timekeeping is free running
- */
-int timekeeping_is_continuous(void)
-{
-	unsigned long seq;
-	int ret;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	return ret;
-}
-
-/**
- * read_persistent_clock -  Return time in seconds from the persistent clock.
- *
- * Weak dummy function for arches that do not yet support it.
- * Returns seconds from epoch using the battery backed persistent clock.
- * Returns zero if unsupported.
- *
- *  XXX - Do be sure to remove it once all arches implement it.
- */
-unsigned long __attribute__((weak)) read_persistent_clock(void)
-{
-	return 0;
-}
-
-/*
- * timekeeping_init - Initializes the clocksource and common timekeeping values
- */
-void __init timekeeping_init(void)
-{
-	unsigned long flags;
-	unsigned long sec = read_persistent_clock();
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	ntp_clear();
-
-	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
-
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-}
-
-/* flag for if timekeeping is suspended */
-static int timekeeping_suspended;
-/* time in seconds when suspend began */
-static unsigned long timekeeping_suspend_time;
-
-/**
- * timekeeping_resume - Resumes the generic timekeeping subsystem.
- * @dev:	unused
- *
- * This is for the generic clocksource timekeeping.
- * xtime/wall_to_monotonic/jiffies/etc are
- * still managed by arch specific suspend/resume code.
- */
-static int timekeeping_resume(struct sys_device *dev)
-{
-	unsigned long flags;
-	unsigned long now = read_persistent_clock();
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	if (now && (now > timekeeping_suspend_time)) {
-		unsigned long sleep_length = now - timekeeping_suspend_time;
-
-		xtime.tv_sec += sleep_length;
-		wall_to_monotonic.tv_sec -= sleep_length;
-	}
-	/* re-base the last cycle value */
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
-	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	touch_softlockup_watchdog();
-
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
-
-	/* Resume hrtimers */
-	clock_was_set();
-
-	return 0;
-}
-
-static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
-{
-	unsigned long flags;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-	timekeeping_suspended = 1;
-	timekeeping_suspend_time = read_persistent_clock();
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
-
-	return 0;
-}
-
-/* sysfs resume/suspend bits for timekeeping */
-static struct sysdev_class timekeeping_sysclass = {
-	.resume		= timekeeping_resume,
-	.suspend	= timekeeping_suspend,
-	set_kset_name("timekeeping"),
-};
-
-static struct sys_device device_timer = {
-	.id		= 0,
-	.cls		= &timekeeping_sysclass,
-};
-
-static int __init timekeeping_init_device(void)
-{
-	int error = sysdev_class_register(&timekeeping_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
-}
-
-device_initcall(timekeeping_init_device);
-
-/*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
- */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
-						 s64 *offset)
-{
-	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
-
-	/*
-	 * Use the current error value to determine how much to look ahead.
-	 * The larger the error the slower we adjust for it to avoid problems
-	 * with losing too many ticks, otherwise we would overadjust and
-	 * produce an even larger error.  The smaller the adjustment the
-	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adusted
-	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
-	 */
-	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
-	error2 = abs(error2);
-	for (look_ahead = 0; error2 > 0; look_ahead++)
-		error2 >>= 2;
-
-	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
-	 */
-	tick_error = current_tick_length() >>
-		(TICK_LENGTH_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
-	error = ((error - tick_error) >> look_ahead) + tick_error;
-
-	/* Finally calculate the adjustment shift value.  */
-	i = *interval;
-	mult = 1;
-	if (error < 0) {
-		error = -error;
-		*interval = -*interval;
-		*offset = -*offset;
-		mult = -1;
-	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
-
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
-
-/*
- * Adjust the multiplier to reduce the error value,
- * this is optimized for the most common adjustments of -1,0,1,
- * for other values we can do a bit more work.
- */
-static void clocksource_adjust(struct clocksource *clock, s64 offset)
-{
-	s64 error, interval = clock->cycle_interval;
-	int adj;
-
-	error = clock->error >> (TICK_LENGTH_SHIFT - clock->shift - 1);
-	if (error > interval) {
-		error >>= 2;
-		if (likely(error <= interval))
-			adj = 1;
-		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
-	} else if (error < -interval) {
-		error >>= 2;
-		if (likely(error >= -interval)) {
-			adj = -1;
-			interval = -interval;
-			offset = -offset;
-		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
-	} else
-		return;
-
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(TICK_LENGTH_SHIFT - clock->shift);
-}
-
-/**
- * update_wall_time - Uses the current clocksource to increment the wall time
- *
- * Called from the timer interrupt, must hold a write on xtime_lock.
- */
-static void update_wall_time(void)
-{
-	cycle_t offset;
-
-	/* Make sure we're fully resumed: */
-	if (unlikely(timekeeping_suspended))
-		return;
-
-#ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
-#else
-	offset = clock->cycle_interval;
-#endif
-	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
-
-	/* normally this loop will run just once, however in the
-	 * case of lost or late ticks, it will accumulate correctly.
-	 */
-	while (offset >= clock->cycle_interval) {
-		/* accumulate one interval */
-		clock->xtime_nsec += clock->xtime_interval;
-		clock->cycle_last += clock->cycle_interval;
-		offset -= clock->cycle_interval;
-
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
-			xtime.tv_sec++;
-			second_overflow();
-		}
-
-		/* interpolator bits */
-		time_interpolator_update(clock->xtime_interval
-						>> clock->shift);
-
-		/* accumulate error between NTP and clock interval */
-		clock->error += current_tick_length();
-		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
-	}
-
-	/* correct the clock when NTP error is too big */
-	clocksource_adjust(clock, offset);
-
-	/* store full nanoseconds into xtime */
-	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
-	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-
-	/* check to see if there is a new clocksource to use */
-	change_clocksource();
-	update_vsyscall(&xtime, clock);
-}
-
 /*
  * Called from the timer interrupt handler to charge one tick to the current 
  * process.  user_tick is 1 if the tick is user time, 0 for system.
@@ -1316,14 +867,6 @@ static inline void calc_load(unsigned lo
 }
 
 /*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime and avenrun.
- */
-__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
-EXPORT_SYMBOL(xtime_lock);
-
-/*
  * This function runs timers and the timer-tq in bottom half context.
  */
 static void run_timer_softirq(struct softirq_action *h)
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
i386-fix-bogus-return-value-in-hpet_next_event.patch
log-reason-why-tsc-was-marked-unstable.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
declare-struct-ktime.patch
