From: akpm@linux-foundation.org
Subject: - pata_sis-add-missing-udma5-timing-value-in-sis_66_set_dmamode.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:44:14 -0700
Message-ID: <200709270144.l8R1iEJK014028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbXI0Bvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, alan@redhat.com, cebbert@redhat.com, desaster.area@addcom.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_sis: add missing UDMA5 timing value in sis_66_set_dmamode()
has been removed from the -mm tree.  Its filename was
     pata_sis-add-missing-udma5-timing-value-in-sis_66_set_dmamode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_sis: add missing UDMA5 timing value in sis_66_set_dmamode()
From: Tejun Heo <htejun@gmail.com>

sis_66_set_dmamode() also handles early UDMA100 (SIS630 ET) but is
missing udma timing value for UDMA100.  According to sis5513, this
should be 0x8000.  This caused UDMA100 device to fail on pata_sis till
it downgrades to UDMA66 while it works fine on sis5513 at UDMA100.

Reported by Adam Blech.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Adam Blech <desaster.area@addcom.de>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/pata_sis.c~pata_sis-add-missing-udma5-timing-value-in-sis_66_set_dmamode drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sis-add-missing-udma5-timing-value-in-sis_66_set_dmamode
+++ a/drivers/ata/pata_sis.c
@@ -375,8 +375,9 @@ static void sis_66_set_dmamode (struct a
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
+	/* MWDMA 0-2 and UDMA 0-5 */
 	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
-	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000};
+	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000, 0x8000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-implement-ata_wait_after_reset.patch
libata-add-a-drivers-ide-style-dma-disable.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-human-readable-error-value-decoding-v3.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
scsi-early-detection-of-medium-not-present-updated.patch
git-block.patch
