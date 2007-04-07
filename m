From: akpm@linux-foundation.org
Subject: - timekeeping-drop-irq-context-clocksource-polling.patch removed from -mm tree
Date: Sat, 07 Apr 2007 03:19:38 -0700
Message-ID: <200704071019.l37AJc0P032403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965746AbXDGKUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 06:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timekeeping: drop irq-context clocksource polling
has been removed from the -mm tree.  Its filename was
     timekeeping-drop-irq-context-clocksource-polling.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: timekeeping: drop irq-context clocksource polling
From: Daniel Walker <dwalker@mvista.com>

Before this change the timekeeping code would poll the clocksource list
every interrupt.  This changes that so the clocksource list is only checked
when there has been and update, and no longer checks in interrupt context.

This also has a few small space and line cleanups.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timekeeping.h |   10 ++++++++++
 kernel/time/clocksource.c   |    7 +++++++
 kernel/time/timekeeping.c   |   17 ++++++++---------
 3 files changed, 25 insertions(+), 9 deletions(-)

diff -puN /dev/null include/linux/timekeeping.h
--- /dev/null
+++ a/include/linux/timekeeping.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_TIMEKEEPING_H
+#define _LINUX_TIMEKEEPING_H
+
+#ifdef CONFIG_GENERIC_TIME
+extern void timekeeping_change_clocksource(void);
+#else
+static inline void timekeeping_change_clocksource(void) { }
+#endif
+
+#endif
diff -puN kernel/time/clocksource.c~timekeeping-drop-irq-context-clocksource-polling kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~timekeeping-drop-irq-context-clocksource-polling
+++ a/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/timekeeping.h>
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
@@ -252,6 +253,8 @@ static int clocksource_enqueue(struct cl
 	    !strcmp(c->name, override_name))
 		clocksource_override = c;
 
+	timekeeping_change_clocksource();
+
 	return 0;
 }
 
@@ -291,6 +294,8 @@ void clocksource_change_rating(struct cl
 	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+
+	timekeeping_change_clocksource();
 }
 
 #ifdef CONFIG_SYSFS
@@ -368,6 +373,8 @@ static ssize_t sysfs_override_clocksourc
 
 	spin_unlock_irq(&clocksource_lock);
 
+	timekeeping_change_clocksource();
+
 	return ret;
 }
 
diff -puN kernel/time/timekeeping.c~timekeeping-drop-irq-context-clocksource-polling kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-drop-irq-context-clocksource-polling
+++ a/kernel/time/timekeeping.c
@@ -18,7 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 #include <linux/tick.h>
-
+#include <linux/timekeeping.h>
 
 /*
  * This read-write spinlock protects us from races in SMP while
@@ -42,10 +42,8 @@ struct timespec wall_to_monotonic __attr
 
 EXPORT_SYMBOL(xtime);
 
-
 static struct clocksource *clock; /* pointer to current clocksource */
 
-
 #ifdef CONFIG_GENERIC_TIME
 /**
  * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
@@ -168,9 +166,10 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static void change_clocksource(void)
+void timekeeping_change_clocksource(void)
 {
 	struct clocksource *new;
+	unsigned long flags;
 	cycle_t now;
 	u64 nsec;
 
@@ -179,8 +178,10 @@ static void change_clocksource(void)
 	if (clock == new)
 		return;
 
+	write_seqlock_irqsave(&xtime_lock, flags);
+
 	now = clocksource_read(new);
-	nsec =  __get_nsec_offset();
+	nsec = __get_nsec_offset();
 	timespec_add_ns(&xtime, nsec);
 
 	clock = new;
@@ -192,11 +193,11 @@ static void change_clocksource(void)
 
 	tick_clock_notify();
 
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
 	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 	       clock->name);
 }
-#else
-static inline void change_clocksource(void) { }
 #endif
 
 /**
@@ -470,7 +471,5 @@ void update_wall_time(void)
 	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 
-	/* check to see if there is a new clocksource to use */
-	change_clocksource();
 	update_vsyscall(&xtime, clock);
 }
_

Patches currently in -mm which might be from dwalker@mvista.com are

timekeeping-drop-irq-context-clocksource-polling.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
