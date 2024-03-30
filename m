Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445F94687
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769438; cv=none; b=D3VW9gkoDQJkYJY0wzkiQcziW0xHWLuWoj/Kmu4B9xuSIsDQi0tKG2txUSoNEwiEldd9BduwmIedK0mLh1rn488l8UA5/gVTK7BsTHYOKKBEj6niVhIATyGoFd1pUSiIuY+HZ75tuNgTbT5QC9tplfZSMtrELGJxnZXqmcEsHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769438; c=relaxed/simple;
	bh=3I60s6M/9HBseZ2L+kKpa7V3UZA82J4oGkaTgulSF8I=;
	h=Date:To:From:Subject:Message-Id; b=Br/sF7/ed1KuTOWtuzagju9aXHZVn0Et4Np8U3wbXLrL3+hgWP/im5gaXrXBUw6c7rGll4l+k2KKVWOhg9NQUz3QrhinT96gEyqBV7k4pL0CAhAqBruP1YJa0f1+w+03IQ34Pt9LdoAwaov006Xylsz3zmXZmABf5Zoko62D4A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CziWIgco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CziWIgco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E98DC433C7;
	Sat, 30 Mar 2024 03:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769437;
	bh=3I60s6M/9HBseZ2L+kKpa7V3UZA82J4oGkaTgulSF8I=;
	h=Date:To:From:Subject:From;
	b=CziWIgcoowzB00wGb3gjlelaffKI4nph2ZGISjIhuWS0nP5IJf539uf9WoLgWfB7+
	 PXgdP8bfcD3ePG8Bt2IQVLvhBLMAhvw/rndbJsfWtgfoGn81LIeQ84iyJmD/k7DE8e
	 sb0BYNKVJ8OmmZ9pj3KIGuvpX7zSf1khve8efVIs=
Date: Fri, 29 Mar 2024 20:30:37 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-fpu-fix-asm-fpu-typesh-include-guard.patch added to mm-nonmm-unstable branch
Message-Id: <20240330033037.9E98DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/fpu: fix asm/fpu/types.h include guard
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-fpu-fix-asm-fpu-typesh-include-guard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-fpu-fix-asm-fpu-typesh-include-guard.patch

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
Subject: x86/fpu: fix asm/fpu/types.h include guard
Date: Fri, 29 Mar 2024 00:18:24 -0700

Patch series "Unified cross-architecture kernel-mode FPU API", v4.

This series unifies the kernel-mode FPU API across several architectures
by wrapping the existing functions (where needed) in consistently-named
functions placed in a consistent header location, with mostly the same
semantics: they can be called from preemptible or non-preemptible task
context, and are not assumed to be reentrant.  Architectures are also
expected to provide CFLAGS adjustments for compiling FPU-dependent code. 
For the moment, SIMD/vector units are out of scope for this common API.

This allows us to remove the ifdeffery and duplicated Makefile logic at
each FPU user.  It then implements the common API on RISC-V, and converts
a couple of users to the new API: the AMDGPU DRM driver, and the FPU self
test.

The underlying goal of this series is to allow using newer AMD GPUs (e.g. 
Navi) on RISC-V boards such as SiFive's HiFive Unmatched.  Those GPUs need
CONFIG_DRM_AMD_DC_FP to initialize, which requires kernel-mode FPU
support.


This patch (of 15):

The include guard should match the filename, or it will conflict with
the newly-added asm/fpu.h.

Link: https://lkml.kernel.org/r/20240329072441.591471-1-samuel.holland@sifive.com
Link: https://lkml.kernel.org/r/20240329072441.591471-10-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: WANG Xuerui <git@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fpu/types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/fpu/types.h~x86-fpu-fix-asm-fpu-typesh-include-guard
+++ a/arch/x86/include/asm/fpu/types.h
@@ -2,8 +2,8 @@
 /*
  * FPU data structures:
  */
-#ifndef _ASM_X86_FPU_H
-#define _ASM_X86_FPU_H
+#ifndef _ASM_X86_FPU_TYPES_H
+#define _ASM_X86_FPU_TYPES_H
 
 #include <asm/page_types.h>
 
@@ -596,4 +596,4 @@ struct fpu_state_config {
 /* FPU state configuration information */
 extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
 
-#endif /* _ASM_X86_FPU_H */
+#endif /* _ASM_X86_FPU_TYPES_H */
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

