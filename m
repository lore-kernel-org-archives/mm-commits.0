Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB323BB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154457; cv=none; b=RbkDFrxx+V8racTnP+KEXxjFHOfEzK3hlCE4ww47enCCkhOGH3Y+giJOOmF1zfqCByiXtF1D1v/xjpM1PCDpD2S0M112GJtZVeNYCvbSIjpw3dUDGhKSzncOB/YAHhv6ElxxYgWmlNkGLjUexe9oPD65ou9fNZXW0adU+OffjeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154457; c=relaxed/simple;
	bh=pxGBvU0TKcbZcX6KZdmgSD0buqVtruNug7QQQzSitkk=;
	h=Date:To:From:Subject:Message-Id; b=WkBOqhbB3pcCPmzhScluj0bjf1cpJj6Bxz7VVNlfzFYvRnZ/Reev+s7PPfPVbn23nUmNbBh8MzFanzr7uYHUrkQ7fww2WIEwReTnxcYuBe6UO4p3BIsDKmpbOZQSuV7eWL4iNXykXY6sZdnCX1783Wf9qMa+OvSRCRRY8g8VOgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1iJ6SmB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1iJ6SmB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC5AC32781;
	Sun, 19 May 2024 21:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154456;
	bh=pxGBvU0TKcbZcX6KZdmgSD0buqVtruNug7QQQzSitkk=;
	h=Date:To:From:Subject:From;
	b=1iJ6SmB5lqBcIxvSqnIVg4VYdgDqJJ0mfsBq20LlO2PFkXAIV8RjMOyKUA64ve56x
	 UWcyb2E4HUFS8+r+zv/b+YXlsJ0dQ5MwShiQAu4Tzg5P41qwh2BbXC3GRrEJP3dYJm
	 aNehhOyKbTcU18L8wpzhgiheEPZzn03uOEXjcxDM=
Date: Sun, 19 May 2024 14:34:16 -0700
To: mm-commits@vger.kernel.org,thiago.bauermann@linaro.org,lkp@intel.com,ardb@kernel.org,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm-implement-arch_has_kernel_fpu_support-fix.patch removed from -mm tree
Message-Id: <20240519213416.9EC5AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ARM: do not select ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     arm-implement-arch_has_kernel_fpu_support-fix.patch

This patch was dropped because it was folded into arm-implement-arch_has_kernel_fpu_support.patch

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

