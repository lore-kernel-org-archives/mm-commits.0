Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCFDC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 10:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiERKX4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 06:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbiERKXz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 06:23:55 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16832107899
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 03:23:51 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2fee010f509so18777547b3.11
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 03:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SbzA0OtJpvtgSSkdGAox6Y9VkOUJy09Dxq3y6E7WHn8=;
        b=gPfq+PfsTZuYEqluWB014sLR3+baCmLjXOB6WXgmX0lzBlxTr7Tf9oibahczg+DJ0r
         g8wQTZoa+Hp4yx+11Hd/asq2UOUlKUfBqcLcZrnx/BDNWSDOGBNPJzPYLedbRnQSSqxV
         ZjM7Hn2TZ4bZyTjFGk+t1owPyqM5AZ2dtaW0IaYtwl2OGeIgwso4WrNWqeZBNk7hh1Sk
         Hq9yKZMgm2VJI2iBfHPlOQlqcKillAWCc1skgAyTDfFBbxnqA0FIGisTk17d/S3RrLHk
         AaD64VUhNKRhqVHNt8rnzVQ3L+hXXNUsCN3aAPn4TnHcp1o1S/NYTHKmzvVGu/Giugj6
         CSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SbzA0OtJpvtgSSkdGAox6Y9VkOUJy09Dxq3y6E7WHn8=;
        b=jsDOfyqyhLofIiXth63RTgcZc4Adj56veOfDj8E/1RwCSG4fk6kT7m5jiv/QqIVY1z
         j36ewBIORut/2sk/GXGIibP50WWJKRSqgU65lM259UTFi1xeHhhInv1rVixKwg+GevVZ
         B30a58hxLKMGPGdN+frpygDaxwQcPJUFR2WVT5XNKz2Pi4OYXTu5s0ctukEZ+nfKR5fg
         uBRM7yAliQ2Rv336BV/WmMWSSLVf7GPyZ+k01wCB5asmYAmJH7d9dpKTSw1y44jECtTv
         ZS1v/gN268h2JBiFo11Rc7j324p3cA7Fw24ETILdUU3jmqTiiOM4F1zWHKLSO1D9wS1M
         c0gw==
X-Gm-Message-State: AOAM533akAeJzclNcaZfNEJD+2YTB53ui2vIE7qesMTsDIdgJjERwT8p
        XdtufoNOheT3IjUQzaknbJhRPzgjTkst2JUMyJxOfw==
X-Google-Smtp-Source: ABdhPJwTIKMszr+F52SXbr5QbmFf7LIfXfRHpqjVxVhkikjUliF7UzjA5mLG/MBjSP1clEwzK7WIE8jXhi1zci+d+24=
X-Received: by 2002:a0d:eacc:0:b0:2ff:3990:c6c3 with SMTP id
 t195-20020a0deacc000000b002ff3990c6c3mr4702104ywe.141.1652869430150; Wed, 18
 May 2022 03:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220517173936.E461AC34116@smtp.kernel.org>
In-Reply-To: <20220517173936.E461AC34116@smtp.kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 May 2022 15:53:39 +0530
Message-ID: <CA+G9fYv3EFOt4h2bDxHUNmSYfbK3yVGvLcHprNBUuHT1u2Ax2A@mail.gmail.com>
Subject: Re: + maple-tree-add-new-data-structure-fix-3.patch added to
 mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkft@linaro.org,
        Liam.Howlett@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

Please ignore my previous email.
It was another bug context.

This patch has been applied and tested
LTP sched test cases on x86 and the reported bug fixed.

> From: Liam Howlett <liam.howlett@oracle.com>
> Subject: maple_tree: fix 32b parent pointers
> Date: Tue, 17 May 2022 15:22:20 +0000
>
> 32 bit parent pointers need an extra bit to account for increased slot
> count.  Update the constants and documentation to use the remaining high
> bit.
>
> Link: https://lkml.kernel.org/r/20220517152209.3486724-1-Liam.Howlett@oracle.com
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

> ---
>
>  include/linux/maple_tree.h |    2 +-
>  lib/maple_tree.c           |   14 +++++++-------
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> --- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix-3
> +++ a/include/linux/maple_tree.h
> @@ -37,7 +37,7 @@
>  #define MAPLE_NODE_SLOTS       63      /* 256 bytes including ->parent */
>  #define MAPLE_RANGE64_SLOTS    32      /* 256 bytes */
>  #define MAPLE_ARANGE64_SLOTS   21      /* 240 bytes */
> -#define MAPLE_ARANGE64_META_MAX        22      /* Out of range for metadata */
> +#define MAPLE_ARANGE64_META_MAX        31      /* Out of range for metadata */
>  #define MAPLE_ALLOC_SLOTS      (MAPLE_NODE_SLOTS - 2)
>  #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
>
> --- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-3
> +++ a/lib/maple_tree.c
> @@ -354,7 +354,7 @@ static inline bool mt_is_alloc(struct ma
>  /*
>   * The Parent Pointer
>   * Excluding root, the parent pointer is 256B aligned like all other tree nodes.
> - * When storing a 32 or 64 bit values, the offset can fit into 4 bits.  The 16
> + * When storing a 32 or 64 bit values, the offset can fit into 5 bits.  The 16
>   * bit values need an extra bit to store the offset.  This extra bit comes from
>   * a reuse of the last bit in the node type.  This is possible by using bit 1 to
>   * indicate if bit 2 is part of the type or the slot.
> @@ -366,19 +366,19 @@ static inline bool mt_is_alloc(struct ma
>   *  0x110 = 64 bit nodes
>   *
>   * Slot size and alignment
> - *  0x??1 : Root
> - *  0x?00 : 16 bit values, type in 0-1, slot in 2-6
> - *  0x010 : 32 bit values, type in 0-2, slot in 3-6
> - *  0x110 : 64 bit values, type in 0-2, slot in 3-6
> + *  0b??1 : Root
> + *  0b?00 : 16 bit values, type in 0-1, slot in 2-7
> + *  0b010 : 32 bit values, type in 0-2, slot in 3-7
> + *  0b110 : 64 bit values, type in 0-2, slot in 3-7
>   */
>
>  #define MAPLE_PARENT_ROOT              0x01
>
>  #define MAPLE_PARENT_SLOT_SHIFT                0x03
> -#define MAPLE_PARENT_SLOT_MASK         0x78
> +#define MAPLE_PARENT_SLOT_MASK         0xF8
>
>  #define MAPLE_PARENT_16B_SLOT_SHIFT    0x02
> -#define MAPLE_PARENT_16B_SLOT_MASK     0x7C
> +#define MAPLE_PARENT_16B_SLOT_MASK     0xFC
>
>  #define MAPLE_PARENT_RANGE64           0x06
>  #define MAPLE_PARENT_RANGE32           0x04
> _
>
> Patches currently in -mm which might be from liam.howlett@oracle.com are
>
> maple-tree-add-new-data-structure-fix.patch
> maple-tree-add-new-data-structure-fix-2.patch
> maple-tree-add-new-data-structure-fix-3.patch
> lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
> mm-start-tracking-vmas-with-maple-tree-fix-2.patch
> mm-remove-the-vma-linked-list-fix.patch
>
