Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A39C11F6B
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 05:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F096141E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 05:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhGBFuT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 01:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhGBFuS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 01:50:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8B2C061762;
        Thu,  1 Jul 2021 22:47:47 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ie21so4007604pjb.0;
        Thu, 01 Jul 2021 22:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2wK0sFMdIZyCO2WDDH+HS8h56bpuMmkc9e3XYE6mC5Q=;
        b=qnmeXfnHyTdcxzSWqkrnRdF2V//PUbXbCggyVQvBBlImgYwbIwgnUm6ym34I4xErv2
         6MGrB3Tkkm6p0KjJF9w3F82WPl/xLdcPBDWEOSf7XXYL1fGDtOf7VcYxIfdYA5fCvjLk
         QoFE+LYblZyAosZAA8iP3SbFkuEM7PwYh/B732Bx09daQx1XWvI/TGoXKtdzjXk9Ek/6
         2fYEFiur77q5gOOoOE0jypLYycPfkDk/9cWN5hANTuWWLf9Dd/4ffiDEMczborexJZD6
         roCtnk7h9y2yZ0czsJi1c8Z3o3kxvc+w93aY7sai88a70paIkVMLRmeuXDBYBs8cL+xw
         ZVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2wK0sFMdIZyCO2WDDH+HS8h56bpuMmkc9e3XYE6mC5Q=;
        b=HQEmUYix4lTb+dv+2jw0qqTiwXbpa4QDaa68+aS3doA8shHK5uwTelWY6NNJKj/cnM
         epYr15RugblGZSkqE0TPyHu2+yge8ewm3fyJrVDCIOdrhOrm3n4PLKkWq6uFep5JkD36
         ZkrPjsez7P7FFcuVIrPqCGfy8NRV2uLeScH9hCHJSwzMy6V7LYs4yBtrmTflhU9gLjcl
         ZrILjyTGyNM07iLjowv2zSvTUU0MYDjz+lX9JSvSbUMo5AF7EAZhwDy4GcSJX734GLWt
         QTzdz6WhKW54Cz2KLP9yTDLaOefZjNxLmCfmaN64IG+t4LPcmtTRLaJT0HlSVwCMSeCQ
         1a9A==
X-Gm-Message-State: AOAM533e+Hb7kxa0+wOKk/XWRtSCjq2ny3EHiondGUY3sFTilQeEc4CC
        jrCToba7Y6QYRrW2EYNmf+A=
X-Google-Smtp-Source: ABdhPJzx2qJnS6WY4yyozM0awsnrnn4p1AUviqTkpqPguXby+p7/335O/NkQcbUVuFQqnIn4jQAvLg==
X-Received: by 2002:a17:90a:7e13:: with SMTP id i19mr3237480pjl.23.1625204866789;
        Thu, 01 Jul 2021 22:47:46 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:e476:fcd4:d1bf:22a2])
        by smtp.gmail.com with ESMTPSA id s31sm1915055pfg.191.2021.07.01.22.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 22:47:46 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 1 Jul 2021 22:47:44 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        torvalds@linux-foundation.org,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: Re: [patch 108/192] mm: zram: amend SLAB_RECLAIM_ACCOUNT on
 zspage_cachep
Message-ID: <YN6ogJbnI46hnjgk@google.com>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015258.BrxjIzdE1%akpm@linux-foundation.org>
 <YN3Xbdc9N81PIegK@google.com>
 <CAGWkznHWe22iwtBNtJfY75aS5_cfwKTaBfkX=zzmSaTwHZaAyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGWkznHWe22iwtBNtJfY75aS5_cfwKTaBfkX=zzmSaTwHZaAyQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 02, 2021 at 10:45:09AM +0800, Zhaoyang Huang wrote:
> On Thu, Jul 1, 2021 at 10:56 PM Minchan Kim <minchan@kernel.org> wrote:
> >
> > On Wed, Jun 30, 2021 at 06:52:58PM -0700, Andrew Morton wrote:
> > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
> > >
> > > Zspage_cachep is found be merged with other kmem cache during test, which
> > > is not good for debug things (zs_pool->zspage_cachep present to be another
> > > kmem cache in memory dumpfile).  It is also neccessary to do so as
> > > shrinker has been registered for zspage.
> > >
> > > Amending this flag can help kernel to calculate SLAB_RECLAIMBLE correctly.
> > >
> > > Link: https://lkml.kernel.org/r/1623137297-29685-1-git-send-email-huangzhaoyang@gmail.com
> > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > Cc: Minchan Kim <minchan@kernel.org>
> > > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >
> > Sorry for the late. I don't think this is correct.
> >
> > It's true "struct zspage" can be freed by zsmalloc's compaction registerred
> > by slab shrinker so tempted to make it SLAB_RECLAIM_ACCOUNT. However, it's
> > quite limited to work only when objects in the zspage are heavily fragmented.
> > Once the compaction is done, zspage are never discardable until objects are
> > fragmented again. It means it could hurt other reclaimable slab page reclaiming
> > since the zspage slab object pins the page.
> IMHO, kmem cache's reclaiming is NOT affected by SLAB_RECLAIM_ACCOUNT
> . This flag just affects kmem cache merge[1], the slab page's migrate
> type[2] and the page's statistics. Actually, zspage's cache DO merged
> with others even without SLAB_RECLAIM_ACCOUNT currently, which maybe
> cause zspage's object will NEVER be discarded.(SLAB_MERGE_SAME
> introduce confusions as people believe the cache will merge with
> others when it set and vice versa)
> 
> [1]
>  struct kmem_cache *find_mergeable(size_t size, size_t align, unsigned
> long flags, const char *name, void (*ctor)(void *))
> ...
>     if ((flags & SLAB_MERGE_SAME) != (s->flags & SLAB_MERGE_SAME))
>      continue;
> 
> [2]
> if (s->flags & SLAB_RECLAIM_ACCOUNT)
>     s->allocflags |= __GFP_RECLAIMABLE;

That's the point here. With SLAB_RECLAIM_ACCOUNT, page allocator
try to allocate pages from MIGRATE_RECLAIMABLE with belief those
objects are easily reclaimable. Say a page has object A, B, C, D
and E. A-D are easily reclaimable but E is hard. What happens is
VM couldn't reclaim the page in the end due to E even though it
already reclaimed A-D. And the such fragmenation could be spread
out entire MIGRATE_RECLAIMABLE pageblocks over time.
That's why I'd like to put zspage into MIGRATE_UNMOVALBE from the
beginning since I don't think it's easily reclaimble once compaction
is done.
