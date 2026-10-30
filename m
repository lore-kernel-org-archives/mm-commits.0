Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793328360;
	b=Wscwo1PIkCLpFTRMtfoiWjbWA3S82icVKVcktPtX9uYhIKJ5/zUINStwJONC6Jqjj5GI
	 ylSD7JiRBxX+MV/uXCx/aBd3cNX2yMx8XUys+7MyT9Zq2PrFI4kEkRHGOeIe9G3693owR
	 QJXIcK+nnMisUK0cKtIDBlbitm/4pe+OjNS+JiPvQCtLlmW7w/DNV2m2hwNKO6QCz8dGb
	 izyYLkh33hNDnZ711DV1JGVNEX6a2W/0mlvNUEaDZa4/2O/PTcCThAzylynn5imdiwOq6
	 4c+6wfWv8VfFNtu2Re9vNgDALv8+EmcWvdkxr4WMEP6wj4OT+66lIIkVVXjw/T0aWaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793328360;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=66mm4u3nPhs26Rpl5gf759SWA/BG02fweMmC2RZ5DY8=;
	b=p2Nk3lwtiLwwFq105o3Y1KZY9TeNLpNyJBzN6ig+qiJfkqT1NRXug/3qaIKIzxvgvDk2
	 qUxlcpjgrtqVVUJQGnsJoZFi55ntP35+MPntmlV7tkrBYj6idhtteeDIA6aamQ9ZN2WbJ
	 uI5aclTkyzP2NGFhccoZhyv/shoCgs+lpL9KbOokkYIEX+MGZmk3NFb0g2jFRI/PXtkA5
	 +PSAQ2JaGQPL5iCoQpnOiJcJ0NSQnDfmh1iKkQu1phhZyATnpCl7hSsqe+H69mBJnx88s
	 Z/6I7S3Ny69xk2kZVkL/rOS1flnvRvvcgHEEiriVVpn19gKJ5dXbsYec5Z365s6aLcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2Vrzryok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A35606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 02:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2Vrzryok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207241F000C1;
	Fri, 30 Oct 2026 02:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793328359;
	bh=66mm4u3nPhs26Rpl5gf759SWA/BG02fweMmC2RZ5DY8=;
	h=Date:To:From:Subject;
	b=2VrzryokV0bRb+dE5yr1MznjurtDmOqfaGpbqHyi8X2Fq1OpIXE6NNm+0E081i71I
	 Xn8tUon9L/v2cJ2iYOTuAt4jmlUmdkTmyPaqZL6Gyq0xVl2+5LRc1LLKo6WgmJS0zd
	 n70FJn8fpckN7yTZrmBQ1LTJJO+GwRzerO9CAhEA=
Date: Thu, 29 Oct 2026 19:45:58 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,david.laight.linux@gmail.com,
	ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-remove-obsolete-mmx-optimized-code.patch added to mm-nonmm-unstable branch
Message-Id: <20261030024559.207241F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: raid6: remove obsolete MMX optimized code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-remove-obsolete-mmx-optimized-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-remove-obsolete-mmx-optimized-code.patch

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
Subject: raid6: remove obsolete MMX optimized code
Date: Sun, 25 Oct 2026 12:12:06 -0700

The MMX optimized RAID6 code is used only on 25-year old 32-bit CPUs
that lack SSE2 support -- and only on systems that actually have a RAID
array.  Those CPUs already have well-tested scalar C fallbacks.

It's also the only remaining MMX optimized code in the kernel.  MMX
optimizations for the much more commonly called functions memcpy(),
copy_page(), and clear_page() were already removed years ago by
commit c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").

Remove the MMX optimized RAID6 code.  This includes
lib/raid/raid6/x86/sse1.c, which was really an MMX implementation with
SSE1 prefetches and non-temporal stores added on top.

Link: https://lore.kernel.org/20261025191207.86590-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Laight <david.laight.linux@gmail.com>
---

 lib/raid/raid6/Makefile      |    4 
 lib/raid/raid6/x86/mmx.c     |  118 ----------------------------
 lib/raid/raid6/x86/pq_arch.h |   18 ----
 lib/raid/raid6/x86/sse1.c    |  136 ---------------------------------
 4 files changed, 276 deletions(-)

