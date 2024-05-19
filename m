Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD16CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154637; cv=none; b=UrKRZf7IFppgubJJjHBYmpKJRKwrf84ZUbxff6AzaRY6UpazmNIrRgiqFYEE7WUHQ6p6UciKLtT3ztNZMsBMY2w/+37CjAhbObGaaOYI980cN0dfCq3OTyEVHoM4eaBuFxxD7Xil6AKM05Jo4Pghmp1TwRyN9ta5yFnV2wpXs/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154637; c=relaxed/simple;
	bh=/SHlCO6IgG7MxidegWbRxvR6dg2HgZUCDU1Nbmb/7Jk=;
	h=Date:To:From:Subject:Message-Id; b=fBSFD3301aNOZvSVoSheZ8GW0u//D/+5NnE/QTo+vgHYCXKVDsoYiTbEzRuqW0ORA1tx4j1xQZ38gdjvgVTuKTUMkzOSpzJvUepzs14dH6nojAUa9l7e6SjAEYLrCSpq/zt3S8pBq3kSmkINMbqNlkpRmz9esDaSL1190JNIaDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocoqu5A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocoqu5A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19386C32781;
	Sun, 19 May 2024 21:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154637;
	bh=/SHlCO6IgG7MxidegWbRxvR6dg2HgZUCDU1Nbmb/7Jk=;
	h=Date:To:From:Subject:From;
	b=ocoqu5A5LcfB9LfSd/Hl3k6tQ2CyZT6MxIFsnD+67fC9+uHqdm8jKTt//FT+Gr9Ot
	 tc+4P1kV9RCUN5nNrrCNZjNurJhYrALFep/IzccgUuWguyTjEMyUSRN1qvaxcN1tXi
	 5Sayc3CcX9iFZzX2x4+XDZwDKx4FKYe4vQotWPgY=
Date: Sun, 19 May 2024 14:37:16 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-raid6-use-cc_flags_fpu-for-neon-cflags.patch removed from -mm tree
Message-Id: <20240519213717.19386C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/raid6: use CC_FLAGS_FPU for NEON CFLAGS
has been removed from the -mm tree.  Its filename was
     lib-raid6-use-cc_flags_fpu-for-neon-cflags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: lib/raid6: use CC_FLAGS_FPU for NEON CFLAGS
Date: Fri, 29 Mar 2024 00:18:21 -0700

Now that CC_FLAGS_FPU is exported and can be used anywhere in the source
tree, use it instead of duplicating the flags here.

Link: https://lkml.kernel.org/r/20240329072441.591471-7-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian König <christian.koenig@amd.com> 
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
       cmd_unroll = $(AWK) -v N=$* -f $(src)/unroll.awk < $< > $@
 
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


