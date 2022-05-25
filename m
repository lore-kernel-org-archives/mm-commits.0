Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BA0C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 12:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243693AbiEYML5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 08:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243670AbiEYMLc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 08:11:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0242656F
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 05:11:29 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i18so1454446pfk.7
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 05:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gu+QAebvwEXRvn+ThIJPlBzhHTznFzsKEDCvobNl9FM=;
        b=cdgFsJOw0kjw13qW620Z9bUI9V86aH3A5SFjWZ+kqNnCXFPQrhHgTFXeE6zXVeAIS/
         5E+LoJY/38QtJyBSJSrGFjRPl5eVYzjlEl4bTQpzMN7/zPS5co72RcG48FlXbc9iOTh1
         oSbMqjhsC7D+fafORe+unyBawBfeazMqgS2MqLaAQAb6nlgN1ilR7KGiUO4dV/E8KKVD
         kdRJDWCNvMYq5R27SilmolM46+oQ7exI1qIAAnYuHyGcAjiXfWS7VhZxTPG145ij09lF
         fuPDMbmQJlm9MTwe4UwzJQ7DBiwU40aGmTcgnxbl9Bu9sdz4l/3atUaHS1WfhVuKii0I
         wp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gu+QAebvwEXRvn+ThIJPlBzhHTznFzsKEDCvobNl9FM=;
        b=UTcBzYXQTJJCFjpgmSP5qOh75+zirL2QfAtNC6nFCKaKJjMq9ElTITonopbAipkX7i
         8jgJ2DJbwB6LMovC5uctl/4VZvhqVpS4TyvrTVzyQ+J+VU9hgtsWa118FzL2RB1SGNBa
         Jh2LqMmd3vhx7VP3Vgw4lCHm8u+QWYmmhBpi4/nqfV0qKo4pOgmvYorOxBmlvuRPcXqV
         99bDmUOVcWLZM3SpjZwD204jmGUkoSqZVW86ZtOoZ26EAt0F11oHphNUaMdMY8vtZdD6
         pobS38RKbzhnN3ydljaP5Ypvh7LOxAhXtLffrqrWHMx85lUpp19S69GK7Vh83YGhEn/E
         8NEw==
X-Gm-Message-State: AOAM532BP/JtcN2cLEgV1JeZqBczLZEmH0xOJaF3fzHR2UgwtgIP3zWm
        rsotGHkyNIS/R4dogsNDZCZG2EYhG2lZj88y8Lo=
X-Google-Smtp-Source: ABdhPJwmCQLIMpvOwaGIairSKM8tCQzCcLJuyyVJr1hZKQfyJ1B/tkn0ctT7unJdc9XirKC3jkoja0AgThx5ckRwAVU=
X-Received: by 2002:a63:5357:0:b0:3f2:6210:f8e9 with SMTP id
 t23-20020a635357000000b003f26210f8e9mr27823081pgl.158.1653480688856; Wed, 25
 May 2022 05:11:28 -0700 (PDT)
