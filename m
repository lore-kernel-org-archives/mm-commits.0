Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562E5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 19:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348A461167
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 19:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhIJTZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 15:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhIJTZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 15:25:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9E9C061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:24:21 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id e21so6311799ejz.12
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKo4Tdq4dmbNJOXszHMpLvxuG8B+UoHSQq7ZbUR792g=;
        b=Mr6cvJJlBTrCWCrY7vfg81gJvM5lpccs29n3iDnmmnXzX7JfqRV63CjG9qEvfj6fmc
         8+n/fSq+mBQB2vfi12kOGeo8yFanCMN4y0NPlfCyPP5heDaHIZN3eMlxWd7aCV+u+ySr
         VN5quD/divWymKPTsLcSedC3KD9heDjMhth04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QKo4Tdq4dmbNJOXszHMpLvxuG8B+UoHSQq7ZbUR792g=;
        b=B2v7UFuS8q1TgFxSj3GlvDGIblltCOqbns4TkIVuJWm7rNEJYYmS6KojYIZDcDX0UJ
         RWiP1C7pCXpvUlHQSPdf/Dp8PQQTlUxgaSNrPZKZr/THDsqLYCl2KUdoTjC7FkNX2cpz
         5hPBdHPXx/icjP/Xn/huIr9rNaSSnAh0Q18/HmLqxgqARdIAIAcQVYFtH9Ukda8WQlc0
         8MUnroLAkAQaunEVXaew45jIJbWjm9aUNkaWFapi+GOIBFLycRMoiDn06pDoHlrk9OaT
         I9wkIOYnseYz3UcQ6N+3tptHcPiUpotOJOysW9DG723Xez1ypIy8rbBvNiOet8iRYI2m
         oSqg==
X-Gm-Message-State: AOAM531ySJ03YwBFrVWCKmjJUkN3mhfSbS2YRqOX5cFNotoPvEt4yQTy
        oJifTFTexmVijNcEwUn+3Tx5CGX/ChohmgzLL4M=
X-Google-Smtp-Source: ABdhPJztDWnkGF60PExZPWhN/0U9sppClpH7UGWQdaYl5S9pACxqHW7pJuETmaOF/C4X6FuebOOoRA==
X-Received: by 2002:a17:906:3798:: with SMTP id n24mr2647475ejc.116.1631301859828;
        Fri, 10 Sep 2021 12:24:19 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id z6sm1531388ejj.13.2021.09.10.12.24.19
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 12:24:19 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id v10so4089464wrd.4
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:24:19 -0700 (PDT)
X-Received: by 2002:a05:6512:1112:: with SMTP id l18mr4994964lfg.402.1631301476401;
 Fri, 10 Sep 2021 12:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org> <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109101138.53FCADF5C@keescook>
In-Reply-To: <202109101138.53FCADF5C@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Sep 2021 12:17:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=whHPPKunYcDmSAJ4--o7VddZW-SWmMqQkiYwA_kEyQVUQ@mail.gmail.com>
Message-ID: <CAHk-=whHPPKunYcDmSAJ4--o7VddZW-SWmMqQkiYwA_kEyQVUQ@mail.gmail.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Joe Perches <joe@perches.com>, Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 11:43 AM Kees Cook <keescook@chromium.org> wrote:
>
> I had originally set out to do that, but the problem with merging with
> __malloc is the bit in the docs about "and that the memory has undefined
> content". So we can't do that for kmalloc() in the face of GFP_ZERO, as
> well as a bunch of other helpers. I always get suspicious about "this
> will improve optimization because we depend on claiming something is
> 'undefined'". :|

Oh, I had entirely missed that historical subtlety of __malloc.

Yeah, that would have been absolutely horrible. But it's not actually
really true.

It seems that the gcc people actually realized the problem, and fixed
the documentation:

  "Attribute malloc indicates that a function is malloc-like, i.e.,
that the pointer P returned by the function cannot alias any other
pointer valid when the function returns, and moreover no pointers to
valid objects occur in any storage addressed by P. In addition, the
GCC predicts that a function with the attribute returns non-null in
most cases"

IOW, it is purely about aliasing guarantees. Basically the guarantee
is that the memory that a "malloc" function returns can not alias
(directly or indirectly) any other allocations.

See

    https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Common-Function-Attributes.html#Common-Function-Attributes

So I think it's ok, and your reaction was entirely correct, but came
from looking at old documentation.

             Linus
