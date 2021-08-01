Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B580BC4320A
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 05:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9074E6109F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 05:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhHAFcp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 01:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhHAFco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Aug 2021 01:32:44 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EA6C0613CF
        for <mm-commits@vger.kernel.org>; Sat, 31 Jul 2021 22:32:35 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r23so19329829lji.3
        for <mm-commits@vger.kernel.org>; Sat, 31 Jul 2021 22:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7J4wUyNX78qif2RKUFd3wsafpswn9+jydrAIq9BO51s=;
        b=WwFYADtaE9jNcoAEF8oYqB4AcklFthGbkFLFGQSQ1uKQPJgRQWwSxYkFjHLNSokU63
         1W76gDWWpbP1CaRSCmHCoz/ixwMMX+zQHrcZJmsCLI2BWu8XLt0zkrHBsSCcHlEL8wvv
         nUTIAoa5yAp5VFGZrnhiPO0af1366UVqrWQZVTRq6mF4y3b9VYsw71mEWEaFdiHFbDmY
         dj+d6oqsJfjIyzdYdw9B/g9X8FdLor4nzIlWm6VZVpYh61rJCOUZh0bHcW3Dx04OdaF+
         56uZFvff27zjqK9dNZ10SHPaLa9MDEWMumqFb/VL+jn4OQFzmqqcHq98pgRwUoKVgeat
         h4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7J4wUyNX78qif2RKUFd3wsafpswn9+jydrAIq9BO51s=;
        b=MvvDGOvC6WnpvMjRptfVjrC+jfCzJqEc92H3hcBSlIqDYiu2QhUgrawwDuBMQpycww
         78TEN8iTX839nRA8+fnWeyzUfGZawcHr/2UGTrKQZ/xXiRrV1cJcw29A3mRBVV0oon5x
         EUF3/QxodYHHQJslKpdlXchHwZUxVz91zJTLrDfIo47zPu0BUc7tym0tlpAskf69cSK9
         qQQKY2LsGZarWMTPGY5dhzZgkJKPUc3GVjhxiG5rPlHzX1E6Ey7y1NihLouRogueuc/S
         16oqBU3ZgD2glcRzGnHB8BziArSMYAGw+splUnWlQnuS95BmQTWmxbxIfFlPZfF0jqWH
         JY7Q==
X-Gm-Message-State: AOAM530OqfH/eP0cORfdnb8fIUnYZbnTIoQ4My+Q+ClW5q5I6Njid/lQ
        TI9JsfDDet+a6O6wxdJWJzwuRvQTsMJF6i/rgpQJhw==
X-Google-Smtp-Source: ABdhPJx487LYrQWlxhYEv7l56r+0t7kddFosW2G0L5cqyIm7I/q1xfrjFli9AHjU7lhgTbMg+OTKU6QU7Vth7M1qX1E=
X-Received: by 2002:a05:651c:906:: with SMTP id e6mr6932238ljq.160.1627795953826;
 Sat, 31 Jul 2021 22:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
 <20210729215350.SZC9InNuL%akpm@linux-foundation.org> <YQXMHnWRsmfzKK00@archlinux-ax161>
In-Reply-To: <YQXMHnWRsmfzKK00@archlinux-ax161>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sat, 31 Jul 2021 22:32:22 -0700
Message-ID: <CALvZod6_uOVSp83mrjuQRqoRhdzfaV_sNfYNppVHMNhuHpR1oA@mail.gmail.com>
Subject: Re: [patch 6/7] slub: fix unreclaimable slab stat for bulk free
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Nathan,

