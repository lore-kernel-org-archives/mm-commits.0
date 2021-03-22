Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56ABC433DB
	for <mm-commits@archiver.kernel.org>; Mon, 22 Mar 2021 13:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 897536192E
	for <mm-commits@archiver.kernel.org>; Mon, 22 Mar 2021 13:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhCVNlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Mar 2021 09:41:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:58438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhCVNlU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 22 Mar 2021 09:41:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616420479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lV6hLYqwgDg9Ia5vDJMZukp4UJ1bK9fyQkcc+CdVY2o=;
        b=psAoxRhgNlWO44qUUhE0/3kajeUHMozDHmymTjtYG8q8bMhtgMihpzaruIpbSwprojdarX
        SpquiZfS/fjdrApWzcHNcZqRMwFyfjuJ/t2oUSd8PgTMvLtybvStePwenHc86WnzxFIoo5
        mU6yuHAHtX1xl24n0v/cLcJ4fXxYXRQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 860EFAC1F;
        Mon, 22 Mar 2021 13:41:19 +0000 (UTC)
Date:   Mon, 22 Mar 2021 14:41:18 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, loberman@redhat.com,
        mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        tglx@linutronix.de, vincent.whitchurch@axis.com
Subject: Re: [PATCH] watchdog: Use bit lock operations to prevent multiple
 soft-lockup reports
Message-ID: <YFiefr3Kb/gbpYiL@alley>
References: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
 <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
 <YFHIc+Q42bKcuWFY@alley>
 <YFSVsLGVWMXTvlbk@alley>
 <20210320093243.63d8ddfb36995edb9b339b51@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320093243.63d8ddfb36995edb9b339b51@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat 2021-03-20 09:32:43, Andrew Morton wrote:
> On Fri, 19 Mar 2021 13:14:40 +0100 Petr Mladek <pmladek@suse.com> wrote:
> 
> > this patch can be put on top of the patchset fixing/cleaning softlockup
> > watchdog code. Feel free to squash it into the other patch fixing
> > the barriers.
> > 
> > Or should I resend the entire patchset again, please?
> 
> That's OK - I'll queue this as a fix against "watchdog: fix barriers
> when printing backtraces from all CPUs".
> 
> However once the two patches are merged into one for upstreaming, the
> changelog doesn't seem to be fully correct and complete.  Please check
> and suggest a replacement if needed?  The joined patches presently 
> look like this:
> 
> From: Petr Mladek <pmladek@suse.com>
> Subject: watchdog: fix barriers when printing backtraces from all CPUs
> 
> Any parallel softlockup reports are skipped when one CPU is already
> printing backtraces from all CPUs.
> 
> The exclusive rights are synchronized using one bit in
> soft_lockup_nmi_warn.  There is also one memory barrier that does not make
> much sense.
> 
> Use two barriers on the right location to prevent mixing two reports.

Please, use the following:

<proposal>
Subject: watchdog: Clean up locking when printing backtraces from all CPUs

Any parallel softlockup reports are skipped when one CPU is already
printing backtraces from all CPUs.

The exclusive rights are synchronized using one bit in
soft_lockup_nmi_warn. There is one explicit barrier. The other
is implicitly provided by test_and_set_bit().

Use *_bit_lock() API to better express the intention. It provides
the needed barriers out of box.
</proposal>

Thanks a lot for taking care of it.

Best Regards,
Petr

> 
> Link: https://lkml.kernel.org/r/20210311122130.6788-6-pmladek@suse.com
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
> 
>  kernel/watchdog.c |   17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> --- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus
> +++ a/kernel/watchdog.c
> @@ -409,11 +409,12 @@ static enum hrtimer_restart watchdog_tim
>  		if (kvm_check_and_clear_guest_paused())
>  			return HRTIMER_RESTART;
>  
> +		/*
> +		 * Prevent multiple soft-lockup reports if one cpu is already
> +		 * engaged in dumping all cpu back traces.
> +		 */
>  		if (softlockup_all_cpu_backtrace) {
> -			/* Prevent multiple soft-lockup reports if one cpu is already
> -			 * engaged in dumping cpu back traces
> -			 */
> -			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
> +			if (test_and_set_bit_lock(0, &soft_lockup_nmi_warn))
>  				return HRTIMER_RESTART;
>  		}
>  
> @@ -431,14 +432,8 @@ static enum hrtimer_restart watchdog_tim
>  			dump_stack();
>  
>  		if (softlockup_all_cpu_backtrace) {
> -			/* Avoid generating two back traces for current
> -			 * given that one is already made above
> -			 */
>  			trigger_allbutself_cpu_backtrace();
> -
> -			clear_bit(0, &soft_lockup_nmi_warn);
> -			/* Barrier to sync with other cpus */
> -			smp_mb__after_atomic();
> +			clear_bit_unlock(0, &soft_lockup_nmi_warn);
>  		}
>  
>  		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
> _
> 
