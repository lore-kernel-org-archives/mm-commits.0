Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C21E36607C
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198525; cv=none; b=g8h5fMfhXRBGe0IEnRhYPTnvkvoZEDpN+SLOI2IavWW/rCab102y2dEbxqmHjo4eYyc/rLdVjTiFfgQjCQBQOKWro0MLRImbMJzdXIhpJ8aEBa+5oJrFRKB7k0GZn2zyvo6r6jXAkYkg18FahhQK1bJDNzKi5FiQxBfJls7yeEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198525; c=relaxed/simple;
	bh=GXQ/Ll4g7M0BQ+KkBwbkRqt5XtHaQzxAg/5XL7rd+3o=;
	h=Date:To:From:Subject:Message-Id; b=HnoUSUkxvIvNGgXk5mM9DQWS9dFSn4C0nKlTi2Qi8ndACJXi6NnhPIQ3ydJVBcZ/oH/RMM8D5WsDWP1TmH1PLp3TYWK+6a8T4XgKgrwG5R3GUufPYwRQ78yT2t3EYww488DkVJy3mWxKtXJ9DLWB/63JVG9eL7dr1Iz+LnEQfLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OYIW9SFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OYIW9SFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ED5C4CEF7;
	Fri,  3 Apr 2026 06:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198525;
	bh=GXQ/Ll4g7M0BQ+KkBwbkRqt5XtHaQzxAg/5XL7rd+3o=;
	h=Date:To:From:Subject:From;
	b=OYIW9SFpxrZ38j9uhrtCPiO39I9emEWITPDZOtmS/3Xvztdkjpulo/r24Ooyrmmfh
	 Amuh/NWDJsTdZd8aZ4DsOVNis9FHN6PB2Iuw9Z902KsDiRESn0tbWGGn3YbH4TA5NJ
	 ehOGke+5TDINdFjPhFYBOBleT2Jf1u3+uFxe0Kns=
Date: Thu, 02 Apr 2026 23:42:04 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-avoid-indirect-calls-for-arm64-optimized-ops.patch removed from -mm tree
Message-Id: <20260403064204.D9ED5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: avoid indirect calls for arm64-optimized ops
has been removed from the -mm tree.  Its filename was
     xor-avoid-indirect-calls-for-arm64-optimized-ops.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: avoid indirect calls for arm64-optimized ops
Date: Fri, 27 Mar 2026 07:16:52 +0100

Remove the inner xor_block_templates, and instead have two separate actual
template that call into the neon-enabled compilation unit.

Link: https://lkml.kernel.org/r/20260327061704.3707577-21-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
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