On Sat, Jul 31, 2021 at 3:18 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Thu, Jul 29, 2021 at 02:53:50PM -0700, Andrew Morton wrote:
> > From: Shakeel Butt <shakeelb@google.com>
> > Subject: slub: fix unreclaimable slab stat for bulk free
> >
> > SLUB uses page allocator for higher order allocations and update
> > unreclaimable slab stat for such allocations.  At the moment, the bulk
> > free for SLUB does not share code with normal free code path for these
> > type of allocations and have missed the stat update.  So, fix the stat
> > update by common code.  The user visible impact of the bug is the
> > potential of inconsistent unreclaimable slab stat visible through meminfo
> > and vmstat.
> >
> > Link: https://lkml.kernel.org/r/20210728155354.3440560-1-shakeelb@google.com
> > Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Acked-by: Roman Gushchin <guro@fb.com>
> > Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  mm/slub.c |   22 ++++++++++++----------
> >  1 file changed, 12 insertions(+), 10 deletions(-)
> >
> > --- a/mm/slub.c~slub-fix-unreclaimable-slab-stat-for-bulk-free
> > +++ a/mm/slub.c
> > @@ -3236,6 +3236,16 @@ struct detached_freelist {
> >       struct kmem_cache *s;
> >  };
> >
> > +static inline void free_nonslab_page(struct page *page)
> > +{
> > +     unsigned int order = compound_order(page);
> > +
> > +     VM_BUG_ON_PAGE(!PageCompound(page), page);
> > +     kfree_hook(page_address(page));
> > +     mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
> > +     __free_pages(page, order);
> > +}
> > +
> >  /*
> >   * This function progressively scans the array with free objects (with
> >   * a limited look ahead) and extract objects belonging to the same
> > @@ -3272,9 +3282,7 @@ int build_detached_freelist(struct kmem_
> >       if (!s) {
> >               /* Handle kalloc'ed objects */
> >               if (unlikely(!PageSlab(page))) {
> > -                     BUG_ON(!PageCompound(page));
> > -                     kfree_hook(object);
> > -                     __free_pages(page, compound_order(page));
> > +                     free_nonslab_page(page);
> >                       p[size] = NULL; /* mark object processed */
> >                       return size;
> >               }
> > @@ -4250,13 +4258,7 @@ void kfree(const void *x)
> >
> >       page = virt_to_head_page(x);
> >       if (unlikely(!PageSlab(page))) {
> > -             unsigned int order = compound_order(page);
> > -
> > -             BUG_ON(!PageCompound(page));
> > -             kfree_hook(object);
> > -             mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
> > -                                   -(PAGE_SIZE << order));
> > -             __free_pages(page, order);
> > +             free_nonslab_page(page);
> >               return;
> >       }
> >       slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
> > _
>
> This patch, now in mainline as commit f227f0faf63b ("slub: fix
> unreclaimable slab stat for bulk free") causes the KASAN KUnit test
> kmalloc_pagealloc_invalid_free to no longer fail:
>
> [    0.000000] Linux version 5.14.0-rc3-00066-gf227f0faf63b (nathan@archlinux-ax161) (x86_64-linux-gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37) #1 SMP Sat Jul 31 15:08:11 MST 2021
> ...
> [    5.717678]     # kmalloc_pagealloc_invalid_free: EXPECTATION FAILED at lib/test_kasan.c:203
> [    5.717678]     KASAN failure expected in "kfree(ptr + 1)", but none occurred
> [    5.718909]     not ok 6 - kmalloc_pagealloc_invalid_free
> ...
> [    9.481520] not ok 1 - kasan
>
> The previous commit is fine:
>
> [    0.000000] Linux version 5.14.0-rc3-00065-gb5916c025432 (nathan@archlinux-ax161) (x86_64-linux-gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37) #1 SMP Sat Jul 31 15:05:09 MST 2021
> ...
> [    9.347598] ok 1 - kasan
>
> I am by no means a KASAN or mm/ expert, I noticed this when trying to
> test KASAN with clang for ClangBuiltLinux's CI, so it does not appear to
> be compiler dependent. It is reproducible for me in QEMU with
> x86_64_defconfig + CONFIG_KASAN=y + CONFIG_KUNIT=y +
> CONFIG_KASAN_KUNIT_TEST=y.
>
> Please let me know if there is any other information I can provide or
> testing I can do.
>

Thanks for the report. This is actually due to changing
kfree_hook(object) to kfree_hook(page_address(page)). The test forces
slub to go to the page allocator and then freeing with the next byte
address instead of the returned address. Since both are addresses on
the same page, the code is fine but the kasan test is not happy.

The test is making sure that programmers use the address returned by
kmalloc in the kfree. I don't think this is urgent but I will send the
patch to fix this during the week.

thanks,
Shakeel
