Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740EE12B93
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633836; cv=none; b=izNvzRwMCAvOJ6me0MgyxFaJhhLvBZLFE5aZLeZHOVv8u6NHjhACGRXB07CiYX74LifkFJtt66x8B1RXBRi3gGz8Ahnm/eXhsFiSphhOKmbkQlwGb0gX5g/DtX2RXp2yYwk4bTlovqZgXtQ8IU2aWnMxMJANvx5Jet7dhJHTGjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633836; c=relaxed/simple;
	bh=CHbn3Bjno8oArZYk1QvqjSU8Fa4OUXWx5U5FWpAo8ns=;
	h=Date:To:From:Subject:Message-Id; b=RTY2kxQcBKa4dPV44IeAv2pxC4m1zKwDvPi0Evn6smQCl3pJjdqsxMF5AEOaTSS+ffFoEO+6ebEdUAv3IO5joMGclf5GaMEmeHBVJI4vJSepI/GCQEdxprY4P7xejOj33SfZqJQsXPiSg6HZUOyBn7hK4d/KiAhgjs2ntSq6YBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPZhwpEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPZhwpEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C502C19423;
	Fri, 27 Mar 2026 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633836;
	bh=CHbn3Bjno8oArZYk1QvqjSU8Fa4OUXWx5U5FWpAo8ns=;
	h=Date:To:From:Subject:From;
	b=oPZhwpEjdP32onus8nnXMJjsvLC4ANE6BrOyW8Ga+WaHP5bfYesJhqzxFD29ualaj
	 CgrQHXLGYeYK+5yTz6hQjQyD+0Ua1SBZNPq9jnSViwqy2sv2zVMMWj0SWMkqlcSNDX
	 piqJ+zP4udKAKVY9aW3a4+e+A0HkjzTOtyD0IOuc=
Date: Fri, 27 Mar 2026 10:50:35 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-move-the-xor-code-to-lib-raid.patch added to mm-nonmm-unstable branch
Message-Id: <20260327175036.4C502C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: move the XOR code to lib/raid/
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-move-the-xor-code-to-lib-raid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-move-the-xor-code-to-lib-raid.patch

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
Subject: riscv: move the XOR code to lib/raid/
Date: Fri, 27 Mar 2026 07:16:48 +0100

Move the optimized XOR into lib/raid and include it it in xor.ko instead
of always building it into the main kernel image.

Link: https://lkml.kernel.org/r/20260327061704.3707577-17-hch@lst.de
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

 arch/riscv/include/asm/xor.h  |   54 ---------------------
 arch/riscv/lib/Makefile       |    1 
 arch/riscv/lib/xor.S          |   81 --------------------------------
 lib/raid/xor/Makefile         |    1 
 lib/raid/xor/riscv/xor-glue.c |   56 ++++++++++++++++++++++
 lib/raid/xor/riscv/xor.S      |   77 ++++++++++++++++++++++++++++++
 6 files changed, 136 insertions(+), 134 deletions(-)

--- a/arch/riscv/include/asm/xor.h~riscv-move-the-xor-code-to-lib-raid
+++ a/arch/riscv/include/asm/xor.h
@@ -2,60 +2,10 @@
 /*
  * Copyright (C) 2021 SiFive
  */
-
-#include <linux/hardirq.h>
-#include <asm-generic/xor.h>
-#ifdef CONFIG_RISCV_ISA_V
 #include <asm/vector.h>
-#include <asm/switch_to.h>
-#include <asm/asm-prototypes.h>
-
-static void xor_vector_2(unsigned long bytes, unsigned long *__restrict p1,
-			 const unsigned long *__restrict p2)
-{
-	kernel_vector_begin();
-	xor_regs_2_(bytes, p1, p2);
-	kernel_vector_end();
-}
-
-static void xor_vector_3(unsigned long bytes, unsigned long *__restrict p1,
-			 const unsigned long *__restrict p2,
-			 const unsigned long *__restrict p3)
-{
-	kernel_vector_begin();
-	xor_regs_3_(bytes, p1, p2, p3);
-	kernel_vector_end();
-}
-
-static void xor_vector_4(unsigned long bytes, unsigned long *__restrict p1,
-			 const unsigned long *__restrict p2,
-			 const unsigned long *__restrict p3,
-			 const unsigned long *__restrict p4)
-{
-	kernel_vector_begin();
-	xor_regs_4_(bytes, p1, p2, p3, p4);
-	kernel_vector_end();
-}
-
-static void xor_vector_5(unsigned long bytes, unsigned long *__restrict p1,
-			 const unsigned long *__restrict p2,
-			 const unsigned long *__restrict p3,
-			 const unsigned long *__restrict p4,
-			 const unsigned long *__restrict p5)
-{
-	kernel_vector_begin();
-	xor_regs_5_(bytes, p1, p2, p3, p4, p5);
-	kernel_vector_end();
-}
+#include <asm-generic/xor.h>
 