--- a/lib/raid/raid6/Makefile~raid6-remove-obsolete-mmx-optimized-code
+++ a/lib/raid/raid6/Makefile
@@ -38,10 +38,6 @@ raid6_pq-$(CONFIG_RISCV_ISA_V)	+= riscv/
 				   riscv/recov_rvv.o
 raid6_pq-$(CONFIG_S390)		+= s390/s390vx8.o \
 				   s390/recov_s390xc.o
-ifeq ($(CONFIG_X86),y)
-raid6_pq-$(CONFIG_X86_32)	+= x86/mmx.o \
-				   x86/sse1.o
-endif
 raid6_pq-$(CONFIG_X86)		+= x86/sse2.o \
 				   x86/avx2.o \
 				   x86/avx512.o \
diff --git a/lib/raid/raid6/x86/mmx.c a/lib/raid/raid6/x86/mmx.c
deleted file mode 100644
--- a/lib/raid/raid6/x86/mmx.c
+++ /dev/null
@@ -1,118 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright 2002 H. Peter Anvin - All Rights Reserved
- *
- * MMX implementation of RAID-6 syndrome functions.
- */
-
-#include <asm/cpufeature.h>
-#include <asm/fpu/api.h>
-#include "algos.h"
-
-/* Shared with raid6/sse1.c */
-const struct raid6_mmx_constants {
-	u64 x1d;
-} raid6_mmx_constants = {
-	0x1d1d1d1d1d1d1d1dULL,
-};
-
-/*
- * Plain MMX implementation
- */
-static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-
-	for ( d = 0 ; d < bytes ; d += 8 ) {
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			asm volatile("movq %0,%%mm6" : : "m" (dptr[z][d]));
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm6,%mm2");
-			asm volatile("pxor %mm6,%mm4");
-		}
-		asm volatile("movq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("pxor %mm2,%mm2");
-		asm volatile("movq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("pxor %mm4,%mm4");
-	}
-
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_mmxx1 = {
-	.gen_syndrome	= raid6_mmx1_gen_syndrome,
-	.name		= "mmxx1",
-};
-
-/*
- * Unrolled-by-2 MMX implementation
- */
-static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-	asm volatile("pxor %mm7,%mm7"); /* Zero temp */
-
-	for ( d = 0 ; d < bytes ; d += 16 ) {
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d+8]));
-		asm volatile("movq %mm2,%mm4"); /* Q[0] */
-		asm volatile("movq %mm3,%mm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("pcmpgtb %mm6,%mm7");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("paddb %mm6,%mm6");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pand %mm0,%mm7");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("movq %0,%%mm5" : : "m" (dptr[z][d]));
-			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d+8]));
-			asm volatile("pxor %mm5,%mm2");
-			asm volatile("pxor %mm7,%mm3");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm7,%mm7");
-		}
-		asm volatile("movq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movq %%mm3,%0" : "=m" (p[d+8]));
-		asm volatile("movq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("movq %%mm6,%0" : "=m" (q[d+8]));
-	}
-
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_mmxx2 = {
-	.gen_syndrome	= raid6_mmx2_gen_syndrome,
-	.name		= "mmxx2",
-};
--- a/lib/raid/raid6/x86/pq_arch.h~raid6-remove-obsolete-mmx-optimized-code
+++ a/lib/raid/raid6/x86/pq_arch.h
@@ -2,10 +2,6 @@
 
 #include <asm/cpufeature.h>
 
-extern const struct raid6_calls raid6_mmxx1;
-extern const struct raid6_calls raid6_mmxx2;
-extern const struct raid6_calls raid6_sse1x1;
-extern const struct raid6_calls raid6_sse1x2;
 extern const struct raid6_calls raid6_sse2x1;
 extern const struct raid6_calls raid6_sse2x2;
 extern const struct raid6_calls raid6_sse2x4;
@@ -50,13 +46,6 @@ static inline bool raid6_has_sse2(void)
 		    boot_cpu_has(X86_FEATURE_XMM2);
 }
 
-static inline bool raid6_has_sse1_or_mmxext(void)
-{
-	return boot_cpu_has(X86_FEATURE_MMX) &&
-		(boot_cpu_has(X86_FEATURE_XMM) ||
-		 boot_cpu_has(X86_FEATURE_MMXEXT));
-}
-
 static __always_inline void __init arch_raid6_init(void)
 {
 	if (raid6_has_avx2()) {
@@ -78,13 +67,6 @@ static __always_inline void __init arch_
 			raid6_algo_add(&raid6_sse2x4);
 	} else {
 		raid6_algo_add_default();
-		if (raid6_has_sse1_or_mmxext()) {
-			raid6_algo_add(&raid6_sse1x1);
-			raid6_algo_add(&raid6_sse1x2);
-		} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-			raid6_algo_add(&raid6_mmxx1);
-			raid6_algo_add(&raid6_mmxx2);
-		}
 	}
 
 	if (raid6_has_avx512())
