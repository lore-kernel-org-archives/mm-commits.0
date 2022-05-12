Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC74C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 21:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358707AbiELV2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 17:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343679AbiELV2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 17:28:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F201DE57D
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 14:28:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j14so6138519plx.3
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 14:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R6YC55yvG1FoH60PApU4i4PtJV15NOJHIrl/EzB9RvU=;
        b=EX8VKkwfjev2j5YSo3yCej/V3g0Z56GYXOiRkVjySictjbuLIcPvcTAV1BAO/M1qV2
         YMF4swUgFUjejwYO4JKPo97KAqm1UBFmrptm8UEtj68DTCjCOJcCm2vJzHGcB0UeexyN
         xAD2jV+cl/pAtiqIeUvKLJA22IbQvd8AYTeoMpoLnx1eZSD9A/jsdFnkxjDMnqQybVV5
         wQlI+t2aPKKDKDsS4loHfWc9dCez3/cQ1tgXaoMiATenEW646owbxfBsm0nKv0nZrt4I
         SY+hLJhNLobxyXwicT9FyZN+kRxFT1pRsknqiVinPX/m9Dk5ofaP+oSy1YldYfoMI4dc
         Vq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=R6YC55yvG1FoH60PApU4i4PtJV15NOJHIrl/EzB9RvU=;
        b=VJPE6me8SOuSo+sbHiEtYDoNsmh6V6RZ9XhtvikdiuFT0h8imAkBcdvmy2kiOEdg56
         wEdLIoyDdZp8zuuAu57m9dzTju892X7LhYtMMg5LJZiQnulcasvw4vAc51fv87roEFyI
         coMv1SORbi+JI8rpSY8gYXU0M2lHmjBulsHaFxNohP3t805eo+oqXNGuD8BHDbW6W2fy
         QwLGQcQLHnSk/50ziFNUjqAgGdvT5a0fmCismyQXVs4hZi/a3H81Xqg06bLvAkrzZXdp
         B9HsprTjRx5lz0S804guFd8c7WOlofUaJ3M5nO+6Sf35l+1t8loVKVA+JpeyeXhGaBQ7
         rBaw==
X-Gm-Message-State: AOAM531fTWFZzc3iIWAxKCB2mSoLwoSd5m2F3Jqpg4oE5NXRsRneR8Y3
        PZy2FxWxb4IwxHVzCSJ1Dzc=
X-Google-Smtp-Source: ABdhPJzflqt7XF77Vi0vGbtdGPfa5/CkOFO7qXYdLdA+/QGte6urDw2JwWFvuusZQShc0VmJ+EK5hw==
X-Received: by 2002:a17:902:d707:b0:15f:42a:bc62 with SMTP id w7-20020a170902d70700b0015f042abc62mr1765693ply.98.1652390915459;
        Thu, 12 May 2022 14:28:35 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:872f:bbca:8e23:fae5])
        by smtp.gmail.com with ESMTPSA id x12-20020a62860c000000b0050dc7628198sm265396pfd.114.2022.05.12.14.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 14:28:35 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 12 May 2022 14:28:33 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        jhubbard@nvidia.com, david@redhat.com
Subject: Re: + mm-fix-is_pinnable_page-against-on-cma-page-v5.patch added to
 mm-unstable branch
Message-ID: <Yn18AfcH26Rtry+/@google.com>
References: <20220512204506.423D0C3411F@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512204506.423D0C3411F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 12, 2022 at 01:45:05PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-fix-is_pinnable_page-against-on-cma-page-v5.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-on-cma-page-v5.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Minchan Kim <minchan@kernel.org>
> Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5
> 
>   * clarification why we need READ_ONCE - Paul
>   * Add a comment about READ_ONCE - John
> 
> Link: https://lkml.kernel.org/r/20220512204143.3961150-1-minchan@kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> Cc: "Paul E . McKenney" <paulmck@kernel.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/mm.h |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> --- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-v5
> +++ a/include/linux/mm.h
> @@ -1627,13 +1627,14 @@ static inline bool is_pinnable_page(stru
>  {
>  #ifdef CONFIG_CMA
>  	/*
> -	 * use volatile to use local variable mt instead of
> -	 * refetching mt value.
> +	 * Defend against future compiler LTO features, or code refactoring
> +	 * that inlines the above function, by forcing a single read. Because,
> +	 * this routine races with set_pageblock_migratetype(), and we want to
> +	 * avoid reading zero, when actually one or the other flags was set.
>  	 */
> -	int __mt = get_pageblock_migratetype(page);

It makes build failure.

Could you pick this up instead?

https://lore.kernel.org/all/Yn10GkInyZNtqASa@google.com/

Sorry for confusing.
