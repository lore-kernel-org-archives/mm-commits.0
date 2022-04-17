Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53F2C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Apr 2022 20:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbiDQU7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Apr 2022 16:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiDQU7b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Apr 2022 16:59:31 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37ECDFD2
        for <mm-commits@vger.kernel.org>; Sun, 17 Apr 2022 13:56:47 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p10so21582929lfa.12
        for <mm-commits@vger.kernel.org>; Sun, 17 Apr 2022 13:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DsyxLgNrrlFcEa7Y01Ulqliiz+Bkxw84zt+8RzzuZRo=;
        b=WXRtYH3k6SxBF/y/KFw7kiV8oQU8icffy4o+sluqUWmZ1tbNBig1mFI9GYeGtGdw1y
         uFQCY6mv+8o1UtvYz8mD/ZEpob40zlS8W5FIjQpHXzi0UUzCLQuiM9oWDenMmppAdKRb
         GmYRYlbNO68MYyq/zyzukR0j04JB6zUHJxzO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DsyxLgNrrlFcEa7Y01Ulqliiz+Bkxw84zt+8RzzuZRo=;
        b=i+BUE8Rueo0/dygcSAcDxZSt402i7JzAtOToAct/Y8JYZiMGESICYv0QTOxP7CybNU
         PT2SkINOP8Vcoy/d7CTLYgvOo5KGEjMHXkOMeitvMGKwux1/XlSSJOwa9TOn2rVDSvSG
         V17rBvW2+PuV5NdHCXchkLyUKPjZtWeCcxaJ1V2s05ZrX/HTRidOW6moWQpcBfAhMpNy
         q7cuwCAVZWSpLAXx59w/DWuLcN53rSuWNwhIBs85oF6HweueGiewCFzhS75kx2XWSVrm
         4ZMUb+8AIfmpxr3f6SCiwUqQgrYtugKRwDXyyteSurafJJk0KI+VaS3pVDB4ao+akSCH
         AXBQ==
X-Gm-Message-State: AOAM532w4+Da1U9pzK5ezqYZdujq0/75nht9mu1XCA3UiaBR8t7HpLIy
        A8KrGpEUQwrt8vzrWsuO1eQjE8jrUJ0+J3wM
X-Google-Smtp-Source: ABdhPJxpbLxLLOgJNBdoFdG0JQBjLNfAgbWX6DMiZT7kbaKr/nes4+VBAHN3sW3UBmBYOzOVJz1EAg==
X-Received: by 2002:a05:6512:25a6:b0:46b:bcbe:12da with SMTP id bf38-20020a05651225a600b0046bbcbe12damr5994954lfb.343.1650229005667;
        Sun, 17 Apr 2022 13:56:45 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id h18-20020a05651c159200b00247fd128953sm977597ljq.11.2022.04.17.13.56.41
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 13:56:42 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id o2so21574599lfu.13
        for <mm-commits@vger.kernel.org>; Sun, 17 Apr 2022 13:56:41 -0700 (PDT)
X-Received: by 2002:a05:6512:3055:b0:44a:3914:6603 with SMTP id
 b21-20020a056512305500b0044a39146603mr6024068lfb.435.1650229001342; Sun, 17
 Apr 2022 13:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic>
In-Reply-To: <YlxtTNFP58TcUHZQ@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 17 Apr 2022 13:56:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
Message-ID: <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Apr 17, 2022 at 12:41 PM Borislav Petkov <bp@alien8.de> wrote:
>
> Anyway, more playing with this later to make sure it really does what it
> should.

I think the special calling conventions have tripped you up:

>  SYM_FUNC_START(clear_user_original)
> -       ASM_STAC
>         movq %rcx,%rax
>         shrq $3,%rcx
>         andq $7,%rax
> @@ -86,7 +84,7 @@ SYM_FUNC_START(clear_user_original)
>         decl %ecx
>         jnz  2b
>
> -3:     ASM_CLAC
> +3:
>         movq %rcx,%rax
>         RET

That 'movq %rcx,%rax' can't be right. The caller expects it to be zero
on input and stay zero on output.

But I think "xorl %eax,%eax" is good, since %eax was used as a
temporary in that function.

And the comment above the function should be fixed too.

>  SYM_FUNC_START(clear_user_rep_good)
> -       ASM_STAC
>         movq %rcx,%rdx
> -       xorq %rax,%rax
>         shrq $3,%rcx
>         andq $7,%rdx
>
> @@ -118,7 +113,7 @@ SYM_FUNC_START(clear_user_rep_good)
>
>  1:     rep stosb
>
> -3:     ASM_CLAC
> +3:
>         movq %rcx,%rax
>         RET

Same issue here.

Probably nothing notices, since %rcx *does* end up containing the
right value, and it's _likely_ that the compiler doesn't actually end
up re-using the zero value in %rax after the inline asm (that this bug
has corrupted), but if the compiler ever goes "Oh, I put zero in %rax,
so I'll just use that afterwards", this is going to blow up very
spectacularly and be very hard to debug.

> @@ -135,15 +130,13 @@ EXPORT_SYMBOL(clear_user_rep_good)
>   *
>   * Output:
>   * rax uncopied bytes or 0 if successful.
> + *
> + * XXX: check for small sizes and call the original version.
> + * Benchmark it first though.
>   */
> -
>  SYM_FUNC_START(clear_user_erms)
> -       xorq %rax,%rax
> -       ASM_STAC
> -
>  0:     rep stosb
> -
> -3:     ASM_CLAC
> +3:
>         movq %rcx,%rax
>         RET

.. and one more time.

Also, I do think that the rep_good and erms cases should probably
check for small copes, and use the clear_user_original thing for %rcx
< 64 or something like that.

It's what we do on the memcpy side - and more importantly, it's the
only difference between "erms" and FSRM. If the ERMS code doesn't do
anything different for small copies, why have it at all?

But other than these small issues, it looks good to me.

                  Linus
