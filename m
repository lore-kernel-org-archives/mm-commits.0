From: akpm@linux-foundation.org
Subject: + clocksource-introduce-clocksource_forward_now.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:18:38 -0700
Message-ID: <200807220818.m6M8IcW3018186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYGVIT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource: introduce clocksource_forward_now()
has been added to the -mm tree.  Its filename is
     clocksource-introduce-clocksource_forward_now.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: introduce clocksource_forward_now()
From: Roman Zippel <zippel@linux-m68k.org>

To keep the raw monotonic patch simple first introduce
clocksource_forward_now(), which takes care of the offset since the last
update_wall_time() call and adds it to the clock, so there is no need
anymore to deal with it explicitly at various places, which need to make
significant changes to the clock.
This is also gets rid of the timekeeping_suspend_nsecs, instead of
waiting until resume, the value is accumulated during suspend. In the end
there is only a single user of __get_nsec_offset() left, so I integrated
it back to getnstimeofday().

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |   71 ++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 38 deletions(-)

diff -puN kernel/time/timekeeping.c~clocksource-introduce-clocksource_forward_now kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~clocksource-introduce-clocksource_forward_now
+++ a/kernel/time/timekeeping.c
@@ -58,27 +58,23 @@ struct clocksource *clock;
 
 #ifdef CONFIG_GENERIC_TIME
 /**
- * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
+ * clocksource_forward_now - update clock to the current time
  *
- * private function, must hold xtime_lock lock when being
- * called. Returns the number of nanoseconds since the
- * last call to update_wall_time() (adjusted by NTP scaling)
+ * Forward the current clock to update its state since the last call to
+ * update_wall_time(). This is useful before significant clock changes,
+ * as it avoids having to deal with this time offset explicitly.
  */
-static inline s64 __get_nsec_offset(void)
+static void clocksource_forward_now(void)
 {
 	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
+	s64 nsec;
 
-	/* read clocksource: */
 	cycle_now = clocksource_read(clock);
-
-	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	clock->cycle_last = cycle_now;
 
-	/* convert to nanoseconds: */
-	ns_offset = cyc2ns(clock, cycle_delta);
-
-	return ns_offset;
+	nsec = cyc2ns(clock, cycle_delta);
+	timespec_add_ns(&xtime, nsec);
 }
 
 /**
@@ -89,6 +85,7 @@ static inline s64 __get_nsec_offset(void
  */
 void getnstimeofday(struct timespec *ts)
 {
+	cycle_t cycle_now, cycle_delta;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -96,7 +93,15 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 
 		*ts = xtime;
-		nsecs = __get_nsec_offset();
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs = cyc2ns(clock, cycle_delta);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -129,22 +134,22 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
+	struct timespec ts_delta;
 	unsigned long flags;
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	nsec -= __get_nsec_offset();
+	clocksource_forward_now();
+
+	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, ts_delta);
 
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
+	xtime = *tv;
 
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
 	update_xtime_cache(0);
 
 	clock->error = 0;
@@ -170,22 +175,17 @@ EXPORT_SYMBOL(do_settimeofday);
 static void change_clocksource(void)
 {
 	struct clocksource *new;
-	cycle_t now;
-	u64 nsec;
 
 	new = clocksource_get_next();
 
 	if (clock == new)
 		return;
 
-	new->cycle_last = 0;
-	now = clocksource_read(new);
-	nsec =  __get_nsec_offset();
-	timespec_add_ns(&xtime, nsec);
+	clocksource_forward_now();
 
 	clock = new;
-	clock->cycle_last = now;
-
+	clock->cycle_last = 0;
+	clock->cycle_last = clocksource_read(new);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -200,8 +200,8 @@ static void change_clocksource(void)
 	 */
 }
 #else
+static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
-static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -265,8 +265,6 @@ void __init timekeeping_init(void)
 static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
-/* xtime offset when we went into suspend */
-static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -292,8 +290,6 @@ static int timekeeping_resume(struct sys
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
-	/* Make sure that we have the correct xtime reference */
-	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	clock->cycle_last = 0;
@@ -319,8 +315,7 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspend_time = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	/* Get the current xtime offset */
-	timekeeping_suspend_nsecs = __get_nsec_offset();
+	clocksource_forward_now();
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -461,10 +456,10 @@ void update_wall_time(void)
 	 */
 	while (offset >= clock->cycle_interval) {
 		/* accumulate one interval */
-		clock->xtime_nsec += clock->xtime_interval;
-		clock->cycle_last += clock->cycle_interval;
 		offset -= clock->cycle_interval;
+		clock->cycle_last += clock->cycle_interval;
 
+		clock->xtime_nsec += clock->xtime_interval;
 		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
 			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
hfs-convert-bitmap_lock-in-a-mutex.patch
hfs-convert-extents_lock-in-a-mutex.patch
hfsplus-convert-the-extents_lock-in-a-mutex.patch
affs-convert-s_bmlock-into-a-mutex.patch

