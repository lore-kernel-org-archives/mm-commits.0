Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C287C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 07:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14AE561178
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 07:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhIVHZn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Sep 2021 03:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhIVHZm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Sep 2021 03:25:42 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EC3C061574;
        Wed, 22 Sep 2021 00:24:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q26so3851814wrc.7;
        Wed, 22 Sep 2021 00:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ULwoOoLedOT4q7QVhiTfuMRJL+g42ZvtZLso5l9rgRY=;
        b=mUlp7aX+AbdUf8t/iQV/vo+r+mLJL7e/qWLY5UNFxABQv07ML9RXYBeZJycroCNdrR
         nYqG8tfJNFkuYOKW7WlHBnUezqqFkQm6K2/RL7B5j6WkSLS2dd9haJUPR7b68uFYvD7l
         cf6CwkVU6sbzGdkiCGVfWCxXT+7Y7vrvJn2egaqCe8EZh/dIzwW49U7MAhoDlLDyFEa9
         /Ei39y5F+UyjybB7Q9cpWd2Q6+0d9cb91L8CA8CmHMZjy9/vqoaBmYtJC/p07wHjP9YF
         RYRsfAr2TTDhFqYCSbgbhUy4e7sfreV6a3CbA8FMQAjssbh8X1sBd2QpADRdQJk6wxdf
         kdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ULwoOoLedOT4q7QVhiTfuMRJL+g42ZvtZLso5l9rgRY=;
        b=155DDb5nrqNj8KINtGqgJKJ0+f/OhHj4MrDstaaiEPfQgpEvqj/Oj9fiAhGgcBhM6q
         xgNngNPfn3ytPpMq9uQ1uG/5gZNKytRjLl/qJz/StPzFNwgKdRT9xmNQBWRxkN1xtuH9
         OkfQTVgD1ERLXOYazLi0fdV2j54bHKNdZatkskMjb9woTxkh2Ihf6hGhd/RImvDCRk1k
         BHxm4cHqzHQdfBYmZX+zkMdBqe3sDkgUgIOA0XW3VbVZgHcUoLe+KsANNGGz132v22A0
         JImTnABKF9M61iYxyIlGlv6zHiVymeKgCyiLcTI835vkAsvd3K9cN1cUFJGecpwFaWSG
         cPpQ==
X-Gm-Message-State: AOAM531lyuTCiCWte8jlj0s+fCVq0hFHSYwO4Gv7xgcYBQyAhnQs2sR1
        /3+uyYPpLY6PxX4QW2VCkcRxSsRAXHy0
X-Google-Smtp-Source: ABdhPJy7HsSVUaQeuyvJ6ZcmsmbeD912UQv/jB8HzcSjxN589QnfzOcYK9boFdHVuTUAqmqTwGDiZw==
X-Received: by 2002:adf:a745:: with SMTP id e5mr28910852wrd.406.1632295451096;
        Wed, 22 Sep 2021 00:24:11 -0700 (PDT)
Received: from localhost.localdomain ([46.53.252.100])
        by smtp.gmail.com with ESMTPSA id s10sm1309856wrg.42.2021.09.22.00.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 00:24:10 -0700 (PDT)
Date:   Wed, 22 Sep 2021 10:24:08 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-doc@vger.kernel.org
Subject: Re: function prototype element ordering
Message-ID: <YUraGKetS+Tgc7y9@localhost.localdomain>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109211630.2D00627@keescook>
 <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
 <202109211757.F38DF644@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202109211757.F38DF644@keescook>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 21, 2021 at 07:25:53PM -0700, Kees Cook wrote:
