From: akpm@linux-foundation.org
Subject: [merged] hexdump-do-few-calculations-ahead.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:38 -0800
Message-ID: <54de5d0e.LSs1pWFVkV8lK8sr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbbBMUWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: do a few calculations ahead
has been removed from the -mm tree.  Its filename was
     hexdump-do-few-calculations-ahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
