Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A486C11F68
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 07:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E356137D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 07:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhGBHgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 03:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhGBHgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 03:36:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F6C061762;
        Fri,  2 Jul 2021 00:33:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id in17-20020a17090b4391b0290170ba0ec7fcso8274764pjb.4;
        Fri, 02 Jul 2021 00:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iFQeUZJpN/P8c4rNnw9ZStEGC/9J57e7oVfkc7jOXBw=;
        b=mJMs94qsqAKm0pzG+d/8ak5uPFgWva45kkIYnP5i9i11ynkExAicnsBOkuoIaMVVPq
         rqwpeeplbqDUYVThdtFU/WwAiaHtI6/hGyAuOXS9egERqDiQi8bziv0Zq3pNEotYU1AE
         /KD8IClawLyRgExTpQkDXSVDep7Nqu032aflrB8St3IR7/QH5wR75f0QW155eRcKYXgh
         3ar3esD3sC1KEClkMznsib3UqTjgJoy1sZTSGYiUiFFvG298cl+wR+C3iGRUTznYGrMZ
         YCqDk/Erp9mfk5XN/9uJ+u6lPAFcHWeUXhI8UMjeLSdOe1jb2sOoFN/eK2HQ+IN7RETu
         ffFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iFQeUZJpN/P8c4rNnw9ZStEGC/9J57e7oVfkc7jOXBw=;
        b=Ods9QtLLTGVgpQDmnbv7aFTsOS12EXIDHl7ivZKAK6CbwntneVms7t98n7sFehWq1p
         +zve9ImMC/XCZHMnCD08V6JkjCvrLSyav80UzkIJOCG+GYbCm2BNEPTB55myMkzkC2Nd
         FfckF3OthVHVWHyKDQdM//xhNpDsq2pyYPp0tos37CVQ4bIgm0fFgpBZrvYGGDAtp9D3
         ffi/6M/ZlZ6UkkTcznAFSRcFkwEOUzq4Nn4Xq7jI/C1ZisjJkpl6M0Zke5Ag6LKcxYGA
         Cn+oxMZeuWXuE3lcymj2HuJL34nmRseyBG8T6niI6d5LUmCWC3kEOpkodfNSpIUv8oEn
         CXaA==
X-Gm-Message-State: AOAM5318lS03NpkAr3qSVj780YWai7i67EChHHSJcDGBd1zXb6ZYEd8i
        /h7GBxARfDXB413orjC4WvA=
X-Google-Smtp-Source: ABdhPJzfbBfr0twKNwd1iNtaS41APSdZgzYtJq7ZlrpuaBqpD8i4yGmApJ4Nl/bhtwzQBmHnz014EQ==
X-Received: by 2002:a17:902:6e02:b029:128:977c:217d with SMTP id u2-20020a1709026e02b0290128977c217dmr1310954plk.44.1625211213156;
        Fri, 02 Jul 2021 00:33:33 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:e476:fcd4:d1bf:22a2])
        by smtp.gmail.com with ESMTPSA id 133sm2438670pfx.39.2021.07.02.00.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 00:33:32 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 2 Jul 2021 00:33:30 -0700
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
Message-ID: <YN7BSgvSJXzzbIBj@google.com>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015258.BrxjIzdE1%akpm@linux-foundation.org>
 <YN3Xbdc9N81PIegK@google.com>
 <CAGWkznHWe22iwtBNtJfY75aS5_cfwKTaBfkX=zzmSaTwHZaAyQ@mail.gmail.com>
 <YN6ogJbnI46hnjgk@google.com>
 <CAGWkznGaQyfxUuP8OJxvLapk4R8x3kpgU50H-xZfTiLO-i9WMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGWkznGaQyfxUuP8OJxvLapk4R8x3kpgU50H-xZfTiLO-i9WMg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 02, 2021 at 02:20:42PM +0800, Zhaoyang Huang wrote:
