Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470D1372677
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028807; cv=none; b=PHsJkxNAA7Qj+NFjxYZK//rgEYHoiZp3XfaKPsjFLYtOBZMDEUM302yh0Zg2Mt1s13pWVF8Nir/qmUhb+3WNp9SPu6ObMhPuQB143dkOYyulm6IlLXjkQg3FZw2Lj94xVZ4sRs1qiW4cuh+hxkZk7iN3/RYzinosidhSDpgmjFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028807; c=relaxed/simple;
	bh=PRd+2OU+4kcpp+1W4u+KK4zhnRfv0r/gk3ZAGh3ueZE=;
	h=Date:To:From:Subject:Message-Id; b=iZGpDARrFKKtxGV0cOWxmMVgIqfYmFiamyf+zdE8PH7IdKDnkxo14japoA0/hGKvUoMspyoFtpWJS42ODXnJeFONRlfRBAVCSnJyCKfb/EqHUqbItMPG2DeH25mWav+gNaTc3wekQ6OUMf3pUnPjf68v2V8bSsH592Wd6w1uY+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eb9n3JGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eb9n3JGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159531F00898;
	Fri, 29 May 2026 04:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028806;
	bh=4GywYcI9gt4ai4wqCj5j29crDIs13/nBB2t53YjYgb4=;
	h=Date:To:From:Subject;
	b=eb9n3JGyIWzuQ5hNgT5tksCQpHj1q+7TnSOXg/6SGQtWJAykW9mG6Ls1krgnevrco
	 ZXlqORzR2kra5jACQty2NQgmTbp07YyY+ZEBQRAGFpWQQEYibJZ3Kt3z5zJ0JMNScn
	 4/nakVMVGmfnoj4ceGYWruXRucbMyIWBN2uSPwvk=
Date: Thu, 28 May 2026 21:26:45 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,song@kernel.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,linan122@huawei.com,kernel@xen0n.name,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,dsterba@suse.com,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-use-named-initializers-for-struct-raid6_calls.patch removed from -mm tree
Message-Id: <20260529042646.159531F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: use named initializers for struct raid6_calls
has been removed from the -mm tree.  Its filename was
     raid6-use-named-initializers-for-struct-raid6_calls.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: use named initializers for struct raid6_calls
Date: Mon, 18 May 2026 07:17:49 +0200

Link: https://lore.kernel.org/20260518051804.462141-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/arm/neon.c                 |    9 ++---
 lib/raid/raid6/int.uc                     |    8 +---
 lib/raid/raid6/loongarch/loongarch_simd.c |   18 ++++------
 lib/raid/raid6/powerpc/altivec.uc         |    8 +---
 lib/raid/raid6/powerpc/vpermxor.uc        |    8 +---
 lib/raid/raid6/riscv/rvv.h                |    9 ++---
 lib/raid/raid6/s390/s390vx.uc             |   10 +++---
 lib/raid/raid6/x86/avx2.c                 |   33 ++++++++++----------
 lib/raid/raid6/x86/avx512.c               |   33 ++++++++++----------
 lib/raid/raid6/x86/mmx.c                  |   16 +++------
 lib/raid/raid6/x86/sse1.c                 |   18 ++++------
 lib/raid/raid6/x86/sse2.c                 |   30 +++++++++---------
 12 files changed, 95 insertions(+), 105 deletions(-)

--- a/lib/raid/raid6/arm/neon.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/arm/neon.c
@@ -40,11 +40,10 @@
 				start, stop, (unsigned long)bytes, ptrs);\
 	}								\
 	struct raid6_calls const raid6_neonx ## _n = {			\
-		raid6_neon ## _n ## _gen_syndrome,			\
-		raid6_neon ## _n ## _xor_syndrome,			\
-		raid6_have_neon,					\
-		"neonx" #_n,						\
-		0							\
+		.gen_syndrome	= raid6_neon ## _n ## _gen_syndrome,	\
+		.xor_syndrome	= raid6_neon ## _n ## _xor_syndrome,	\
+		.valid		= raid6_have_neon,			\
+		.name		= "neonx" #_n,				\
 	}
 
 static int raid6_have_neon(void)
