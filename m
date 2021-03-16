Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D939C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 11:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FA065044
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 11:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhCPLtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Mar 2021 07:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbhCPLsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Mar 2021 07:48:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04638C06174A
        for <mm-commits@vger.kernel.org>; Tue, 16 Mar 2021 04:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3cdjixhNFYsXM24dcUTI3r7tn6t6VeSrcquoRg3lZRg=; b=FE0rKE9IypwkH/MRXh1mTy9O44
        vVhDmaPXVsia+kOTIZ/W5q6YRBB4Y9W7npWqpXdvmVekNoysar9SF9flIfZ8BX3n5/U9CQiSSNN0E
        ouKGIf0vB1J5+em1GigfkIri3EyIRat20eKi/2ArHNJnGFDDol3cDSiwqN3ldJlMwp03NJ3gH8YLv
        SskYMQ6Qeb3iV51Z4tzwrFAp2yad3YBEypC6nxxJLdQK2Ybf5JFJfoVvb1M9ZX4nGrhIuaa17nG1g
        /EvTfkqwE0MyH3IU7tJYvrzmfi4zVaGSshsYYr3EFvCKBwxXLOSlNFukc705FP8SERoemxswTMUW6
        gbgRcUCA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lM8Br-000cJw-Kz; Tue, 16 Mar 2021 11:48:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B9BE8301324;
        Tue, 16 Mar 2021 12:48:45 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 699B620435CE8; Tue, 16 Mar 2021 12:48:45 +0100 (CET)
Date:   Tue, 16 Mar 2021 12:48:45 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     akpm@linux-foundation.org
Cc:     loberman@redhat.com, mhocko@suse.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, pmladek@suse.com, tglx@linutronix.de,
        vincent.whitchurch@axis.com
Subject: Re: +
 watchdog-fix-barriers-when-printing-backtraces-from-all-cpus.patch added to
 -mm tree
Message-ID: <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
References: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Mar 11, 2021 at 01:22:07PM -0800, akpm@linux-foundation.org wrote:
> --- a/kernel/watchdog.c~watchdog-fix-barriers-when-printing-backtraces-from-all-cpus
> +++ a/kernel/watchdog.c
> @@ -409,12 +409,18 @@ static enum hrtimer_restart watchdog_tim
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
>  			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
>  				return HRTIMER_RESTART;
> +			/*
> +			 * Make sure that reports are serialized. Start
> +			 * printing after getting the exclusive rights.
> +			 */
> +			smp_mb__after_atomic();

test_and_set_bit() is a value returning atomic and therefore already
implies a full smp_mb() on both ends.

>  		}
>  
>  		/* Start period for the next softlockup warning. */
> @@ -431,14 +437,14 @@ static enum hrtimer_restart watchdog_tim
>  			dump_stack();
>  
>  		if (softlockup_all_cpu_backtrace) {
> -			/* Avoid generating two back traces for current
> -			 * given that one is already made above
> -			 */
>  			trigger_allbutself_cpu_backtrace();
> -
> +			/*
> +			 * Make sure that everything is printed before
> +			 * another CPU is allowed to report lockup again.
> +			 */

This is not something smp_mb() ensures. smp_mb() is only concerned with
memory access ordering, not completion, and certainly not some random
IO.

IOW, that comment is complete bollocks.

> +			smp_mb__before_atomic();
> +			/* Allow a further report. */
>  			clear_bit(0, &soft_lockup_nmi_warn);


That said, this looks like a test-and-set lock and clear_bit unlock like
situation. In fact it doesn't seem to use anything other than bit0 of
that word.

FWIW we have test_and_set_bit_lock() / clear_bit_unlock().
