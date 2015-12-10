From: akpm@linux-foundation.org
Subject: + test_hexdump-switch-to-memcmp.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:31:07 -0800
Message-ID: <5668c7cb.i0L9VnmQkqMU2V0i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbLJAbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:31:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: switch to memcmp()
has been added to the -mm tree.  Its filename is
     test_hexdump-switch-to-memcmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_hexdump-switch-to-memcmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_hexdump-switch-to-memcmp.patch

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
Subject: test_hexdump: switch to memcmp()

Better to use memcmp() against entire buffer to check that nothing is
happened to the data in the tail.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-switch-to-memcmp lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-switch-to-memcmp
+++ a/lib/test_hexdump.c
@@ -72,8 +72,6 @@ static void __init test_hexdump_prepare_
 	else
 		result = test_data_1_le;
 
-	memset(test, FILL_CHAR, testlen);
-
 	/* hex dump */
 	p = test;
 	for (i = 0; i < l / gs; i++) {
@@ -109,13 +107,15 @@ static void __init test_hexdump(size_t l
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char real[TEST_HEXDUMP_BUF_SIZE];
 
+	memset(real, FILL_CHAR, sizeof(real));
 	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
 			   ascii);
 
+	memset(test, FILL_CHAR, sizeof(test));
 	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
 				  ascii);
 
-	if (strcmp(test, real)) {
+	if (memcmp(test, real, TEST_HEXDUMP_BUF_SIZE)) {
 		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
 		pr_err("Result: '%s'\n", real);
 		pr_err("Expect: '%s'\n", test);
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

