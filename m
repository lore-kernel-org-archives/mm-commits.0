From: akpm@linux-foundation.org
Subject: + pata_pdc202xx_old-fix-data-corruption-and-other-problems.patch added to -mm tree
Date: Mon, 05 Mar 2007 21:06:37 -0800
Message-ID: <200703060506.l2656bRj012576@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51155 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbXCFFGu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 00:06:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, alan@redhat.com


The patch titled
     pata_pdc202xx_old: fix data corruption and other problems
has been added to the -mm tree.  Its filename is
     pata_pdc202xx_old-fix-data-corruption-and-other-problems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_pdc202xx_old: fix data corruption and other problems
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Fix wrong "port" calculations in pdc202xx_{configure_piomode,set_dmamode}()
They were broken for all configurations except one (master device on
primary channel, no other devices) and as a result device settings +
PIO/DMA timings were being programmed into the wrong PCI registers.  This
could result in a large variety of problems including data corruption,
hangs etc.  (depending on devices used and your luck :-).

  ap->port_no   ap->devno   used PCI registers   correct PCI registers
            0           0            0x60-0x62               0x60-0x62
            0           1            0x62-0x64               0x64-0x66
            1           0            0x64-0x66               0x68-0x6a
            1           1            0x66-0x68               0x6c-0x6e

Also forward port recent fixes from drivers/ide pdc202xx_old driver:

* fix XFER_MW_DMA0 timings (they were overclocked, use the official ones)

* fix bitmasks for clearing bits of register B:

  - when programming DMA mode bit 0x10 of register B was cleared which
    resulted in overclocked PIO timing setting (iff PIO0 was used)

  - when programming PIO mode bits 0x18 weren't cleared so suboptimal
    timings were used for PIO1-4 if PIO0 was previously set (bit 0x10)
    and for PIO0/3/4 if PIO1/2 was previously set (bit 0x08)

and finally bump driver version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc202xx_old.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-fix-data-corruption-and-other-problems drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-fix-data-corruption-and-other-problems
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -2,13 +2,14 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
+ *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
  * First cut with LBA48/ATAPI
  *
  * TODO:
- *	Channel interlock/reset on both required ?
+ *	Channel interlock/reset on both required
  */
 
 #include <linux/kernel.h>
@@ -21,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_pdc202xx_old"
-#define DRV_VERSION "0.3.0"
+#define DRV_VERSION "0.4.0"
 
 /**
  *	pdc2024x_pre_reset		-	probe begin
@@ -76,7 +77,7 @@ static void pdc2026x_error_handler(struc
 static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *adev, int pio)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 4 * ap->port_no + 2 * adev->devno;
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u16 pio_timing[5] = {
 		0x0913, 0x050C , 0x0308, 0x0206, 0x0104
 	};
@@ -85,7 +86,7 @@ static void pdc202xx_configure_piomode(s
 	pci_read_config_byte(pdev, port, &r_ap);
 	pci_read_config_byte(pdev, port + 1, &r_bp);
 	r_ap &= ~0x3F;	/* Preserve ERRDY_EN, SYNC_IN */
-	r_bp &= ~0x07;
+	r_bp &= ~0x1F;
 	r_ap |= (pio_timing[pio] >> 8);
 	r_bp |= (pio_timing[pio] & 0xFF);
 
@@ -123,7 +124,7 @@ static void pdc202xx_set_piomode(struct 
 static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 4 * ap->port_no + 2 * adev->devno;
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u8 udma_timing[6][2] = {
 		{ 0x60, 0x03 },	/* 33 Mhz Clock */
 		{ 0x40, 0x02 },
@@ -132,12 +133,17 @@ static void pdc202xx_set_dmamode(struct 
 		{ 0x20, 0x01 },
 		{ 0x20, 0x01 }
 	};
+	static u8 mdma_timing[3][2] = {
+		{ 0x60, 0x03 },
+		{ 0x60, 0x04 },
+		{ 0xe0, 0x0f },
+	};
 	u8 r_bp, r_cp;
 
 	pci_read_config_byte(pdev, port + 1, &r_bp);
 	pci_read_config_byte(pdev, port + 2, &r_cp);
 
-	r_bp &= ~0xF0;
+	r_bp &= ~0xE0;
 	r_cp &= ~0x0F;
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
@@ -147,8 +153,8 @@ static void pdc202xx_set_dmamode(struct 
 
 	} else {
 		int speed = adev->dma_mode - XFER_MW_DMA_0;
-		r_bp |= 0x60;
-		r_cp |= (5 - speed);
+		r_bp |= mdma_timing[speed][0];
+		r_cp |= mdma_timing[speed][1];
 	}
 	pci_write_config_byte(pdev, port + 1, r_bp);
 	pci_write_config_byte(pdev, port + 2, r_cp);
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
pata_pdc202xx_old-fix-data-corruption-and-other-problems.patch
