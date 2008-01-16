From: akpm@linux-foundation.org
Subject: + fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch added to -mm tree
Date: Wed, 16 Jan 2008 11:03:22 -0800
Message-ID: <200801161903.m0GJ32c1019215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbYAPTDi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 14:03:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scottwood@freescale.com


The patch titled
     Fix misparenthesization introduced by commit 78b65179d08e7e4466ba69d5ede85035a2c96358
has been added to the -mm tree.  Its filename is
     fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch

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

git-powerpc.patch
git-mtd.patch
fix-misparenthesization-introduced-by-commit-78b65179d08e7e4466ba69d5ede85035a2c96358.patch
