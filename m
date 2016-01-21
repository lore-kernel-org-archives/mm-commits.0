From: akpm@linux-foundation.org
Subject: [merged]
 test_hexdump-replace-magic-numbers-by-their-meaning.patch removed from -mm
 tree
Date: Thu, 21 Jan 2016 14:59:00 -0800
Message-ID: <56a162b4.UpNTRmC0ks8AvS3Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcAUW7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: test_hexdump: replace magic numbers by their meaning
has been removed from the -mm tree.  Its filename was
     test_hexdump-replace-magic-numbers-by-their-meaning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

