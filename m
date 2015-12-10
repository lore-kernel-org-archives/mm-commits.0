From: akpm@linux-foundation.org
Subject: + test_hexdump-replace-magic-numbers-by-their-meaning.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:31:05 -0800
Message-ID: <5668c7c9.7JUjWKrlPYlZnNN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbLJAbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:31:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: replace magic numbers by their meaning
has been added to the -mm tree.  Its filename is
     test_hexdump-replace-magic-numbers-by-their-meaning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_hexdump-replace-magic-numbers-by-their-meaning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_hexdump-replace-magic-numbers-by-their-meaning.patch

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
Subject: test_hexdump: replace magic numbers by their meaning

The magic numbers of the length are converted to their actual meaning,
such as end of the buffer with and without ASCII part.

We don't touch the rest of the magic constants that will be removed in the
following commits.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hexdump.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN lib/test_hexdump.c~test_hexdump-replace-magic-numbers-by-their-meaning lib/test_hexdump.c
--- a/lib/test_hexdump.c~test_hexdump-replace-magic-numbers-by-their-meaning
+++ a/lib/test_hexdump.c
@@ -137,17 +137,26 @@ static void __init test_hexdump_overflow
 {
 	char buf[TEST_HEXDUMP_BUF_SIZE];
 	const char *t = test_data_1_le[0];
+	size_t len = 1;
+	int rs = 16, gs = 1;
+	int ae, he, e, r;
 	bool a;
-	int e, r;
 
 	memset(buf, FILL_CHAR, sizeof(buf));
 
-	r = hex_dump_to_buffer(data_b, 1, 16, 1, buf, buflen, ascii);
+	r = hex_dump_to_buffer(data_b, len, rs, gs, buf, buflen, ascii);
+
+	/*
+	 * Caller must provide the data length multiple of groupsize. The
+	 * calculations below are made with that assumption in mind.
+	 */
+	ae = rs * 2 /* hex */ + rs / gs /* spaces */ + 1 /* space */ + len /* ascii */;
+	he = (gs * 2 /* hex */ + 1 /* space */) * len / gs - 1 /* no trailing space */;
 
 	if (ascii)
-		e = 50;
+		e = ae;
 	else
-		e = 2;
+		e = he;
 	buf[e + 2] = '\0';
 
 	if (!buflen) {
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

