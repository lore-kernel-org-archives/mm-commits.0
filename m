Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793328357;
	b=18hyoAYrMb6qX4GkXW3XUuh/LhMyp+EGnBZu2wkzHclg7k+4KO4Sfl7uRG8SS3Vxz+r1
	 +9TrtPMqAv1XTOdWktKvdx0fGcIomDjbMo84ym0CDqLACwEAbT/Y7UbyEwOrLT52Mg80T
	 4KfpshMPyINONCerg3oiK873yCg96/LMw5uUzOk4dkkGnI7W9IycsTI5wBm/0ztCWESUd
	 LQBI/kfI0q/f+Vx5N/scGImyTuBkYB5bBAnNbdtnsr+zvFJaT1uI2vElPviBTGO46Uhwg
	 YPgH//qiwErbFM14ABv+iZhMdS/kJaIO8T8KMd2TGHoKf2huhWZIjIAJZoJFbk0r+qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793328357;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=sHZRowa0vYWITDnWIAImzotHpUEU/UCpafntur4GKBo=;
	b=5i+6O7ND4ECApJ0Lbb11mDEzlGwaFnsfYMf/VJp8MErW7t9aB1xI3OKGZNdzfqS/VZkl
	 RsvGlB2n9sHwZ4PE0fVxCvRNaLhBMvxkUFNVC3waMAxcYbE6dIs/Brpq+FhlhoceYi9HP
	 +SU5J4bwUHaOR0ogFLFphb+LvJEZ+1WN60dKne4Ayx6QORN1o5E+MvZf0GpUZiLjsFWLL
	 DPQXtkpR4n924OU17qW2cu8JnikEsVdRC46F9pWJtlQjl7EeJ+CjkENj/ZeBSuFYkEov7
	 0BOQhCkb7CezJoRORxVUvvmch0ttCubzkOHOcUaorcGWhlPHDOzdd6bWpSAMyQ5bFPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O7gBBefU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9612E606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 02:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O7gBBefU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094D31F000C1;
	Fri, 30 Oct 2026 02:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793328356;
	bh=sHZRowa0vYWITDnWIAImzotHpUEU/UCpafntur4GKBo=;
	h=Date:To:From:Subject;
	b=O7gBBefUAGaN9nF4VMm5BwvfR3C1OkgCqlYd5gSByD4vvwLT5h9lCWWgRBdHw78id
	 Ow0uOAoz4IKwV0czu4Lr4nDfBv25stoHQmmZSZQL+4w+YHS9RNcBss7hHAWzbSk1g9
	 MXtrjkGyExeGXHeCaCl2mOx4gvJMR1N8KlPFUXIM=
Date: Thu, 29 Oct 2026 19:45:55 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,david.laight.linux@gmail.com,
	ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-remove-obsolete-mmx-optimized-code.patch added to mm-nonmm-unstable branch
Message-Id: <20261030024556.094D31F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: xor: remove obsolete MMX optimized code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-remove-obsolete-mmx-optimized-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-remove-obsolete-mmx-optimized-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Eric Biggers <ebiggers@kernel.org>
Subject: xor: remove obsolete MMX optimized code
Date: Sun, 25 Oct 2026 12:12:05 -0700

Patch series "raid: remove obsolete MMX optimized code", v1.

This series retires 32-bit MMX optimizations for RAID.

Affected CPUs, such as the Pentium MMX and Pentium II, will just fall
back to the existing well-tested scalar code instead.

This was the only remaining MMX optimized code in the kernel.  MMX
optimizations for the much more commonly called functions memcpy(),
copy_page(), and clear_page() were already removed years ago by commit
c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").  There are zero MMX
optimizations for anything else, like crypto or CRC, which left the RAID
code as an outlier.

Patch 3 also cleans up the CPU feature checks in the RAID6 code.


This patch (of 3):

The MMX optimized XOR code is used only on 25-year old 32-bit CPUs that
lack SSE support -- and only on systems that actually have a RAID array.
Those CPUs already have well-tested scalar C fallbacks.

Together with the RAID6 code, it's also the only remaining MMX optimized
code in the kernel.  MMX optimizations for the much more commonly called
functions memcpy(), copy_page(), and clear_page() were already removed
years ago by commit c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").

Remove the MMX optimized XOR code.

