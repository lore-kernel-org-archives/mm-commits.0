From: akpm@linux-foundation.org
Subject: [to-be-updated] test_hexdump-print-statistics-at-the-end.patch
 removed from -mm tree
Date: Wed, 09 Dec 2015 16:23:33 -0800
Message-ID: <5668c605.1H/GByPlwW2kgXqe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbbLJAXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:23:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: print statistics at the end
has been removed from the -mm tree.  Its filename was
     test_hexdump-print-statistics-at-the-end.patch

This patch was dropped because an updated version will be merged

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
