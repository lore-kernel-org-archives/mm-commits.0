From: akpm@linux-foundation.org
Subject: - clocksource-introduce-clock_monotonic_raw.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:46 -0700
Message-ID: <200808261845.m7QIjkoQ021430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757913AbYHZSyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: introduce CLOCK_MONOTONIC_RAW
has been removed from the -mm tree.  Its filename was
     clocksource-introduce-clock_monotonic_raw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: introduce CLOCK_MONOTONIC_RAW
From: John Stultz <johnstul@us.ibm.com>

In talking with Josip Loncaric, and his work on clock synchronization (see
btime.sf.net), he mentioned that for really close synchronization, it is
useful to have access to "hardware time", that is a notion of time that is
not in any way adjusted by the clock slewing done to keep close time sync.

Part of the issue is if we are using the kernel's ntp adjusted
representation of time in order to measure how we should correct time, we
can run into what Paul McKenney aptly described as "Painting a road using
the lines we're painting as the guide".

I had been thinking of a similar problem, and was trying to come up with a
way to give users access to a purely hardware based time representation
that avoided users having to know the underlying frequency and mask values
needed to deal with the wide variety of possible underlying hardware
counters.

My solution is to introduce CLOCK_MONOTONIC_RAW.  This exposes a
nanosecond based time value, that increments starting at bootup and has no
frequency adjustments made to it what so ever.

The time is accessed from userspace via the posix_clock_gettime() syscall,
passing CLOCK_MONOTONIC_RAW as the clock_id.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    3 ++
 include/linux/time.h        |    2 +
 kernel/posix-timers.c       |   15 +++++++++++
 kernel/time/timekeeping.c   |   44 ++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff -puN include/linux/clocksource.h~clocksource-introduce-clock_monotonic_raw include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-introduce-clock_monotonic_raw
+++ a/include/linux/clocksource.h
@@ -79,6 +79,7 @@ struct clocksource {
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_interval;
 	u64	xtime_interval;
+	u32	raw_interval;
 	/*
 	 * Second part is written at each timer interrupt
 	 * Keep it in a different cache line to dirty no
@@ -87,6 +88,7 @@ struct clocksource {
 	cycle_t cycle_last ____cacheline_aligned_in_smp;
 	u64 xtime_nsec;
 	s64 error;
+	struct timespec raw_time;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
@@ -215,6 +217,7 @@ static inline void clocksource_calculate
 
 	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
+	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) >> c->shift;
 }
 
 
diff -puN include/linux/time.h~clocksource-introduce-clock_monotonic_raw include/linux/time.h
--- a/include/linux/time.h~clocksource-introduce-clock_monotonic_raw
+++ a/include/linux/time.h
@@ -117,6 +117,7 @@ extern int do_setitimer(int which, struc
 extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
+extern void getrawmonotonic(struct timespec *ts);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 
@@ -214,6 +215,7 @@ struct itimerval {
 #define CLOCK_MONOTONIC			1
 #define CLOCK_PROCESS_CPUTIME_ID	2
 #define CLOCK_THREAD_CPUTIME_ID		3
+#define CLOCK_MONOTONIC_RAW		4
 
 /*
  * The IDs of various hardware clocks:
diff -puN kernel/posix-timers.c~clocksource-introduce-clock_monotonic_raw kernel/posix-timers.c
--- a/kernel/posix-timers.c~clocksource-introduce-clock_monotonic_raw
+++ a/kernel/posix-timers.c
@@ -223,6 +223,15 @@ static int posix_ktime_get_ts(clockid_t 
 }
 
 /*
+ * Get monotonic time for posix timers
+ */
+static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
+{
+	getrawmonotonic(tp);
+	return 0;
+}
+
+/*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
 static __init int init_posix_timers(void)
@@ -235,9 +244,15 @@ static __init int init_posix_timers(void
 		.clock_get = posix_ktime_get_ts,
 		.clock_set = do_posix_clock_nosettime,
 	};
+	struct k_clock clock_monotonic_raw = {
+		.clock_getres = hrtimer_get_res,
+		.clock_get = posix_get_monotonic_raw,
+		.clock_set = do_posix_clock_nosettime,
+	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
+	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff -puN kernel/time/timekeeping.c~clocksource-introduce-clock_monotonic_raw kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~clocksource-introduce-clock_monotonic_raw
+++ a/kernel/time/timekeeping.c
@@ -75,6 +75,9 @@ static void clocksource_forward_now(void
 
 	nsec = cyc2ns(clock, cycle_delta);
 	timespec_add_ns(&xtime, nsec);
+
+	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
+	clock->raw_time.tv_nsec += nsec;
 }
 
 /**
@@ -183,6 +186,8 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
+	new->raw_time = clock->raw_time;
+
 	clock = new;
 	clock->cycle_last = 0;
 	clock->cycle_last = clocksource_read(new);
@@ -205,6 +210,39 @@ static inline void change_clocksource(vo
 #endif
 
 /**
+ * getrawmonotonic - Returns the raw monotonic time in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the raw monotonic time (completely un-modified by ntp)
+ */
+void getrawmonotonic(struct timespec *ts)
+{
+	unsigned long seq;
+	s64 nsecs;
+	cycle_t cycle_now, cycle_delta;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
+
+		*ts = clock->raw_time;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+EXPORT_SYMBOL(getrawmonotonic);
+
+
+/**
  * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
 int timekeeping_valid_for_hres(void)
@@ -466,6 +504,12 @@ void update_wall_time(void)
 			second_overflow();
 		}
 
+		clock->raw_time.tv_nsec += clock->raw_interval;
+		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
+			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
+			clock->raw_time.tv_sec++;
+		}
+
 		/* accumulate error between NTP and clock interval */
 		clock->error += tick_length;
 		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-improve-adjtimex-frequency-rounding.patch

