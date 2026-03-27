Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3113750A4
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633790; cv=none; b=M3oMv15+9AfLr1m82DFYLbSWKXhR5v+7JWAutfj0kgtPO6asSKSRWDUDAe7LnDSeD+L69ma1J5dhlALXWOPE2JDtRzBfVwbsucE74FAeyJDTewNd469TEz1unQHGdZhxKWiOhIz44PthS6q8MPQXFY43hLve1nC7LPrt073709o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633790; c=relaxed/simple;
	bh=Ozkplas4Dy2UzlLyzE3uj7hyBbKHigRgj/c0KicSL08=;
	h=Date:To:From:Subject:Message-Id; b=tlONfiC2VILfU2UXbf5VX/d5U3GbNnHSvJA2xVxKGyvnpJw0TtdpZhfBOErDy7W0LBjgr6D6NnuwkHip+a2TcGDyZJLwaGPydqW7Gq+RAYgeTLN/sNvWQ8OCkh1Bz6/yipuxMbMBWLFa2NUW7Wpk0RZSJ7tmrgmhgBH0x9w3+U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dLqqW5rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dLqqW5rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12550C19423;
	Fri, 27 Mar 2026 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633790;
	bh=Ozkplas4Dy2UzlLyzE3uj7hyBbKHigRgj/c0KicSL08=;
	h=Date:To:From:Subject:From;
	b=dLqqW5rC8iuvuzApluT6xnZF8ljK27yIb5e3a6RsvQS2nMlwwTMfT2aHzyHeu+Qc2
	 JRBjVR7r9O9qDq0TwmLBVOJXfok1G+lvzajdoe7ujxDgxVCQf2Ep7K11aawNZm716p
	 HoMrKXXiC9DX5zzcl80jxuhOsAfwUBl/WqrM8zTs=
Date: Fri, 27 Mar 2026 10:49:49 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-remove-macro-abuse-for-xor-implementation-registrations.patch added to mm-nonmm-unstable branch
Message-Id: <20260327174950.12550C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: remove macro abuse for XOR implementation registrations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-remove-macro-abuse-for-xor-implementation-registrations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-remove-macro-abuse-for-xor-implementation-registrations.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: xor: remove macro abuse for XOR implementation registrations
Date: Fri, 27 Mar 2026 07:16:41 +0100

Drop the pretty confusing historic XOR_TRY_TEMPLATES and
XOR_SELECT_TEMPLATE, and instead let the architectures provide a
arch_xor_init that calls either xor_register to register candidates or
xor_force to force a specific implementation.

Link: https://lkml.kernel.org/r/20260327061704.3707577-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/xor.h     |   29 +++++++++++---------
 arch/arm/include/asm/xor.h       |   25 ++++++++---------
 arch/arm64/include/asm/xor.h     |   18 ++++++------
 arch/loongarch/include/asm/xor.h |   42 +++++++++++------------------
 arch/powerpc/include/asm/xor.h   |   31 ++++++++-------------
 arch/riscv/include/asm/xor.h     |   19 ++++++-------
 arch/s390/include/asm/xor.h      |   12 +++-----
 arch/sparc/include/asm/xor_32.h  |   14 ++++-----
 arch/sparc/include/asm/xor_64.h  |   31 +++++++++------------
 arch/x86/include/asm/xor.h       |    3 --
 arch/x86/include/asm/xor_32.h    |   36 +++++++++++++-----------
 arch/x86/include/asm/xor_64.h    |   18 +++++++-----
 arch/x86/include/asm/xor_avx.h   |    9 ------
 include/asm-generic/xor.h        |    8 -----
 include/linux/raid/xor_impl.h    |    5 +++
 lib/raid/xor/xor-core.c          |   41 +++++++++++++++++++++-------
 16 files changed, 168 insertions(+), 173 deletions(-)

