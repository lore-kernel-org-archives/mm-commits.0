Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA48C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 12:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A8C61287
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 12:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhDLMzP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Apr 2021 08:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238259AbhDLMzP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Apr 2021 08:55:15 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50331C061574
        for <mm-commits@vger.kernel.org>; Mon, 12 Apr 2021 05:54:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id e14so20053944ejz.11
        for <mm-commits@vger.kernel.org>; Mon, 12 Apr 2021 05:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Co/n8JGdueipQMR9nBhAn/ujwDkJvzG+qQyDrb+/tyw=;
        b=SYPx/iJkkatJKxBwAWEULLLRHv/aFY38fcTZ8+jW4WfUA3olXObjpB91wQ09iazfAB
         M3vOhjrO3hhn6AJM1lms/CA3iZfobAnb13+epblc+UzI8vt9d8HM+79LDXjAwRvqgqGM
         BH1IfOg2Up6VDPMkN1tI6/so6k7LgvK+UXeQqaIkKjEfa2UI0y/flZhjmzPzLXKZX8F0
         10sYI7UY2hMMd3mo7Z1M2nRNvveDxK5AEoQcghuX81+otsdkhFdYt4tZZAUH17qcXWS5
         QZSmNizC0BZQCT1AiofYZNOuNP6U+5ooBII0Uo07d9Qk7yZKSAoHJTLi9CUDnbaakYDe
         WjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Co/n8JGdueipQMR9nBhAn/ujwDkJvzG+qQyDrb+/tyw=;
        b=P0Djab+zMQkxsD/o5j3QyU/2rfdn3BmaAN4Jh92gNZ6RucYZ0FR9fA7OMgAcy61677
         NVOlyQuaddXwP+NPkAPBS7WlR59/MTC4AqJxB9zUfK1OoM5uCyw/eZKXsBgOEJPBOV8A
         k+66X2FCCh3EB4jkadnrS9eXhZYkdB1zapD1f/YW8C9m+q1auaifSaOt8ETQVhaz/+86
         VeYPATej4BWyCVy7AfpGadwai4k4Kc6i0mCQ1Hv8f8Hb3IFjX1VHKxj33YbVqQccf4uo
         cWbh/b2uBbpVXsXXylOn74jHLgb+VsDta/vmVwkzBVzyCaEfc++KbvYpFESSarnOTz4s
         kVtQ==
X-Gm-Message-State: AOAM533bsaZrU5AFcOLd8Yaz3eSG+0vr7sPByGhYSkiGyq+H5QNv9Iyb
        Tgg62iG21M1Rc8It/y7DZbgncz2+Nm9ow6ZHw8Q=
X-Google-Smtp-Source: ABdhPJzMa3ko5cPHHV4C5C/vHT3hHOnASBYb40mvsJ2JO11s4GZ/vnNSwUXO6aProJwSPEK4ijHuyoMBeCjnck3J9RU=
X-Received: by 2002:a17:907:2d0c:: with SMTP id gs12mr13342688ejc.443.1618232096063;
 Mon, 12 Apr 2021 05:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
 <20210409202713.NIELx3Tx9%akpm@linux-foundation.org> <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
 <20210409135836.5fd622e4bec07650774f58c2@linux-foundation.org> <YHQZVfVVLE/LDK2v@elver.google.com>
In-Reply-To: <YHQZVfVVLE/LDK2v@elver.google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Mon, 12 Apr 2021 14:54:45 +0200
Message-ID: <CA+fCnZcnyp26oWKz8rEZya6kxWLWro_7yNyDCTmt84yx5Y-qZg@mail.gmail.com>
Subject: Re: [patch 05/16] kasan: fix hwasan build for gcc
To:     Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Dmitry Vyukov <dvyukov@google.com>,
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

On Mon, Apr 12, 2021 at 11:56 AM Marco Elver <elver@google.com> wrote:
>
> On Fri, Apr 09, 2021 at 01:58PM -0700, Andrew Morton wrote:
> > On Fri, 9 Apr 2021 22:39:46 +0200 Andrey Konovalov <andreyknvl@gmail.com> wrote:
> >
> > > >
> > > >  endif # CONFIG_KASAN_SW_TAGS
> > > > _
> > >
> > > Hi,
> > >
> > > As I commented on the patch, this breaks SW_TAGS build with Clang for me with:
> > >
> > > arch/arm64/include/asm/current.h:19: undefined reference to `__hwasan_tls'
> > >
> > > The reason for this is that cc-param is only defined for
> > > KASAN_GENERIC, the definition needs to be moved.
> > >
> >
> > Oh.  I thought that had been fixed.
> >
> > Please send a patch?
>
> I think we need something like the below.
>
> Unless a fixed version has already been sent, feel free to squash
> (applies immediately after "kasan: fix hwasan build for gcc", and before
> the conflicting "kasan: remove redundant config option").
>
> Thanks,
> -- Marco
>
> ------ >8 ------
>
> From: Marco Elver <elver@google.com>
> Date: Sun, 11 Apr 2021 21:32:01 +0200
> Subject: [PATCH] fixup for "kasan: fix hwasan build for gcc"
>
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  scripts/Makefile.kasan | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
> index 0a2789783d1b..127012f45166 100644
> --- a/scripts/Makefile.kasan
> +++ b/scripts/Makefile.kasan
> @@ -2,6 +2,8 @@
>  CFLAGS_KASAN_NOSANITIZE := -fno-builtin
>  KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
>
> +cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
> +
>  ifdef CONFIG_KASAN_GENERIC
>
>  ifdef CONFIG_KASAN_INLINE
> @@ -12,8 +14,6 @@ endif
>
>  CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
>
> -cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
> -
>  # -fasan-shadow-offset fails without -fsanitize
>  CFLAGS_KASAN_SHADOW := $(call cc-option, -fsanitize=kernel-address \
>                         -fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
> --
> 2.31.1.295.g9ea45b61b8-goog
>

This fix-up looks good to me.

Thank you, Marco!
