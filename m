From: akpm@linux-foundation.org
Subject: + pata_amd-update-mode-selection-for-nv-patas.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:16:55 -0800
Message-ID: <200711122116.lACLGtql009419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbXKLV0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:26:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     pata_amd: update mode selection for NV PATAs
has been added to the -mm tree.  Its filename is
     pata_amd-update-mode-selection-for-nv-patas.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_amd: update mode selection for NV PATAs
From: Tejun Heo <htejun@gmail.com>

Cable detection on NV PATA hosts isn't implemented and the CBLID- cable isn't
wired according to the sepc either, so both host-side and generic drive-side
cable detections are broken.  Till now, nv_cable_detect() relied on peeking
BIOS and ACPI configurations to upgrade to 80C but this often results in
misdetection of 40C cable as 80C.  Also, the original implementation was
broken in that by the time BIOS configuration is read it has already been
cleared by programming PIO0 during reset.

This patch reimplements NV mode selection such that...

* BIOS configuration value is stored during driver attach and restored
  on detach.

* Cable type is fixed to ATA_CBL_PATA_IGN and mode selection is soley
  done by nv_mode_filter() which peeks both BIOS and ACPI
  configurations and filter accordingly.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |  129 ++++++++++++++++++++++++++++-----------
 1 file changed, 93 insertions(+), 36 deletions(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-update-mode-selection-for-nv-patas drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-update-mode-selection-for-nv-patas
+++ a/drivers/ata/pata_amd.c
@@ -219,6 +219,62 @@ static void amd133_set_dmamode(struct at
 	timing_setup(ap, adev, 0x40, adev->dma_mode, 4);
 }
 
+/* Both host-side and drive-side detection results are worthless on NV
+ * PATAs.  Ignore them and just follow what BIOS configured.  Both the
+ * current configuration in PCI config reg and ACPI GTM result are
+ * cached during driver attach and are consulted to select transfer
+ * mode.
+ */
+static unsigned int nv_mode_filter(struct ata_device *dev,
+				   unsigned int xfer_mask)
+{
+	static const unsigned int udma_mask_map[] =
+		{ ATA_UDMA2, ATA_UDMA1, ATA_UDMA0, 0,
+		  ATA_UDMA3, ATA_UDMA4, ATA_UDMA5, ATA_UDMA6 };
+	struct ata_port *ap = dev->link->ap;
+	char acpi_str[32] = "";
+	u32 saved_udma, udma;
+	const struct ata_acpi_gtm *gtm;
+	unsigned int bios_limit = 0, acpi_limit = 0, limit;
+
+	/* find out what BIOS configured */
+	udma = saved_udma = (unsigned long)ap->host->private_data;
+
+	if (ap->port_no == 0)
+		udma >>= 16;
+	if (dev->devno == 0)
+		udma >>= 8;
+
+	if ((udma & 0xc0) == 0xc0)
+		bios_limit = ata_pack_xfermask(0, 0, udma_mask_map[udma & 0x7]);
+
+	/* consult ACPI GTM too */
+	gtm = ata_acpi_init_gtm(ap);
+	if (gtm) {
+		acpi_limit = ata_acpi_gtm_xfermask(dev, gtm);
+
+		snprintf(acpi_str, sizeof(acpi_str), " (%u:%u:0x%x)",
+			 gtm->drive[0].dma, gtm->drive[1].dma, gtm->flags);
+	}
+
+	/* be optimistic, EH can take care of things if something goes wrong */
+	limit = bios_limit | acpi_limit;
+
+	/* If PIO or DMA isn't configured at all, don't limit.  Let EH
+	 * handle it.
+	 */
+	if (!(limit & ATA_MASK_PIO))
+		limit |= ATA_MASK_PIO;
+	if (!(limit & (ATA_MASK_MWDMA | ATA_MASK_UDMA)))
+		limit |= ATA_MASK_MWDMA | ATA_MASK_UDMA;
+
+	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%x&0x%x->0x%x, "
+			"BIOS=0x%x (0x%x) ACPI=0x%x%s\n",
+			xfer_mask, limit, xfer_mask & limit, bios_limit,
+			saved_udma, acpi_limit, acpi_str);
+
+	return xfer_mask & limit;
+}
 
 /**
  *	nv_probe_init	-	cable detection
@@ -251,32 +307,6 @@ static void nv_error_handler(struct ata_
 			       ata_std_postreset);
 }
 
-static int nv_cable_detect(struct ata_port *ap)
-{
-	static const u8 bitmask[2] = {0x03, 0x0C};
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 ata66;
-	u16 udma;
-	int cbl;
-
-	pci_read_config_byte(pdev, 0x52, &ata66);
-	if (ata66 & bitmask[ap->port_no])
-		cbl = ATA_CBL_PATA80;
-	else
-		cbl = ATA_CBL_PATA40;
-
- 	/* We now have to double check because the Nvidia boxes BIOS
- 	   doesn't always set the cable bits but does set mode bits */
- 	pci_read_config_word(pdev, 0x62 - 2 * ap->port_no, &udma);
- 	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
-		cbl = ATA_CBL_PATA80;
-	/* And a triple check across suspend/resume with ACPI around */
-	if (ata_acpi_init_gtm(ap) &&
-	    ata_acpi_cbl_80wire(ap, ata_acpi_init_gtm(ap)))
-		cbl = ATA_CBL_PATA80;
-	return cbl;
-}
-
 /**
  *	nv100_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -314,6 +344,14 @@ static void nv133_set_dmamode(struct ata
 	timing_setup(ap, adev, 0x50, adev->dma_mode, 4);
 }
 
+static void nv_host_stop(struct ata_host *host)
+{
+	u32 udma = (unsigned long)host->private_data;
+
+	/* restore PCI config register 0x60 */
+	pci_write_config_dword(to_pci_dev(host->dev), 0x60, udma);
+}
+
 static struct scsi_host_template amd_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -478,7 +516,8 @@ static struct ata_port_operations nv100_
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
-	.cable_detect	= nv_cable_detect,
+	.cable_detect	= ata_cable_ignore,
+	.mode_filter	= nv_mode_filter,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -495,6 +534,7 @@ static struct ata_port_operations nv100_
 	.irq_on		= ata_irq_on,
 
 	.port_start	= ata_sff_port_start,
