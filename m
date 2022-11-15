Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D1FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 23:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKOXOG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKOXNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 18:13:53 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C4921B5
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 15:13:28 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-13bd19c3b68so18081354fac.7
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 15:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6M/FJ5paQRaNnd8LhD3Rk8vQgrwvFuN+u5EtqaD7DWM=;
        b=XWbrYU9+F40zDFN8F5Ley0lQLoezcyvufvlw/CH+ls5uaEJ+Mrba7EtNUhW8y6mqSd
         uLOOZGo4TfjVXxGpN5EEpdWPMKDjjOTQf2GLOD/a47jkDunB9fRkPtqtinc/i8fXadBN
         KXlfqD/5dR1qBFoKqo09UVrtOb/7gJqgIJ6iFgWfhTHftyyuO3ACfAsCI2azq1v8rnWo
         WQ5PxqeDRxv4NFqWf5ACbLjjgnBhTKfsy840JwW+nSEVCJtdrgOlBFwIaluXPkMn1A3a
         f3fBOqNIqQsaZHhbUF3KhN/SzMKNMVv5PMQlSnPCfwsJgyIrGt4jUZwmfo2GMXXf/gKr
         neIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6M/FJ5paQRaNnd8LhD3Rk8vQgrwvFuN+u5EtqaD7DWM=;
        b=vSp+wivhAVELec5VmJwejJwReyjT0ulvCzA3ny0E6kBx2oNUlGwZN5ChS95e9xSXbc
         h5L/sa/5qromD3n39AuYxjUZDFvmyJpzomZljQ/XvAVOukHmTQrT5ho45Ce8370m/gw7
         /FijAM5AVt7Kq/Vi580TwuNAbBa2FABA5R/eUH+YGxBnjDb4s+4zGlxYIfG0aSqn6Rsp
         0d0Fr1Rk3zf9kWc5xwQhRO+2DY44WElHpGb9Hym/BIeu/CZ8NbLjbNKBrWJrR18mbwBg
         Bg17Ny8QJ0Nu28Q87lYyTVQbqpcsr3TtTVF08dirRXZYJY9Bgl3RvaDfJs8q9t7g7p8u
         HVNg==
X-Gm-Message-State: ANoB5pnZHivBQ5fIIh+LT9nNY6alGgggzALbZaduIV0sYR6CPs0FQIFK
        axpVMVrSVm9cSYXdvo7UpiaOXPNdVz8=
X-Google-Smtp-Source: AA0mqf57OFnY5+nXLLddbQZXYjHzJB2HL1I+d7JImFICzdo/oJj4qX3Zx6I1LwdFe1vJKFTXNvmZiw==
X-Received: by 2002:a05:6871:4097:b0:132:1c:9aad with SMTP id kz23-20020a056871409700b00132001c9aadmr343254oab.168.1668554008104;
        Tue, 15 Nov 2022 15:13:28 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id g26-20020a9d619a000000b0063696cbb6bdsm5778984otk.62.2022.11.15.15.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:13:27 -0800 (PST)
Date:   Tue, 15 Nov 2022 15:13:26 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vschneid@redhat.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, sander@svanheule.net, peterz@infradead.org,
        paulmck@kernel.org, linux@rasmusvillemoes.dk,
        klimov.linux@gmail.com, geert@linux-m68k.org, ebiggers@google.com,
        dvyukov@google.com, andriy.shevchenko@linux.intel.com
Subject: Re: [merged mm-nonmm-stable]
 cpumask-limit-visibility-of-force_nr_cpus.patch removed from -mm tree
Message-ID: <Y3QdFrd7Lld5XCE7@yury-laptop>
References: <20221115223220.D75F7C433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115223220.D75F7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Nov 15, 2022 at 02:32:20PM -0800, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: cpumask: limit visibility of FORCE_NR_CPUS
> has been removed from the -mm tree.  Its filename was
>      cpumask-limit-visibility-of-force_nr_cpus.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Andrew,

I need to send v3 for this. Can you please exclude this?

Thanks,
Yury

> 
> ------------------------------------------------------
> From: Yury Norov <yury.norov@gmail.com>
> Subject: cpumask: limit visibility of FORCE_NR_CPUS
> Date: Wed, 19 Oct 2022 15:59:39 -0700
> 
> In current form, FORCE_NR_CPUS is visible to all users building their
> kernels, even not experts.  It is also set in allmodconfig or
> allyesconfig, which is not a correct behavior.
> 
> The 'choice' and unused config UNFORCE_NR_CPUS are used to ensure that
> auto-generated configs that try to enable as much options as possible,
> like allmodconfig, don't enable FORCE_NR_CPUS.
> 
> Link: https://lkml.kernel.org/r/20221019225939.1646349-1-yury.norov@gmail.com
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Alexey Klimov <klimov.linux@gmail.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sander Vanheule <sander@svanheule.net>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/Kconfig |   31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> --- a/lib/Kconfig~cpumask-limit-visibility-of-force_nr_cpus
> +++ a/lib/Kconfig
> @@ -528,14 +528,31 @@ config CPUMASK_OFFSTACK
>  	  them on the stack.  This is a bit more expensive, but avoids
>  	  stack overflow.
>  
> +choice
> +	prompt "Number of CPUs detection method"
> +	default UNFORCE_NR_CPUS
> +	depends on SMP && EXPERT
> +	help
> +	  Select between boot-time and compile-time detection of number
> +	  of CPUs. If it's possible to provide exact number of CPUs at
> +	  compile-time, kernel code may be optimized better.
> +	  For general-purpose kernel, choose "boot time" option.
> +
> +config UNFORCE_NR_CPUS
> +	bool "Set number of CPUs at boot time"
> +	help
> +	  Choose it if you build general-purpose kernel and want to rely
> +	  on kernel to detect actual number of CPUs.
> +
>  config FORCE_NR_CPUS
> -       bool "NR_CPUS is set to an actual number of CPUs"
> -       depends on SMP
> -       help
> -         Say Yes if you have NR_CPUS set to an actual number of possible
> -         CPUs in your system, not to a default value. This forces the core
> -         code to rely on compile-time value and optimize kernel routines
> -         better.
> +	bool "Set number of CPUs at compile time"
> +	help
> +	  Choose it if NR_CPUS corresponds to an actual number of
> +	  possible CPUs in your system. This forces the core code
> +	  to rely on compile-time value and optimize kernel routines
> +	  better.
> +
> +endchoice
>  
>  config CPU_RMAP
>  	bool
> _
> 
> Patches currently in -mm which might be from yury.norov@gmail.com are
> 
