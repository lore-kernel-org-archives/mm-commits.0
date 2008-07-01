From: akpm@linux-foundation.org
Subject: + tick-schedc-suppress-needless-timer-reprogramming.patch added to -mm tree
Date: Mon, 30 Jun 2008 23:29:34 -0700
Message-ID: <200807010629.m616TY3v012819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbYGAG3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 02:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: r-woodruff2@ti.com, tglx@linutronix.de


The patch titled
     tick-sched.c: suppress needless timer reprogramming
has been added to the -mm tree.  Its filename is
     tick-schedc-suppress-needless-timer-reprogramming.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tick-sched.c: suppress needless timer reprogramming
From: "Woodruff, Richard" <r-woodruff2@ti.com>

In my device I get many interrupts from a high speed USB device in a very
short period of time.  The system spends a lot of time reprogramming the
hardware timer which is in a slower timing domain as compared to the CPU. 
This results in the CPU spending a huge amount of time waiting for the
timer posting to be done.  All of this reprogramming is useless as the
wake up time has not changed.

As measured using ETM trace this drops my reprogramming penalty from
almost 60% CPU load down to 15% during high interrupt rate.  I can send
traces to show this.


Suppress setting of duplicate timer event when timer already stopped. 
Timer programming can be very costly and can result in long cpu stall/wait
times.

Signed-off-by: Richard Woodruff <r-woodruff2@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN kernel/time/tick-sched.c~tick-schedc-suppress-needless-timer-reprogramming kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-schedc-suppress-needless-timer-reprogramming
+++ a/kernel/time/tick-sched.c
@@ -261,6 +261,17 @@ void tick_nohz_stop_sched_tick(void)
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
 
+		/*
+		* calculate the expiry time for the next timer wheel
+		* timer
+		*/
+		expires = ktime_add_ns(last_update, tick_period.tv64 *
+				   delta_jiffies);
+
+		/* Skip reprogram of event if its not changed */
+		if(ts->tick_stopped && ktime_equal(expires, dev->next_event))
+			goto out2;
+
 		if (delta_jiffies > 1)
 			cpu_set(cpu, nohz_cpu_mask);
 		/*
@@ -311,12 +322,7 @@ void tick_nohz_stop_sched_tick(void)
 			goto out;
 		}
 
-		/*
-		 * calculate the expiry time for the next timer wheel
-		 * timer
-		 */
-		expires = ktime_add_ns(last_update, tick_period.tv64 *
-				       delta_jiffies);
+		/* Mark expiries */
 		ts->idle_expires = expires;
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
@@ -335,6 +341,7 @@ void tick_nohz_stop_sched_tick(void)
 		tick_do_update_jiffies64(ktime_get());
 		cpu_clear(cpu, nohz_cpu_mask);
 	}
+out2:
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
 out:
 	ts->next_jiffies = next_jiffies;
_

Patches currently in -mm which might be from r-woodruff2@ti.com are

tick-schedc-suppress-needless-timer-reprogramming.patch

