Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9241C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 20:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E41611B0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 20:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhIJU7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 16:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbhIJU7l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 16:59:41 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3CBC061756
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:58:30 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id m4so5242636ljq.8
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vEUZXH3M/SQ453EGXpEqw5L2mLWMbvjphyJujJracnk=;
        b=f3BL7STQnjG9rAr9jDFy/qUWbxqwdUs653gNETSUuawD76fDUoo0tWc3BjhGd0KXVX
         irjY30Du1gKpZZLYOqVdDg3Y2CXthr09xjcFtuoxdxYOw4hJk9eNRJNgLy6XFoiMl+q0
         YdHLww9V5SwvkufQg2uQneHLlpsHArIe76DvTOa/EDW/GVbAbPqO8h9Lk8H99vPet5Ez
         VA6G1URWCf/yvykqMSWDUVjgQ159LXYNeOAJNNsaXVAUPVq1m3vPlGF4le8v63deik0u
         JnzR2zdv0q4v0PAsDK2arBVRb0t2LWeBIgClDVe20VMkHMCd2Eh+u7mePaky0XVsMwNp
         MVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEUZXH3M/SQ453EGXpEqw5L2mLWMbvjphyJujJracnk=;
        b=GmLL3LWIR67MAujCmvxqJxrMuG4Kjk0GsInd2QI7J8pS5HHCgEjbcv/9SlfaRujgEr
         evM2lQfQARJtoPovUDRWqkdiZ0ZTf3S3II6wycywdlkWIeuTVMld7QwvuhqQW4PMcxaZ
         EAUn9YnqBWBlcowSdZJ1/4OZ5HvYYQsbCKS/2pO/Ci3/0jFRt9E3djMmx+8XcRgj4U/v
         fHsK1sNQNtZaHQe7u9EGkL8OeGb7fBPaCesA7G0gZm5vndBxHwaWDAZAQmfh5FFj0YnV
         MsFGo1N8/9wuCJ3pe812MgV6CtnCL21WcO+aC0lgJN657YtKABnRkC8F2SYdSm4akuzs
         n4LQ==
X-Gm-Message-State: AOAM530sDRvpGKqdoo3Dod8TP4aqNKpdn9Z50JOW3ABSDN3ri2FrTrkP
        3izKoO/FMVm7m0XF5HYjpyZWJXFJJ7LN2dYUjtOk3g==
X-Google-Smtp-Source: ABdhPJx9LKRcnNWARf8srsNV0YQazwhGjMmfLbOM1+xPBJ09Uzg+2COXESpOmlYLZZ0A4WQWO6Lwti5ETb5yx2djX6M=
X-Received: by 2002:a05:651c:54d:: with SMTP id q13mr5783351ljp.526.1631307508459;
 Fri, 10 Sep 2021 13:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org> <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <CAKwvOd=quUcE8UBcwD6Hjs40LNKodHEwAfqt=_OjNdwYM19LOA@mail.gmail.com>
 <CAHk-=wiOCLRny5aifWNhr621kYrJwhfURsa0vFPeUEm8mF0ufg@mail.gmail.com> <202109101341.1BA94A0F5@keescook>
In-Reply-To: <202109101341.1BA94A0F5@keescook>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 10 Sep 2021 13:58:17 -0700
Message-ID: <CAKwvOdmZEZqgZa+SUFXU6jtavpcmhBcshA-h1nZJyHYONM+ogw@mail.gmail.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
To:     Kees Cook <keescook@chromium.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 1:47 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Sep 10, 2021 at 01:16:00PM -0700, Linus Torvalds wrote:
> > So to a close approximation
> >
> >  - "storage class" goes first, so "static inline" etc.
> >
> >  - return type next (including attributes directly related to the
> > returned value - like "__must_check")
> >
> >  - then function name and argument declaration
> >
> >  - and finally the "function argument type attributes" at the end.
>
> I'm going to eventually forget this thread, so I want to get it into
> our coding style so I can find it again more easily. :) How does this
> look?
>
> diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
> index 42969ab37b34..3c72f0232f02 100644
> --- a/Documentation/process/coding-style.rst
> +++ b/Documentation/process/coding-style.rst
> @@ -487,6 +487,29 @@ because it is a simple way to add valuable information for the reader.
>  Do not use the ``extern`` keyword with function prototypes as this makes
>  lines longer and isn't strictly necessary.
>
> +.. code-block:: c
> +
> +       static __always_inline __must_check void *action(enum magic value,
> +                                                        size_t size, u8 count,
> +                                                        char *buffer)
> +                                                       __alloc_size(2, 3)
> +       {
> +               ...
> +       }
> +
> +When writing a function prototype, keep the order of elements regular. The
> +desired order is "storage class", "return type attributes", "return
> +type", name, arguments (as described earlier), followed by "function
> +argument attributes". In the ``action`` function example above, ``static
> +__always_inline`` is the "storage class" (even though ``__always_inline``
> +is an attribute, it is treated like ``inline``). ``__must_check`` is

eh...mentioning inline as though it was a storage class doesn't seem
precise, but I think this is a good start. Thanks Kees.

Acked-by: Nick Desaulniers <ndesaulniers@google.com>

Worst case, consider "inlining related attributes like __always_inline
and noinline should follow the storage class (static, extern).

> +a "return type attribute" (describing ``void *``). ``void *`` is the
> +"return type". ``action`` is the function name, followed by the function
> +arguments. Finally ``__alloc_size(2,3)`` is an "function argument attribute",
> +describing things about the function arguments. Some attributes, like
> +``__malloc``, describe the behavior of the function more than they
> +describe the function return type, and are more appropriately included
> +in the "function argument attributes".
>
>  7) Centralized exiting of functions
>  -----------------------------------
>
> --
> Kees Cook



-- 
Thanks,
~Nick Desaulniers
