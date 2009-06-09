From: akpm@linux-foundation.org
Subject: [merged] davinci_nand-cmdlinepart-uses-mtd-ids.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:12 -0700
Message-ID: <200906091812.n59ICCm3018486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbZFISMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, nsnehaprabha@ti.com, mm-commits@vger.kernel.org


The patch titled
     davinci_nand: cmdlinepart uses MTD IDs
has been removed from the -mm tree.  Its filename was
     davinci_nand-cmdlinepart-uses-mtd-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci_nand: cmdlinepart uses MTD IDs
From: David Brownell <dbrownell@users.sourceforge.net>

Remove some legacy code from the davinci_nand driver, which made
cmdlinepart ignore the the MTD ID passed to it.  Boards can have multiple
NAND chips, and some do (like the DM357 EVM), so this dated hack is
undesirable.

Correct labels a"re like davinci_nand.0" (for chipselect 0).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Snehaprabha Narnakaje <nsnehaprabha@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~davinci_nand-cmdlinepart-uses-mtd-ids drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~davinci_nand-cmdlinepart-uses-mtd-ids
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -717,19 +717,8 @@ syndrome_done:
 			static const char *probes[] __initconst =
 				{ "cmdlinepart", NULL };
 
-			const char		*master_name;
-
-			/* Set info->mtd.name = 0 temporarily */
-			master_name		= info->mtd.name;
-			info->mtd.name		= (char *)0;
-
-			/* info->mtd.name == 0, means: don't bother checking
-			   <mtd-id> */
 			mtd_parts_nb = parse_mtd_partitions(&info->mtd, probes,
 							    &mtd_parts, 0);
