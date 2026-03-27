Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5D4371CFE
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633816; cv=none; b=gg+vU5QGiFzlx1JlhXO/g7eW6NtqhUrVVQn5mz/2ppnvkBH0xFJM4H4GgaQg0LSwj9YLnVXuLnHvCSngGYFKWgh5n+c4u057/rDz2hFWuvDSQ5BzuRrXfe0eNos5TufM/FNVhcUaRJfyyUDSpMu0ZUC23mg3DzMvdxJGfMZ6+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633816; c=relaxed/simple;
	bh=msP5CdxzFK92VHWLMVbc7FO9L/EOpervBt3L6NwQ0I8=;
	h=Date:To:From:Subject:Message-Id; b=qPlNbedaJqIuVD2p5zaFeOdb2MgQ8bRtedN7PymlwC/1b565S0xuJo+WyDpcMyRcrzQAUMsLFfAQ7MPo7fVlVE7FGy+pAs1EiGugLljv8Aor+IrNv8trNfNypTdoYhI8UXXjyCK9W5kaqJcO54fMGuV3TIVqwfO2dx3pkZMV9n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DfySDGj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DfySDGj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D916C19423;
	Fri, 27 Mar 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633816;
	bh=msP5CdxzFK92VHWLMVbc7FO9L/EOpervBt3L6NwQ0I8=;
	h=Date:To:From:Subject:From;
	b=DfySDGj3RwMKb5zxxfRGTSHyRjjpHeL3Lux+g9tydOibhqMZcThzbPHMROULPTYlx
	 Uvji9Dc7r8c1fx9Z/3SEzdn96+A3/Q0kJ+gA4f9reEYkpagpdQSRVPabR+ixZ1O9Ba
	 89H8M6L1U0R8Ur9X6s4HNeYZQZCSrYoM38vA9rMU=
Date: Fri, 27 Mar 2026 10:50:15 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-move-the-xor-code-to-lib-raid.patch added to mm-nonmm-unstable branch
Message-Id: <20260327175016.5D916C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: move the XOR code to lib/raid/
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-move-the-xor-code-to-lib-raid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-move-the-xor-code-to-lib-raid.patch

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
Subject: arm64: move the XOR code to lib/raid/
Date: Fri, 27 Mar 2026 07:16:45 +0100

Move the optimized XOR into lib/raid and include it it in the main xor.ko
instead of building a separate module for it.

Note that this drops the CONFIG_KERNEL_MODE_NEON dependency, as that is
always set for arm64.

Link: https://lkml.kernel.org/r/20260327061704.3707577-14-hch@lst.de
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

 arch/arm64/include/asm/xor.h       |   58 ----
 arch/arm64/lib/Makefile            |    6 
 arch/arm64/lib/xor-neon.c          |  339 ---------------------------
 lib/raid/xor/Makefile              |    4 
 lib/raid/xor/arm64/xor-neon-glue.c |   57 ++++
 lib/raid/xor/arm64/xor-neon.c      |  325 +++++++++++++++++++++++++
 6 files changed, 389 insertions(+), 400 deletions(-)

--- a/arch/arm64/include/asm/xor.h~arm64-move-the-xor-code-to-lib-raid
+++ a/arch/arm64/include/asm/xor.h
@@ -1,73 +1,21 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * arch/arm64/include/asm/xor.h
- *
  * Authors: Jackie Liu <liuyun01@kylinos.cn>
  * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
 
-#include <linux/hardirq.h>
 #include <asm-generic/xor.h>
-#include <asm/hwcap.h>
 #include <asm/simd.h>
 