-static struct xor_block_template xor_block_rvv = {
-	.name = "rvv",
-	.do_2 = xor_vector_2,
-	.do_3 = xor_vector_3,
-	.do_4 = xor_vector_4,
-	.do_5 = xor_vector_5
-};
-#endif /* CONFIG_RISCV_ISA_V */
+extern struct xor_block_template xor_block_rvv;
 
 #define arch_xor_init arch_xor_init
 static __always_inline void __init arch_xor_init(void)
--- a/arch/riscv/lib/Makefile~riscv-move-the-xor-code-to-lib-raid
+++ a/arch/riscv/lib/Makefile
@@ -16,5 +16,4 @@ lib-$(CONFIG_MMU)	+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
-lib-$(CONFIG_RISCV_ISA_V)	+= xor.o
 lib-$(CONFIG_RISCV_ISA_V)	+= riscv_v_helpers.o
diff --git a/arch/riscv/lib/xor.S a/arch/riscv/lib/xor.S
deleted file mode 100644
--- a/arch/riscv/lib/xor.S
+++ /dev/null
@@ -1,81 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Copyright (C) 2021 SiFive
- */
-#include <linux/linkage.h>
-#include <linux/export.h>
-#include <asm/asm.h>
-
-SYM_FUNC_START(xor_regs_2_)
-	vsetvli a3, a0, e8, m8, ta, ma
-	vle8.v v0, (a1)
-	vle8.v v8, (a2)
-	sub a0, a0, a3
-	vxor.vv v16, v0, v8
-	add a2, a2, a3
-	vse8.v v16, (a1)
-	add a1, a1, a3
-	bnez a0, xor_regs_2_
-	ret
-SYM_FUNC_END(xor_regs_2_)
-EXPORT_SYMBOL(xor_regs_2_)
-
-SYM_FUNC_START(xor_regs_3_)
-	vsetvli a4, a0, e8, m8, ta, ma
-	vle8.v v0, (a1)
-	vle8.v v8, (a2)
-	sub a0, a0, a4
-	vxor.vv v0, v0, v8
-	vle8.v v16, (a3)
-	add a2, a2, a4
-	vxor.vv v16, v0, v16
-	add a3, a3, a4
-	vse8.v v16, (a1)
-	add a1, a1, a4
-	bnez a0, xor_regs_3_
-	ret
-SYM_FUNC_END(xor_regs_3_)
-EXPORT_SYMBOL(xor_regs_3_)
-
-SYM_FUNC_START(xor_regs_4_)
-	vsetvli a5, a0, e8, m8, ta, ma
-	vle8.v v0, (a1)
-	vle8.v v8, (a2)
-	sub a0, a0, a5
-	vxor.vv v0, v0, v8
-	vle8.v v16, (a3)
-	add a2, a2, a5
-	vxor.vv v0, v0, v16
-	vle8.v v24, (a4)
-	add a3, a3, a5
-	vxor.vv v16, v0, v24
-	add a4, a4, a5
-	vse8.v v16, (a1)
-	add a1, a1, a5
-	bnez a0, xor_regs_4_
-	ret
-SYM_FUNC_END(xor_regs_4_)
-EXPORT_SYMBOL(xor_regs_4_)
-
-SYM_FUNC_START(xor_regs_5_)
-	vsetvli a6, a0, e8, m8, ta, ma
-	vle8.v v0, (a1)
-	vle8.v v8, (a2)
-	sub a0, a0, a6
-	vxor.vv v0, v0, v8
-	vle8.v v16, (a3)
-	add a2, a2, a6
-	vxor.vv v0, v0, v16
-	vle8.v v24, (a4)
-	add a3, a3, a6
-	vxor.vv v0, v0, v24
-	vle8.v v8, (a5)
-	add a4, a4, a6
-	vxor.vv v16, v0, v8
-	add a5, a5, a6
-	vse8.v v16, (a1)
-	add a1, a1, a6
-	bnez a0, xor_regs_5_
-	ret
-SYM_FUNC_END(xor_regs_5_)
-EXPORT_SYMBOL(xor_regs_5_)
--- a/lib/raid/xor/Makefile~riscv-move-the-xor-code-to-lib-raid
+++ a/lib/raid/xor/Makefile
@@ -17,6 +17,7 @@ xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd_glue.o
 xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
+xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o riscv/xor-glue.o
 
 
 CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
