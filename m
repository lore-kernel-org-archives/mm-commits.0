From: akpm@linux-foundation.org
Subject: + hexdump-do-few-calculations-ahead.patch added to -mm tree
Date: Mon, 29 Dec 2014 14:15:56 -0800
Message-ID: <54a1d29c.jsgqA9hCkVJvWxFp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaL2WP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 17:15:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: do a few calculations ahead
has been added to the -mm tree.  Its filename is
     hexdump-do-few-calculations-ahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-do-few-calculations-ahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-do-few-calculations-ahead.patch

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
Subject: hexdump: do a few calculations ahead

Instead of doing calculations in each case of different groupsize let's do
them beforehand.  While there, change the switch to an if-else-if
construction.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff -puN lib/hexdump.c~hexdump-do-few-calculations-ahead lib/hexdump.c
--- a/lib/hexdump.c~hexdump-do-few-calculations-ahead
+++ a/lib/hexdump.c
@@ -103,6 +103,7 @@ void hex_dump_to_buffer(const void *buf,
 			bool ascii)
 {
 	const u8 *ptr = buf;
+	int ngroups;
 	u8 ch;
 	int j, lx = 0;
 	int ascii_column;
@@ -114,45 +115,33 @@ void hex_dump_to_buffer(const void *buf,
 		goto nil;
 	if (len > rowsize)		/* limit to one line at a time */
 		len = rowsize;
+	if (!is_power_of_2(groupsize) || groupsize > 8)
+		groupsize = 1;
 	if ((len % groupsize) != 0)	/* no mixed size output */
 		groupsize = 1;
 
-	switch (groupsize) {
-	case 8: {
+	ngroups = len / groupsize;
+	ascii_column = rowsize * 2 + rowsize / groupsize + 1;
+	if (groupsize == 8) {
 		const u64 *ptr8 = buf;
-		int ngroups = len / groupsize;
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%16.16llx", j ? " " : "",
 					(unsigned long long)*(ptr8 + j));
-		ascii_column = rowsize * 2 + rowsize / 8 + 2;
-		break;
-	}
-
-	case 4: {
+	} else if (groupsize == 4) {
 		const u32 *ptr4 = buf;
-		int ngroups = len / groupsize;
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%8.8x", j ? " " : "", *(ptr4 + j));
-		ascii_column = rowsize * 2 + rowsize / 4 + 2;
-		break;
-	}
-
-	case 2: {
+	} else if (groupsize == 2) {
 		const u16 *ptr2 = buf;
-		int ngroups = len / groupsize;
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
 					"%s%4.4x", j ? " " : "", *(ptr2 + j));
-		ascii_column = rowsize * 2 + rowsize / 2 + 2;
-		break;
-	}
-
-	default:
+	} else {
 		for (j = 0; (j < len) && (lx + 3) <= linebuflen; j++) {
 			ch = ptr[j];
 			linebuf[lx++] = hex_asc_hi(ch);
@@ -161,14 +150,11 @@ void hex_dump_to_buffer(const void *buf,
 		}
 		if (j)
 			lx--;