--- a/arch/alpha/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/alpha/include/asm/xor.h
@@ -851,16 +851,19 @@ static struct xor_block_template xor_blo
 /* For grins, also test the generic routines.  */
 #include <asm-generic/xor.h>
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-	do {						\
-		xor_speed(&xor_block_8regs);		\
-		xor_speed(&xor_block_32regs);		\
-		xor_speed(&xor_block_alpha);		\
-		xor_speed(&xor_block_alpha_prefetch);	\
-	} while (0)
-
-/* Force the use of alpha_prefetch if EV6, as it is significantly
-   faster in the cold cache case.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) \
-	(implver() == IMPLVER_EV6 ? &xor_block_alpha_prefetch : FASTEST)
+/*
+ * Force the use of alpha_prefetch if EV6, as it is significantly faster in the
+ * cold cache case.
+ */
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	if (implver() == IMPLVER_EV6) {
+		xor_force(&xor_block_alpha_prefetch);
+	} else {
+		xor_register(&xor_block_8regs);
+		xor_register(&xor_block_32regs);
+		xor_register(&xor_block_alpha);
+		xor_register(&xor_block_alpha_prefetch);
+	}
+}
--- a/arch/arm64/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/arm64/include/asm/xor.h
@@ -60,14 +60,14 @@ static struct xor_block_template xor_blo
 	.do_4   = xor_neon_4,
 	.do_5	= xor_neon_5
 };
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES           \
-	do {        \
-		xor_speed(&xor_block_8regs);    \
-		xor_speed(&xor_block_32regs);    \
-		if (cpu_has_neon()) { \
-			xor_speed(&xor_block_arm64);\
-		} \
-	} while (0)
+
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_32regs);
+	if (cpu_has_neon())
+		xor_register(&xor_block_arm64);
+}
 
 #endif /* ! CONFIG_KERNEL_MODE_NEON */
--- a/arch/arm/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/arm/include/asm/xor.h
@@ -138,15 +138,6 @@ static struct xor_block_template xor_blo
 	.do_5	= xor_arm4regs_5,
 };
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES			\
-	do {					\
-		xor_speed(&xor_block_arm4regs);	\
-		xor_speed(&xor_block_8regs);	\
-		xor_speed(&xor_block_32regs);	\
-		NEON_TEMPLATES;			\
-	} while (0)
-
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 extern struct xor_block_template const xor_block_neon_inner;
@@ -201,8 +192,16 @@ static struct xor_block_template xor_blo
 	.do_5	= xor_neon_5
 };
 
-#define NEON_TEMPLATES	\
-	do { if (cpu_has_neon()) xor_speed(&xor_block_neon); } while (0)
-#else
-#define NEON_TEMPLATES
+#endif /* CONFIG_KERNEL_MODE_NEON */
+
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_register(&xor_block_arm4regs);
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_32regs);
+#ifdef CONFIG_KERNEL_MODE_NEON
+	if (cpu_has_neon())
+		xor_register(&xor_block_neon);
 #endif
+}
--- a/arch/loongarch/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/loongarch/include/asm/xor.h
@@ -16,14 +16,6 @@ static struct xor_block_template xor_blo
 	.do_4 = xor_lsx_4,
 	.do_5 = xor_lsx_5,
 };
-
-#define XOR_SPEED_LSX()					\
-	do {						\
-		if (cpu_has_lsx)			\
-			xor_speed(&xor_block_lsx);	\
-	} while (0)
-#else /* CONFIG_CPU_HAS_LSX */
-#define XOR_SPEED_LSX()
 #endif /* CONFIG_CPU_HAS_LSX */
 
 #ifdef CONFIG_CPU_HAS_LASX
@@ -34,14 +26,6 @@ static struct xor_block_template xor_blo
 	.do_4 = xor_lasx_4,
 	.do_5 = xor_lasx_5,
 };
-
-#define XOR_SPEED_LASX()					\
-	do {							\
-		if (cpu_has_lasx)				\
-			xor_speed(&xor_block_lasx);		\
-	} while (0)
-#else /* CONFIG_CPU_HAS_LASX */
-#define XOR_SPEED_LASX()
 #endif /* CONFIG_CPU_HAS_LASX */
 
 /*
@@ -54,15 +38,21 @@ static struct xor_block_template xor_blo
  */
 #include <asm-generic/xor.h>
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-do {							\
-	xor_speed(&xor_block_8regs);			\
-	xor_speed(&xor_block_8regs_p);			\
-	xor_speed(&xor_block_32regs);			\
-	xor_speed(&xor_block_32regs_p);			\
-	XOR_SPEED_LSX();				\
-	XOR_SPEED_LASX();				\
-} while (0)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_8regs_p);
+	xor_register(&xor_block_32regs);
+	xor_register(&xor_block_32regs_p);
+#ifdef CONFIG_CPU_HAS_LSX
+	if (cpu_has_lsx)
+		xor_register(&xor_block_lsx);
+#endif
+#ifdef CONFIG_CPU_HAS_LASX
+	if (cpu_has_lasx)
+		xor_register(&xor_block_lasx);
+#endif
+}
 
 #endif /* _ASM_LOONGARCH_XOR_H */
