From: akpm@linux-foundation.org
Subject: [merged] test_hexdump-define-fill_char-constant.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:58:56 -0800
Message-ID: <56a162b0.BdHZWLGt/GUsoL8G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcAUW65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: define FILL_CHAR constant
has been removed from the -mm tree.  Its filename was
     test_hexdump-define-fill_char-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: test_hexdump: define FILL_CHAR constant

Define a character to fill the test buffers.  Though the character should
be printable since it's used when errors are reported.  It should neither
be from hex digit [a-fA-F0-9] dictionary nor space.  It is recommended not
to use one which is present in ASCII part of the test data.  Later on we
might switch to unprintable character to make test case more robust.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-define-fill_char-constant lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-define-fill_char-constant
+++ a/lib/test_hexdump.c
@@ -42,6 +42,8 @@ static const char * const test_data_8_le
 	"e9ac0f9cad319ca6", "0cafb1439919d14c",
 };
 
+#define FILL_CHAR	'#'
+
 static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 					     int groupsize, char *test,
 					     size_t testlen, bool ascii)
@@ -70,7 +72,7 @@ static void __init test_hexdump_prepare_
 	else
 		result = test_data_1_le;
 
-	memset(test, ' ', testlen);
+	memset(test, FILL_CHAR, testlen);
 
 	/* hex dump */
 	p = test;
@@ -79,14 +81,19 @@ static void __init test_hexdump_prepare_
 		size_t amount = strlen(q);
 
 		strncpy(p, q, amount);
-		p += amount + 1;
+		p += amount;
+
+		*p++ = ' ';
 	}
 	if (i)
 		p--;
 
 	/* ASCII part */
 	if (ascii) {
-		p = test + rs * 2 + rs / gs + 1;
+		do {
+			*p++ = ' ';
+		} while (p < test + rs * 2 + rs / gs + 1);
+
 		strncpy(p, data_a, l);
 		p += l;
 	}
@@ -134,7 +141,7 @@ static void __init test_hexdump_overflow
 	bool a;
 	int e, r;
 
-	memset(buf, ' ', sizeof(buf));
+	memset(buf, FILL_CHAR, sizeof(buf));
 
 	r = hex_dump_to_buffer(data_b, 1, 16, 1, buf, l, ascii);
 
@@ -145,14 +152,14 @@ static void __init test_hexdump_overflow
 	buf[e + 2] = '\0';
 
 	if (!l) {
-		a = r == e && buf[0] == ' ';
+		a = r == e && buf[0] == FILL_CHAR;
 	} else if (l < 3) {
 		a = r == e && buf[0] == '\0';
 	} else if (l < 4) {
 		a = r == e && !strcmp(buf, t);
 	} else if (ascii) {
 		if (l < 51)
-			a = r == e && buf[l - 1] == '\0' && buf[l - 2] == ' ';
+			a = r == e && buf[l - 1] == '\0' && buf[l - 2] == FILL_CHAR;
 		else
 			a = r == e && buf[50] == '\0' && buf[49] == '.';
 	} else {
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

