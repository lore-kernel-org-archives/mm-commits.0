Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8C3C2B9F2
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E72611C1
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhEWAn0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF4B36100A;
        Sun, 23 May 2021 00:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730520;
        bh=w6r4+6oLQ9XxfpIH6oV3PgU3paSqR8vp9PDMuLDqusU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BwlfXixFmoIRraFkvnq0V4UOV5gHeDRbvnAcMVsnoQFHtf+/SejaaN0koxOg0k7Ba
         Je8NlhzSd9pf6DiiZoX6zKMyM0EaxH1JiGdG13y2yw9I1TOoM0MjPyR2gakSetMN+v
         YfKdBnIjBbyrrVLPgR8jr5h9ptLfEeIyUZbxl5NA=
Date:   Sat, 22 May 2021 17:41:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        senozhatsky@chromium.org, torvalds@linux-foundation.org
Subject:  [patch 06/10] watchdog: reliable handling of timestamps
Message-ID: <20210523004159.hyJ_THBDa%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>
Subject: watchdog: reliable handling of timestamps

The commit 9bf3bc949f8aeefeacea4b ("watchdog: cleanup handling of false
positives") tried to handle a virtual host stopped by the host a more
straightforward and cleaner way.

But it introduced a risk of false softlockup reports.  The virtual host
might be stopped at any time, for example between
kvm_check_and_clear_guest_paused() and is_softlockup().  As a result,
is_softlockup() might read the updated jiffies are detects softlockup.

A solution might be to put back kvm_check_and_clear_guest_paused() after
is_softlockup() and detect it.  But it would put back the cycle that
complicates the logic.

In fact, the handling of all the timestamps is not reliable.  The code
does not guarantee when and how many times the timestamps are read.  For
example, "period_ts" might be touched anytime also from NMI and re-read in
is_softlockup().  It works just by chance.

Fix all the problems by making the code even more explicit.

1. Make sure that "now" and "period_ts" timestamps are read only once.
   They might be changed at anytime by NMI or when the virtual guest is
   stopped by the host.  Note that "now" timestamp does this implicitly
   because "jiffies" is marked volatile.

2. "now" time must be read first.  The state of "period_ts" will
   decide whether it will be used or the period will get restarted.

3. kvm_check_and_clear_guest_paused() must be called before reading
   "period_ts".  It touches the variable when the guest was stopped.

As a result, "now" timestamp is used only when the watchdog was not
touched and the guest not stopped in the meantime.  "period_ts" is
restarted in all other situations.

Link: https://lkml.kernel.org/r/YKT55gw+RZfyoFf7@alley
Fixes: 9bf3bc949f8aeefeacea4b ("watchdog: cleanup handling of false positives")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/kernel/watchdog.c~watchdog-reliable-handling-of-timestamps
+++ a/kernel/watchdog.c
@@ -302,10 +302,10 @@ void touch_softlockup_watchdog_sync(void
 	__this_cpu_write(watchdog_report_ts, SOFTLOCKUP_DELAY_REPORT);
 }
 
-static int is_softlockup(unsigned long touch_ts, unsigned long period_ts)
+static int is_softlockup(unsigned long touch_ts,
+			 unsigned long period_ts,
+			 unsigned long now)
 {
-	unsigned long now = get_timestamp();
-
 	if ((watchdog_enabled & SOFT_WATCHDOG_ENABLED) && watchdog_thresh){
 		/* Warn about unreasonable delays. */
 		if (time_after(now, period_ts + get_softlockup_thresh()))
@@ -353,8 +353,7 @@ static int softlockup_fn(void *data)
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
-	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
-	unsigned long period_ts = __this_cpu_read(watchdog_report_ts);
+	unsigned long touch_ts, period_ts, now;
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
@@ -377,11 +376,22 @@ static enum hrtimer_restart watchdog_tim
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
 	/*
+	 * Read the current timestamp first. It might become invalid anytime
+	 * when a virtual machine is stopped by the host or when the watchog
+	 * is touched from NMI.
+	 */
+	now = get_timestamp();
+	/*
 	 * If a virtual machine is stopped by the host it can look to
-	 * the watchdog like a soft lockup. Check to see if the host
-	 * stopped the vm before we process the timestamps.
+	 * the watchdog like a soft lockup. This function touches the watchdog.
 	 */
 	kvm_check_and_clear_guest_paused();
+	/*
+	 * The stored timestamp is comparable with @now only when not touched.
+	 * It might get touched anytime from NMI. Make sure that is_softlockup()
+	 * uses the same (valid) value.
+	 */
+	period_ts = READ_ONCE(*this_cpu_ptr(&watchdog_report_ts));
 
 	/* Reset the interval when touched by known problematic code. */
 	if (period_ts == SOFTLOCKUP_DELAY_REPORT) {
@@ -398,13 +408,9 @@ static enum hrtimer_restart watchdog_tim
 		return HRTIMER_RESTART;
 	}
 
-	/* check for a softlockup
-	 * This is done by making sure a high priority task is
-	 * being scheduled.  The task touches the watchdog to
-	 * indicate it is getting cpu time.  If it hasn't then
-	 * this is a good indication some task is hogging the cpu
-	 */
-	duration = is_softlockup(touch_ts, period_ts);
+	/* Check for a softlockup. */
+	touch_ts = __this_cpu_read(watchdog_touch_ts);
+	duration = is_softlockup(touch_ts, period_ts, now);
 	if (unlikely(duration)) {
 		/*
 		 * Prevent multiple soft-lockup reports if one cpu is already
_
