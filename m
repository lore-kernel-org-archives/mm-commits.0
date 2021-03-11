Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EDCC4332B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58A764FA3
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhCKVWa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhCKVWI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:22:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 117DB64F98;
        Thu, 11 Mar 2021 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615497728;
        bh=bwGImc3p7Fn6gLflHrGKT89LUPZans+Z95wueI3uPso=;
        h=Date:From:To:Subject:From;
        b=asH2VsOTgiA3a28yevDu+yLiFubQHu2c+usBwg/s6Q7HfpcWxbLmZL3EQY1x91KZe
         nj2P5I9wHPh25s8oYxFVxuKQOfTYJfgRxNTJ6uH9sQpVSEEz5zAaYjnl7s0np7jPMT
         8t49TPlwer4STFQK2C+FOu/QDk/UviZljcDGca4g=
Date:   Thu, 11 Mar 2021 13:22:07 -0800
From:   akpm@linux-foundation.org
To:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject:  +
 watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch added to
 -mm tree
Message-ID: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: fix barriers when printing backtraces from all CPUs
has been added to the -mm tree.  Its filename is
     watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch

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
Subject: watchdog: fix barriers when printing backtraces from all CPUs

Any parallel softlockup reports are skipped when one CPU is already
printing backtraces from all CPUs.

The exclusive rights are synchronized using one bit in
soft_lockup_nmi_warn.  There is also one memory barrier that does not make
much sense.

Use two barriers on the right location to prevent mixing two reports.

Link: https://lkml.kernel.org/r/20210311122130.6788-6-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus
+++ a/kernel/watchdog.c
@@ -409,12 +409,18 @@ static enum hrtimer_restart watchdog_tim
 		if (kvm_check_and_clear_guest_paused())
 			return HRTIMER_RESTART;
 
+		/*
+		 * Prevent multiple soft-lockup reports if one cpu is already
+		 * engaged in dumping all cpu back traces.
+		 */
 		if (softlockup_all_cpu_backtrace) {
-			/* Prevent multiple soft-lockup reports if one cpu is already
-			 * engaged in dumping cpu back traces
-			 */
 			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
+			/*
+			 * Make sure that reports are serialized. Start
+			 * printing after getting the exclusive rights.
+			 */
+			smp_mb__after_atomic();
 		}
 
 		/* Start period for the next softlockup warning. */
@@ -431,14 +437,14 @@ static enum hrtimer_restart watchdog_tim
 			dump_stack();
 
 		if (softlockup_all_cpu_backtrace) {
-			/* Avoid generating two back traces for current
-			 * given that one is already made above
-			 */
 			trigger_allbutself_cpu_backtrace();
-
+			/*
+			 * Make sure that everything is printed before
+			 * another CPU is allowed to report lockup again.
+			 */
+			smp_mb__before_atomic();
+			/* Allow a further report. */
 			clear_bit(0, &soft_lockup_nmi_warn);
-			/* Barrier to sync with other cpus */
-			smp_mb__after_atomic();
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
_

Patches currently in -mm which might be from pmladek@suse.com are

watchdog-rename-__touch_watchdog-to-a-better-descriptive-name.patch
watchdog-explicitly-update-timestamp-when-reporting-softlockup.patch
watchdog-softlockup-report-the-overall-time-of-softlockups.patch
watchdog-softlockup-remove-logic-that-tried-to-prevent-repeated-reports.patch
watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch
watchdog-cleanup-handling-of-false-positives.patch

