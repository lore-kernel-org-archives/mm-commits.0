Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183746CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154639; cv=none; b=QVfHCxpG16PbwJ0RqPDQp5iTqXEv1WUMRZym8orKhng0O0EkWCslAoBDSYZTb5V8YG+UHXVFTn28MpnrDbZgAlUiBcOeg6C2kfQNXiFLUwWgSO7lBIyjmeW6ZZVjsrRnf06xRCYTww1X6NUMLIEoIiTTuD4o5Iat+ZUwkQSMxCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154639; c=relaxed/simple;
	bh=pHRbIDa9FfcPzqP8wmI4HR0ufxCi/4VqNLniIRgRZmM=;
	h=Date:To:From:Subject:Message-Id; b=EZ6ApW176VdoEpwv9CuN/XOlS3K8nTIY3aK7z94VMQNk+9qodrsRetCKZ4KCX/xKyOnmixDVyBwD4j/+Hs3c+Na+98+9EA7YBA5iK2jTVvh0OLFNDnz6bpM2BlT5zOCG7bB26G45ljlHjZibQfqw7WDakKr1yDHexex6vxCCIx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1TQYu5Np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1TQYu5Np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE535C32781;
	Sun, 19 May 2024 21:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154639;
	bh=pHRbIDa9FfcPzqP8wmI4HR0ufxCi/4VqNLniIRgRZmM=;
	h=Date:To:From:Subject:From;
	b=1TQYu5NpEFP6ZiWM6zYv9/32DeB64E/GjNxn3KI6SFj32FHYPPFa8kiYwkMyXaaoX
	 zEhgn+a+OLFXmSQcSfS0bx4y7sqhu0Qwv6X/E432kVR+3NiN3AuOOe4zDc5ikwS7if
	 oSLq15BAI5oEN1x64FUyxlH54DHRr8XtFz7xsiqI=
Date: Sun, 19 May 2024 14:37:18 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] loongarch-implement-arch_has_kernel_fpu_support.patch removed from -mm tree
Message-Id: <20240519213718.DE535C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: LoongArch: implement ARCH_HAS_KERNEL_FPU_SUPPORT
has been removed from the -mm tree.  Its filename was
     loongarch-implement-arch_has_kernel_fpu_support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: LoongArch: implement ARCH_HAS_KERNEL_FPU_SUPPORT
Date: Fri, 29 Mar 2024 00:18:22 -0700

LoongArch already provides kernel_fpu_begin() and kernel_fpu_end() in
asm/fpu.h, so it only needs to add kernel_fpu_available() and export the
CFLAGS adjustments.

Link: https://lkml.kernel.org/r/20240329072441.591471-8-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: WANG Xuerui <git@xen0n.name>
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


