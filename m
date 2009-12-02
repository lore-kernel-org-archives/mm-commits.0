From: akpm@linux-foundation.org
Subject: + clocksource-add-suspend-callback.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:36:45 -0800
Message-ID: <200912022336.nB2NajQP028486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755801AbZLBXhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:37:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de


The patch titled
     clocksource: add suspend callback
has been added to the -mm tree.  Its filename is
     clocksource-add-suspend-callback.patch

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
 
diff -puN kernel/time/clocksource.c~clocksource-add-suspend-callback kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-suspend-callback
+++ a/kernel/time/clocksource.c
@@ -441,6 +441,18 @@ static inline int clocksource_watchdog_k
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
@@ -611,6 +611,7 @@ static int timekeeping_suspend(struct sy
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	clocksource_suspend();
 
 	return 0;
 }
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
driver-core-early-platform-driver-buffer.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
mm-uncached-vma-support-with-writenotify.patch
mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch

