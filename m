Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44FFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 20 May 2022 21:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiETVmF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 May 2022 17:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiETVmE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2022 17:42:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F4A62A15
        for <mm-commits@vger.kernel.org>; Fri, 20 May 2022 14:42:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d22so8355946plr.9
        for <mm-commits@vger.kernel.org>; Fri, 20 May 2022 14:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cejMs6XmRwWeLv2y/hw6SR+JYMFlZMVtyI44rl3KQx8=;
        b=WQUk9azBQMHfQecoUiWRD/sxImt3wYDRIl9cKuwRjqfwN9/HPB+8j+PEZyGGiTF6H/
         IN4kOfDGsWRCV+LFyv23zvgRwaVgITm2SRcDi7+rry844YpSZP5LXW0DzQAWQoU0nQF6
         EaP/sYo+Pv0GGGKiq8fqFVPx1+dBtoFuQBGn93iHdk5wOx9uxPGa3NKF5cLgchIqyITB
         hJy2EaMktTi0WJGwLyjZZbzxX76HL4Jp3ofLSRmO7tT12BHJ1cTd+oUNXftSmvZSgMYP
         uS/VFimddqPpjHV7ch62SL13fDn9mhCCYbhH3zlLbqvo4AtVXnsmKBQfcBs4BssemkfR
         BTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cejMs6XmRwWeLv2y/hw6SR+JYMFlZMVtyI44rl3KQx8=;
        b=vYNp2JbSX+bvnnHJgu2rjjj6o59eS+n4OJt1hQABMLOetO5C41K37ftl0Tx41bS27u
         TNr46qVN3m+bz8dRBF4vJ1GdmaBrhPXaUURtg/As9e2qBKV1S+j7Fxx0vecn2EznUO1A
         dPma/H0hqmGQQp6DFaSHAMGoAIU5UNSKpGRqwvyvKx0aHeoacEo6v0oQPH/HK2q3V7XU
         EyJpYwjDOZv2Ao11BS+F0ok9JrjYUFFNBlAmTASWphq98t1+C2hhNl/oOYpPAUsbAOek
         aGnSKg2LHT+mMJiL6xW2BL4N0+kSdL1cYiRJtDzREGYxLCy7IJljfQT53Vm+wC/8SkjD
         Qoxg==
X-Gm-Message-State: AOAM532413Fa48lCRfet6YUrqHYcLWe0gKNgWHgLzy5n6KC5mLpeS9Rj
        xDaHn5kma+QoBGa24F+X6m4=
X-Google-Smtp-Source: ABdhPJzYKFIJjN3dLdPA5L1NtEMX6ECQ6XdSLdZ2BdyZteLAwmyEmSvx+h6BrRFSavTDhk+jED+1Mw==
X-Received: by 2002:a17:902:e1cd:b0:161:61b6:9d96 with SMTP id t13-20020a170902e1cd00b0016161b69d96mr11606824pla.155.1653082923095;
        Fri, 20 May 2022 14:42:03 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:828d:ad52:eebc:6659])
        by smtp.gmail.com with ESMTPSA id y196-20020a62cecd000000b0050d4d156362sm2307594pfg.1.2022.05.20.14.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:42:02 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 20 May 2022 14:42:00 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        paulmck@kernel.org, joaodias@google.com, jhubbard@nvidia.com,
        david@redhat.com
Subject: Re: [alternative-merged]
 mm-fix-is_pinnable_page-against-on-cma-page.patch removed from -mm tree
Message-ID: <YogLKAuBnDfSJjwm@google.com>
References: <20220517194801.85817C385B8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517194801.85817C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 17, 2022 at 12:48:00PM -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: mm: fix is_pinnable_page against on cma page
> has been removed from the -mm tree.  Its filename was
>      mm-fix-is_pinnable_page-against-on-cma-page.patch
> 
> This patch was dropped because an alternative patch was merged

Hi Andrew,

