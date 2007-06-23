From: akpm@linux-foundation.org
Subject: + posix-timers-prevent-softirq-starvation-by-small-intervals.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:47:12 -0700
Message-ID: <200706231647.l5NGl9gw019475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760219AbXFWQsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, drepper@redhat.com, jan.kiszka@web.de, mingo@elte.hu, stable@kernel.org


The patch titled
     posix-timers: prevent softirq starvation by small intervals and SIG_IGN
has been added to the -mm tree.  Its filename is
     posix-timers-prevent-softirq-starvation-by-small-intervals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: posix-timers: prevent softirq starvation by small intervals and SIG_IGN
From: Thomas Gleixner <tglx@linutronix.de>

posix-timers which deliver an ignored signal are currently rearmed in the
timer softirq: This is necessary because the timer needs to be delivered
again when SIG_IGN is removed.  This is not a problem, when the interval is
reasonable.

With high resolution timers enabled one might arm a posix timer with a very
small interval and ignore the signal.  This might lead to a softirq
starvation when the interval is so small that the timer is requeued onto
the softirq pending list right away.

This problem was pointed out by Jan Kiszka. Thanks Jan !

The correct solution would be to stop the timer, when the signal is ignored
and rearm it when SIG_IGN is removed.  Unfortunately this requires
modification in sigaction and involves non trivial sighand locking.  It's
too late in the release cycle for such a change.

For now we just keep the timer running and enforce that the timer only
fires every jiffie.  This does not break anything as we keep the overrun
counter correct.  It adds a little inaccuracy to the timer_gettime()
interface, but...

The more complex change is necessary anyway to fix another short coming of
the current implementation, which I discovered while looking at this
problem: A pending signal is discarded when SIG_IGN is set.  In case that a
posixtimer signal is pending then it is discarded as well, but when SIG_IGN
is removed later nothing rearms the timer.  This is not new, it's that way
since posix timers have been merged.  So nothing to worry about right now.

I have a working solution to fix all of this, but the impact is too large
for both stable and 2.6.22.  I'm going to send it out for review in the
next days.

This should go into 2.6.21.stable as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@web.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Stable Team <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-prevent-softirq-starvation-by-small-intervals kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-prevent-softirq-starvation-by-small-intervals
+++ a/kernel/posix-timers.c
@@ -353,9 +353,40 @@ static enum hrtimer_restart posix_timer_
 		 * it should be restarted.
 		 */
 		if (timr->it.real.interval.tv64 != 0) {
+			ktime_t now = hrtimer_cb_get_time(timer);
+
+			/*
+			 * FIXME: What we really want, is to stop this
+			 * timer completely and restart it in case the
+			 * SIG_IGN is removed. This is a non trivial
+			 * change which involves sighand locking
+			 * (sigh !), which we don't want to do late in
+			 * the release cycle.
+			 *
+			 * For now we just let timers with an interval
+			 * less than a jiffie expire every jiffie to
+			 * avoid softirq starvation in case of SIG_IGN
+			 * and a very small interval, which would put
+			 * the timer right back on the softirq pending
+			 * list. By moving now ahead of time we trick
+			 * hrtimer_forward() to expire the timer
+			 * later, while we still maintain the overrun
+			 * accuracy, but have some inconsistency in
+			 * the timer_gettime() case. This is at least
+			 * better than a starved softirq. A more
+			 * complex fix which solves also another related
+			 * inconsistency is already in the pipeline.
+			 */
+#ifdef CONFIG_HIGH_RES_TIMERS
+			{
+				ktime_t kj = ktime_set(0, NSEC_PER_SEC / HZ);
+
+				if (timr->it.real.interval.tv64 < kj.tv64)
+					now = ktime_add(now, kj);
+			}
+#endif
 			timr->it_overrun +=
-				hrtimer_forward(timer,
-						hrtimer_cb_get_time(timer),
+				hrtimer_forward(timer, now,
 						timr->it.real.interval);
 			ret = HRTIMER_RESTART;
 			++timr->it_requeue_pending;
_

Patches currently in -mm which might be from tglx@linutronix.de are

futex-revert-the-non-functional-requeue_pi.patch
posix-timers-prevent-softirq-starvation-by-small-intervals.patch
git-acpi-add-exports.patch
git-arm.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
lguest-the-host-code.patch
