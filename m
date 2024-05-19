Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766EF6CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154640; cv=none; b=G2JnvXtI03c5l/By8aKTDNmnEPuzBTX7NbKOW7cP9D2jvgX/i7i1YZCxup0mOj5/zvzrMXqlgjfumXya58C/cJVkqoQVjx1osWx2rUovVBLFQ+hJ0ACyaj6cSh+RaAJaP3ABYpYa9xm5AUYm0JyofPUMcj8L8DKaoONZA1P+VLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154640; c=relaxed/simple;
	bh=xCDEK5JWQTkj4n+K20jKeYKh+yDROYBV8hnDCQ36x2s=;
	h=Date:To:From:Subject:Message-Id; b=IpWbZwFll0X7friu5WnNfqSzDx/3D1E73cdOPEJjeqS7CPb0Z867E/StrEtioV9zUlxUg4uY9c6U544ajIRGjPgXzYXbBtqBDDUk6CUihuu+gIZj42h2rGvwCQyzT8umcQzKrG8+bn4STlSkgd5QHqVUP4Rm+Iy+HbfkwRRKV9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jtKL/TWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jtKL/TWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B222C32781;
	Sun, 19 May 2024 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154640;
	bh=xCDEK5JWQTkj4n+K20jKeYKh+yDROYBV8hnDCQ36x2s=;
	h=Date:To:From:Subject:From;
	b=jtKL/TWFqvApmHcVPqXOmeTx6lOCN2CT/2O+v1hO5sEAtPZC4Wq/mT48SwqlRgNrq
	 M08ipPBkAIL01DjlioORk6hDzAFKqju+naNuv9vhvjy1ZbmGycZZ5031PJd61iDRaT
	 5NlTBxQusUpLW9TL72omPh0xnUlk+KzxyGZk8mkI=
Date: Sun, 19 May 2024 14:37:19 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-implement-arch_has_kernel_fpu_support.patch removed from -mm tree
Message-Id: <20240519213720.4B222C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     powerpc-implement-arch_has_kernel_fpu_support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: powerpc: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Fri, 29 Mar 2024 00:18:23 -0700

PowerPC provides an equivalent to the common kernel-mode FPU API, but in a
different header and using different function names.  The PowerPC API also
requires a non-preemptible context.  Add a wrapper header, and export the
CFLAGS adjustments.

Link: https://lkml.kernel.org/r/20240329072441.591471-9-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
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
@@ -149,6 +149,9 @@ CFLAGS-$(CONFIG_PPC32)	+= $(call cc-opti
 
 CFLAGS-$(CONFIG_PPC32)	+= $(call cc-option,-mno-readonly-in-sdata)
 
+CC_FLAGS_FPU		:= $(call cc-option,-mhard-float)
+CC_FLAGS_NO_FPU		:= $(call cc-option,-msoft-float)
+
 ifdef CONFIG_FUNCTION_TRACER
 ifdef CONFIG_ARCH_USING_PATCHABLE_FUNCTION_ENTRY
 KBUILD_CPPFLAGS	+= -DCC_USING_PATCHABLE_FUNCTION_ENTRY
@@ -170,7 +173,7 @@ asinstr := $(call as-instr,lis 9$(comma)
 
 KBUILD_CPPFLAGS	+= -I $(srctree)/arch/powerpc $(asinstr)
 KBUILD_AFLAGS	+= $(AFLAGS-y)
-KBUILD_CFLAGS	+= $(call cc-option,-msoft-float)
+KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU)
 KBUILD_CFLAGS	+= $(CFLAGS-y)
 CPP		= $(CC) -E $(KBUILD_CFLAGS)
 
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