--- a/arch/powerpc/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/powerpc/include/asm/xor.h
@@ -21,27 +21,22 @@ static struct xor_block_template xor_blo
 	.do_4 = xor_altivec_4,
 	.do_5 = xor_altivec_5,
 };
-
-#define XOR_SPEED_ALTIVEC()				\
-	do {						\
-		if (cpu_has_feature(CPU_FTR_ALTIVEC))	\
-			xor_speed(&xor_block_altivec);	\
-	} while (0)
-#else
-#define XOR_SPEED_ALTIVEC()
-#endif
+#endif /* CONFIG_ALTIVEC */
 
 /* Also try the generic routines. */
 #include <asm-generic/xor.h>
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-do {							\
-	xor_speed(&xor_block_8regs);			\
-	xor_speed(&xor_block_8regs_p);			\
-	xor_speed(&xor_block_32regs);			\
-	xor_speed(&xor_block_32regs_p);			\
-	XOR_SPEED_ALTIVEC();				\
-} while (0)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_8regs_p);
+	xor_register(&xor_block_32regs);
+	xor_register(&xor_block_32regs_p);
+#ifdef CONFIG_ALTIVEC
+	if (cpu_has_feature(CPU_FTR_ALTIVEC))
+		xor_register(&xor_block_altivec);
+#endif
+}
 
 #endif /* _ASM_POWERPC_XOR_H */
--- a/arch/riscv/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/riscv/include/asm/xor.h
@@ -55,14 +55,15 @@ static struct xor_block_template xor_blo
 	.do_4 = xor_vector_4,
 	.do_5 = xor_vector_5
 };
+#endif /* CONFIG_RISCV_ISA_V */
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES           \
-	do {        \
-		xor_speed(&xor_block_8regs);    \
-		xor_speed(&xor_block_32regs);    \
-		if (has_vector()) { \
-			xor_speed(&xor_block_rvv);\
-		} \
-	} while (0)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_32regs);
+#ifdef CONFIG_RISCV_ISA_V
+	if (has_vector())
+		xor_register(&xor_block_rvv);
 #endif
+}
--- a/arch/s390/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/s390/include/asm/xor.h
@@ -10,12 +10,10 @@
 
 extern struct xor_block_template xor_block_xc;
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-do {							\
-	xor_speed(&xor_block_xc);			\
-} while (0)
-
-#define XOR_SELECT_TEMPLATE(FASTEST)	(&xor_block_xc)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_force(&xor_block_xc);
+}
 
 #endif /* _ASM_S390_XOR_H */
