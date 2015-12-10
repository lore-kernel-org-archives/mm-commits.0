From: akpm@linux-foundation.org
Subject: + test_hexdump-define-fill_char-constant.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:31:01 -0800
Message-ID: <5668c7c5.xXkveafqWEmss+Vm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLJAbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:31:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: define FILL_CHAR constant
has been added to the -mm tree.  Its filename is
     test_hexdump-define-fill_char-constant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_hexdump-define-fill_char-constant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_hexdump-define-fill_char-constant.patch

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

test_hexdump-rename-to-test_hexdump.patch
test_hexdump-introduce-test_hexdump_prepare_test-helper.patch
test_hexdump-define-fill_char-constant.patch
test_hexdump-go-through-all-possible-lengths-of-buffer.patch
test_hexdump-replace-magic-numbers-by-their-meaning.patch
test_hexdump-switch-to-memcmp.patch
test_hexdump-check-all-bytes-in-real-buffer.patch
test_hexdump-test-all-possible-group-sizes-for-overflow.patch
test_hexdump-print-statistics-at-the-end.patch

