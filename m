From: akpm@linux-foundation.org
Subject: + test_hexdump-test-all-possible-group-sizes-for-overflow.patch
 added to -mm tree
Date: Wed, 09 Dec 2015 16:31:11 -0800
Message-ID: <5668c7cf.RBzwJTwcimUxYM8x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbLJAbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:31:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: test all possible group sizes for overflow
has been added to the -mm tree.  Its filename is
     test_hexdump-test-all-possible-group-sizes-for-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_hexdump-test-all-possible-group-sizes-for-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_hexdump-test-all-possible-group-sizes-for-overflow.patch

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

test_hexdump-rename-to-test_hexdump.patch
test_hexdump-introduce-test_hexdump_prepare_test-helper.patch
test_hexdump-define-fill_char-constant.patch
test_hexdump-go-through-all-possible-lengths-of-buffer.patch
test_hexdump-replace-magic-numbers-by-their-meaning.patch
test_hexdump-switch-to-memcmp.patch
test_hexdump-check-all-bytes-in-real-buffer.patch
test_hexdump-test-all-possible-group-sizes-for-overflow.patch
test_hexdump-print-statistics-at-the-end.patch

