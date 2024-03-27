Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C814D2B4
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571406; cv=none; b=VxFtEFcGfbxlM839tjfQM1ug7rU1cGvZEWHlswcJ+2gx4cto87R/I5M+XRprV62YSK7TecdEoDc4wxGvj7ghtGar1IMG0Ggi3/KUQYMaZwcCRBTiwtk7fCt9UxXeIo0UbgmG4F2htp3UzGbO8I9m0GM6FgPOCPu8o/icdmCvcPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571406; c=relaxed/simple;
	bh=5omljik+RLFldbsP5S/jIkGkUQQDWaYfGFgX+iCrey4=;
	h=Date:To:From:Subject:Message-Id; b=DYZaGTDTFXKTErR8ViOVzkFLuINNI67PsQDHqPbNehAX6W5F94y9efXsn3SDGLZ4sUi6ii+kQm77/54t5UdzigntEf96DHizJ4uzvekl8c/gnnLpJ6ogKxxwEd36prV/HQogiD6USO41nZ3Z3l25RfJcaRN9hx0vs5UuR6vyfwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KPlWGLh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KPlWGLh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405AEC433F1;
	Wed, 27 Mar 2024 20:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711571406;
	bh=5omljik+RLFldbsP5S/jIkGkUQQDWaYfGFgX+iCrey4=;
	h=Date:To:From:Subject:From;
	b=KPlWGLh0ZlTcYnZT0wW1McxaFTOwlm+InqE2E87fWaZLFOEpoP5CT7PfM92pfb+8e
	 +0YjpAEBq1Epc6MI3YvpkTy23idEYgTUdKTGhi5FcCIFjVYxpPx/Dgc1lpgicu21+c
	 RgG7DWIj2Rq/LF5mWqsILNe4E76vDpP2ojmRXLVc=
Date: Wed, 27 Mar 2024 13:30:05 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch added to mm-nonmm-unstable branch
Message-Id: <20240327203006.405AEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ARM: crypto: use CC_FLAGS_FPU for NEON CFLAGS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch

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
Subject: ARM: crypto: use CC_FLAGS_FPU for NEON CFLAGS
Date: Wed, 27 Mar 2024 13:00:34 -0700

Now that CC_FLAGS_FPU is exported and can be used anywhere in the source
tree, use it instead of duplicating the flags here.

Link: https://lkml.kernel.org/r/20240327200157.1097089-4-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
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
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <git@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/lib/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/lib/Makefile~arm-crypto-use-cc_flags_fpu-for-neon-cflags
+++ a/arch/arm/lib/Makefile
@@ -40,8 +40,7 @@ $(obj)/csumpartialcopy.o:	$(obj)/csumpar
 $(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
 
 ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
-  NEON_FLAGS			:= -march=armv7-a -mfloat-abi=softfp -mfpu=neon
-  CFLAGS_xor-neon.o		+= $(NEON_FLAGS)
+  CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU)
   obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
 endif
 
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