--- a/lib/raid/raid6/int.uc~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/int.uc
@@ -139,9 +139,7 @@ static void raid6_int$#_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_intx$# = {
-	raid6_int$#_gen_syndrome,
-	raid6_int$#_xor_syndrome,
-	NULL,			/* always valid */
-	"int" NSTRING "x$#",
-	0
+	.gen_syndrome	= raid6_int$#_gen_syndrome,
+	.xor_syndrome	= raid6_int$#_xor_syndrome,
+	.name		= "int" NSTRING "x$#",
 };
--- a/lib/raid/raid6/loongarch/loongarch_simd.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/loongarch/loongarch_simd.c
@@ -244,11 +244,10 @@ static void raid6_lsx_xor_syndrome(int d
 }
 
 const struct raid6_calls raid6_lsx = {
-	raid6_lsx_gen_syndrome,
-	raid6_lsx_xor_syndrome,
-	raid6_has_lsx,
-	"lsx",
-	.priority = 0 /* see the comment near the top of the file for reason */
+	.gen_syndrome	= raid6_lsx_gen_syndrome,
+	.xor_syndrome	= raid6_lsx_xor_syndrome,
+	.valid		= raid6_has_lsx,
+	.name		= "lsx",
 };
 
 #undef NSIZE
@@ -413,11 +412,10 @@ static void raid6_lasx_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_lasx = {
-	raid6_lasx_gen_syndrome,
-	raid6_lasx_xor_syndrome,
-	raid6_has_lasx,
-	"lasx",
-	.priority = 0 /* see the comment near the top of the file for reason */
+	.gen_syndrome	= raid6_lasx_gen_syndrome,
+	.xor_syndrome	= raid6_lasx_xor_syndrome,
+	.valid		= raid6_has_lasx,
+	.name		= "lasx",
 };
 #undef NSIZE
 #endif /* CONFIG_CPU_HAS_LASX */
--- a/lib/raid/raid6/powerpc/altivec.uc~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/powerpc/altivec.uc
@@ -114,9 +114,7 @@ int raid6_have_altivec(void)
 #endif
 
 const struct raid6_calls raid6_altivec$# = {
-	raid6_altivec$#_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_altivec,
-	"altivecx$#",
-	0
+	.gen_syndrome	= raid6_altivec$#_gen_syndrome,
+	.valid		= raid6_have_altivec,
+	.name		= "altivecx$#",
 };
--- a/lib/raid/raid6/powerpc/vpermxor.uc~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/powerpc/vpermxor.uc
@@ -87,9 +87,7 @@ int raid6_have_altivec_vpermxor(void)
 #endif
 
 const struct raid6_calls raid6_vpermxor$# = {
-	raid6_vpermxor$#_gen_syndrome,
-	NULL,
-	raid6_have_altivec_vpermxor,
-	"vpermxor$#",
-	0
+	.gen_syndrome	= raid6_vpermxor$#_gen_syndrome,
+	.valid		= raid6_have_altivec_vpermxor,
+	.name		= "vpermxor$#",
 };
--- a/lib/raid/raid6/riscv/rvv.h~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/riscv/rvv.h
@@ -39,9 +39,8 @@ static int rvv_has_vector(void)
 		kernel_vector_end();					\
 	}								\
 	struct raid6_calls const raid6_rvvx ## _n = {			\
-		raid6_rvv ## _n ## _gen_syndrome,			\
-		raid6_rvv ## _n ## _xor_syndrome,			\
-		rvv_has_vector,						\
-		"rvvx" #_n,						\
-		0							\
+		.gen_syndrome	= raid6_rvv ## _n ## _gen_syndrome,	\
+		.xor_syndrome	= raid6_rvv ## _n ## _xor_syndrome,	\
+		.valid		= rvv_has_vector,			\
+		.name		= "rvvx" #_n,				\
 	}
