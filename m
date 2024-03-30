Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC3C566A
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769461; cv=none; b=gv7mcppCy+q29ZD/BGI6wsd2lAtLIfZ2oIeo+sKuxeLKLJW4LGhDVqUju8FvhNTRg8hqdeR3PUMvx+SV3ZurD2V38ix0TNdqc8lJilnIhKuezZjcy2mubP+RVp4OH7rW1CfXABPxPv38+84z5GK+oHl4ry8/53r7yFSg+b04jkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769461; c=relaxed/simple;
	bh=QAP1PVcw+WqXbvg+WF9YqruUyqCjlfaNJomFn29YxTM=;
	h=Date:To:From:Subject:Message-Id; b=pSWleB55dT3ditdrO849TfpgN2Uubcffg1ZWw7d8HYryuQy64ZceUsTI0sBjkfXnTgMfsQbQMV3I1Il+d/nKkY2BaZM5fRG6lOc9V8wjNnzsdi6/mxcRxLeqxtfd0+Z9PnOe/mcIzxgvCXABjA9gtuPfEvr759CzOgA+HggwCng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TezpB6/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TezpB6/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A143CC433F1;
	Sat, 30 Mar 2024 03:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769461;
	bh=QAP1PVcw+WqXbvg+WF9YqruUyqCjlfaNJomFn29YxTM=;
	h=Date:To:From:Subject:From;
	b=TezpB6/MEtcou28XqoR9TOgd4w1LmNEJQF2+ulLG03gSM3nyGtnsirUzWRaK5++Ar
	 +D3bAOpoWxn1Bs0V6SaJN19OmUbn/8C2UzyJxrVD7sUh7p2MGA4+a5HkpFlcOxU8Y1
	 nI/Wq6KlR22x2+/Yv0zMtOArvC0QB+rgUvZtcGdI=
Date: Fri, 29 Mar 2024 20:31:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-implement-arch_has_kernel_fpu_support.patch added to mm-nonmm-unstable branch
Message-Id: <20240330033101.A143CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-implement-arch_has_kernel_fpu_support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-implement-arch_has_kernel_fpu_support.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: x86: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Fri, 29 Mar 2024 00:18:25 -0700

x86 already provides kernel_fpu_begin() and kernel_fpu_end(), but in a
different header.  Add a wrapper header, and export the CFLAGS adjustments
as found in lib/Makefile.

Link: https://lkml.kernel.org/r/20240329072441.591471-11-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

 arch/x86/Kconfig           |    1 +
 arch/x86/Makefile          |   20 ++++++++++++++++++++
 arch/x86/include/asm/fpu.h |   13 +++++++++++++
 3 files changed, 34 insertions(+)

--- /dev/null
+++ a/arch/x86/include/asm/fpu.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 SiFive
+ */
+
+#ifndef _ASM_X86_FPU_H
+#define _ASM_X86_FPU_H
+
+#include <asm/fpu/api.h>
+
+#define kernel_fpu_available()	true
+
+#endif /* ! _ASM_X86_FPU_H */
--- a/arch/x86/Kconfig~x86-implement-arch_has_kernel_fpu_support
+++ a/arch/x86/Kconfig
@@ -83,6 +83,7 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
+	select ARCH_HAS_KERNEL_FPU_SUPPORT
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
--- a/arch/x86/Makefile~x86-implement-arch_has_kernel_fpu_support
+++ a/arch/x86/Makefile
@@ -74,6 +74,26 @@ KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-
 KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
 KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
 
+#
+# CFLAGS for compiling floating point code inside the kernel.
+#
+CC_FLAGS_FPU := -msse -msse2
+ifdef CONFIG_CC_IS_GCC
+# Stack alignment mismatch, proceed with caution.
+# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
+# (8B stack alignment).
+# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383
+#
+# The "-msse" in the first argument is there so that the
+# -mpreferred-stack-boundary=3 build error:
+#
+#  -mpreferred-stack-boundary=3 is not between 4 and 12
+#
+# can be triggered. Otherwise gcc doesn't complain.
+CC_FLAGS_FPU += -mhard-float
+CC_FLAGS_FPU += $(call cc-option,-msse -mpreferred-stack-boundary=3,-mpreferred-stack-boundary=4)
+endif
+
 ifeq ($(CONFIG_X86_KERNEL_IBT),y)
 #
 # Kernel IBT has S_CET.NOTRACK_EN=0, as such the compilers must not generate
_

Patches currently in -mm which might be from samuel.holland@sifive.com are

x86-fpu-fix-asm-fpu-typesh-include-guard.patch
arch-add-arch_has_kernel_fpu_support.patch
arm-implement-arch_has_kernel_fpu_support.patch
arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch
arm64-implement-arch_has_kernel_fpu_support.patch
arm64-crypto-use-cc_flags_fpu-for-neon-cflags.patch
lib-raid6-use-cc_flags_fpu-for-neon-cflags.patch
loongarch-implement-arch_has_kernel_fpu_support.patch
powerpc-implement-arch_has_kernel_fpu_support.patch
x86-implement-arch_has_kernel_fpu_support.patch
riscv-add-support-for-kernel-mode-fpu.patch
drm-amd-display-use-arch_has_kernel_fpu_support.patch
selftests-fpu-move-fp-code-to-a-separate-translation-unit.patch
selftests-fpu-allow-building-on-other-architectures.patch

