Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF796CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154642; cv=none; b=jYASPo6SZI5Nnz7kCYJStlf+mQ8wemxOY516jv9lFH9AIbiJpcuiglW0U3ta9rRy5csmkT6kdoO7rEVOIADW2GiqxN/3Dz9fAzOgFgEqnQz+xRgjY0n9yMFaEFrNAPCjsh2qmSB4MCrBI+mEmqh6CNj5+cFspaVz7lKtuddHwvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154642; c=relaxed/simple;
	bh=RMOcJ9r2OHurVySImbYXV30LouOHsobhRpw8hSzIeTs=;
	h=Date:To:From:Subject:Message-Id; b=Qt0PyZXLpAUNNCekzOZlgpko60Hd/9zkxVrOTfNexP329ljkbGSpxWcU3fPmtw7W2+N6x8QbBMqro0USA8LibtaJ3rlHFTvuMd9o5hSrQ4UU1wUdrgc41/iqMnkkKEu5KRJb3+6SxbePTi7fCQdSmRa+f8Q1hcNHQDzYKEdlUuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z4MYLnm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z4MYLnm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C44C32781;
	Sun, 19 May 2024 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154642;
	bh=RMOcJ9r2OHurVySImbYXV30LouOHsobhRpw8hSzIeTs=;
	h=Date:To:From:Subject:From;
	b=z4MYLnm/U4/D2tWkrizukyzhnDF+aSv802UoimzZoGDF/EFtwDDG4wn3h+fUVZfm9
	 wDr0smN5Ab/v0yBj1JLev0ySnl00DWh8FmwfYglLbzPuaMeUmNMtyMqst7JeFFGOiZ
	 eOI0VzK73n7ZUodIhjAdBN1xHHQcbrz19/krqZNE=
Date: Sun, 19 May 2024 14:37:21 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-implement-arch_has_kernel_fpu_support.patch removed from -mm tree
Message-Id: <20240519213722.24C44C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     x86-implement-arch_has_kernel_fpu_support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -85,6 +85,7 @@ config X86
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


