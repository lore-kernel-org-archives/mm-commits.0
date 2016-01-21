From: akpm@linux-foundation.org
Subject: [merged]
 test_hexdump-go-through-all-possible-lengths-of-buffer.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 14:58:59 -0800
Message-ID: <56a162b3.1aC7TBNQbrahvy5j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcAUW67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: go through all possible lengths of buffer
has been removed from the -mm tree.  Its filename was
     test_hexdump-go-through-all-possible-lengths-of-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: go through all possible lengths of buffer

When test for overflow do iterate the buffer length in a range 0 .. 
BUF_SIZE.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-go-through-all-possible-lengths-of-buffer lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-go-through-all-possible-lengths-of-buffer
+++ a/lib/test_hexdump.c
@@ -133,17 +133,16 @@ static void __init test_hexdump_set(int
 	test_hexdump(len, rowsize, 1, ascii);
 }
 
-static void __init test_hexdump_overflow(bool ascii)
+static void __init test_hexdump_overflow(size_t buflen, bool ascii)
 {
-	char buf[56];
+	char buf[TEST_HEXDUMP_BUF_SIZE];
 	const char *t = test_data_1_le[0];
-	size_t l = get_random_int() % sizeof(buf);
 	bool a;
 	int e, r;
 
 	memset(buf, FILL_CHAR, sizeof(buf));
 
-	r = hex_dump_to_buffer(data_b, 1, 16, 1, buf, l, ascii);
+	r = hex_dump_to_buffer(data_b, 1, 16, 1, buf, buflen, ascii);
 
 	if (ascii)
 		e = 50;
@@ -151,15 +150,15 @@ static void __init test_hexdump_overflow
 		e = 2;
 	buf[e + 2] = '\0';
 
-	if (!l) {
+	if (!buflen) {
 		a = r == e && buf[0] == FILL_CHAR;
-	} else if (l < 3) {
+	} else if (buflen < 3) {
 		a = r == e && buf[0] == '\0';
-	} else if (l < 4) {
+	} else if (buflen < 4) {
 		a = r == e && !strcmp(buf, t);
 	} else if (ascii) {
-		if (l < 51)
-			a = r == e && buf[l - 1] == '\0' && buf[l - 2] == FILL_CHAR;
+		if (buflen < 51)
+			a = r == e && buf[buflen - 1] == '\0' && buf[buflen - 2] == FILL_CHAR;
 		else
 			a = r == e && buf[50] == '\0' && buf[49] == '.';
 	} else {
@@ -167,7 +166,7 @@ static void __init test_hexdump_overflow
 	}
 
 	if (!a) {
-		pr_err("Len: %zu rc: %u strlen: %zu\n", l, r, strlen(buf));
+		pr_err("Len: %zu rc: %u strlen: %zu\n", buflen, r, strlen(buf));
 		pr_err("Result: '%s'\n", buf);
 	}
 }
@@ -187,11 +186,11 @@ static int __init test_hexdump_init(void
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, true);
 
-	for (i = 0; i < 16; i++)
-		test_hexdump_overflow(false);
+	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
+		test_hexdump_overflow(i, false);
 
-	for (i = 0; i < 16; i++)
-		test_hexdump_overflow(true);
+	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
+		test_hexdump_overflow(i, true);
 
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

