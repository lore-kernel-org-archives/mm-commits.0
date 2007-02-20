From: akpm@linux-foundation.org
Subject: - sata_via-fix-resource-managed-iomap-conversion.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:09:25 -0800
Message-ID: <200702202009.l1KK9Pxw018220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122AbXBTUJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sata_via: fix resource-managed iomap conversion
has been removed from the -mm tree.  Its filename was
     sata_via-fix-resource-managed-iomap-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_via: fix resource-managed iomap conversion
From: Tejun Heo <htejun@gmail.com>

Conversion to resource-managed iomap was buggy causing init failures on
both vt6420 and 6421 - BAR5 wasn't mapped for both controllers while on
vt6420 sata_via tried to map BAR0-4 twice.  Fix it.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_via.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/ata/sata_via.c~sata_via-fix-resource-managed-iomap-conversion drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~sata_via-fix-resource-managed-iomap-conversion
+++ a/drivers/ata/sata_via.c
@@ -423,16 +423,21 @@ static struct ata_probe_ent *vt6420_init
 {
 	struct ata_probe_ent *probe_ent;
 	struct ata_port_info *ppi[2];
-	void __iomem * const *iomap;
+	void __iomem *bar5;
 
 	ppi[0] = ppi[1] = &vt6420_port_info;
 	probe_ent = ata_pci_init_native_mode(pdev, ppi, ATA_PORT_PRIMARY | ATA_PORT_SECONDARY);
 	if (!probe_ent)
 		return NULL;
 
-	iomap = pcim_iomap_table(pdev);
-	probe_ent->port[0].scr_addr = svia_scr_addr(iomap[5], 0);
-	probe_ent->port[1].scr_addr = svia_scr_addr(iomap[5], 1);
+	bar5 = pcim_iomap(pdev, 5, 0);
+	if (!bar5) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		return NULL;
+	}
+
+	probe_ent->port[0].scr_addr = svia_scr_addr(bar5, 0);
+	probe_ent->port[1].scr_addr = svia_scr_addr(bar5, 1);
 
 	return probe_ent;
 }
@@ -460,6 +465,13 @@ static struct ata_probe_ent *vt6421_init
 	probe_ent->mwdma_mask	= 0x07;
 	probe_ent->udma_mask	= 0x7f;
 
+	for (i = 0; i < 6; i++)
+		if (!pcim_iomap(pdev, i, 0)) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "failed to iomap PCI BAR %d\n", i);
+			return NULL;
+		}
+
 	for (i = 0; i < N_PORTS; i++)
 		vt6421_init_addrs(probe_ent, pcim_iomap_table(pdev), i);
 
@@ -522,7 +534,7 @@ static int svia_init_one (struct pci_dev
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 0x1f, DRV_NAME);
+	rc = pci_request_regions(pdev, DRV_NAME);
 	if (rc) {
 		pcim_pin_device(pdev);
 		return rc;
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
