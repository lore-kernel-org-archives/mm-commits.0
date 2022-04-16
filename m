Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136FDC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 16 Apr 2022 21:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiDPVR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Apr 2022 17:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiDPVR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2022 17:17:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F0520F61
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 14:15:24 -0700 (PDT)
Received: from zn.tnic (p200300ea971b5861329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:5861:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45D331EC032C;
        Sat, 16 Apr 2022 23:15:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650143718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZgGNK8HM+ckNOZwguRFUr5LjsUMGywPq5HNleGapKdA=;
        b=LkSxbh68Nd8863i7jnf8au6tiN7FAYtLIg3Okx3EIxjwVDeTiq0QePk9Tyj/x4N1qR3Wc6
        S3c9zKvDBc2oWf77vPheu1uQ5aMrulXmtwT6CFAvhuRX727wvEQH3sT64G3+qddCXJhDo1
        bSMY6ff/dVVOVOIDu98NnIYtIkLB2+A=
Date:   Sat, 16 Apr 2022 23:15:16 +0200
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
Message-ID: <Ylsx5PwyUPOainHa@zn.tnic>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org>
 <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic>
 <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic>
 <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Apr 16, 2022 at 10:42:22AM -0700, Linus Torvalds wrote:
> On Sat, Apr 16, 2022 at 10:28 AM Borislav Petkov <bp@alien8.de> wrote:
> >
> > you also need a _fsrm() one which checks X86_FEATURE_FSRM. That one
> > should simply do rep; stosb regardless of the size. For that you can
> > define an alternative_call_3 similar to how the _2 variant is defined.
> 
> Honestly, my personal preference would be that with FSRM, we'd have an
> alternative that looks something like
> 
>     asm volatile(
>         "1:"
>         ALTERNATIVE("call __stosb_user", "rep movsb", X86_FEATURE_FSRM)
>         "2:"
>        _ASM_EXTABLE_UA(1b, 2b)
>         :"=c" (count), "=D" (dest),ASM_CALL_CONSTRAINT
>         :"0" (count), "1" (dest), "a" (0)
>         :"memory");
> 
> iow, the 'rep stosb' case would be inline.

I knew you were gonna say that - we have talked about this in the past.
And I'll do you one better -- we have the patch-if-bit-not-set thing now
too, so I think it should work if we did:


       alternative_call_3(__clear_user_fsrm,
                          __clear_user_erms,   ALT_NOT(X86_FEATURE_FSRM),
                          __clear_user_string, ALT_NOT(X86_FEATURE_ERMS),
			  __clear_user_orig,   ALT_NOT(X86_FEATURE_REP_GOOD),
                          : "+&c" (size), "+&D" (addr)
                          :: "eax");

and yeah, you wanna get rid of the CALL even and I guess that could
be made to work - I just need to play with it a bit to hammer out the
details.

I.e., it would be most optimal if it ended up being

	ALTERNATIVE_3("rep stosb",
		      "call ... ", ALT_NOT(X86_FEATURE_FSRM),
		      ...


> Note that the above would have a few things to look out for:
> 
>  - special 'stosb' calling convention:
> 
>      %rax/%rcx/%rdx as inputs
>      %rcx as "bytes not copied" return value
>      %rdi can be clobbered
> 
>    so the actual functions would look a bit odd and would need to
> save/restore some registers, but they'd basically just emulate "rep
> stosb".

Right.

>  - since the whole point is that the "rep movsb" is inlined, it also
> means that the "call __stosb_user" is done within the STAC/CLAC
> region, so objdump would have to be taught that's ok
> 
> but wouldn't it be lovely if we could start moving towards a model
> where we can just inline 'memset' and 'memcpy' like this?

Yeah, inlined insns without even a CALL insn would be the most optimal
thing to do.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
