From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 081/127] lib: make a test module with set/clear
 bit
Date: Thu, 04 Jun 2020 16:50:27 -0700
Message-ID: <20200604235027.mAnbSWEWO%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:28 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@intel.com, bp@alien8.de, christian.brauner@ubuntu.com, dan.j.williams@intel.com, jesse.brandeburg@intel.com, linux-mm@kvack.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, peterz@infradead.org, richard.weiyang@gmail.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: lib: make a test module with set/clear bit

Test some bit clears/sets to make sure assembly doesn't change, and that
the set_bit and clear_bit functions work and don't cause sparse warnings.

Instruct Kbuild to build this file with extra warning level -Wextra, to
catch new issues, and also doesn't hurt to build with C=1.

This was used to test changes to arch/x86/include/asm/bitops.h.

In particular, sparse (C=1) was very concerned when the last bit before a
natural boundary, like 7, or 31, was being tested, as this causes sign
extension (0xffffff7f) for instance when clearing bit 7.

Recommended usage:
make defconfig
scripts/config -m CONFIG_TEST_BITOPS
make modules_prepare
make C=1 W=1 lib/test_bitops.ko
objdump -S -d lib/test_bitops.ko
insmod lib/test_bitops.ko
rmmod lib/test_bitops.ko
<check dmesg>, there should be no compiler/sparse warnings and no
error messages in log.

Link: http://lkml.kernel.org/r/20200310221747.2848474-2-jesse.brandeburg@intel.com
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
CcL Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                  |   13 +++++
 lib/Makefile                       |    2 
 lib/test_bitops.c                  |   60 +++++++++++++++++++++++++++
 tools/testing/selftests/lib/config |    1 
 4 files changed, 76 insertions(+)

--- a/lib/Kconfig.debug~lib-make-a-test-module-with-set-clear-bit
+++ a/lib/Kconfig.debug
@@ -2022,6 +2022,19 @@ config TEST_LKM
 
 	  If unsure, say N.
 
+config TEST_BITOPS
+	tristate "Test module for compilation of clear_bit/set_bit operations"
+	depends on m
+	help
+	  This builds the "test_bitops" module that is much like the
+	  TEST_LKM module except that it does a basic exercise of the
+	  clear_bit and set_bit macros to make sure there are no compiler
+	  warnings from C=1 sparse checker or -Wextra compilations. It has
+	  no dependencies and doesn't run or load unless explicitly requested
+	  by name.  for example: modprobe test_bitops.
+
+	  If unsure, say N.
+
 config TEST_VMALLOC
 	tristate "Test module for stress/performance analysis of vmalloc allocator"
 	default n
--- a/lib/Makefile~lib-make-a-test-module-with-set-clear-bit
+++ a/lib/Makefile
@@ -56,6 +56,8 @@ obj-y += kstrtox.o
 obj-$(CONFIG_FIND_BIT_BENCHMARK) += find_bit_benchmark.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
+obj-$(CONFIG_TEST_BITOPS) += test_bitops.o
+CFLAGS_test_bitops.o += -Werror
 obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_IDA) += test_ida.o
--- /dev/null
+++ a/lib/test_bitops.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+/* a tiny module only meant to test set/clear_bit */
+
+/* use an enum because thats the most common BITMAP usage */
+enum bitops_fun {
+	BITOPS_4 = 4,
+	BITOPS_7 = 7,
+	BITOPS_11 = 11,
+	BITOPS_31 = 31,
+	BITOPS_88 = 88,
+	BITOPS_LAST = 255,
+	BITOPS_LENGTH = 256
+};
+
+static DECLARE_BITMAP(g_bitmap, BITOPS_LENGTH);
+
+static int __init test_bitops_startup(void)
+{
+	pr_warn("Loaded test module\n");
+	set_bit(BITOPS_4, g_bitmap);
+	set_bit(BITOPS_7, g_bitmap);
+	set_bit(BITOPS_11, g_bitmap);
+	set_bit(BITOPS_31, g_bitmap);
+	set_bit(BITOPS_88, g_bitmap);
+	return 0;
+}
+
+static void __exit test_bitops_unstartup(void)
+{
+	int bit_set;
+
+	clear_bit(BITOPS_4, g_bitmap);
+	clear_bit(BITOPS_7, g_bitmap);
+	clear_bit(BITOPS_11, g_bitmap);
+	clear_bit(BITOPS_31, g_bitmap);
+	clear_bit(BITOPS_88, g_bitmap);
+
+	bit_set = find_first_bit(g_bitmap, BITOPS_LAST);
+	if (bit_set != BITOPS_LAST)
+		pr_err("ERROR: FOUND SET BIT %d\n", bit_set);
+
+	pr_warn("Unloaded test module\n");
+}
+
+module_init(test_bitops_startup);
+module_exit(test_bitops_unstartup);
+
+MODULE_AUTHOR("Jesse Brandeburg <jesse.brandeburg@intel.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Bit testing module");
--- a/tools/testing/selftests/lib/config~lib-make-a-test-module-with-set-clear-bit
+++ a/tools/testing/selftests/lib/config
@@ -2,3 +2,4 @@ CONFIG_TEST_PRINTF=m
 CONFIG_TEST_BITMAP=m
 CONFIG_PRIME_NUMBERS=m
 CONFIG_TEST_STRSCPY=m
+CONFIG_TEST_BITOPS=m
_
