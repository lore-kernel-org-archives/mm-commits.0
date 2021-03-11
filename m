Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B204C43381
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC23B64FB2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhCKVWa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhCKVWM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 366C864F9C;
        Thu, 11 Mar 2021 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615497732;
        bh=fDPE0bbw9YY2wlWnPqMkWTbvCv9yzuKhBYUuMVjBDwE=;
        h=Date:From:To:Subject:From;
        b=1MCPmLUUvTN7rw8idVieUTTxzCahsQ3Ms7jBdypE3EQXFtRO3CvzLR5g0mu8y/rU1
         C8jki8leLHjZIICyR0P9wX4kD9+KMbqTw5kNhFTFgktYIr9ipbs5e9PZ6JAVv9xXWg
         dNqumKKf+Z6jz+F/hnoTFXxVv4SQElRV1QaRA6PE=
Date:   Thu, 11 Mar 2021 13:22:10 -0800
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  + watchdog-cleanup-handling-of-false-positives.patch
 added to -mm tree
Message-ID: <20210311212210.6UdHS-qBa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: cleanup handling of false positives
has been added to the -mm tree.  Its filename is
     watchdog-cleanup-handling-of-false-positives.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/watchdog-cleanup-handling-of-false-positives.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/watchdog-cleanup-handling-of-false-positives.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog: cleanup handling of false positives

The commit d6ad3e286d2c075 ("softlockup: Add sched_clock_tick() to avoid
kernel warning on kgdb resume") introduced
touch_softlockup_watchdog_sync().

It solved a problem when the watchdog was touched in an atomic context,
the timer callback was proceed right after releasing interrupts, and the
local clock has not been updated yet.  In this case, sched_clock_tick()
was called in watchdog_timer_fn() before updating the timer.

So far so good.

Later the commit 5d1c0f4a80a6df73 ("watchdog: add check for suspended vm
in softlockup detector") added two kvm_check_and_clear_guest_paused()
calls.  They touch the watchdog when the guest has been sleeping.

The code makes my head spin around.

Scenario 1:

    + guest did sleep:
	+ PVCLOCK_GUEST_STOPPED is set

    + 1st watchdog_timer_fn() invocation:
	+ the watchdog is not touched yet
	+ is_softlockup() returns too big delay
	+ kvm_check_and_clear_guest_paused():
	   + clear PVCLOCK_GUEST_STOPPED
	   + call touch_softlockup_watchdog_sync()
		+ set SOFTLOCKUP_DELAY_REPORT
		+ set softlockup_touch_sync
	+ return from the timer callback

      + 2nd watchdog_timer_fn() invocation:

	+ call sched_clock_tick() even though it is not needed.
	  The timer callback was invoked again only because the clock
	  has already been updated in the meantime.

	+ call kvm_check_and_clear_guest_paused() that does nothing
	  because PVCLOCK_GUEST_STOPPED has been cleared already.

	+ call update_report_ts() and return. This is fine. Except
	  that sched_clock_tick() might allow to set it already
	  during the 1st invocation.

Scenario 2:

	+ guest did sleep

	+ 1st watchdog_timer_fn() invocation
	    + same as in 1st scenario

	+ guest did sleep again:
	    + set PVCLOCK_GUEST_STOPPED again

	+ 2nd watchdog_timer_fn() invocation
	    + SOFTLOCKUP_DELAY_REPORT is set from 1st invocation
	    + call sched_clock_tick()
	    + call kvm_check_and_clear_guest_paused()
		+ clear PVCLOCK_GUEST_STOPPED
		+ call touch_softlockup_watchdog_sync()
		    + set SOFTLOCKUP_DELAY_REPORT
		    + set softlockup_touch_sync
	    + call update_report_ts() (set real timestamp immediately)
	    + return from the timer callback

	+ 3rd watchdog_timer_fn() invocation
	    + timestamp is set from 2nd invocation
	    + softlockup_touch_sync is set but not checked because
	      the real timestamp is already set

Make the code more straightforward:

1. Always call kvm_check_and_clear_guest_paused() at the very
   beginning to handle PVCLOCK_GUEST_STOPPED. It touches the watchdog
   when the quest did sleep.

2. Handle the situation when the watchdog has been touched
   (SOFTLOCKUP_DELAY_REPORT is set).

   Call sched_clock_tick() when touch_*sync() variant was used. It makes
   sure that the timestamp will be up to date even when it has been
   touched in atomic context or quest did sleep.

As a result, kvm_check_and_clear_guest_paused() is called on a single
location.  And the right timestamp is always set when returning from the
timer callback.

Link: https://lkml.kernel.org/r/20210311122130.6788-7-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/kernel/watchdog.c~watchdog-cleanup-handling-of-false-positives
+++ a/kernel/watchdog.c
@@ -375,7 +375,14 @@ static enum hrtimer_restart watchdog_tim
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
-	/* Reset the interval when touched externally by a known slow code. */
+	/*
+	 * If a virtual machine is stopped by the host it can look to
+	 * the watchdog like a soft lockup. Check to see if the host
+	 * stopped the vm before we process the timestamps.
+	 */
+	kvm_check_and_clear_guest_paused();
+
+	/* Reset the interval when touched by known problematic code. */
 	if (period_ts == SOFTLOCKUP_DELAY_REPORT) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
@@ -386,10 +393,7 @@ static enum hrtimer_restart watchdog_tim
 			sched_clock_tick();
 		}
 
-		/* Clear the guest paused flag on watchdog reset */
-		kvm_check_and_clear_guest_paused();
 		update_report_ts();
-
 		return HRTIMER_RESTART;
 	}
 
@@ -402,14 +406,6 @@ static enum hrtimer_restart watchdog_tim
 	duration = is_softlockup(touch_ts, period_ts);
 	if (unlikely(duration)) {
 		/*
-		 * If a virtual machine is stopped by the host it can look to
-		 * the watchdog like a soft lockup, check to see if the host
-		 * stopped the vm before we issue the warning
-		 */
-		if (kvm_check_and_clear_guest_paused())
-			return HRTIMER_RESTART;
-
-		/*
 		 * Prevent multiple soft-lockup reports if one cpu is already
 		 * engaged in dumping all cpu back traces.
 		 */
_

Patches currently in -mm which might be from pmladek@suse.com are

watchdog-rename-__touch_watchdog-to-a-better-descriptive-name.patch
watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch
watchdog-softlockup-report-the-overall-time-of-softlockups.patch
watchdog-softlockup-remove-logic-that-tried-to-prevent-repeated-reports.patch
watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch
watchdog-cleanup-handling-of-false-positives.patch

