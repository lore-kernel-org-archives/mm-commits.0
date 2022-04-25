Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13839C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiDYWYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343700AbiDYWOy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:14:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA4622B0B
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1583B61348
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484D8C385A4;
        Mon, 25 Apr 2022 22:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650924707;
        bh=SxqlkL+RS/Y6DfrxBDx7gKpFTTjcO4bZxXoM0JnWCFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U5VOSs+6SlHpJlvJAUYNV0uMnbVaRTI2ciViVfwK/D8IklcaCXKc8QIyhaBPOkmHr
         wa2ELW/74W/+9Gp9NxYsAq1iFROGtUHRprnsA1ng6VrCZBvpsx/6MmVFuI+ODqm32M
         SUrsTbVFOKOMrGpiu0xT0RmHnDQVePqTY6k6RMYo=
Date:   Mon, 25 Apr 2022 15:11:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mm-commits@vger.kernel.org, axboe@kernel.dk, chenwandun@huawei.com
Subject: Re: +
 mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch added to
 -mm tree
Message-Id: <20220425151146.f79ef6d19027b35d6aaeded6@linux-foundation.org>
In-Reply-To: <20220425083723.GB2731@worktop.programming.kicks-ass.net>
References: <20220422205413.C4DF4C385A0@smtp.kernel.org>
        <20220425083723.GB2731@worktop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 25 Apr 2022 10:37:23 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Apr 22, 2022 at 01:54:13PM -0700, Andrew Morton wrote:
> 
> > From: Chen Wandun <chenwandun@huawei.com>
> > Subject: mm: rework calculation of bdi_min_ratio in bdi_set_min_ratio
> > 
> > In function bdi_set_min_ratio, min_ratio is unsigned int, it will
> > result underflow when setting min_ratio below bdi->min_ratio, it
> > is confusing. Rework it, no functional change.
> > 
>
> ...
>
> > 
> > --- a/mm/page-writeback.c~mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio
> > +++ a/mm/page-writeback.c
> > @@ -650,18 +650,25 @@ static unsigned int bdi_min_ratio;
> >  
> >  int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
> >  {
> > +	unsigned int delta;
> >  	int ret = 0;
> >  
> >  	spin_lock_bh(&bdi_lock);
> >  	if (min_ratio > bdi->max_ratio) {
> >  		ret = -EINVAL;
> >  	} else {
> 
> > -		min_ratio -= bdi->min_ratio;
> > -		if (bdi_min_ratio + min_ratio < 100) {
> > -			bdi_min_ratio += min_ratio;
> > -			bdi->min_ratio += min_ratio;
> >  		} else {
> > -			ret = -EINVAL;
> 
> I really don't see the why we're doing this, code gets to be worse, for
> no actual gain.

Oh.  I found the resulting code to be considerably more understandable.
I mean, how does the old code work?  afaict it treats `unsigned
min_ratio' as a signed value(!) and relies upon an underflowed unsigned
to be a large number (> 100) when avoiding underflowing global
bdi_min_ratio.  Or something like that.  Also, modifying an incoming
arg's value is kinda rude.

And there's no change in the object file's .text size.

> > +		if (min_ratio < bdi->min_ratio) {
> > +			delta = bdi->min_ratio - min_ratio;
> > +			bdi_min_ratio -= delta;
> > +			bdi->min_ratio = min_ratio;
> >  		} else {
> > +			delta = min_ratio - bdi->min_ratio;
> > +			if (bdi_min_ratio + delta < 100) {
> > +				bdi_min_ratio += delta;
> > +				bdi->min_ratio = min_ratio;
> > +			} else {
> > +				ret = -EINVAL;
> > +			}
> >  		}
> 
> >  	}
