Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18A7C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 21:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E75233CF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 21:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbhAGVKM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 16:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGVKL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2021 16:10:11 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BD7C0612F5
        for <mm-commits@vger.kernel.org>; Thu,  7 Jan 2021 13:09:31 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id z21so5971781pgj.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Jan 2021 13:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Y1RsUOGhOKBGEt5+SzDxuGmeM89Q25Gimct2MecP3Y=;
        b=MDkslH6jbIYHI7bxPEVTXGP6IKo6Ggk+b/7HwmuJIhqdxkbi3Kw6+oZr6wqBfIBffn
         b4PVaZxXqWgyKYlzXToiZzjsWfgHlRn4fpkt48a0KziFPiyQ1D7vSkc0jO2lEV8oU650
         jy9jEKI168+o81Rqd7zRPUJHHD7iFOoER4VG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Y1RsUOGhOKBGEt5+SzDxuGmeM89Q25Gimct2MecP3Y=;
        b=sRomn08bl0aaWwoWdl7eAyT2Bn4ea8dYu3IRuLqQP2q/1gluWP0vY3HZiDy+Np9Y6i
         Seij3qGU5rxLBRvahTKRZIrwzUv2JETDgQTwhWBQQiHncpVktNUPUtJYSXTZH+L2wat6
         EUlLwaOrVEOSmmnVZUreCjKu21FsV6ohazMD/VgrPM9iEgSd+Wa3JBzbTU6vDTBh6c8w
         WInmgdioDjYdi4ExQi/20FNN8ebWhpbwJNAopJSYrGP+J2T3pr658z5M5ooxItQKlEnw
         rHwVJP+VGzD4OQYTfsj2yoaRvl4IFQUJu+pjKKKmXY9rs9tiCXFGSGiJcrh10O3CuuZM
         lG3g==
X-Gm-Message-State: AOAM530U0wdXTQMyZxoKfMICRxgCJOQPU7Prt3dkKyjl/hJymQp0kAI8
        eGQ/mK2zEonM4YI7nUcKvN8YFA==
X-Google-Smtp-Source: ABdhPJwznV9mmUQhtAFw8HaW0QnWtAsibl0eaySkBEgHDaTqjkm3RGMNEma9rPFV0p8ySwelss6ezA==
X-Received: by 2002:a63:f016:: with SMTP id k22mr3688403pgh.233.1610053770982;
        Thu, 07 Jan 2021 13:09:30 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a22sm6720016pfg.49.2021.01.07.13.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:09:29 -0800 (PST)
Date:   Thu, 7 Jan 2021 13:09:29 -0800
From:   Kees Cook <keescook@chromium.org>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, elver@google.com, georgepope@android.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sfr@canb.auug.org.au
Subject: Re: [folded-merged]
 ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
 removed from -mm tree
Message-ID: <202101071308.8854B1428B@keescook>
References: <20210107003426.Bqzd_O7Lf%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107003426.Bqzd_O7Lf%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jan 06, 2021 at 04:34:26PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
> has been removed from the -mm tree.  Its filename was
>      ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
> 
> This patch was dropped because it was folded into ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang.patch
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
> 
> fix comment typo, per Nathan
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: George Popescu <georgepope@android.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Nathan Chancellor <natechancellor@gmail.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/Kconfig.ubsan |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/lib/Kconfig.ubsan~ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
> +++ a/lib/Kconfig.ubsan
> @@ -122,7 +122,7 @@ config UBSAN_SIGNED_OVERFLOW
>  
>  config UBSAN_UNSIGNED_OVERFLOW
>  	bool "Perform checking for unsigned arithmetic overflow"
> -	# clang hugely expands stack usage with -fsanitize=object-size
> +	# clang hugely expands stack usage with -fsanitize=unsigned-integer-overflow
>  	depends on !CC_IS_CLANG

The above "!CC_IS_CLANG" needs to be dropped. I makes it impossible to use at
all (unsigned UBSAN overflow is only implemented for Clang).

-Kees

>  	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
>  	help
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
> ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang.patch
> mm.patch
> mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
> mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
> kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
> mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
> mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
> kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
> set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
> arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> 

-- 
Kees Cook
