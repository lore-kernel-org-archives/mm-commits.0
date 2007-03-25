From: akpm@linux-foundation.org
Subject: + dynticks-fix-hrtimer-rounding-error-in.patch added to -mm tree
Date: Sun, 25 Mar 2007 13:44:05 -0800
Message-ID: <200703252144.l2PLi5lY003548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59022 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXCYVrf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 17:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, bunk@stusta.de, jkarlson@cc.hut.fi, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     dynticks: fix hrtimer rounding error in next_timer_interrupt()
has been added to the -mm tree.  Its filename is
     dynticks-fix-hrtimer-rounding-error-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dynticks: fix hrtimer rounding error in next_timer_interrupt()
From: Thomas Gleixner <tglx@linutronix.de>

The rework of next_timer_interrupt() fixed the timer wheel bugs, but
invented a rounding error versus the next hrtimer event.  This is caused by
the conversion of the hrtimer internal representation to relative jiffies.

This causes bug #8100:
http://bugzilla.kernel.org/show_bug.cgi?id=8100

next_timer_interrupt() returns "now" in such a case and causes the code in
tick_nohz_stop_sched_tick() to trigger the timer softirq, which is bogus as
no timer is due for expiry.  This results in an endless context switching
between idle and ksoftirqd until a timer is due for expiry.

Modify the hrtimer evaluation so that, it returns now + 1, when the
conversion results in a delta < 1 jiffie.

It's confirmed to resolve bug #8100

Reported-by: Emil Karlson <jkarlson@cc.hut.fi>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN kernel/timer.c~dynticks-fix-hrtimer-rounding-error-in kernel/timer.c
--- a/kernel/timer.c~dynticks-fix-hrtimer-rounding-error-in
+++ a/kernel/timer.c
@@ -695,15 +695,28 @@ static unsigned long cmp_next_hrtimer_ev
 {
 	ktime_t hr_delta = hrtimer_get_next_event();
 	struct timespec tsdelta;
+	unsigned long delta;
 
 	if (hr_delta.tv64 == KTIME_MAX)
 		return expires;
 
-	if (hr_delta.tv64 <= TICK_NSEC)
-		return now;
+	/*
+	 * Expired timer available, let it expire in the next tick
+	 */
+	if (hr_delta.tv64 <= 0)
+		return now + 1;
 
 	tsdelta = ktime_to_timespec(hr_delta);
-	now += timespec_to_jiffies(&tsdelta);
+	delta = timespec_to_jiffies(&tsdelta);
+	/*
+	 * Take rounding errors in to account and make sure, that it
+	 * expires in the next tick. Otherwise we go into an endless
+	 * ping pong due to tick_nohz_stop_sched_tick() retriggering
+	 * the timer softirq
+	 */
+	if (delta < 1)
+		delta = 1;
+	now += delta;
 	if (time_before(now, expires))
 		return now;
 	return expires;
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
time-fix-formatting-in-proc-timer_list.patch
correct-slow-acpi_pm-rating.patch
i386-prevent-early-access-to-tsc-to-avoid-crash-on.patch
dynticks-fix-hrtimer-rounding-error-in.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
mm-only-hrtimers-debug-patch.patch
