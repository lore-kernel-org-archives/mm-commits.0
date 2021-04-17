Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFA1C433ED
	for <mm-commits@archiver.kernel.org>; Sat, 17 Apr 2021 00:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5029A6137D
	for <mm-commits@archiver.kernel.org>; Sat, 17 Apr 2021 00:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhDQAqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 20:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhDQAqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 20:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2121E6137D
        for <mm-commits@vger.kernel.org>; Sat, 17 Apr 2021 00:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618620341;
        bh=lSsnVay0rJWW6MjOZqm8flZ5I5tTGTUG6tF6O4/guDA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Tyv15qdH10P1CX6MbjYxxWSCqw5E01W2VOrmv7oxnMSFEyrN594lfuz1l1Gqm+Vs7
         Fd8Gsblu5fVfeV+VN1cKQjdBPgmKMWMDmoAKoBKsKlHLs7Y0z7k4MoUvKmMb92cWCY
         8aYrmnsrlVQ2SoPNccRHTqzaMqOalPEVxh5qTg7s9Fel1Wkwu82xZTgKwVqaoww9xF
         a4CsmFbugxLQ/D7PtA08djX+zRO3ras027Sws6GUYBRezPFsFuuHVFi30uDvoS0miq
         W56AOUDHwXTZbSxoPOuryGKbCRxdZww3pjQ36TYMbPZXbnKkTcb/U1iczhb1wD0AoC
         fLxBkx4jPNXLQ==
Received: by mail-lf1-f50.google.com with SMTP id f17so40377766lfu.7
        for <mm-commits@vger.kernel.org>; Fri, 16 Apr 2021 17:45:41 -0700 (PDT)
X-Gm-Message-State: AOAM530OK7Gwuhy30s1fDlRRoydCI5s5jrbmoQV4VpGPyuKYq3zQ+bUt
        34zCd2HsUPxm/bs8TwkU4BKA1wC0yl58uPtGm5I=
X-Google-Smtp-Source: ABdhPJz32kliawinOEuXKfgFPcpC2BEqt0tlvGESX2Sa34wzDqUIxi1I5niUwnf7/+B9QQghlWUZT+Px75+KnnGukc4=
X-Received: by 2002:a05:6512:3f02:: with SMTP id y2mr4737601lfa.355.1618620339526;
 Fri, 16 Apr 2021 17:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org> <20210416224603.EETOY2Or4%akpm@linux-foundation.org>
In-Reply-To: <20210416224603.EETOY2Or4%akpm@linux-foundation.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Sat, 17 Apr 2021 08:45:28 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTDzXPqmwTiyESzwwbJFsAZpnhSY9UqvXvvkY51WusGBA@mail.gmail.com>
Message-ID: <CAJF2gTTDzXPqmwTiyESzwwbJFsAZpnhSY9UqvXvvkY51WusGBA@mail.gmail.com>
Subject: Re: [patch 04/12] csky: change a Kconfig symbol name to fix e1000
 build error
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kbuild test robot <lkp@intel.com>,
        mm-commits@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Looks good to me, I'll approve it in my linux-next tree.

On Sat, Apr 17, 2021 at 6:46 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: csky: change a Kconfig symbol name to fix e1000 build error
>
> e1000's #define of CONFIG_RAM_BASE conflicts with a Kconfig symbol in
> arch/csky/Kconfig.
>
> The symbol in e1000 has been around longer, so change arch/csky/ to use
> DRAM_BASE instead of RAM_BASE to remove the conflict.  (although e1000 is
> also a 2-line change)
>
> Link: https://lkml.kernel.org/r/20210411055335.7111-1-rdunlap@infradead.org
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Acked-by: Guo Ren <guoren@kernel.org>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/csky/Kconfig            |    2 +-
>  arch/csky/include/asm/page.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> --- a/arch/csky/include/asm/page.h~csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error
> +++ a/arch/csky/include/asm/page.h
> @@ -28,7 +28,7 @@
>  #define SSEG_SIZE      0x20000000
>  #define LOWMEM_LIMIT   (SSEG_SIZE * 2)
>
> -#define PHYS_OFFSET_OFFSET (CONFIG_RAM_BASE & (SSEG_SIZE - 1))
> +#define PHYS_OFFSET_OFFSET (CONFIG_DRAM_BASE & (SSEG_SIZE - 1))
>
>  #ifndef __ASSEMBLY__
>
> --- a/arch/csky/Kconfig~csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error
> +++ a/arch/csky/Kconfig
> @@ -314,7 +314,7 @@ config FORCE_MAX_ZONEORDER
>         int "Maximum zone order"
>         default "11"
>
> -config RAM_BASE
> +config DRAM_BASE
>         hex "DRAM start addr (the same with memory-section in dts)"
>         default 0x0
>
> _



-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
