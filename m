Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.0 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FC7C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFFB613BC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhGIXiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhGIXiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2021 19:38:15 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83467C0613DD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jul 2021 16:35:30 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id x192so17055741ybe.6
        for <mm-commits@vger.kernel.org>; Fri, 09 Jul 2021 16:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F0okWJOs/m5rIk+lqB/O7tPHyPCxVp7tXQW0BaZt/jo=;
        b=smADiH+Omq3zFhOp46Ep92zPeRRLcYElI58YoE0+ke9LCb8TqYFi8C3AxFveav7GQb
         vuJrzq8armlU0oce++KcBOmLrJ02+LNsyzr/IzXGIgO+iLNWXeaalB16mWHvmqFOrxtS
         0AzL/36XX4MX2Ycq1cV3tc3SH9xG0ajizF1Lzk5fIDytZGvR7PKqRHBMSfMYPYqV5LWd
         fJXwskLX/Dz2J0gqrR/Zfl+TM5FWyk4mikKXCplrGegFi9fB4Nyn7zhDb+8dHZl+EnoK
         X98kHFXBsZvUgkiOSEqTTmeZrICPBlu0aRKtVKLgpU/IThpdEdSg2PdJgKlz2r6DyeM2
         6+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F0okWJOs/m5rIk+lqB/O7tPHyPCxVp7tXQW0BaZt/jo=;
        b=dFQ+EsKmN3XLQpzq4M7vNMw2C6GiHRAPngL9H4tuspP31GzhZMoGpWVgYLOy4DsogJ
         uSxrJ8IRUORQU6uP0N/56Ah6cLA0P68RHk4eBNCSLS8dtG+yfYzQBCwnGzo4EQGo6cEr
         HJPVOe3qjJ+FWtXD8FkV1vGQsl0d8TH2OAYd8EFmbRYVuJ1TGldKdvGfHJpg/uSFwdkA
         UyFZLDDKvdGeFkBT3z9LshyOAPjy9/xnLM7GgFY/rL7ODy7zTBL98a1o+joHyPW6Ya7F
         gFhmlKqc3M94/d+rISFEYb4lVQDfr+tmjj/I7opSZHRmR6dx3tKlshiP6xmL/uxvSOyg
         W2cg==
X-Gm-Message-State: AOAM533zgV1m1xl0HBJUMRH+CDfk5WgdgTDtvm7DkvGNjiVGEs8VCEji
        0BSl8XIVrlplkOS02DobsPBG+g5OPeT3d1+TTaMdLXFByqMGcprd
X-Google-Smtp-Source: ABdhPJwApO7bz2G7aHcrjum+6hOc+QOOVjNDZaHxI9gf0OrKjwYef7rXrm0rj2hAd+HARUhpoE4MOrEcnQDaEkn9PV0=
X-Received: by 2002:a25:2341:: with SMTP id j62mr51886824ybj.190.1625873729527;
 Fri, 09 Jul 2021 16:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210709222253.W41zC%akpm@linux-foundation.org>
In-Reply-To: <20210709222253.W41zC%akpm@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 9 Jul 2021 16:35:18 -0700
Message-ID: <CAJuCfpG4JenxJX+-QpHBNkX=MY9hGhh1gTHp5z8vumeZNrCCdQ@mail.gmail.com>
Subject: Re: + mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 9, 2021 at 3:22 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
> has been added to the -mm tree.  Its filename is
>      mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch

