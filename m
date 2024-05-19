Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DE925761
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154635; cv=none; b=l90H3QHtZHahqmpbynISLNoimbO2lnzf4oTey+eJj8fjCTnzkIZNoMcIPJqRT1+lLaluMWYVy4cllwWXvsRANo5lNvyj44g8cPXnO/es7c3nKzLK9/AR8RARUlWO3mtKCTfQIMeOzVXz5YRnnkB829WYVLeGEeAgAKSyItsJrRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154635; c=relaxed/simple;
	bh=4aoUut5DL4R7RoIeV6GrvyWMLAlUmDD5YQUcXpiJ4tQ=;
	h=Date:To:From:Subject:Message-Id; b=PETcOiGyJi+l4g8nbph+k76uGdKfZuSiifB/EAEtVE8BGJZFRsr1g7v5/VDhfUqJvDZV4wi84CUsNck1Xptiu08k+I72yDgIQX0SPJjmW7/Qe8COLo6rx2a8xVPJZcxHB/M4xp3hvkHhVQq1vIBuR4ewKIJdIAnwrHVorLFxvDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2pd6PeZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2pd6PeZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEDEC32781;
	Sun, 19 May 2024 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154634;
	bh=4aoUut5DL4R7RoIeV6GrvyWMLAlUmDD5YQUcXpiJ4tQ=;
	h=Date:To:From:Subject:From;
	b=2pd6PeZH9E4cxOgmdo9+1acij4AaPksuuyZVyOzMSrywyRjhX3x2h1zn1Fgo4QHOP
	 IfjPyvT5eQhnhN12EN5ELaJlzcSJrzUO0la89MtR6P/ilXb99IqnostsNqbtOiM1Pw
	 TGfjb24E8O8Jd5iBJU0Eyls8yRZDMdrQVn+savxQ=
Date: Sun, 19 May 2024 14:37:13 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64-implement-arch_has_kernel_fpu_support.patch removed from -mm tree
Message-Id: <20240519213714.4CEDEC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     arm64-implement-arch_has_kernel_fpu_support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: arm64: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Fri, 29 Mar 2024 00:18:19 -0700

arm64 provides an equivalent to the common kernel-mode FPU API, but in a
different header and using different function names.  Add a wrapper
header, and export CFLAGS adjustments as found in lib/raid6/Makefile.

Link: https://lkml.kernel.org/r/20240329072441.591471-5-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian König <christian.koenig@amd.com> 
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <git@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig           |    1 +
 arch/arm64/Makefile          |    9 ++++++++-
 arch/arm64/include/asm/fpu.h |   15 +++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/arch/arm64/include/asm/fpu.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 SiFive
+ */
+
+#ifndef __ASM_FPU_H
+#define __ASM_FPU_H
+
+#include <asm/neon.h>
+
+#define kernel_fpu_available()	cpu_has_neon()
+#define kernel_fpu_begin()	kernel_neon_begin()
+#define kernel_fpu_end()	kernel_neon_end()
+
+#endif /* ! __ASM_FPU_H */
--- a/arch/arm64/Kconfig~arm64-implement-arch_has_kernel_fpu_support
+++ a/arch/arm64/Kconfig
@@ -30,6 +30,7 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
--- a/arch/arm64/Makefile~arm64-implement-arch_has_kernel_fpu_support
+++ a/arch/arm64/Makefile
@@ -36,7 +36,14 @@ ifeq ($(CONFIG_BROKEN_GAS_INST),y)
 $(warning Detected assembler with broken .inst; disassembly will be unreliable)
 endif
 
-KBUILD_CFLAGS	+= -mgeneral-regs-only	\
+# The GCC option -ffreestanding is required in order to compile code containing
+# ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
+CC_FLAGS_FPU	:= -ffreestanding
+# Enable <arm_neon.h>
+CC_FLAGS_FPU	+= -isystem $(shell $(CC) -print-file-name=include)
+CC_FLAGS_NO_FPU	:= -mgeneral-regs-only
+
+KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU) \
 		   $(compat_vdso) $(cc_has_k_constraint)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(compat_vdso)
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


