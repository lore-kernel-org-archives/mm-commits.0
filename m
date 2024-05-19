Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E78F6CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154647; cv=none; b=kwgDFXfQQDFzs3fLbYC9wvCravNgv6k925YnmECnGeami5W6XxzC+967oqo/6w//yZUr8MvTzQ4e/Mo3qbODwXosC9VLW4wGTvdGiJbn7d/sjpKFkq39kkBUSpR9nzbHPLGC0Zh1aNqp24eETwC25Y3jUodJk8lqtjE3TK/V+C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154647; c=relaxed/simple;
	bh=d9ZYUDy8tc/YMZlFw4ESU3g6xeGJu6439CvqnjcJMD8=;
	h=Date:To:From:Subject:Message-Id; b=rKHeeclE4gJsak1B9U60P8u5p/vW9aBBJ/caPDy6qCkD2h6Tmhd6bYe5A6gMdQylBdsoaWYNVZox00RLvKwOyi9a+vbksK1yAllPmz5FaVUrWd9JZNMJ19/MsHVF4hT/GvkkYGGX85cGLShDOltt3UpZuIaVnEMWLA0KGYZFRLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y8cvQx7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y8cvQx7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4D6C32781;
	Sun, 19 May 2024 21:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154646;
	bh=d9ZYUDy8tc/YMZlFw4ESU3g6xeGJu6439CvqnjcJMD8=;
	h=Date:To:From:Subject:From;
	b=Y8cvQx7FyQUBqKkscfEmC7tBcH36a9LmlvRUH5Vm7gZXDBvP4pLXiLkUL7ptCi10F
	 5Gh0wPR0/OSuaIBhygkj7Pfl3/wXIFnygjSr1LxOJkLzbmlKMLE6XWXGnL4EpIF+1X
	 zPWGFMywa3PdVZfa8TvIMI/MczY+XLnQg4CSKBAw=
Date: Sun, 19 May 2024 14:37:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-amd-display-use-arch_has_kernel_fpu_support.patch removed from -mm tree
Message-Id: <20240519213726.CE4D6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/amd/display: use ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     drm-amd-display-use-arch_has_kernel_fpu_support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: drm/amd/display: use ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Fri, 29 Mar 2024 00:18:28 -0700

Now that all previously-supported architectures select
ARCH_HAS_KERNEL_FPU_SUPPORT, this code can depend on that symbol instead
of the existing list of architectures.  It can also take advantage of the
common kernel-mode FPU API and method of adjusting CFLAGS.

Link: https://lkml.kernel.org/r/20240329072441.591471-14-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian König <christian.koenig@amd.com> 
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

 drivers/gpu/drm/amd/display/Kconfig            |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c |   27 -----------
 drivers/gpu/drm/amd/display/dc/dml/Makefile    |   36 ---------------
 drivers/gpu/drm/amd/display/dc/dml2/Makefile   |   36 ---------------
 4 files changed, 7 insertions(+), 94 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c~drm-amd-display-use-arch_has_kernel_fpu_support
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c
@@ -26,16 +26,7 @@
 
 #include "dc_trace.h"
 
