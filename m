Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABF5137C42
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571427; cv=none; b=OOlQqoWMVQJJtuhnRNWC5v4/TMwmqSkMcT30dBWQAvcvuEJm658Y4ddxMgEbJeNQKpc3h0dmwr4QmR6gX1vAiohMYE8/aAWRKd6UX2KZZzj4dPVSSvYwRvuF3fe5YrHAofpTkybFIbsUMdI0mW6HIEkXtNIJrQ9VwL3T7lylz9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571427; c=relaxed/simple;
	bh=0KHZ2MN9HNhTseXbiHp+p+dj8c7dOMfq58RjWqkk/UM=;
	h=Date:To:From:Subject:Message-Id; b=otPPXi7Zl3NQ+EXO+wq4y4n8kXdWqu8clo3Z6GobGfz1+s+upJCLnShXpzx5hqP0dV/CFgyKvVm+Wty7egikvXEdECp+xVIFElMtZWhP6V1eysjevhfL2SM668OlRSvWUH+YFuqpnB4zx3b8HkO9V2eb7Yhhu17syKLMYFAOTbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UMHLJQFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UMHLJQFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA8FC433C7;
	Wed, 27 Mar 2024 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711571427;
	bh=0KHZ2MN9HNhTseXbiHp+p+dj8c7dOMfq58RjWqkk/UM=;
	h=Date:To:From:Subject:From;
	b=UMHLJQFbNaz8Sko9tpYZA9rbiqEj8MSVxdlHivgWZnzmpjZGHKWbVkDJExv9KvnSo
	 n7zEjIl2SP8SY64SjpazcYmEhatRI/o1W9oUHWsUdajDK50I6CzxkCz2h3//FQ9eKW
	 nMwhxM85Sfi26F/P1JPJoduQlMlkOPUez19QXooQ=
Date: Wed, 27 Mar 2024 13:30:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-fpu-move-fp-code-to-a-separate-translation-unit.patch added to mm-nonmm-unstable branch
Message-Id: <20240327203027.1BA8FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/fpu: move FP code to a separate translation unit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-fpu-move-fp-code-to-a-separate-translation-unit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-fpu-move-fp-code-to-a-separate-translation-unit.patch

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
Subject: selftests/fpu: move FP code to a separate translation unit
Date: Wed, 27 Mar 2024 13:00:44 -0700

This ensures no compiler-generated floating-point code can appear outside
kernel_fpu_{begin,end}() sections, and some architectures enforce this
separation.

Link: https://lkml.kernel.org/r/20240327200157.1097089-14-samuel.holland@sifive.com
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

 lib/Makefile        |    3 -
 lib/test_fpu.c      |   89 ------------------------------------------
 lib/test_fpu.h      |    8 +++
 lib/test_fpu_glue.c |   59 +++++++++++++++++++++++++++
 lib/test_fpu_impl.c |   37 +++++++++++++++++
 5 files changed, 106 insertions(+), 90 deletions(-)

--- a/lib/Makefile~selftests-fpu-move-fp-code-to-a-separate-translation-unit
+++ a/lib/Makefile
@@ -133,7 +133,8 @@ FPU_CFLAGS += $(call cc-option,-msse -mp
 endif
 
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
-CFLAGS_test_fpu.o += $(FPU_CFLAGS)
+test_fpu-y := test_fpu_glue.o test_fpu_impl.o
+CFLAGS_test_fpu_impl.o += $(FPU_CFLAGS)
 
 # Some KUnit files (hooks.o) need to be built-in even when KUnit is a module,
 # so we can't just use obj-$(CONFIG_KUNIT).
--- a/lib/test_fpu.c
+++ /dev/null
@@ -1,89 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Test cases for using floating point operations inside a kernel module.
- *
- * This tests kernel_fpu_begin() and kernel_fpu_end() functions, especially
- * when userland has modified the floating point control registers. The kernel
- * state might depend on the state set by the userland thread that was active
- * before a syscall.
- *
- * To facilitate the test, this module registers file
- * /sys/kernel/debug/selftest_helpers/test_fpu, which when read causes a
- * sequence of floating point operations. If the operations fail, either the
- * read returns error status or the kernel crashes.
- * If the operations succeed, the read returns "1\n".
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/debugfs.h>
-#include <asm/fpu/api.h>
-
-static int test_fpu(void)
-{
-	/*
-	 * This sequence of operations tests that rounding mode is
-	 * to nearest and that denormal numbers are supported.
-	 * Volatile variables are used to avoid compiler optimizing
-	 * the calculations away.
-	 */
-	volatile double a, b, c, d, e, f, g;
-
-	a = 4.0;
-	b = 1e-15;
-	c = 1e-310;
-
-	/* Sets precision flag */
-	d = a + b;
-
-	/* Result depends on rounding mode */
-	e = a + b / 2;
-
-	/* Denormal and very large values */
-	f = b / c;
-
-	/* Depends on denormal support */
-	g = a + c * f;
-
-	if (d > a && e > a && g > a)
-		return 0;
-	else
-		return -EINVAL;
-}
-
-static int test_fpu_get(void *data, u64 *val)
-{
-	int status = -EINVAL;
-
-	kernel_fpu_begin();
-	status = test_fpu();
-	kernel_fpu_end();
-
-	*val = 1;
-	return status;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(test_fpu_fops, test_fpu_get, NULL, "%lld\n");
-static struct dentry *selftest_dir;
-
-static int __init test_fpu_init(void)
-{
-	selftest_dir = debugfs_create_dir("selftest_helpers", NULL);
-	if (!selftest_dir)
-		return -ENOMEM;
-
-	debugfs_create_file_unsafe("test_fpu", 0444, selftest_dir, NULL,
-				   &test_fpu_fops);
-
-	return 0;
-}
-
-static void __exit test_fpu_exit(void)
-{
-	debugfs_remove(selftest_dir);
-}
-
-module_init(test_fpu_init);
-module_exit(test_fpu_exit);
-
-MODULE_LICENSE("GPL");
--- /dev/null
+++ a/lib/test_fpu_glue.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Test cases for using floating point operations inside a kernel module.
+ *
+ * This tests kernel_fpu_begin() and kernel_fpu_end() functions, especially
+ * when userland has modified the floating point control registers. The kernel
+ * state might depend on the state set by the userland thread that was active
+ * before a syscall.
+ *
+ * To facilitate the test, this module registers file
+ * /sys/kernel/debug/selftest_helpers/test_fpu, which when read causes a
+ * sequence of floating point operations. If the operations fail, either the
+ * read returns error status or the kernel crashes.
+ * If the operations succeed, the read returns "1\n".
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <asm/fpu/api.h>
+
+#include "test_fpu.h"
+
+static int test_fpu_get(void *data, u64 *val)
+{
+	int status = -EINVAL;
+
+	kernel_fpu_begin();
+	status = test_fpu();
+	kernel_fpu_end();
+
+	*val = 1;
+	return status;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(test_fpu_fops, test_fpu_get, NULL, "%lld\n");
+static struct dentry *selftest_dir;
+
+static int __init test_fpu_init(void)
+{
+	selftest_dir = debugfs_create_dir("selftest_helpers", NULL);
+	if (!selftest_dir)
+		return -ENOMEM;
+
+	debugfs_create_file_unsafe("test_fpu", 0444, selftest_dir, NULL,
+				   &test_fpu_fops);
+
+	return 0;
+}
+
+static void __exit test_fpu_exit(void)
+{
+	debugfs_remove(selftest_dir);
+}
+
+module_init(test_fpu_init);
+module_exit(test_fpu_exit);
+
+MODULE_LICENSE("GPL");
--- /dev/null
+++ a/lib/test_fpu.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef _LIB_TEST_FPU_H
+#define _LIB_TEST_FPU_H
+
+int test_fpu(void);
+
+#endif
--- /dev/null
+++ a/lib/test_fpu_impl.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/errno.h>
+
+#include "test_fpu.h"
+
+int test_fpu(void)
+{
+	/*
+	 * This sequence of operations tests that rounding mode is
+	 * to nearest and that denormal numbers are supported.
+	 * Volatile variables are used to avoid compiler optimizing
+	 * the calculations away.
+	 */
+	volatile double a, b, c, d, e, f, g;
+
+	a = 4.0;
+	b = 1e-15;
+	c = 1e-310;
+
+	/* Sets precision flag */
+	d = a + b;
+
+	/* Result depends on rounding mode */
+	e = a + b / 2;
+
+	/* Denormal and very large values */
+	f = b / c;
+
+	/* Depends on denormal support */
+	g = a + c * f;
+
+	if (d > a && e > a && g > a)
+		return 0;
+	else
+		return -EINVAL;
+}
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

