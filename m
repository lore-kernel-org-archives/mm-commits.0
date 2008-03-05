From: akpm@linux-foundation.org
Subject: - sm501-remove-a-duplicated-table.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:37 -0800
Message-ID: <200803050744.m257ib1V021526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764702AbYCEHpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     sm501: remove a duplicated table
has been removed from the -mm tree.  Its filename was
     sm501-remove-a-duplicated-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


