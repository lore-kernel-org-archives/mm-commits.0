From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_hexdump-test-all-possible-group-sizes-for-overflow.patch removed from
 -mm tree
Date: Wed, 09 Dec 2015 16:23:31 -0800
Message-ID: <5668c603.J9FQWrXh4R4DZ4o5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbbLJAXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: test all possible group sizes for overflow
has been removed from the -mm tree.  Its filename was
     test_hexdump-test-all-possible-group-sizes-for-overflow.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: test all possible group sizes for overflow

Currently only one combination is tested for overflow, i.e. rowsize = 16,
groupsize = 1, len = 1.  Do various test to go all possible branches.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-test-all-possible-group-sizes-for-overflow lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-test-all-possible-group-sizes-for-overflow
+++ a/lib/test_hexdump.c
@@ -126,12 +126,13 @@ static void __init test_hexdump_set(int
 	test_hexdump(len, rowsize, 1, ascii);
 }
 
-static void __init test_hexdump_overflow(size_t buflen, bool ascii)
+static void __init test_hexdump_overflow(size_t buflen, size_t len,
+					 int rowsize, int groupsize,
+					 bool ascii)
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
-	size_t len = 1;
-	int rs = 16, gs = 1;
+	int rs = rowsize, gs = groupsize;
 	int ae, he, e, r;
 	bool a;
 
@@ -170,6 +171,18 @@ static void __init test_hexdump_overflow
 	}
 }
 
+static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
+{
+	unsigned int i = 0;
+
+	do {
+		int gs = 1 << i;
+		size_t len = get_random_int() % 16 + gs;
+
+		test_hexdump_overflow(buflen, rounddown(len, gs), 16, gs, ascii);
+	} while (i++ < 3);
+}
+
 static int __init test_hexdump_init(void)
 {
 	unsigned int i;
@@ -186,10 +199,10 @@ static int __init test_hexdump_init(void
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

test_hexdump-print-statistics-at-the-end.patch

