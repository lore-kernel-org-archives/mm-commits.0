Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F8BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 17:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343545AbiEJRsh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 13:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241938AbiEJRsg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 13:48:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A028E4FF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A47EDB81CCA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 17:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A9DC385C2;
        Tue, 10 May 2022 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652204676;
        bh=D94GqGWw7bsDUEJFDyPQL79hdaweoVmi1XjXZqmOa/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PwuxHyuy/ZNGnGcqteMiVl2Lb0AxQAqa6Ml+tySdlX020fADWAYwTdgYwTzrnL+or
         kwhKU6xRqx+FWzjPQpevAA55h+HomT0enW0aK2tmxo60yIe6P1Bk1tZ85KF8yESXIO
         OEM0DE9PrbO0wWG6F8oCD1jGMKMkq3/me89LsH6M=
Date:   Tue, 10 May 2022 10:44:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, hch@lst.de
Subject: Re: +
 vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
 added to mm-unstable branch
Message-Id: <20220510104435.0235f730c112d59d66deaac6@linux-foundation.org>
In-Reply-To: <YnqJAGgV7S8b51fk@casper.infradead.org>
References: <20220506013250.B5929C385A8@smtp.kernel.org>
        <YnqJAGgV7S8b51fk@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 10 May 2022 16:47:12 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Thu, May 05, 2022 at 06:32:50PM -0700, Andrew Morton wrote:
> > +++ a/mm/vmscan.c
> > @@ -1598,40 +1598,42 @@ retry:
> >  			stat->nr_congested += nr_pages;
> >  
> >  		/*
> > -		 * If a page at the tail of the LRU is under writeback, there
> > +		 * If a folio at the tail of the LRU is under writeback, there
> >  		 * are three cases to consider.
> >  		 *
> > -		 * 1) If reclaim is encountering an excessive number of pages
> > -		 *    under writeback and this page is both under writeback and
> > -		 *    PageReclaim then it indicates that pages are being queued
> > -		 *    for IO but are being recycled through the LRU before the
> > -		 *    IO can complete. Waiting on the page itself risks an
> > -		 *    indefinite stall if it is impossible to writeback the
> > -		 *    page due to IO error or disconnected storage so instead
> > -		 *    note that the LRU is being scanned too quickly and the
> > -		 *    caller can stall after page list has been processed.
> > +		 * 1) If reclaim is encountering an excessive number of folios
> > +		 *    under writeback and this folio is both under
> > +		 *    writeback and has the reclaim flag set then it
> > +		 *    indicates that folios are being queued for I/O but
> > +		 *    are being recycled through the LRU before the I/O
> > +		 *    can complete. Waiting on the folio itself risks an
> > +		 *    indefinite stall if it is impossible to writeback
> > +		 *    the folio due to I/O error or disconnected storage
> > +		 *    so instead note that the LRU is being scanned too
> > +		 *    quickly and the caller can stall after the folio
> > +		 *    list has been processed.
> >  		 *
> 
> At some point between this email being sent and what's currently in
> linux-next, the above asterisk changed to a hash (* -> #).  You may
> or may not want to fix that.

I looked everywhere and cannot find this #?


