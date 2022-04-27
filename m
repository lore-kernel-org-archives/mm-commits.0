Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3999C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 01:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356701AbiD0Bcx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 21:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356712AbiD0Bcr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 21:32:47 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5CEAFAC9
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 18:29:37 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id k12so577147lfr.9
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 18:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuMemhK5xIsarCH9/oTmT9dxFi1jAyKuuZDdiuUgrA8=;
        b=TCP10/qe9Q7mX7BBVd9N5qR12JU4ZU7GN1Vdw0bT4WLE6GBs8lZf8d6pIMh6W99uuy
         +ByiZ0SKyNBKfVivB20Qfv1HcyYocCLPeMkZ8BxU77r8QuWnXeWbOUZeXPmIO/Ez4lFU
         QTV1CIUoDVtcWPB3PtminDbgmMVEToyNmLloo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuMemhK5xIsarCH9/oTmT9dxFi1jAyKuuZDdiuUgrA8=;
        b=LQn0h+4LNIbIWy5HBI1WtQfKGunj0aGh1jkJbVhiV0aeIsWl5U7QuEQCB+hTlpBha5
         qqrQZ0wsG2vfVSYJrLHsxGQfaNDX0/EEG4P/fzgPl7ZSYbx0pJmVLo3VgmiivNUaOuWo
         oMJ8/WKvQYdTpwQSZdKKCbNGvhfiAEzovwgRi48+36oXH2oQHvoYVN41B66/1S91DqRT
         AgBpPfb1hpCmmELsMsUv18tgYm2imPks8U9oveb8RJKAwmL5RHibu81SAPHdspDltAPI
         H+H75dhE7Wo1kL8gi3Zqs7sAh2BRkeomixhFrzoYfrPWPvCvMeqhnk/r43UvfcNE1Pf2
         BwYw==
X-Gm-Message-State: AOAM533CmXJBUzw75jOpRSPHXmMa+F+408zsU8CdvIDrm2j5xusv9lpi
        6lm1/VgeYCBLwsrJ9VOfwVFY87VdDCIQDMGB
X-Google-Smtp-Source: ABdhPJwaS+OzjmwX8tbLVEKBK+KeZs9zces6CPEDqyopR+ovzcxZn9WKJVXgdJ5OMnTwORIJUPCRPg==
X-Received: by 2002:a05:6512:3341:b0:44a:eb29:c59c with SMTP id y1-20020a056512334100b0044aeb29c59cmr18273371lfd.596.1651022975384;
        Tue, 26 Apr 2022 18:29:35 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id o5-20020a198c05000000b00471b18fb5fesm1895985lfd.306.2022.04.26.18.29.33
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 18:29:33 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id bq30so619231lfb.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 18:29:33 -0700 (PDT)
X-Received: by 2002:a05:6512:6c6:b0:472:296e:6dfb with SMTP id
 u6-20020a05651206c600b00472296e6dfbmr767509lff.542.1651022972680; Tue, 26 Apr
 2022 18:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic>
In-Reply-To: <YmiK7Bos+zLAvL0t@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 26 Apr 2022 18:29:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
Message-ID: <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
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

On Tue, Apr 26, 2022 at 5:14 PM Borislav Petkov <bp@alien8.de> wrote:
>
> So when we enter the function, we shift %rcx to get the number of
> qword-sized quantities to zero:
>
> SYM_FUNC_START(clear_user_original)
>         mov %rcx,%rax
>         shr $3,%rcx             # qwords        <---

Yes.

But that's what we do for "rep stosq" too, for all the same reasons.

> but when we encounter the fault here, we return *%rcx* - not %rcx << 3
> - latter being the *bytes* leftover which we *actually* need to return
> when we encounter the #PF.

Yes, but:

> So, we need to shift back when we fault during the qword-sized zeroing,
> i.e., full function below, see label 3 there.

No.

The problem is that you're using the wrong exception type.

Thanks for posting the whole thing, because that makes it much more obvious.

You have the exception table entries switched.

You should have

         _ASM_EXTABLE_TYPE_REG(0b, 3b, EX_TYPE_UCOPY_LEN8, %rax)
        _ASM_EXTABLE_UA(2b, 3b)

and not need that label '4' at all.

Note how that "_ASM_EXTABLE_TYPE_REG" thing is literally designed to do

   %rcx = 8*%rcx+%rax

in the exception handler.

Of course, to get that regular

        _ASM_EXTABLE_UA(2b, 3b)

to work, you need to have the final byte count in %rcx, not in %rax so
that means that the "now do the rest of the bytes" case should have
done something like

        movl %eax,%ecx
2:      movb $0,(%rdi)
        inc %rdi
        decl %ecx
        jnz  2b

instead.

Yeah, yeah, you could also use that _ASM_EXTABLE_TYPE_REG thing for
the second exception point, and keep %rcx as zero, and keep it in
%eax, and depend on that whole "%rcx = 8*%rcx+%rax" fixing it up, and
knowing that if an exception does *not* happen, %rcx will be zero from
the word-size loop.

But that really seems much too subtle for me - why not just keep
things in %rcx, and try to make this look as much as possible like the
"rep stosq + rep stosb" case?

And finally: I still think that those fancy exception table things are
*much* too fancy, and much too subtle, and much too complicated.

So I'd actually prefer to get rid of them entirely, and make the code
use the "no register changes" exception, and make the exception
handler do a proper site-specific fixup. At that point, you can get
rid of all the "mask bits early" logic, get rid of all the extraneous
'test' instructions, and make it all look something like below.

NOTE! I've intentionally kept the %eax thing using 32-bit instructions
- smaller encoding, and only the low three bits matter, so why
move/mask full 64 bits?

NOTE2! Entirely untested. But I tried to make the normal code do
minimal work, and then fix things up in the exception case more. So it
just keeps the original count in the 32 bits in %eax until it wants to
test it, and then uses the 'andl' to both mask and test. And the
exception case knows that, so it masks there too.

I dunno. But I really think that whole new _ASM_EXTABLE_TYPE_REG and
EX_TYPE_UCOPY_LEN8 was unnecessary.

               Linus

SYM_FUNC_START(clear_user_original)
        movl %ecx,%eax
        shrq $3,%rcx             # qwords
        jz .Lrest_bytes

        # do the qwords first
        .p2align 4
.Lqwords:
        movq $0,(%rdi)
        lea 8(%rdi),%rdi
        dec %rcx
        jnz .Lqwords

.Lrest_bytes:
        andl $7,%eax             # rest bytes
        jz .Lexit

        # now do the rest bytes
.Lbytes:
        movb $0,(%rdi)
        inc %rdi
        decl %eax
        jnz .Lbytes

.Lexit:
        xorl %eax,%eax
        RET

.Lqwords_exception:
        # convert qwords back into bytes to return to caller
        shlq $3, %rcx
        andl $7, %eax
        addq %rax,%rcx
        jmp .Lexit

.Lbytes_exception:
        movl %eax,%ecx
        jmp .Lexit

        _ASM_EXTABLE_UA(.Lqwords, .Lqwords_exception)
        _ASM_EXTABLE_UA(.Lbytes, .Lbytes_exception)
