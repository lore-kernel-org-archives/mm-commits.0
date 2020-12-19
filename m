Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C905EC4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 18:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8730E2389F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 18:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgLSSBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 13:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbgLSSBv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 19 Dec 2020 13:01:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DB7C0613CF
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 10:01:11 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v1so3177568pjr.2
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 10:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+dkz6NPCxxT6JP7MgOe38b427lT6UXYd6e4otO5k2E=;
        b=ajNsIS4PvnV04i4mpoELf0ftd868lQwZqAa4gal46UsA/Ks/LRfYc31p2sqZk8eTeI
         hwv+1R0GQNkUfbIvTeP2fXxtFQ4fDWBEEUAMO815gYBsBuU/WFZYFJfTAN7PBHSwERy7
         2eqVn9HUtlOpmhvIBTYqDbfmdW6bEe4cY/DjYMljnmiTCrsrw1hw1siM/zc2RKG88kHc
         BkQxuSZ5c+8LmYuKG3/h7gCxRB7Nrwnl3g6ZqWm6GBY6a11R+KJZ/WKW/muGqq1ZedXI
         Hz9L0zWYlGAvDOyoaBsaEyaFayV70p4pplNq9blZsO50DBm62/NiA9TbpETFnDko+Vs+
         MXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+dkz6NPCxxT6JP7MgOe38b427lT6UXYd6e4otO5k2E=;
        b=ArXqvE3OgGRSeJjfL1ZahsZDRVzaLuv99lTC4D4HkuNTQ54s82BJFjnFYcct1UvDQV
         El1bcaOVll4bTfDoGWA8jq0V0m5pOw3ebzO1cM4a4UK/4ZxKsKHyISRU/8sUMxnOAQCS
         27zvETDO4y9PwgFBq5Fhukmi/EBrMGU10sJux1EH9QzK3ISkaB5ts95NgFLlYO/swF3I
         xPKOF4/0KKwHTUaHkoJOophPNQkmLeqLt7HRV3x3+OkVrqxx9Znc+mGuQCDg8sRfHNBE
         YRNxnM3oIMy7MfGphqOalA34KnqK+UR6KI5adt036eADblLayj/7MvbpDFc9lYEV6iyp
         sDVQ==
X-Gm-Message-State: AOAM533A1IRmnXajDqj0hi/dxWba72KoIGaxeBaEQgmRCXzfhLnZKdJc
        ic5vRegSeRP3dXbboqkSQVTdTf2VMCbrd5IAK0F6ag==
X-Google-Smtp-Source: ABdhPJxRsLqg8sh6pmkPMC6FL+JcOYKK6ZFk2C2eVc0NL+LL7JqhHS68S9tWZLjxXfDMRb0/TRpwKRt7ykU4eUbwgWE=
X-Received: by 2002:a17:902:c144:b029:dc:292e:a8a1 with SMTP id
 4-20020a170902c144b02900dc292ea8a1mr9443462plj.13.1608400870952; Sat, 19 Dec
 2020 10:01:10 -0800 (PST)
MIME-Version: 1.0
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org> <X91JLZhrXYaLzoB8@elver.google.com>
 <20201218171327.180140338d183b41a962742d@linux-foundation.org>
In-Reply-To: <20201218171327.180140338d183b41a962742d@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Sat, 19 Dec 2020 19:01:00 +0100
Message-ID: <CAAeHK+zMiGKPpyZbkEq0Ugm-Gf9TiA-gNP__16EovmV-AADLgQ@mail.gmail.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Marco Elver <elver@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Dec 19, 2020 at 2:13 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Sigh.  I don't have access to my capable-of-compiling-KASAN machine at
> present :(  We'll need this, yes?
>
> --- a/mm/kasan/kasan.h~a
> +++ a/mm/kasan/kasan.h
> @@ -3,7 +3,6 @@
>  #define __MM_KASAN_KASAN_H
>
>  #include <linux/kasan.h>
> -#include <linux/kfence.h>
>  #include <linux/stackdepot.h>
>
>  #ifdef CONFIG_KASAN_HW_TAGS
> @@ -305,20 +304,12 @@ static inline u8 random_tag(void) { retu
>
>  static inline void poison_range(const void *address, size_t size, u8 value)
>  {
> -       /* Skip KFENCE memory if called explicitly outside of sl*b. */
> -       if (is_kfence_address(address))
> -               return;
> -
>         hw_set_mem_tag_range(kasan_reset_tag(address),
>                         round_up(size, KASAN_GRANULE_SIZE), value);
>  }
>
>  static inline void unpoison_range(const void *address, size_t size)
>  {
> -       /* Skip KFENCE memory if called explicitly outside of sl*b. */
> -       if (is_kfence_address(address))
> -               return;
> -
>         hw_set_mem_tag_range(kasan_reset_tag(address),
>                         round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
>  }
> --- a/mm/kasan/shadow.c~a
> +++ a/mm/kasan/shadow.c
> @@ -13,7 +13,6 @@
>  #include <linux/init.h>
>  #include <linux/kasan.h>
>  #include <linux/kernel.h>
> -#include <linux/kfence.h>
>  #include <linux/kmemleak.h>
>  #include <linux/memory.h>
>  #include <linux/mm.h>
> @@ -85,10 +84,6 @@ void poison_range(const void *address, s
>         address = kasan_reset_tag(address);
>         size = round_up(size, KASAN_GRANULE_SIZE);
>
> -       /* Skip KFENCE memory if called explicitly outside of sl*b. */
> -       if (is_kfence_address(address))
> -               return;
> -
>         shadow_start = kasan_mem_to_shadow(address);
>         shadow_end = kasan_mem_to_shadow(address + size);
>
> @@ -106,14 +101,6 @@ void unpoison_range(const void *address,
>          */
>         address = kasan_reset_tag(address);
>
> -       /*
> -        * Skip KFENCE memory if called explicitly outside of sl*b. Also note
> -        * that calls to ksize(), where size is not a multiple of machine-word
> -        * size, would otherwise poison the invalid portion of the word.
> -        */
> -       if (is_kfence_address(address))
> -               return;
> -
>         poison_range(address, size, tag);
>
>         if (size & KASAN_GRANULE_MASK) {
> _
>

Yes, this should be it.

Thanks!
