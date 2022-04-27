Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93209C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 10:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiD0LCz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 07:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiD0LCl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 07:02:41 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571063C9D7A
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 03:41:19 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7991D1EC04A9;
        Wed, 27 Apr 2022 12:41:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651056073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LBbpFhl+1CZpRJA7Wg/EqdjikZnQoYyXLdtwSFhoF0s=;
        b=JVTy9o8PY7XDCKPgwKAOrxhHNp4/y0PRV+/J1rJQD9GfLT3M91LFvm3J8BGvBtRNSw/8U7
        4udhq17K3+Osn7tcHudmG6tHs5p8MnhSA+85VaU+V9UTmyuK4Qb4r9WEELLDR0GEkfY/vA
        7SmDfx/PiDkn1lnyLxxEjvml74774Ss=
Date:   Wed, 27 Apr 2022 12:41:09 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <YmkdxaKdc2w/3I7o@zn.tnic>
References: <Yl5+DCfQmG5C3BHf@zn.tnic>
 <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic>
 <YmFy8DEqvX4FlnuB@zn.tnic>
 <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic>
 <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic>
 <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Apr 26, 2022 at 06:29:16PM -0700, Linus Torvalds wrote:
> Yeah, yeah, you could also use that _ASM_EXTABLE_TYPE_REG thing for
> the second exception point, and keep %rcx as zero, and keep it in
> %eax, and depend on that whole "%rcx = 8*%rcx+%rax" fixing it up, and
> knowing that if an exception does *not* happen, %rcx will be zero from
> the word-size loop.

Exactly!

> But that really seems much too subtle for me - why not just keep
> things in %rcx, and try to make this look as much as possible like the
> "rep stosq + rep stosb" case?
> 
> And finally: I still think that those fancy exception table things are
> *much* too fancy, and much too subtle, and much too complicated.

This whole confusion goes to show that this really is too subtle. ;-\

I mean, it is probably fine for some simple asm where you want to have
the register fixup out of the way. But for something like that where
I wanted the asm to be optimal but not tricky at the same time, that
tricky "hidden fixup" might turn out to be not such a good idea.

And sure, yeah, we can make this work this way now and all but after
time passes, swapping all that tricky stuff back in is going to be a
pain. That's why I'm leaving breadcrumbs everywhere I can.

> So I'd actually prefer to get rid of them entirely, and make the code
> use the "no register changes" exception, and make the exception
> handler do a proper site-specific fixup. At that point, you can get
> rid of all the "mask bits early" logic, get rid of all the extraneous
> 'test' instructions, and make it all look something like below.

Yap, and the named labels make it even clearer.

> NOTE! I've intentionally kept the %eax thing using 32-bit instructions
> - smaller encoding, and only the low three bits matter, so why
> move/mask full 64 bits?

Some notes below.

> NOTE2! Entirely untested.

I'll poke at it.

> But I tried to make the normal code do minimal work, and then fix
> things up in the exception case more.

Yap.

> So it just keeps the original count in the 32 bits in %eax until it
> wants to test it, and then uses the 'andl' to both mask and test. And
> the exception case knows that, so it masks there too.

Sure.

> I dunno. But I really think that whole new _ASM_EXTABLE_TYPE_REG and
> EX_TYPE_UCOPY_LEN8 was unnecessary.

I've pointed this out to Mr. Z. He likes them as complex as possible.
:-P

> SYM_FUNC_START(clear_user_original)
>         movl %ecx,%eax

I'll add a comment here along the lines of us only needing the 32-bit
quantity of the size as we're dealing with the rest bytes and so we save
a REX byte in the opcode.

>         shrq $3,%rcx             # qwords

Any particular reason for the explicit "q" suffix? The register already
denotes the opsize and the generated opcode is the same.

>         jz .Lrest_bytes
> 
>         # do the qwords first
>         .p2align 4
> .Lqwords:
>         movq $0,(%rdi)
>         lea 8(%rdi),%rdi
>         dec %rcx

Like here, for example.

I guess you wanna be explicit as to the operation width...

>         jnz .Lqwords
> 
> .Lrest_bytes:
>         andl $7,%eax             # rest bytes
>         jz .Lexit
> 
>         # now do the rest bytes
> .Lbytes:
>         movb $0,(%rdi)
>         inc %rdi
>         decl %eax
>         jnz .Lbytes
> 
> .Lexit:
>         xorl %eax,%eax
>         RET
> 
> .Lqwords_exception:
>         # convert qwords back into bytes to return to caller
>         shlq $3, %rcx
>         andl $7, %eax
>         addq %rax,%rcx
>         jmp .Lexit
> 
> .Lbytes_exception:
>         movl %eax,%ecx
>         jmp .Lexit
> 
>         _ASM_EXTABLE_UA(.Lqwords, .Lqwords_exception)
>         _ASM_EXTABLE_UA(.Lbytes, .Lbytes_exception)

Yap, I definitely like this one more. Straightforward.

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