-#ifdef CONFIG_KERNEL_MODE_NEON
-
-extern struct xor_block_template xor_block_inner_neon __ro_after_init;
-
-static void
-xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
-	   const unsigned long * __restrict p2)
-{
-	scoped_ksimd()
-		xor_block_inner_neon.do_2(bytes, p1, p2);
-}
-
-static void
-xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
-	   const unsigned long * __restrict p2,
-	   const unsigned long * __restrict p3)
-{
-	scoped_ksimd()
-		xor_block_inner_neon.do_3(bytes, p1, p2, p3);
-}
-
-static void
-xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
-	   const unsigned long * __restrict p2,
-	   const unsigned long * __restrict p3,
-	   const unsigned long * __restrict p4)
-{
-	scoped_ksimd()
-		xor_block_inner_neon.do_4(bytes, p1, p2, p3, p4);
-}
-
-static void
-xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
-	   const unsigned long * __restrict p2,
-	   const unsigned long * __restrict p3,
-	   const unsigned long * __restrict p4,
-	   const unsigned long * __restrict p5)
-{
-	scoped_ksimd()
-		xor_block_inner_neon.do_5(bytes, p1, p2, p3, p4, p5);
-}
-
-static struct xor_block_template xor_block_arm64 = {
-	.name   = "arm64_neon",
-	.do_2   = xor_neon_2,
-	.do_3   = xor_neon_3,
-	.do_4   = xor_neon_4,
-	.do_5	= xor_neon_5
-};
+extern struct xor_block_template xor_block_arm64;
+void __init xor_neon_init(void);
 
 #define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
+	xor_neon_init();
 	xor_register(&xor_block_8regs);
 	xor_register(&xor_block_32regs);
 	if (cpu_has_neon())
 		xor_register(&xor_block_arm64);
 }
-
-#endif /* ! CONFIG_KERNEL_MODE_NEON */
--- a/arch/arm64/lib/Makefile~arm64-move-the-xor-code-to-lib-raid
+++ a/arch/arm64/lib/Makefile
@@ -5,12 +5,6 @@ lib-y		:= clear_user.o delay.o copy_from
 		   memset.o memcmp.o strcmp.o strncmp.o strlen.o	\
 		   strnlen.o strchr.o strrchr.o tishift.o
 
