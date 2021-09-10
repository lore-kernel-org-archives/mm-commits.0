Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2840C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 17:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 992786120E
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 17:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhIJRZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 13:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhIJRZW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 13:25:22 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211F6C061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 10:24:11 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id m4so4354950ljq.8
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 10:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cypChv/ZPiPPdnrzU87mN4Ofl9d96gkwlfzVA4NlYRI=;
        b=J/bQOCMoNtLuqW1QBFpH98vDNeU4z7eQMVuPv+gzD0eb/B0ZmfYgKYurss1AMLET2j
         ZfqLEb20lguxzxEeNXsA5k/K/NNjUAmmcWmOBzDyNrsfAvq3rLtxFxCABcuBCZ6StP+6
         iWWPm5KB/AEgaz9NOFyOYsUpcxuR00kIdIe44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cypChv/ZPiPPdnrzU87mN4Ofl9d96gkwlfzVA4NlYRI=;
        b=PzNiU+pXm8oilZBPXRpRaEeCjbQMwXLWD7xttUsXjcXXFtCkj4Zyu3HHMsXVSl5gMk
         RTax27aQF62TbvN5XTOdvPVwowTnoG59xIbZ5CKQveVZqpqp3xZh5XAciwqoLeasPdKm
         iVlnKmM+H1Zn/nj1R5cq36JNaYKQtSppDrKJAlRDp8ucA7BZ7tj+yAB6Zg5fJe/vSDki
         Gxs9vOZHYhuLRGAnOJcGS4ScmGE9/YMlewZEHWi6DFSjIBBoN7UCX4OcC+7seg/8D926
         N32Uw/O2Y0WDxeUfFjNA+5Sf9e1+557mZfemHrynFM5s2xZYOiqmXQYjEzuUm5cEqFUL
         koiA==
X-Gm-Message-State: AOAM531FiJx/lSghSjI32y5h3DYaoHPy1Lcr8C0ii9BJvA20xoJUQMAN
        HUgwRVSw2m6dWbIAuos0hlBltLBgKjpsrEm1
X-Google-Smtp-Source: ABdhPJwG35X46CI7fDiL+idl8MgcS8bgXCceA4g96NmZiV9/X4RDOlMXxuhXf4NLxrTvs747y8YAoA==
X-Received: by 2002:a2e:bf03:: with SMTP id c3mr4894528ljr.513.1631294648785;
        Fri, 10 Sep 2021 10:24:08 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id q17sm614804lfo.232.2021.09.10.10.24.04
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 10:24:05 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id h16so5470436lfk.10
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 10:24:04 -0700 (PDT)
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr4883348lfg.150.1631294644229;
 Fri, 10 Sep 2021 10:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org> <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
In-Reply-To: <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Sep 2021 10:23:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
Message-ID: <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     apw@canonical.com, Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>,
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

On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> +__alloc_size(1)
>  extern void *vmalloc(unsigned long size);
[...]

All of these are added in the wrong place - inconsistent with the very
compiler documentation the patches add.

The function attributes are generally added _after_ the function,
although admittedly we've been quite confused here before.

But the very compiler documentation you point to in the patch that
adds these macros gives that as the examples both for gcc and clang:

+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size

and honestly I think that is the preferred format because this is
about the *function*, not about the return type.

Do both placements work? Yes.

Have we been confused about this before? Yes. I note that our __printf
attributes in particular have been added in odd places. And our
existing __malloc annotations seem to correct in <linux/slab.h> and
<linux/device.h> but then randomly applied in some other places.

I really think it's pointlessly stupid and hard to read/grep for to
make it be a separate line before the whole thing.

I also think it should have taken over the "__malloc" name that is
almost unused right now. Because why would you ever have
__alloc_size() without having __malloc().

So wouldn't this all have looked much more natural as

     void *vmalloc(unsigned long size) __malloc(1);

instead? Hmm?

              Linus