Link: https://lore.kernel.org/20261025191207.86590-1-ebiggers@kernel.org
Link: https://lore.kernel.org/20261025191207.86590-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Laight <david.laight.linux@gmail.com>
---

 lib/raid/xor/Makefile       |    2 
 lib/raid/xor/x86/xor-mmx.c  |  515 ----------------------------------
 lib/raid/xor/x86/xor_arch.h |    5 
 3 files changed, 1 insertion(+), 521 deletions(-)

--- a/lib/raid/xor/Makefile~xor-remove-obsolete-mmx-optimized-code
+++ a/lib/raid/xor/Makefile
@@ -30,7 +30,7 @@ xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o
 xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
 xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
 xor-$(CONFIG_S390)		+= s390/xor.o
-xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
+xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o
 xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-avx512.o
 obj-y				+= tests/
 
--- a/lib/raid/xor/x86/xor_arch.h~xor-remove-obsolete-mmx-optimized-code
+++ a/lib/raid/xor/x86/xor_arch.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 #include <asm/cpufeature.h>
 
-extern struct xor_block_template xor_block_pII_mmx;
-extern struct xor_block_template xor_block_p5_mmx;
 extern struct xor_block_template xor_block_sse;
 extern struct xor_block_template xor_block_sse_pf64;
 extern struct xor_block_template xor_block_avx;
@@ -33,9 +31,6 @@ static __always_inline void __init arch_
 		 */
 		xor_register(&xor_block_sse);
 		xor_register(&xor_block_sse_pf64);
