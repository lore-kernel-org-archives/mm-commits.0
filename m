Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9146AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 17:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7599E60FDA
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 17:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhIJRNG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 13:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhIJRNG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 13:13:06 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F2DC061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 10:11:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s29so2421026pfw.5
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 10:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BUpOKTpeqGBNXiZgSUJzUGs/3KYllh5vEBA+EMKJvM4=;
        b=S7ZkT1nca1Uk/UsTmjpNinLLpdDgZzaOJrjpC3WdL2jxh5+T4cNruI2wzflvYHvBNz
         Ol+ZEr2IK6tfPyuJtTOYvJ7y532OJP8+ZRdpdS4uIO0iPE+bndcMaFfPtDVQbC02FMEP
         8QVyBgEvJiLdix9uwBA14mEfTS0nOYZJQ8gbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BUpOKTpeqGBNXiZgSUJzUGs/3KYllh5vEBA+EMKJvM4=;
        b=eay9NCfu+3vRsp1A/El9GqM8Uqe+OED2fK43STZaYwgzyh3YyVxwHk2WjwiOqRIl9Y
         LmX/EPnVbqwtqgqiuQY1ZYVxPSesGYmCTnO3UHgFcVXUzETuY+jdK4KQNTVnDpzEJ2yq
         fx9G8nvMIZ4gjmVi0+iE9wm5ighUivkm4mO3NH4ot9NUijEF3Pmy+Tm0FmvYpYTfRJee
         H+vBj9wCMsKiZvwa8Q6dOkeiA6xBx6htSiyw+B+iECDN7iawz3Trtsj6fsB7ZTw4a+I0
         tfZLDUaYKd63DkzEqV6SNz4Q4+sXp3StfNR9C/Rs1D+HDS7JF6aTgFCZEo14AzZ/P9Ss
         rbVg==
X-Gm-Message-State: AOAM532RSNXGlUKAmcpnXpiYzvNB1mVRsL31N1dsUDlWB7i0VtVJb+yp
        G82+UGJHiYaka9AUgWqKCnM6BVKt9piOsg==
X-Google-Smtp-Source: ABdhPJyim91Duw3Gai6L8yOIdq80u03yzLvVtaZRigmmySbYFZ9pRl8adNetZCMdPRXTacUVd9Jw0g==
X-Received: by 2002:a63:5902:: with SMTP id n2mr8195073pgb.305.1631293915032;
        Fri, 10 Sep 2021 10:11:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h24sm5595297pfn.180.2021.09.10.10.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:11:54 -0700 (PDT)
Date:   Fri, 10 Sep 2021 10:11:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: Re: incoming
Message-ID: <202109101009.13A90EBB6@keescook>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 09, 2021 at 08:09:48PM -0700, Andrew Morton wrote:
> 
> More post linux-next material.
> 
> 9 patches, based on f154c806676ad7153c6e161f30c53a44855329d6.
> 
> Subsystems affected by this patch series:
> 
>   mm/slab-generic
>   rapidio
>   mm/debug
> 
> Subsystem: mm/slab-generic
> 
>     "Matthew Wilcox (Oracle)" <willy@infradead.org>:
>       mm: move kvmalloc-related functions to slab.h
> 
> Subsystem: rapidio
> 
>     Kees Cook <keescook@chromium.org>:
>       rapidio: avoid bogus __alloc_size warning
> 
> Subsystem: mm/debug
> 
>     Kees Cook <keescook@chromium.org>:
>     Patch series "Add __alloc_size() for better bounds checking", v2:
>       Compiler Attributes: add __alloc_size() for better bounds checking
>       checkpatch: add __alloc_size() to known $Attribute
>       slab: clean up function declarations
>       slab: add __alloc_size attributes for better bounds checking
>       mm/page_alloc: add __alloc_size attributes for better bounds checking
>       percpu: add __alloc_size attributes for better bounds checking
>       mm/vmalloc: add __alloc_size attributes for better bounds checking

Hi,

FYI, in overnight build testing I found yet another corner case in
GCC's handling of the __alloc_size attribute. It's the gift that keeps
on giving. The fix is here:

https://lore.kernel.org/lkml/20210910165851.3296624-1-keescook@chromium.org/

> 
>  Makefile                                 |   15 +++
>  drivers/of/kexec.c                       |    1 
>  drivers/rapidio/devices/rio_mport_cdev.c |    9 +-
>  include/linux/compiler_attributes.h      |    6 +
>  include/linux/gfp.h                      |    2 
>  include/linux/mm.h                       |   34 --------
>  include/linux/percpu.h                   |    3 
>  include/linux/slab.h                     |  122 ++++++++++++++++++++++---------
>  include/linux/vmalloc.h                  |   11 ++
>  scripts/checkpatch.pl                    |    3 
>  10 files changed, 132 insertions(+), 74 deletions(-)
> 

-- 
Kees Cook
