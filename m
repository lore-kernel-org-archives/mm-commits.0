Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5DFC11F67
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 02:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DEF861410
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 02:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhGBCry (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 22:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhGBCry (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 22:47:54 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A9AC061762;
        Thu,  1 Jul 2021 19:45:22 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id n9so5665508qtk.7;
        Thu, 01 Jul 2021 19:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOfujZpJs5bJ1Y1hAIj12f3/unKCESff8MCkIvriXAI=;
        b=RuVx54sI98pLBf6DbcXjoYQW0a+GwzvuRYR21hRtFGPJglZ19aPxpKxoOrHg1d3cAM
         uqXjy9ZYC6IHD3usEhZczLcAeVvEQUJBaAb5b9t9dU6jIzN59rjjDIrnV9NTG18Dlin4
         2/hhgdVOYOsQfBnMaE5R/+Lpl4F5kW6AueKCisQ+MlhyVk17pgVevMuWkLhkDz2hmT7E
         82/o3nGdd7ujb+1DVpa84CJIHZ7+sO+7zVUPyiJ4dNsvv3cNIxYerKjE/A63obmxrgeG
         WbeYQENN6ywD3agFrj8KUBdVEdx7j/KD77WkLIbcg2QYnEfjNUWY1mMsPhdazacWQ8Qt
         D9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOfujZpJs5bJ1Y1hAIj12f3/unKCESff8MCkIvriXAI=;
        b=VIYEk4Jn8vnAxUC7PbGaC+3XaK3DLPDD14Qm26n9bwzcgneg51wEkNGIoGUBh3adys
         Pc6jsv/mDFbzgBIhMFGdLR/1N1H7IppNKSHOenbSwMNCYtR2QBEtkFlC6KceweeeFUvJ
         GED6Ge7J1BwVjB4/3YXzyOWeQWlev6QHp9r3oDB9h1YZQ65MVvj/VHcOZ/LO2WrZJyIc
         /r4kgbw1Fr9TfP3U2a1IIzFxmvIKq5mOlPXHmn6TOfjkRnRZCTpnPCwbfcJFT6WBaYpO
         3n+0NV8UKlml9wizclFl6QjjXxsD3vvkymQVTE/HCB++DU7CoyRIF85V0F0VSwluB5ZY
         CwwA==
X-Gm-Message-State: AOAM532OWVKrTseOmvxt4xrC+rYQx6BYbs1uyjiygkVS3yUC3VhbBipE
        WTPeG7P7cBxfhlSvmcMtRk579GEjuCAplfS7MDvt16T5gm/0Xw==
X-Google-Smtp-Source: ABdhPJzdKeXp/hkdB4Tj1wmnRZ8Y/zfm9GHei1xljO4BcdhplePgiV9DKq4olHz57Z4XjRuIcC3fDAR94XTbF7UEqEw=
X-Received: by 2002:a05:622a:1451:: with SMTP id v17mr1720393qtx.286.1625193921736;
 Thu, 01 Jul 2021 19:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015258.BrxjIzdE1%akpm@linux-foundation.org> <YN3Xbdc9N81PIegK@google.com>
In-Reply-To: <YN3Xbdc9N81PIegK@google.com>
From:   Zhaoyang Huang <huangzhaoyang@gmail.com>
Date:   Fri, 2 Jul 2021 10:45:09 +0800
Message-ID: <CAGWkznHWe22iwtBNtJfY75aS5_cfwKTaBfkX=zzmSaTwHZaAyQ@mail.gmail.com>
Subject: Re: [patch 108/192] mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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

On Thu, Jul 1, 2021 at 10:56 PM Minchan Kim <minchan@kernel.org> wrote:
>
> On Wed, Jun 30, 2021 at 06:52:58PM -0700, Andrew Morton wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
> >
> > Zspage_cachep is found be merged with other kmem cache during test, which
> > is not good for debug things (zs_pool->zspage_cachep present to be another
> > kmem cache in memory dumpfile).  It is also neccessary to do so as
> > shrinker has been registered for zspage.
> >
> > Amending this flag can help kernel to calculate SLAB_RECLAIMBLE correctly.
> >
> > Link: https://lkml.kernel.org/r/1623137297-29685-1-git-send-email-huangzhaoyang@gmail.com
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> Sorry for the late. I don't think this is correct.
>
> It's true "struct zspage" can be freed by zsmalloc's compaction registerred
> by slab shrinker so tempted to make it SLAB_RECLAIM_ACCOUNT. However, it's
> quite limited to work only when objects in the zspage are heavily fragmented.
> Once the compaction is done, zspage are never discardable until objects are
> fragmented again. It means it could hurt other reclaimable slab page reclaiming
> since the zspage slab object pins the page.
IMHO, kmem cache's reclaiming is NOT affected by SLAB_RECLAIM_ACCOUNT
. This flag just affects kmem cache merge[1], the slab page's migrate
type[2] and the page's statistics. Actually, zspage's cache DO merged
with others even without SLAB_RECLAIM_ACCOUNT currently, which maybe
cause zspage's object will NEVER be discarded.(SLAB_MERGE_SAME
introduce confusions as people believe the cache will merge with
others when it set and vice versa)

[1]
 struct kmem_cache *find_mergeable(size_t size, size_t align, unsigned
long flags, const char *name, void (*ctor)(void *))
...
    if ((flags & SLAB_MERGE_SAME) != (s->flags & SLAB_MERGE_SAME))
     continue;

[2]
if (s->flags & SLAB_RECLAIM_ACCOUNT)
    s->allocflags |= __GFP_RECLAIMABLE;

>
> > ---
> >
> >  mm/zsmalloc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/mm/zsmalloc.c~mm-zram-amend-slab_reclaim_account-on-zspage_cachep
> > +++ a/mm/zsmalloc.c
> > @@ -328,7 +328,7 @@ static int create_cache(struct zs_pool *
> >               return 1;
> >
> >       pool->zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
> > -                                     0, 0, NULL);
> > +                                     0, SLAB_RECLAIM_ACCOUNT, NULL);
> >       if (!pool->zspage_cachep) {
> >               kmem_cache_destroy(pool->handle_cachep);
> >               pool->handle_cachep = NULL;
> > _
