From: akpm@osdl.org
Subject: + atiixpc-remove-unused-code.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:23:22 -0800
Message-ID: <200701082223.l08MNM1R020666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320AbXAHWXl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:23:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: conke.hu@gmail.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, conke.hu@amd.com, greg@kroah.com


The patch titled
     atiixp.c: remove unused code
has been added to the -mm tree.  Its filename is
     atiixpc-remove-unused-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atiixp.c: remove unused code
From: "Conke Hu" <conke.hu@gmail.com>

A previous patch to atiixp.c was removed but some code has not been
cleaned. Now we remove these code sine they are no use any longer.

Signed-off-by: Conke Hu <conke.hu@amd.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/atiixp.c |   21 +--------------------
 1 files changed, 1 insertion(+), 20 deletions(-)

diff -puN drivers/ide/pci/atiixp.c~atiixpc-remove-unused-code drivers/ide/pci/atiixp.c
--- a/drivers/ide/pci/atiixp.c~atiixpc-remove-unused-code
+++ a/drivers/ide/pci/atiixp.c
@@ -320,19 +320,6 @@ static void __devinit init_hwif_atiixp(i
 	hwif->drives[0].autodma = hwif->autodma;
 }
 
-static void __devinit init_hwif_sb600_legacy(ide_hwif_t *hwif)
-{
-
-	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
-	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
-
-	if (!noautodma)
-		hwif->autodma = 1;
-	hwif->drives[0].autodma = hwif->autodma;
-	hwif->drives[1].autodma = hwif->autodma;
-}
 
 static ide_pci_device_t atiixp_pci_info[] __devinitdata = {
 	{	/* 0 */
@@ -342,13 +329,7 @@ static ide_pci_device_t atiixp_pci_info[
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.bootable	= ON_BOARD,
-	},{	/* 1 */
-		.name		= "ATI SB600 SATA Legacy IDE",
-		.init_hwif	= init_hwif_sb600_legacy,
-		.channels	= 2,
-		.autodma	= AUTODMA,
-		.bootable	= ON_BOARD,
-	}
+	},
 };
 
 /**
_

Patches currently in -mm which might be from conke.hu@gmail.com are

atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
