Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F8235A3BF
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198515; cv=none; b=B/wu0xYvSokYw2qsHGqGnK0SdJe5zL9qj0ScoJRdhVy1m2RNWAR7LTVX5Ayod9E16HrpmoNm2NohEb035vrbY51MWRWmAdk4nrW8V34WxWL6sPVi0WQvvh+3BYFfeMd1CKlj/eJOhrPm7osb7KwDxNxveAePDC+ZsAYmLgHDTw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198515; c=relaxed/simple;
	bh=NjeF8HXHYHrcMmzxuCk5348m1/108AfhiB3VqZQ73ds=;
	h=Date:To:From:Subject:Message-Id; b=YB0oTAWb5TxwgSv9kkSbUkRb9C3qH+TyR8jzIt2sdYrzI7texlTOa1cpGh4wZ0SxYEXpOlisX6LtbnSiz29okR3N75lQ6wS9jZ7Dt5ivNnrB725iFv9172TJ8v828AAS1v3YP2VpJCK1bBY6WK23fwDmOxXHiiGn+hovbW61LaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eFMRwSQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eFMRwSQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9443FC4CEF7;
	Fri,  3 Apr 2026 06:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198514;
	bh=NjeF8HXHYHrcMmzxuCk5348m1/108AfhiB3VqZQ73ds=;
	h=Date:To:From:Subject:From;
	b=eFMRwSQrVoDLz/Z68+erXEQgcUq5QcmmuQHqxObHe91Y9C42e7lnqkEzvjAN1K3Jf
	 gSNRtc4qBBKa+vj7H1jd4mWpq41dcXv7xGP10BUw9nrrQHythfjawJdtWVvhvMDMON
	 ZwiX0y/XuyCEM/wQ4DmSp8iSpHmOY2LynLuhVi/4=
Date: Thu, 02 Apr 2026 23:41:54 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-move-the-xor-code-to-lib-raid.patch removed from -mm tree
Message-Id: <20260403064154.9443FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: move the XOR code to lib/raid/
has been removed from the -mm tree.  Its filename was
     powerpc-move-the-xor-code-to-lib-raid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: powerpc: move the XOR code to lib/raid/
Date: Fri, 27 Mar 2026 07:16:47 +0100

Move the optimized XOR into lib/raid and include it it in xor.ko instead
of always building it into the main kernel image.

Link: https://lkml.kernel.org/r/20260327061704.3707577-16-hch@lst.de
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

 arch/powerpc/include/asm/xor.h         |   17 --
 arch/powerpc/include/asm/xor_altivec.h |   22 ---
 arch/powerpc/lib/Makefile              |    5 
 arch/powerpc/lib/xor_vmx.c             |  156 -----------------------
 arch/powerpc/lib/xor_vmx.h             |   22 ---
 arch/powerpc/lib/xor_vmx_glue.c        |   63 ---------
 lib/raid/xor/Makefile                  |    5 
 lib/raid/xor/powerpc/xor_vmx.c         |  156 +++++++++++++++++++++++
 lib/raid/xor/powerpc/xor_vmx.h         |   22 +++
 lib/raid/xor/powerpc/xor_vmx_glue.c    |   67 +++++++++
 10 files changed, 252 insertions(+), 283 deletions(-)

diff --git a/arch/powerpc/include/asm/xor_altivec.h a/arch/powerpc/include/asm/xor_altivec.h
deleted file mode 100644
--- a/arch/powerpc/include/asm/xor_altivec.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_POWERPC_XOR_ALTIVEC_H
-#define _ASM_POWERPC_XOR_ALTIVEC_H
-
-#ifdef CONFIG_ALTIVEC
-void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2);
-void xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3);
-void xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4);
-void xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4,
-		   const unsigned long * __restrict p5);
-
-#endif
-#endif /* _ASM_POWERPC_XOR_ALTIVEC_H */
--- a/arch/powerpc/include/asm/xor.h~powerpc-move-the-xor-code-to-lib-raid
+++ a/arch/powerpc/include/asm/xor.h
@@ -8,24 +8,11 @@
 #ifndef _ASM_POWERPC_XOR_H
 #define _ASM_POWERPC_XOR_H
 
-#ifdef CONFIG_ALTIVEC
-
-#include <asm/cputable.h>
 #include <asm/cpu_has_feature.h>
-#include <asm/xor_altivec.h>
-
-static struct xor_block_template xor_block_altivec = {
-	.name = "altivec",
-	.do_2 = xor_altivec_2,
-	.do_3 = xor_altivec_3,
-	.do_4 = xor_altivec_4,
-	.do_5 = xor_altivec_5,
-};
-#endif /* CONFIG_ALTIVEC */
-
-/* Also try the generic routines. */
 #include <asm-generic/xor.h>
 
