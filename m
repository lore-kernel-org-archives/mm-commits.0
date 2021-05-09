Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8F3C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 19:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BCBF6023C
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 19:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEITlr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 15:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhEITlq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 9 May 2021 15:41:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FD5C061573
        for <mm-commits@vger.kernel.org>; Sun,  9 May 2021 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xOmB/YchRcK/qsDYZe5ppZqxGiNZtOWSH9+LUL6fPJg=; b=HJjS0h92Sfk7cPS9WLCURlJssA
        uTON3a7sl2fCTC7bFektNVtZcttBLPer2KIx6FTorRNbgyL6b7CyM4UlEDkHu7kj2buDV5aJBrRN0
        qfI/HIc7WY1bbM3NlxL/3abjtiJoyUnRT3ereHR2Zdr3qSzqXccbdruZxLtS0cZBerWdMeEvCA1rC
        Ich11TyO4bH+GZLnLJ8aIJxTNpeBTTkTKeyH/6rywtJfZ3B7oXWHncrNO/7M0wVrPOuBrkQis1mFt
        VaMSgcrsov3zhjQ7wb6QwIqWSkJOqKtzcbuunaW4SpMbJwOUwyupu/YdoCXDhM7vdychH4s0RN95u
        maaoPo3A==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lfpHt-005NQn-Fz; Sun, 09 May 2021 19:40:30 +0000
Date:   Sun, 9 May 2021 20:40:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 041/178] mm: provide filemap_range_needs_writeback()
 helper
Message-ID: <YJg6qegqogOrJL2R@casper.infradead.org>
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
 <20210430055518.KCtlWixJr%akpm@linux-foundation.org>
 <CAHk-=wg_-EwefQ_3Osz4iJxTrTk3tfrV53Z7-jaGg=tm9i5TXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg_-EwefQ_3Osz4iJxTrTk3tfrV53Z7-jaGg=tm9i5TXg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 30, 2021 at 09:50:29AM -0700, Linus Torvalds wrote:
> Wait, what?
> 
> On Thu, Apr 29, 2021 at 10:55 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > +       if (!mapping_needs_writeback(mapping))
> > +               return false;
> > +       if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> > +           !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> > +               return false;
> > +       if (end_byte < start_byte)
> > +               return false;
> 
> Ok, good, get rid of the trivial cases first.
> 
> > +       rcu_read_lock();
> > +       xas_for_each(&xas, page, max) {
> > +               if (xas_retry(&xas, page))
> > +                       continue;
> > +               if (xa_is_value(page))
> > +                       continue;
> > +               if (PageDirty(page) || PageLocked(page) || PageWriteback(page))
> > +                       break;
> > +       }
> > +       rcu_read_unlock();
> 
> Whee. This looks very very expensive indeed.
> 
> Why is is going to each page, why does it care about locked when the
> simple early cases did not?

I was hoping Jens would answer this, but I guess he missed it so far.
I don't know why it now cares about whether the page is locked or not.
I presume it's not even the slightest bit slow for Jens because the
common case is that there are no pages in the range, and so we never
check any pages.

> Why isn't this just using xas_for_each_marked(), or maybe even just a
> single "xa_find()", since all it cares about is "is _any_ page.."

We don't have an iterator that looks for either mark A or mark B,
so we'd have to iterate twice, once to look for dirty and once to
look for writeback.  For the common case of there being no pages in
the range, that'd be slower.

I could add an iterator that returns the next entry in the given range
that has any mark set (almost trivial; OR the mark bitmaps together
before scanning them).  But I don't know why we care about the Locked
case, so I don't know if it'd be the right thing to do.

xa_find() isn't quite right because that'll return shadow entries, and
we do want to skip those.
