From: akpm@linux-foundation.org
Subject: - pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:51 -0800
Message-ID: <200711060552.lA65qpSj007401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbXKFF4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_hpt37x: fix outstanding bug reports on the HPT374 and  37x cable detect
has been removed from the -mm tree.  Its filename was
     pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_hpt37x: fix outstanding bug reports on the HPT374 and  37x cable detect
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Read frequency correctly
- Correct cable detect handling
- Fix wrong filter test

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt37x.c |   49 ++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff -puN drivers/ata/pata_hpt37x.c~pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect
+++ a/drivers/ata/pata_hpt37x.c
@@ -295,7 +295,7 @@ static unsigned long hpt370_filter(struc
 
 static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 {
-	if (adev->class != ATA_DEV_ATA) {
+	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
 			mask &= ~ (0x1F << ATA_SHIFT_UDMA);
 	}
@@ -359,28 +359,25 @@ static int hpt374_pre_reset(struct ata_l
 		{ 0x50, 1, 0x04, 0x04 },
 		{ 0x54, 1, 0x04, 0x04 }
 	};
-	u16 mcr3, mcr6;
+	u16 mcr3;
 	u8 ata66;
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned int mcrbase = 0x50 + 4 * ap->port_no;
 
 	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
 		return -ENOENT;
 
 	/* Do the extra channel work */
-	pci_read_config_word(pdev, 0x52, &mcr3);
-	pci_read_config_word(pdev, 0x56, &mcr6);
+	pci_read_config_word(pdev, mcrbase + 2, &mcr3);
 	/* Set bit 15 of 0x52 to enable TCBLID as input
-	   Set bit 15 of 0x56 to enable FCBLID as input
 	 */
-	pci_write_config_word(pdev, 0x52, mcr3 | 0x8000);
-	pci_write_config_word(pdev, 0x56, mcr6 | 0x8000);
+	pci_write_config_word(pdev, mcrbase + 2, mcr3 | 0x8000);
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Reset TCBLID/FCBLID to output */
 	pci_write_config_word(pdev, 0x52, mcr3);
-	pci_write_config_word(pdev, 0x56, mcr6);
 
-	if (ata66 & (1 << ap->port_no))
+	if (ata66 & (2 >> ap->port_no))
 		ap->cbl = ATA_CBL_PATA40;
 	else
 		ap->cbl = ATA_CBL_PATA80;
@@ -844,6 +841,25 @@ static int hpt37x_calibrate_dpll(struct 
 	/* Never went stable */
 	return 0;
 }
+
+static u32 hpt374_read_freq(struct pci_dev *pdev)
+{
+	u32 freq;
+	unsigned long io_base = pci_resource_start(pdev, 4);
+	if (PCI_FUNC(pdev->devfn) & 1) {
+		struct pci_dev *pdev_0 = pci_get_slot(pdev->bus, pdev->devfn - 1);
+		/* Someone hot plugged the controller on us ? */
+		if (pdev_0 == NULL)
+			return 0;
+		io_base = pci_resource_start(pdev_0, 4);
+		freq = inl(io_base + 0x90);
+		pci_dev_put(pdev_0);
+	}
+	else
+		freq = inl(io_base + 0x90);
+	return freq;
+}
+
 /**
  *	hpt37x_init_one		-	Initialise an HPT37X/302
  *	@dev: PCI device
@@ -902,7 +918,7 @@ static int hpt37x_init_one(struct pci_de
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x0f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
@@ -911,7 +927,7 @@ static int hpt37x_init_one(struct pci_de
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x0f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA133 */
@@ -1047,9 +1063,16 @@ static int hpt37x_init_one(struct pci_de
 		outb(0x0e, iobase + 0x9c);
 
 	/* Some devices do not let this value be accessed via PCI space
-	   according to the old driver */
+	   according to the old driver. In addition we must use the value
+	   from FN 0 on the HPT374 */
+
+	if (chip_table == &hpt374) {
+		freq = hpt374_read_freq(dev);
+		if (freq == 0)
+			return -ENODEV;
+	} else
+		freq = inl(iobase + 0x90);
 
-	freq = inl(iobase + 0x90);
 	if ((freq >> 12) != 0xABCDE) {
 		int i;
 		u8 sr;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
keyspan-init-termios-properly.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
