Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D783750A7
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632734; cv=none; b=SqaNEiLB4Do8kr+gvj4ff7Rda5LvUkdy2k0gzqQI83LI3Cnd5JwfNiVnInzD75QbE/fjd7lCQk9Sk706GA23FnW3BksfNU4AaSkcyyInJPtmm5pNqw0s9BSxVOqYkeoGws9ce53IDrNBb5euz6gOnEYB5wY9AHj6vpOB8YGRdyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632734; c=relaxed/simple;
	bh=7n94JyGqmFlNCc+bFhAcRVSPZms5UPBtld+vVvMcCZs=;
	h=Date:To:From:Subject:Message-Id; b=iZH4lPbGD4F5ceg64xnwx/Zyt1HwFstCz3GIP/PXXTuAKpx+QvPJwcCynT63gQzdLN20S0VrbGpahOZqluGMe57p82kWiDOpp5T8nVa0/ddltRYTrtmt2/sg7xhnR0yh1w7HVH+JBj881KsJuRHlOTh7gWU9YtukBJ21EGY3xW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UlHmoKHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UlHmoKHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5DCC19423;
	Fri, 27 Mar 2026 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632734;
	bh=7n94JyGqmFlNCc+bFhAcRVSPZms5UPBtld+vVvMcCZs=;
	h=Date:To:From:Subject:From;
	b=UlHmoKHqM6Vg3fXsDhnPWxjaX6j95X6yIE+fShZlXftTWAGO4AoHSwkQ4vc9A8vmh
	 C+YrLQOZ16dk867bztge29EVn0GyI8BMuin2ImTH7ZDBc9gQeu86VOy8TvMgZ1lr6s
	 ptamCeOuMrp4yHesPmgZCTydXsVx7qsxCx49hJuc=
Date: Fri, 27 Mar 2026 10:32:13 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xor-avoid-indirect-calls-for-arm64-optimized-ops.patch removed from -mm tree
Message-Id: <20260327173214.3E5DCC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: avoid indirect calls for arm64-optimized ops
has been removed from the -mm tree.  Its filename was
     xor-avoid-indirect-calls-for-arm64-optimized-ops.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: avoid indirect calls for arm64-optimized ops
Date: Tue, 24 Mar 2026 07:21:55 +0100

Remove the inner xor_block_templates, and instead have two separate
actual template that call into the neon-enabled compilation unit.

Link: https://lkml.kernel.org/r/20260324062211.3216301-20-hch@lst.de
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

 arch/arm64/include/asm/xor.h       |   13 ++-
 lib/raid/xor/arm64/xor-neon-glue.c |   95 +++++++++++++--------------
 lib/raid/xor/arm64/xor-neon.c      |   73 +++++++-------------
 lib/raid/xor/arm64/xor-neon.h      |   30 ++++++++
 4 files changed, 114 insertions(+), 97 deletions(-)

--- a/arch/arm64/include/asm/xor.h~xor-avoid-indirect-calls-for-arm64-optimized-ops
+++ a/arch/arm64/include/asm/xor.h
@@ -7,15 +7,18 @@
 #include <asm-generic/xor.h>
 #include <asm/simd.h>
 
-extern struct xor_block_template xor_block_arm64;
-void __init xor_neon_init(void);
+extern struct xor_block_template xor_block_neon;
+extern struct xor_block_template xor_block_eor3;
 
 #define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
-	xor_neon_init();
 	xor_register(&xor_block_8regs);
 	xor_register(&xor_block_32regs);
-	if (cpu_has_neon())
-		xor_register(&xor_block_arm64);
+	if (cpu_has_neon()) {
+		if (cpu_have_named_feature(SHA3))
+			xor_register(&xor_block_eor3);
+		else
+			xor_register(&xor_block_neon);
+	}
 }
--- a/lib/raid/xor/arm64/xor-neon.c~xor-avoid-indirect-calls-for-arm64-optimized-ops
+++ a/lib/raid/xor/arm64/xor-neon.c
@@ -8,9 +8,10 @@
 #include <linux/cache.h>
 #include <asm/neon-intrinsics.h>
 #include <asm/xor.h>
+#include "xor-neon.h"
 
-static void xor_arm64_neon_2(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2)
+void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -36,9 +37,9 @@ static void xor_arm64_neon_2(unsigned lo
 	} while (--lines > 0);
 }
 
-static void xor_arm64_neon_3(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3)
+void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -72,10 +73,10 @@ static void xor_arm64_neon_3(unsigned lo
 	} while (--lines > 0);
 }
 
-static void xor_arm64_neon_4(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4)
+void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -117,11 +118,11 @@ static void xor_arm64_neon_4(unsigned lo
 	} while (--lines > 0);
 }
 
-static void xor_arm64_neon_5(unsigned long bytes, unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4,
-	const unsigned long * __restrict p5)
+void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -171,14 +172,6 @@ static void xor_arm64_neon_5(unsigned lo
 	} while (--lines > 0);
 }
 