--- a/arch/sparc/include/asm/xor_32.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/sparc/include/asm/xor_32.h
@@ -259,10 +259,10 @@ static struct xor_block_template xor_blo
 /* For grins, also test the generic routines.  */
 #include <asm-generic/xor.h>
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-	do {						\
-		xor_speed(&xor_block_8regs);		\
-		xor_speed(&xor_block_32regs);		\
-		xor_speed(&xor_block_SPARC);		\
-	} while (0)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_32regs);
+	xor_register(&xor_block_SPARC);
+}
--- a/arch/sparc/include/asm/xor_64.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/sparc/include/asm/xor_64.h
@@ -60,20 +60,17 @@ static struct xor_block_template xor_blo
         .do_5	= xor_niagara_5,
 };
 
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-	do {						\
-		xor_speed(&xor_block_VIS);		\
-		xor_speed(&xor_block_niagara);		\
-	} while (0)
-
-/* For VIS for everything except Niagara.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) \
-	((tlb_type == hypervisor && \
-	  (sun4v_chip_type == SUN4V_CHIP_NIAGARA1 || \
-	   sun4v_chip_type == SUN4V_CHIP_NIAGARA2 || \
-	   sun4v_chip_type == SUN4V_CHIP_NIAGARA3 || \
-	   sun4v_chip_type == SUN4V_CHIP_NIAGARA4 || \
-	   sun4v_chip_type == SUN4V_CHIP_NIAGARA5)) ? \
-	 &xor_block_niagara : \
-	 &xor_block_VIS)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	/* Force VIS for everything except Niagara.  */
+	if (tlb_type == hypervisor &&
+	    (sun4v_chip_type == SUN4V_CHIP_NIAGARA1 ||
+	     sun4v_chip_type == SUN4V_CHIP_NIAGARA2 ||
+	     sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
+	     sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
+	     sun4v_chip_type == SUN4V_CHIP_NIAGARA5))
+		xor_force(&xor_block_niagara);
+	else
+		xor_force(&xor_block_VIS);
+}
--- a/arch/x86/include/asm/xor_32.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/x86/include/asm/xor_32.h
@@ -552,22 +552,24 @@ static struct xor_block_template xor_blo
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-do {							\
-	AVX_XOR_SPEED;					\
-	if (boot_cpu_has(X86_FEATURE_XMM)) {				\
-		xor_speed(&xor_block_pIII_sse);		\
-		xor_speed(&xor_block_sse_pf64);		\
-	} else if (boot_cpu_has(X86_FEATURE_MMX)) {	\
-		xor_speed(&xor_block_pII_mmx);		\
-		xor_speed(&xor_block_p5_mmx);		\
-	} else {					\
-		xor_speed(&xor_block_8regs);		\
-		xor_speed(&xor_block_8regs_p);		\
-		xor_speed(&xor_block_32regs);		\
-		xor_speed(&xor_block_32regs_p);		\
-	}						\
-} while (0)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	if (boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		xor_force(&xor_block_avx);
+	} else if (boot_cpu_has(X86_FEATURE_XMM)) {
+		xor_register(&xor_block_pIII_sse);
+		xor_register(&xor_block_sse_pf64);
+	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
+		xor_register(&xor_block_pII_mmx);
+		xor_register(&xor_block_p5_mmx);
+	} else {
+		xor_register(&xor_block_8regs);
+		xor_register(&xor_block_8regs_p);
+		xor_register(&xor_block_32regs);
+		xor_register(&xor_block_32regs_p);
+	}
+}
 
 #endif /* _ASM_X86_XOR_32_H */
--- a/arch/x86/include/asm/xor_64.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/x86/include/asm/xor_64.h
@@ -17,12 +17,16 @@ static struct xor_block_template xor_blo
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
-#undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES			\
-do {						\
-	AVX_XOR_SPEED;				\
-	xor_speed(&xor_block_sse_pf64);		\
-	xor_speed(&xor_block_sse);		\
-} while (0)
+#define arch_xor_init arch_xor_init
+static __always_inline void __init arch_xor_init(void)
+{
+	if (boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		xor_force(&xor_block_avx);
+	} else {
+		xor_register(&xor_block_sse_pf64);
+		xor_register(&xor_block_sse);
+	}
+}
 
 #endif /* _ASM_X86_XOR_64_H */
--- a/arch/x86/include/asm/xor_avx.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/x86/include/asm/xor_avx.h
@@ -166,13 +166,4 @@ static struct xor_block_template xor_blo
 	.do_5 = xor_avx_5,
 };
 
-#define AVX_XOR_SPEED \
-do { \
-	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_OSXSAVE)) \
-		xor_speed(&xor_block_avx); \
-} while (0)
-
-#define AVX_SELECT(FASTEST) \
-	(boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_OSXSAVE) ? &xor_block_avx : FASTEST)
-
 #endif
--- a/arch/x86/include/asm/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/arch/x86/include/asm/xor.h
@@ -496,7 +496,4 @@ static struct xor_block_template xor_blo
 # include <asm/xor_64.h>
 #endif
 
-#define XOR_SELECT_TEMPLATE(FASTEST) \
-	AVX_SELECT(FASTEST)
-
 #endif /* _ASM_X86_XOR_H */
--- a/include/asm-generic/xor.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/include/asm-generic/xor.h
@@ -728,11 +728,3 @@ static struct xor_block_template xor_blo
 	.do_4 = xor_32regs_p_4,
 	.do_5 = xor_32regs_p_5,
 };
-
-#define XOR_TRY_TEMPLATES			\
-	do {					\
-		xor_speed(&xor_block_8regs);	\
-		xor_speed(&xor_block_8regs_p);	\
-		xor_speed(&xor_block_32regs);	\
-		xor_speed(&xor_block_32regs_p);	\
-	} while (0)
--- a/include/linux/raid/xor_impl.h~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/include/linux/raid/xor_impl.h
@@ -2,6 +2,8 @@
 #ifndef _XOR_IMPL_H
 #define _XOR_IMPL_H
 
