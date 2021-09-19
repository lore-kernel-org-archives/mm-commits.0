Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472BCC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 222D1610F9
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 22:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhISXAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbhISW75 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Sep 2021 18:59:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F51C061574
        for <mm-commits@vger.kernel.org>; Sun, 19 Sep 2021 15:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=23XSx0+4g3S2BZg/YfCsMWQGHGfOq93QOgjTIs/M9vc=; b=N/4XTmVTiqtiH0f2XvO3vFPZqM
        bFQKpbBc2w/3NZL+npYMzM/rycTuxsk/HQWztQtV6GIDJ+qYYXlf+sNlxI/nzgsOlYEuPImN+dFZ+
        5keJ6Zq+ME71hesHO4IBiV7UyKhRLcV8pk1IZFox6wUrgSh5qF2eQYTGzK1jfmqSRbHHi8rtPTpxT
        QeLqELSNhBDk1dXrKHkiQCvVgib9ZWkpJn94ReJhyztZ2n3MJ7WYUktU3pggBe2BkzUqvFDQ/Akyq
        vxdNF78LWQDYdQCT5P+KnmbRJCfS7nkMkFn84G6ohxR5xyKIHpa+bWWQHTp4+sqals/b7K54QyG6O
        hRqTjrsA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mS5kD-002D6h-Oy; Sun, 19 Sep 2021 22:57:18 +0000
Date:   Sun, 19 Sep 2021 23:57:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     davem@davemloft.net, horms@verge.net.au, kuba@kernel.org,
        liumh1@shanghaitech.edu.cn, marcelo.leitner@gmail.com,
        mm-commits@vger.kernel.org, pshelar@ovn.org,
        ulf.hansson@linaro.org, vyasevich@gmail.com
Subject: Re: +
 include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch added to
 -mm tree
Message-ID: <YUfARSO6gOV45brm@casper.infradead.org>
References: <20210915033747.w8w89QJxl%akpm@linux-foundation.org>
 <YUbPNoDr/YHNDy4l@casper.infradead.org>
 <20210919153850.6a4d71f155ea725e913e0450@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919153850.6a4d71f155ea725e913e0450@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Sep 19, 2021 at 03:38:50PM -0700, Andrew Morton wrote:
> > i don't think that moving more crap into mm.h is an improvement.
> > if anything, we should be moving more things out of mm.h.
> 
> nr_free_buffer_pages() is part of the page allocation API and gfp.h
> seems a more appropriate place for its declaration.
> 
> I expect this would also permit a reduction in the #include sprawl?

It must ... mm.h includes gfp.h, so everything else about this patchset
should continue to work.  Maybe we could even remove mm.h from some files.
