Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC5E1094E
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154649; cv=none; b=c5NFkpuvuFTnRz+5T9aCd/Op4U7QFDeqUbrj20l7jN1+/euPoS7hYMO9PXM5sHs/yGpPc4UUiLT0ho6iOS23Q/RVpRYuLcyTN3iSD/Tudi3h2Ru59CVfePo0/2r1nWvMCgCPt1Bev6fQU5jLGwT9CN/1q9yo8hItj8HN6TtKoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154649; c=relaxed/simple;
	bh=BqAwtxOmxQrlSE0HL1NfLoftqZjRdhDqj6GZFQgn0S0=;
	h=Date:To:From:Subject:Message-Id; b=UHibEzVyxwe6e//Hxz5ldnGAl0eMB56G5MTjnFvkR7YkAT/FKLytugsNRTTxsrLEP/F8pMNitpJHd5l7JOE4zMz2PIsi8l704irDplsx4/gIR52OQWL80r4qv/wgLU/vcMcJeMQUhRWk5jE0mi2ZBlHT6dgqCkr9P9zkZbL8npc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bvyelvg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bvyelvg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DCAC32781;
	Sun, 19 May 2024 21:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154649;
	bh=BqAwtxOmxQrlSE0HL1NfLoftqZjRdhDqj6GZFQgn0S0=;
	h=Date:To:From:Subject:From;
	b=Bvyelvg8gh7vo+N1khOClXo3tu74P6i1DeYVHgWw5nJ09a/qaoME2ROps4d/67er2
	 FUFwIWSMAzgNtsZzbP4mQ8lUnPMcsMIIKOlrH1BrubXVS9b83fdqiaVUHZ2Q811Zch
	 KAjMq4pGL+IRP3N0djMumv3NbJWLBbVSUMU+A5JU=
Date: Sun, 19 May 2024 14:37:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-fpu-allow-building-on-other-architectures.patch removed from -mm tree
Message-Id: <20240519213729.96DCAC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/fpu: allow building on other architectures
has been removed from the -mm tree.  Its filename was
     selftests-fpu-allow-building-on-other-architectures.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: selftests/fpu: allow building on other architectures
Date: Fri, 29 Mar 2024 00:18:30 -0700

Now that ARCH_HAS_KERNEL_FPU_SUPPORT provides a common way to compile and
run floating-point code, this test is no longer x86-specific.

Link: https://lkml.kernel.org/r/20240329072441.591471-16-samuel.holland@sifive.com
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

 lib/Kconfig.debug   |    2 +-
 lib/Makefile        |   25 ++-----------------------
 lib/test_fpu_glue.c |    5 ++++-
 3 files changed, 7 insertions(+), 25 deletions(-)

--- a/lib/Kconfig.debug~selftests-fpu-allow-building-on-other-architectures
+++ a/lib/Kconfig.debug
@@ -2926,7 +2926,7 @@ config TEST_FREE_PAGES
 
 config TEST_FPU
 	tristate "Test floating point operations in kernel space"
-	depends on X86 && !KCOV_INSTRUMENT_ALL
+	depends on ARCH_HAS_KERNEL_FPU_SUPPORT && !KCOV_INSTRUMENT_ALL
 	help
 	  Enable this option to add /sys/kernel/debug/selftest_helpers/test_fpu
 	  which will trigger a sequence of floating point operations. This is used
--- a/lib/Makefile~selftests-fpu-allow-building-on-other-architectures
+++ a/lib/Makefile
@@ -110,31 +110,10 @@ CFLAGS_test_fprobe.o += $(CC_FLAGS_FTRAC
 obj-$(CONFIG_FPROBE_SANITY_TEST) += test_fprobe.o
 obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
 
-#
-# CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
-# off the generation of FPU/SSE* instructions for kernel proper but FPU_FLAGS
-# get appended last to CFLAGS and thus override those previous compiler options.
-#
-FPU_CFLAGS := -msse -msse2
-ifdef CONFIG_CC_IS_GCC
-# Stack alignment mismatch, proceed with caution.
-# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
-# (8B stack alignment).
-# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383
-#
-# The "-msse" in the first argument is there so that the
-# -mpreferred-stack-boundary=3 build error:
-#
-#  -mpreferred-stack-boundary=3 is not between 4 and 12
-#
-# can be triggered. Otherwise gcc doesn't complain.
-FPU_CFLAGS += -mhard-float
-FPU_CFLAGS += $(call cc-option,-msse -mpreferred-stack-boundary=3,-mpreferred-stack-boundary=4)
-endif
-
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
 test_fpu-y := test_fpu_glue.o test_fpu_impl.o
-CFLAGS_test_fpu_impl.o += $(FPU_CFLAGS)
+CFLAGS_test_fpu_impl.o += $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_test_fpu_impl.o += $(CC_FLAGS_NO_FPU)
 
 # Some KUnit files (hooks.o) need to be built-in even when KUnit is a module,
 # so we can't just use obj-$(CONFIG_KUNIT).
--- a/lib/test_fpu_glue.c~selftests-fpu-allow-building-on-other-architectures
+++ a/lib/test_fpu_glue.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
-#include <asm/fpu/api.h>
+#include <linux/fpu.h>
 
 #include "test_fpu.h"
 
@@ -38,6 +38,9 @@ static struct dentry *selftest_dir;
 
 static int __init test_fpu_init(void)
 {
+	if (!kernel_fpu_available())
+		return -EINVAL;
+
 	selftest_dir = debugfs_create_dir("selftest_helpers", NULL);
 	if (!selftest_dir)
 		return -ENOMEM;
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


