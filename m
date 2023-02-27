Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A9FC7EE23
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 00:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjB0Ape (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjB0Apd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 19:45:33 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909FE10278
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 16:45:32 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id h8so1777112plf.10
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 16:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yDr1AomZ/bsVTOpFQmuDlr5MvDGNx4AsqOOAzHvIahg=;
        b=Wgev3ndtu+tBcnDnM3773sjF4DWLnJnqTP5eneyMt3Bu4kFvvpJqBMHKRZ5eAJu70X
         G4905Gpzd62L97aHnSDQwr9ZPRlmjCRz9EiobmIuYoDubNolg4gWtcpYJiftT+geVWaS
         VHOMK45/KtNEXTWQjG7igv4CCgIFvxzPlqWm5TMF7aICZCWmsgkU/1EtERHqkKcsmoUg
         uT3zlLsAjnCheY4CMwMi3ahPG+6Ba2SmGoZ3s8LigO/EYzq+DXl1+wIFQe7Lw4Tpkv2P
         KAsTf9wsIwvjdYd9cWHjZ9NKLlQBYNGSEyjkm54AGwNNGEqafoPmm8IeV3T9QnDs1z6J
         qBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDr1AomZ/bsVTOpFQmuDlr5MvDGNx4AsqOOAzHvIahg=;
        b=wLo9/NzXTaPWyVogpqkBXrhhy9PQK880aW5M2FLHKNDNjpz/rIgErz9FbnrGCx1aru
         NMgR4F3e7flhNcPfTMHs38TtEbd96sETqNKn3Ow1vXrtu/TAuzr9eq7cysBqpdjzg1N1
         kfuAwHep15YRV/2l64tPA9Oldu8YldBNt7hZcXMEGcEiMbuIa8bQHC+7VKYRNy8If07+
         ZWXB63jrDPridzrsmLHDEqhyhc4BCLbeMXVb9CrDZ49cGTTKrg7ccL1AA90AbsIlWZfv
         2UmuaUqV5OFCtGEiJnXt07KTpvFbppPZfTPrG0s+deybyKsMODmA4yQxWgI+mf8n+LmW
         4onA==
X-Gm-Message-State: AO0yUKVCwHuEBbwr6BTiX+63inEOHrBHnTJIewf6o2sg25dbX8aNnlK7
        a/INqT6qjVBWbDTDQFuxwLAdn0wCvYybYlYr05Q=
X-Google-Smtp-Source: AK7set97uKWgPStgquyhbZWyu/trWfiY5GxX3RWjeWkOkaYZXdlON5caeTVqUv9dqm9jAIAVfKva8nAixFmAqyZnvgw=
X-Received: by 2002:a17:90a:dc04:b0:233:bc72:1c69 with SMTP id
 i4-20020a17090adc0400b00233bc721c69mr4102982pjv.9.1677458732015; Sun, 26 Feb
 2023 16:45:32 -0800 (PST)
MIME-Version: 1.0
References: <20230226050340.CFC98C433D2@smtp.kernel.org> <Y/s7q4EAXRticRvR@zn.tnic>
 <20230226114111.405aa7d661076a45feb70a96@linux-foundation.org>
In-Reply-To: <20230226114111.405aa7d661076a45feb70a96@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Mon, 27 Feb 2023 01:45:21 +0100
Message-ID: <CA+fCnZeioZWYw0qjmBwbpM5x6=iZOwAD8w5BKV6j1_x331hz8w@mail.gmail.com>
Subject: Re: + kasan-emit-different-calls-for-instrumentable-memintrinsics.patch
 added to mm-hotfixes-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Feb 26, 2023 at 8:41 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sun, 26 Feb 2023 11:59:55 +0100 Borislav Petkov <bp@alien8.de> wrote:
>
> > On Sat, Feb 25, 2023 at 09:03:40PM -0800, Andrew Morton wrote:
> > > --- a/mm/kasan/shadow.c~kasan-emit-different-calls-for-instrumentable-memintrinsics
> > > +++ b/mm/kasan/shadow.c
> > > @@ -107,6 +107,17 @@ void *__asan_memcpy(void *dest, const void *src, size_t len)
> > >  }
> > >  EXPORT_SYMBOL(__asan_memcpy);
> > >
> > > +#ifdef CONFIG_KASAN_SW_TAGS
> > > +void *__hwasan_memset(void *addr, int c, size_t len) __alias(__asan_memset);
> > > +EXPORT_SYMBOL(__hwasan_memset);
> > > +#ifdef __HAVE_ARCH_MEMMOVE
> > > +void *__hwasan_memmove(void *dest, const void *src, size_t len) __alias(__asan_memmove);
> > > +EXPORT_SYMBOL(__hwasan_memmove);
> > > +#endif
> > > +void *__hwasan_memcpy(void *dest, const void *src, size_t len) __alias(__asan_memcpy);
> > > +EXPORT_SYMBOL(__hwasan_memcpy);
> >
> > Any particular reason those exports are not _GPL?

Not using _GPL will allow using KASAN with non-GPL modules AFAIU. I
don't see why this should be forbidden.

> mm/kasan/ is an exotic blend of both.  Perhaps the maintainers will
> take a look at this sometime?

All of the _GPL exports in mm/kasan/ are for symbols required for
KASAN tests. If there was a way to only export them for kasan_test.ko,
we could use that instead. _GPL is used as a best-effort marking.

Everything else is using EXPORT_SYMBOL().
