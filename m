Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83691C4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 10:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4600823B70
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 10:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgLSKMH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 05:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgLSKMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 19 Dec 2020 05:12:07 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2AFC0617B0
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 02:11:26 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id k9so1171856oop.6
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 02:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UqOGtZREbkb+fiwZN0Ug1TqVk+ihnvQV5sY7M/Qf/dY=;
        b=eXGl9Vze31Q7rp/XbgJJPxYc4cQUnJTwBwAncSxFKhjPdJHZfi+keOMvWbw9PzesuL
         ly+vEvHlLVr/WEIMx1WBvtmT9JTIkdEC+tls/ujaIvxzXBnevC/D49kx6PAA1hslw9vy
         qC2Rw8WM2D+Drv+9HbvgLmPe+mncjl0ikDaWu8Xrxc7eceBiehqoM118HYNJ9T1xf5pt
         x3Kr+4bBWQSHsV5djYTJBZM4gfQPtpdXTCtQF/iW1i82xjM+bdVhlhcWmUmK15Cq/bdY
         w2oGTNq4ruFv3V5P/f95PAg1GtiCpi48ONNTJiTyj4SLWlDaP21Lf5XL4WJoklkG5EXv
         j0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UqOGtZREbkb+fiwZN0Ug1TqVk+ihnvQV5sY7M/Qf/dY=;
        b=VLB1HxIBoYFnNShs0qpgNnLHC6DCFd3BVxygv5i9/pYpeIsN2T4faSOpJ8SSXkUQZM
         8qM/lL8+Q0UdesVDcv1BaceJ86SZVVjpErZUKjHAb+aZScgPdL0dMKaThEv+5b66shKV
         dHOkyZb0wIUjEpFBAMsCe7+9e6bl50PWRZtQg9FFj0ECtetHdHfwhdKClbnifWQwV8ON
         23YOkGegJAG4CCHmTzY72SKY4vuuEQP2uivG42uXHD6k32MbPjJx1qXaP8N9NGqrlaau
         +f8/RAkPj5vx4Fvg69vmj0ddvK9kUlAAEcd3zl48sKuzb/Iy21TfMfcf9n2Mb+ek4y4N
         ujeQ==
X-Gm-Message-State: AOAM532Ri5lknx85Wka5aGupd3PuMaOGNoKVwN1j1gaaOI0lvTkaFx4d
        P8Rm3xxGGFiyqW0WCY11V3Ulf5S7A34G62bMo7lL3Q==
X-Google-Smtp-Source: ABdhPJwm/rLRbkdTAvwinCTLENT0LvnkcguPk8K/Z3ZquF/0A6Y5AFoj1vx1Ie0yMHspNqrI1k+bJwvmslycMglrcB8=
X-Received: by 2002:a4a:a11a:: with SMTP id i26mr631929ool.54.1608372685934;
 Sat, 19 Dec 2020 02:11:25 -0800 (PST)
MIME-Version: 1.0
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org> <X91JLZhrXYaLzoB8@elver.google.com>
 <20201218171327.180140338d183b41a962742d@linux-foundation.org>
In-Reply-To: <20201218171327.180140338d183b41a962742d@linux-foundation.org>
From:   Marco Elver <elver@google.com>
Date:   Sat, 19 Dec 2020 11:11:14 +0100
Message-ID: <CANpmjNNWo7=WSs6jss56-jZP-F5tsTxUAE4UvbLgdbR6Bqr7fg@mail.gmail.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
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

[Ignore previous email without reply -- this time with actual reply]

On Sat, 19 Dec 2020 at 02:13, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 19 Dec 2020 01:28:29 +0100 Marco Elver <elver@google.com> wrote:
> > [...]
> > > -/*
> > > - * Poisons the shadow memory for 'size' bytes starting from 'addr'.
> > > - * Memory addresses should be aligned to KASAN_GRANULE_SIZE.
> > > - */
> > > -void poison_range(const void *address, size_t size, u8 value)
> > > -{
> > > -   void *shadow_start, *shadow_end;
> > > -
> > > -   /*
> > > -    * Perform shadow offset calculation based on untagged address, as
> > > -    * some of the callers (e.g. kasan_poison_object_data) pass tagged
> > > -    * addresses to this function.
> > > -    */
> > > -   address = reset_tag(address);
> > > -
> >
> > The moved lines do not mention kfence...
> > (The same commit in -next does.)
>
> They shouldn't.
>
> > > -   shadow_start = kasan_mem_to_shadow(address);
> > > -   shadow_end = kasan_mem_to_shadow(address + size);
> > > -
> > > -   __memset(shadow_start, value, shadow_end - shadow_start);
> > > -}
> > [...]
> > > --- /dev/null
> > > +++ a/mm/kasan/shadow.c
> > > @@ -0,0 +1,518 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * This file contains KASAN runtime code that manages shadow memory for
> > > + * generic and software tag-based KASAN modes.
> > > + *
> > > + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> > > + * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> > > + *
> > > + * Some code borrowed from https://github.com/xairy/kasan-prototype by
> > > + *        Andrey Konovalov <andreyknvl@gmail.com>
> > > + */
> > > +
> > > +#include <linux/init.h>
> > > +#include <linux/kasan.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/kfence.h>
> >
> > This is the first time kfence is mentioned. Is this correct?
>
> Yes.
>
> > Is my assumption correct that the kasan changes and kfence changes are
> > to be swapped?
>
> Yes, kfence came in fairly late and seems a bit fresh.  I was planning
> on holding it off until next cycle.
>
> Sigh.  I don't have access to my capable-of-compiling-KASAN machine at
> present :(  We'll need this, yes?

Looks reasonable; any mention of kfence should be removed from any of
the kasan patches if the kasan series goes before kfence. And kfence's
"kfence, kasan: make KFENCE compatible with KASAN" should absorb any
of those reverted changes.

Because kfence was picked up earlier, and appeared in -next before the
kasan series, the kasan series was rebased to not conflict with those
changes from kfence. Sorry for the inconvenience, and thank you for
sorting it out.

Thanks,
-- Marco

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