Hi Andrew,
Please note that this patch is the second in the series of 3 here:
https://lore.kernel.org/patchwork/project/lkml/list/?series=507567 and
the only one that needed a v2 (others seem to be fine and are Ack'ed).
If you would like me to respin the whole series please let me know.
Otherwise please don't forget to pick up the other two patches from
this series.
Thanks,
Suren.

>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Suren Baghdasaryan <surenb@google.com>
> Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
>
> Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
> functions to perform mem_cgroup_disabled static key check inline before
> calling the main body of the function.  This minimizes the memcg overhead
> in the pagefault and exit_mmap paths when memcgs are disabled using
> cgroup_disable=memory command-line option.
>
> This change results in ~0.4% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> configurationon on an 8-core ARM64 Android device.
>
> Link: https://lkml.kernel.org/r/20210709171554.3494654-1-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/memcontrol.h |   28 +++++++++++++++++++++++++---
>  mm/memcontrol.c            |   29 ++++++++++-------------------
>  2 files changed, 35 insertions(+), 22 deletions(-)
>
> --- a/include/linux/memcontrol.h~mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config
> +++ a/include/linux/memcontrol.h
> @@ -693,13 +693,35 @@ static inline bool mem_cgroup_below_min(
>                 page_counter_read(&memcg->memory);
>  }
>
> -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> +int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +                       gfp_t gfp_mask);
> +static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +                                   gfp_t gfp_mask)
> +{
> +       if (mem_cgroup_disabled())
> +               return 0;
> +       return __mem_cgroup_charge(page, mm, gfp_mask);
> +}
> +
>  int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
>                                   gfp_t gfp, swp_entry_t entry);
>  void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
>
> -void mem_cgroup_uncharge(struct page *page);
> -void mem_cgroup_uncharge_list(struct list_head *page_list);
> +void __mem_cgroup_uncharge(struct page *page);
> +static inline void mem_cgroup_uncharge(struct page *page)
> +{
> +       if (mem_cgroup_disabled())
> +               return;
> +       __mem_cgroup_uncharge(page);
> +}
> +
> +void __mem_cgroup_uncharge_list(struct list_head *page_list);
> +static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
> +{
> +       if (mem_cgroup_disabled())
> +               return;
> +       __mem_cgroup_uncharge_list(page_list);
> +}
>
>  void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
>
> --- a/mm/memcontrol.c~mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config
> +++ a/mm/memcontrol.c
> @@ -6701,8 +6701,7 @@ void mem_cgroup_calculate_protection(str
>                         atomic_long_read(&parent->memory.children_low_usage)));
>  }
>
> -static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> -                              gfp_t gfp)
> +static int charge_memcg(struct page *page, struct mem_cgroup *memcg, gfp_t gfp)
>  {
>         unsigned int nr_pages = thp_nr_pages(page);
>         int ret;
> @@ -6723,7 +6722,7 @@ out:
>  }
>
>  /**
> - * mem_cgroup_charge - charge a newly allocated page to a cgroup
> + * __mem_cgroup_charge - charge a newly allocated page to a cgroup
>   * @page: page to charge
>   * @mm: mm context of the victim
>   * @gfp_mask: reclaim mode
> @@ -6736,16 +6735,14 @@ out:
>   *
>   * Returns 0 on success. Otherwise, an error code is returned.
>   */
> -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
> +int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> +                       gfp_t gfp_mask)
>  {
>         struct mem_cgroup *memcg;
>         int ret;
>
> -       if (mem_cgroup_disabled())
> -               return 0;
> -
>         memcg = get_mem_cgroup_from_mm(mm);
> -       ret = __mem_cgroup_charge(page, memcg, gfp_mask);
> +       ret = charge_memcg(page, memcg, gfp_mask);
>         css_put(&memcg->css);
>
>         return ret;
> @@ -6780,7 +6777,7 @@ int mem_cgroup_swapin_charge_page(struct
>                 memcg = get_mem_cgroup_from_mm(mm);
>         rcu_read_unlock();
>
> -       ret = __mem_cgroup_charge(page, memcg, gfp);
> +       ret = charge_memcg(page, memcg, gfp);
>
>         css_put(&memcg->css);
>         return ret;
> @@ -6916,18 +6913,15 @@ static void uncharge_page(struct page *p
>  }
>
>  /**
> - * mem_cgroup_uncharge - uncharge a page
> + * __mem_cgroup_uncharge - uncharge a page
>   * @page: page to uncharge
>   *
>   * Uncharge a page previously charged with mem_cgroup_charge().
>   */
> -void mem_cgroup_uncharge(struct page *page)
> +void __mem_cgroup_uncharge(struct page *page)
>  {
>         struct uncharge_gather ug;
>
> -       if (mem_cgroup_disabled())
> -               return;
> -
>         /* Don't touch page->lru of any random page, pre-check: */
>         if (!page_memcg(page))
>                 return;
> @@ -6938,20 +6932,17 @@ void mem_cgroup_uncharge(struct page *pa
>  }
>
>  /**
> - * mem_cgroup_uncharge_list - uncharge a list of page
> + * __mem_cgroup_uncharge_list - uncharge a list of page
>   * @page_list: list of pages to uncharge
>   *
>   * Uncharge a list of pages previously charged with
>   * mem_cgroup_charge().
>   */
> -void mem_cgroup_uncharge_list(struct list_head *page_list)
> +void __mem_cgroup_uncharge_list(struct list_head *page_list)
>  {
>         struct uncharge_gather ug;
>         struct page *page;
>
> -       if (mem_cgroup_disabled())
> -               return;
> -
>         uncharge_gather_clear(&ug);
>         list_for_each_entry(page, page_list, lru)
>                 uncharge_page(page, &ug);
> _
>
> Patches currently in -mm which might be from surenb@google.com are
>
> mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
>
