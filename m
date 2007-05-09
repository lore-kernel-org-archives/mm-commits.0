From: akpm@linux-foundation.org
Subject: - clocksource-fix-resume-logic.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:13 -0700
Message-ID: <200705092154.l49LsDZ0003154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759502AbXEIV4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: fix resume logic
has been removed from the -mm tree.  Its filename was
     clocksource-fix-resume-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>

We need to make sure that the clocksources are resumed, when timekeeping is
resumed.  The current resume logic does not guarantee this.

Add a resume function pointer to the clocksource struct, so clocksource
drivers which need to reinitialize the clocksource can provide a resume
function.

Add a resume function, which calls the maybe available clocksource resume
functions and resets the watchdog function, so a stable TSC can be used
accross suspend/resume.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    3 ++
 kernel/time/clocksource.c   |   45 ++++++++++++++++++++++++++++++++++
 kernel/timer.c              |    2 +
 3 files changed, 50 insertions(+)

diff -puN include/linux/clocksource.h~clocksource-fix-resume-logic include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-fix-resume-logic
+++ a/include/linux/clocksource.h
@@ -49,6 +49,7 @@ struct clocksource;
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
+ * @resume:		resume function for the clocksource, if necessary
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -65,6 +66,7 @@ struct clocksource {
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
+	void (*resume)(void);
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_interval;
@@ -209,6 +211,7 @@ static inline void clocksource_calculate
 extern int clocksource_register(struct clocksource*);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
diff -puN kernel/time/clocksource.c~clocksource-fix-resume-logic kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-fix-resume-logic
+++ a/kernel/time/clocksource.c
@@ -74,6 +74,8 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
+static int watchdog_resumed;
+
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
@@ -98,15 +100,26 @@ static void clocksource_watchdog(unsigne
 	struct clocksource *cs, *tmp;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
+	int resumed;
 
 	spin_lock(&watchdog_lock);
 
+	resumed = watchdog_resumed;
+	if (unlikely(resumed))
+		watchdog_resumed = 0;
+
 	wdnow = watchdog->read();
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
 
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		csnow = cs->read();
+
+		if (unlikely(resumed)) {
+			cs->wd_last = csnow;
+			continue;
+		}
+
 		/* Initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
@@ -136,6 +149,13 @@ static void clocksource_watchdog(unsigne
 	}
 	spin_unlock(&watchdog_lock);
 }
+static void clocksource_resume_watchdog(void)
+{
+	spin_lock(&watchdog_lock);
+	watchdog_resumed = 1;
+	spin_unlock(&watchdog_lock);
+}
+
 static void clocksource_check_watchdog(struct clocksource *cs)
 {
 	struct clocksource *cse;
@@ -182,9 +202,34 @@ static void clocksource_check_watchdog(s
 	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 }
+
+static inline void clocksource_resume_watchdog(void) { }
 #endif
 
 /**
+ * clocksource_resume - resume the clocksource(s)
+ */
+void clocksource_resume(void)
+{
+	struct list_head *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *cs;
+
+		cs = list_entry(tmp, struct clocksource, list);
+		if (cs->resume)
+			cs->resume();
+	}
+
+	clocksource_resume_watchdog();
+
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+}
+
+/**
  * clocksource_get_next - Returns the selected clocksource
  *
  */
diff -puN kernel/timer.c~clocksource-fix-resume-logic kernel/timer.c
--- a/kernel/timer.c~clocksource-fix-resume-logic
+++ a/kernel/timer.c
@@ -1499,6 +1499,8 @@ unregister_time_interpolator(struct time
 		prev = &curr->next;
 	}
 
+	clocksource_resume();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
 	if (ti == time_interpolator) {
 		/* we lost the best time-interpolator: */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
git-ieee1394.patch
s390-spinlock-initializer-cleanup.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