diff --git a/lib/raid/raid6/x86/sse1.c a/lib/raid/raid6/x86/sse1.c
deleted file mode 100644
--- a/lib/raid/raid6/x86/sse1.c
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright 2002 H. Peter Anvin - All Rights Reserved
- *
- * SSE-1/MMXEXT implementation of RAID-6 syndrome functions.
- *
- * This is really an MMX implementation, but it requires SSE-1 or AMD MMXEXT for
- * prefetch support and a few other features.  The support for nontemporal
- * memory accesses is enough to make this worthwhile as a separate
- * implementation.
- */
-
-#include <asm/cpufeature.h>
-#include <asm/fpu/api.h>
-#include "algos.h"
-
-/* Defined in raid6/mmx.c */
-extern const struct raid6_mmx_constants {
-	u64 x1d;
-} raid6_mmx_constants;
-
-/*
- * Plain SSE1 implementation
- */
-static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-
-	for ( d = 0 ; d < bytes ; d += 8 ) {
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0-1][d]));
-		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		asm volatile("movq %0,%%mm6" : : "m" (dptr[z0-1][d]));
-		for ( z = z0-2 ; z >= 0 ; z-- ) {
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm6,%mm2");
-			asm volatile("pxor %mm6,%mm4");
-			asm volatile("movq %0,%%mm6" : : "m" (dptr[z][d]));
-		}
-		asm volatile("pcmpgtb %mm4,%mm5");
-		asm volatile("paddb %mm4,%mm4");
-		asm volatile("pand %mm0,%mm5");
-		asm volatile("pxor %mm5,%mm4");
-		asm volatile("pxor %mm5,%mm5");
-		asm volatile("pxor %mm6,%mm2");
-		asm volatile("pxor %mm6,%mm4");
-
-		asm volatile("movntq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movntq %%mm4,%0" : "=m" (q[d]));
-	}
-
-	asm volatile("sfence" : : : "memory");
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_sse1x1 = {
-	.gen_syndrome	= raid6_sse11_gen_syndrome,
-	.name		= "sse1x1",
-};
-
-/*
- * Unrolled-by-2 SSE1 implementation
- */
-static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
-{
-	u8 **dptr = (u8 **)ptrs;
-	u8 *p, *q;
-	int d, z, z0;
-
-	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
-
-	kernel_fpu_begin();
-
-	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
-	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
-	asm volatile("pxor %mm7,%mm7"); /* Zero temp */
-
-	/* We uniformly assume a single prefetch covers at least 16 bytes */
-	for ( d = 0 ; d < bytes ; d += 16 ) {
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d+8])); /* P[1] */
-		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		asm volatile("movq %mm3,%mm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
-			asm volatile("pcmpgtb %mm4,%mm5");
-			asm volatile("pcmpgtb %mm6,%mm7");
-			asm volatile("paddb %mm4,%mm4");
-			asm volatile("paddb %mm6,%mm6");
-			asm volatile("pand %mm0,%mm5");
-			asm volatile("pand %mm0,%mm7");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("movq %0,%%mm5" : : "m" (dptr[z][d]));
-			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d+8]));
-			asm volatile("pxor %mm5,%mm2");
-			asm volatile("pxor %mm7,%mm3");
-			asm volatile("pxor %mm5,%mm4");
-			asm volatile("pxor %mm7,%mm6");
-			asm volatile("pxor %mm5,%mm5");
-			asm volatile("pxor %mm7,%mm7");
-		}
-		asm volatile("movntq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movntq %%mm3,%0" : "=m" (p[d+8]));
-		asm volatile("movntq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("movntq %%mm6,%0" : "=m" (q[d+8]));
-	}
-
-	asm volatile("sfence" : :: "memory");
-	kernel_fpu_end();
-}
-
-const struct raid6_calls raid6_sse1x2 = {
-	.gen_syndrome	= raid6_sse12_gen_syndrome,
-	.name		= "sse1x2",
-};
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-remove-obsolete-mmx-optimized-code.patch
raid6-remove-obsolete-mmx-optimized-code.patch
raid6-simplify-cpu-feature-checks.patch