I didn't see what an alternative patch was merged.

What I observed from last discussion[1] was that let's use
READ_ONCE in __get_pfnblock_flags_mask and remove READ_ONCE
in is_pinnable_page.

Please point me out if you merged other alternative. Otherwise,
I am happy to post new version based on the comment of [1]

Let me know. 

[1] https://lore.kernel.org/all/b6eef200-43d1-7913-21ed-176b05fcb4fe@nvidia.com/

> 
> ------------------------------------------------------
> From: Minchan Kim <minchan@kernel.org>
> Subject: mm: fix is_pinnable_page against on cma page
> 
> Pages on CMA area could have MIGRATE_ISOLATE as well as MIGRATE_CMA so
> current is_pinnable_page could miss CMA pages which has MIGRATE_ ISOLATE. 
> It ends up pinning CMA pages as longterm at pin_user_pages APIs so CMA
> allocation keep failed until the pin is released.
> 
>      CPU 0                                   CPU 1 - Task B
> 
> cma_alloc
> alloc_contig_range
>                                         pin_user_pages_fast(FOLL_LONGTERM)
> change pageblock as MIGRATE_ISOLATE
>                                         internal_get_user_pages_fast
>                                         lockless_pages_from_mm
>                                         gup_pte_range
>                                         try_grab_folio
>                                         is_pinnable_page
>                                           return true;
>                                         So, pinned the page successfully.
> page migration failure with pinned page
>                                         ..
>                                         .. After 30 sec
>                                         unpin_user_page(page)
> 
> CMA allocation succeeded after 30 sec.
> 
> The CMA allocation path protects the migration type change race using
> zone->lock but what GUP path need to know is just whether the page is on
> CMA area or not rather than exact migration type.  Thus, we don't need
> zone->lock but just checks migration type in either of (MIGRATE_ISOLATE
> and MIGRATE_CMA).
> 
> Adding the MIGRATE_ISOLATE check in is_pinnable_page could cause rejecting
> of pinning pages on MIGRATE_ISOLATE pageblocks even though it's neither
> CMA nor movable zone if the page is temporarily unmovable.  However, such
> a migration failure by unexpected temporal refcount holding is general
> issue, not only come from MIGRATE_ISOLATE and the MIGRATE_ISOLATE is also
> transient state like other temporal elevated refcount problem.
> 
> [akpm@linux-foundation.org: MIGRATE_CMA and MIGRATE_ISOLATE are not bitwise, per Minchan]
> [minchan@kernel.org: restore __mt definition]
> [minchan@kernel.org: changes per Paul and John]
>   Link: https://lkml.kernel.org/r/20220512204143.3961150-1-minchan@kernel.org
> Link: https://lkml.kernel.org/r/20220510211743.95831-1-minchan@kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Paul E . McKenney" <paulmck@kernel.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: John Dias <joaodias@google.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/mm.h |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page
> +++ a/include/linux/mm.h
> @@ -1625,8 +1625,21 @@ static inline bool page_needs_cow_for_dm
>  #ifdef CONFIG_MIGRATION
>  static inline bool is_pinnable_page(struct page *page)
>  {
> -	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
> -		is_zero_pfn(page_to_pfn(page));
> +#ifdef CONFIG_CMA
> +	/*
> +	 * Defend against future compiler LTO features, or code refactoring
> +	 * that inlines the above function, by forcing a single read. Because,
> +	 * this routine races with set_pageblock_migratetype(), and we want to
> +	 * avoid reading zero, when actually one or the other flags was set.
> +	 */
> +	int __mt = get_pageblock_migratetype(page);
> +	int mt = __READ_ONCE(__mt);
> +
> +	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
> +		return false;
> +#endif
> +
> +	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
>  }
>  #else
>  static inline bool is_pinnable_page(struct page *page)
> _
> 
> Patches currently in -mm which might be from minchan@kernel.org are
> 
> mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch
> 
