Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAB2C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EFD361445
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhD3FVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FVi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BB306121E;
        Fri, 30 Apr 2021 05:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760050;
        bh=qP09R2xnHMySgMcZA3etM6LdlZEJAp0kvhiLvUWzIG4=;
        h=Date:From:To:Subject:From;
        b=iQCu7nQVGpxN8qzVjWNZqioalGDLD2bQ9DWHeboza+UT/k5/ikiB96PeqSdj31OiN
         GJBdoPfVOtA3jmS67awCZ74ESzPG+DaD/X5mB/S7mVBJcY2iJU+bbtKdMxIKDD6pU0
         bkLev67EqYaXVCCHIEQaOGMv817NyWFcCKc4dtl0=
Date:   Thu, 29 Apr 2021 22:20:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com
Subject:  [folded-merged]
 watchdog-fix-barriers-when-printing-backtraces-from-all-cpus-fix.patch
 removed from -mm tree
Message-ID: <20210430052050.bcj_hb0CI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: use bit lock operations to prevent multiple soft-lockup reports
has been removed from the -mm tree.  Its filename was
     watchdog-fix-barriers-when-printing-backtraces-from-all-cpus-fix.patch

This patch was dropped because it was folded into watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: watchdog: use bit lock operations to prevent multiple soft-lockup reports

Use bit_lock operation to prevent multiple soft-lockups reports when one
CPU already triggered dumping backtraces from all CPUs.

It allows to remove the explicit memory barriers and misleading
comments.

Link: https://lkml.kernel.org/r/YFSVsLGVWMXTvlbk@alley
Signed-off-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus-fix
+++ a/kernel/watchdog.c
@@ -415,13 +415,8 @@ static enum hrtimer_restart watchdog_tim
 		 * engaged in dumping all cpu back traces.
 		 */
 		if (softlockup_all_cpu_backtrace) {
-			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
+			if (test_and_set_bit_lock(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
-			/*
-			 * Make sure that reports are serialized. Start
-			 * printing after getting the exclusive rights.
-			 */
-			smp_mb__after_atomic();
 		}
 
 		/* Start period for the next softlockup warning. */
@@ -439,13 +434,7 @@ static enum hrtimer_restart watchdog_tim
 
 		if (softlockup_all_cpu_backtrace) {
 			trigger_allbutself_cpu_backtrace();
-			/*
-			 * Make sure that everything is printed before
-			 * another CPU is allowed to report lockup again.
-			 */
-			smp_mb__before_atomic();
-			/* Allow a further report. */
-			clear_bit(0, &soft_lockup_nmi_warn);
+			clear_bit_unlock(0, &soft_lockup_nmi_warn);
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

