From: akpm@linux-foundation.org
Subject: [to-be-updated] test_hexdump-check-all-bytes-in-real-buffer.patch removed from -mm tree
Date: Wed, 09 Dec 2015 16:23:29 -0800
Message-ID: <5668c601.FAsu3i/blIUr+15P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbbLJAXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:23:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: check all bytes in real buffer
has been removed from the -mm tree.  Its filename was
     test_hexdump-check-all-bytes-in-real-buffer.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: check all bytes in real buffer

After processing by hex_dump_to_buffer() check all the parts to be expected.

Part 1. The actual expected hex dump with or without ASCII part.
	This is provided by plain strcmp() call including check for the
	terminating NUL.

Part 2. Check if the buffer is dirty beyond needed.
	We fill the buffer by ' ' (space) characters, so, we expect to have the
	tail of buffer will be left untouched. Check all bytes in the tail of
	the buffer.

Part 3. Return code should be as expected.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-check-all-bytes-in-real-buffer lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-check-all-bytes-in-real-buffer
+++ a/lib/test_hexdump.c
@@ -128,10 +128,9 @@ static void __init test_hexdump_set(int
 
 static void __init test_hexdump_overflow(size_t buflen, bool ascii)
 {
+	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
-	const char *t = test_data_1_le[0];
 	size_t len = 1;
-	size_t l = buflen;
 	int rs = 16, gs = 1;
 	int ae, he, e, r;
 	bool a;
@@ -147,26 +146,27 @@ static void __init test_hexdump_overflow
 		e = ae;
 	else
 		e = he;
-	buf[e + 2] = '\0';
 
 	if (!buflen) {
-		a = r == e && buf[0] == ' ';
-	} else if (l < 3) {
-		a = r == e && buf[0] == '\0';
-	} else if (l < 4) {
-		a = r == e && !strcmp(buf, t);
-	} else if (ascii) {
-		if (l < 51)
-			a = r == e && buf[l - 1] == '\0' && buf[l - 2] == ' ';
-		else
-			a = r == e && buf[50] == '\0' && buf[49] == '.';
+		memset(test, ' ', sizeof(test));
+		test[sizeof(buf) - 1] = '\0';
+
+		a = r == e && !memchr_inv(buf, ' ', sizeof(buf));
 	} else {
-		a = r == e && buf[e] == '\0';
+		int f = min_t(int, e + 1, buflen);
+
+		test_hexdump_prepare_test(len, rs, gs, test, sizeof(test), ascii);
+		test[f - 1] = '\0';
+
+		a = r == e && !memchr_inv(buf + f, ' ', sizeof(buf) - f) && !strcmp(buf, test);
 	}
 
+	buf[sizeof(buf) - 1] = '\0';
+
 	if (!a) {
-		pr_err("Len: %zu rc: %u strlen: %zu\n", buflen, r, strlen(buf));
-		pr_err("Result: '%s'\n", buf);
+		pr_err("Len: %zu buflen: %zu strlen: %zu\n", len, buflen, strlen(buf));
+		pr_err("Result: %d '%s'\n", r, buf);
+		pr_err("Expect: %d '%s'\n", e, test);
 	}
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

test_hexdump-test-all-possible-group-sizes-for-overflow.patch
test_hexdump-print-statistics-at-the-end.patch

