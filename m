Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AD04F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154627; cv=none; b=VgIJPSfuYN0E0wdnI8Bc8nTHFmy2xaT7z5lrLXSD4GoWCdiklXGu7y1OqyE3FI9Huf4a36HI+eIc85PGM+P83YGDWu7jw5oHyuVNFrxlUn2loNC3i9TrVQelmFMonQdsuNoMsgRQCBqzFZhBIgvYovdmhv7jhURXNmNgOhoPWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154627; c=relaxed/simple;
	bh=fJiiLGJmrHvqRbAP41/mdNBDZAbepewUjwqNg5u36is=;
	h=Date:To:From:Subject:Message-Id; b=B+qFoQB6nnnMq+E5GSyWQ3j4Kgd5cjWnLBwgS4ByWHsXJLCMcvQ7Pf8Z3s9rl1YzA2C+4q7qk6CFX8e+B2MZyAJes6tNdnyioCT8DW3fivOP8ZYqmzZon+13fFK/f6GAtN3zqPGCBHA6UBy27A2Bp1ZQYGgHp4YY+0hMQ73oxLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UAqIVrbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UAqIVrbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B36C32781;
	Sun, 19 May 2024 21:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154627;
	bh=fJiiLGJmrHvqRbAP41/mdNBDZAbepewUjwqNg5u36is=;
	h=Date:To:From:Subject:From;
	b=UAqIVrbuaSBsojPU+NjghFdSeGbKeUMlv8vvM/3pIkHQkewp1kb6aY7mrG3Bwb4Os
	 JhD92uw1WBKwfokKqKdjEfSpKI2WvpPXw7JGydD/dRjF8cvxVT7mEHq4eSvaEEWHB7
	 sGShk0S7wuvFbA6IcusMsKMNHnw2TByaeU4iqx7w=
Date: Sun, 19 May 2024 14:37:06 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-fpu-fix-asm-fpu-typesh-include-guard.patch removed from -mm tree
Message-Id: <20240519213707.02B36C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/fpu: fix asm/fpu/types.h include guard
has been removed from the -mm tree.  Its filename was
     x86-fpu-fix-asm-fpu-typesh-include-guard.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: x86/fpu: fix asm/fpu/types.h include guard
Date: Fri, 29 Mar 2024 00:18:24 -0700

Patch series "Unified cross-architecture kernel-mode FPU API", v4.

This series unifies the kernel-mode FPU API across several architectures
by wrapping the existing functions (where needed) in consistently-named
functions placed in a consistent header location, with mostly the same
semantics: they can be called from preemptible or non-preemptible task
context, and are not assumed to be reentrant.  Architectures are also
expected to provide CFLAGS adjustments for compiling FPU-dependent code. 
For the moment, SIMD/vector units are out of scope for this common API.

This allows us to remove the ifdeffery and duplicated Makefile logic at
each FPU user.  It then implements the common API on RISC-V, and converts
a couple of users to the new API: the AMDGPU DRM driver, and the FPU self
test.

The underlying goal of this series is to allow using newer AMD GPUs (e.g. 
Navi) on RISC-V boards such as SiFive's HiFive Unmatched.  Those GPUs need
CONFIG_DRM_AMD_DC_FP to initialize, which requires kernel-mode FPU
support.


This patch (of 15):

The include guard should match the filename, or it will conflict with
the newly-added asm/fpu.h.

Link: https://lkml.kernel.org/r/20240329072441.591471-1-samuel.holland@sifive.com
Link: https://lkml.kernel.org/r/20240329072441.591471-10-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Christian König <christian.koenig@amd.com> 
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: WANG Xuerui <git@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fpu/types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/fpu/types.h~x86-fpu-fix-asm-fpu-typesh-include-guard
+++ a/arch/x86/include/asm/fpu/types.h
@@ -2,8 +2,8 @@
 /*
  * FPU data structures:
  */
-#ifndef _ASM_X86_FPU_H
-#define _ASM_X86_FPU_H
+#ifndef _ASM_X86_FPU_TYPES_H
+#define _ASM_X86_FPU_TYPES_H
 
 #include <asm/page_types.h>
 
@@ -596,4 +596,4 @@ struct fpu_state_config {
 /* FPU state configuration information */
 extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
 
-#endif /* _ASM_X86_FPU_H */
+#endif /* _ASM_X86_FPU_TYPES_H */
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


