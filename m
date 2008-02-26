From: akpm@linux-foundation.org
Subject: + sm501-remove-a-duplicated-table.patch added to -mm tree
Date: Tue, 26 Feb 2008 11:15:19 -0800
Message-ID: <200802261916.m1QJGB2j004179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761540AbYBZTQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Feb 2008 14:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, ben-linux@fluff.org


The patch titled
     sm501: remove a duplicated table
has been added to the -mm tree.  Its filename is
     sm501-remove-a-duplicated-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: remove a duplicated table
From: Ville Syrjala <syrjala@sci.fi>

misc_div is a subset of px_div so eliminate the smaller table.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   45 ++++++++++++------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-remove-a-duplicated-table drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-remove-a-duplicated-table
+++ a/drivers/mfd/sm501.c
@@ -53,26 +53,7 @@ struct sm501_devdata {
 #define MHZ (1000 * 1000)
 
 #ifdef DEBUG
-static const unsigned int misc_div[] = {
-	[0]		= 1,
-	[1]		= 2,
-	[2]		= 4,
-	[3]		= 8,
-	[4]		= 16,
-	[5]		= 32,
-	[6]		= 64,
-	[7]		= 128,
-	[8]		= 3,
-	[9]		= 6,
-	[10]		= 12,
-	[11]		= 24,
-	[12]		= 48,
-	[13]		= 96,
-	[14]		= 192,
-	[15]		= 384,
-};
-
-static const unsigned int px_div[] = {
+static const unsigned int div_tab[] = {
 	[0]		= 1,
 	[1]		= 2,
 	[2]		= 4,
@@ -101,12 +82,12 @@ static const unsigned int px_div[] = {
 
 static unsigned long decode_div(unsigned long pll2, unsigned long val,
 				unsigned int lshft, unsigned int selbit,
-				unsigned long mask, const unsigned int *dtab)
+				unsigned long mask)
 {
 	if (val & selbit)
 		pll2 = 288 * MHZ;
 
-	return pll2 / dtab[(val >> lshft) & mask];
+	return pll2 / div_tab[(val >> lshft) & mask];
 }
 
 #define fmt_freq(x) ((x) / MHZ), ((x) % MHZ), (x)
@@ -141,10 +122,10 @@ static void sm501_dump_clk(struct sm501_
 	}
 
 	sdclk0 = (misct & (1<<12)) ? pll2 : 288 * MHZ;
-	sdclk0 /= misc_div[((misct >> 8) & 0xf)];
+	sdclk0 /= div_tab[((misct >> 8) & 0xf)];
 
 	sdclk1 = (misct & (1<<20)) ? pll2 : 288 * MHZ;
-	sdclk1 /= misc_div[((misct >> 16) & 0xf)];
+	sdclk1 /= div_tab[((misct >> 16) & 0xf)];
 
 	dev_dbg(sm->dev, "MISCT=%08lx, PM0=%08lx, PM1=%08lx\n",
 		misct, pm0, pm1);
@@ -158,19 +139,19 @@ static void sm501_dump_clk(struct sm501_
 		 "P2 %ld.%ld MHz (%ld), V2 %ld.%ld (%ld), "
 		 "M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\n",
 		 (pmc & 3 ) == 0 ? '*' : '-',
-		 fmt_freq(decode_div(pll2, pm0, 24, 1<<29, 31, px_div)),
-		 fmt_freq(decode_div(pll2, pm0, 16, 1<<20, 15, misc_div)),
-		 fmt_freq(decode_div(pll2, pm0, 8,  1<<12, 15, misc_div)),
-		 fmt_freq(decode_div(pll2, pm0, 0,  1<<4,  15, misc_div)));
+		 fmt_freq(decode_div(pll2, pm0, 24, 1<<29, 31)),
+		 fmt_freq(decode_div(pll2, pm0, 16, 1<<20, 15)),
+		 fmt_freq(decode_div(pll2, pm0, 8,  1<<12, 15)),
+		 fmt_freq(decode_div(pll2, pm0, 0,  1<<4,  15)));
 
 	dev_dbg(sm->dev, "PM1[%c]: "
 		"P2 %ld.%ld MHz (%ld), V2 %ld.%ld (%ld), "
 		"M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\n",
 		(pmc & 3 ) == 1 ? '*' : '-',
-		fmt_freq(decode_div(pll2, pm1, 24, 1<<29, 31, px_div)),
-		fmt_freq(decode_div(pll2, pm1, 16, 1<<20, 15, misc_div)),
-		fmt_freq(decode_div(pll2, pm1, 8,  1<<12, 15, misc_div)),
-		fmt_freq(decode_div(pll2, pm1, 0,  1<<4,  15, misc_div)));
+		fmt_freq(decode_div(pll2, pm1, 24, 1<<29, 31)),
+		fmt_freq(decode_div(pll2, pm1, 16, 1<<20, 15)),
+		fmt_freq(decode_div(pll2, pm1, 8,  1<<12, 15)),
+		fmt_freq(decode_div(pll2, pm1, 0,  1<<4,  15)));
 }
 
 static void sm501_dump_regs(struct sm501_devdata *sm)
_

Patches currently in -mm which might be from syrjala@sci.fi are

sm501fb-direct-color-visual-does-not-work.patch
sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
sm501fb-fix-timing-limits.patch
sm501-remove-a-duplicated-table.patch
sm501-add-support-for-the-sm502-programmable-pll.patch
