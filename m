Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3633C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 12:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E0D864E09
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 12:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCSMaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCSMaK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Mar 2021 08:30:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5644CC06174A
        for <mm-commits@vger.kernel.org>; Fri, 19 Mar 2021 05:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vePxZmNu/MjiLj/1FK7eIUdqsMhNs24YQhOK7ZDakmE=; b=sT6ybm/1IsEZvneqID/oiKFDxM
        hPdvWkTRXTABBDCgQ6kaqh1NYycilK5lYTZ7CbUMYFyYgwy/8psPc4jUNdbsYx8rkbhIocC6L6Yyp
        vx+uczmr2zJ5IgNrru9LMcezYA1exzThXsjHIsy2TUIIIHfWSYA3Ip+IikhyAP1G6zjGaQ9NWJHtO
        h1NCdzbrwJlWHJAH2H5VwIEIjxWf28dKVeaMjXwVvZf4Me0E6CWiAfaUcwp3IBTldmkGcv6QAHr9F
        Tb+YDS/1e+ax+1vXrIF9vnWuIlZmFmX30jVLtHhZsb6qXwa47QxfxBpQjmmGmR7U5ZvukcrDpSH6K
        m9TAIOuw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lNEFV-004Olj-Ts; Fri, 19 Mar 2021 12:29:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8840A30018A;
        Fri, 19 Mar 2021 13:29:05 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5EB1421244621; Fri, 19 Mar 2021 13:29:05 +0100 (CET)
Date:   Fri, 19 Mar 2021 13:29:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     akpm@linux-foundation.org, loberman@redhat.com, mhocko@suse.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de,
        vincent.whitchurch@axis.com
Subject: Re: [PATCH] watchdog: Use bit lock operations to prevent multiple
 soft-lockup reports
Message-ID: <YFSZEVty8oNeQfZI@hirez.programming.kicks-ass.net>
References: <20210311212207.2aUhwqqUh%akpm@linux-foundation.org>
 <YFCbHVcvyyGFFp7g@hirez.programming.kicks-ass.net>
 <YFHIc+Q42bKcuWFY@alley>
 <YFSVsLGVWMXTvlbk@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFSVsLGVWMXTvlbk@alley>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Mar 19, 2021 at 01:14:40PM +0100, Petr Mladek wrote:
> Use bit_lock operation to prevent multiple soft-lockups reports when
> one CPU already triggered dumping backtraces from all CPUs.
> 
> It allows to remove the explicit memory barriers and misleading
> comments.
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Thanks!

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
