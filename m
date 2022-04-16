Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7C8C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 16 Apr 2022 14:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiDPOKf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Apr 2022 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiDPOKf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2022 10:10:35 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EECC2127F
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 07:08:02 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m15-20020a7bca4f000000b0038fdc1394b1so5698772wml.2
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 07:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=uF6OsoJuv8Gn1RZ5HbuH+1a/CFsaDCHXY66jKKDePe4=;
        b=aOjQXL9ADcCktqPPcdOnu6EKxaJ3Bt56tZGsN7Gk82MFHAcamNCWw6jsYnGpPh22Sb
         SP0majfdlfjNN4efdNc4+KmLBKaGrq/vaSJygxgzUSadw7Wwpc+MmUYr5bv24D4B39gG
         4otR/P9NYZRP6uPlUDhs0tdtYlRMt83J0AleyQGZqhGvvyLz6/VcGqwfv3Y6vueeO40o
         8MrLVs7ZYpd6gBNZS/heyP96XzLvUWfJuqK9ujGTSZLoXyhmM6fSEFYQp6l7bHiq+bbC
         OXhlzvnONau1N4luhcSaOZAd7E9BgVNGNXDsGXUvdfyKGQIhZjljCEElfgh42J3tq9sP
         d9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=uF6OsoJuv8Gn1RZ5HbuH+1a/CFsaDCHXY66jKKDePe4=;
        b=U6iJzfL7mOosLnNZFMkHgIMbCCdqF2bf1BLPnBoVz3eyndUqk/FbWKHBfrUl9C3XFA
         YTwqpRS/vH6mNVNo5rdLh1WweMhhiLvfuKWwxgdcfaO5O5E+Q+QrXR9851mb8djyZIn1
         iZunCWFRbDOoJSkMJGPEyBSXI2aI4GlwF6c77ElGFWXVW3BpsliY/SMmTScChl+v5taN
         eV1YJon+D6sS8hhpi7KCT5IMbBmaUuU3gxzn7OjunyA1Nrb4oni17qaoPRoiUpq09e3z
         XE7MoFqURyG1IfZ770NBJTSiwmLHjwt7sLxDQZvfYTdBgj8OaUgvp0XuClp7GMQZ0lCy
         vfNw==
X-Gm-Message-State: AOAM533a3XZl+s595BuUBThEng0bCnr1t1VeGtGUXBMosOc4MigRBsWk
        w4mEfLrUIP5IcwKduLg7rME=
X-Google-Smtp-Source: ABdhPJxb0wjIHqmBv7hjF0Xl+y1V0MawgA8KfEcXqU+1TUpzZpKLE+8LFetF1mioXNo1GVcixmnE/g==
X-Received: by 2002:a05:600c:4ecb:b0:392:88ed:1ef9 with SMTP id g11-20020a05600c4ecb00b0039288ed1ef9mr3335342wmq.68.1650118081074;
        Sat, 16 Apr 2022 07:08:01 -0700 (PDT)
Received: from linux-dev (host86-172-30-253.range86-172.btcentralplus.com. [86.172.30.253])
        by smtp.gmail.com with ESMTPSA id u5-20020a5d6ac5000000b00207e90b2869sm6278215wrw.91.2022.04.16.07.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 07:08:00 -0700 (PDT)
From:   Mark Hemment <markhemm@googlemail.com>
X-Google-Original-From: Mark Hemment <markhe@gmail.com>
Date:   Sat, 16 Apr 2022 15:07:47 +0100 (BST)
To:     Borislav Petkov <bp@alien8.de>
cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        markhemm@googlemail.com, Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of
 ZERO_PAGE
In-Reply-To: <Ylpj9of+CP4ipDtm@zn.tnic>
Message-ID: <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org> <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com> <Ylpj9of+CP4ipDtm@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On Sat, 16 Apr 2022, Borislav Petkov wrote:

> On Fri, Apr 15, 2022 at 03:10:51PM -0700, Linus Torvalds wrote:
> > Adding PeterZ and Borislav (who seem to be the last ones to have
> > worked on the copy and clear_page stuff respectively) and the x86
> > maintainers in case somebody gets the urge to just fix this.
> 
> I guess if enough people ask and keep asking, some people at least try
> to move...
> 
> > Because memory clearing should be faster than copying, and the thing
> > that makes copying fast is that FSRM and ERMS logic (the whole
> > "manually unrolled copy" is hopefully mostly a thing of the past and
> > we can consider it legacy)
> 
> So I did give it a look and it seems to me, if we want to do the
> alternatives thing here, it will have to look something like
> arch/x86/lib/copy_user_64.S.
> 
> I.e., the current __clear_user() will have to become the "handle_tail"
> thing there which deals with uncopied rest-bytes at the end and the new
> fsrm/erms/rep_good variants will then be alternative_call_2 or _3.
> 
> The fsrm thing will have only the handle_tail thing at the end when size
> != 0.
> 
> The others - erms and rep_good - will have to check for sizes smaller
> than, say a cacheline, and for those call the handle_tail thing directly
> instead of going into a REP loop. The current __clear_user() is still a
> lot better than that copy_user_generic_unrolled() abomination. And it's
> not like old CPUs would get any perf penalty - they'll simply use the
> same code.
> 
> And then you need the labels for _ASM_EXTABLE_UA() exception handling.
> 
> Anyway, something along those lines.
> 
> And then we'll need to benchmark this on a bunch of current machines to
> make sure there's no funny surprises, perf-wise.
> 
> I can get cracking on this but I would advise people not to hold their
> breaths. :)
> 
> Unless someone has a better idea or is itching to get hands dirty
> her-/himself.