--- a/lib/raid/raid6/s390/s390vx.uc~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/s390/s390vx.uc
@@ -127,9 +127,9 @@ static int raid6_s390vx$#_valid(void)
 }
 
 const struct raid6_calls raid6_s390vx$# = {
-	raid6_s390vx$#_gen_syndrome,
-	raid6_s390vx$#_xor_syndrome,
-	raid6_s390vx$#_valid,
-	"vx128x$#",
-	1
+	.gen_syndrome	= raid6_s390vx$#_gen_syndrome,
+	.xor_syndrome	= raid6_s390vx$#_xor_syndrome,
+	.valid		= raid6_s390vx$#_valid,
+	.name		= "vx128x$#",
+	.priority	= 1,
 };
--- a/lib/raid/raid6/x86/avx2.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/x86/avx2.c
@@ -128,11 +128,12 @@ static void raid6_avx21_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_avx2x1 = {
-	raid6_avx21_gen_syndrome,
-	raid6_avx21_xor_syndrome,
-	raid6_have_avx2,
-	"avx2x1",
-	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx21_gen_syndrome,
+	.xor_syndrome	= raid6_avx21_xor_syndrome,
+	.valid		= raid6_have_avx2,
+	.name		= "avx2x1",
+	/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 /*
@@ -258,11 +259,12 @@ static void raid6_avx22_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_avx2x2 = {
-	raid6_avx22_gen_syndrome,
-	raid6_avx22_xor_syndrome,
-	raid6_have_avx2,
-	"avx2x2",
-	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx22_gen_syndrome,
+	.xor_syndrome	= raid6_avx22_xor_syndrome,
+	.valid		= raid6_have_avx2,
+	.name		= "avx2x2",
+	/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 #ifdef CONFIG_X86_64
@@ -461,10 +463,11 @@ static void raid6_avx24_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_avx2x4 = {
-	raid6_avx24_gen_syndrome,
-	raid6_avx24_xor_syndrome,
-	raid6_have_avx2,
-	"avx2x4",
-	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx24_gen_syndrome,
+	.xor_syndrome	= raid6_avx24_xor_syndrome,
+	.valid		= raid6_have_avx2,
+	.name		= "avx2x4",
+	/* Prefer AVX2 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 #endif /* CONFIG_X86_64 */
--- a/lib/raid/raid6/x86/avx512.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/x86/avx512.c
@@ -156,11 +156,12 @@ static void raid6_avx5121_xor_syndrome(i
 }
 
 const struct raid6_calls raid6_avx512x1 = {
-	raid6_avx5121_gen_syndrome,
-	raid6_avx5121_xor_syndrome,
-	raid6_have_avx512,
-	"avx512x1",
-	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx5121_gen_syndrome,
+	.xor_syndrome	= raid6_avx5121_xor_syndrome,
+	.valid		= raid6_have_avx512,
+	.name		= "avx512x1",
+	/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 /*
@@ -313,11 +314,12 @@ static void raid6_avx5122_xor_syndrome(i
 }
 
 const struct raid6_calls raid6_avx512x2 = {
-	raid6_avx5122_gen_syndrome,
-	raid6_avx5122_xor_syndrome,
-	raid6_have_avx512,
-	"avx512x2",
-	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx5122_gen_syndrome,
+	.xor_syndrome	= raid6_avx5122_xor_syndrome,
+	.valid		= raid6_have_avx512,
+	.name		= "avx512x2",
+	/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 
 #ifdef CONFIG_X86_64
@@ -551,10 +553,11 @@ static void raid6_avx5124_xor_syndrome(i
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
-	raid6_avx5124_gen_syndrome,
-	raid6_avx5124_xor_syndrome,
-	raid6_have_avx512,
-	"avx512x4",
-	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.gen_syndrome	= raid6_avx5124_gen_syndrome,
+	.xor_syndrome	= raid6_avx5124_xor_syndrome,
+	.valid		= raid6_have_avx512,
+	.name		= "avx512x4",
+	/* Prefer AVX512 over priority 1 (SSE2 and others) */
+	.priority	= 2,
 };
 #endif
--- a/lib/raid/raid6/x86/mmx.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/x86/mmx.c
@@ -68,11 +68,9 @@ static void raid6_mmx1_gen_syndrome(int
 }
 
 const struct raid6_calls raid6_mmxx1 = {
-	raid6_mmx1_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_mmx,
-	"mmxx1",
-	0
+	.gen_syndrome	= raid6_mmx1_gen_syndrome,
+	.valid		= raid6_have_mmx,
+	.name		= "mmxx1",
 };
 
 /*
@@ -127,9 +125,7 @@ static void raid6_mmx2_gen_syndrome(int
 }
 
 const struct raid6_calls raid6_mmxx2 = {
-	raid6_mmx2_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_mmx,
-	"mmxx2",
-	0
+	.gen_syndrome	= raid6_mmx2_gen_syndrome,
+	.valid		= raid6_have_mmx,
+	.name		= "mmxx2",
 };
--- a/lib/raid/raid6/x86/sse1.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/x86/sse1.c
@@ -84,11 +84,10 @@ static void raid6_sse11_gen_syndrome(int
 }
 
 const struct raid6_calls raid6_sse1x1 = {
-	raid6_sse11_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_sse1_or_mmxext,
-	"sse1x1",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse11_gen_syndrome,
+	.valid		= raid6_have_sse1_or_mmxext,
+	.name		= "sse1x1",
+	.priority	= 1,	/* Has cache hints */
 };
 
 /*
@@ -147,9 +146,8 @@ static void raid6_sse12_gen_syndrome(int
 }
 
 const struct raid6_calls raid6_sse1x2 = {
-	raid6_sse12_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
-	raid6_have_sse1_or_mmxext,
-	"sse1x2",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse12_gen_syndrome,
+	.valid		= raid6_have_sse1_or_mmxext,
+	.name		= "sse1x2",
+	.priority	= 1,	/* Has cache hints */
 };
