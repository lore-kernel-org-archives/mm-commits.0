From: akpm@linux-foundation.org
Subject: [merged]
 test_hexdump-test-all-possible-group-sizes-for-overflow.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 14:59:05 -0800
Message-ID: <56a162b9.14epvXcHEBtJO1i6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcAUW7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: test all possible group sizes for overflow
has been removed from the -mm tree.  Its filename was
     test_hexdump-test-all-possible-group-sizes-for-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: test all possible group sizes for overflow

Currently the only one combination is tested for overflow, i.e.  rowsize =
16, groupsize = 1, len = 1.  Do various test to go through all possible
branches.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-test-all-possible-group-sizes-for-overflow lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-test-all-possible-group-sizes-for-overflow
+++ a/lib/test_hexdump.c
@@ -133,7 +133,9 @@ static void __init test_hexdump_set(int
 	test_hexdump(len, rowsize, 1, ascii);
 }
 
-static void __init test_hexdump_overflow(size_t buflen, bool ascii)
+static void __init test_hexdump_overflow(size_t buflen, size_t len,
+					 int rowsize, int groupsize,
+					 bool ascii)
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
@@ -176,6 +178,19 @@ static void __init test_hexdump_overflow
 	}
 }
 
+static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
+{
+	unsigned int i = 0;
+	int rs = (get_random_int() % 2 + 1) * 16;
+
+	do {
+		int gs = 1 << i;
+		size_t len = get_random_int() % rs + gs;
+
+		test_hexdump_overflow(buflen, rounddown(len, gs), rs, gs, ascii);
+	} while (i++ < 3);
+}
+
 static int __init test_hexdump_init(void)
 {
 	unsigned int i;
@@ -192,10 +207,10 @@ static int __init test_hexdump_init(void
 		test_hexdump_set(rowsize, true);
 
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
-		test_hexdump_overflow(i, false);
+		test_hexdump_overflow_set(i, false);
 
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
-		test_hexdump_overflow(i, true);
+		test_hexdump_overflow_set(i, true);
 
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