> On Tue, Sep 21, 2021 at 04:45:44PM -0700, Joe Perches wrote:
> > On Tue, 2021-09-21 at 16:37 -0700, Kees Cook wrote:
> > > On Fri, Sep 10, 2021 at 10:23:48AM -0700, Linus Torvalds wrote:
> > > > On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > 
> > > > > +__alloc_size(1)
> > > > >  extern void *vmalloc(unsigned long size);
> > > > [...]
> > > > 
> > > > All of these are added in the wrong place - inconsistent with the very
> > > > compiler documentation the patches add.
> > > > 
> > > > The function attributes are generally added _after_ the function,
> > > > although admittedly we've been quite confused here before.
> > > > 
> > > > But the very compiler documentation you point to in the patch that
> > > > adds these macros gives that as the examples both for gcc and clang:
> > > > 
> > > > + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
> > > > + * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
> > > > 
> > > > and honestly I think that is the preferred format because this is
> > > > about the *function*, not about the return type.
> > > > 
> > > > Do both placements work? Yes.
> > > 
> > > I'm cleaning this up now, and have discovered that the reason for the
> > > before-function placement is consistency with static inlines. If I do this:
> > > 
> > > static __always_inline void * kmalloc(size_t size, gfp_t flags) __alloc_size(1)
> > > {
> > > 	...
> > > }
> > > 
> > > GCC is very angry:
> > > 
> > > ./include/linux/slab.h:519:1: error: attributes should be specified before the declarator in a function definition
> > >   519 | static __always_inline void *kmalloc_large(size_t size, gfp_t flags) __alloc_size(1)
> > >       | ^~~~~~
> > > 
> > > It's happy if I treat it as a "return type attribute" in the ordering,
> > > though:
> > > 
> > > static __always_inline void * __alloc_size(1) kmalloc(size_t size, gfp_t flags)
> > > 
> > > I'll do that unless you have a preference for somewhere else...
> > 
> > _please_ put it before the return type on a separate line.
> > 
> > [__attributes]
> > [static inline const] <return type> function(<args...>)
> 
> Somehow Linus wasn't in CC. :P
> 
> Linus, what do you want here? I keep getting conflicting (or
> uncompilable) advice. I'm also trying to prepare a patch for
> Documentation/process/coding-style.rst ...
> 
> Looking through what was written before[1] and through examples in the
> source tree, I find the following categories:
> 
> 1- storage class: static extern inline __always_inline
> 2- storage class attributes/hints/???: __init __cold
> 3- return type: void *
> 4- return type attributes: __must_check __noreturn __assume_aligned(n)
> 5- function attributes: __attribute_const__ __malloc
> 6- function argument attributes: __printf(n, m) __alloc_size(n)
> 
> Everyone seems to basically agree on:
> 
> [storage class] [return type] [return type attributes] [name]([arg1type] [arg1name], ...)
> 
> There is a lot of disagreement over where 5 and 6 should fit in above. And
> there is a lot of confusion over 4 (mixed between before and after the
> function name) and 2 (see below).
> 
> What's currently blocking me is that 6 cannot go after the function
> (for definitions) because it angers GCC (see quoted bit above), but 5
> can (e.g. __attribute_const__).
> 
> Another inconsistency seems to be 2 (mainly section markings like
> __init). Sometimes it's after the storage class and sometimes after the
> return type, but it certainly feels more like a storage class than a
> return type attribute:
> 
> $ git grep 'static __init int' | wc -l
> 349
> $ git grep 'static int __init' | wc -l
> 8402
> 
> But it's clearly positioned like a return type attribute in most of the
> tree. What's correct?
> 
> Regardless, given the constraints above, it seems like what Linus may
> want is (on "one line", though it will get wrapped in pathological cases
> like kmem_cache_alloc_node_trace):
> 
> [storage class] [storage class attributes] [return type] [return type attributes] [function argument attributes] [name]([arg1type] [arg1name], ...) [function attributes]
> 
> Joe appears to want (on two lines):
> 
> [storage class attributes] [function attributes] [function argument attributes]
> [storage class] [return type] [return type attributes] [name]([arg1type] [arg1name], ...)
> 
> I would just like to have an arrangement that won't get NAKed by
> someone. ;) And I'm willing to document it. :)

Attributes should be on their own line, they can be quite lengthy.

	__attribute__((...))
	[static] [inline] T f(A1 arg1, ...)
	{
		...
	}

There will be even more attributes in the future, both added by
compilers and developers (const, pure, WUR), so let's make "prototype lane"
for them.

Same for structures:

	__attribute__((packed))
	struct S {
	};

Kernel practice of hiding attributes under defines (__ro_after_init)
breaks ctags which parses the last identifier before semicolon as object
name. Naturally, it is ctags bug, but placing attributes before
declaration will autmatically unbreak such cases.
