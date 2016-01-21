From: akpm@linux-foundation.org
Subject: [merged]
 test_hexdump-introduce-test_hexdump_prepare_test-helper.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 14:58:54 -0800
Message-ID: <56a162ae.wbJcC7nnvB+gjV2g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbcAUW6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: introduce test_hexdump_prepare_test() helper
has been removed from the -mm tree.  Its filename was
     test_hexdump-introduce-test_hexdump_prepare_test-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: introduce test_hexdump_prepare_test() helper

The function prepares the expected result in the provided buffer.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-introduce-test_hexdump_prepare_test-helper lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-introduce-test_hexdump_prepare_test-helper
+++ a/lib/test_hexdump.c
@@ -42,19 +42,16 @@ static const char * const test_data_8_le
 	"e9ac0f9cad319ca6", "0cafb1439919d14c",
 };
 
-static void __init test_hexdump(size_t len, int rowsize, int groupsize,
-				bool ascii)
+static void __init test_hexdump_prepare_test(size_t len, int rowsize,
+					     int groupsize, char *test,
+					     size_t testlen, bool ascii)
 {
-	char test[32 * 3 + 2 + 32 + 1];
-	char real[32 * 3 + 2 + 32 + 1];
 	char *p;
 	const char * const *result;
 	size_t l = len;
 	int gs = groupsize, rs = rowsize;
 	unsigned int i;
 
-	hex_dump_to_buffer(data_b, l, rs, gs, real, sizeof(real), ascii);
-
 	if (rs != 16 && rs != 32)
 		rs = 16;
 
@@ -73,7 +70,7 @@ static void __init test_hexdump(size_t l
 	else
 		result = test_data_1_le;
 
-	memset(test, ' ', sizeof(test));
+	memset(test, ' ', testlen);
 
 	/* hex dump */
 	p = test;
@@ -95,6 +92,21 @@ static void __init test_hexdump(size_t l
 	}
 
 	*p = '\0';
+}
+
+#define TEST_HEXDUMP_BUF_SIZE		(32 * 3 + 2 + 32 + 1)
+
+static void __init test_hexdump(size_t len, int rowsize, int groupsize,
+				bool ascii)
+{
+	char test[TEST_HEXDUMP_BUF_SIZE];
+	char real[TEST_HEXDUMP_BUF_SIZE];
+
+	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
+			   ascii);
+
+	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
+				  ascii);
 
 	if (strcmp(test, real)) {
 		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