-ifeq ($(CONFIG_KERNEL_MODE_NEON), y)
-obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
-CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU)
-CFLAGS_REMOVE_xor-neon.o	+= $(CC_FLAGS_NO_FPU)
-endif
-
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
 
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
diff --git a/arch/arm64/lib/xor-neon.c a/arch/arm64/lib/xor-neon.c
deleted file mode 100644
--- a/arch/arm64/lib/xor-neon.c
+++ /dev/null
@@ -1,339 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * arch/arm64/lib/xor-neon.c
- *
- * Authors: Jackie Liu <liuyun01@kylinos.cn>
- * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
- */
-
-#include <linux/raid/xor.h>
-#include <linux/raid/xor_impl.h>
-#include <linux/module.h>
-#include <asm/neon-intrinsics.h>
-
-static void xor_arm64_neon_2(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-	} while (--lines > 0);
-}
-
-static void xor_arm64_neon_3(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-	} while (--lines > 0);
-}
-
-static void xor_arm64_neon_4(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-	} while (--lines > 0);
-}
-
-static void xor_arm64_neon_5(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4,
-	const unsigned long * __restrict p5)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-	uint64_t *dp5 = (uint64_t *)p5;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
-
-		/* p1 ^= p5 */
-		v0 = veorq_u64(v0, vld1q_u64(dp5 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp5 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp5 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp5 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-		dp5 += 8;
-	} while (--lines > 0);
-}
-
-struct xor_block_template xor_block_inner_neon __ro_after_init = {
-	.name	= "__inner_neon__",
-	.do_2	= xor_arm64_neon_2,
-	.do_3	= xor_arm64_neon_3,
-	.do_4	= xor_arm64_neon_4,
-	.do_5	= xor_arm64_neon_5,
-};
-EXPORT_SYMBOL(xor_block_inner_neon);
-
-static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
-{
-	uint64x2_t res;
-
-	asm(ARM64_ASM_PREAMBLE ".arch_extension sha3\n"
-	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
-	    : "=w"(res) : "w"(p), "w"(q), "w"(r));
-	return res;
-}
-
-static void xor_arm64_eor3_3(unsigned long bytes,
-	unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 ^ p3 */
-		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
-			  vld1q_u64(dp3 + 0));
-		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
-			  vld1q_u64(dp3 + 2));
-		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
-			  vld1q_u64(dp3 + 4));
-		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
-			  vld1q_u64(dp3 + 6));
-
-		/* store */
-		vst1q_u64(dp1 + 0, v0);
-		vst1q_u64(dp1 + 2, v1);
-		vst1q_u64(dp1 + 4, v2);
-		vst1q_u64(dp1 + 6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-	} while (--lines > 0);
-}
-
-static void xor_arm64_eor3_4(unsigned long bytes,
-	unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 ^ p3 */
-		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
-			  vld1q_u64(dp3 + 0));
-		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
-			  vld1q_u64(dp3 + 2));
-		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
-			  vld1q_u64(dp3 + 4));
-		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
-			  vld1q_u64(dp3 + 6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 + 0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 + 2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 + 4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 + 6));
-
-		/* store */
-		vst1q_u64(dp1 + 0, v0);
-		vst1q_u64(dp1 + 2, v1);
-		vst1q_u64(dp1 + 4, v2);
-		vst1q_u64(dp1 + 6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-	} while (--lines > 0);
-}
-
-static void xor_arm64_eor3_5(unsigned long bytes,
-	unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4,
-	const unsigned long * __restrict p5)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-	uint64_t *dp5 = (uint64_t *)p5;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 ^ p3 */
-		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
-			  vld1q_u64(dp3 + 0));
-		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
-			  vld1q_u64(dp3 + 2));
-		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
-			  vld1q_u64(dp3 + 4));
-		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
-			  vld1q_u64(dp3 + 6));
-
-		/* p1 ^= p4 ^ p5 */
-		v0 = eor3(v0, vld1q_u64(dp4 + 0), vld1q_u64(dp5 + 0));
-		v1 = eor3(v1, vld1q_u64(dp4 + 2), vld1q_u64(dp5 + 2));
-		v2 = eor3(v2, vld1q_u64(dp4 + 4), vld1q_u64(dp5 + 4));
-		v3 = eor3(v3, vld1q_u64(dp4 + 6), vld1q_u64(dp5 + 6));
-
-		/* store */
-		vst1q_u64(dp1 + 0, v0);
-		vst1q_u64(dp1 + 2, v1);
-		vst1q_u64(dp1 + 4, v2);
-		vst1q_u64(dp1 + 6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-		dp5 += 8;
-	} while (--lines > 0);
-}
-
-static int __init xor_neon_init(void)
-{
-	if (cpu_have_named_feature(SHA3)) {
-		xor_block_inner_neon.do_3 = xor_arm64_eor3_3;
-		xor_block_inner_neon.do_4 = xor_arm64_eor3_4;
-		xor_block_inner_neon.do_5 = xor_arm64_eor3_5;
-	}
-	return 0;
-}
-module_init(xor_neon_init);
-
-static void __exit xor_neon_exit(void)
-{
-}
-module_exit(xor_neon_exit);
-
-MODULE_AUTHOR("Jackie Liu <liuyun01@kylinos.cn>");
-MODULE_DESCRIPTION("ARMv8 XOR Extensions");
-MODULE_LICENSE("GPL");
diff --git a/lib/raid/xor/arm64/xor-neon.c a/lib/raid/xor/arm64/xor-neon.c
new file mode 100664
--- /dev/null
+++ a/lib/raid/xor/arm64/xor-neon.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Authors: Jackie Liu <liuyun01@kylinos.cn>
+ * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
+ */
+
+#include <linux/raid/xor_impl.h>
+#include <linux/cache.h>
+#include <asm/neon-intrinsics.h>
+#include <asm/xor.h>
+
+static void xor_arm64_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+	const unsigned long * __restrict p2)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+	} while (--lines > 0);
+}
+
+static void xor_arm64_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+	const unsigned long * __restrict p2,
+	const unsigned long * __restrict p3)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+	} while (--lines > 0);
+}
+
+static void xor_arm64_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+	const unsigned long * __restrict p2,
+	const unsigned long * __restrict p3,
+	const unsigned long * __restrict p4)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* p1 ^= p4 */
+		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+	} while (--lines > 0);
+}
+
+static void xor_arm64_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+	const unsigned long * __restrict p2,
+	const unsigned long * __restrict p3,
+	const unsigned long * __restrict p4,
+	const unsigned long * __restrict p5)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+	uint64_t *dp5 = (uint64_t *)p5;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* p1 ^= p4 */
+		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
+
+		/* p1 ^= p5 */
+		v0 = veorq_u64(v0, vld1q_u64(dp5 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp5 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp5 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp5 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+		dp5 += 8;
+	} while (--lines > 0);
+}
+
+struct xor_block_template xor_block_inner_neon __ro_after_init = {
+	.name	= "__inner_neon__",
+	.do_2	= xor_arm64_neon_2,
+	.do_3	= xor_arm64_neon_3,
+	.do_4	= xor_arm64_neon_4,
+	.do_5	= xor_arm64_neon_5,
+};
+
+static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
+{
+	uint64x2_t res;
+
+	asm(ARM64_ASM_PREAMBLE ".arch_extension sha3\n"
+	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
+	    : "=w"(res) : "w"(p), "w"(q), "w"(r));
+	return res;
+}
+
+static void xor_arm64_eor3_3(unsigned long bytes,
+	unsigned long * __restrict p1,
+	const unsigned long * __restrict p2,
+	const unsigned long * __restrict p3)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 ^ p3 */
+		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
+			  vld1q_u64(dp3 + 0));
+		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
+			  vld1q_u64(dp3 + 2));
+		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
+			  vld1q_u64(dp3 + 4));
+		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
+			  vld1q_u64(dp3 + 6));
+
+		/* store */
+		vst1q_u64(dp1 + 0, v0);
+		vst1q_u64(dp1 + 2, v1);
+		vst1q_u64(dp1 + 4, v2);
+		vst1q_u64(dp1 + 6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+	} while (--lines > 0);
+}
+
+static void xor_arm64_eor3_4(unsigned long bytes,
+	unsigned long * __restrict p1,
+	const unsigned long * __restrict p2,
+	const unsigned long * __restrict p3,
+	const unsigned long * __restrict p4)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 ^ p3 */
+		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
+			  vld1q_u64(dp3 + 0));
+		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
+			  vld1q_u64(dp3 + 2));
+		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
+			  vld1q_u64(dp3 + 4));
+		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
+			  vld1q_u64(dp3 + 6));
+
+		/* p1 ^= p4 */
+		v0 = veorq_u64(v0, vld1q_u64(dp4 + 0));
+		v1 = veorq_u64(v1, vld1q_u64(dp4 + 2));
+		v2 = veorq_u64(v2, vld1q_u64(dp4 + 4));
+		v3 = veorq_u64(v3, vld1q_u64(dp4 + 6));
+
+		/* store */
+		vst1q_u64(dp1 + 0, v0);
+		vst1q_u64(dp1 + 2, v1);
+		vst1q_u64(dp1 + 4, v2);
+		vst1q_u64(dp1 + 6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+	} while (--lines > 0);
+}
+
+static void xor_arm64_eor3_5(unsigned long bytes,
+	unsigned long * __restrict p1,
+	const unsigned long * __restrict p2,
+	const unsigned long * __restrict p3,
+	const unsigned long * __restrict p4,
+	const unsigned long * __restrict p5)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+	uint64_t *dp5 = (uint64_t *)p5;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 ^ p3 */
+		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
+			  vld1q_u64(dp3 + 0));
+		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
+			  vld1q_u64(dp3 + 2));
+		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
+			  vld1q_u64(dp3 + 4));
+		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
+			  vld1q_u64(dp3 + 6));
+
+		/* p1 ^= p4 ^ p5 */
+		v0 = eor3(v0, vld1q_u64(dp4 + 0), vld1q_u64(dp5 + 0));
+		v1 = eor3(v1, vld1q_u64(dp4 + 2), vld1q_u64(dp5 + 2));
+		v2 = eor3(v2, vld1q_u64(dp4 + 4), vld1q_u64(dp5 + 4));
+		v3 = eor3(v3, vld1q_u64(dp4 + 6), vld1q_u64(dp5 + 6));
+
+		/* store */
+		vst1q_u64(dp1 + 0, v0);
+		vst1q_u64(dp1 + 2, v1);
+		vst1q_u64(dp1 + 4, v2);
+		vst1q_u64(dp1 + 6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+		dp5 += 8;
+	} while (--lines > 0);
+}
+
+void __init xor_neon_init(void)
+{
+	if (cpu_have_named_feature(SHA3)) {
+		xor_block_inner_neon.do_3 = xor_arm64_eor3_3;
+		xor_block_inner_neon.do_4 = xor_arm64_eor3_4;
+		xor_block_inner_neon.do_5 = xor_arm64_eor3_5;
+	}
+}
diff --git a/lib/raid/xor/arm64/xor-neon-glue.c a/lib/raid/xor/arm64/xor-neon-glue.c
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/arm64/xor-neon-glue.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Authors: Jackie Liu <liuyun01@kylinos.cn>
+ * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
+ */
+
+#include <linux/raid/xor_impl.h>
+#include <asm/simd.h>
+#include <asm/xor.h>
+
+extern struct xor_block_template const xor_block_inner_neon;
+
+static void
+xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+	   const unsigned long * __restrict p2)
+{
+	scoped_ksimd()
+		xor_block_inner_neon.do_2(bytes, p1, p2);
+}
+
+static void
+xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+	   const unsigned long * __restrict p2,
+	   const unsigned long * __restrict p3)
+{
+	scoped_ksimd()
+		xor_block_inner_neon.do_3(bytes, p1, p2, p3);
+}
+
+static void
+xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+	   const unsigned long * __restrict p2,
+	   const unsigned long * __restrict p3,
+	   const unsigned long * __restrict p4)
+{
+	scoped_ksimd()
+		xor_block_inner_neon.do_4(bytes, p1, p2, p3, p4);
+}
+
+static void
+xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+	   const unsigned long * __restrict p2,
+	   const unsigned long * __restrict p3,
+	   const unsigned long * __restrict p4,
+	   const unsigned long * __restrict p5)
+{
+	scoped_ksimd()
+		xor_block_inner_neon.do_5(bytes, p1, p2, p3, p4, p5);
+}
+
+struct xor_block_template xor_block_arm64 = {
+	.name   = "arm64_neon",
+	.do_2   = xor_neon_2,
+	.do_3   = xor_neon_3,
+	.do_4   = xor_neon_4,
+	.do_5	= xor_neon_5
+};
--- a/lib/raid/xor/Makefile~arm64-move-the-xor-code-to-lib-raid
+++ a/lib/raid/xor/Makefile
@@ -13,7 +13,11 @@ xor-$(CONFIG_ARM)		+= arm/xor.o
 ifeq ($(CONFIG_ARM),y)
 xor-$(CONFIG_KERNEL_MODE_NEON)	+= arm/xor-neon.o arm/xor-neon-glue.o
 endif
+xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o arm64/xor-neon-glue.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
 CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
+
+CFLAGS_arm64/xor-neon.o		+= $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_arm64/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
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

