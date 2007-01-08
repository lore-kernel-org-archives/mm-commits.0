From: akpm@osdl.org
Subject: + atiixpc-sb600-ide-only-has-one-channel.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:23:24 -0800
Message-ID: <200701082223.l08MNOpx020669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030342AbXAHWXg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:23:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: conke.hu@gmail.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, conke.hu@amd.com, greg@kroah.com


The patch titled
     atiixp.c: sb600 ide only has one channel
has been added to the -mm tree.  Its filename is
     atiixpc-sb600-ide-only-has-one-channel.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atiixp.c: sb600 ide only has one channel
From: "Conke Hu" <conke.hu@gmail.com>

AMD/ATI SB600 IDE/PATA controller only has one channel.

Signed-off-by: Conke Hu <conke.hu@amd.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/atiixp.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/ide/pci/atiixp.c~atiixpc-sb600-ide-only-has-one-channel drivers/ide/pci/atiixp.c
--- a/drivers/ide/pci/atiixp.c~atiixpc-sb600-ide-only-has-one-channel
+++ a/drivers/ide/pci/atiixp.c
@@ -329,7 +329,14 @@ static ide_pci_device_t atiixp_pci_info[
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
 		.bootable	= ON_BOARD,
-	},
+	},{	/* 1 */
+		.name		= "SB600_PATA",
+		.init_hwif	= init_hwif_atiixp,
+		.channels	= 1,
+		.autodma	= AUTODMA,
+		.enablebits	= {{0x48,0x01,0x00}, {0x00,0x00,0x00}},
+ 		.bootable	= ON_BOARD,
+ 	},
 };
 
 /**
@@ -350,7 +357,7 @@ static struct pci_device_id atiixp_pci_t
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP200_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
_

Patches currently in -mm which might be from conke.hu@gmail.com are

atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
