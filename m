Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-29.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC48C4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 00:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBBB823B99
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 00:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgLSA3T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 19:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgLSA3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2020 19:29:18 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A16C0617B0
        for <mm-commits@vger.kernel.org>; Fri, 18 Dec 2020 16:28:37 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v14so4121745wml.1
        for <mm-commits@vger.kernel.org>; Fri, 18 Dec 2020 16:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=idOcayvZksV8U9XCkPXoBwAbfu6Q/k3dr1NuKGPl0FQ=;
        b=LMXgkxMcyFiYw5VwE6tsFvPFenA6vMJB0NCHDoiJHDMFLB27ZcoVJPD4tzkwM9PB1P
         YVxqXHRcBjMvJ+4jPEobot+kpCaEEk/z0heioCe1cY8EN5J4sqPClvdhJIv9Qk8f4mnG
         d6T2wzeqnlLhl2y+Ql/8Mt5RZKvsmc8NiIKHCbmhPAWmLgX2sbSIp2qwwP6Y0GIS8fER
         xbk3X6tAZeNHYbV2ehgMux3Ps1+uISYrn0LwF2a4t+zv3Rgn8vFvXoa9vmAMEj2/WhwR
         QCaG5FVewt1IEAJ3zwDsXBhaKyA7W2sohAopGi/XB1UgJK/53l/p3fVRzYVbeFpx8e6F
         VP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=idOcayvZksV8U9XCkPXoBwAbfu6Q/k3dr1NuKGPl0FQ=;
        b=X1RBLARrzfRNuHMcF/na4mr6nPfhr2Ygp9WF+hL+e+8aAR2YjhldokmjvSaivWG8a4
         LOe500h29YsEHbnn0j23ZOnMt0RgZNFoWPy/iGFnCeCu9ti40PTKVXXNy0h+Ln8l+JeM
         AFekWvxkPMYoE9VU48cFqPjL6cpx1RaYrE84O794gB7fqBigkzRdJkYC0rXsvV0RmALj
         IZTYPXAenXMsPXPzZZHhyMJt/hWYiFR31/he+pHWsrUnm/OaEedhMLRQapdAFK5fpW+K
         FzgFpG1OeWFggerM31Vayuo6ZY2GQHD0dbUwIKU7OXfeCZAZqhG6imkCXQgEzqK0SIo8
         RwnA==
X-Gm-Message-State: AOAM533wmIFi4H408X4Cu2N2OYFg3vDPv6zaGCPrMhAYyemDUjalFeFB
        9XLpwNa8d74+1MGZZJFXVB6kMQ==
X-Google-Smtp-Source: ABdhPJy/PrE2fnMaQWHuWb+KOaOS+i/G7uK7Ln6KN/F+OtSatypi0da31FWV9HGIB93BbM5WjU6QtQ==
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr6274092wml.50.1608337716378;
        Fri, 18 Dec 2020 16:28:36 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
        by smtp.gmail.com with ESMTPSA id l8sm14201637wmf.35.2020.12.18.16.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 16:28:34 -0800 (PST)
Date:   Sat, 19 Dec 2020 01:28:29 +0100
From:   Marco Elver <elver@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, eugenis@google.com, glider@google.com,
        gor@linux.ibm.com, kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
Message-ID: <X91JLZhrXYaLzoB8@elver.google.com>
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218220233.pgX0nYYVt%akpm@linux-foundation.org>
User-Agent: Mutt/2.0.2 (2020-11-20)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Dec 18, 2020 at 02:02PM -0800, Andrew Morton wrote:
> From: Andrey Konovalov <andreyknvl@google.com>
> Subject: kasan: split out shadow.c from common.c
> 
> This is a preparatory commit for the upcoming addition of a new hardware
> tag-based (MTE-based) KASAN mode.
> 
> The new mode won't be using shadow memory.  Move all shadow-related code
> to shadow.c, which is only enabled for software KASAN modes that use
> shadow memory.
> 
> No functional changes for software modes.
> 
> Link: https://lkml.kernel.org/r/17d95cfa7d5cf9c4fcd9bf415f2a8dea911668df.1606161801.git.andreyknvl@google.com
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Reviewed-by: Marco Elver <elver@google.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Branislav Rankov <Branislav.Rankov@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Evgenii Stepanov <eugenis@google.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/kasan/Makefile |    6 
>  mm/kasan/common.c |  486 -----------------------------------------
>  mm/kasan/shadow.c |  518 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 523 insertions(+), 487 deletions(-)
> 
> --- a/mm/kasan/common.c~kasan-split-out-shadowc-from-commonc
> +++ a/mm/kasan/common.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * This file contains common generic and tag-based KASAN code.
> + * This file contains common KASAN code.
>   *
>   * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>   * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> @@ -13,7 +13,6 @@
>  #include <linux/init.h>
>  #include <linux/kasan.h>
>  #include <linux/kernel.h>
> -#include <linux/kmemleak.h>
>  #include <linux/linkage.h>
>  #include <linux/memblock.h>
>  #include <linux/memory.h>
> @@ -26,12 +25,8 @@
>  #include <linux/stacktrace.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
> -#include <linux/vmalloc.h>
>  #include <linux/bug.h>
>  
> -#include <asm/cacheflush.h>
> -#include <asm/tlbflush.h>
> -
>  #include "kasan.h"
>  #include "../slab.h"
>  
[...]
> -/*
> - * Poisons the shadow memory for 'size' bytes starting from 'addr'.
> - * Memory addresses should be aligned to KASAN_GRANULE_SIZE.
> - */
> -void poison_range(const void *address, size_t size, u8 value)
> -{
> -	void *shadow_start, *shadow_end;
> -
> -	/*
> -	 * Perform shadow offset calculation based on untagged address, as
> -	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
> -	 * addresses to this function.
> -	 */
> -	address = reset_tag(address);
> -

The moved lines do not mention kfence...
(The same commit in -next does.)

> -	shadow_start = kasan_mem_to_shadow(address);
> -	shadow_end = kasan_mem_to_shadow(address + size);
> -
> -	__memset(shadow_start, value, shadow_end - shadow_start);
> -}
[...]
> --- /dev/null
> +++ a/mm/kasan/shadow.c
> @@ -0,0 +1,518 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This file contains KASAN runtime code that manages shadow memory for
> + * generic and software tag-based KASAN modes.
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> + *
> + * Some code borrowed from https://github.com/xairy/kasan-prototype by
> + *        Andrey Konovalov <andreyknvl@gmail.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kasan.h>
> +#include <linux/kernel.h>
> +#include <linux/kfence.h>

This is the first time kfence is mentioned. Is this correct?

Is my assumption correct that the kasan changes and kfence changes are
to be swapped?

Thanks,
-- Marco