+	.host_stop	= nv_host_stop,
 };
 
 static struct ata_port_operations nv133_port_ops = {
@@ -511,7 +551,8 @@ static struct ata_port_operations nv133_
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
-	.cable_detect	= nv_cable_detect,
+	.cable_detect	= ata_cable_ignore,
+	.mode_filter	= nv_mode_filter,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -528,6 +569,7 @@ static struct ata_port_operations nv133_
 	.irq_on		= ata_irq_on,
 
 	.port_start	= ata_sff_port_start,
+	.host_stop	= nv_host_stop,
 };
 
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -614,7 +656,8 @@ static int amd_init_one(struct pci_dev *
 			.port_ops = &amd100_port_ops
 		}
 	};
-	const struct ata_port_info *ppi[] = { NULL, NULL };
+	struct ata_port_info pi;
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	static int printed_version;
 	int type = id->driver_data;
 	u8 fifo;
@@ -628,6 +671,19 @@ static int amd_init_one(struct pci_dev *
 	if (type == 1 && pdev->revision > 0x7)
 		type = 2;
 
+	/* Serenade ? */
+	if (type == 5 && pdev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
+			 pdev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
+		type = 6;	/* UDMA 100 only */
+
+	/*
+	 * Okay, type is determined now.  Apply type-specific workarounds.
+	 */
+	pi = info[type];
+
+	if (type < 3)
+		ata_pci_clear_simplex(pdev);
+
 	/* Check for AMD7411 */
 	if (type == 3)
 		/* FIFO is broken */
@@ -635,16 +691,17 @@ static int amd_init_one(struct pci_dev *
 	else
 		pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
 
-	/* Serenade ? */
-	if (type == 5 && pdev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
-			 pdev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
-		type = 6;	/* UDMA 100 only */
+	/* Cable detection on Nvidia chips doesn't work too well,
+	 * cache BIOS programmed UDMA mode.
+	 */
+	if (type == 7 || type == 8) {
+		u32 udma;
 
-	if (type < 3)
-		ata_pci_clear_simplex(pdev);
+		pci_read_config_dword(pdev, 0x60, &udma);
+		pi.private_data = (void *)(unsigned long)udma;
+	}
 
 	/* And fire it up */
-	ppi[0] = &info[type];
 	return ata_pci_init_one(pdev, ppi);
 }
 
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
ata_generic-unindent-loop-in-generic_set_mode.patch
libata-export-xfermode--pata-timing-related-functions.patch
libata-clean-up-xfermode--pata-timing-related-stuff.patch
libata-kill-ata_id_to_dma_mode.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-implement-ata_acpi_init_gtm.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
scsi-early-detection-of-medium-not-present-updated.patch
