Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F56CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154645; cv=none; b=qLWiWiDRFiwoYybfFGIREOiBMF4i0W0XNjPXCOmoeQGu9mucbIgCqJQedGQABzoqCLSPt3kvGb8i9rjjXef96Zb3DI9CTYn8OWWqBoehuIV0SpCWbjUaQy+mEy1vnoWfVsPTnbLOa1my7HoB/bwxplxCB0jG+eIYpU7rMtM44yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154645; c=relaxed/simple;
	bh=QEceMBjpFXiecRirgl0dIJbVirzg+iLUEvAPx5qsWuI=;
	h=Date:To:From:Subject:Message-Id; b=ZquJzbbq47vYxrceTPOxZpbTyA10RpBc7dtUiZ17F2dRq2589tRga4PNriboHKIso95sQYmuin+21UB6cyZM/fskOMjr97gNtgSGYhigScnE/JS725NfHDQwbLM7169hlWYjLtwqoop/wXuhr4939mJ2PCOcd82LO6Xx350tgjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zQRgTvVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zQRgTvVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F977C32781;
	Sun, 19 May 2024 21:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154645;
	bh=QEceMBjpFXiecRirgl0dIJbVirzg+iLUEvAPx5qsWuI=;
	h=Date:To:From:Subject:From;
	b=zQRgTvVnAcFu8+AyidJTpa8lcUHaZXf6eZeZwtopcrvcbwBsErCCZtl48jDQNyUJf
	 0hOgvV/RSSLTfGPjsdjfgBTydd4dh/hnCx2mLoAsfqmQnlQYSOr6M0uO6lzNG4i16d
	 h5o9NOYi/9dbkjkKC6AHl/ncDI7KK1fozlIgnlUo=
Date: Sun, 19 May 2024 14:37:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,samuel.holland@sifive.com,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch removed from -mm tree
Message-Id: <20240519213725.6F977C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/amd/display: only use hard-float, not altivec on powerpc
has been removed from the -mm tree.  Its filename was
     drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: drm/amd/display: only use hard-float, not altivec on powerpc
Date: Fri, 29 Mar 2024 00:18:27 -0700

The compiler flags enable altivec, but that is not required; hard-float is
sufficient for the code to build and function.

Drop altivec from the compiler flags and adjust the enable/disable code to
only enable FPU use.

Link: https://lkml.kernel.org/r/20240329072441.591471-13-samuel.holland@sifive.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Christian König <christian.koenig@amd.com> 
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


