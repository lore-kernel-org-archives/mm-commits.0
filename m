From: akpm@linux-foundation.org
Subject: - dynticks-fix-hrtimer-rounding-error-in.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:55 -0800
Message-ID: <200703260105.l2Q15tDX008741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbXCZBJ1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, bunk@stusta.de, jkarlson@cc.hut.fi, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     dynticks: fix hrtimer rounding error in next_timer_interrupt()
has been removed from the -mm tree.  Its filename was
     dynticks-fix-hrtimer-rounding-error-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
mm-only-hrtimers-debug-patch.patch
