Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691514F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154630; cv=none; b=mD0MFiS0vRKwPRzgkL/xpsG/Oai0O74mIQs3N/xu795PDCTIfL4eBgkxYlzbebnX+ocIKCHxNmNA7FTVaD2fVeO0nuq7i4z2KuabLgAapS/GPV2LlYHtlbyynwQRLnIEIG9kfnb3yx9r/bhkaUBPbhOdrHJFmvMqV/j0WkkJmaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154630; c=relaxed/simple;
	bh=s88JQHPhtw60VewKVXAZ2eJN4Q0qbk19dmEPNqe0cWo=;
	h=Date:To:From:Subject:Message-Id; b=RcIw7i2MIzemktSDuB/IjSlPz0Lko5kY0SvLbF5hZoYUs6MAvKvSWzhGrOZWUBQ+8PsYScQK6ERkMZdpbGxmeHC4CM+YwAtRk+9ZZ/+XvAq2bmqRBH1qP5+CWsoug17D2/3NDk04tq21oIF1qgqKk/ovSMpeZ+bejCpkCbTUpDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UerlRDYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UerlRDYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E548C32781;
	Sun, 19 May 2024 21:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154630;
	bh=s88JQHPhtw60VewKVXAZ2eJN4Q0qbk19dmEPNqe0cWo=;
	h=Date:To:From:Subject:From;
	b=UerlRDYE6CbbFe2Z7j2lJvZtVUh6LIOyiN55lurCJylHR2P/kyGgZadLkEchUDhqO
	 j2JYrazGEhj059dIaCeEdCiwHGXDt4cc6JylQRR+FusvX/O/g9rv2SgMhHvGENQOIE
	 VQZBEnJG6fqmme3xuItFyTNOJBoTDQQ0onFyi6rI=
Date: Sun, 19 May 2024 14:37:09 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thiago.bauermann@linaro.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm-implement-arch_has_kernel_fpu_support.patch removed from -mm tree
Message-Id: <20240519213710.3E548C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ARM: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     arm-implement-arch_has_kernel_fpu_support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: ARM: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Fri, 29 Mar 2024 00:18:17 -0700

ARM provides an equivalent to the common kernel-mode FPU API, but in a
different header and using different function names.  Add a wrapper
header, and export CFLAGS adjustments as found in lib/raid6/Makefile.

[samuel.holland@sifive.com: ARM: do not select ARCH_HAS_KERNEL_FPU_SUPPORT]
  Link: https://lkml.kernel.org/r/20240509013727.648600-1-samuel.holland@sifive.com
Link: https://lkml.kernel.org/r/20240329072441.591471-3-samuel.holland@sifive.com
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
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Makefile          |    7 +++++++
 arch/arm/include/asm/fpu.h |   15 +++++++++++++++
 2 files changed, 22 insertions(+)

--- /dev/null
+++ a/arch/arm/include/asm/fpu.h
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
--- a/arch/arm/Makefile~arm-implement-arch_has_kernel_fpu_support
+++ a/arch/arm/Makefile
@@ -130,6 +130,13 @@ endif
 # Accept old syntax despite ".syntax unified"
 AFLAGS_NOWARN	:=$(call as-option,-Wa$(comma)-mno-warn-deprecated,-Wa$(comma)-W)
 
+# The GCC option -ffreestanding is required in order to compile code containing
+# ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
+CC_FLAGS_FPU	:= -ffreestanding
+# Enable <arm_neon.h>
+CC_FLAGS_FPU	+= -isystem $(shell $(CC) -print-file-name=include)
+CC_FLAGS_FPU	+= -march=armv7-a -mfloat-abi=softfp -mfpu=neon
+
 ifeq ($(CONFIG_THUMB2_KERNEL),y)
 CFLAGS_ISA	:=-Wa,-mimplicit-it=always $(AFLAGS_NOWARN)
 AFLAGS_ISA	:=$(CFLAGS_ISA) -Wa$(comma)-mthumb
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


