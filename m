From: akpm@linux-foundation.org
Subject: - introduce-boot-based-time.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:00 -0700
Message-ID: <200707162053.l6GKr05o001585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761496AbXGPVhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tjanouse@redhat.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, tsmetana@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Introduce boot based time
has been removed from the -mm tree.  Its filename was
     introduce-boot-based-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Introduce boot based time
From: Tomas Janousek <tjanouse@redhat.com>

The commits

  411187fb05cd11676b0979d9fbf3291db69dbce2 (GTOD: persistent clock support)
  c1d370e167d66b10bca3b602d3740405469383de (i386: use GTOD persistent clock
    support)

changed the monotonic time so that it no longer jumps after resume, but it's
not possible to use it for boot time and process start time calculations then.
 Also, the uptime no longer increases during suspend.

I add a variable to track the wall_to_monotonic changes, a function to get the
real boot time and a function to get the boot based time from the monotonic
one.

[akpm@linux-foundation.org: remove exports, add comment]
Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |    2 +
 kernel/time/timekeeping.c |   37 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff -puN include/linux/time.h~introduce-boot-based-time include/linux/time.h
--- a/include/linux/time.h~introduce-boot-based-time
+++ a/include/linux/time.h
@@ -116,6 +116,8 @@ extern int do_setitimer(int which, struc
 extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
+extern void getboottime(struct timespec *ts);
+extern void monotonic_to_bootbased(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_is_continuous(void);
diff -puN kernel/time/timekeeping.c~introduce-boot-based-time kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~introduce-boot-based-time
+++ a/kernel/time/timekeeping.c
@@ -36,9 +36,17 @@ EXPORT_SYMBOL(xtime_lock);
  * at zero at system boot time, so wall_to_monotonic will be negative,
  * however, we will ALWAYS keep the tv_nsec part positive so we can use
  * the usual normalization.
+ *
+ * wall_to_monotonic is moved after resume from suspend for the monotonic
+ * time not to jump. We need to add total_sleep_time to wall_to_monotonic
+ * to get the real boot based time offset.
+ *
+ * - wall_to_monotonic is no longer the boot time, getboottime must be
+ * used instead.
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+static unsigned long total_sleep_time;		/* seconds */
 
 EXPORT_SYMBOL(xtime);
 
@@ -251,6 +259,7 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
+	total_sleep_time = 0;
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
@@ -282,6 +291,7 @@ static int timekeeping_resume(struct sys
 
 		xtime.tv_sec += sleep_length;
 		wall_to_monotonic.tv_sec -= sleep_length;
+		total_sleep_time += sleep_length;
 	}
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
@@ -476,3 +486,30 @@ void update_wall_time(void)
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
 }
+
+/**
+ * getboottime - Return the real time of system boot.
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ *
+ * This is based on the wall_to_monotonic offset and the total suspend
+ * time. Calls to settimeofday will affect the value returned (which
+ * basically means that however wrong your real time clock is at boot time,
+ * you get the right time here).
+ */
+void getboottime(struct timespec *ts)
+{
+	set_normalized_timespec(ts,
+		- (wall_to_monotonic.tv_sec + total_sleep_time),
+		- wall_to_monotonic.tv_nsec);
+}
+
+/**
+ * monotonic_to_bootbased - Convert the monotonic time to boot based.
+ * @ts:		pointer to the timespec to be converted
+ */
+void monotonic_to_bootbased(struct timespec *ts)
+{
+	ts->tv_sec += total_sleep_time;
+}
_

Patches currently in -mm which might be from tjanouse@redhat.com are

origin.patch