-struct xor_block_template xor_block_inner_neon __ro_after_init = {
-	.name	= "__inner_neon__",
-	.do_2	= xor_arm64_neon_2,
-	.do_3	= xor_arm64_neon_3,
-	.do_4	= xor_arm64_neon_4,
-	.do_5	= xor_arm64_neon_5,
-};
-
 static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
 {
 	uint64x2_t res;
@@ -189,10 +182,9 @@ static inline uint64x2_t eor3(uint64x2_t
 	return res;
 }
 
-static void xor_arm64_eor3_3(unsigned long bytes,
-	unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3)
+void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -224,11 +216,10 @@ static void xor_arm64_eor3_3(unsigned lo
 	} while (--lines > 0);
 }
 
-static void xor_arm64_eor3_4(unsigned long bytes,
-	unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4)
+void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -268,12 +259,11 @@ static void xor_arm64_eor3_4(unsigned lo
 	} while (--lines > 0);
 }
 
-static void xor_arm64_eor3_5(unsigned long bytes,
-	unsigned long * __restrict p1,
-	const unsigned long * __restrict p2,
-	const unsigned long * __restrict p3,
-	const unsigned long * __restrict p4,
-	const unsigned long * __restrict p5)
+void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
 	uint64_t *dp2 = (uint64_t *)p2;
@@ -314,12 +304,3 @@ static void xor_arm64_eor3_5(unsigned lo
 		dp5 += 8;
 	} while (--lines > 0);
 }
-
-void __init xor_neon_init(void)
-{
-	if (cpu_have_named_feature(SHA3)) {
-		xor_block_inner_neon.do_3 = xor_arm64_eor3_3;
-		xor_block_inner_neon.do_4 = xor_arm64_eor3_4;
-		xor_block_inner_neon.do_5 = xor_arm64_eor3_5;
-	}
-}
--- a/lib/raid/xor/arm64/xor-neon-glue.c~xor-avoid-indirect-calls-for-arm64-optimized-ops
+++ a/lib/raid/xor/arm64/xor-neon-glue.c
@@ -7,51 +7,54 @@
 #include <linux/raid/xor_impl.h>
 #include <asm/simd.h>
 #include <asm/xor.h>
+#include "xor-neon.h"
 
-extern struct xor_block_template const xor_block_inner_neon;
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
-struct xor_block_template xor_block_arm64 = {
-	.name   = "arm64_neon",
-	.do_2   = xor_neon_2,
-	.do_3   = xor_neon_3,
-	.do_4   = xor_neon_4,
-	.do_5	= xor_neon_5
+#define XOR_TEMPLATE(_name)						\
+static void								\
+xor_##_name##_2(unsigned long bytes, unsigned long * __restrict p1,	\
+	   const unsigned long * __restrict p2)				\
+{									\
+	scoped_ksimd()							\
+		__xor_##_name##_2(bytes, p1, p2);			\
+}									\
+									\
+static void								\
+xor_##_name##_3(unsigned long bytes, unsigned long * __restrict p1,	\
+	   const unsigned long * __restrict p2,				\
+	   const unsigned long * __restrict p3)				\
+{									\
+	scoped_ksimd()							\
+		__xor_##_name##_3(bytes, p1, p2, p3);			\
+}									\
+									\
+static void								\
+xor_##_name##_4(unsigned long bytes, unsigned long * __restrict p1,	\
+	   const unsigned long * __restrict p2,				\
+	   const unsigned long * __restrict p3,				\
+	   const unsigned long * __restrict p4)				\
+{									\
+	scoped_ksimd()							\
+		__xor_##_name##_4(bytes, p1, p2, p3, p4);		\
+}									\
+									\
+static void								\
+xor_##_name##_5(unsigned long bytes, unsigned long * __restrict p1,	\
+	   const unsigned long * __restrict p2,				\
+	   const unsigned long * __restrict p3,				\
+	   const unsigned long * __restrict p4,				\
+	   const unsigned long * __restrict p5)				\
+{									\
+	scoped_ksimd()							\
+		__xor_##_name##_5(bytes, p1, p2, p3, p4, p5);		\
+}									\
+									\
+struct xor_block_template xor_block_##_name = {				\
+	.name   = __stringify(_name),					\
+	.do_2   = xor_##_name##_2,					\
+	.do_3   = xor_##_name##_3,					\
+	.do_4   = xor_##_name##_4,					\
+	.do_5	= xor_##_name##_5					\
 };
+
+XOR_TEMPLATE(neon);
+XOR_TEMPLATE(eor3);
diff --git a/lib/raid/xor/arm64/xor-neon.h a/lib/raid/xor/arm64/xor-neon.h
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/arm64/xor-neon.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2);
+void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3);
+void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4);
+void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5);
+
+#define __xor_eor3_2	__xor_neon_2
+void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3);
+void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4);
+void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5);
_

Patches currently in -mm which might be from hch@lst.de are

xor-make-xorko-self-contained-in-lib-raid.patch
xor-add-a-better-public-api.patch
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

