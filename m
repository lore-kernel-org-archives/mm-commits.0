Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA9BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 20:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3B861207
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 20:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhIJURc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 16:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhIJURb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 16:17:31 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD20C061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:16:19 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id l18so5055062lji.12
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d28/k7ILzz9ipn+GGAmUKD/GHAg24xQv1Ub5U2SUv70=;
        b=L8rkMIzR+JWOIkGoxKT6RnGMCiKXSCOh59olXxXpcI6AgvHjxtz01KFWFHx0TF023g
         GlUr5IlA032pU4KRbIbCV6spQW3H9DG7l7svknERoM15+emMyFpKNZJnPsl+P1DrH0LC
         05BjvWKjLSaCQHyGRKKYcIed0FDjjQyRNlygo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d28/k7ILzz9ipn+GGAmUKD/GHAg24xQv1Ub5U2SUv70=;
        b=BPIkseWPA+D+Pw+Xlbxj3qtwnimsQrXya/54GkdVZS03WnK+ndPugdyXyNKyvMqktM
         3JYEG5i0g3MdJdoQHTAJbEtFP9k1AqjI6G8NeIO6vse5IkeI0EZTIG9m29+FGoGg5/Ie
         sx1OdEs2HnohBVoB3hf6KpOyuGePR31RdokehUziYM7hWXPn0zWvGKPrBxnfWbYG6spg
         t59VnZ1rhke/SnaDXj7fh1HhqV0axRvVl79NSb8hzZ4JVfLhPCOeQxdPZ6R2MznQQdEG
         mMdr4MYJ4PmIjumVL6jl+0LPdz786ngzGfNeEzv/AleYdk4h4e+gd7snKxF+x8mf6mjF
         sWbA==
X-Gm-Message-State: AOAM530Rkztbjt4CrVQnsSxFPi9LOPuMrQpWJ1znUUZcmtxuPjy3cGBW
        EO4bclxXV8YDCXZoas39CyNS8SPHv2gb88P0k/0=
X-Google-Smtp-Source: ABdhPJz8hLkYHi4vTxxnLzn/hni0Q0cA4iutXcgE3wycUN6hkl+VgnImhSFXQA2V+ctXq4B4nEhOVg==
X-Received: by 2002:a2e:b5d0:: with SMTP id g16mr5428356ljn.349.1631304977693;
        Fri, 10 Sep 2021 13:16:17 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id w21sm654443lfk.84.2021.09.10.13.16.17
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 13:16:17 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id x27so6400155lfu.5
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:16:17 -0700 (PDT)
X-Received: by 2002:a05:6512:3d04:: with SMTP id d4mr3853280lfv.474.1631304977155;
 Fri, 10 Sep 2021 13:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org> <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <CAKwvOd=quUcE8UBcwD6Hjs40LNKodHEwAfqt=_OjNdwYM19LOA@mail.gmail.com>
In-Reply-To: <CAKwvOd=quUcE8UBcwD6Hjs40LNKodHEwAfqt=_OjNdwYM19LOA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Sep 2021 13:16:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiOCLRny5aifWNhr621kYrJwhfURsa0vFPeUEm8mF0ufg@mail.gmail.com>
Message-ID: <CAHk-=wiOCLRny5aifWNhr621kYrJwhfURsa0vFPeUEm8mF0ufg@mail.gmail.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>,
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

On Fri, Sep 10, 2021 at 12:49 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Huh?
> $ grep -rn __always_inline
> $ grep -rn noinline
> $ grep -rn __cold

Those are all examples of basically storage classes.

And yes, they go to the front - generally even before the return
value. Exactly like 'extern' and 'static'.

The In contrast, the "function argument descriptions" have
traditionally gone at the end, although you can certainly finds us
screwing that up too.

This, btw, tends to be how the compiler documentation also does it.

So to a close approximation

 - "storage class" goes first, so "static inline" etc.

 - return type next (including attributes directly related to the
returned value - like "__must_check")

 - then function name and argument declaration

 - and finally the "function argument type attributes" at the end.

can you do it in different orders? Yes. And the compiler won't even
generally warn about it. So we've gotten it wrong many many times.

I mean, compilers won't complain even about clear garbage that is _so_
bad that we generally get it right:

  int static myfn(void);

will build perfectly fine. That most certainly doesn't make it right.

Arguably "__malloc" could be seen about the returned type, rather than
being about the function declarations. But if it was about the
returned type, you'd call it a "restrict" pointer, so the very name
kind of implies that it's about the behaviot of the _function_ more
than the type of the return value.

And the "enumerate the arguments" of __alloc_size() makes it 100%
clear that it has absolutely NOTHING to do with the return type, and
is all about the function itself and which arguments give the size.

So the attribute goes at the end, not the front.

Are these a bit arbitrary? Sure. And because it's not checked, it's
not consistent. But I can only repeat: this is literally how the
compiler docs themselves tend to order things, pointed to in the very
patches that are under discussion.

So the rules may be arbitrary, but they are at least _somewhat_
internally consistent. Yes, you can always argue about whether some
behavior is about the returned type or whether it is about the
semantics of the function.

         Linus
