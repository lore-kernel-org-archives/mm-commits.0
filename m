From: akpm@linux-foundation.org
Subject: + time-remove-xtime_cache-take-2.patch added to -mm tree
Date: Mon, 12 Apr 2010 21:01:57 -0400
Message-ID: <201004130403.o3D43Zlf011661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728Ab0DMEDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 00:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, P.Titera@century.cz, tglx@linutronix.de


The patch titled
     time: remove xtime_cache
has been added to the -mm tree.  Its filename is
     time-remove-xtime_cache-take-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: remove xtime_cache
From: John Stultz <johnstul@us.ibm.com>

With the earlier logarithmic time accumulation patch, xtime will now
always be within one "tick" of the current time, instead of possibly half
a second off.

This removes the need for the xtime_cache value, which always stored the
time at the last interrupt, so this patch cleans that up removing the
xtime_cache related code.

This patch also addresses an issue with an earlier version of this change,
where xtime_cache was normalizing xtime, which could in some cases be not
valid (ie: tv_nsec == NSEC_PER_SEC).  This is fixed by handling the edge
case in update_wall_time().

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Petr Titera <P.Titera@century.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |    1 -
 kernel/time/timekeeping.c |   35 ++++++++++++++++-------------------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff -puN include/linux/time.h~time-remove-xtime_cache-take-2 include/linux/time.h
--- a/include/linux/time.h~time-remove-xtime_cache-take-2
+++ a/include/linux/time.h
@@ -150,7 +150,6 @@ extern struct timespec timespec_trunc(st
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
-extern void update_xtime_cache(u64 nsec);
 extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
diff -puN kernel/time/timekeeping.c~time-remove-xtime_cache-take-2 kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-remove-xtime_cache-take-2
+++ a/kernel/time/timekeeping.c
@@ -165,13 +165,6 @@ struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
-void update_xtime_cache(u64 nsec)
-{
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
-}
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
@@ -332,8 +325,6 @@ int do_settimeofday(struct timespec *tv)
 
 	xtime = *tv;
 
-	update_xtime_cache(0);
-
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
@@ -559,7 +550,6 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -593,7 +583,6 @@ static int timekeeping_resume(struct sys
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
 		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
 	}
-	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
@@ -788,7 +777,6 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	u64 nsecs;
 	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
@@ -847,7 +835,9 @@ void update_wall_time(void)
 		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
 	}
 
-	/* store full nanoseconds into xtime after rounding it up and
+
+	/*
+	 * Store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
 	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
@@ -855,8 +845,15 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
-	update_xtime_cache(nsecs);
+	/*
+	 * Finally, make sure that after the rounding
+	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
+	 */
+	if (unlikely(xtime.tv_nsec >= NSEC_PER_SEC)) {
+		xtime.tv_nsec -= NSEC_PER_SEC;
+		xtime.tv_sec++;
+		second_overflow();
+	}
 
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
@@ -896,13 +893,13 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased
 
 unsigned long get_seconds(void)
 {
-	return xtime_cache.tv_sec;
+	return xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return xtime_cache;
+	return xtime;
 }
 
 struct timespec current_kernel_time(void)
@@ -913,7 +910,7 @@ struct timespec current_kernel_time(void
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	return now;
@@ -928,7 +925,7 @@ struct timespec get_monotonic_coarse(voi
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 		mono = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
time-clean-up-warp_clock.patch
time-clean-up-direct-xtime-usage-in-xen.patch
ntp-make-time_adjust-static.patch
ntp-remove-tickadj.patch
time-remove-xtime_cache-take-2.patch
xtensa-fix-unnecessary-setting-of-xtime.patch
hangcheck-timer-fix-x86_32-bugs.patch
time-kill-off-config_generic_time.patch

