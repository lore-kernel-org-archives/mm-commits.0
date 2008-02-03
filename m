From: akpm@linux-foundation.org
Subject: - fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:14 -0800
Message-ID: <200802032021.m13KLtR1029962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbYBCUWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Fix misparenthesization introduced by commit 78b65179d08e7e4466ba69d5ede85035a2c96358
has been removed from the -mm tree.  Its filename was
     fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix misparenthesization introduced by commit 78b65179d08e7e4466ba69d5ede85035a2c96358
From: Scott Wood <scottwood@freescale.com>

Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358 drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358
+++ a/drivers/mtd/nand/nand_base.c
@@ -2472,9 +2472,9 @@ int nand_scan_tail(struct mtd_info *mtd)
 		if ((!chip->ecc.calculate || !chip->ecc.correct ||
 		     !chip->ecc.hwctl) &&
 		    (!chip->ecc.read_page ||
-		     chip->ecc.read_page == nand_read_page_hwecc) ||
+		     chip->ecc.read_page == nand_read_page_hwecc ||
 		     !chip->ecc.write_page ||
-		     chip->ecc.write_page == nand_write_page_hwecc) {
+		     chip->ecc.write_page == nand_write_page_hwecc)) {
 			printk(KERN_WARNING "No ECC functions supplied, "
 			       "Hardware ECC not possible\n");
 			BUG();
_

Patches currently in -mm which might be from scottwood@freescale.com are

origin.patch
git-mtd.patch
