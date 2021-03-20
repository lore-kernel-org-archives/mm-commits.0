Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9E6C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 16:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D246194B
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 16:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCTQcx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Mar 2021 12:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhCTQcp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Mar 2021 12:32:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CC5D61944;
        Sat, 20 Mar 2021 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616257965;
        bh=lbdISAcfFVmX9aGQq/IleZyCL5Dye4KVeeEeB1PmQQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6OogETp0IzwsGR+80L+zMVBuRtpLJShe+knEAUuC1iZE3SEdGWPn+Z6fv5Wks3Pi
         JbIta/JdRrO6iJhoh8nYi8RDCcJZe7updmwI+PqCbdikUb4/XS3Aw39hbfRZ+6Qgcm
         v4hT++Uo5iF2BGh5MnADFJepCLwHcc0gU6YCbgD8=
Date:   Sat, 20 Mar 2021 09:32:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, loberman@redhat.com,
        mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject: Re: [PATCH] watchdog: Use bit lock operations to prevent multiple
 soft-lockup reports
Message-Id: <20210320093243.63d8ddfb36995edb9b339b51@linux-foundation.org>
In-Reply-To: <YFSVsLGVWMXTvlbk@alley>
References: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
        <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
        <YFHIc+Q42bKcuWFY@alley>
        <YFSVsLGVWMXTvlbk@alley>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 19 Mar 2021 13:14:40 +0100 Petr Mladek <pmladek@suse.com> wrote:

> this patch can be put on top of the patchset fixing/cleaning softlockup
> watchdog code. Feel free to squash it into the other patch fixing
> the barriers.
> 
> Or should I resend the entire patchset again, please?

That's OK - I'll queue this as a fix against "watchdog: fix barriers
when printing backtraces from all CPUs".

However once the two patches are merged into one for upstreaming, the
changelog doesn't seem to be fully correct and complete.  Please check
and suggest a replacement if needed?  The joined patches presently 
look like this:




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

 kernel/watchdog.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus
+++ a/kernel/watchdog.c
@@ -409,11 +409,12 @@ static enum hrtimer_restart watchdog_tim
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
-			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
+			if (test_and_set_bit_lock(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
 		}
 
@@ -431,14 +432,8 @@ static enum hrtimer_restart watchdog_tim
 			dump_stack();
 
 		if (softlockup_all_cpu_backtrace) {
-			/* Avoid generating two back traces for current
-			 * given that one is already made above
-			 */
 			trigger_allbutself_cpu_backtrace();
-
-			clear_bit(0, &soft_lockup_nmi_warn);
-			/* Barrier to sync with other cpus */
-			smp_mb__after_atomic();
+			clear_bit_unlock(0, &soft_lockup_nmi_warn);
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
_


