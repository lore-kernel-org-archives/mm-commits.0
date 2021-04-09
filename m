Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3953AC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 153C4610C8
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhDIUkM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhDIUkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2021 16:40:11 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A907C061762
        for <mm-commits@vger.kernel.org>; Fri,  9 Apr 2021 13:39:58 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n2so10620484ejy.7
        for <mm-commits@vger.kernel.org>; Fri, 09 Apr 2021 13:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vx9Ye8GdMp5AWz2zoETZUcBCfUh884wkgBYG61Nkrec=;
        b=AvHGMe88O0kQ2Jw87ZBNde7OJ3MZ4GXqRLkY0A26Y/iq7IfsvvGW7Mz/j09toL2lT4
         OL+rASnnRujVoF8fPXZ4Rq3vALqXD3nqS+V3CkmQg52G8gD7wiPlFu6lUXVET7KS2OWb
         ihE6Fgh6nQAYUAnJc2TuiMpIdRFMamI/A9sTo1fxkf8rNo5z3EvbZ5N9NftuqFXGitY0
         Z3WD7d69eSILnU54USApDCbRqB85msN0T9iMKDg0DDNW2BIUNhgSneR+IMf65F+3qV/S
         DYO5dqcf7K/kHy12UFQcUayea069gpAcm9J502+mhApVaa8TDv7YvWw/rtf03xoUl1Qg
         GSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vx9Ye8GdMp5AWz2zoETZUcBCfUh884wkgBYG61Nkrec=;
        b=iPtmDDkJnmL5B7sUu96pPZCdALgZdzqd7y6P7PrWqnWnV+6R6isTghBHtz5XTKjzi7
         OztTKiPvfWgx1S3AS04q5FOc10oEPAS3k6SGjiGzWGNQb5V7ydirLGAMP1bKz0vqmeg3
         dWqbpZjpmiiSSoVktn+VIlpYo4wf2ZALRiri4afg4BTh8moXzodP4M+KNJAEda3hfCyN
         yMZP2EPPeGBq317+PEFP/C5+tFXUWyYAei+PGWs6wMN1BDt6izXSREJdewE0MP1DYVx9
         A2RZPpG2yX+TrYFt6/UUjphqoDMYe5J2sOegi9AfysJ0BwAxD//pqN0xGZeyTEYMCJke
         bwUQ==
X-Gm-Message-State: AOAM5324HvBexegTCyL2CdJkUnit02tTZ0dMlP2sf70ejiVHHmc4qfcs
        QVwbwWVEs4EWlwDJn4UopEeFZAL5+gctpxHmOp8=
X-Google-Smtp-Source: ABdhPJyKfYmNeVaGIwRZmk0RgiGlYMyt7DNrutjBjgs8GlHP8UI3q4Zhv4kuldzxUd1CINSs8alfCUJyuIiaFeCUuNM=
X-Received: by 2002:a17:907:3c08:: with SMTP id gh8mr4061051ejc.439.1618000796958;
 Fri, 09 Apr 2021 13:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org> <20210409202713.NIELx3Tx9%akpm@linux-foundation.org>
In-Reply-To: <20210409202713.NIELx3Tx9%akpm@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Fri, 9 Apr 2021 22:39:46 +0200
Message-ID: <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
Subject: Re: [patch 05/16] kasan: fix hwasan build for gcc
To:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 9, 2021 at 10:27 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
> Subject: kasan: fix hwasan build for gcc
>
> gcc-11 adds support for -fsanitize=kernel-hwaddress, so it becomes
> possible to enable CONFIG_KASAN_SW_TAGS.
>
> Unfortunately this fails to build at the moment, because the corresponding
> command line arguments use llvm specific syntax.
>
> Change it to use the cc-param macro instead, which works on both clang and
> gcc.
>
> Link: https://lkml.kernel.org/r/20210323124112.1229772-1-arnd@kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Marco Elver <elver@google.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Michal Marek <michal.lkml@markovi.net>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  scripts/Makefile.kasan |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- a/scripts/Makefile.kasan~kasan-fix-hwasan-build-for-gcc
> +++ a/scripts/Makefile.kasan
> @@ -36,14 +36,14 @@ endif # CONFIG_KASAN_GENERIC
>  ifdef CONFIG_KASAN_SW_TAGS
>
>  ifdef CONFIG_KASAN_INLINE
> -    instrumentation_flags := -mllvm -hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET)
> +    instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
>  else
> -    instrumentation_flags := -mllvm -hwasan-instrument-with-calls=1
> +    instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
>  endif
>
>  CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
> -               -mllvm -hwasan-instrument-stack=$(CONFIG_KASAN_STACK) \
> -               -mllvm -hwasan-use-short-granules=0 \
> +               $(call cc-param,hwasan-instrument-stack=$(CONFIG_KASAN_STACK)) \
> +               $(call cc-param,hwasan-use-short-granules=0) \
>                 $(instrumentation_flags)
>
>  endif # CONFIG_KASAN_SW_TAGS
> _

Hi,

As I commented on the patch, this breaks SW_TAGS build with Clang for me with:

arch/arm64/include/asm/current.h:19: undefined reference to `__hwasan_tls'

The reason for this is that cc-param is only defined for
KASAN_GENERIC, the definition needs to be moved.

Thanks!
