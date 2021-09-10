Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A3BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 21:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E3D6120C
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 21:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhIJVI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 17:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbhIJVI2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 17:08:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FFBC061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 14:07:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d5so2207198pjx.2
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 14:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gwhCZpL/arZxgXCHc9ihA6IxJv6LlN3gOMlWrZ90PaM=;
        b=if9Tsma2/jX+TbJy6Wdtzyzw8dArueidpajTPxgbgMpDTUfmi+YCHbkh6pTwjUxyQr
         C745EfuBEFpXfXNI3OTL79bD/Z4EqJsyWt6zfi+zb6I6R1yZFW9LVleLWzaDiv1Werbu
         LKRIhi6OwLvP17d/7t3kDj+BtkXubcIEwmtI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gwhCZpL/arZxgXCHc9ihA6IxJv6LlN3gOMlWrZ90PaM=;
        b=As74wnP+FMDdGxi3EePJFryZOr5u/ma2b2zOhNP6Xfka8hLnYwT7pccT6XhjfuSrTn
         Kb3/fgp+EFWKgojs3Md4fsWa3HVuHwbhSY09R//p8jQyd77BQMP1E4rNVyuAST9dGvYk
         0rh9T8tE3quKrLrPnWxU8ufqfWl2n7r8Y9wmv5U8kCYpI+4dK+6m+Bul6hcE+FZJq3or
         8Mr23AgRXBtn5d/lKYuW6Ai2MaDlapOaBVwFQm7Kh47XjiCIlm31pLSCfc/bXMKJ63qq
         sLZJZMwwipcw/2iuwEXUPO4eomC9SxNBJf7FeUWhDpPaq5bJg7b/WVl96f9mHzOCS8Hl
         33MA==
X-Gm-Message-State: AOAM530bwzv0oj/jTBHBRfOSuZOBoKiSe2s0vinNYqeiNtMPtu+FSCQF
        xvO6XGRARVtI3SpfY1nRw6ti2Wh+VUHbJA==
X-Google-Smtp-Source: ABdhPJxD+BWZf753q3J1pd/aXECoQ4UXYAHdYGlsLM8MIVH2zYcRrwZGmNcr65zd9F5GVGlA6ts1Ag==
X-Received: by 2002:a17:90b:4f85:: with SMTP id qe5mr11651706pjb.241.1631308036478;
        Fri, 10 Sep 2021 14:07:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w192sm5886254pfc.82.2021.09.10.14.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 14:07:15 -0700 (PDT)
Date:   Fri, 10 Sep 2021 14:07:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Joe Perches <joe@perches.com>, Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
Message-ID: <202109101359.1C0B9B0A@keescook>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <CAKwvOd=quUcE8UBcwD6Hjs40LNKodHEwAfqt=_OjNdwYM19LOA@mail.gmail.com>
 <CAHk-=wiOCLRny5aifWNhr621kYrJwhfURsa0vFPeUEm8mF0ufg@mail.gmail.com>
 <202109101341.1BA94A0F5@keescook>
 <CAKwvOdmZEZqgZa+SUFXU6jtavpcmhBcshA-h1nZJyHYONM+ogw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmZEZqgZa+SUFXU6jtavpcmhBcshA-h1nZJyHYONM+ogw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 01:58:17PM -0700, Nick Desaulniers wrote:
> On Fri, Sep 10, 2021 at 1:47 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, Sep 10, 2021 at 01:16:00PM -0700, Linus Torvalds wrote:
> > > So to a close approximation
> > >
> > >  - "storage class" goes first, so "static inline" etc.
> > >
> > >  - return type next (including attributes directly related to the
> > > returned value - like "__must_check")
> > >
> > >  - then function name and argument declaration
> > >
> > >  - and finally the "function argument type attributes" at the end.
> >
> > I'm going to eventually forget this thread, so I want to get it into
> > our coding style so I can find it again more easily. :) How does this
> > look?
> >
> > diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
> > index 42969ab37b34..3c72f0232f02 100644
> > --- a/Documentation/process/coding-style.rst
> > +++ b/Documentation/process/coding-style.rst
> > @@ -487,6 +487,29 @@ because it is a simple way to add valuable information for the reader.
> >  Do not use the ``extern`` keyword with function prototypes as this makes
> >  lines longer and isn't strictly necessary.
> >
> > +.. code-block:: c
> > +
> > +       static __always_inline __must_check void *action(enum magic value,
> > +                                                        size_t size, u8 count,
> > +                                                        char *buffer)
> > +                                                       __alloc_size(2, 3)
> > +       {
> > +               ...
> > +       }
> > +
> > +When writing a function prototype, keep the order of elements regular. The
> > +desired order is "storage class", "return type attributes", "return
> > +type", name, arguments (as described earlier), followed by "function
> > +argument attributes". In the ``action`` function example above, ``static
> > +__always_inline`` is the "storage class" (even though ``__always_inline``
> > +is an attribute, it is treated like ``inline``). ``__must_check`` is
> 
> eh...mentioning inline as though it was a storage class doesn't seem
> precise, but I think this is a good start. Thanks Kees.

Well, hm, it's kinda like that? "where does it go?" "*everywhere*" :P
In looking at this a little longer, I do wonder about section attributes,
though. __cold is a hint, but ends up being a section attribute. And
section attributes appear to be used in the storage class (i.e.
"noinstr"). We treat "how the function should behave" attributes as
storage classes too, though (e.g. "notrace"). Is that right?

> 
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> 
> Worst case, consider "inlining related attributes like __always_inline
> and noinline should follow the storage class (static, extern).
> 
> > +a "return type attribute" (describing ``void *``). ``void *`` is the
> > +"return type". ``action`` is the function name, followed by the function
> > +arguments. Finally ``__alloc_size(2,3)`` is an "function argument attribute",
> > +describing things about the function arguments. Some attributes, like
> > +``__malloc``, describe the behavior of the function more than they
> > +describe the function return type, and are more appropriately included
> > +in the "function argument attributes".
> >
> >  7) Centralized exiting of functions
> >  -----------------------------------
> >
> > --
> > Kees Cook
> 
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers

-- 
Kees Cook