+extern struct xor_block_template xor_block_altivec;
+
 #define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
 {
--- a/arch/powerpc/lib/Makefile~powerpc-move-the-xor-code-to-lib-raid
+++ a/arch/powerpc/lib/Makefile
@@ -73,9 +73,4 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
-obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
-# Enable <altivec.h>
-CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
-
 obj-$(CONFIG_PPC64) += $(obj64-y)
diff --git a/arch/powerpc/lib/xor_vmx.c a/arch/powerpc/lib/xor_vmx.c
deleted file mode 100644
--- a/arch/powerpc/lib/xor_vmx.c
+++ /dev/null
@@ -1,156 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *
- * Copyright (C) IBM Corporation, 2012
- *
- * Author: Anton Blanchard <anton@au.ibm.com>
- */
-
-/*
- * Sparse (as at v0.5.0) gets very, very confused by this file.
- * Make it a bit simpler for it.
- */
-#if !defined(__CHECKER__)
-#include <altivec.h>
-#else
-#define vec_xor(a, b) a ^ b
-#define vector __attribute__((vector_size(16)))
-#endif
-
-#include "xor_vmx.h"
-
-typedef vector signed char unative_t;
-
-#define DEFINE(V)				\
-	unative_t *V = (unative_t *)V##_in;	\
-	unative_t V##_0, V##_1, V##_2, V##_3
-
-#define LOAD(V)			\
-	do {			\
-		V##_0 = V[0];	\
-		V##_1 = V[1];	\
-		V##_2 = V[2];	\
-		V##_3 = V[3];	\
-	} while (0)
-
-#define STORE(V)		\
-	do {			\
-		V[0] = V##_0;	\
-		V[1] = V##_1;	\
-		V[2] = V##_2;	\
-		V[3] = V##_3;	\
-	} while (0)
-
-#define XOR(V1, V2)					\
-	do {						\
-		V1##_0 = vec_xor(V1##_0, V2##_0);	\
-		V1##_1 = vec_xor(V1##_1, V2##_1);	\
-		V1##_2 = vec_xor(V1##_2, V2##_2);	\
-		V1##_3 = vec_xor(V1##_3, V2##_3);	\
-	} while (0)
-
-void __xor_altivec_2(unsigned long bytes,
-		     unsigned long * __restrict v1_in,
-		     const unsigned long * __restrict v2_in)
-{
-	DEFINE(v1);
-	DEFINE(v2);
-	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
-
-	do {
-		LOAD(v1);
-		LOAD(v2);
-		XOR(v1, v2);
-		STORE(v1);
-
-		v1 += 4;
-		v2 += 4;
-	} while (--lines > 0);
-}
-
-void __xor_altivec_3(unsigned long bytes,
-		     unsigned long * __restrict v1_in,
-		     const unsigned long * __restrict v2_in,
-		     const unsigned long * __restrict v3_in)
-{
-	DEFINE(v1);
-	DEFINE(v2);
-	DEFINE(v3);
-	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
-
-	do {
-		LOAD(v1);
-		LOAD(v2);
-		LOAD(v3);
-		XOR(v1, v2);
-		XOR(v1, v3);
-		STORE(v1);
-
-		v1 += 4;
-		v2 += 4;
-		v3 += 4;
-	} while (--lines > 0);
-}
-
-void __xor_altivec_4(unsigned long bytes,
-		     unsigned long * __restrict v1_in,
-		     const unsigned long * __restrict v2_in,
-		     const unsigned long * __restrict v3_in,
-		     const unsigned long * __restrict v4_in)
-{
-	DEFINE(v1);
-	DEFINE(v2);
-	DEFINE(v3);
-	DEFINE(v4);
-	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
-
-	do {
-		LOAD(v1);
-		LOAD(v2);
-		LOAD(v3);
-		LOAD(v4);
-		XOR(v1, v2);
-		XOR(v3, v4);
-		XOR(v1, v3);
-		STORE(v1);
-
-		v1 += 4;
-		v2 += 4;
-		v3 += 4;
-		v4 += 4;
-	} while (--lines > 0);
-}
-
-void __xor_altivec_5(unsigned long bytes,
-		     unsigned long * __restrict v1_in,
-		     const unsigned long * __restrict v2_in,
-		     const unsigned long * __restrict v3_in,
-		     const unsigned long * __restrict v4_in,
-		     const unsigned long * __restrict v5_in)
-{
-	DEFINE(v1);
-	DEFINE(v2);
-	DEFINE(v3);
-	DEFINE(v4);
-	DEFINE(v5);
-	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
-
-	do {
-		LOAD(v1);
-		LOAD(v2);
-		LOAD(v3);
-		LOAD(v4);
-		LOAD(v5);
-		XOR(v1, v2);
-		XOR(v3, v4);
-		XOR(v1, v5);
-		XOR(v1, v3);
-		STORE(v1);
-
-		v1 += 4;
-		v2 += 4;
-		v3 += 4;
-		v4 += 4;
-		v5 += 4;
-	} while (--lines > 0);
-}
diff --git a/arch/powerpc/lib/xor_vmx_glue.c a/arch/powerpc/lib/xor_vmx_glue.c
deleted file mode 100644
--- a/arch/powerpc/lib/xor_vmx_glue.c
+++ /dev/null
@@ -1,63 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Altivec XOR operations
- *
- * Copyright 2017 IBM Corp.
- */
-
-#include <linux/preempt.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <asm/switch_to.h>
-#include <asm/xor_altivec.h>
-#include "xor_vmx.h"
-
-void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_2(bytes, p1, p2);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_2);
-
-void xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_3(bytes, p1, p2, p3);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_3);
-
-void xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_4(bytes, p1, p2, p3, p4);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_4);
-
-void xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
-		   const unsigned long * __restrict p2,
-		   const unsigned long * __restrict p3,
-		   const unsigned long * __restrict p4,
-		   const unsigned long * __restrict p5)
-{
-	preempt_disable();
-	enable_kernel_altivec();
-	__xor_altivec_5(bytes, p1, p2, p3, p4, p5);
-	disable_kernel_altivec();
-	preempt_enable();
-}
-EXPORT_SYMBOL(xor_altivec_5);
diff --git a/arch/powerpc/lib/xor_vmx.h a/arch/powerpc/lib/xor_vmx.h
deleted file mode 100644
--- a/arch/powerpc/lib/xor_vmx.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Simple interface to link xor_vmx.c and xor_vmx_glue.c
- *
- * Separating these file ensures that no altivec instructions are run
- * outside of the enable/disable altivec block.
- */
-
-void __xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2);
-void __xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2,
-		     const unsigned long * __restrict p3);
-void __xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2,
-		     const unsigned long * __restrict p3,
-		     const unsigned long * __restrict p4);
-void __xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
-		     const unsigned long * __restrict p2,
-		     const unsigned long * __restrict p3,
-		     const unsigned long * __restrict p4,
-		     const unsigned long * __restrict p5);
--- a/lib/raid/xor/Makefile~powerpc-move-the-xor-code-to-lib-raid
+++ a/lib/raid/xor/Makefile
@@ -16,6 +16,7 @@ endif
 xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o arm64/xor-neon-glue.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd_glue.o
+xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
@@ -23,3 +24,7 @@ CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLA
 
 CFLAGS_arm64/xor-neon.o		+= $(CC_FLAGS_FPU)
 CFLAGS_REMOVE_arm64/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
+
+CFLAGS_powerpc/xor_vmx.o	+= -mhard-float -maltivec \
+				   $(call cc-option,-mabi=altivec) \
+				   -isystem $(shell $(CC) -print-file-name=include)
diff --git a/lib/raid/xor/powerpc/xor_vmx.c a/lib/raid/xor/powerpc/xor_vmx.c
new file mode 100664
--- /dev/null
+++ a/lib/raid/xor/powerpc/xor_vmx.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *
+ * Copyright (C) IBM Corporation, 2012
+ *
+ * Author: Anton Blanchard <anton@au.ibm.com>
+ */
+
+/*
+ * Sparse (as at v0.5.0) gets very, very confused by this file.
+ * Make it a bit simpler for it.
+ */
+#if !defined(__CHECKER__)
+#include <altivec.h>
+#else
+#define vec_xor(a, b) a ^ b
+#define vector __attribute__((vector_size(16)))
+#endif
+
+#include "xor_vmx.h"
+
+typedef vector signed char unative_t;
+
+#define DEFINE(V)				\
+	unative_t *V = (unative_t *)V##_in;	\
+	unative_t V##_0, V##_1, V##_2, V##_3
+
+#define LOAD(V)			\
+	do {			\
+		V##_0 = V[0];	\
+		V##_1 = V[1];	\
+		V##_2 = V[2];	\
+		V##_3 = V[3];	\
+	} while (0)
+
+#define STORE(V)		\
+	do {			\
+		V[0] = V##_0;	\
+		V[1] = V##_1;	\
+		V[2] = V##_2;	\
+		V[3] = V##_3;	\
+	} while (0)
+
+#define XOR(V1, V2)					\
+	do {						\
+		V1##_0 = vec_xor(V1##_0, V2##_0);	\
+		V1##_1 = vec_xor(V1##_1, V2##_1);	\
+		V1##_2 = vec_xor(V1##_2, V2##_2);	\
+		V1##_3 = vec_xor(V1##_3, V2##_3);	\
+	} while (0)
+
+void __xor_altivec_2(unsigned long bytes,
+		     unsigned long * __restrict v1_in,
+		     const unsigned long * __restrict v2_in)
+{
+	DEFINE(v1);
+	DEFINE(v2);
+	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
+
+	do {
+		LOAD(v1);
+		LOAD(v2);
+		XOR(v1, v2);
+		STORE(v1);
+
+		v1 += 4;
+		v2 += 4;
+	} while (--lines > 0);
+}
+
+void __xor_altivec_3(unsigned long bytes,
+		     unsigned long * __restrict v1_in,
+		     const unsigned long * __restrict v2_in,
+		     const unsigned long * __restrict v3_in)
+{
+	DEFINE(v1);
+	DEFINE(v2);
+	DEFINE(v3);
+	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
+
+	do {
+		LOAD(v1);
+		LOAD(v2);
+		LOAD(v3);
+		XOR(v1, v2);
+		XOR(v1, v3);
+		STORE(v1);
+
+		v1 += 4;
+		v2 += 4;
+		v3 += 4;
+	} while (--lines > 0);
+}
+
+void __xor_altivec_4(unsigned long bytes,
+		     unsigned long * __restrict v1_in,
+		     const unsigned long * __restrict v2_in,
+		     const unsigned long * __restrict v3_in,
+		     const unsigned long * __restrict v4_in)
+{
+	DEFINE(v1);
+	DEFINE(v2);
+	DEFINE(v3);
+	DEFINE(v4);
+	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
+
+	do {
+		LOAD(v1);
+		LOAD(v2);
+		LOAD(v3);
+		LOAD(v4);
+		XOR(v1, v2);
+		XOR(v3, v4);
+		XOR(v1, v3);
+		STORE(v1);
+
+		v1 += 4;
+		v2 += 4;
+		v3 += 4;
+		v4 += 4;
+	} while (--lines > 0);
+}
+
+void __xor_altivec_5(unsigned long bytes,
+		     unsigned long * __restrict v1_in,
+		     const unsigned long * __restrict v2_in,
+		     const unsigned long * __restrict v3_in,
+		     const unsigned long * __restrict v4_in,
+		     const unsigned long * __restrict v5_in)
+{
+	DEFINE(v1);
+	DEFINE(v2);
+	DEFINE(v3);
+	DEFINE(v4);
+	DEFINE(v5);
+	unsigned long lines = bytes / (sizeof(unative_t)) / 4;
+
+	do {
+		LOAD(v1);
+		LOAD(v2);
+		LOAD(v3);
+		LOAD(v4);
+		LOAD(v5);
+		XOR(v1, v2);
+		XOR(v3, v4);
+		XOR(v1, v5);
+		XOR(v1, v3);
+		STORE(v1);
+
+		v1 += 4;
+		v2 += 4;
+		v3 += 4;
+		v4 += 4;
+		v5 += 4;
+	} while (--lines > 0);
+}
diff --git a/lib/raid/xor/powerpc/xor_vmx_glue.c a/lib/raid/xor/powerpc/xor_vmx_glue.c
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/powerpc/xor_vmx_glue.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Altivec XOR operations
+ *
+ * Copyright 2017 IBM Corp.
+ */
+
+#include <linux/preempt.h>
+#include <linux/sched.h>
+#include <linux/raid/xor_impl.h>
+#include <asm/switch_to.h>
+#include <asm/xor.h>
+#include "xor_vmx.h"
+
+static void xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_2(bytes, p1, p2);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+static void xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_3(bytes, p1, p2, p3);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+static void xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_4(bytes, p1, p2, p3, p4);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+static void xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+	__xor_altivec_5(bytes, p1, p2, p3, p4, p5);
+	disable_kernel_altivec();
+	preempt_enable();
+}
+
+struct xor_block_template xor_block_altivec = {
+	.name = "altivec",
+	.do_2 = xor_altivec_2,
+	.do_3 = xor_altivec_3,
+	.do_4 = xor_altivec_4,
+	.do_5 = xor_altivec_5,
+};
diff --git a/lib/raid/xor/powerpc/xor_vmx.h a/lib/raid/xor/powerpc/xor_vmx.h
new file mode 100664
--- /dev/null
+++ a/lib/raid/xor/powerpc/xor_vmx.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Simple interface to link xor_vmx.c and xor_vmx_glue.c
+ *
+ * Separating these file ensures that no altivec instructions are run
+ * outside of the enable/disable altivec block.
+ */
+
+void __xor_altivec_2(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2);
+void __xor_altivec_3(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2,
+		     const unsigned long * __restrict p3);
+void __xor_altivec_4(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2,
+		     const unsigned long * __restrict p3,
+		     const unsigned long * __restrict p4);
+void __xor_altivec_5(unsigned long bytes, unsigned long * __restrict p1,
+		     const unsigned long * __restrict p2,
+		     const unsigned long * __restrict p3,
+		     const unsigned long * __restrict p4,
+		     const unsigned long * __restrict p5);
_

Patches currently in -mm which might be from hch@lst.de are