I've done a skeleton implementation of alternative __clear_user() based on 
CPU features.
It has three versions of __clear_user();
o __clear_user_original() - similar to the 'standard' __clear_user()
o __clear_user_rep_good() - using resp stos{qb} when CPU has 'rep_good'
o __clear_user_erms() - using 'resp stosb' when CPU has 'erms'

Not claiming the implementation is ideal, but might be a useful starting 
point for someone.
Patch is against 5.18.0-rc2.
Only basic sanity testing done.

Simple performance testing done for large sizes, on a system (Intel E8400) 
which has rep_good but not erms;
# dd if=/dev/zero of=/dev/null bs=16384 count=10000
o *_original() - ~14.2GB/s.  Same as the 'standard' __clear_user().
o *_rep_good() - same throughput as *_original().
o *_erms()     - ~12.2GB/s (expected on a system without erms).

No performance testing done for zeroing small sizes.

Cheers,
Mark

Signed-off-by: Mark Hemment <markhemm@googlemail.com>
---
 arch/x86/include/asm/asm.h        |  39 +++++++++++++++
 arch/x86/include/asm/uaccess_64.h |  36 ++++++++++++++
 arch/x86/lib/clear_page_64.S      | 100 ++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/usercopy_64.c        |  32 ------------
 4 files changed, 175 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index fbcfec4dc4cc..373ed6be7a8d 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -132,6 +132,35 @@
 /* Exception table entry */
 #ifdef __ASSEMBLY__
 
+# define UNDEFINE_EXTABLE_TYPE_REG \
+	.purgem extable_type_reg ;
+
+# define DEFINE_EXTABLE_TYPE_REG \
+	.macro extable_type_reg type:req reg:req ;			\
+	.set .Lfound, 0	;						\
+	.set .Lregnr, 0 ;						\
+	.irp rs,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,	\
+	     r14,r15 ;							\
+	.ifc \reg, %\rs ;						\
+	.set .Lfound, .Lfound+1 ;					\
+	.long \type + (.Lregnr << 8) ;					\
+	.endif ;							\
+	.set .Lregnr, .Lregnr+1 ;					\
+	.endr ;								\
+	.set .Lregnr, 0 ;						\
+	.irp rs,eax,ecx,edx,ebx,esp,ebp,esi,edi,r8d,r9d,r10d,r11d,r12d, \
+	     r13d,r14d,r15d ;						\
+	.ifc \reg, %\rs ;						\
+	.set .Lfound, .Lfound+1 ;					\
+	.long \type + (.Lregnr << 8) ;					\
+	.endif ;							\
+	.set .Lregnr, .Lregnr+1 ;					\
+	.endr ;								\
+	.if (.Lfound != 1) ;						\
+	.error "extable_type_reg: bad register argument" ;		\
+	.endif ;							\
+	.endm ;
+
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
 	.pushsection "__ex_table","a" ;				\
 	.balign 4 ;						\
@@ -140,6 +169,16 @@
 	.long type ;						\
 	.popsection
 
+# define _ASM_EXTABLE_TYPE_REG(from, to, type1, reg1)		\
+	.pushsection "__ex_table","a" ;				\
+	.balign 4 ;						\
+	.long (from) - . ;					\
+	.long (to) - . ;					\
+	DEFINE_EXTABLE_TYPE_REG					\
+	extable_type_reg reg=reg1, type=type1 ;			\
+	UNDEFINE_EXTABLE_TYPE_REG				\
+	.popsection
+
 # ifdef CONFIG_KPROBES
 #  define _ASM_NOKPROBE(entry)					\
 	.pushsection "_kprobe_blacklist","aw" ;			\
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 45697e04d771..6a4995e4cfae 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -79,4 +79,40 @@ __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
 	kasan_check_write(dst, size);
 	return __copy_user_flushcache(dst, src, size);
 }
