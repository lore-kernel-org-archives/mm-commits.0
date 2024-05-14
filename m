Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB772AF0B
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 23:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715727970; cv=none; b=bLWZeDZTFQWw+4PanN/y/ff0WAXQACc3dEm0NNuVSRWoD71bXluihg0nYDBB+bWGsfD51+PbKV16/b39ui6kzOar5GHMbgnLZlZxN/r5ez3i4CwqAa0+E66Xw89bQ1dYLiDK183of6xBgfjvIiXmhY4z79Io/y5BNJEjb+UVwLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715727970; c=relaxed/simple;
	bh=f5R3r4DYIMWOXxDYUQiGYYmPDQ5fkGP6/I8+TFDGC00=;
	h=Date:To:From:Subject:Message-Id; b=FxEQ6B+ALDhO9F907c7fTUmXd0s//TCx8p6RWCm6xzNwZIVWjQxqaWxupXd4vnhH5v6xe29bvYxdy8mFsOhzU6AbxG4XoBW4m6iokjPqlkf1Eric2x1mHrdLhXBnRuhRh56vPqxK5ovJq8sDhwHUjfUCIPKsXZo1+x19my4hVS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lLCxt4mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lLCxt4mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A84C2BD10;
	Tue, 14 May 2024 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715727969;
	bh=f5R3r4DYIMWOXxDYUQiGYYmPDQ5fkGP6/I8+TFDGC00=;
	h=Date:To:From:Subject:From;
	b=lLCxt4mGNlhScqO2noWuRJkO+otLwP6SkczXhVy4TJlfw9h99QLMAqtB+IBiIc5Zt
	 mSoROZzov7/rVpWBlgxvqof1/sG2KLDPZuGW8Enz+/i4u5oC5yPW+qQD+eCRwRzN9/
	 icFHIJkEuaC2qc2OjJ4rUmr2rC5auD4s2aYB+MH4=
Date: Tue, 14 May 2024 16:06:08 -0700
To: mm-commits@vger.kernel.org,thiago.bauermann@linaro.org,lkp@intel.com,ardb@kernel.org,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-implement-arch_has_kernel_fpu_support-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240514230609.14A84C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ARM: do not select ARCH_HAS_KERNEL_FPU_SUPPORT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm-implement-arch_has_kernel_fpu_support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-implement-arch_has_kernel_fpu_support-fix.patch

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
Subject: ARM: do not select ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Wed, 8 May 2024 18:37:10 -0700

On 32-bit ARM, conversions between `double` and `long long` require
runtime library support.  Since the kernel does not currently provide this
library support, the amdgpu driver fails to build:

  ERROR: modpost: "__aeabi_l2d" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
  ERROR: modpost: "__aeabi_d2ulz" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!

As Arnd reports, there are likely no 32-bit ARM platforms which can use
the amdgpu driver anyway, due to lack of features like 64-bit prefetchable
BARs.  Since amdgpu is currently the only real user of
ARCH_HAS_KERNEL_FPU_SUPPORT, drop support for this option instead of
bothering to implement the library functions.

Link: https://lkml.kernel.org/r/20240509013727.648600-1-samuel.holland@sifive.com
Fixes: 12624fe2d707 ("ARM: implement ARCH_HAS_KERNEL_FPU_SUPPORT")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reported-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Closes: https://lore.kernel.org/lkml/87wmp4oo3y.fsf@linaro.org/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404042327.jRpt81kP-lkp@intel.com/
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/Kconfig~arm-implement-arch_has_kernel_fpu_support-fix
+++ a/arch/arm/Kconfig
@@ -15,7 +15,6 @@ config ARM
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_KCOV
-	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
_

Patches currently in -mm which might be from samuel.holland@sifive.com are

x86-fpu-fix-asm-fpu-typesh-include-guard.patch
arch-add-arch_has_kernel_fpu_support.patch
arm-implement-arch_has_kernel_fpu_support.patch
arm-implement-arch_has_kernel_fpu_support-fix.patch
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

