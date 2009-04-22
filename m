From: akpm@linux-foundation.org
Subject: + mtd-nand-dont-walk-past-end-of-oobfree.patch added to -mm tree
Date: Tue, 21 Apr 2009 20:37:25 -0700
Message-ID: <200904220337.n3M3bPN1004603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZDVDlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 23:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, dwmw2@infradead.org, nsnehaprabha@ti.com


The patch titled
     mtd: nand: don't walk past end of oobfree[]
has been added to the -mm tree.  Its filename is
     mtd-nand-dont-walk-past-end-of-oobfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: nand: don't walk past end of oobfree[]
From: David Brownell <dbrownell@users.sourceforge.net>

Resolve issue noted by Sneha: when computing oobavail from the list of
free areas in the OOB, don't assume there will always be an unused slot at
the end.  With ECC_HW_SYNDROME and 4KB page chips, it's fairly likely
there *won't* be one.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>"
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/nand/nand_base.c~mtd-nand-dont-walk-past-end-of-oobfree drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-nand-dont-walk-past-end-of-oobfree
+++ a/drivers/mtd/nand/nand_base.c
@@ -2756,7 +2756,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 	 * the out of band area
 	 */
 	chip->ecc.layout->oobavail = 0;
-	for (i = 0; chip->ecc.layout->oobfree[i].length; i++)
+	for (i = 0; chip->ecc.layout->oobfree[i].length
+			&& i < ARRAY_SIZE(chip->ecc.layout->oobfree); i++)
 		chip->ecc.layout->oobavail +=
 			chip->ecc.layout->oobfree[i].length;
 	mtd->oobavail = chip->ecc.layout->oobavail;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
pxa2xx_spi-restore-drcmr-on-resume.patch
spi-documentation-emphasise-spi_mastersetup-semantics.patch
linux-next.patch
mtd-nand-dont-walk-past-end-of-oobfree.patch
mtd-nand-minor-davinci_nand-cleanup.patch
mtd-nand-davinci_nand-4-bit-ecc-for-smallpage.patch
spi_bfin5xx-limit-reaches-1.patch
spi-move-common-spi_setup-functionality-into-core.patch
spi-move-more-spi_setup-functionality-into-core.patch
rtc-rtc-ds1307-add-ds3231.patch

