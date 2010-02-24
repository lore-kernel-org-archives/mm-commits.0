From: akpm@linux-foundation.org
Subject: [merged] clocksource-add-suspend-callback.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:40:06 -0800
Message-ID: <201002241940.o1OJe6n7016345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757711Ab0BXTko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: add suspend callback
has been removed from the -mm tree.  Its filename was
     clocksource-add-suspend-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: add suspend callback
From: Magnus Damm <damm@opensource.se>

Add a clocksource suspend callback.  This callback can be used by the
clocksource driver to shutdown and perform any kind of late suspend
activities even though the clocksource driver itself is a non-sysdev
driver.

One example where this is useful is to fix the sh_cmt.c platform driver
that today suspends using the platform bus and shuts down the clocksource
too early.

With this callback in place the sh_cmt driver will suspend using the
clocksource and clockevent hooks and leave the platform device pm
callbacks unused.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    3 +++
 kernel/time/clocksource.c   |   12 ++++++++++++
 kernel/time/timekeeping.c   |    1 +
 3 files changed, 16 insertions(+)

diff -puN include/linux/clocksource.h~clocksource-add-suspend-callback include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-add-suspend-callback
+++ a/include/linux/clocksource.h
@@ -154,6 +154,7 @@ extern u64 timecounter_cyc2time(struct t
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
+ * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  */
 struct clocksource {
@@ -172,6 +173,7 @@ struct clocksource {
 	u64 max_idle_ns;
 	unsigned long flags;
 	cycle_t (*vread)(void);
+	void (*suspend)(struct clocksource *cs);
 	void (*resume)(struct clocksource *cs);
 #ifdef CONFIG_IA64
 	void *fsys_mmio;        /* used by fsyscall asm code */
@@ -277,6 +279,7 @@ extern void clocksource_unregister(struc
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
diff -puN kernel/time/clocksource.c~clocksource-add-suspend-callback kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-suspend-callback
+++ a/kernel/time/clocksource.c
@@ -453,6 +453,18 @@ static inline int clocksource_watchdog_k
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 /**
+ * clocksource_suspend - suspend the clocksource(s)
+ */
+void clocksource_suspend(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry_reverse(cs, &clocksource_list, list)
+		if (cs->suspend)
+			cs->suspend(cs);
+}
+
+/**
  * clocksource_resume - resume the clocksource(s)
  */
 void clocksource_resume(void)
diff -puN kernel/time/timekeeping.c~clocksource-add-suspend-callback kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~clocksource-add-suspend-callback
+++ a/kernel/time/timekeeping.c
@@ -622,6 +622,7 @@ static int timekeeping_suspend(struct sy
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	clocksource_suspend();
 
 	return 0;
 }
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch

