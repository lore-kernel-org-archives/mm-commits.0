Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB714687
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769447; cv=none; b=UXOQDFKL98InBH7i9VOsbDqIhqAxE40KbO6DThjierasoNkvbcRxCxrxENjJbUD8MMJd0ws9kb0UbqAdE7Fock1Pffbpq1b0qeaiWW8ce2X3g6Qi7bQcLcFfPVSERkjWA+dhE/+aCICI2nvkP3fS+ypL1EMCwe7dbbghAh6Nr3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769447; c=relaxed/simple;
	bh=D++i0phdgtSIEFRp+nWoEJLUjhJLavljwWOzBAmG/gc=;
	h=Date:To:From:Subject:Message-Id; b=fPcmAN69nVVS4yUXF73a5AsQadMVrUAE4GLkiZowVFn+vM0+4ETq0Dm2cel54bFelvK7CIOPMd5ooXt9JkSDkUg6hMlCieSCcicz3B8wDWnBGvoqCpZzZ9tHvsp6zm/6x4bxt2T7RmJcIPKWVFk+1ReMTZ5n8w5N23uX5jeljG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VTr9ge1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VTr9ge1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A3C433F1;
	Sat, 30 Mar 2024 03:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769447;
	bh=D++i0phdgtSIEFRp+nWoEJLUjhJLavljwWOzBAmG/gc=;
	h=Date:To:From:Subject:From;
	b=VTr9ge1fhxkZdrSFOLNDw9fVJSNMKFHtaQx2Qom+1THdgEftS+MuVO44+ut94u7Hh
	 Vg1up4777kMd1u4AW1nXVOzRRIa2y7+X4clZioMKTnfgwRCnVmIgazNCMCBTS682Hv
	 xeftmYTtad+mepdOQ11+CztHYgD94Aw1yDfz2t7U=
Date: Fri, 29 Mar 2024 20:30:46 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch added to mm-nonmm-unstable branch
Message-Id: <20240330033047.050A3C433F1@smtp.kernel.org>
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
Date: Fri, 29 Mar 2024 00:18:18 -0700

Now that CC_FLAGS_FPU is exported and can be used anywhere in the source
tree, use it instead of duplicating the flags here.

Link: https://lkml.kernel.org/r/20240329072441.591471-4-samuel.holland@sifive.com
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