--- a/lib/raid/raid6/x86/sse2.c~raid6-use-named-initializers-for-struct-raid6_calls
+++ a/lib/raid/raid6/x86/sse2.c
@@ -133,11 +133,11 @@ static void raid6_sse21_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_sse2x1 = {
-	raid6_sse21_gen_syndrome,
-	raid6_sse21_xor_syndrome,
-	raid6_have_sse2,
-	"sse2x1",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse21_gen_syndrome,
+	.xor_syndrome	= raid6_sse21_xor_syndrome,
+	.valid		= raid6_have_sse2,
+	.name		= "sse2x1",
+	.priority	= 1,	/* Has cache hints */
 };
 
 /*
@@ -263,11 +263,11 @@ static void raid6_sse22_xor_syndrome(int
 }
 
 const struct raid6_calls raid6_sse2x2 = {
-	raid6_sse22_gen_syndrome,
-	raid6_sse22_xor_syndrome,
-	raid6_have_sse2,
-	"sse2x2",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse22_gen_syndrome,
+	.xor_syndrome	= raid6_sse22_xor_syndrome,
+	.valid		= raid6_have_sse2,
+	.name		= "sse2x2",
+	.priority	= 1,	/* Has cache hints */
 };
 
 #ifdef CONFIG_X86_64
@@ -470,11 +470,11 @@ static void raid6_sse24_xor_syndrome(int
 
 
 const struct raid6_calls raid6_sse2x4 = {
-	raid6_sse24_gen_syndrome,
-	raid6_sse24_xor_syndrome,
-	raid6_have_sse2,
-	"sse2x4",
-	1			/* Has cache hints */
+	.gen_syndrome	= raid6_sse24_gen_syndrome,
+	.xor_syndrome	= raid6_sse24_xor_syndrome,
+	.valid		= raid6_have_sse2,
+	.name		= "sse2x4",
+	.priority	= 1,	/* Has cache hints */
 };
 
 #endif /* CONFIG_X86_64 */
_

Patches currently in -mm which might be from hch@lst.de are


