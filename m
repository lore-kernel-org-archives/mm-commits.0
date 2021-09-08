Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A236C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CC3611C1
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhIHTuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 15:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234047AbhIHTur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 15:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AFCF61164;
        Wed,  8 Sep 2021 19:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631130578;
        bh=4qFY3rIXWA5136WUsVpcDs4xV20GEs0OP48CeTJvLxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0uwng8BzxjhJsftzrjpvB5s8Jzfubkg1byvjgFjuWSxOrRCTuJivcgqjlT67BZXOd
         iVHXzxjHmdvUPF12ghQXQqXn8vzAq6B2tkBecvEgFR94OxJF3vFt1JnYY9eiEbnwzL
         GhxCFr+ZPCfFHMEwF/8COev50wwljiWre9WGpOqU=
Date:   Wed, 8 Sep 2021 12:49:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, aklimov@redhat.com,
        Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Zhou <dennis@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [patch 108/147] bitops: move find_bit_*_le functions from le.h
 to find.h
Message-Id: <20210908124937.bfa68a1428df07eb4e4c0597@linux-foundation.org>
In-Reply-To: <YTkRM/98mwL2GKns@yury-ThinkPad>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
        <20210908025901.gV9fu4cei%akpm@linux-foundation.org>
        <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
        <YTkRM/98mwL2GKns@yury-ThinkPad>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 8 Sep 2021 12:38:27 -0700 Yury Norov <yury.norov@gmail.com> wrote:

> On Wed, Sep 08, 2021 at 11:37:54AM -0700, Linus Torvalds wrote:
> > On Tue, Sep 7, 2021 at 7:59 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > From: Yury Norov <yury.norov@gmail.com>
> > > Subject: bitops: move find_bit_*_le functions from le.h to find.h
> > >
> > > It's convenient to have all find_bit declarations in one place.
> > 
> > What what what?
> > 
> > The subject line says "move".
> > 
> > The body of the commit message doesn't imply anything else.
> > 
> > But the patch doesn't "move" anything at all:
> > 
> > >  include/asm-generic/bitops/find.h |  193 ----------------------------
> > >  include/asm-generic/bitops/le.h   |   64 ---------
> > >  2 files changed, 257 deletions(-)
> > 
> > What's going on?
> > 
> > Dropped just because I refuse to have anything to do with patches that
> > lie about what they are actually doing.
> 
> This is how the patch looks in my tree:
> https://github.com/norov/linux/commit/4a92b733138e3fd71cd8a021ad53cbce68d61cfc
> 
> And in my submission:
> http://lkml.iu.edu/hypermail/linux/kernel/2108.1/07330.html
> 
> So it actually does what it says. The following patch in this series
> also differs from what I have in my tree. Something weird happened...

There were some competing changes in next for a while so I guess there
was damage.

> Andrew, Linus, are you OK if I resend the patchset?

Linus suggests other changes.  I suggest you get this tree into -next
as discussed and put the changes through another kernel cycle.

