Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F8BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 19:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743D560E54
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 19:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhIJTud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 15:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJTuc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 15:50:32 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213E7C061762
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:49:21 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id i28so4956625ljm.7
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 12:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GN80YMAl1pIDXe7DGEZBk2ixhfr92aqiNjP2rTtktow=;
        b=VrIWHd9zX+z/Bt8qhmJLxwhXLsSmMpb5HTPD6Aiz8jfHHtTUEtE0mkTgf7qj7VHubp
         3P4eltXAuhHbS/cA+4h2VyZb3T0p+2QF4kDk8AnfDShf05as/Pdv9nh3Olt5MwuYyHj7
         Sp8n+WG/xfOzb7Z+Oi7hvJ93DjSZpGCB4IIFeOUNfJ7NSV7D42WG+DiVBqMtiN/deCUr
         /2C7CUV+Jtc/wCoWuf4Zjkz/z4hNVPLaR6HYIR8amSyhrVs/f/tYROHBsqg71DniXvSU
         G5Wapit+FV0hUXgghiY0zGBiCjFld0d1ZJ/ijldbBZmmIXclNJRa3NMOU0zrQKUWW2q1
         dZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GN80YMAl1pIDXe7DGEZBk2ixhfr92aqiNjP2rTtktow=;
        b=FXcbUyD6FXyUrVCr901XGds6bSgrJQWOquQ6/MWkTd0HsSF7HESk0+gTx1yMKTzEA6
         z2S4uxPlE/tmWJKPxLU5QjlTuBdlj6f7k2qU8a6zD8WP9WDdaeLnK2sPtJtunkKdoZav
         p/hJlt93e48kyloUue5mJeL3g+8+Qeh8qIxutNRsS9DqlVZp1RcgMRSv5i9ZylGrDXYM
         Q3iQpmmKE5qKUdXoEEV0haXjZKjuZosx+m3o82DM7FtmO5/fvSuTK5aXrTq8MGkNGGrb
         Fh+SptQsjixBSQstSJ0cishvBpByF85bA+Rb8HcAHlA9tF2AfZsxdmb+IdXE9Y+7ltfR
         hMyg==
X-Gm-Message-State: AOAM532fzV209jzRcS9P5q/ywnrRMCgNX/j42IZeEmXJD45x5yRpff6C
        gEy08G40Nxc9LJzRLOQGLGM54Z7kaguFpdFD9U8ogg==
X-Google-Smtp-Source: ABdhPJxwTNhBoufvxArxxeBrmLxqq5WMeCXnPZLFRdIv0bH95PUKM8LahYoXspk9rANHib3uaORJqtM9SCT5hY1Sta8=
X-Received: by 2002:a2e:99da:: with SMTP id l26mr5248054ljj.339.1631303359314;
 Fri, 10 Sep 2021 12:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org> <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 10 Sep 2021 12:49:08 -0700
Message-ID: <CAKwvOd=quUcE8UBcwD6Hjs40LNKodHEwAfqt=_OjNdwYM19LOA@mail.gmail.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
To:     Linus Torvalds <torvalds@linux-foundation.org>
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

On Fri, Sep 10, 2021 at 10:24 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > +__alloc_size(1)
> >  extern void *vmalloc(unsigned long size);
> [...]
>
> All of these are added in the wrong place

Huh?
$ grep -rn __always_inline
$ grep -rn noinline
$ grep -rn __cold
...

Not that we have explicit guidance here in any coding style guide,
perhaps we can make a clarification in
Documentation/process/coding-style.rst?

I'd say when using function attributes, we tend to have the linkage
(ie. explicitly static or implicitly extern), followed by function
attributes related to inlining (__always_inline, noinline), followed
by return type, followed by function level attributes, followed by
parameter list. But I don't think we're even internally consistent
here.
-- 
Thanks,
~Nick Desaulniers
