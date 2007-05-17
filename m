From: akpm@linux-foundation.org
Subject: + sata_nv-fix-fallout-of-devres-conversion.patch added to -mm tree
Date: Thu, 17 May 2007 15:31:05 -0700
Message-ID: <200705172231.l4HMV5kd002071@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758109AbXEQWct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 18:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, pchen@nvidia.com


The patch titled
     sata_nv: fix fallout of devres conversion
has been added to the -mm tree.  Its filename is
     sata_nv-fix-fallout-of-devres-conversion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: fix fallout of devres conversion
From: Tejun Heo <htejun@gmail.com>

As with all other drivers, sata_nv's hpriv is allocated with devm_kzalloc()
and there's no need to free it explicitly.  Kill nv_remove_one() which
incorrectly used kfree() instead of devm_kfree() and use
ata_pci_remove_one() directly.

Original fix is from Peer Chen.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Peer Chen <pchen@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   12 +-----------
 1 files changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-fix-fallout-of-devres-conversion drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-fix-fallout-of-devres-conversion
+++ a/drivers/ata/sata_nv.c
@@ -229,7 +229,6 @@ struct nv_host_priv {
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
 
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static void nv_remove_one (struct pci_dev *pdev);
 #ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev);
 #endif
@@ -300,7 +299,7 @@ static struct pci_driver nv_pci_driver =
 	.suspend		= ata_pci_device_suspend,
 	.resume			= nv_pci_device_resume,
 #endif
-	.remove			= nv_remove_one,
+	.remove			= ata_pci_remove_one,
 };
 
 static struct scsi_host_template nv_sht = {
@@ -1607,15 +1606,6 @@ static int nv_init_one (struct pci_dev *
 				 IRQF_SHARED, ppi[0]->sht);
 }
 
-static void nv_remove_one (struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	struct nv_host_priv *hpriv = host->private_data;
-
-	ata_pci_remove_one(pdev);
-	kfree(hpriv);
-}
-
 #ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev)
 {
_

Patches currently in -mm which might be from htejun@gmail.com are

fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-libata-all.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
optional-led-trigger-for-libata.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
sata_nv-fix-fallout-of-devres-conversion.patch
libata-implement-ata_wait_after_reset.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
pci-quirks-disable-msi-on-rs400-200-and-rs480.patch
