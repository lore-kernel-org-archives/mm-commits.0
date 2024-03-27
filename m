Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB8D2FE0F
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571423; cv=none; b=mY2UL03vdq1eEilvqkC5s/RiVx+PFO1BaX2khnFA9GuFncMwNRLsQ02xh1M/M7A6waCPsYmNgabgJe24ENiRerp3Xh7YAYmRIL3Suhjgx6SoL8JnS69xyImxERU2LNzI/Lxjyr2z17aDEEEPmtJrMuOcn6/dTLHohBZG3/pHIQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571423; c=relaxed/simple;
	bh=jQkpE3I1FeibA10bsKSkFhlPDeLDB0sN0ic8H7ikHEM=;
	h=Date:To:From:Subject:Message-Id; b=CF6jHr2sexiinJml0fSRDsyfg9MypaUvzDPHQXNl2OtJN9+7vMF1/VoCRRakYJkAqrlAaRA26rKAYdvYuUS7glWcJday7lfTFU043/t2/eD8GqaObc3YoooXi05TLysG8kc1X+zVFE9JhhbIJcGIXF+wBkQjDMn7GlTrjdLX4YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TSbjEL6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TSbjEL6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5D5C433C7;
	Wed, 27 Mar 2024 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711571423;
	bh=jQkpE3I1FeibA10bsKSkFhlPDeLDB0sN0ic8H7ikHEM=;
	h=Date:To:From:Subject:From;
	b=TSbjEL6SIbCKOrU39QKDdmOt59a+mEJHQNYKb3xLqoQHxYHFZzyYf0Qcg/WsTcfLi
	 ZCajwlMv2Q94YHr1TdaYwkk4Y3YahD/s+CCNzgFwBcOn4Eb2it7Hl2lMS4YOSMvspN
	 jcfjOMdAF48AzCyj9LX83MsIBIjikFqUm3szE+1E=
Date: Wed, 27 Mar 2024 13:30:22 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,samuel.holland@sifive.com,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch added to mm-nonmm-unstable branch
Message-Id: <20240327203022.EE5D5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/amd/display: only use hard-float, not altivec on powerpc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch

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
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: drm/amd/display: only use hard-float, not altivec on powerpc
Date: Wed, 27 Mar 2024 13:00:42 -0700

The compiler flags enable altivec, but that is not required; hard-float
is sufficient for the code to build and function.

Drop altivec from the compiler flags and adjust the enable/disable code
to only enable FPU use.

Link: https://lkml.kernel.org/r/20240327200157.1097089-12-samuel.holland@sifive.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
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

 drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c |   12 ++----------
 drivers/gpu/drm/amd/display/dc/dml/Makefile    |    2 +-
 drivers/gpu/drm/amd/display/dc/dml2/Makefile   |    2 +-
 3 files changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c~drm-amd-display-only-use-hard-float-not-altivec-on-powerpc
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c
@@ -92,11 +92,7 @@ void dc_fpu_begin(const char *function_n
 #if defined(CONFIG_X86) || defined(CONFIG_LOONGARCH)
 		kernel_fpu_begin();
 #elif defined(CONFIG_PPC64)
-		if (cpu_has_feature(CPU_FTR_VSX_COMP))
-			enable_kernel_vsx();
-		else if (cpu_has_feature(CPU_FTR_ALTIVEC_COMP))
-			enable_kernel_altivec();
-		else if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
+		if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
 			enable_kernel_fp();
 #elif defined(CONFIG_ARM64)
 		kernel_neon_begin();
@@ -125,11 +121,7 @@ void dc_fpu_end(const char *function_nam
 #if defined(CONFIG_X86) || defined(CONFIG_LOONGARCH)
 		kernel_fpu_end();
 #elif defined(CONFIG_PPC64)
-		if (cpu_has_feature(CPU_FTR_VSX_COMP))
-			disable_kernel_vsx();
-		else if (cpu_has_feature(CPU_FTR_ALTIVEC_COMP))
-			disable_kernel_altivec();
-		else if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
+		if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE))
 			disable_kernel_fp();
 #elif defined(CONFIG_ARM64)
 		kernel_neon_end();
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile~drm-amd-display-only-use-hard-float-not-altivec-on-powerpc
+++ a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -30,7 +30,7 @@ dml2_ccflags := $(dml2_ccflags-y) -msse
 endif
 
 ifdef CONFIG_PPC64
-dml2_ccflags := -mhard-float -maltivec
+dml2_ccflags := -mhard-float
 endif
 
 ifdef CONFIG_ARM64
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile~drm-amd-display-only-use-hard-float-not-altivec-on-powerpc
+++ a/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -31,7 +31,7 @@ dml_ccflags := $(dml_ccflags-y) -msse
 endif
 
 ifdef CONFIG_PPC64
-dml_ccflags := -mhard-float -maltivec
+dml_ccflags := -mhard-float
 endif
 
 ifdef CONFIG_ARM64
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch

