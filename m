Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734506CDBA
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154648; cv=none; b=VDI0vDD73t4X3qrcazwbe/6Og37YZ75BRxsCfwYDqXWLkS92a2KviZnol0nC7vG2Iz6ak8+afXjKitEzmcoH+kW5eZLXFH/J5sUtomd4LgjjQo8rIQ8OIw/g9gtEOb4H3n4WARDtZkms9J53eivZT7Gqb+UONx/G0rdjhlP56Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154648; c=relaxed/simple;
	bh=9ZuLPHJpk+360pdsN3iEzZzFEgPBSf3ioy6dScryfG8=;
	h=Date:To:From:Subject:Message-Id; b=lhCC0Cix1/pMsAIKn0xm1P8IOCgAgOp3np9teT8B6I+Di+v16mQU8Vxx6UVeUWjYtWuD+kle+vn6Ps0Zu4Ocm1Jy0Dh8RWoZ+FQxnHMR/ddPah09ocLa16b0eKMvV52bMzSredyJnqKSjql22Cc9jXYlm0rJGw5wYOd2UtWlQYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7hcmZ2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7hcmZ2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36301C32781;
	Sun, 19 May 2024 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154648;
	bh=9ZuLPHJpk+360pdsN3iEzZzFEgPBSf3ioy6dScryfG8=;
	h=Date:To:From:Subject:From;
	b=M7hcmZ2N1JZT+SOVYrgv2qEavqaC2+tcayICy+auxN2KBvmzO4wyLSsJ4f+LOk9B0
	 qkKL3zmM+cTmuEhAr6Ln+XT7U/cA4L/GD6fB/LCkdS6w75DX62/NcbBDfNrSRbCouz
	 mfsHwri4bNcBspOEtYuROhtuWFkjRna0lw7giyIE=
Date: Sun, 19 May 2024 14:37:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-fpu-move-fp-code-to-a-separate-translation-unit.patch removed from -mm tree
Message-Id: <20240519213728.36301C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/fpu: move FP code to a separate translation unit
has been removed from the -mm tree.  Its filename was
     selftests-fpu-move-fp-code-to-a-separate-translation-unit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: selftests/fpu: move FP code to a separate translation unit
Date: Fri, 29 Mar 2024 00:18:29 -0700

This ensures no compiler-generated floating-point code can appear outside
kernel_fpu_{begin,end}() sections, and some architectures enforce this
separation.

Link: https://lkml.kernel.org/r/20240329072441.591471-15-samuel.holland@sifive.com
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