+#include <linux/init.h>
+
 struct xor_block_template {
 	struct xor_block_template *next;
 	const char *name;
@@ -22,4 +24,7 @@ struct xor_block_template {
 		     const unsigned long * __restrict);
 };
 
+void __init xor_register(struct xor_block_template *tmpl);
+void __init xor_force(struct xor_block_template *tmpl);
+
 #endif /* _XOR_IMPL_H */
--- a/lib/raid/xor/xor-core.c~xor-remove-macro-abuse-for-xor-implementation-registrations
+++ a/lib/raid/xor/xor-core.c
@@ -14,10 +14,6 @@
 #include <linux/preempt.h>
 #include <asm/xor.h>
 
-#ifndef XOR_SELECT_TEMPLATE
-#define XOR_SELECT_TEMPLATE(x) (x)
-#endif
-
 /* The xor routines to use.  */
 static struct xor_block_template *active_template;
 
@@ -55,12 +51,33 @@ EXPORT_SYMBOL(xor_blocks);
 static struct xor_block_template *__initdata template_list;
 static bool __initdata xor_forced = false;
 
-static void __init do_xor_register(struct xor_block_template *tmpl)
+/**
+ * xor_register - register a XOR template
+ * @tmpl:	template to register
+ *
+ * Register a XOR implementation with the core.  Registered implementations
+ * will be measured by a trivial benchmark, and the fastest one is chosen
+ * unless an implementation is forced using xor_force().
+ */
+void __init xor_register(struct xor_block_template *tmpl)
 {
 	tmpl->next = template_list;
 	template_list = tmpl;
 }
 
+/**
+ * xor_force - force use of a XOR template
+ * @tmpl:	template to register
+ *
+ * Register a XOR implementation with the core and force using it.  Forcing
+ * an implementation will make the core ignore any template registered using
+ * xor_register(), or any previous implementation forced using xor_force().
+ */
+void __init xor_force(struct xor_block_template *tmpl)
+{
+	active_template = tmpl;
+}
+
 #define BENCH_SIZE	4096
 #define REPS		800U
 
@@ -126,11 +143,19 @@ static int __init calibrate_xor_blocks(v
 
 static int __init xor_init(void)
 {
+#ifdef arch_xor_init
+	arch_xor_init();
+#else
+	xor_register(&xor_block_8regs);
+	xor_register(&xor_block_8regs_p);
+	xor_register(&xor_block_32regs);
+	xor_register(&xor_block_32regs_p);
+#endif
+
 	/*
 	 * If this arch/cpu has a short-circuited selection, don't loop through
 	 * all the possible functions, just use the best one.
 	 */
-	active_template = XOR_SELECT_TEMPLATE(NULL);
 	if (active_template) {
 		pr_info("xor: automatically using best checksumming function   %-10s\n",
 			active_template->name);
@@ -138,10 +163,6 @@ static int __init xor_init(void)
 		return 0;
 	}
 
-#define xor_speed	do_xor_register
-	XOR_TRY_TEMPLATES;
-#undef xor_speed
-
 #ifdef MODULE
 	return calibrate_xor_blocks();
 #else
_

Patches currently in -mm which might be from hch@lst.de are

xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch
arm-xor-remove-in_interrupt-handling.patch
arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch
um-xor-cleanup-xorh.patch
xor-move-to-lib-raid.patch
xor-small-cleanups.patch
xor-cleanup-registration-and-probing.patch
xor-split-xorh.patch
xor-remove-macro-abuse-for-xor-implementation-registrations.patch
xor-move-generic-implementations-out-of-asm-generic-xorh.patch
alpha-move-the-xor-code-to-lib-raid.patch
arm-move-the-xor-code-to-lib-raid.patch
arm64-move-the-xor-code-to-lib-raid.patch
loongarch-move-the-xor-code-to-lib-raid.patch
powerpc-move-the-xor-code-to-lib-raid.patch
riscv-move-the-xor-code-to-lib-raid.patch
sparc-move-the-xor-code-to-lib-raid.patch
s390-move-the-xor-code-to-lib-raid.patch
x86-move-the-xor-code-to-lib-raid.patch
xor-avoid-indirect-calls-for-arm64-optimized-ops.patch
xor-make-xorko-self-contained-in-lib-raid.patch
xor-add-a-better-public-api.patch
xor-add-a-better-public-api-2.patch
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

