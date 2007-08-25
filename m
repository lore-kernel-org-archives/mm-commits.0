From: akpm@linux-foundation.org
Subject: - msleep-with-hrtimers.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:43:19 -0700
Message-ID: <200708250343.l7P3hJ5o028741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452AbXHYDoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     msleep() with hrtimers
has been removed from the -mm tree.  Its filename was
     msleep-with-hrtimers.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: msleep() with hrtimers
From: Jonathan Corbet <corbet@lwn.net>

The problem being addressed here is that the current msleep() will stop for
a minimum of two jiffies, meaning that, on a HZ=100 system, msleep(1)
delays for for about 20ms.  In a driver with one such delay for each of 150
or so register setting operations, the extra time adds up to a few seconds.

This patch addresses the situation by using hrtimers.  On tickless systems
with working timers, msleep(1) now sleeps for 1ms, even with HZ=100.

Roman worries about the overhead of using hrtimers for this operation; my
understanding is that he would rather see a really_msleep() function for
those who actually want millisecond resolution.  I'm not sure how to
characterize what the cost could be, but it can only be buried by the fact
that every call sleeps for some number of milliseconds.  On my system, the
several hundred total msleep() calls can't cause any real overhead, and
almost all happen at initialization time.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   47 ++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 38 insertions(+), 9 deletions(-)

diff -puN kernel/timer.c~msleep-with-hrtimers kernel/timer.c
--- a/kernel/timer.c~msleep-with-hrtimers
+++ a/kernel/timer.c
@@ -1353,18 +1353,43 @@ void __init init_timers(void)
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
 }
 
+
+
+
+static void do_msleep(unsigned int msecs, struct hrtimer_sleeper *sleeper,
+	int sigs)
+{
+	enum hrtimer_mode mode = HRTIMER_MODE_REL;
+	int state = sigs ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE;
+
+	/*
+	 * This is really just a reworked and simplified version
+	 * of do_nanosleep().
+	 */
+	hrtimer_init(&sleeper->timer, CLOCK_MONOTONIC, mode);
+	sleeper->timer.expires = ktime_set(0, msecs*NSEC_PER_MSEC);
+	hrtimer_init_sleeper(sleeper, current);
+
+	do {
+		set_current_state(state);
+		hrtimer_start(&sleeper->timer, sleeper->timer.expires, mode);
+		if (sleeper->task)
+			schedule();
+		hrtimer_cancel(&sleeper->timer);
+		mode = HRTIMER_MODE_ABS;
+	} while (sleeper->task && !(sigs && signal_pending(current)));
+}
+
 /**
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for
  */
 void msleep(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	struct hrtimer_sleeper sleeper;
 
-	while (timeout)
-		timeout = schedule_timeout_uninterruptible(timeout);
+	do_msleep(msecs, &sleeper, 0);
 }
-
 EXPORT_SYMBOL(msleep);
 
 /**
@@ -1373,11 +1398,15 @@ EXPORT_SYMBOL(msleep);
  */
 unsigned long msleep_interruptible(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	struct hrtimer_sleeper sleeper;
+	ktime_t left;
 
-	while (timeout && !signal_pending(current))
-		timeout = schedule_timeout_interruptible(timeout);
-	return jiffies_to_msecs(timeout);
-}
+	do_msleep(msecs, &sleeper, 1);
 
+	if (!sleeper.task)
+		return 0;
+	left = ktime_sub(sleeper.timer.expires,
+			 sleeper.timer.base->get_time());
+	return max(((long) ktime_to_ns(left))/NSEC_PER_MSEC, 1L);
+}
 EXPORT_SYMBOL(msleep_interruptible);
_

Patches currently in -mm which might be from corbet@lwn.net are

origin.patch
