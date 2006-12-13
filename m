From: akpm@osdl.org
Subject: + gtod-persistent-clock-support-core.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:43:47 -0800
Message-ID: <200612132243.kBDMhlD3022832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbWLMWrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, bunk@stusta.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     gtod: persistent clock support, core
has been added to the -mm tree.  Its filename is
     gtod-persistent-clock-support-core.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gtod: persistent clock support, core
From: John Stultz <johnstul@us.ibm.com>

Persistent clock support: do proper timekeeping across suspend/resume.

[ cleanup from Adrian Bunk <bunk@stusta.de> ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    3 +++
 include/linux/time.h    |    1 +
 kernel/hrtimer.c        |    8 ++++++++
 kernel/timer.c          |   37 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff -puN include/linux/hrtimer.h~gtod-persistent-clock-support-core include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~gtod-persistent-clock-support-core
+++ a/include/linux/hrtimer.h
@@ -146,6 +146,9 @@ extern void hrtimer_init_sleeper(struct 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
 
+/* Resume notification */
+void hrtimer_notify_resume(void);
+
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
diff -puN include/linux/time.h~gtod-persistent-clock-support-core include/linux/time.h
--- a/include/linux/time.h~gtod-persistent-clock-support-core
+++ a/include/linux/time.h
@@ -92,6 +92,7 @@ extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock __attribute__((weak));
 
+extern unsigned long read_persistent_clock(void);
 void timekeeping_init(void);
 
 static inline unsigned long get_seconds(void)
diff -puN kernel/hrtimer.c~gtod-persistent-clock-support-core kernel/hrtimer.c
--- a/kernel/hrtimer.c~gtod-persistent-clock-support-core
+++ a/kernel/hrtimer.c
@@ -287,6 +287,14 @@ static unsigned long ktime_divns(const k
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
+ * Timekeeping resumed notification
+ */
+void hrtimer_notify_resume(void)
+{
+	clock_was_set();
+}
+
+/*
  * Counterpart to lock_timer_base above:
  */
 static inline
diff -puN kernel/timer.c~gtod-persistent-clock-support-core kernel/timer.c
--- a/kernel/timer.c~gtod-persistent-clock-support-core
+++ a/kernel/timer.c
@@ -878,12 +878,27 @@ int timekeeping_is_continuous(void)
 	return ret;
 }
 
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
 /*
  * timekeeping_init - Initializes the clocksource and common timekeeping values
  */
 void __init timekeeping_init(void)
 {
 	unsigned long flags;
+	unsigned long sec = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
@@ -893,11 +908,20 @@ void __init timekeeping_init(void)
 	clocksource_calculate_interval(clock, tick_nsec);
 	clock->cycle_last = clocksource_read(clock);
 
+	xtime.tv_sec = sec;
+	xtime.tv_nsec = 0;
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
+
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
 
+/* flag for if timekeeping is suspended */
 static int timekeeping_suspended;
+/* time in seconds when suspend began */
+static unsigned long timekeeping_suspend_time;
+
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  * @dev:	unused
@@ -909,13 +933,23 @@ static int timekeeping_suspended;
 static int timekeeping_resume(struct sys_device *dev)
 {
 	unsigned long flags;
+	unsigned long now = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	/* restart the last cycle value */
+
+	if (now && (now > timekeeping_suspend_time)) {
+		unsigned long sleep_length = now - timekeeping_suspend_time;
+		xtime.tv_sec += sleep_length;
+		jiffies_64 += (u64)sleep_length * HZ;
+	}
+	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	hrtimer_notify_resume();
+
 	return 0;
 }
 
@@ -925,6 +959,7 @@ static int timekeeping_suspend(struct sy
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_suspended = 1;
+	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 	return 0;
 }
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
clockevents-core.patch
clockevents-i386-drivers.patch
high-res-timers-core.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
debugging-feature-add-proc-timer_stat.patch

