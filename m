Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D389414D45B
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571413; cv=none; b=TEqSleQ8rNeH3xygwebEJ0mIBQYZYNS+bkTD0ZEftblGEWKEuEpL5pVYLh6mG6Eok5pxjbGv3ji/zPFgJ5l6/yTJlhW0zHXA+YpMqAPrwVxN6fRUz/e6qPdIswZg9olkFOI0KBO+0SNcqRVDoir2JsAmii2r6DBpkXCJfgLGnd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571413; c=relaxed/simple;
	bh=9CswuWsYc4wsUmqz/LnHdjEA70KbTETUYbfmevsTLNw=;
	h=Date:To:From:Subject:Message-Id; b=ULH/TsoSOpk8Km2+XM61Q0bma+0u1zkPRGF/xp+rNTd7ZH5oUoKh1qakvx2UhZdQ3xDGJT/rQpkr4/Cf53idWQgbIG2lk3HbIgAcZKTkpxrnbkkxrc9bHec1gxlqcJJvixC/l/Q54kWwN/cLT/10/OZ7PfSVAOOI4Lw+JTozIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eefbXycH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eefbXycH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6056BC433F1;
	Wed, 27 Mar 2024 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711571413;
	bh=9CswuWsYc4wsUmqz/LnHdjEA70KbTETUYbfmevsTLNw=;
	h=Date:To:From:Subject:From;
	b=eefbXycH28xe/m3sQXKNvzybwjYl2cIgjnwmDo1aWyx6M1ppjbmbailBtWOssuzP7
	 0uTHYLiJh4eybcIMTZ3vHQ/ot4QutP10QVz8B+MJ47APPCMYuvleq90zrtV0BDe8mW
	 S6bKH1mgOO88EAa0BB13LT7BCct8Yj8H1t+ScRvQ=
Date: Wed, 27 Mar 2024 13:30:12 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-implement-arch_has_kernel_fpu_support.patch added to mm-nonmm-unstable branch
Message-Id: <20240327203013.6056BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: LoongArch: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     loongarch-implement-arch_has_kernel_fpu_support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-implement-arch_has_kernel_fpu_support.patch

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
Subject: LoongArch: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Wed, 27 Mar 2024 13:00:38 -0700

LoongArch already provides kernel_fpu_begin() and kernel_fpu_end() in
asm/fpu.h, so it only needs to add kernel_fpu_available() and export the
CFLAGS adjustments.

Link: https://lkml.kernel.org/r/20240327200157.1097089-8-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: WANG Xuerui <git@xen0n.name>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/Kconfig           |    1 +
 arch/loongarch/Makefile          |    5 ++++-
 arch/loongarch/include/asm/fpu.h |    1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/fpu.h~loongarch-implement-arch_has_kernel_fpu_support
+++ a/arch/loongarch/include/asm/fpu.h
@@ -21,6 +21,7 @@
 
 struct sigcontext;
 
+#define kernel_fpu_available() cpu_has_fpu
 extern void kernel_fpu_begin(void);
 extern void kernel_fpu_end(void);
 
--- a/arch/loongarch/Kconfig~loongarch-implement-arch_has_kernel_fpu_support
+++ a/arch/loongarch/Kconfig
@@ -18,6 +18,7 @@ config LOONGARCH
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_KERNEL_FPU_SUPPORT if CPU_HAS_FPU
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL
--- a/arch/loongarch/Makefile~loongarch-implement-arch_has_kernel_fpu_support
+++ a/arch/loongarch/Makefile
@@ -26,6 +26,9 @@ endif
 32bit-emul		= elf32loongarch
 64bit-emul		= elf64loongarch
 
+CC_FLAGS_FPU		:= -mfpu=64
+CC_FLAGS_NO_FPU		:= -msoft-float
+
 ifdef CONFIG_UNWINDER_ORC
 orc_hash_h := arch/$(SRCARCH)/include/generated/asm/orc_hash.h
 orc_hash_sh := $(srctree)/scripts/orc_hash.sh
@@ -59,7 +62,7 @@ ld-emul			= $(64bit-emul)
 cflags-y		+= -mabi=lp64s
 endif
 
-cflags-y			+= -pipe -msoft-float
+cflags-y			+= -pipe $(CC_FLAGS_NO_FPU)
 LDFLAGS_vmlinux			+= -static -n -nostdlib
 
 # When the assembler supports explicit relocation hint, we must use it.
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

