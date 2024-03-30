Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD415231
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769454; cv=none; b=hFk458xQOkx5PGcgpGCSo9uiTLvzrcT7RgPv4vxUC6a8tkiA0oDY5qjZgisX/bZavaN85T9IFQJaLFtWNK5SEsuUu2Ro4W/Nft4oGQMGS/YKkdmaR63fgPmeZILkUXI/azDYnUABEBNNvLKD5ToM9nvP7mRhyn/lPagK5PqUWuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769454; c=relaxed/simple;
	bh=GYNa1T3SuunivpjFG8X8pSrm+WDh9xRssCUHYEWqwLY=;
	h=Date:To:From:Subject:Message-Id; b=HTrHte8z0ggos5VnYVqWXPxXrmue7PWJ1LuEKtRX7Y25v57Gb8aPC0uq/9gt4/y7u8jIdyCmKD5dqjlGSWpP9cm42xf/zfYxOuwxwryG5nHmyQacEA4SWtJ3Lv22PgDzSauq/3332bY+6U6o6qAqEuDnNwwcZ6LCYMVQg5nf1aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLnAJNH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLnAJNH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F8C433F1;
	Sat, 30 Mar 2024 03:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769454;
	bh=GYNa1T3SuunivpjFG8X8pSrm+WDh9xRssCUHYEWqwLY=;
	h=Date:To:From:Subject:From;
	b=OLnAJNH21QabIl8cmZXTRzj6qkcXPrAuUTKqUqMVZMh0xNKjvcHqMmmuFicRajOUZ
	 fOFgpFD68F/90cvA7bP+IcuCQBEEBrQmnb5ZKm5HJ4bq7p1PBednyFEScbB0KK55Jz
	 lIiMxxytuWgBBEGB/8l1cnt9Ll15Cxk0MU+8J5xk=
Date: Fri, 29 Mar 2024 20:30:53 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-raid6-use-cc_flags_fpu-for-neon-cflags.patch added to mm-nonmm-unstable branch
Message-Id: <20240330033053.E89F8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/raid6: use CC_FLAGS_FPU for NEON CFLAGS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-raid6-use-cc_flags_fpu-for-neon-cflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-raid6-use-cc_flags_fpu-for-neon-cflags.patch

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
Subject: lib/raid6: use CC_FLAGS_FPU for NEON CFLAGS
Date: Fri, 29 Mar 2024 00:18:21 -0700

Now that CC_FLAGS_FPU is exported and can be used anywhere in the source
tree, use it instead of duplicating the flags here.

Link: https://lkml.kernel.org/r/20240329072441.591471-7-samuel.holland@sifive.com
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

 lib/raid6/Makefile |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

--- a/lib/raid6/Makefile~lib-raid6-use-cc_flags_fpu-for-neon-cflags
+++ a/lib/raid6/Makefile
@@ -33,25 +33,6 @@ CFLAGS_REMOVE_vpermxor8.o += -msoft-floa
 endif
 endif
 
-# The GCC option -ffreestanding is required in order to compile code containing
-# ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
-ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
-NEON_FLAGS := -ffreestanding
-# Enable <arm_neon.h>
-NEON_FLAGS += -isystem $(shell $(CC) -print-file-name=include)
-ifeq ($(ARCH),arm)
-NEON_FLAGS += -march=armv7-a -mfloat-abi=softfp -mfpu=neon
-endif
-CFLAGS_recov_neon_inner.o += $(NEON_FLAGS)
-ifeq ($(ARCH),arm64)
-CFLAGS_REMOVE_recov_neon_inner.o += -mgeneral-regs-only
-CFLAGS_REMOVE_neon1.o += -mgeneral-regs-only
-CFLAGS_REMOVE_neon2.o += -mgeneral-regs-only
-CFLAGS_REMOVE_neon4.o += -mgeneral-regs-only
-CFLAGS_REMOVE_neon8.o += -mgeneral-regs-only
-endif
-endif
-
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(AWK) -v N=$* -f $(srctree)/$(src)/unroll.awk < $< > $@
 
@@ -75,10 +56,16 @@ targets += vpermxor1.c vpermxor2.c vperm
 $(obj)/vpermxor%.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
-CFLAGS_neon1.o += $(NEON_FLAGS)
-CFLAGS_neon2.o += $(NEON_FLAGS)
-CFLAGS_neon4.o += $(NEON_FLAGS)
-CFLAGS_neon8.o += $(NEON_FLAGS)
+CFLAGS_neon1.o += $(CC_FLAGS_FPU)
+CFLAGS_neon2.o += $(CC_FLAGS_FPU)
+CFLAGS_neon4.o += $(CC_FLAGS_FPU)
+CFLAGS_neon8.o += $(CC_FLAGS_FPU)
+CFLAGS_recov_neon_inner.o += $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_neon1.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_neon2.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_neon4.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_neon8.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
 targets += neon1.c neon2.c neon4.c neon8.c
 $(obj)/neon%.c: $(src)/neon.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
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

