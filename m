Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7C6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 09:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbiDSJTw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 05:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiDSJTu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 05:19:50 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3905026573
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 02:17:09 -0700 (PDT)
Received: from zn.tnic (p200300ea971b58fe329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:58fe:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A9F2F1EC0426;
        Tue, 19 Apr 2022 11:17:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650359823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IpUcxK1+aTl3dEfdBYBEfx4dIywUQ3Ulo1xvFLO5pfQ=;
        b=m6EKFizfaEKMQ8/FoV/wzQyw+m/nH+T/i6ZYFMp/On5sVMohISCvYd1t7rKxwUrqs1KRHZ
        MuxuTVr35O0B+kdtlZxWn8Zf0/6WqE1RbLQis3tRq9id/Q0jHUBgNi33N56YfpjJJufgtq
        yfaK9g5cQyAj8X+50o3k1UeuK16auAo=
Date:   Tue, 19 Apr 2022 11:17:00 +0200
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
Message-ID: <Yl5+DCfQmG5C3BHf@zn.tnic>
References: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic>
 <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic>
 <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic>
 <YlxtTNFP58TcUHZQ@zn.tnic>
 <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic>
 <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Apr 18, 2022 at 10:10:42AM -0700, Linus Torvalds wrote:
> Ugh. If you do this, you need to have a big comment about how that
> %rcx value gets fixed up with EX_TYPE_UCOPY_LEN (which basically ends
> up doing "%rcx = %rcx*8+%rax" in ex_handler_ucopy_len() for the
> exception case).

Yap, and I reused your text and expanded it. You made me look at that
crazy DEFINE_EXTABLE_TYPE_REG macro finally so that I know what it does
in detail.

So I have the below now, it boots in the guest so it must be perfect.

---

/*
 * Default clear user-space.
 * Input:
 * rdi destination
 * rcx count
 *
 * Output:
 * rcx uncopied bytes or 0 if successful.
 */
SYM_FUNC_START(clear_user_original)
        mov %rcx,%rax
        shr $3,%rcx             # qwords
        and $7,%rax             # rest bytes
        test %rcx,%rcx
        jz 1f

        # do the qwords first
        .p2align 4
0:      movq $0,(%rdi)
        lea 8(%rdi),%rdi
        dec %rcx
        jnz   0b

1:      test %rax,%rax
        jz 3f

        # now do the rest bytes
2:      movb $0,(%rdi)
        inc %rdi
        decl %eax
        jnz  2b

3:
        xorl %eax,%eax
        RET

        _ASM_EXTABLE_UA(0b, 3b)

        /*
         * The %rcx value gets fixed up with EX_TYPE_UCOPY_LEN (which basically ends
         * up doing "%rcx = %rcx*8 + %rax" in ex_handler_ucopy_len() for the exception
         * case). That is, we use %rax above at label 2: for simpler asm but the number
         * of uncleared bytes will land in %rcx, as expected by the caller.
         *
         * %rax at label 3: still needs to be cleared in the exception case because this
         * is called from inline asm and the compiler expects %rax to be zero when exiting
         * the inline asm, in case it might reuse it somewhere.
         */
        _ASM_EXTABLE_TYPE_REG(2b, 3b, EX_TYPE_UCOPY_LEN8, %rax)
SYM_FUNC_END(clear_user_original)
EXPORT_SYMBOL(clear_user_original)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
