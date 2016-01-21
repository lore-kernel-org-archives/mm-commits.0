From: akpm@linux-foundation.org
Subject: [merged] test_hexdump-print-statistics-at-the-end.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:59:07 -0800
Message-ID: <56a162bb.yfjenpwTFpWSMXDk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbcAUW7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: print statistics at the end
has been removed from the -mm tree.  Its filename was
     test_hexdump-print-statistics-at-the-end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: print statistics at the end

Like others test are doing print the gathered statistics after test module
is finished.  Return from the module based on the result.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-print-statistics-at-the-end lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-print-statistics-at-the-end
+++ a/lib/test_hexdump.c
@@ -44,6 +44,9 @@ static const char * const test_data_8_le
 
 #define FILL_CHAR	'#'
 
+static unsigned total_tests __initdata;
+static unsigned failed_tests __initdata;
+
 static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 					     int groupsize, char *test,
 					     size_t testlen, bool ascii)
@@ -107,6 +110,8 @@ static void __init test_hexdump(size_t l
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char real[TEST_HEXDUMP_BUF_SIZE];
 
+	total_tests++;
+
 	memset(real, FILL_CHAR, sizeof(real));
 	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
 			   ascii);
@@ -119,6 +124,7 @@ static void __init test_hexdump(size_t l
 		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
 		pr_err("Result: '%s'\n", real);
 		pr_err("Expect: '%s'\n", test);
+		failed_tests++;
 	}
 }
 
@@ -143,6 +149,8 @@ static void __init test_hexdump_overflow
 	int ae, he, e, f, r;
 	bool a;
 
+	total_tests++;
+
 	memset(buf, FILL_CHAR, sizeof(buf));
 
 	r = hex_dump_to_buffer(data_b, len, rs, gs, buf, buflen, ascii);
@@ -175,6 +183,7 @@ static void __init test_hexdump_overflow
 			len, buflen, strnlen(buf, sizeof(buf)));
 		pr_err("Result: %d '%s'\n", r, buf);
 		pr_err("Expect: %d '%s'\n", e, test);
+		failed_tests++;
 	}
 }
 
@@ -196,8 +205,6 @@ static int __init test_hexdump_init(void
 	unsigned int i;
 	int rowsize;
 
-	pr_info("Running tests...\n");
-
 	rowsize = (get_random_int() % 2 + 1) * 16;
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, false);
@@ -212,7 +219,20 @@ static int __init test_hexdump_init(void
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
 		test_hexdump_overflow_set(i, true);
 
-	return -EINVAL;
+	if (failed_tests == 0)
+		pr_info("all %u tests passed\n", total_tests);
+	else
+		pr_err("failed %u out of %u tests\n", failed_tests, total_tests);
+
+	return failed_tests ? -EINVAL : 0;
 }
 module_init(test_hexdump_init);
+
+static void __exit test_hexdump_exit(void)
+{
+	/* do nothing */
+}
+module_exit(test_hexdump_exit);
+
+MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
 MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

