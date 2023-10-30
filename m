Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1B2C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 30 Oct 2023 16:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjJ3Q1d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Oct 2023 12:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjJ3Q1d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Oct 2023 12:27:33 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5F611C
        for <mm-commits@vger.kernel.org>; Mon, 30 Oct 2023 09:27:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cc5916d578so5528445ad.2
        for <mm-commits@vger.kernel.org>; Mon, 30 Oct 2023 09:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698683243; x=1699288043; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3hdrkNKDgHtK42Z+Shx37lzevpuFE6/dimtvBy8Df4=;
        b=RS/f7KGUl7FHUOjG47W41DnAxX5yop7zRiHKm32BLuBgMbBSuToYoWUuTg8BxbYvCO
         q54L5hpAJCrp9UByI+xgbAtVilrgtGd84aGwaFM/McN7ZzdZg0TfPdhtmHzHVzALD7an
         zVQxqCnqgiJlRYBmD48ZHPUYsK9zc+O6ShDBsuMPorhdxgHrcH1Sg9go1WP+h+LX2V2G
         NRf5Czb7Q4pxjR4d5EeBuPsySXCa1E5beWhXQymqFNQl6UMQJa91r4xmXYFbwVkWds0O
         fLKW/ixN1v6OC3iFz3PFtCt30GOv88aegktcp52QV8EKpYbjuBJKm4dUlzEVqnN0WTfV
         OI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698683243; x=1699288043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3hdrkNKDgHtK42Z+Shx37lzevpuFE6/dimtvBy8Df4=;
        b=o9MCSG5kgHEHqJVsB2Ts6u381QgYfSGb80RzOApQ2FJ5bR0IZo4K+hywrrySS7VxAY
         zCjB8vvuNkbsC7rVRVKy4WoO9Uad640hoJLxqLucNM2MZEMYbfjVtGimA7ZnbOcKoxF5
         tiWkVMbh+rI5iceBgAfXENZL6rb2cLvv6CrWm7UZm5vcCokVjVAHKM1Bhm/OLnVgJe5x
         GEW3u3zVfNgaLnB4/BClIXR3KYnLT/UImdcNjqzZDH6937LQzf5TaP7o33Vfgpdj6NZX
         baaHRrI6jdf1VxwvpIISIUzLNO8WQv9z20CVO/LPWSZwGqGotWA/6L971gzsdaUCDRtF
         kqgQ==
X-Gm-Message-State: AOJu0YwUzmOl/zdhZafDnBKvCgo132saI4vj69caZ7b6UKQO1AKifpaP
        opjBf/p7GQpZRl2Qpx4mLfU=
X-Google-Smtp-Source: AGHT+IFqnWJXSNyQVameUP5VpYHfrBrTRqbIMhwCeqUh6JUvjNtyIG7GDT1coNcEvzB/Bj34VFTOfA==
X-Received: by 2002:a17:902:e848:b0:1cc:4559:ff with SMTP id t8-20020a170902e84800b001cc455900ffmr4617055plg.13.1698683242921;
        Mon, 30 Oct 2023 09:27:22 -0700 (PDT)
Received: from swarup-virtual-machine ([171.76.83.22])
        by smtp.gmail.com with ESMTPSA id v8-20020a170902b7c800b001c71ec1866fsm4643471plz.258.2023.10.30.09.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 09:27:22 -0700 (PDT)
Date:   Mon, 30 Oct 2023 21:57:13 +0530
From:   swarup <swarupkotikalapudi@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, adobriyan@gmail.com
Subject: Re: + proc-fix-proc-empty-vm-test-with-vsyscall.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZT/ZYcH7EPX+E+Cn@swarup-virtual-machine>
References: <20231027153857.41AD1C433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027153857.41AD1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

eOn Fri, Oct 27, 2023 at 08:38:56AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: proc: fix proc-empty-vm test with vsyscall
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      proc-fix-proc-empty-vm-test-with-vsyscall.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-proc-empty-vm-test-with-vsyscall.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Subject: proc: fix proc-empty-vm test with vsyscall
> Date: Fri, 27 Oct 2023 17:21:03 +0300
> 
> * fix embarassing /proc/*/smaps test bug due to a typo in variable name
>   it tested only the first line of the output if vsyscall is enabled:
> 
>   	ffffffffff600000-ffffffffff601000 r-xp ...
> 
>   so test passed but tested only VMA location and permissions.
> 
> * add "KSM" entry, unnoticed because (1)
> 
> * swap "r-xp" and "--xp" vsyscall test strings,
>   also unnoticed because (1)
> 
> Link: https://lkml.kernel.org/r/76f42cce-b1ab-45ec-b6b2-4c64f0dccb90@p183
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/proc/proc-empty-vm.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> --- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-fix-proc-empty-vm-test-with-vsyscall
> +++ a/tools/testing/selftests/proc/proc-empty-vm.c
> @@ -60,7 +60,7 @@ static const char proc_pid_maps_vsyscall
>  static const char proc_pid_smaps_vsyscall_0[] = "";
>  
>  static const char proc_pid_smaps_vsyscall_1[] =
> -"ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n"
> +"ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n"
>  "Size:                  4 kB\n"
>  "KernelPageSize:        4 kB\n"
>  "MMUPageSize:           4 kB\n"
> @@ -73,6 +73,7 @@ static const char proc_pid_smaps_vsyscal
>  "Private_Dirty:         0 kB\n"
>  "Referenced:            0 kB\n"
>  "Anonymous:             0 kB\n"
> +"KSM:                   0 kB\n"
>  "LazyFree:              0 kB\n"
>  "AnonHugePages:         0 kB\n"
>  "ShmemPmdMapped:        0 kB\n"
> @@ -90,7 +91,7 @@ static const char proc_pid_smaps_vsyscal
>  ;
>  
>  static const char proc_pid_smaps_vsyscall_2[] =
> -"ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n"
> +"ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n"
>  "Size:                  4 kB\n"
>  "KernelPageSize:        4 kB\n"
>  "MMUPageSize:           4 kB\n"
> @@ -103,6 +104,7 @@ static const char proc_pid_smaps_vsyscal
>  "Private_Dirty:         0 kB\n"
>  "Referenced:            0 kB\n"
>  "Anonymous:             0 kB\n"
> +"KSM:                   0 kB\n"
>  "LazyFree:              0 kB\n"
>  "AnonHugePages:         0 kB\n"
>  "ShmemPmdMapped:        0 kB\n"
> @@ -244,10 +246,10 @@ static int test_proc_pid_smaps(pid_t pid
>  		if (g_vsyscall == 0) {
>  			assert(rv == 0);
>  		} else {
> -			size_t len = strlen(g_proc_pid_maps_vsyscall);
> +			size_t len = strlen(g_proc_pid_smaps_vsyscall);
>  			/* TODO "ProtectionKey:" */
>  			assert(rv > len);
> -			assert(memcmp(buf, g_proc_pid_maps_vsyscall, len) == 0);
> +			assert(memcmp(buf, g_proc_pid_smaps_vsyscall, len) == 0);
>  		}
>  		return EXIT_SUCCESS;
>  	}
> _
> 
> Patches currently in -mm which might be from adobriyan@gmail.com are
> 
> proc-fix-proc-empty-vm-test-with-vsyscall.patch
> 
Tested-by: Swarup Laxman Kotikalapudi<swarupkotikalapudi@mail.com>
Hi Alexey Dobriyan,
I reviewed and tested it seems to working fine.
Thanks,
Swarup
