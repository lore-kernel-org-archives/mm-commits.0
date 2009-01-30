From: akpm@linux-foundation.org
Subject: + pata_amd-program-fifo.patch added to -mm tree
Date: Thu, 29 Jan 2009 16:36:08 -0800
Message-ID: <200901300036.n0U0a8L7002545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbZA3Agg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 19:36:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk


The patch titled
     pata_amd: program FIFO
has been added to the -mm tree.  Its filename is
     pata_amd-program-fifo.patch

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
Subject: pata_amd: program FIFO
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

With 32bit PIO we can use the posted write buffers, but only for 32bit I/O
cycles.  This means we must disable the FIFO for ATAPI where a final 16bit
cycle may occur.

Rework the FIFO logic so that we disable the FIFO then selectively
re-enable it when we set the timings on AMD devices.  Also fix a case
where we scribbled on PCI config 0x41 of Nvidia chips when we shouldn't.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |   76 ++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-program-fifo drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-program-fifo
+++ a/drivers/ata/pata_amd.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.11"
+#define DRV_VERSION "0.4.1"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -145,6 +145,13 @@ static int amd_pre_reset(struct ata_link
 	return ata_sff_prereset(link, deadline);
 }
 
+/**
+ *	amd_cable_detect	-	report cable type
+ *	@ap: port
+ *
+ *	AMD controller/BIOS setups record the cable type in word 0x42
+ */
+
 static int amd_cable_detect(struct ata_port *ap)
 {
 	static const u32 bitmask[2] = {0x03, 0x0C};
@@ -158,6 +165,40 @@ static int amd_cable_detect(struct ata_p
 }
 
 /**
+ *	amd_fifo_setup		-	set the PIO FIFO for ATA/ATAPI
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Set the PCI fifo for this device according to the devices present
+ *	on the bus at this point in time. We need to turn the post write buffer
+ *	off for ATAPI devices as we may need to issue a word sized write to the
+ *	device as the final I/O
+ */
+
+static void amd_fifo_setup(struct ata_port *ap)
+{
+	struct ata_device *adev;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static const u8 fifobit[2] = { 0xC0, 0x30};
+	u8 fifo = fifobit[ap->port_no];
+	u8 r;
+
+
+	ata_for_each_dev(adev, &ap->link, ENABLED) {
+		if (adev->class == ATA_DEV_ATAPI)
+			fifo = 0;
+	}
+	if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411) /* FIFO is broken */
+		fifo = 0;
+
+	/* On the later chips the read prefetch bits become no-op bits */
+	pci_read_config_byte(pdev, 0x41, &r);
+	r &= ~fifobit[ap->port_no];
+	r |= fifo;
+	pci_write_config_byte(pdev, 0x41, r);
+}
+
+/**
  *	amd33_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -167,21 +208,25 @@ static int amd_cable_detect(struct ata_p
 
 static void amd33_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 1);
 }
 
 static void amd66_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 2);
 }
 
 static void amd100_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 3);
 }
 
 static void amd133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 4);
 }
 
@@ -397,6 +442,16 @@ static struct ata_port_operations nv133_
 	.set_dmamode	= nv133_set_dmamode,
 };
 
+static void amd_clear_fifo(struct pci_dev *pdev)
+{
+	u8 fifo;
+	/* Disable the FIFO, the FIFO logic will re-enable it as
+	   appropriate */
+	pci_read_config_byte(pdev, 0x41, &fifo);
+	fifo &= 0x0F;
+	pci_write_config_byte(pdev, 0x41, fifo);
+}
+
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info[10] = {
@@ -503,14 +558,8 @@ static int amd_init_one(struct pci_dev *
 
 	if (type < 3)
 		ata_pci_bmdma_clear_simplex(pdev);
-
-	/* Check for AMD7411 */
-	if (type == 3)
-		/* FIFO is broken */
-		pci_write_config_byte(pdev, 0x41, fifo & 0x0F);
-	else
-		pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
-
+	if (pdev->vendor == PCI_VENDOR_ID_AMD)
+		amd_clear_fifo(pdev);
 	/* Cable detection on Nvidia chips doesn't work too well,
 	 * cache BIOS programmed UDMA mode.
 	 */
@@ -536,18 +585,11 @@ static int amd_reinit_one(struct pci_dev
 		return rc;
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
-		u8 fifo;
-		pci_read_config_byte(pdev, 0x41, &fifo);
-		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411)
-			/* FIFO is broken */
-			pci_write_config_byte(pdev, 0x41, fifo & 0x0F);
-		else
-			pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
+		amd_clear_fifo(pdev);
 		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7409 ||
 		    pdev->device == PCI_DEVICE_ID_AMD_COBRA_7401)
 			ata_pci_bmdma_clear_simplex(pdev);
 	}
