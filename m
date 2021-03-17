Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D75BC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 09:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB9764F42
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 09:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCQJPC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:15:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:46724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhCQJO3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 05:14:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615972467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6DzbtkdTehSb8kglQ8YDBaz+nDj7PayBgDLEbSJj+a0=;
        b=ZqAXGMW0Jbv0pPKN0XpRizuCKwvG0dfth+6jR2bLsHZMOy9SrgpdrZTsPreflUWQlKtBrY
        Nt5e1Z2i7TlUe0DGvBOHpgjQ0nb15y+LU/00fZKa++mLR3G6ejK9U+Psg/+SV6OKulKssO
        Y21CzC3gwJKl7ihqcEcuSDxiiXdHC1o=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C0B7CAC1F;
        Wed, 17 Mar 2021 09:14:27 +0000 (UTC)
Date:   Wed, 17 Mar 2021 10:14:27 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org
Cc:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        vincent.whitchurch@axis.com
Subject: Re: +
 watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch added to
 -mm tree
Message-ID: <YFHIc+Q42bKcuWFY@alley>
References: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
 <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue 2021-03-16 12:48:45, Peter Zijlstra wrote:
> On Thu, Mar 11, 2021 at 01:22:07PM -0800, akpm@linux-foundation.org wrote:
> > --- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus
> > +++ a/kernel/watchdog.c
> > @@ -409,12 +409,18 @@ static enum hrtimer_restart watchdog_tim
> >  		if (kvm_check_and_clear_guest_paused())
> >  			return HRTIMER_RESTART;
> >  
> > +		/*
> > +		 * Prevent multiple soft-lockup reports if one cpu is already
> > +		 * engaged in dumping all cpu back traces.
> > +		 */
> >  		if (softlockup_all_cpu_backtrace) {
> > -			/* Prevent multiple soft-lockup reports if one cpu is already
> > -			 * engaged in dumping cpu back traces
> > -			 */
> >  			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
> >  				return HRTIMER_RESTART;
> > +			/*
> > +			 * Make sure that reports are serialized. Start
> > +			 * printing after getting the exclusive rights.
> > +			 */
> > +			smp_mb__after_atomic();
> 
> test_and_set_bit() is a value returning atomic and therefore already
> implies a full smp_mb() on both ends.

Still learning.

> >  		}
> >  
> >  		/* Start period for the next softlockup warning. */
> > @@ -431,14 +437,14 @@ static enum hrtimer_restart watchdog_tim
> >  			dump_stack();
> >  
> >  		if (softlockup_all_cpu_backtrace) {
> > -			/* Avoid generating two back traces for current
> > -			 * given that one is already made above
> > -			 */
> >  			trigger_allbutself_cpu_backtrace();
> > -
> > +			/*
> > +			 * Make sure that everything is printed before
> > +			 * another CPU is allowed to report lockup again.
> > +			 */
> 
> This is not something smp_mb() ensures. smp_mb() is only concerned with
> memory access ordering, not completion, and certainly not some random
> IO.

> IOW, that comment is complete bollocks.

The problem is the comment.

trigger_allbutself_cpu_backtrace() waits until all the NMI handlers
confirm that they printed the backtrace. The generic implemetation
even does clear_bit_unlock(0, &backtrace_flag), see
nmi_trigger_cpumask_backtrace().

> > +			smp_mb__before_atomic();
> > +			/* Allow a further report. */
> >  			clear_bit(0, &soft_lockup_nmi_warn);
> 
> 
> That said, this looks like a test-and-set lock and clear_bit unlock like
> situation. In fact it doesn't seem to use anything other than bit0 of
> that word.

Exactly, they prevent mixing two reports. It consists of more pieces.
The simplified would code looks like:

		if (test_and_set_bit_lock())
			return;

		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",...)
		print_modules();
		print_irqtrace_events(current);
		if (regs)
			show_regs(regs);
		else
			dump_stack();

		trigger_allbutself_cpu_backtrace();

			clear_bit(0, &soft_lockup_nmi_warn);
			/* Barrier to sync with other cpus */
			smp_mb__after_atomic();
		}

		clear_bit_unlock().

> FWIW we have test_and_set_bit_lock() / clear_bit_unlock().

Thanks for hint. I am going to update the patch.

IMHO, the best solution would be to use test_and_set_bit_lock()
and remove the confusing comment.

Andrew, should I send the entire patchset or just fixup of this patch?

Best Regards,
Petr
