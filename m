Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C087C6FA8F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Aug 2023 22:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjH2W6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Aug 2023 18:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240075AbjH2W5u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2023 18:57:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C2FE0;
        Tue, 29 Aug 2023 15:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KjVdVIFxJK1S0mlXVGX3XsEwRZAqqxvdeRlQviOkAiA=; b=qBliHH+2inoQylsLO5NF3FqY6Q
        NzmMybkdbfp5DkEOQ8pQViO23fosf8A/diCmRWy7HaHaWTZ+FM5JME5VmbpbEFi6dicYwF6lpjFeU
        SB6/ANBgraaj3wj54Df2triXfoThYizvQtc3ACCouUi8ukvqgb+R0Usg0bbkrDju+4emKFi1JPuUv
        saIy5V7buVQIGeJpxjlxj9fBPMbzV3vpyb+xHUOvvBu/tUYfwhyzJvMubnXLmyxneJ+WXeHwJVfeb
        vAjFGyGzKQL+xfxVsSQpITFpki3EeDpHAnOX2QVYI8Otd0QaeanQpku8ifFXoDZz4IvwSR1UiujjZ
        d90IkoXQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qb7eN-009FBY-V9; Tue, 29 Aug 2023 22:57:32 +0000
Date:   Tue, 29 Aug 2023 23:57:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Guo Ren <guoren@kernel.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.6-rc1
Message-ID: <ZO532zzLXSKvpvb0@casper.infradead.org>
References: <20230828184251.bfbc164280503903eacf498c@linux-foundation.org>
 <CAHk-=wjtBk23T4bsA4wxyogvDAP0mWmPPvy=qaMWsySM=WOC9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjtBk23T4bsA4wxyogvDAP0mWmPPvy=qaMWsySM=WOC9A@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Aug 29, 2023 at 02:31:38PM -0700, Linus Torvalds wrote:
> On Mon, 28 Aug 2023 at 18:43, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > csky tree, arch/csky/abiv2/cacheflush.c:
> > https://lkml.kernel.org/r/20230815104604.54f65293@canb.auug.org.au
> 
> At least this resolution in linux-next was wrong. It would just keep
> on doing a cache invalidate on the same one-page address range over
> and over again.
> 
> I think I did it right, but obviously can't test (and am too lazy to
> build-test too).
> 
> Of course, it won't actually matter unless you have large folio on
> csky, which is probably hard to impossible to trigger in practice, but
> I thought I'd mention it if for no other reason than Guo Ren to be
> aware and at least test-build and maybe think about it.

As far as I can tell, csky doesn't enable support for HUGETLBFS nor for
TRANSPARENT_HUGEPAGE and large folios are currently disabled unless you
have TRANSPARENT_HUGEPAGE, simply because they rely on infrastructure
that's only built for TRANSPARENT_HUGEPAGE.  We should probably fix that
at some point; allocating in larger chunks is beneficial even if you don't
have PMD sized TLB entries.  But the motivation to do that work has been
lacking; there are plenty of more important projects in the queue.
