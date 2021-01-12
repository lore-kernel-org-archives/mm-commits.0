Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCCAC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 22:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B54230FC
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 22:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438417AbhALWmd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 17:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438406AbhALWmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 17:42:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 236D1230FC;
        Tue, 12 Jan 2021 22:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610491312;
        bh=I0AFmIa3UnK/Jcz9FTKsaEckCk/F2Xw9lSaL3nbr97M=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=UG9UJ5BDh3sZHkF2fq3KEmtzmMkgJaqyon57/JiebbpLRtUKyRbgFdB2mc9wMoWAV
         Rl3ewuviNP34tvTP1ajnx2EG1QuY/BAvQt+QmGXpq/IhHfToJ52rLPKZm6QQ6pLOR4
         dUkMymZ4w+9aDxkSTSQkmCevl3qoNRcdw+yHKQvc=
Date:   Tue, 12 Jan 2021 14:41:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aryabinin@virtuozzo.com, dan.j.williams@intel.com,
        dvyukov@google.com, glider@google.com, lecopzer.chen@mediatek.com,
        lecopzer@gmail.com, mm-commits@vger.kernel.org
Subject: Re: +
 kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch added
 to -mm tree
Message-Id: <20210112144151.9293558d9f4cdf156d9edc39@linux-foundation.org>
In-Reply-To: <20210104212913.Dp2ZoxVB9%akpm@linux-foundation.org>
References: <20210104212913.Dp2ZoxVB9%akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 04 Jan 2021 13:29:13 -0800 akpm@linux-foundation.org wrote:

> 
> From: Lecopzer Chen <lecopzer@gmail.com>
> Subject: kasan: fix incorrect arguments passing in kasan_add_zero_shadow
> 
> kasan_remove_zero_shadow() shall use original virtual address, start and
> size, instead of shadow address.
> 
> Link: https://lkml.kernel.org/r/20210103063847.5963-1-lecopzer@gmail.com
> Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
> Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/kasan/init.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/mm/kasan/init.c~kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow
> +++ a/mm/kasan/init.c
> @@ -485,7 +485,6 @@ int kasan_add_zero_shadow(void *start, u
>  
>  	ret = kasan_populate_early_shadow(shadow_start, shadow_end);
>  	if (ret)
> -		kasan_remove_zero_shadow(shadow_start,
> -					size >> KASAN_SHADOW_SCALE_SHIFT);
> +		kasan_remove_zero_shadow(start, size);
>  	return ret;
>  }

Reviewer input on this one, please?
