From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-make-a-test-module-with-set-clear-bit.patch added
 to -mm tree
Date: Mon, 25 May 2020 13:41:19 -0700
Message-ID: <20200525204119.A3KVxDxU7%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390437AbgEYUlU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 May 2020 16:41:20 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@intel.com, bp@alien8.de, christian.brauner@ubuntu.com, dan.j.williams@intel.com, jesse.brandeburg@intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, peterz@infradead.org, richard.weiyang@gmail.com, tglx@linutronix.de


The patch titled
     Subject: lib: make a test module with set/clear bit
has been added to the -mm tree.  Its filename is
     lib-make-a-test-module-with-set-clear-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-make-a-test-module-with-set-clear-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-make-a-test-module-with-set-clear-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2035,6 +2035,19 @@ config TEST_LKM
 
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
@@ -76,6 +76,8 @@ obj-$(CONFIG_TEST_SORT) += test_sort.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
+obj-$(CONFIG_TEST_BITOPS) += test_bitops.o
+CFLAGS_test_bitops.o += -Werror
 obj-$(CONFIG_TEST_PRINTF) += test_printf.o
 obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
 obj-$(CONFIG_TEST_STRSCPY) += test_strscpy.o
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

Patches currently in -mm which might be from jesse.brandeburg@intel.com are

lib-make-a-test-module-with-set-clear-bit.patch
