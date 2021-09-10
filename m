Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44214C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 18:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28EA361250
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 18:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhIJSqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 14:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbhIJSq1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 14:46:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FBEC0613DE
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 11:43:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2062308pjq.4
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 11:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lv1p9zHba3I9cECEqRtPSSNa5kOoo9emyH9mJ0H8m8o=;
        b=bjpP9QHFJ+pYcG5i9iwcHyxO5hzHyEzm3e1HqmIFsMPrh1GMlTxAZZXh76EB9/QG8R
         OjsRzXncN5A0i4Jdvnr+jqWJdk2cvvOYocddzJX+dphXM0GINC3lcoYBg2X38mSgaBCE
         U0WuKIw0RI9MsgjqW4cfe/hDtC1CTCC9apdYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lv1p9zHba3I9cECEqRtPSSNa5kOoo9emyH9mJ0H8m8o=;
        b=ZCZahO0lzhQc8K6jYasr7EYyZTsfdoZfw14DLimtyEgvGxChHnSAx+KNVLuuJTCwi4
         HGleg0Y+np0L9lY0Nl6W00AhAHtSgYehkmNurXDSp3cmBOkrnVADXzWH9p1IWhDGwdBN
         YUIdfyAYceGFcRuadf939JVuLMLSSv3VZu60EphI6fIyfeCPGZtiuNcWzent5h13eSQr
         peDW+isgSnEKGHbrbpnVy/GwnOhjJKK6z3W/hKQBeyAuaFJmT6Rw73ImBp6zTP3+h7cM
         2Re2xJKcjYDfbJ7ZYpL5ixXvEu2QMRt5kTLo4iNQSN90DHcKyCNb1rFGvM1zAndq0rZ6
         KSsQ==
X-Gm-Message-State: AOAM533vatCNgM79yghX+1+Rz5ThajlrKI/KZ6Tipo/3hXWwHnItwOrQ
        72pl7QUwrrb1CSuBTMRkM+7cdw==
X-Google-Smtp-Source: ABdhPJzbR+ovIpV5OqJJYBmG2oeAsqbsKVwHDcgn5Kv05lSErl4vHRfRj8TTEAcF6HmnRDc7ke7YXQ==
X-Received: by 2002:a17:90a:8b98:: with SMTP id z24mr11135526pjn.87.1631299432723;
        Fri, 10 Sep 2021 11:43:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c4sm5776533pji.51.2021.09.10.11.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 11:43:52 -0700 (PDT)
Date:   Fri, 10 Sep 2021 11:43:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
Message-ID: <202109101138.53FCADF5C@keescook>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 10:23:48AM -0700, Linus Torvalds wrote:
> On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > +__alloc_size(1)
> >  extern void *vmalloc(unsigned long size);
> [...]
> 
> All of these are added in the wrong place - inconsistent with the very
> compiler documentation the patches add.
> 
> The function attributes are generally added _after_ the function,
> although admittedly we've been quite confused here before.
> 
> But the very compiler documentation you point to in the patch that
> adds these macros gives that as the examples both for gcc and clang:
> 
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
> 
> and honestly I think that is the preferred format because this is
> about the *function*, not about the return type.
> 
> Do both placements work? Yes.
> 
> Have we been confused about this before? Yes. I note that our __printf
> attributes in particular have been added in odd places. And our
> existing __malloc annotations seem to correct in <linux/slab.h> and
> <linux/device.h> but then randomly applied in some other places.
> 
> I really think it's pointlessly stupid and hard to read/grep for to
> make it be a separate line before the whole thing.

This was bike-shed on the list, and this result seemed to be consensus,
but I kind of dislike all the options. Either things are on separate
lines or they're trailing attributes that get really long, etc. Ugh.

I'm happy to clean all of it up into whatever form can be agreed on for
the "correct" placement.

> I also think it should have taken over the "__malloc" name that is
> almost unused right now. Because why would you ever have
> __alloc_size() without having __malloc().

I had originally set out to do that, but the problem with merging with
__malloc is the bit in the docs about "and that the memory has undefined
content". So we can't do that for kmalloc() in the face of GFP_ZERO, as
well as a bunch of other helpers. I always get suspicious about "this
will improve optimization because we depend on claiming something is
'undefined'". :|

-Kees

-- 
Kees Cook