diff --git a/lib/raid/xor/riscv/xor-glue.c a/lib/raid/xor/riscv/xor-glue.c
new file mode 100644
--- /dev/null
+++ a/lib/raid/xor/riscv/xor-glue.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021 SiFive
+ */
+
+#include <linux/raid/xor_impl.h>
+#include <asm/vector.h>
+#include <asm/switch_to.h>
+#include <asm/asm-prototypes.h>
+#include <asm/xor.h>
+
+static void xor_vector_2(unsigned long bytes, unsigned long *__restrict p1,
+			 const unsigned long *__restrict p2)
+{
+	kernel_vector_begin();
+	xor_regs_2_(bytes, p1, p2);
+	kernel_vector_end();
+}
+
+static void xor_vector_3(unsigned long bytes, unsigned long *__restrict p1,
+			 const unsigned long *__restrict p2,
+			 const unsigned long *__restrict p3)
+{
+	kernel_vector_begin();
+	xor_regs_3_(bytes, p1, p2, p3);
+	kernel_vector_end();
+}
+
+static void xor_vector_4(unsigned long bytes, unsigned long *__restrict p1,
+			 const unsigned long *__restrict p2,
+			 const unsigned long *__restrict p3,
+			 const unsigned long *__restrict p4)
+{
+	kernel_vector_begin();
+	xor_regs_4_(bytes, p1, p2, p3, p4);
+	kernel_vector_end();
+}
+
+static void xor_vector_5(unsigned long bytes, unsigned long *__restrict p1,
+			 const unsigned long *__restrict p2,
+			 const unsigned long *__restrict p3,
+			 const unsigned long *__restrict p4,
+			 const unsigned long *__restrict p5)
+{
+	kernel_vector_begin();
+	xor_regs_5_(bytes, p1, p2, p3, p4, p5);
+	kernel_vector_end();
+}
+
+struct xor_block_template xor_block_rvv = {
+	.name = "rvv",
+	.do_2 = xor_vector_2,
+	.do_3 = xor_vector_3,
+	.do_4 = xor_vector_4,
+	.do_5 = xor_vector_5
+};
diff --git a/lib/raid/xor/riscv/xor.S a/lib/raid/xor/riscv/xor.S
new file mode 100664
--- /dev/null
+++ a/lib/raid/xor/riscv/xor.S
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2021 SiFive
+ */
+#include <linux/linkage.h>
+#include <linux/export.h>
+#include <asm/asm.h>
+
+SYM_FUNC_START(xor_regs_2_)
+	vsetvli a3, a0, e8, m8, ta, ma
+	vle8.v v0, (a1)
+	vle8.v v8, (a2)
+	sub a0, a0, a3
+	vxor.vv v16, v0, v8
+	add a2, a2, a3
+	vse8.v v16, (a1)
+	add a1, a1, a3
+	bnez a0, xor_regs_2_
+	ret
+SYM_FUNC_END(xor_regs_2_)
+
+SYM_FUNC_START(xor_regs_3_)
+	vsetvli a4, a0, e8, m8, ta, ma
+	vle8.v v0, (a1)
+	vle8.v v8, (a2)
+	sub a0, a0, a4
+	vxor.vv v0, v0, v8
+	vle8.v v16, (a3)
+	add a2, a2, a4
+	vxor.vv v16, v0, v16
+	add a3, a3, a4
+	vse8.v v16, (a1)
+	add a1, a1, a4
+	bnez a0, xor_regs_3_
+	ret
+SYM_FUNC_END(xor_regs_3_)
+
+SYM_FUNC_START(xor_regs_4_)
+	vsetvli a5, a0, e8, m8, ta, ma
+	vle8.v v0, (a1)
+	vle8.v v8, (a2)
+	sub a0, a0, a5
+	vxor.vv v0, v0, v8
+	vle8.v v16, (a3)
+	add a2, a2, a5
+	vxor.vv v0, v0, v16
+	vle8.v v24, (a4)
+	add a3, a3, a5
+	vxor.vv v16, v0, v24
+	add a4, a4, a5
+	vse8.v v16, (a1)
+	add a1, a1, a5
+	bnez a0, xor_regs_4_
+	ret
+SYM_FUNC_END(xor_regs_4_)
+
+SYM_FUNC_START(xor_regs_5_)
+	vsetvli a6, a0, e8, m8, ta, ma
+	vle8.v v0, (a1)
+	vle8.v v8, (a2)
+	sub a0, a0, a6
+	vxor.vv v0, v0, v8
+	vle8.v v16, (a3)
+	add a2, a2, a6
+	vxor.vv v0, v0, v16
+	vle8.v v24, (a4)
+	add a3, a3, a6
+	vxor.vv v0, v0, v24
+	vle8.v v8, (a5)
+	add a4, a4, a6
+	vxor.vv v16, v0, v8
+	add a5, a5, a6
+	vse8.v v16, (a1)
+	add a1, a1, a6
+	bnez a0, xor_regs_5_
+	ret
+SYM_FUNC_END(xor_regs_5_)
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

