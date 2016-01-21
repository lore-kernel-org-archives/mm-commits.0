From: akpm@linux-foundation.org
Subject: [merged] test_hexdump-switch-to-memcmp.patch removed from -mm
 tree
Date: Thu, 21 Jan 2016 14:59:02 -0800
Message-ID: <56a162b6.3sSPFAB2h7Ap2VDt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbcAUW7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: switch to memcmp()
has been removed from the -mm tree.  Its filename was
     test_hexdump-switch-to-memcmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

