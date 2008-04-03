From: akpm@linux-foundation.org
Subject: - clocksource-introduce-clocksource_forward_now.patch removed from -mm tree
Date: Thu, 03 Apr 2008 14:10:29 -0700
Message-ID: <200804032110.m33LATOg022672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297AbYDCVLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 17:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: introduce clocksource_forward_now
has been removed from the -mm tree.  Its filename was
     clocksource-introduce-clocksource_forward_now.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: introduce clocksource_forward_now
From: Roman Zippel <zippel@linux-m68k.org>

There is a problem with the time offset since the last update_wall_time()
call, which isn't taken into account when switching clocks (possibly during
suspend/resume too), so that the clock might jump back during a clock switch.

To avoid making the whole more complex it's better to do small cleanup first,
so this patch introduces clocksource_forward_now() which takes care of this
offset since the last update_wall_time() call and adds it to the clock, so
there is no need anymore to deal with it explicitly.  This is also gets rid of
the timekeeping_suspend_nsecs hack, instead of waiting until resume, the value
is accumulated during suspend.  In the end there is only a single user of
__get_nsec_offset() left, so I integrated it back to getnstimeofday().

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |   66 ++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff -puN kernel/time/timekeeping.c~clocksource-introduce-clocksource_forward_now kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~clocksource-introduce-clocksource_forward_now
+++ a/kernel/time/timekeeping.c
@@ -59,27 +59,23 @@ struct clocksource *clock;
 
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
@@ -90,6 +86,7 @@ static inline s64 __get_nsec_offset(void
  */
 void getnstimeofday(struct timespec *ts)
 {
+	cycle_t cycle_now, cycle_delta;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -97,7 +94,15 @@ void getnstimeofday(struct timespec *ts)
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
 
@@ -131,21 +136,19 @@ EXPORT_SYMBOL(do_gettimeofday);
 int do_settimeofday(struct timespec *tv)
 {
 	unsigned long flags;
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	nsec -= __get_nsec_offset();
+	clocksource_forward_now();
 
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
+	wall_to_monotonic.tv_sec += xtime.tv_sec - tv->tv_sec;
+	timespec_add_ns(&wall_to_monotonic, xtime.tv_nsec - tv->tv_nsec);
+
+	xtime = *tv;
 
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
 	update_xtime_cache(0);
 
 	clock->error = 0;
@@ -171,21 +174,16 @@ EXPORT_SYMBOL(do_settimeofday);
 static void change_clocksource(void)
 {
 	struct clocksource *new;
-	cycle_t now;
-	u64 nsec;
 
 	new = clocksource_get_next();
 
 	if (clock == new)
 		return;
 
-	now = clocksource_read(new);
-	nsec =  __get_nsec_offset();
-	timespec_add_ns(&xtime, nsec);
+	clocksource_forward_now();
 
 	clock = new;
-	clock->cycle_last = now;
-
+	clock->cycle_last = clocksource_read(new);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clock->raw_snsec = 0;
@@ -201,8 +199,8 @@ static void change_clocksource(void)
 	 */
 }
 #else
+static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
-static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -301,8 +299,6 @@ void __init timekeeping_init(void)
 static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
-/* xtime offset when we went into suspend */
-static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -328,8 +324,6 @@ static int timekeeping_resume(struct sys
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
-	/* Make sure that we have the correct xtime reference */
-	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
@@ -354,8 +348,7 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspend_time = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	/* Get the current xtime offset */
-	timekeeping_suspend_nsecs = __get_nsec_offset();
+	clocksource_forward_now();
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -497,9 +490,10 @@ void update_wall_time(void)
 	 */
 	while (offset >= clock->cycle_interval) {
 		/* accumulate one interval */
-		clock->xtime_nsec += clock->xtime_interval;
 		clock->raw_snsec += clock->raw_interval;
 		clock->cycle_last += clock->cycle_interval;
+		clock->xtime_nsec += clock->xtime_interval;
+
 		offset -= clock->cycle_interval;
 
 		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

git-x86.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
git-watchdog.patch
m68k-replace-remaining-__function__-occurences.patch
fs-hfsplus-proper-externs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
fs-affs-filec-use-bug_on.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-mm.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
clocksource-introduce-clocksource_forward_now.patch

