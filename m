Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CC7C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 00:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351618AbiD0AR4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343562AbiD0ARy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 20:17:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CF87C16C
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 17:14:45 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E70FF1EC0494;
        Wed, 27 Apr 2022 02:14:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651018480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=eyJ8yFBLBpaJxLAfmkk/CGQT7EiTu9SRf6l3Zjs9qYU=;
        b=j/lN+WJ+w7PdlLtwOpnhZXIhtexfiMhOCjL2zVdrnICLCqFuPelFr+zrMwkkwVkSf6qv7r
        1St1S3jcjP3aclE8rLfMi2KQWZSV1W8IqdF3C+v3p94wF2HxyYRDVku1NTV50Hy5iIcF8k
        QTp3VnYffK/EvaiSsdIB1KvSwDikVwc=
Date:   Wed, 27 Apr 2022 02:14:36 +0200
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
Message-ID: <YmiK7Bos+zLAvL0t@zn.tnic>
References: <Yl06PWVgeZplboXV@zn.tnic>
 <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic>
 <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic>
 <YmFy8DEqvX4FlnuB@zn.tnic>
 <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic>
 <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Apr 24, 2022 at 12:54:57PM -0700, Linus Torvalds wrote:
> I suspect it's a %rax vs %rcx confusion again, but with your "patch on
> top of earlier patch" I didn't go and sort it out.

Finally had some quiet time to stare at this.

So when we enter the function, we shift %rcx to get the number of
qword-sized quantities to zero:

SYM_FUNC_START(clear_user_original)
	mov %rcx,%rax
	shr $3,%rcx		# qwords	<---

and we zero in qword quantities merrily:

        # do the qwords first
        .p2align 4
0:      movq $0,(%rdi)
        lea 8(%rdi),%rdi
        dec %rcx
        jnz   0b 


but when we encounter the fault here, we return *%rcx* - not %rcx << 3
- latter being the *bytes* leftover which we *actually* need to return
when we encounter the #PF.

So, we need to shift back when we fault during the qword-sized zeroing,
i.e., full function below, see label 3 there.

With that, strace looks good too:

openat(AT_FDCWD, "/dev/zero", O_RDONLY) = 3
mmap(NULL, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffff7dc5000
munmap(0x7ffff7dd5000, 65536)           = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 16
exit_group(16)                          = ?
+++ exited with 16 +++

As to the byte-exact deal, I'll put it on my TODO to play with it later
and see how much asm we can shed from this simplification so thanks for
the pointers!

/* 
 * Default clear user-space.
 * Input:
 * rdi destination
 * rcx count
 *
 * Output:
 * rcx uncleared bytes or 0 if successful.
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
        # convert qwords back into bytes to return to caller
        shl $3, %rcx

4:
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
        _ASM_EXTABLE_TYPE_REG(2b, 4b, EX_TYPE_UCOPY_LEN8, %rax)


Btw, I'm wondering if using descriptive label names would make this function even more
understandable:

/*      
 * Default clear user-space.
 * Input:
 * rdi destination
 * rcx count
 *
 * Output:
 * rcx uncleared bytes or 0 if successful.
 */
SYM_FUNC_START(clear_user_original)
        mov %rcx,%rax
        shr $3,%rcx             # qwords
        and $7,%rax             # rest bytes
        test %rcx,%rcx
        jz .Lrest_bytes

        # do the qwords first
        .p2align 4

.Lqwords:
        movq $0,(%rdi)
        lea 8(%rdi),%rdi
        dec %rcx
        jnz .Lqwords
        
.Lrest_bytes:
        test %rax,%rax
        jz .Lexit
        
        # now do the rest bytes
.Lbytes:
        movb $0,(%rdi)
        inc %rdi
        decl %eax
        jnz .Lbytes
        
.Lqwords_exit:
        # convert qwords back into bytes to return to caller
        shl $3, %rcx

.Lexit:
        xorl %eax,%eax
        RET
        
        _ASM_EXTABLE_UA(.Lqwords, .Lqwords_exit)
      
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
        _ASM_EXTABLE_TYPE_REG(.Lbytes, .Lexit, EX_TYPE_UCOPY_LEN8, %rax)
SYM_FUNC_END(clear_user_original) 
EXPORT_SYMBOL(clear_user_original)


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
