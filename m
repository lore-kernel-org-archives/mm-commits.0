Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036FCC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 12:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29F864F6B
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 12:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhCSMPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 08:15:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:57420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhCSMOm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 08:14:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616156081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TOK0Furp8lO02N30JjZn2Y1lnCVwhifBRH1q5aaypUQ=;
        b=P6jrj7IL6I1PwNNN1OIlrhPw2BZ+iQO1O32mRIFao+V7ww/+Yl/DbaBVwIIigIuMILj1pv
        lGy6TlXknSgN1AR50mc5k7UF0dEUqeWftNnAy/VUCX/0zXASfVxL286TZR0spceGGXm8m0
        fItgKxF8HtzATphsk4v+k89JCZlqOhg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2071AAE05;
        Fri, 19 Mar 2021 12:14:41 +0000 (UTC)
Date:   Fri, 19 Mar 2021 13:14:40 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org
Cc:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        vincent.whitchurch@axis.com
Subject: [PATCH] watchdog: Use bit lock operations to prevent multiple
 soft-lockup reports
Message-ID: <YFSVsLGVWMXTvlbk@alley>
References: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
 <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
 <YFHIc+Q42bKcuWFY@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFHIc+Q42bKcuWFY@alley>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Use bit_lock operation to prevent multiple soft-lockups reports when
one CPU already triggered dumping backtraces from all CPUs.

It allows to remove the explicit memory barriers and misleading
comments.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
---
Andrew,

this patch can be put on top of the patchset fixing/cleaning softlockup
watchdog code. Feel free to squash it into the other patch fixing
the barriers.

Or should I resend the entire patchset again, please?

Best Regards,
Petr

 kernel/watchdog.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c050323fcd33..090b6bc4de79 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -410,13 +410,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
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
@@ -434,13 +429,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 
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
-- 
2.26.2

