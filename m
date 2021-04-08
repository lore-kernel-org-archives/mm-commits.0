Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BC2C433ED
	for <mm-commits@archiver.kernel.org>; Thu,  8 Apr 2021 03:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B44B61186
	for <mm-commits@archiver.kernel.org>; Thu,  8 Apr 2021 03:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHDUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Apr 2021 23:20:38 -0400
Received: from condef-01.nifty.com ([202.248.20.66]:34742 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhDHDUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2021 23:20:37 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 23:20:37 EDT
Received: from conssluserg-03.nifty.com ([10.126.8.82])by condef-01.nifty.com with ESMTP id 1383B2O6031642
        for <mm-commits@vger.kernel.org>; Thu, 8 Apr 2021 12:11:02 +0900
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 1383AoaK002408
        for <mm-commits@vger.kernel.org>; Thu, 8 Apr 2021 12:10:50 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 1383AoaK002408
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1617851451;
        bh=mUb8/zLH4VLUU0o6DqASQLvb+JkMA87rrcoXLn9WYn4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E+fY//dKZkO8h8PUgMjgC7f2ugQc+hJLiLRg4TC9P4F2hlrQmc3NILrvBSb3pYUwl
         b6hl8UHqJ9wS9L2MsvxUQkpRnp1SbyWS7sfwoNqccUGsYHhTUxfh0a9EGID8LCUq1d
         tMMzZzXFFIF6gS5vermgR2aKgzR/H0XPVtOdBgciyCi9D9TZNg13lrHPFrNgDZv8Q8
         VsdwORq/1UvnvWESYusSZdbP5DlBt6HfbkEKkMhqSl9t/hRlxdrNi5sUj3xCI8wOfN
         +jADiBf+9HsGGUTNpMnEkOeIk2aWkLvyui6Sf7yMZ1U8P21DyT6/GpwKZ+HGEJ+Eyw
         s6E+IGsdqlo2Q==
X-Nifty-SrcIP: [209.85.216.46]
Received: by mail-pj1-f46.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso2352659pji.3
        for <mm-commits@vger.kernel.org>; Wed, 07 Apr 2021 20:10:50 -0700 (PDT)
X-Gm-Message-State: AOAM531thI0MyPgHNKarqErxuVKQXq6Jjv1RNi6OtbuFko6KiZSOTES4
        x69lr/n8edRvZBc67zs6e3N/TBSV0zV0HbmCKmA=
X-Google-Smtp-Source: ABdhPJzKZhP/k+T5w/ORZAB1NJNpyzFWIZp8RMgrJ2cGWktMR3NUR6uzG/NwSmqU/N5kKvMejTdAy6ZvJsz/cpGbukc=
X-Received: by 2002:a17:90a:28a1:: with SMTP id f30mr6322421pjd.198.1617851449895;
 Wed, 07 Apr 2021 20:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210331045326.9oHKzEL-X%akpm@linux-foundation.org>
In-Reply-To: <20210331045326.9oHKzEL-X%akpm@linux-foundation.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 8 Apr 2021 12:10:12 +0900
X-Gmail-Original-Message-ID: <CAK7LNATy5CTU=GSjwRFbCa-1Jv2kH70aADYOY3zARv++2xoqug@mail.gmail.com>
Message-ID: <CAK7LNATy5CTU=GSjwRFbCa-1Jv2kH70aADYOY3zARv++2xoqug@mail.gmail.com>
Subject: Re: + init-add-support-for-zstd-compressed-modules.patch added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Piotr Gorski <lucjan.lucjanov@gmail.com>,
        mm-commits@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 31, 2021 at 1:53 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: init: add support for zstd compressed modules
> has been added to the -mm tree.  Its filename is
>      init-add-support-for-zstd-compressed-modules.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/init-add-support-for-zstd-compressed-modules.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/init-add-support-for-zstd-compressed-modules.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Piotr Gorski <lucjan.lucjanov@gmail.com>
> Subject: init: add support for zstd compressed modules
>
> kmod 28 supports modules compressed in zstd format so let's add this
> possibility to kernel.
>
> Requires this update to mkinitcpio:
> https://github.com/archlinux/mkinitcpio/pull/43
>
> Link: https://lkml.kernel.org/r/20210330113235.2767216-1-lucjan.lucjanov@gmail.com
> Signed-off-by: Piotr Gorski <lucjan.lucjanov@gmail.com>
> Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


I applied v3 to the kbuild tree.






> ---
>
>  Makefile     |    7 +++++--
>  init/Kconfig |    9 ++++++---
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> --- a/init/Kconfig~init-add-support-for-zstd-compressed-modules
> +++ a/init/Kconfig
> @@ -2222,8 +2222,8 @@ config MODULE_COMPRESS
>         bool "Compress modules on installation"
>         help
>
> -         Compresses kernel modules when 'make modules_install' is run; gzip or
> -         xz depending on "Compression algorithm" below.
> +         Compresses kernel modules when 'make modules_install' is run; gzip,
> +         xz, or zstd depending on "Compression algorithm" below.
>
>           module-init-tools MAY support gzip, and kmod MAY support gzip and xz.
>
> @@ -2245,7 +2245,7 @@ choice
>           This determines which sort of compression will be used during
>           'make modules_install'.
>
> -         GZIP (default) and XZ are supported.
> +         GZIP (default), XZ, and ZSTD are supported.
>
>  config MODULE_COMPRESS_GZIP
>         bool "GZIP"
> @@ -2253,6 +2253,9 @@ config MODULE_COMPRESS_GZIP
>  config MODULE_COMPRESS_XZ
>         bool "XZ"
>
> +config MODULE_COMPRESS_ZSTD
> +       bool "ZSTD"
> +
>  endchoice
>
>  config MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS
> --- a/Makefile~init-add-support-for-zstd-compressed-modules
> +++ a/Makefile
> @@ -1066,8 +1066,8 @@ endif # INSTALL_MOD_STRIP
>  export mod_strip_cmd
>
>  # CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
> -# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
> -# or CONFIG_MODULE_COMPRESS_XZ.
> +# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP,
> +# CONFIG_MODULE_COMPRESS_XZ, or CONFIG_MODULE_COMPRESS_ZSTD.
>
>  mod_compress_cmd = true
>  ifdef CONFIG_MODULE_COMPRESS
> @@ -1077,6 +1077,9 @@ ifdef CONFIG_MODULE_COMPRESS
>    ifdef CONFIG_MODULE_COMPRESS_XZ
>      mod_compress_cmd = $(XZ) --lzma2=dict=2MiB -f
>    endif # CONFIG_MODULE_COMPRESS_XZ
> +  ifdef CONFIG_MODULE_COMPRESS_ZSTD
> +    mod_compress_cmd = $(ZSTD) -T0 --rm -f -q
> +  endif # CONFIG_MODULE_COMPRESS_ZSTD
>  endif # CONFIG_MODULE_COMPRESS
>  export mod_compress_cmd
>
> _
>
> Patches currently in -mm which might be from lucjan.lucjanov@gmail.com are
>
> init-add-support-for-zstd-compressed-modules.patch
>


-- 
Best Regards
Masahiro Yamada
