From: akpm@linux-foundation.org
Subject: - clocksource-introduce-clock_monotonic_raw-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2008 14:10:24 -0700
Message-ID: <200804032110.m33LAOqf022666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756246AbYDCVQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 17:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, use-math@users.sourceforge.net, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: introduce CLOCK_MONOTONIC_RAW fix
has been removed from the -mm tree.  Its filename was
     clocksource-introduce-clock_monotonic_raw-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: introduce CLOCK_MONOTONIC_RAW fix
From: john stultz <johnstul@us.ibm.com>

On Tue, 2008-03-18 at 19:43 -0700, Andrew Morton wrote:
> alpha:
> 
> kernel/built-in.o: In function `posix_get_monotonic_raw':
> : undefined reference to `getrawmonotonic'
> kernel/built-in.o: In function `posix_get_monotonic_raw':
> : undefined reference to `getrawmonotonic'
> 
> presumably busted for all CONFIG_GENERIC_TIME=n architectures.
> 
> Couldn't see a quick fix so I dropped it.

Ah, crud. Sorry about that.

Hrmm.. How about this quick fix, move getrawmonotonic outside "#ifdef
CONFIG_GENERIC_TIME" ?

Build tested on x86_64 and also alpha.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Josip Loncaric <use-math@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |   67 ++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff -puN kernel/time/timekeeping.c~clocksource-introduce-clock_monotonic_raw-fix kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~clocksource-introduce-clock_monotonic_raw-fix
+++ a/kernel/time/timekeeping.c
@@ -107,39 +107,6 @@ void getnstimeofday(struct timespec *ts)
 EXPORT_SYMBOL(getnstimeofday);
 
 /**
- * getrawmonotonic - Returns the raw monotonic time in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the raw monotonic time (completely un-modified by ntp)
- */
-void getrawmonotonic(struct timespec *ts)
-{
-	unsigned long seq;
-	s64 nsecs;
-	cycle_t cycle_now, cycle_delta;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-
-		*ts = monotonic_raw;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	timespec_add_ns(ts, nsecs);
-}
-
-EXPORT_SYMBOL(getrawmonotonic);
-
-/**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
@@ -239,6 +206,40 @@ static inline s64 __get_nsec_offset(void
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
+		*ts = monotonic_raw;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+
+EXPORT_SYMBOL(getrawmonotonic);
+
+
+/**
  * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
 int timekeeping_valid_for_hres(void)
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

proper-extern-for-late_time_init.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
clocksource-introduce-clock_monotonic_raw-fix.patch
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
clocksource-introduce-clocksource_forward_now.patch

