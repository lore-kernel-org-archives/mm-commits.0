Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D31C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 16 Apr 2022 17:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiDPRa4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Apr 2022 13:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiDPRaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2022 13:30:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073F813D79
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 10:28:21 -0700 (PDT)
Received: from zn.tnic (p200300ea971b5861329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:5861:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 48B2D1EC04AD;
        Sat, 16 Apr 2022 19:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650130096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TZZBFR0UIpKQ6/ePd/xtC+CEa/y9JPMvZ8AAKonVVhw=;
        b=PBt7jjyS7zlDSZ6sMB5gxd5nErbTRaDGiXBnmRorrgtRKpswr+5Hsx72z89lqCk1k+eXJ0
        HdrTxF0UsaXHHG9oAiy4DhuE798tZWSg8gBykzEqImQuC+eN9aqOwoVXBgJGTMF9LO4bfG
        TdPgCNm0w6CfcnIsl4+ay4IKXS2fB28=
Date:   Sat, 16 Apr 2022 19:28:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mark Hemment <markhemm@googlemail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <Ylr8rR+LHQ1uGL47@zn.tnic>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org>
 <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic>
 <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Apr 16, 2022 at 03:07:47PM +0100, Mark Hemment wrote:
> I've done a skeleton implementation of alternative __clear_user() based on 
> CPU features.

Cool!

Just a couple of quick notes - more indepth look next week.

> It has three versions of __clear_user();
> o __clear_user_original() - similar to the 'standard' __clear_user()
> o __clear_user_rep_good() - using resp stos{qb} when CPU has 'rep_good'
> o __clear_user_erms() - using 'resp stosb' when CPU has 'erms'

you also need a _fsrm() one which checks X86_FEATURE_FSRM. That one
should simply do rep; stosb regardless of the size. For that you can
define an alternative_call_3 similar to how the _2 variant is defined.

> Not claiming the implementation is ideal, but might be a useful starting
> point for someone.
> Patch is against 5.18.0-rc2.
> Only basic sanity testing done.
> 
> Simple performance testing done for large sizes, on a system (Intel E8400) 
> which has rep_good but not erms;
> # dd if=/dev/zero of=/dev/null bs=16384 count=10000
> o *_original() - ~14.2GB/s.  Same as the 'standard' __clear_user().
> o *_rep_good() - same throughput as *_original().
> o *_erms()     - ~12.2GB/s (expected on a system without erms).

Right.

I have a couple of boxes too - I can run the benchmarks on them too so
we should have enough perf data points eventually.

> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> index fbcfec4dc4cc..373ed6be7a8d 100644
> --- a/arch/x86/include/asm/asm.h
> +++ b/arch/x86/include/asm/asm.h
> @@ -132,6 +132,35 @@
>  /* Exception table entry */
>  #ifdef __ASSEMBLY__
>  
> +# define UNDEFINE_EXTABLE_TYPE_REG \
> +	.purgem extable_type_reg ;
> +
> +# define DEFINE_EXTABLE_TYPE_REG \
> +	.macro extable_type_reg type:req reg:req ;			\

I love that macro PeterZ!</sarcasm>

> +	.set .Lfound, 0	;						\
> +	.set .Lregnr, 0 ;						\
> +	.irp rs,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,	\
> +	     r14,r15 ;							\
> +	.ifc \reg, %\rs ;						\
> +	.set .Lfound, .Lfound+1 ;					\
> +	.long \type + (.Lregnr << 8) ;					\
> +	.endif ;							\
> +	.set .Lregnr, .Lregnr+1 ;					\
> +	.endr ;								\
> +	.set .Lregnr, 0 ;						\
> +	.irp rs,eax,ecx,edx,ebx,esp,ebp,esi,edi,r8d,r9d,r10d,r11d,r12d, \
> +	     r13d,r14d,r15d ;						\
> +	.ifc \reg, %\rs ;						\
> +	.set .Lfound, .Lfound+1 ;					\
> +	.long \type + (.Lregnr << 8) ;					\
> +	.endif ;							\
> +	.set .Lregnr, .Lregnr+1 ;					\
> +	.endr ;								\
> +	.if (.Lfound != 1) ;						\
> +	.error "extable_type_reg: bad register argument" ;		\
> +	.endif ;							\
> +	.endm ;
> +
>  # define _ASM_EXTABLE_TYPE(from, to, type)			\
>  	.pushsection "__ex_table","a" ;				\
>  	.balign 4 ;						\
> @@ -140,6 +169,16 @@
>  	.long type ;						\
>  	.popsection
>  
> +# define _ASM_EXTABLE_TYPE_REG(from, to, type1, reg1)		\
> +	.pushsection "__ex_table","a" ;				\
> +	.balign 4 ;						\
> +	.long (from) - . ;					\
> +	.long (to) - . ;					\
> +	DEFINE_EXTABLE_TYPE_REG					\
> +	extable_type_reg reg=reg1, type=type1 ;			\
> +	UNDEFINE_EXTABLE_TYPE_REG				\
> +	.popsection
> +
>  # ifdef CONFIG_KPROBES
>  #  define _ASM_NOKPROBE(entry)					\
>  	.pushsection "_kprobe_blacklist","aw" ;			\
> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
> index 45697e04d771..6a4995e4cfae 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -79,4 +79,40 @@ __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
>  	kasan_check_write(dst, size);
>  	return __copy_user_flushcache(dst, src, size);
>  }
> +
> +/*
> + * Zero Userspace.
> + */
> +
> +__must_check unsigned long
> +clear_user_original(void __user *addr, unsigned long len);
> +__must_check unsigned long
> +clear_user_rep_good(void __user *addr, unsigned long len);
> +__must_check unsigned long
> +clear_user_erms(void __user *addr, unsigned long len);
> +
> +static __always_inline __must_check unsigned long
> +___clear_user(void __user *addr, unsigned long len)
> +{
> +	unsigned long	ret;
> +
> +	/*
> +	 * No memory constraint because it doesn't change any memory gcc
> +	 * knows about.
> +	 */
> +
> +	might_fault();

I think you could do the stac(); clac() sandwich around the
alternative_call_2 here and remove the respective calls from the asm.

> +	alternative_call_2(
> +		clear_user_original,
> +		clear_user_rep_good,
> +		X86_FEATURE_REP_GOOD,
> +		clear_user_erms,
> +		X86_FEATURE_ERMS,
> +		ASM_OUTPUT2("=a" (ret), "=D" (addr), "=c" (len)),

You can do here:

                           : "+&c" (size), "+&D" (addr)
                           :: "eax");

because size and addr need to be earlyclobbers:

  e0a96129db57 ("x86: use early clobbers in usercopy*.c")

and then simply return size;

The asm modifies it anyway - no need for ret.

In any case, thanks for doing that!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
