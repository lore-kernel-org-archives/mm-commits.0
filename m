Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF95C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA66E61051
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhISWkS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 18:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhISWkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 18:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A62A760C51;
        Sun, 19 Sep 2021 22:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632091132;
        bh=Px1/uzdWWc/WISRxyxCTsxYyDxXrocgdJVqJRk/lc3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MIuCLUI4eFnt/ztDec18FBwHWSh8wTmwk7F7WhqhXOU5i0e3O/J0veT2GODyjzE/2
         PSrAxFX9P41f5JBg9if7ERv98WT0qn26wL0d/krUE8E2vq3HxTWECvkqk+cHOvvAEw
         X8X1Hu2Wu7ifizN3ZDzVWHzAFMogtMGjVYMiBsFk=
Date:   Sun, 19 Sep 2021 15:38:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     davem@davemloft.net, horms@verge.net.au, kuba@kernel.org,
        liumh1@shanghaitech.edu.cn, marcelo.leitner@gmail.com,
        mm-commits@vger.kernel.org, pshelar@ovn.org,
        ulf.hansson@linaro.org, vyasevich@gmail.com
Subject: Re: +
 include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch added
 to -mm tree
Message-Id: <20210919153850.6a4d71f155ea725e913e0450@linux-foundation.org>
In-Reply-To: <YUbPNoDr/YHNDy4l@casper.infradead.org>
References: <20210915033747.w8w89QJxl%akpm@linux-foundation.org>
        <YUbPNoDr/YHNDy4l@casper.infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 19 Sep 2021 06:48:38 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Sep 14, 2021 at 08:37:47PM -0700, akpm@linux-foundation.org wrote:
> > ------------------------------------------------------
> > From: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> > Subject: include/linux/mm.h: move nr_free_buffer_pages from swap.h to mm.h
> > 
> > nr_free_buffer_pages could be exposed through mm.h instead of swap.h.  The
> > advantage of this change is that it can reduce the obsolete includes.  For
> > example, net/ipv4/tcp.c wouldn't need swap.h any more since it has already
> > included mm.h.  Similarly, after checking all the other files, it comes
> > that tcp.c, udp.c meter.c ,...  follow the same rule, so these files can
> > have swap.h removed too.
> > 
> > Moreover, after preprocessing all the files that use nr_free_buffer_pages,
> > it turns out that those files have already included mm.h.Thus, we can move
> > nr_free_buffer_pages from swap.h to mm.h safely.  This change will not
> > affect the compilation of other files.
> 
> i don't think that moving more crap into mm.h is an improvement.
> if anything, we should be moving more things out of mm.h.

nr_free_buffer_pages() is part of the page allocation API and gfp.h
seems a more appropriate place for its declaration.

I expect this would also permit a reduction in the #include sprawl?
