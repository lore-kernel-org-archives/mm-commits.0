From: akpm@osdl.org
Subject: + atiixpc-add-cable-detection-support-for-ati-ide.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:23:26 -0800
Message-ID: <200701082223.l08MNQm8020672@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030332AbXAHWXg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:23:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: conke.hu@gmail.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, conke.hu@amd.com, greg@kroah.com


The patch titled
     atiixp.c: add cable detection support for ATI IDE
has been added to the -mm tree.  Its filename is
     atiixpc-add-cable-detection-support-for-ati-ide.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atiixp.c: add cable detection support for ATI IDE
From: "Conke Hu" <conke.hu@gmail.com>

IDE HDD does not work if it uses a 40-pin PATA cable on ATI chipset.
This patch fixes the bug.

Signed-off-by: Conke Hu <conke.hu@amd.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/atiixp.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/ide/pci/atiixp.c~atiixpc-add-cable-detection-support-for-ati-ide drivers/ide/pci/atiixp.c
--- a/drivers/ide/pci/atiixp.c~atiixpc-add-cable-detection-support-for-ati-ide
+++ a/drivers/ide/pci/atiixp.c
@@ -291,8 +291,12 @@ fast_ata_pio:
 
 static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 {
+	u8 udma_mode = 0;
+	u8 ch = hwif->channel;
+	struct pci_dev *pdev = hwif->pci_dev;
+
 	if (!hwif->irq)
-		hwif->irq = hwif->channel ? 15 : 14;
+		hwif->irq = ch ? 15 : 14;
 
 	hwif->autodma = 0;
 	hwif->tuneproc = &atiixp_tuneproc;
@@ -308,8 +312,12 @@ static void __devinit init_hwif_atiixp(i
 	hwif->mwdma_mask = 0x06;
 	hwif->swdma_mask = 0x04;
 
-	/* FIXME: proper cable detection needed */
-	hwif->udma_four = 1;
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
+	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
+		hwif->udma_four = 1;
+	else
+		hwif->udma_four = 0;
+
 	hwif->ide_dma_host_on = &atiixp_ide_dma_host_on;
 	hwif->ide_dma_host_off = &atiixp_ide_dma_host_off;
 	hwif->ide_dma_check = &atiixp_dma_check;
_

Patches currently in -mm which might be from conke.hu@gmail.com are

atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