> On Fri, Jul 2, 2021 at 1:47 PM Minchan Kim <minchan@kernel.org> wrote:
> >
> > On Fri, Jul 02, 2021 at 10:45:09AM +0800, Zhaoyang Huang wrote:
> > > On Thu, Jul 1, 2021 at 10:56 PM Minchan Kim <minchan@kernel.org> wrote:
> > > >
> > > > On Wed, Jun 30, 2021 at 06:52:58PM -0700, Andrew Morton wrote:
> > > > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > > > Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
> > > > >
> > > > > Zspage_cachep is found be merged with other kmem cache during test, which
> > > > > is not good for debug things (zs_pool->zspage_cachep present to be another
> > > > > kmem cache in memory dumpfile).  It is also neccessary to do so as
> > > > > shrinker has been registered for zspage.
> > > > >
> > > > > Amending this flag can help kernel to calculate SLAB_RECLAIMBLE correctly.
> > > > >
> > > > > Link: https://lkml.kernel.org/r/1623137297-29685-1-git-send-email-huangzhaoyang@gmail.com
> > > > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > > > Cc: Minchan Kim <minchan@kernel.org>
> > > > > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > >
> > > > Sorry for the late. I don't think this is correct.
> > > >
> > > > It's true "struct zspage" can be freed by zsmalloc's compaction registerred
> > > > by slab shrinker so tempted to make it SLAB_RECLAIM_ACCOUNT. However, it's
> > > > quite limited to work only when objects in the zspage are heavily fragmented.
> > > > Once the compaction is done, zspage are never discardable until objects are
> > > > fragmented again. It means it could hurt other reclaimable slab page reclaiming
> > > > since the zspage slab object pins the page.
> > > IMHO, kmem cache's reclaiming is NOT affected by SLAB_RECLAIM_ACCOUNT
> > > . This flag just affects kmem cache merge[1], the slab page's migrate
> > > type[2] and the page's statistics. Actually, zspage's cache DO merged
> > > with others even without SLAB_RECLAIM_ACCOUNT currently, which maybe
> > > cause zspage's object will NEVER be discarded.(SLAB_MERGE_SAME
> > > introduce confusions as people believe the cache will merge with
> > > others when it set and vice versa)
> > >
> > > [1]
> > >  struct kmem_cache *find_mergeable(size_t size, size_t align, unsigned
> > > long flags, const char *name, void (*ctor)(void *))
> > > ...
> > >     if ((flags & SLAB_MERGE_SAME) != (s->flags & SLAB_MERGE_SAME))
> > >      continue;
> > >
> > > [2]
> > > if (s->flags & SLAB_RECLAIM_ACCOUNT)
> > >     s->allocflags |= __GFP_RECLAIMABLE;
> >
> > That's the point here. With SLAB_RECLAIM_ACCOUNT, page allocator
> > try to allocate pages from MIGRATE_RECLAIMABLE with belief those
> > objects are easily reclaimable. Say a page has object A, B, C, D
> > and E. A-D are easily reclaimable but E is hard. What happens is
> > VM couldn't reclaim the page in the end due to E even though it
> > already reclaimed A-D. And the such fragmenation could be spread
> > out entire MIGRATE_RECLAIMABLE pageblocks over time.
> > That's why I'd like to put zspage into MIGRATE_UNMOVALBE from the
> > beginning since I don't think it's easily reclaimble once compaction
> > is done.
> The slab page could fallback to any migrate type even allocating with

It's true but it couldn't be justication to allocate objects from any
migration type. We should try to select right type. Please see below.

> __GFP_RECLAIMABLE, and there is only one page per slab within zspage's
> cache, which will not be affected by compaction, so I think that
> doesn't make sense.

You shouldn't rely on how many pages the slab has since it's internal
implemenation and zspage size also could be changed in the future.
And please think about external fragmentaion as well as internal one.

What we want to try with allocation type is to group similar lifetime
objects together in a pageblock group to help external fragmentation
for high-order allocation. Think what happens if the unreclaimable
object is located in a reclaimable pageblock. The block couldn't be
merged into high-order page in the end so it causes more compaction
and smaller available high-order pages in the system.