-#if defined(CONFIG_X86)
-#include <asm/fpu/api.h>
-#elif defined(CONFIG_PPC64)
-#include <asm/switch_to.h>
-#include <asm/cputable.h>
-#elif defined(CONFIG_ARM64)
-#include <asm/neon.h>
-#elif defined(CONFIG_LOONGARCH)
-#include <asm/fpu.h>
-#endif
+#include <linux/fpu.h>
 
 /**
  * DOC: DC FPU manipulation overview
@@ -87,16 +78,9 @@ void dc_fpu_begin(const char *function_n
 	WARN_ON_ONCE(!in_task());
 	preempt_disable();
 	depth = __this_cpu_inc_return(fpu_recursion_depth);
-
 	if (depth == 1) {
-#if defined(CONFIG_X86) || defined(CONFIG_LOONGARCH)
+		BUG_ON(!kernel_fpu_available());
 		kernel_fpu_begin();
-#elif defined(CONFIG_PPC64)
-		if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
-			enable_kernel_fp();
-#elif defined(CONFIG_ARM64)
-		kernel_neon_begin();
-#endif
 	}
 
 	TRACE_DCN_FPU(true, function_name, line, depth);
@@ -118,14 +102,7 @@ void dc_fpu_end(const char *function_nam
 
 	depth = __this_cpu_dec_return(fpu_recursion_depth);
 	if (depth == 0) {
-#if defined(CONFIG_X86) || defined(CONFIG_LOONGARCH)
 		kernel_fpu_end();
-#elif defined(CONFIG_PPC64)
-		if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
-			disable_kernel_fp();
-#elif defined(CONFIG_ARM64)
-		kernel_neon_end();
-#endif
 	} else {
 		WARN_ON_ONCE(depth < 0);
 	}
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile~drm-amd-display-use-arch_has_kernel_fpu_support
+++ a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -24,40 +24,8 @@
 #
 # Makefile for dml2.
 
-ifdef CONFIG_X86
-dml2_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
-dml2_ccflags := $(dml2_ccflags-y) -msse
-endif
-
-ifdef CONFIG_PPC64
-dml2_ccflags := -mhard-float
-endif
-
-ifdef CONFIG_ARM64
-dml2_rcflags := -mgeneral-regs-only
-endif
-
-ifdef CONFIG_LOONGARCH
-dml2_ccflags := -mfpu=64
-dml2_rcflags := -msoft-float
-endif
-
-ifdef CONFIG_CC_IS_GCC
-ifeq ($(call cc-ifversion, -lt, 0701, y), y)
-IS_OLD_GCC = 1
-endif
-endif
-
-ifdef CONFIG_X86
-ifdef IS_OLD_GCC
-# Stack alignment mismatch, proceed with caution.
-# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
-# (8B stack alignment).
-dml2_ccflags += -mpreferred-stack-boundary=4
-else
-dml2_ccflags += -msse2
-endif
-endif
+dml2_ccflags := $(CC_FLAGS_FPU)
+dml2_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile~drm-amd-display-use-arch_has_kernel_fpu_support
+++ a/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -25,40 +25,8 @@
 # It provides the general basic services required by other DAL
 # subcomponents.
 
-ifdef CONFIG_X86
-dml_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
-dml_ccflags := $(dml_ccflags-y) -msse
-endif
-
-ifdef CONFIG_PPC64
-dml_ccflags := -mhard-float
-endif
-
-ifdef CONFIG_ARM64
-dml_rcflags := -mgeneral-regs-only
-endif
-
-ifdef CONFIG_LOONGARCH
-dml_ccflags := -mfpu=64
-dml_rcflags := -msoft-float
-endif
-
-ifdef CONFIG_CC_IS_GCC
-ifneq ($(call gcc-min-version, 70100),y)
-IS_OLD_GCC = 1
-endif
-endif
-
-ifdef CONFIG_X86
-ifdef IS_OLD_GCC
-# Stack alignment mismatch, proceed with caution.
-# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
-# (8B stack alignment).
-dml_ccflags += -mpreferred-stack-boundary=4
-else
-dml_ccflags += -msse2
-endif
-endif
+dml_ccflags := $(CC_FLAGS_FPU)
+dml_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
--- a/drivers/gpu/drm/amd/display/Kconfig~drm-amd-display-use-arch_has_kernel_fpu_support
+++ a/drivers/gpu/drm/amd/display/Kconfig
@@ -8,7 +8,7 @@ config DRM_AMD_DC
 	depends on BROKEN || !CC_IS_CLANG || ARM64 || RISCV || SPARC64 || X86_64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	# !CC_IS_CLANG: https://github.com/ClangBuiltLinux/linux/issues/1752
-	select DRM_AMD_DC_FP if (X86 || LOONGARCH || (PPC64 && ALTIVEC) || (ARM64 && KERNEL_MODE_NEON && !CC_IS_CLANG))
+	select DRM_AMD_DC_FP if ARCH_HAS_KERNEL_FPU_SUPPORT && (!ARM64 || !CC_IS_CLANG)
 	help
 	  Choose this option if you want to use the new display engine
 	  support for AMDGPU. This adds required support for Vega and
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


