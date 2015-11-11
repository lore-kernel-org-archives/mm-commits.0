From: akpm@linux-foundation.org
Subject: + test_hexdump-print-statistics-at-the-end.patch added to -mm
 tree
Date: Wed, 11 Nov 2015 13:18:06 -0800
Message-ID: <5643b08e.Uj0bO9FIu2Qd11PB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbKKVSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 16:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: print statistics at the end
has been added to the -mm tree.  Its filename is
     test_hexdump-print-statistics-at-the-end.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_hexdump-print-statistics-at-the-end.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_hexdump-print-statistics-at-the-end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: print statistics at the end

Like others test are doing print the gathered statistics after test module
is finished.  Return from the module based on the result.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-print-statistics-at-the-end lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-print-statistics-at-the-end
+++ a/lib/test_hexdump.c
@@ -42,6 +42,9 @@ static const char * const test_data_8_le
 	"e9ac0f9cad319ca6", "0cafb1439919d14c",
 };
 
+static unsigned total_tests __initdata;
+static unsigned failed_tests __initdata;
+
 static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 					     int groupsize, char *test,
 					     size_t testlen, bool ascii)
@@ -102,6 +105,8 @@ static void __init test_hexdump(size_t l
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char real[TEST_HEXDUMP_BUF_SIZE];
 
+	total_tests++;
+
 	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
 			   ascii);
 
@@ -112,6 +117,7 @@ static void __init test_hexdump(size_t l
 		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
 		pr_err("Result: '%s'\n", real);
 		pr_err("Expect: '%s'\n", test);
+		failed_tests++;
 	}
 }
 
@@ -136,6 +142,8 @@ static void __init test_hexdump_overflow
 	int ae, he, e, r;
 	bool a;
 
+	total_tests++;
+
 	memset(buf, ' ', sizeof(buf));
 
 	r = hex_dump_to_buffer(data_b, len, rs, gs, buf, buflen, ascii);
@@ -168,6 +176,7 @@ static void __init test_hexdump_overflow
 		pr_err("Len: %zu buflen: %zu strlen: %zu\n", len, buflen, strlen(buf));
 		pr_err("Result: %d '%s'\n", r, buf);
 		pr_err("Expect: %d '%s'\n", e, test);
+		failed_tests++;
 	}
 }
 
@@ -188,8 +197,6 @@ static int __init test_hexdump_init(void
 	unsigned int i;
 	int rowsize;
 
-	pr_info("Running tests...\n");
-
 	rowsize = (get_random_int() % 2 + 1) * 16;
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, false);
@@ -204,7 +211,14 @@ static int __init test_hexdump_init(void
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
+MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
 MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

test_hexdump-rename-to-test_hexdump.patch
test_hexdump-introduce-test_hexdump_prepare_test-helper.patch
test_hexdump-go-through-all-possible-lengths-of-buffer.patch
test_hexdump-replace-magic-numbers-by-their-meaning.patch
test_hexdump-check-all-bytes-in-real-buffer.patch
test_hexdump-test-all-possible-group-sizes-for-overflow.patch
test_hexdump-print-statistics-at-the-end.patch