-	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-		xor_register(&xor_block_pII_mmx);
-		xor_register(&xor_block_p5_mmx);
 	} else {
 		xor_register(&xor_block_8regs);
 		xor_register(&xor_block_8regs_p);
diff --git a/lib/raid/xor/x86/xor-mmx.c a/lib/raid/xor/x86/xor-mmx.c
deleted file mode 100644
--- a/lib/raid/xor/x86/xor-mmx.c
+++ /dev/null
@@ -1,515 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Optimized XOR parity functions for MMX.
- *
- * Copyright (C) 1998 Ingo Molnar.
- */
-#include <asm/fpu/api.h>
-#include "xor_impl.h"
-#include "xor_arch.h"
-
-#define LD(x, y)	"       movq   8*("#x")(%1), %%mm"#y"   ;\n"
-#define ST(x, y)	"       movq %%mm"#y",   8*("#x")(%1)   ;\n"
-#define XO1(x, y)	"       pxor   8*("#x")(%2), %%mm"#y"   ;\n"
-#define XO2(x, y)	"       pxor   8*("#x")(%3), %%mm"#y"   ;\n"
-#define XO3(x, y)	"       pxor   8*("#x")(%4), %%mm"#y"   ;\n"
-#define XO4(x, y)	"       pxor   8*("#x")(%5), %%mm"#y"   ;\n"
-
-static void
-xor_pII_mmx_2(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 7;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-	ST(i, 0)				\
-		XO1(i+1, 1)			\
-		ST(i+1, 1)			\
-			XO1(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-}
-
-static void
-xor_pII_mmx_3(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 7;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-		XO1(i + 1, 1)			\
-			XO1(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-	XO2(i, 0)				\
-	ST(i, 0)				\
-		XO2(i + 1, 1)			\
-		ST(i + 1, 1)			\
-			XO2(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO2(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       addl $128, %3         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	:
-	: "memory");
-}
-
-static void
-xor_pII_mmx_4(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3,
-	      const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 7;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-		XO1(i + 1, 1)			\
-			XO1(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-	XO2(i, 0)				\
-		XO2(i + 1, 1)			\
-			XO2(i + 2, 2)		\
-				XO2(i + 3, 3)	\
-	XO3(i, 0)				\
-	ST(i, 0)				\
-		XO3(i + 1, 1)			\
-		ST(i + 1, 1)			\
-			XO3(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO3(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       addl $128, %3         ;\n"
-	"       addl $128, %4         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory");
-}
-
-
-static void
-xor_pII_mmx_5(unsigned long bytes, unsigned long * __restrict p1,
-	      const unsigned long * __restrict p2,
-	      const unsigned long * __restrict p3,
-	      const unsigned long * __restrict p4,
-	      const unsigned long * __restrict p5)
-{
-	unsigned long lines = bytes >> 7;
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)				\
-	LD(i, 0)				\
-		LD(i + 1, 1)			\
-			LD(i + 2, 2)		\
-				LD(i + 3, 3)	\
-	XO1(i, 0)				\
-		XO1(i + 1, 1)			\
-			XO1(i + 2, 2)		\
-				XO1(i + 3, 3)	\
-	XO2(i, 0)				\
-		XO2(i + 1, 1)			\
-			XO2(i + 2, 2)		\
-				XO2(i + 3, 3)	\
-	XO3(i, 0)				\
-		XO3(i + 1, 1)			\
-			XO3(i + 2, 2)		\
-				XO3(i + 3, 3)	\
-	XO4(i, 0)				\
-	ST(i, 0)				\
-		XO4(i + 1, 1)			\
-		ST(i + 1, 1)			\
-			XO4(i + 2, 2)		\
-			ST(i + 2, 2)		\
-				XO4(i + 3, 3)	\
-				ST(i + 3, 3)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-	BLOCK(0)
-	BLOCK(4)
-	BLOCK(8)
-	BLOCK(12)
-
-	"       addl $128, %1         ;\n"
-	"       addl $128, %2         ;\n"
-	"       addl $128, %3         ;\n"
-	"       addl $128, %4         ;\n"
-	"       addl $128, %5         ;\n"
-	"       decl %0               ;\n"
-	"       jnz 1b                ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-}
-
-#undef LD
-#undef XO1
-#undef XO2
-#undef XO3
-#undef XO4
-#undef ST
-#undef BLOCK
-
-static void
-xor_p5_mmx_2(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2)
-{
-	unsigned long lines = bytes >> 6;
-
-	asm volatile(
-	" .align 32	             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-}
-
-static void
-xor_p5_mmx_3(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3)
-{
-	unsigned long lines = bytes >> 6;
-
-	asm volatile(
-	" .align 32,0x90             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       pxor   (%3), %%mm0   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       pxor  8(%3), %%mm1   ;\n"
-	"       pxor 16(%3), %%mm2   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       pxor 24(%3), %%mm3   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       pxor 32(%3), %%mm4   ;\n"
-	"       pxor 40(%3), %%mm5   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       pxor 48(%3), %%mm6   ;\n"
-	"       pxor 56(%3), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       addl $64, %3         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	:
-	: "memory" );
-}
-
-static void
-xor_p5_mmx_4(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4)
-{
-	unsigned long lines = bytes >> 6;
-
-	asm volatile(
-	" .align 32,0x90             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       pxor   (%3), %%mm0   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       pxor  8(%3), %%mm1   ;\n"
-	"       pxor   (%4), %%mm0   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       pxor 16(%3), %%mm2   ;\n"
-	"       pxor  8(%4), %%mm1   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       pxor 16(%4), %%mm2   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       pxor 24(%3), %%mm3   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       pxor 32(%3), %%mm4   ;\n"
-	"       pxor 24(%4), %%mm3   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       pxor 40(%3), %%mm5   ;\n"
-	"       pxor 32(%4), %%mm4   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       pxor 40(%4), %%mm5   ;\n"
-	"       pxor 48(%3), %%mm6   ;\n"
-	"       pxor 56(%3), %%mm7   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 48(%4), %%mm6   ;\n"
-	"       pxor 56(%4), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       addl $64, %3         ;\n"
-	"       addl $64, %4         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory");
-}
-
-static void
-xor_p5_mmx_5(unsigned long bytes, unsigned long * __restrict p1,
-	     const unsigned long * __restrict p2,
-	     const unsigned long * __restrict p3,
-	     const unsigned long * __restrict p4,
-	     const unsigned long * __restrict p5)
-{
-	unsigned long lines = bytes >> 6;
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-	" .align 32,0x90             ;\n"
-	" 1:                         ;\n"
-	"       movq   (%1), %%mm0   ;\n"
-	"       movq  8(%1), %%mm1   ;\n"
-	"       pxor   (%2), %%mm0   ;\n"
-	"       pxor  8(%2), %%mm1   ;\n"
-	"       movq 16(%1), %%mm2   ;\n"
-	"       pxor   (%3), %%mm0   ;\n"
-	"       pxor  8(%3), %%mm1   ;\n"
-	"       pxor 16(%2), %%mm2   ;\n"
-	"       pxor   (%4), %%mm0   ;\n"
-	"       pxor  8(%4), %%mm1   ;\n"
-	"       pxor 16(%3), %%mm2   ;\n"
-	"       movq 24(%1), %%mm3   ;\n"
-	"       pxor   (%5), %%mm0   ;\n"
-	"       pxor  8(%5), %%mm1   ;\n"
-	"       movq %%mm0,   (%1)   ;\n"
-	"       pxor 16(%4), %%mm2   ;\n"
-	"       pxor 24(%2), %%mm3   ;\n"
-	"       movq %%mm1,  8(%1)   ;\n"
-	"       pxor 16(%5), %%mm2   ;\n"
-	"       pxor 24(%3), %%mm3   ;\n"
-	"       movq 32(%1), %%mm4   ;\n"
-	"       movq %%mm2, 16(%1)   ;\n"
-	"       pxor 24(%4), %%mm3   ;\n"
-	"       pxor 32(%2), %%mm4   ;\n"
-	"       movq 40(%1), %%mm5   ;\n"
-	"       pxor 24(%5), %%mm3   ;\n"
-	"       pxor 32(%3), %%mm4   ;\n"
-	"       pxor 40(%2), %%mm5   ;\n"
-	"       movq %%mm3, 24(%1)   ;\n"
-	"       pxor 32(%4), %%mm4   ;\n"
-	"       pxor 40(%3), %%mm5   ;\n"
-	"       movq 48(%1), %%mm6   ;\n"
-	"       movq 56(%1), %%mm7   ;\n"
-	"       pxor 32(%5), %%mm4   ;\n"
-	"       pxor 40(%4), %%mm5   ;\n"
-	"       pxor 48(%2), %%mm6   ;\n"
-	"       pxor 56(%2), %%mm7   ;\n"
-	"       movq %%mm4, 32(%1)   ;\n"
-	"       pxor 48(%3), %%mm6   ;\n"
-	"       pxor 56(%3), %%mm7   ;\n"
-	"       pxor 40(%5), %%mm5   ;\n"
-	"       pxor 48(%4), %%mm6   ;\n"
-	"       pxor 56(%4), %%mm7   ;\n"
-	"       movq %%mm5, 40(%1)   ;\n"
-	"       pxor 48(%5), %%mm6   ;\n"
-	"       pxor 56(%5), %%mm7   ;\n"
-	"       movq %%mm6, 48(%1)   ;\n"
-	"       movq %%mm7, 56(%1)   ;\n"
-
-	"       addl $64, %1         ;\n"
-	"       addl $64, %2         ;\n"
-	"       addl $64, %3         ;\n"
-	"       addl $64, %4         ;\n"
-	"       addl $64, %5         ;\n"
-	"       decl %0              ;\n"
-	"       jnz 1b               ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-}
-
-DO_XOR_BLOCKS(pII_mmx_inner, xor_pII_mmx_2, xor_pII_mmx_3, xor_pII_mmx_4,
-		xor_pII_mmx_5);
-
-static void xor_gen_pII_mmx(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes)
-{
-	kernel_fpu_begin();
-	xor_gen_pII_mmx_inner(dest, srcs, src_cnt, bytes);
-	kernel_fpu_end();
-}
-
-struct xor_block_template xor_block_pII_mmx = {
-	.name		= "pII_mmx",
-	.xor_gen	= xor_gen_pII_mmx,
-};
-
-DO_XOR_BLOCKS(p5_mmx_inner, xor_p5_mmx_2, xor_p5_mmx_3, xor_p5_mmx_4,
-		xor_p5_mmx_5);
-
-static void xor_gen_p5_mmx(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes)
-{
-	kernel_fpu_begin();
-	xor_gen_p5_mmx_inner(dest, srcs, src_cnt, bytes);
-	kernel_fpu_end();
-}
-
-struct xor_block_template xor_block_p5_mmx = {
-	.name		= "p5_mmx",
-	.xor_gen	= xor_gen_p5_mmx,
-};
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-remove-obsolete-mmx-optimized-code.patch
raid6-remove-obsolete-mmx-optimized-code.patch
raid6-simplify-cpu-feature-checks.patch

