Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F18FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 23:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29C60604DC
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 23:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhIUXi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 19:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhIUXi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Sep 2021 19:38:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289BEC061575
        for <mm-commits@vger.kernel.org>; Tue, 21 Sep 2021 16:37:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n18so517277plp.7
        for <mm-commits@vger.kernel.org>; Tue, 21 Sep 2021 16:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qIRPwBi35DByL5nNagL4hpGfYXpq07J7mvCHes4E2I8=;
        b=CagL4ypNs0iUa6oSr82NtUCcM5afk3tpeB8sZw/NJ2O4nCzEvz6X/w/zpg2BofRyva
         3ouHVYLoXloUnknXzDRHbkUfL/Y2/KzBuAtgYAm5fcGpL70SKzDWkbwoKqgBSjKgKWFR
         7x9f1PPXKYYZ3hHmt9RkRBRow7JIi6mipiPOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qIRPwBi35DByL5nNagL4hpGfYXpq07J7mvCHes4E2I8=;
        b=D2yY8fcnWIwOspoP6Sidj5IEag+zovfeEg/E0oGKmKvK4HPU8J4xcn56fFryvCYlq+
         87/XSYgZVQ6ENQioRcCD5ofOcc4fiV5cXLQe6v55VOnAls8tbgIFXrL6gVJAqhw7tsMt
         uyBD/XpZhdwetUpu/gdMjdIdIpZEr49LfNjsYScUd10O4vTH4geHjx66WsrE+6bU82iv
         Vmery+CNIIAS+Fxcc9OpEdHjYgb8iNqwnJlyYsZQ50r6JotjYTrWeknOQtRM0CGO6Xdy
         UvxYauPm3MX8KtKI6uVOeiCBVShseg7lzmMckzhmY/RxsgiMMLjLWKUrF84i5Fa4wJQk
         o6dw==
X-Gm-Message-State: AOAM532MFEm6nFH6mhBghoVg/OgmeiVqJ36/N8uedxXE+aRRwZVmzQUP
        dX3yqf+q5z3p/HiQsInmdwFNjg==
X-Google-Smtp-Source: ABdhPJxmuqnu/uYqodXX1f0kq7Os+jTCYEhXE+TvL4n6MzbS8CErhdU/aNilFR3PjarfxZ9bqn16kQ==
X-Received: by 2002:a17:902:6bc1:b0:137:10b6:972f with SMTP id m1-20020a1709026bc100b0013710b6972fmr29321530plt.69.1632267449413;
        Tue, 21 Sep 2021 16:37:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o15sm229255pfg.14.2021.09.21.16.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 16:37:28 -0700 (PDT)
Date:   Tue, 21 Sep 2021 16:37:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
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
Message-ID: <202109211630.2D00627@keescook>
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

I'm cleaning this up now, and have discovered that the reason for the
before-function placement is consistency with static inlines. If I do this:

static __always_inline void * kmalloc(size_t size, gfp_t flags) __alloc_size(1)
{
	...
}

GCC is very angry:

./include/linux/slab.h:519:1: error: attributes should be specified before the declarator in a function definition
  519 | static __always_inline void *kmalloc_large(size_t size, gfp_t flags) __alloc_size(1)
      | ^~~~~~

It's happy if I treat it as a "return type attribute" in the ordering,
though:

static __always_inline void * __alloc_size(1) kmalloc(size_t size, gfp_t flags)

I'll do that unless you have a preference for somewhere else...

-Kees

-- 
Kees Cook
