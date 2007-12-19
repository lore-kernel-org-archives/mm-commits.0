From: akpm@linux-foundation.org
Subject: + sata_mv-improve-warnings-about-highpoint-rocketraid-23xx-cards.patch added to -mm tree
Date: Tue, 18 Dec 2007 16:06:37 -0800
Message-ID: <200712190006.lBJ06bLE028834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbXLSAHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 19:07:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liml@rtr.ca, mlord@pobox.com


The patch titled
     sata_mv: improve warnings about Highpoint RocketRAID 23xx cards
has been added to the -mm tree.  Its filename is
     sata_mv-improve-warnings-about-highpoint-rocketraid-23xx-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_mv: improve warnings about Highpoint RocketRAID 23xx cards
From: Mark Lord <liml@rtr.ca>

Improve the existing boot/load time warnings from sata_mv for Highpoint
RocketRAID 23xx cards, based on new knowledge about where the BIOS likes to
overwrite sectors with metadata.

Harmless to us, but very useful for end users.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff -puN drivers/ata/sata_mv.c~sata_mv-improve-warnings-about-highpoint-rocketraid-23xx-cards drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~sata_mv-improve-warnings-about-highpoint-rocketraid-23xx-cards
+++ a/drivers/ata/sata_mv.c
@@ -2506,11 +2506,31 @@ static int mv_chip_id(struct ata_host *h
 		if (pdev->vendor == PCI_VENDOR_ID_TTI &&
 		    (pdev->device == 0x2300 || pdev->device == 0x2310))
 		{
-			printk(KERN_WARNING "sata_mv: Highpoint RocketRAID BIOS"
-				" will CORRUPT DATA on attached drives when"
-				" configured as \"Legacy\".  BEWARE!\n");
-			printk(KERN_WARNING "sata_mv: Use BIOS \"JBOD\" volumes"
-				" instead for safety.\n");
+			/*
+			 * Highpoint RocketRAID PCIe 23xx series cards:
+			 *
+			 * Unconfigured drives are treated as "Legacy"
+			 * by the BIOS, and it overwrites sector 8 with
+			 * a "Lgcy" metadata block prior to Linux boot.
+			 *
+			 * Configured drives (RAID or JBOD) leave sector 8
+			 * alone, but instead overwrite a high numbered
+			 * sector for the RAID metadata.  This sector can
+			 * be determined exactly, by truncating the physical
+			 * drive capacity to a nice even GB value.
+			 *
+			 * RAID metadata is at: (dev->n_sectors & ~0xfffff)
+			 *
+			 * Warn the user, lest they think we're just buggy.
+			 */
+			printk(KERN_WARNING DRV_NAME ": Highpoint RocketRAID"
+				" BIOS CORRUPTS DATA on all attached drives,"
+				" regardless of if/how they are configured."
+				" BEWARE!\n");
+			printk(KERN_WARNING DRV_NAME ": For data safety, do not"
+				" use sectors 8-9 on \"Legacy\" drives,"
+				" and avoid the final two gigabytes on"
+				" all RocketRAID BIOS initialized drives.\n");
 		}
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
_

Patches currently in -mm which might be from liml@rtr.ca are

sata_mv-improve-warnings-about-highpoint-rocketraid-23xx-cards.patch
