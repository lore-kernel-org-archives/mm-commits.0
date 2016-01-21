From: akpm@linux-foundation.org
Subject: [merged] test_hexdump-check-all-bytes-in-real-buffer.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:04 -0800
Message-ID: <56a162b8.AIuEbnCLmvemndRG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcAUW7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: check all bytes in real buffer
has been removed from the -mm tree.  Its filename was
     test_hexdump-check-all-bytes-in-real-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: check all bytes in real buffer

After processing by hex_dump_to_buffer() check all the parts to be expected.

Part 1. The actual expected hex dump with or without ASCII part.

Part 2. Check if the buffer is dirty beyond needed.

Part 3. Return code should be as expected.

This is done by using comparison of the return code and memcmp() against
the test buffer.  We fill the buffer by FILL_CHAR ('#') characters, so, we
expect to have a tail of the buffer will be left untouched.  The
terminating NUL is also checked by memcmp().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-check-all-bytes-in-real-buffer lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-check-all-bytes-in-real-buffer
+++ a/lib/test_hexdump.c
@@ -135,11 +135,10 @@ static void __init test_hexdump_set(int
 
 static void __init test_hexdump_overflow(size_t buflen, bool ascii)
 {
+	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
-	const char *t = test_data_1_le[0];
-	size_t len = 1;
-	int rs = 16, gs = 1;
-	int ae, he, e, r;
+	int rs = rowsize, gs = groupsize;
+	int ae, he, e, f, r;
 	bool a;
 
 	memset(buf, FILL_CHAR, sizeof(buf));
@@ -157,26 +156,23 @@ static void __init test_hexdump_overflow
 		e = ae;
 	else
 		e = he;
-	buf[e + 2] = '\0';
 
-	if (!buflen) {
-		a = r == e && buf[0] == FILL_CHAR;
-	} else if (buflen < 3) {
-		a = r == e && buf[0] == '\0';
-	} else if (buflen < 4) {
-		a = r == e && !strcmp(buf, t);
-	} else if (ascii) {
-		if (buflen < 51)
-			a = r == e && buf[buflen - 1] == '\0' && buf[buflen - 2] == FILL_CHAR;
-		else
-			a = r == e && buf[50] == '\0' && buf[49] == '.';
-	} else {
-		a = r == e && buf[e] == '\0';
+	f = min_t(int, e + 1, buflen);
+	if (buflen) {
+		test_hexdump_prepare_test(len, rs, gs, test, sizeof(test), ascii);
+		test[f - 1] = '\0';
 	}
+	memset(test + f, FILL_CHAR, sizeof(test) - f);
+
+	a = r == e && !memcmp(test, buf, TEST_HEXDUMP_BUF_SIZE);
+
+	buf[sizeof(buf) - 1] = '\0';
 
 	if (!a) {
-		pr_err("Len: %zu rc: %u strlen: %zu\n", buflen, r, strlen(buf));
-		pr_err("Result: '%s'\n", buf);
+		pr_err("Len: %zu buflen: %zu strlen: %zu\n",
+			len, buflen, strnlen(buf, sizeof(buf)));
+		pr_err("Result: %d '%s'\n", r, buf);
+		pr_err("Expect: %d '%s'\n", e, test);
 	}
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