+
+/*
+ * Zero Userspace.
+ */
+
+__must_check unsigned long
+clear_user_original(void __user *addr, unsigned long len);
+__must_check unsigned long
+clear_user_rep_good(void __user *addr, unsigned long len);
+__must_check unsigned long
+clear_user_erms(void __user *addr, unsigned long len);
+
+static __always_inline __must_check unsigned long
+___clear_user(void __user *addr, unsigned long len)
+{
+	unsigned long	ret;
+
+	/*
+	 * No memory constraint because it doesn't change any memory gcc
+	 * knows about.
+	 */
+
+	might_fault();
+	alternative_call_2(
+		clear_user_original,
+		clear_user_rep_good,
+		X86_FEATURE_REP_GOOD,
+		clear_user_erms,
+		X86_FEATURE_ERMS,
+		ASM_OUTPUT2("=a" (ret), "=D" (addr), "=c" (len)),
+		"1" (addr), "2" (len)
+		: "%rdx", "cc");
+	return ret;
+}
+
+#define __clear_user(d, n)	___clear_user(d, n)
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index fe59b8ac4fcc..abe1f44ea422 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 #include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/smap.h>
 #include <asm/export.h>
 
 /*
@@ -50,3 +52,101 @@ SYM_FUNC_START(clear_page_erms)
 	RET
 SYM_FUNC_END(clear_page_erms)
 EXPORT_SYMBOL_GPL(clear_page_erms)
+
+/*
+ * Default clear user-space.
+ * Input:
+ * rdi destination
+ * rcx count
+ *
+ * Output:
+ * rax uncopied bytes or 0 if successful.
+ */
+
+SYM_FUNC_START(clear_user_original)
+	ASM_STAC
+	movq %rcx,%rax
+	shrq $3,%rcx
+	andq $7,%rax
+	testq %rcx,%rcx
+	jz 1f
+
+	.p2align 4
+0:	movq $0,(%rdi)
+	leaq 8(%rdi),%rdi
+	decq %rcx
+	jnz   0b
+
+1:	movq %rax,%rcx
+	testq %rcx,%rcx
+	jz 3f
+
+2:	movb $0,(%rdi)
+	incq %rdi
+	decl %ecx
+	jnz  2b
+
+3:	ASM_CLAC
+	movq %rcx,%rax
+	RET
+
+	_ASM_EXTABLE_TYPE_REG(0b, 3b, EX_TYPE_UCOPY_LEN8, %rax)
+	_ASM_EXTABLE_UA(2b, 3b)
+SYM_FUNC_END(clear_user_original)
+EXPORT_SYMBOL(clear_user_original)
+
+/*
+ * Alternative clear user-space when CPU feature X86_FEATURE_REP_GOOD is
+ * present.
+ * Input:
+ * rdi destination
+ * rcx count
+ *
+ * Output:
+ * rax uncopied bytes or 0 if successful.
+ */
+
+SYM_FUNC_START(clear_user_rep_good)
+	ASM_STAC
+	movq %rcx,%rdx
+	xorq %rax,%rax
+	shrq $3,%rcx
+	andq $7,%rdx
+
+0:	rep stosq
+	movq %rdx,%rcx
+
+1:	rep stosb
+
+3:	ASM_CLAC
+	movq %rcx,%rax
+	RET
+
+	_ASM_EXTABLE_TYPE_REG(0b, 3b, EX_TYPE_UCOPY_LEN8, %rdx)
+	_ASM_EXTABLE_UA(1b, 3b)
+SYM_FUNC_END(clear_user_rep_good)
+EXPORT_SYMBOL(clear_user_rep_good)
+
+/*
+ * Alternative clear user-space when CPU feature X86_FEATURE_ERMS is present.
+ * Input:
+ * rdi destination
+ * rcx count
+ *
+ * Output:
+ * rax uncopied bytes or 0 if successful.
+ */
+
+SYM_FUNC_START(clear_user_erms)
+	xorq %rax,%rax
+	ASM_STAC
+
+0:	rep stosb
+
+3:	ASM_CLAC
+	movq %rcx,%rax
+	RET
+
+	_ASM_EXTABLE_UA(0b, 3b)
+SYM_FUNC_END(clear_user_erms)
+EXPORT_SYMBOL(clear_user_erms)
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 0402a749f3a0..3a2872c9c4a9 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -14,38 +14,6 @@
  * Zero Userspace
  */
 
-unsigned long __clear_user(void __user *addr, unsigned long size)
-{
-	long __d0;
-	might_fault();
-	/* no memory constraint because it doesn't change any memory gcc knows
-	   about */
-	stac();
-	asm volatile(
-		"	testq  %[size8],%[size8]\n"
-		"	jz     4f\n"
-		"	.align 16\n"
-		"0:	movq $0,(%[dst])\n"
-		"	addq   $8,%[dst]\n"
-		"	decl %%ecx ; jnz   0b\n"
-		"4:	movq  %[size1],%%rcx\n"
-		"	testl %%ecx,%%ecx\n"
-		"	jz     2f\n"
-		"1:	movb   $0,(%[dst])\n"
-		"	incq   %[dst]\n"
-		"	decl %%ecx ; jnz  1b\n"
-		"2:\n"
-
-		_ASM_EXTABLE_TYPE_REG(0b, 2b, EX_TYPE_UCOPY_LEN8, %[size1])
-		_ASM_EXTABLE_UA(1b, 2b)
-
-		: [size8] "=&c"(size), [dst] "=&D" (__d0)
-		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr));
-	clac();
-	return size;
-}
-EXPORT_SYMBOL(__clear_user);
-
 unsigned long clear_user(void __user *to, unsigned long n)
 {
 	if (access_ok(to, n))
