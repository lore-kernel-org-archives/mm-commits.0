Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C050184FDA
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571415; cv=none; b=KH+WDiyWx30DztothvJVPAqltehBTTRI/asfxHBVOK1St94d3uh6zrbeRD9TSNoCCBEktRO7PnJ2b1TzC9NWCWUYSJta7SF8plgI9WUcgfuN2C5dw6s7C8lO4pWfdxQ/tGTPF3Gl1HIn+XdONQe4/5paKnBYPuJ51MIEniRbqu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571415; c=relaxed/simple;
	bh=S52IFR/U43+xJNkZIzj+Kofdtb7i8gtFXBUMgvqFoS4=;
	h=Date:To:From:Subject:Message-Id; b=KRsBnWzJ0EkzjYpvjr7/1mYDDeKnumIsW9GiV8vJ4WJtGr1jD3GN+JfTornNYqYZpTyOGEUWsXOXOOih+nfQmZe7wy3++qhfWrMIEPJ8LWb3T0a1MmMhCMXL7SX67e7GYW91im+BJcz0xAdYOlUQbgwJfcIqgBsJ/rhBSLMLFOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sqzHtTOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sqzHtTOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5033FC433C7;
	Wed, 27 Mar 2024 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711571415;
	bh=S52IFR/U43+xJNkZIzj+Kofdtb7i8gtFXBUMgvqFoS4=;
	h=Date:To:From:Subject:From;
	b=sqzHtTOAulfI58ljzH0bdNqqgYQr6x4SDzjm6+aUrwmxcf0S+BhIJtGGMpSunWh2v
	 s5BuZR1ocnRZSs6hGZYzACFupXJxm252WEibJ2N3XygBtSqryJffQvdg+Ht/lXVRUD
	 1wb4yDBqV+8lAvZSOxxby0llAtjMZ/qGK84enwkA=
Date: Wed, 27 Mar 2024 13:30:14 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-implement-arch_has_kernel_fpu_support.patch added to mm-nonmm-unstable branch
Message-Id: <20240327203015.5033FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-implement-arch_has_kernel_fpu_support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-implement-arch_has_kernel_fpu_support.patch

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
Subject: powerpc: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Wed, 27 Mar 2024 13:00:39 -0700

PowerPC provides an equivalent to the common kernel-mode FPU API, but in
a different header and using different function names. The PowerPC API
also requires a non-preemptible context. Add a wrapper header, and
export the CFLAGS adjustments.

Link: https://lkml.kernel.org/r/20240327200157.1097089-9-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <git@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig           |    1 +
 arch/powerpc/Makefile          |    5 ++++-
 arch/powerpc/include/asm/fpu.h |   28 ++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/arch/powerpc/include/asm/fpu.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 SiFive
+ */
+
+#ifndef _ASM_POWERPC_FPU_H
+#define _ASM_POWERPC_FPU_H
+
+#include <linux/preempt.h>
+
+#include <asm/cpu_has_feature.h>
+#include <asm/switch_to.h>
+
+#define kernel_fpu_available()	(!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
+
+static inline void kernel_fpu_begin(void)
+{
+	preempt_disable();
+	enable_kernel_fp();
+}
+
+static inline void kernel_fpu_end(void)
+{
+	disable_kernel_fp();
+	preempt_enable();
+}
+
+#endif /* ! _ASM_POWERPC_FPU_H */
--- a/arch/powerpc/Kconfig~powerpc-implement-arch_has_kernel_fpu_support
+++ a/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_HUGEPD			if HUGETLB_PAGE
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEMREMAP_COMPAT_ALIGN	if PPC_64S_HASH_MMU
--- a/arch/powerpc/Makefile~powerpc-implement-arch_has_kernel_fpu_support
+++ a/arch/powerpc/Makefile
@@ -153,6 +153,9 @@ CFLAGS-$(CONFIG_PPC32)	+= $(call cc-opti
 
 CFLAGS-$(CONFIG_PPC32)	+= $(call cc-option,-mno-readonly-in-sdata)
 
+CC_FLAGS_FPU		:= $(call cc-option,-mhard-float)
+CC_FLAGS_NO_FPU		:= $(call cc-option,-msoft-float)
+
 ifdef CONFIG_FUNCTION_TRACER
 ifdef CONFIG_ARCH_USING_PATCHABLE_FUNCTION_ENTRY
 KBUILD_CPPFLAGS	+= -DCC_USING_PATCHABLE_FUNCTION_ENTRY
@@ -174,7 +177,7 @@ asinstr := $(call as-instr,lis 9$(comma)
 
 KBUILD_CPPFLAGS	+= -I $(srctree)/arch/powerpc $(asinstr)
 KBUILD_AFLAGS	+= $(AFLAGS-y)
-KBUILD_CFLAGS	+= $(call cc-option,-msoft-float)
+KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU)
 KBUILD_CFLAGS	+= $(CFLAGS-y)
 CPP		= $(CC) -E $(KBUILD_CFLAGS)
 
_

Patches currently in -mm which might be from samuel.holland@sifive.com are

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

