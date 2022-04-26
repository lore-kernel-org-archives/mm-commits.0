Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF7FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 21:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355329AbiDZVVb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355336AbiDZVVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 17:21:30 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64FBC8676
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 14:18:21 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s137so17072265pgs.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 14:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4wpDWrAiyVwaLwgVD2UTFMv3kWLHoVa/Eh2YuwuZuMo=;
        b=YD5AbAwJM2HmILQx2FMs8lkfGHNHuMC6gc8fUpgiyr6+60HnRwQezLbprcDiq0Rr9l
         TCdm62iXqWlF2/bFPvZe1EcCVmB6ylkclBN/BWcpWizwZDOn8jVgRSxOgX0chBrCmkc8
         F0URaXS7mdA12qFrwUfw/Jo5qShtzDgqI8WC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4wpDWrAiyVwaLwgVD2UTFMv3kWLHoVa/Eh2YuwuZuMo=;
        b=4bVkQiFpetWCbfXB2huX3k1shrHz2QC2vvLW3gDDIYJ9Kt8DVMRceOrePKaiamjv6I
         ZmknPDXm1pj7MQMumqM46Mp3ewvw/gijj8fA8FZ0KQynvvTJifqZbFXUjriaBlcLOUHa
         l4ihMslfjrDmgpW6T38O8XvxqKzH9xguuHPVmgWQB7TRsnOb8f0wN1mFB7zNisTkoEfc
         81NpY3JdHQ0+4A+BOA8Js8kyfKo+fua/17CPbMnGl2jz1NSEdsn6yv3BBXubqjDC9sG3
         2troLx3jxnwYiQ9JfPQh4FSYbPovX8vK8DWMV0+BSHnYNphhBcucSibEIyOPfT50Rw2v
         KV8A==
X-Gm-Message-State: AOAM532eKapth38Ea9ejzcAf5YrEpSSkcpjscJQd0uJpU02C2lDysmxB
        wUA8FymTYiatwSPiJex1mCHKhg==
X-Google-Smtp-Source: ABdhPJzcxRg9Seek6FcEFVmYdF+fgH4OX0DHY+CW78zJSWMqp5K5uXXQ8q3ufVlOhcVb4wTI8HG89g==
X-Received: by 2002:a05:6a00:a85:b0:4e0:57a7:2d5d with SMTP id b5-20020a056a000a8500b004e057a72d5dmr26364433pfl.81.1651007901273;
        Tue, 26 Apr 2022 14:18:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm13663256pgn.72.2022.04.26.14.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 14:18:20 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:18:20 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, will@kernel.org, luto@kernel.org,
        catalin.marinas@arm.com, alex.popov@linux.com, mark.rutland@arm.com
Subject: Re: + arm64-entry-use-stackleak_erase_on_task_stack.patch added to
 -mm tree
Message-ID: <202204261417.41B52508@keescook>
References: <20220426205142.13A38C385A0@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426205142.13A38C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi,

I don't think these should be applied to -mm. They would normally go via
my hardening tree (with other gcc plugins), but also Mark is going to be
spinning a v2...

-Kees

On Tue, Apr 26, 2022 at 01:51:41PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: arm64: entry: use stackleak_erase_on_task_stack()
> has been added to the -mm tree.  Its filename is
>      arm64-entry-use-stackleak_erase_on_task_stack.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/arm64-entry-use-stackleak_erase_on_task_stack.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/arm64-entry-use-stackleak_erase_on_task_stack.patch
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
> From: Mark Rutland <mark.rutland@arm.com>
> Subject: arm64: entry: use stackleak_erase_on_task_stack()
> 
> On arm64 we always call stackleak_erase() on a task stack, and never call
> it on another stack.  We can avoid some redundant work by using
> stackleak_erase_on_task_stack(), telling the stackleak code that it's
> being called on a task stack.
> 
> Link: https://lkml.kernel.org/r/20220425115603.781311-9-mark.rutland@arm.com
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Popov <alex.popov@linux.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/arm64/kernel/entry.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/arm64/kernel/entry.S~arm64-entry-use-stackleak_erase_on_task_stack
> +++ a/arch/arm64/kernel/entry.S
> @@ -596,7 +596,7 @@ SYM_CODE_START_LOCAL(ret_to_user)
>  	ldr	x19, [tsk, #TSK_TI_FLAGS]	// re-check for single-step
>  	enable_step_tsk x19, x2
>  #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> -	bl	stackleak_erase
> +	bl	stackleak_erase_on_task_stack
>  #endif
>  	kernel_exit 0
>  SYM_CODE_END(ret_to_user)
> _
> 
> Patches currently in -mm which might be from mark.rutland@arm.com are
> 
> arm64-stackleak-fix-current_top_of_stack.patch
> stackleak-move-skip_erasing-check-earlier.patch
> stackleak-rework-stack-low-bound-handling.patch
> stackleak-clarify-variable-names.patch
> stackleak-rework-stack-high-bound-handling.patch
> stackleak-remove-redundant-check.patch
> stackleak-add-on-off-stack-variants.patch
> arm64-entry-use-stackleak_erase_on_task_stack.patch
> 

-- 
Kees Cook
