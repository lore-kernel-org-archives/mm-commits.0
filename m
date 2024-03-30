Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F284E5231
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769465; cv=none; b=DmRmaFDNNUDqpWkC6d48ooTkWP/sEHG9SaYWJ52zrXErH28LSXd7NT+MhqCFTjfBxk/mA8YHLnXA5LE28Y8phbIHHcIfIHNcJ2YV4iBeC71LyW93tzm909WlCyH3vjVsEXTeyHMVQEHyIcjwdGriu8n/9P2F91cOapfWMG+Hzwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769465; c=relaxed/simple;
	bh=X+niIPj2R1cmza6N90IgdeVSxkeXZbRiYJwwHiixlYM=;
	h=Date:To:From:Subject:Message-Id; b=izkUPayWPb0ZEd1U/IIoD0re/ddAwxxCv5jx9/79oiuL+b9aM6VKEFPK1l1BphDcWSnKYSg8zZibUAYr+03/z7PSTVfZFwOvA5rq/uvi8rnKhqnCzGfcm5EDp8Y3dxY5D7qQgC4XOwePGBx5FJYCU02dTMPdaw6eXRNyvN35Y+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=biMv20ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="biMv20ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60FEC433C7;
	Sat, 30 Mar 2024 03:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769464;
	bh=X+niIPj2R1cmza6N90IgdeVSxkeXZbRiYJwwHiixlYM=;
	h=Date:To:From:Subject:From;
	b=biMv20exxNFwkhEL0cnTfeNW1op/s72N3vGiWFI5OAgu8AQx6qYJ2JnZCYl7TfAiB
	 LefpT7OM0KPihoYAv716ksylyNvbjtU2vCONtOFBh6bTH91gIXgBuUlSjqLjwVW6pB
	 7Yq2CtjnvQjpwhnnWTC2mAM8/ucPQSzkfonRivcI=
Date: Fri, 29 Mar 2024 20:31:04 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-add-support-for-kernel-mode-fpu.patch added to mm-nonmm-unstable branch
Message-Id: <20240330033104.C60FEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: add support for kernel-mode FPU
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-add-support-for-kernel-mode-fpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-add-support-for-kernel-mode-fpu.patch

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
Subject: riscv: add support for kernel-mode FPU
Date: Fri, 29 Mar 2024 00:18:26 -0700

This is motivated by the amdgpu DRM driver, which needs floating-point
code to support recent hardware.  That code is not performance-critical,
so only provide a minimal non-preemptible implementation for now.

Support is limited to riscv64 because riscv32 requires runtime (libgcc)
assistance to convert between doubles and 64-bit integers.

Link: https://lkml.kernel.org/r/20240329072441.591471-12-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
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
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <git@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig                  |    1 
 arch/riscv/Makefile                 |    3 ++
 arch/riscv/include/asm/fpu.h        |   16 ++++++++++++++
 arch/riscv/kernel/Makefile          |    1 
 arch/riscv/kernel/kernel_mode_fpu.c |   28 ++++++++++++++++++++++++++
 5 files changed, 49 insertions(+)

--- /dev/null
+++ a/arch/riscv/include/asm/fpu.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 SiFive
+ */
+
+#ifndef _ASM_RISCV_FPU_H
+#define _ASM_RISCV_FPU_H
+
+#include <asm/switch_to.h>
+
+#define kernel_fpu_available()	has_fpu()
+
+void kernel_fpu_begin(void);
+void kernel_fpu_end(void);
+
+#endif /* ! _ASM_RISCV_FPU_H */
--- a/arch/riscv/Kconfig~riscv-add-support-for-kernel-mode-fpu
+++ a/arch/riscv/Kconfig
@@ -27,6 +27,7 @@ config RISCV
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_KERNEL_FPU_SUPPORT if 64BIT && FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MMIOWB
--- /dev/null
+++ a/arch/riscv/kernel/kernel_mode_fpu.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 SiFive
+ */
+
+#include <linux/export.h>
+#include <linux/preempt.h>
+
+#include <asm/csr.h>
+#include <asm/fpu.h>
+#include <asm/processor.h>
+#include <asm/switch_to.h>
+
+void kernel_fpu_begin(void)
+{
+	preempt_disable();
+	fstate_save(current, task_pt_regs(current));
+	csr_set(CSR_SSTATUS, SR_FS);
+}
+EXPORT_SYMBOL_GPL(kernel_fpu_begin);
+
+void kernel_fpu_end(void)
+{
+	csr_clear(CSR_SSTATUS, SR_FS);
+	fstate_restore(current, task_pt_regs(current));
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(kernel_fpu_end);
--- a/arch/riscv/kernel/Makefile~riscv-add-support-for-kernel-mode-fpu
+++ a/arch/riscv/kernel/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_RISCV_MISALIGNED)	+= unalig
 obj-$(CONFIG_RISCV_PROBE_UNALIGNED_ACCESS)	+= copy-unaligned.o
 
 obj-$(CONFIG_FPU)		+= fpu.o
+obj-$(CONFIG_FPU)		+= kernel_mode_fpu.o
 obj-$(CONFIG_RISCV_ISA_V)	+= vector.o
 obj-$(CONFIG_RISCV_ISA_V)	+= kernel_mode_vector.o
 obj-$(CONFIG_SMP)		+= smpboot.o
--- a/arch/riscv/Makefile~riscv-add-support-for-kernel-mode-fpu
+++ a/arch/riscv/Makefile
@@ -84,6 +84,9 @@ KBUILD_CFLAGS += -march=$(shell echo $(r
 
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
+# For C code built with floating-point support, exclude V but keep F and D.
+CC_FLAGS_FPU  := -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)([^v_]*)v?/\1\2/')
+
 KBUILD_CFLAGS += -mno-save-restore
 KBUILD_CFLAGS += -DCONFIG_PAGE_OFFSET=$(CONFIG_PAGE_OFFSET)
 
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