MIME-Version: 1.0
References: <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic> <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic> <Ynq1nVpu1xCpjnXm@zn.tnic> <YozQZMyQ0NDdD8cH@zn.tnic>
In-Reply-To: <YozQZMyQ0NDdD8cH@zn.tnic>
From:   Mark Hemment <markhemm@googlemail.com>
Date:   Wed, 25 May 2022 13:11:17 +0100
Message-ID: <CANe_+Uga8g+Nhxz_GxXN7OH28=JOAyfE++NbWBHZv9SvO8Vung@mail.gmail.com>
Subject: Re: [PATCH] x86/clear_user: Make it faster
To:     Borislav Petkov <bp@alien8.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Patrice CHOTARD <patrice.chotard@foss.st.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 24 May 2022 at 13:32, Borislav Petkov <bp@alien8.de> wrote:
>
> Ok,
>
> finally a somewhat final version, lightly tested.
>
> I still need to run it on production Icelake and that is kinda being
> delayed due to server room cooling issues (don't ask ;-\).
>
> ---
> From: Borislav Petkov <bp@suse.de>
>
> Based on a patch by Mark Hemment <markhemm@googlemail.com> and
> incorporating very sane suggestions from Linus.
>
> The point here is to have the default case with FSRM - which is supposed
> to be the majority of x86 hw out there - if not now then soon - be
> directly inlined into the instruction stream so that no function call
> overhead is taking place.
>
> The benchmarks I ran would show very small improvements and a PF
> benchmark would even show weird things like slowdowns with higher core
> counts.
>
> So for a ~6m running the git test suite, the function gets called under
> 700K times, all from padzero():
>
>   <...>-2536    [006] .....   261.208801: padzero: to: 0x55b0663ed214, size: 3564, cycles: 21900
>   <...>-2536    [006] .....   261.208819: padzero: to: 0x7f061adca078, size: 3976, cycles: 17160
>   <...>-2537    [008] .....   261.211027: padzero: to: 0x5572d019e240, size: 3520, cycles: 23850
>   <...>-2537    [008] .....   261.211049: padzero: to: 0x7f1288dc9078, size: 3976, cycles: 15900
>    ...
>
> which is around 1%-ish of the total time and which is consistent with
> the benchmark numbers.
>
> So Mel gave me the idea to simply measure how fast the function becomes.
> I.e.:
>
>   start = rdtsc_ordered();
>   ret = __clear_user(to, n);
>   end = rdtsc_ordered();
>
> Computing the mean average of all the samples collected during the test
> suite run then shows some improvement:
>
>   clear_user_original:
>   Amean: 9219.71 (Sum: 6340154910, samples: 687674)
>
>   fsrm:
>   Amean: 8030.63 (Sum: 5522277720, samples: 687652)
>
> That's on Zen3.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://lore.kernel.org/r/CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com
> ---
>  arch/x86/include/asm/uaccess.h    |   5 +-
>  arch/x86/include/asm/uaccess_64.h |  45 ++++++++++
>  arch/x86/lib/clear_page_64.S      | 142 ++++++++++++++++++++++++++++++
>  arch/x86/lib/usercopy_64.c        |  40 ---------
>  tools/objtool/check.c             |   3 +
>  5 files changed, 192 insertions(+), 43 deletions(-)

[...snip...]
> diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
> index fe59b8ac4fcc..6dd6c7fd1eb8 100644
...
> +/*
> + * Alternative clear user-space when CPU feature X86_FEATURE_REP_GOOD is
> + * present.
> + * Input:
> + * rdi destination
> + * rcx count
> + *
> + * Output:
> + * rcx: uncleared bytes or 0 if successful.
> + */
> +SYM_FUNC_START(clear_user_rep_good)
> +       # call the original thing for less than a cacheline
> +       cmp $64, %rcx
> +       ja  .Lprep
> +       call clear_user_original
> +       RET
> +
> +.Lprep:
> +       # copy lower 32-bits for rest bytes
> +       mov %ecx, %edx
> +       shr $3, %rcx
> +       jz .Lrep_good_rest_bytes

A slight doubt here; comment says "less than a cachline", but the code
is using 'ja' (jump if above) - so calls 'clear_user_original' for a
'len' less than or equal to 64.
Not sure of the intended behaviour for 64 bytes here, but
'copy_user_enhanced_fast_string' uses the slow-method for lengths less
than 64.  So, should this be coded as;
    cmp $64,%rcx
    jb clear_user_original
?

'clear_user_erms' has similar logic which might also need reworking.

> +
> +.Lrep_good_qwords:
> +       rep stosq
> +
> +.Lrep_good_rest_bytes:
> +       and $7, %edx
> +       jz .Lrep_good_exit
> +
> +.Lrep_good_bytes:
> +       mov %edx, %ecx
> +       rep stosb
> +
> +.Lrep_good_exit:
> +       # see .Lexit comment above
> +       xor %eax, %eax
> +       RET
> +
> +.Lrep_good_qwords_exception:
> +       # convert remaining qwords back into bytes to return to caller
> +       shl $3, %rcx
> +       and $7, %edx
> +       add %rdx, %rcx
> +       jmp .Lrep_good_exit
> +
> +       _ASM_EXTABLE_UA(.Lrep_good_qwords, .Lrep_good_qwords_exception)
> +       _ASM_EXTABLE_UA(.Lrep_good_bytes, .Lrep_good_exit)
> +SYM_FUNC_END(clear_user_rep_good)
> +EXPORT_SYMBOL(clear_user_rep_good)
> +
> +/*
> + * Alternative clear user-space when CPU feature X86_FEATURE_ERMS is present.
> + * Input:
> + * rdi destination
> + * rcx count
> + *
> + * Output:
> + * rcx: uncleared bytes or 0 if successful.
> + *
> + */
> +SYM_FUNC_START(clear_user_erms)
> +       # call the original thing for less than a cacheline
> +       cmp $64, %rcx
> +       ja  .Lerms_bytes
> +       call clear_user_original
> +       RET
> +
> +.Lerms_bytes:
> +       rep stosb
> +
> +.Lerms_exit:
> +       xorl %eax,%eax
> +       RET
> +
> +       _ASM_EXTABLE_UA(.Lerms_bytes, .Lerms_exit)
> +SYM_FUNC_END(clear_user_erms)
> +EXPORT_SYMBOL(clear_user_erms)
> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> index 0ae6cf804197..6c1f8ac5e721 100644
> --- a/arch/x86/lib/usercopy_64.c
> +++ b/arch/x86/lib/usercopy_64.c
> @@ -14,46 +14,6 @@
>   * Zero Userspace
>   */
>
> -unsigned long __clear_user(void __user *addr, unsigned long size)
> -{
> -       long __d0;
> -       might_fault();
> -       /* no memory constraint because it doesn't change any memory gcc knows
> -          about */
> -       stac();
> -       asm volatile(
> -               "       testq  %[size8],%[size8]\n"
> -               "       jz     4f\n"
> -               "       .align 16\n"
> -               "0:     movq $0,(%[dst])\n"
> -               "       addq   $8,%[dst]\n"
> -               "       decl %%ecx ; jnz   0b\n"
> -               "4:     movq  %[size1],%%rcx\n"
> -               "       testl %%ecx,%%ecx\n"
> -               "       jz     2f\n"
> -               "1:     movb   $0,(%[dst])\n"
> -               "       incq   %[dst]\n"
> -               "       decl %%ecx ; jnz  1b\n"
> -               "2:\n"
> -
> -               _ASM_EXTABLE_TYPE_REG(0b, 2b, EX_TYPE_UCOPY_LEN8, %[size1])
> -               _ASM_EXTABLE_UA(1b, 2b)
> -
> -               : [size8] "=&c"(size), [dst] "=&D" (__d0)
> -               : [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr));
> -       clac();
> -       return size;
> -}
> -EXPORT_SYMBOL(__clear_user);
> -
> -unsigned long clear_user(void __user *to, unsigned long n)
> -{
> -       if (access_ok(to, n))
> -               return __clear_user(to, n);
> -       return n;
> -}
> -EXPORT_SYMBOL(clear_user);
> -
>  #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>  /**
>   * clean_cache_range - write back a cache range with CLWB
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index ca5b74603008..e460aa004b88 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -1020,6 +1020,9 @@ static const char *uaccess_safe_builtin[] = {
>         "copy_mc_fragile_handle_tail",
>         "copy_mc_enhanced_fast_string",
>         "ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
> +       "clear_user_erms",
> +       "clear_user_rep_good",
> +       "clear_user_original",
>         NULL
>  };
>
> --
> 2.35.1
>
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

Cheers,
Mark
