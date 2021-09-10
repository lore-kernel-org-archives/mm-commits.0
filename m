Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7FDC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 19:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F06611B0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 19:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhIJTeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 15:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhIJTeN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 15:34:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1939C061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:33:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m21-20020a17090a859500b00197688449c4so2182587pjn.0
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3uMJlHWN/DcKri5Cv8QoGGUJBEFXIEZtF1ZDUU3A4C0=;
        b=Q/p2ErFH0C73L91Xoh8gsIzfWPTWe+2ZVTj4jOYozWsZIEVU1BhS/MrYw8TBDwCZn9
         beNIw83reHe7qsxiEEdexIvM9sovfvznTVIO22jLyT+vcemEY6xDBeIQDAPASdgtWj9Z
         vbpvb9Bx8EPVXH/c6QSYklAs6yRwN1vgGImg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3uMJlHWN/DcKri5Cv8QoGGUJBEFXIEZtF1ZDUU3A4C0=;
        b=6PIIVmzcD6HxjoJrRM+qBfYIxBSHJrmc/7H32ebd7sVB6MzfvNf0KzoxW9Z7aZlHdz
         lTsXiuV940RxoI0fZHxbWIe8OtjfGgwRkXP3CTD7n1LU+t+k/7OFcZKvBm0FwZsNxw3u
         PUdOzRHkip2wEGwcjFi08wzJxwDExXYtlS1j8tnxMaJ5hi+rTkPIwofkBoYjn4ysDkW1
         T3whNDuj4Yi3qTaK4wZUAzchTO0QTBcXiONAy7mhliilxYyVBYSNbH8D1VqTnjHTj7cA
         UyUyQwTrrbwNfZv2KzXBP80tM6Xi0MvRoC+0gV3HdulOTsyMnYq0SAJec5ZWPjYk222W
         /rsQ==
X-Gm-Message-State: AOAM533FjraDQW6m72iUuJUWgHaNuSCGwzVmIXB070cSxKgNfleSAO3k
        8icCIuqlO/ZQsA7LRWpdcEPhqQ==
X-Google-Smtp-Source: ABdhPJxu3u6jqvGyqcIOa9fchzzmgXENc6KB5xySoVE7KO2soP3YI60wBssNvdQZNV2Wtexf/aWgTg==
X-Received: by 2002:a17:903:189:b0:13b:7754:1292 with SMTP id z9-20020a170903018900b0013b77541292mr142677plg.69.1631302381270;
        Fri, 10 Sep 2021 12:33:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 4sm5543710pjb.21.2021.09.10.12.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 12:32:59 -0700 (PDT)
Date:   Fri, 10 Sep 2021 12:32:58 -0700
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
Message-ID: <202109101220.ABDCC9652@keescook>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109101138.53FCADF5C@keescook>
 <CAHk-=whHPPKunYcDmSAJ4--o7VddZW-SWmMqQkiYwA_kEyQVUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whHPPKunYcDmSAJ4--o7VddZW-SWmMqQkiYwA_kEyQVUQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 12:17:40PM -0700, Linus Torvalds wrote:
> On Fri, Sep 10, 2021 at 11:43 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > I had originally set out to do that, but the problem with merging with
> > __malloc is the bit in the docs about "and that the memory has undefined
> > content". So we can't do that for kmalloc() in the face of GFP_ZERO, as
> > well as a bunch of other helpers. I always get suspicious about "this
> > will improve optimization because we depend on claiming something is
> > 'undefined'". :|
> 
> Oh, I had entirely missed that historical subtlety of __malloc.
> 
> Yeah, that would have been absolutely horrible. But it's not actually
> really true.
> 
> It seems that the gcc people actually realized the problem, and fixed
> the documentation:
> 
>   "Attribute malloc indicates that a function is malloc-like, i.e.,
> that the pointer P returned by the function cannot alias any other
> pointer valid when the function returns, and moreover no pointers to
> valid objects occur in any storage addressed by P. In addition, the
> GCC predicts that a function with the attribute returns non-null in
> most cases"
> 
> IOW, it is purely about aliasing guarantees. Basically the guarantee
> is that the memory that a "malloc" function returns can not alias
> (directly or indirectly) any other allocations.
> 
> See
> 
>     https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Common-Function-Attributes.html#Common-Function-Attributes
> 
> So I think it's ok, and your reaction was entirely correct, but came
> from looking at old documentation.

Okay, sounds good. The other reason for having them be separate is that
some of our allocators are implicitly sized. (i.e. kmem_cache_alloc()),
so there isn't actually a "size" argument to give. I suppose some kind
of VARARGS macro magic could be used to make __malloc() be valid, but
I don't like that in the face of future changes where people just don't
include the argument by accident.

How about the other way around, where __malloc is included in
__alloc_size()? Then the implicitly-sized allocators are left unchanged
with __malloc.

For the mechanical part of this, I'm left needing an answer to "what's
the style guide for this?" in the face of these longer definitions,
especially in the face of potential future trailing attributes.

e.g. all on one line would be 119 characters, way past even the updated
100 character limit:

__must_check static inline void *krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags) __alloc_size(2, 3)
{
	...
}

Maybe this? I find it weird still:

__must_check static inline void *krealloc_array(void *p, size_t new_n,
						size_t new_size, gfp_t flags)
						__alloc_size(2, 3)
{
	...
}

-- 
Kees Cook
