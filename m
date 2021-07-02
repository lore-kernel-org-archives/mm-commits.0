Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F3DC11F6A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 06:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145AD61416
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 06:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhGBGX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 02:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhGBGX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 02:23:27 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D756C061762;
        Thu,  1 Jul 2021 23:20:55 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id dj3so4178374qvb.11;
        Thu, 01 Jul 2021 23:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYWXH12CqnZMtZW0pOGnma+92SUvIYhPgYiicHyCps0=;
        b=pQwNRlKTGjy2M9pBSmsG0ces2zrOqUET4rUf+IEl0L7cNrn2VJv4Pz6h6LBQq/qszl
         9fIV2kKFNq1/p8cadqBFJS9bAVNN2MAW5csSy4ud9gcPd+MV+qgZBEb7Jhklbf5RtxGk
         IEcVOea8EflMh3hi74fxCd+Js2P2j+0YAHCcA3hER/ZtY39t/NYfQx81miuURjYoBXAq
         8Db2CXKtvbemUNRtQG2ZhmwVvHY5vLwf/pZhbyA/gYbHL6FyBxlIVIw21Yn8uyb+cUgC
         PtaeVkTK+F9ks2tNpRffQWQ2RI8cmnSGqWoDXFJvUJK3viyr1ygpb6BxMvazsccG1p0p
         IPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYWXH12CqnZMtZW0pOGnma+92SUvIYhPgYiicHyCps0=;
        b=XYsTdwZOSkwVT/1uujfy9Y2XSbHJNh6faYI59/DSA5O3j/9c4Wf9DJ27N0uGNc1/As
         bSX9fgJ2WqlNdaXaABTPB8H8rjxzPjd/DcykWwm9gszEGO0QmP00RVBGhHWPwzaHX15p
         JV7EZ17KZyBqaXNTZYM7hURJj7D/rJU2TMf8rdD7rExSUYP4pdNZxvo5rJV4Xyx0OB9U
         +sFy79u8TzTBQXy773zMgvb3rN9vq6P7S0bEl8B/KcekAe2gLMONGKxwbzgknipNfe/2
         qkr9I57VcKG2F/nFpxAq8wbaa0WesDp4lHtUfjHtXJPxMpXaSnc2Hds4hLUWiRJx4P6m
         A6vg==
X-Gm-Message-State: AOAM531E9u/T8hk/SHVJ1UfhQRMgvf/NKYxl+B+3ahu4ZkovPNP9UPY/
        cS4FDiMXMBy7xUc5lr8ttL5axNH4Eh7KfROscfs=
X-Google-Smtp-Source: ABdhPJyWdolrUsVPXoxZQ8ujjBZfyvsIfNOIUdm2Vus8RIEkG9WhT2mnr8LlKu3AUn45rS7CCoMmr1t4VDIBdj/4nQY=
X-Received: by 2002:a05:6214:1244:: with SMTP id q4mr3424052qvv.50.1625206854038;
 Thu, 01 Jul 2021 23:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015258.BrxjIzdE1%akpm@linux-foundation.org> <YN3Xbdc9N81PIegK@google.com>
 <CAGWkznHWe22iwtBNtJfY75aS5_cfwKTaBfkX=zzmSaTwHZaAyQ@mail.gmail.com> <YN6ogJbnI46hnjgk@google.com>
In-Reply-To: <YN6ogJbnI46hnjgk@google.com>
From:   Zhaoyang Huang <huangzhaoyang@gmail.com>
Date:   Fri, 2 Jul 2021 14:20:42 +0800
Message-ID: <CAGWkznGaQyfxUuP8OJxvLapk4R8x3kpgU50H-xZfTiLO-i9WMg@mail.gmail.com>
Subject: Re: [patch 108/192] mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
To:     Minchan Kim <minchan@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        torvalds@linux-foundation.org,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 2, 2021 at 1:47 PM Minchan Kim <minchan@kernel.org> wrote:
>
> On Fri, Jul 02, 2021 at 10:45:09AM +0800, Zhaoyang Huang wrote:
> > On Thu, Jul 1, 2021 at 10:56 PM Minchan Kim <minchan@kernel.org> wrote:
> > >
> > > On Wed, Jun 30, 2021 at 06:52:58PM -0700, Andrew Morton wrote:
> > > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > > Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
> > > >
> > > > Zspage_cachep is found be merged with other kmem cache during test, which
> > > > is not good for debug things (zs_pool->zspage_cachep present to be another
> > > > kmem cache in memory dumpfile).  It is also neccessary to do so as
> > > > shrinker has been registered for zspage.
> > > >
> > > > Amending this flag can help kernel to calculate SLAB_RECLAIMBLE correctly.
> > > >
> > > > Link: https://lkml.kernel.org/r/1623137297-29685-1-git-send-email-huangzhaoyang@gmail.com
> > > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > > Cc: Minchan Kim <minchan@kernel.org>
> > > > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >
> > > Sorry for the late. I don't think this is correct.
> > >
> > > It's true "struct zspage" can be freed by zsmalloc's compaction registerred
> > > by slab shrinker so tempted to make it SLAB_RECLAIM_ACCOUNT. However, it's
> > > quite limited to work only when objects in the zspage are heavily fragmented.
> > > Once the compaction is done, zspage are never discardable until objects are
> > > fragmented again. It means it could hurt other reclaimable slab page reclaiming
> > > since the zspage slab object pins the page.
> > IMHO, kmem cache's reclaiming is NOT affected by SLAB_RECLAIM_ACCOUNT
> > . This flag just affects kmem cache merge[1], the slab page's migrate
> > type[2] and the page's statistics. Actually, zspage's cache DO merged
> > with others even without SLAB_RECLAIM_ACCOUNT currently, which maybe
> > cause zspage's object will NEVER be discarded.(SLAB_MERGE_SAME
> > introduce confusions as people believe the cache will merge with
> > others when it set and vice versa)
> >
> > [1]
> >  struct kmem_cache *find_mergeable(size_t size, size_t align, unsigned
> > long flags, const char *name, void (*ctor)(void *))
> > ...
> >     if ((flags & SLAB_MERGE_SAME) != (s->flags & SLAB_MERGE_SAME))
> >      continue;
> >
> > [2]
> > if (s->flags & SLAB_RECLAIM_ACCOUNT)
> >     s->allocflags |= __GFP_RECLAIMABLE;
>
> That's the point here. With SLAB_RECLAIM_ACCOUNT, page allocator
> try to allocate pages from MIGRATE_RECLAIMABLE with belief those
> objects are easily reclaimable. Say a page has object A, B, C, D
> and E. A-D are easily reclaimable but E is hard. What happens is
> VM couldn't reclaim the page in the end due to E even though it
> already reclaimed A-D. And the such fragmenation could be spread
> out entire MIGRATE_RECLAIMABLE pageblocks over time.
> That's why I'd like to put zspage into MIGRATE_UNMOVALBE from the
> beginning since I don't think it's easily reclaimble once compaction
> is done.
The slab page could fallback to any migrate type even allocating with
__GFP_RECLAIMABLE, and there is only one page per slab within zspage's
cache, which will not be affected by compaction, so I think that
doesn't make sense.
