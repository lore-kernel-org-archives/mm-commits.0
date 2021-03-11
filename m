Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DA5C4332E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6605864FC1
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCKVW3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:22:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhCKVWC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:22:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0451064F91;
        Thu, 11 Mar 2021 21:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615497722;
        bh=Rfl3gBJof4K/iTuUiUUnfvrHS0QThVDH1DTj74hIMWw=;
        h=Date:From:To:Subject:From;
        b=Ka6TN4lEyyAD1Te3T9W+Miff83LlLN56YImko338w8SUvUZmnBCBnmL4GP2n49dHw
         DCOoUXsiBFe0iMEaMw48yubOmgGF0BFqt+wKszw2LP9O103df5K7cfXEfzPe2tXKzw
         SQ22DC39LgcyNhkFEHYFp1khAt4PCkxnUrZdNjl0=
Date:   Thu, 11 Mar 2021 13:22:00 -0800
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  +
 watchdog-softlockup-report-the-overall-time-of-softlockups.patch added to
 -mm tree
Message-ID: <20210311212200.9lTiWNs4d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/softlockup: report the overall time of softlockups
has been added to the -mm tree.  Its filename is
     watchdog-softlockup-report-the-overall-time-of-softlockups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/watchdog-softlockup-report-the-overall-time-of-softlockups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/watchdog-softlockup-report-the-overall-time-of-softlockups.patch

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
Subject: watchdog/softlockup: report the overall time of softlockups

The softlockup detector currently shows the time spent since the last
report.  As a result it is not clear whether a CPU is infinitely hogged by
a single task or if it is a repeated event.

The situation can be simulated with a simply busy loop:

	while (true)
	      cpu_relax();

The softlockup detector produces:

[  168.277520] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [cat:4865]
[  196.277604] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [cat:4865]
[  236.277522] watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [cat:4865]

But it should be, something like:

[  480.372418] watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [cat:4943]
[  508.372359] watchdog: BUG: soft lockup - CPU#2 stuck for 52s! [cat:4943]
[  548.372359] watchdog: BUG: soft lockup - CPU#2 stuck for 89s! [cat:4943]
[  576.372351] watchdog: BUG: soft lockup - CPU#2 stuck for 115s! [cat:4943]

For the better output, add an additional timestamp of the last report. 
Only this timestamp is reset when the watchdog is intentionally touched
from slow code paths or when printing the report.

Link: https://lkml.kernel.org/r/20210311122130.6788-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-report-the-overall-time-of-softlockups
+++ a/kernel/watchdog.c
@@ -154,7 +154,11 @@ static void lockup_detector_update_enabl
 
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
-#define SOFTLOCKUP_RESET	ULONG_MAX
+/*
+ * Delay the soflockup report when running a known slow code.
+ * It does _not_ affect the timestamp of the last successdul reschedule.
+ */
+#define SOFTLOCKUP_DELAY_REPORT	ULONG_MAX
 
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
@@ -169,7 +173,10 @@ unsigned int __read_mostly softlockup_pa
 static bool softlockup_initialized __read_mostly;
 static u64 __read_mostly sample_period;
 
+/* Timestamp taken after the last successful reschedule. */
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+/* Timestamp of the last softlockup report. */
+static DEFINE_PER_CPU(unsigned long, watchdog_report_ts);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
@@ -235,10 +242,16 @@ static void set_sample_period(void)
 	watchdog_update_hrtimer_threshold(sample_period);
 }
 
+static void update_report_ts(void)
+{
+	__this_cpu_write(watchdog_report_ts, get_timestamp());
+}
+
 /* Commands for resetting the watchdog */
 static void update_touch_ts(void)
 {
 	__this_cpu_write(watchdog_touch_ts, get_timestamp());
+	update_report_ts();
 }
 
 /**
@@ -252,10 +265,10 @@ static void update_touch_ts(void)
 notrace void touch_softlockup_watchdog_sched(void)
 {
 	/*
-	 * Preemption can be enabled.  It doesn't matter which CPU's timestamp
-	 * gets zeroed here, so use the raw_ operation.
+	 * Preemption can be enabled.  It doesn't matter which CPU's watchdog
+	 * report period gets restarted here, so use the raw_ operation.
 	 */
-	raw_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
+	raw_cpu_write(watchdog_report_ts, SOFTLOCKUP_DELAY_REPORT);
 }
 
 notrace void touch_softlockup_watchdog(void)
@@ -279,23 +292,23 @@ void touch_all_softlockup_watchdogs(void
 	 * the softlockup check.
 	 */
 	for_each_cpu(cpu, &watchdog_allowed_mask)
-		per_cpu(watchdog_touch_ts, cpu) = SOFTLOCKUP_RESET;
+		per_cpu(watchdog_report_ts, cpu) = SOFTLOCKUP_DELAY_REPORT;
 	wq_watchdog_touch(-1);
 }
 
 void touch_softlockup_watchdog_sync(void)
 {
 	__this_cpu_write(softlockup_touch_sync, true);
-	__this_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
+	__this_cpu_write(watchdog_report_ts, SOFTLOCKUP_DELAY_REPORT);
 }
 
-static int is_softlockup(unsigned long touch_ts)
+static int is_softlockup(unsigned long touch_ts, unsigned long period_ts)
 {
 	unsigned long now = get_timestamp();
 
 	if ((watchdog_enabled & SOFT_WATCHDOG_ENABLED) && watchdog_thresh){
 		/* Warn about unreasonable delays. */
-		if (time_after(now, touch_ts + get_softlockup_thresh()))
+		if (time_after(now, period_ts + get_softlockup_thresh()))
 			return now - touch_ts;
 	}
 	return 0;
@@ -341,6 +354,7 @@ static int softlockup_fn(void *data)
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
 	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
+	unsigned long period_ts = __this_cpu_read(watchdog_report_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
@@ -362,7 +376,8 @@ static enum hrtimer_restart watchdog_tim
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
-	if (touch_ts == SOFTLOCKUP_RESET) {
+	/* Reset the interval when touched externally by a known slow code. */
+	if (period_ts == SOFTLOCKUP_DELAY_REPORT) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
 			 * If the time stamp was touched atomically
@@ -374,7 +389,8 @@ static enum hrtimer_restart watchdog_tim
 
 		/* Clear the guest paused flag on watchdog reset */
 		kvm_check_and_clear_guest_paused();
-		update_touch_ts();
+		update_report_ts();
+
 		return HRTIMER_RESTART;
 	}
 
@@ -384,7 +400,7 @@ static enum hrtimer_restart watchdog_tim
 	 * indicate it is getting cpu time.  If it hasn't then
 	 * this is a good indication some task is hogging the cpu
 	 */
-	duration = is_softlockup(touch_ts);
+	duration = is_softlockup(touch_ts, period_ts);
 	if (unlikely(duration)) {
 		/*
 		 * If a virtual machine is stopped by the host it can look to
@@ -410,7 +426,7 @@ static enum hrtimer_restart watchdog_tim
 		}
 
 		/* Start period for the next softlockup warning. */
-		update_touch_ts();
+		update_report_ts();
 
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
_

Patches currently in -mm which might be from pmladek@suse.com are

watchdog-rename-__touch_watchdog-to-a-better-descriptive-name.patch
watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch
watchdog-softlockup-report-the-overall-time-of-softlockups.patch
watchdog-softlockup-remove-logic-that-tried-to-prevent-repeated-reports.patch
watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch
watchdog-cleanup-handling-of-false-positives.patch

