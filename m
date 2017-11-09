From: akpm@linux-foundation.org
Subject: + lib-test-module-for-find__bit-functions.patch added to -mm tree
Date: Thu, 09 Nov 2017 15:13:41 -0800
Message-ID: <5a04e125.k777UiCmR4NvEU9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754215AbdKIXNm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2017 18:13:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ynorov@caviumnetworks.com, adobriyan@gmail.com, courbet@google.com, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: test module for find_*_bit() functions
has been added to the -mm tree.  Its filename is
     lib-test-module-for-find__bit-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test-module-for-find__bit-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test-module-for-find__bit-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <ynorov@caviumnetworks.com>
Subject: lib: test module for find_*_bit() functions

find_bit functions are widely used in the kernel, including hot paths. 
This module tests performance of those functions in 2 typical scenarios:
randomly filled bitmap with relatively equal distribution of set and
cleared bits, and sparse bitmap which has 1 set bit for 500 cleared bits.

On ThunderX machine:

		 Start testing find_bit() with random-filled bitmap
[1032111.632383] find_next_bit:		240043 cycles,	164062 iterations
[1032111.647236] find_next_zero_bit:	312848 cycles,	163619 iterations
[1032111.661585] find_last_bit:		193748 cycles,	164062 iterations
[1032113.450517] find_first_bit:	177720874 cycles,	164062 iterations
[1032113.462930]
		 Start testing find_bit() with sparse bitmap
[1032113.477229] find_next_bit:		3633 cycles,	656 iterations
[1032113.494281] find_next_zero_bit:	620399 cycles,	327025 iterations
[1032113.506723] find_last_bit:		3038 cycles,	656 iterations
[1032113.524485] find_first_bit:	691407 cycles,	656 iterations

Link: http://lkml.kernel.org/r/20171109140714.13168-1-ynorov@caviumnetworks.com
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Reviewed-by: Clement Courbet <courbet@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug   |    9 ++
 lib/Makefile        |    1 
 lib/test_find_bit.c |  141 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+)

diff -puN lib/Kconfig.debug~lib-test-module-for-find__bit-functions lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-test-module-for-find__bit-functions
+++ a/lib/Kconfig.debug
@@ -1836,6 +1836,15 @@ config TEST_BPF
 
 	  If unsure, say N.
 
+config TEST_FIND_BIT
+	tristate "Test find_bit functions"
+	default n
+	help
+	  This builds the "test_find_bit" module that measure find_*_bit()
+	  functions performance.
+
+	  If unsure, say N.
+
 config TEST_FIRMWARE
 	tristate "Test firmware loading via userspace interface"
 	default n
diff -puN lib/Makefile~lib-test-module-for-find__bit-functions lib/Makefile
--- a/lib/Makefile~lib-test-module-for-find__bit-functions
+++ a/lib/Makefile
@@ -47,6 +47,7 @@ obj-y += hexdump.o
 obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
+obj-$(CONFIG_TEST_FIND_BIT) += test_find_bit.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
 obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
diff -puN /dev/null lib/test_find_bit.c
--- /dev/null
+++ a/lib/test_find_bit.c
@@ -0,0 +1,141 @@
+/*
+ * Test for find_*_bit functions.
+ *
+ * Copyright (c) 2017 Cavium.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * find_bit functions are widely used in kernel, so the successful boot
+ * is good enough test for correctness.
+ *
+ * This test is focused on performance of traversing bitmaps. Two typical
+ * scenarios are reproduced:
+ * - randomly filled bitmap with approximately equal number of set and
+ *   cleared bits;
+ * - sparse bitmap with few set bits at random positions.
+ */
+
+#include <linux/bitops.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/random.h>
+
+#define BITMAP_LEN	(4096UL * 8 * 10)
+#define SPARSE		500
+
+static DECLARE_BITMAP(bitmap, BITMAP_LEN) __initdata;
+
+/*
+ * This is Schlemiel the Painter's algorithm. It should be called after
+ * all other tests for the same bitmap because it sets all bits of bitmap to 1.
+ */
+static int __init test_find_first_bit(void *bitmap, unsigned long len)
+{
+	unsigned long i, cnt;
+	cycles_t cycles;
+
+	cycles = get_cycles();
+	for (cnt = i = 0; i < len; cnt++) {
+		i = find_first_bit(bitmap, len);
+		__clear_bit(i, bitmap);
+	}
+	cycles = get_cycles() - cycles;
+	pr_err("find_first_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+
+	return 0;
+}
+
+static int __init test_find_next_bit(const void *bitmap, unsigned long len)
+{
+	unsigned long i, cnt;
+	cycles_t cycles;
+
+	cycles = get_cycles();
+	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
+		i = find_next_bit(bitmap, BITMAP_LEN, i) + 1;
+	cycles = get_cycles() - cycles;
+	pr_err("find_next_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+
+	return 0;
+}
+
+static int __init test_find_next_zero_bit(const void *bitmap, unsigned long len)
+{
+	unsigned long i, cnt;
+	cycles_t cycles;
+
+	cycles = get_cycles();
+	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
+		i = find_next_zero_bit(bitmap, len, i) + 1;
+	cycles = get_cycles() - cycles;
+	pr_err("find_next_zero_bit:\t%ld cycles,\t%ld iterations\n",
+								cycles, cnt);
+
+	return 0;
+}
+
+static int __init test_find_last_bit(const void *bitmap, unsigned long len)
+{
+	unsigned long l, cnt = 0;
+	cycles_t cycles;
+
+	cycles = get_cycles();
+	do {
+		cnt++;
+		l = find_last_bit(bitmap, len);
+		if (l >= len)
+			break;
+		len = l;
+	} while (len);
+	cycles = get_cycles() - cycles;
+	pr_err("find_last_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+
+	return 0;
+}
+
+static int __init find_bit_test(void)
+{
+	unsigned long nbits = BITMAP_LEN / SPARSE;
+
+	pr_err("\nStart testing find_bit() with random-filled bitmap\n");
+
+	get_random_bytes(bitmap, sizeof(bitmap));
+
+	test_find_next_bit(bitmap, BITMAP_LEN);
+	test_find_next_zero_bit(bitmap, BITMAP_LEN);
+	test_find_last_bit(bitmap, BITMAP_LEN);
+	test_find_first_bit(bitmap, BITMAP_LEN);
+
+	pr_err("\nStart testing find_bit() with sparse bitmap\n");
+
+	bitmap_zero(bitmap, BITMAP_LEN);
+
+	while (nbits--)
+		__set_bit(prandom_u32() % BITMAP_LEN, bitmap);
+
+	test_find_next_bit(bitmap, BITMAP_LEN);
+	test_find_next_zero_bit(bitmap, BITMAP_LEN);
+	test_find_last_bit(bitmap, BITMAP_LEN);
+	test_find_first_bit(bitmap, BITMAP_LEN);
+
+	return 0;
+}
+module_init(find_bit_test);
+
+static void __exit test_find_bit_cleanup(void)
+{
+}
+module_exit(test_find_bit_cleanup);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ynorov@caviumnetworks.com are

lib-test-module-for-find__bit-functions.patch

