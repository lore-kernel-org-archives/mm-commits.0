Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0092471749
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154636; cv=none; b=RsoodLr3Mk1vItYvoqolz9aYwpyjuqHBwTMw/HIq0+uVxkrvvQIGBLjNizDtTfu39RCsTbeQr/axdBr2x7ChdAd9Vaz2a7cZ0O4EHPB3wDUWzdNUhfDjLZRS2GvHW/y0xl2yvDDpc3OPSChZhj1/sgJB1BauQI599YfjeY/Ptws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154636; c=relaxed/simple;
	bh=HGtI3K2AamZBMSmHRB3qmMlK/0BnRryPLXnFFYFDnRA=;
	h=Date:To:From:Subject:Message-Id; b=Ts+vGLk8vemritHkfU1tYvlKuZ768aottPjvloyOV3y+sQi7h8qkka3j4mmsJNa7Ek3sEOIxL9qkXHcixc7eBuiMwap+OZtHBwZEPwBdXGtF4JzMKDdDTIB4WhD3Io6AD15VzpT6lhKHxLttWatVdGApSFUteukBBnf7W2G/SHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=onrur4Gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="onrur4Gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B399CC32781;
	Sun, 19 May 2024 21:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154635;
	bh=HGtI3K2AamZBMSmHRB3qmMlK/0BnRryPLXnFFYFDnRA=;
	h=Date:To:From:Subject:From;
	b=onrur4Gpr8hBsg4lDCVC3AodFU4NCWnfj5ixSgzXEkfSxsAQSHTok9CT+vSmqTbi5
	 Qd51Kn8aX8tgR/UN9dc+IgCc3/jaye9uKSyBaCKfVaESdUoLc3PuwY09nCNXOGVlzO
	 nNMswX/KqyTKvmMU4MmnDo+L/AcR3dp06tgfG+oM=
Date: Sun, 19 May 2024 14:37:15 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64-crypto-use-cc_flags_fpu-for-neon-cflags.patch removed from -mm tree
Message-Id: <20240519213715.B399CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: crypto: use CC_FLAGS_FPU for NEON CFLAGS
has been removed from the -mm tree.  Its filename was
     arm64-crypto-use-cc_flags_fpu-for-neon-cflags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: arm64: crypto: use CC_FLAGS_FPU for NEON CFLAGS
Date: Fri, 29 Mar 2024 00:18:20 -0700

Now that CC_FLAGS_FPU is exported and can be used anywhere in the source
tree, use it instead of duplicating the flags here.

Link: https://lkml.kernel.org/r/20240329072441.591471-6-samuel.holland@sifive.com
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

 arch/arm64/lib/Makefile |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm64/lib/Makefile~arm64-crypto-use-cc_flags_fpu-for-neon-cflags
+++ a/arch/arm64/lib/Makefile
@@ -7,10 +7,8 @@ lib-y		:= clear_user.o delay.o copy_from
 
 ifeq ($(CONFIG_KERNEL_MODE_NEON), y)
 obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
-CFLAGS_REMOVE_xor-neon.o	+= -mgeneral-regs-only
-CFLAGS_xor-neon.o		+= -ffreestanding
-# Enable <arm_neon.h>
-CFLAGS_xor-neon.o		+= -isystem $(shell $(CC) -print-file-name=include)
+CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_xor-neon.o	+= $(CC_FLAGS_NO_FPU)
 endif
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


