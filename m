From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:25 -0800
Message-ID: <200802052228.m15MS6fk011857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762676AbYBEWoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: sata_inic162x: use pci_set_dma_max_seg_size
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: sata_inic162x: use pci_set_dma_max_seg_size
From: FUJITA Tomonori <tomof@acm.org>

This sets the segment size limit properly via pci_set_dma_max_seg_size
and remove blk_queue_max_segment_size because scsi-ml calls it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_inic162x.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/ata/sata_inic162x.c~iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size drivers/ata/sata_inic162x.c
--- a/drivers/ata/sata_inic162x.c~iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size
+++ a/drivers/ata/sata_inic162x.c
@@ -108,17 +108,6 @@ struct inic_port_priv {
 	u8	cached_pirq_mask;
 };
 
-static int inic_slave_config(struct scsi_device *sdev)
-{
-	/* This controller is braindamaged.  dma_boundary is 0xffff
-	 * like others but it will lock up the whole machine HARD if
-	 * 65536 byte PRD entry is fed.  Reduce maximum segment size.
-	 */
-	blk_queue_max_segment_size(sdev->request_queue, 65536 - 512);
-
-	return ata_scsi_slave_config(sdev);
-}
-
 static struct scsi_host_template inic_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -132,7 +121,7 @@ static struct scsi_host_template inic_sh
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.slave_configure	= inic_slave_config,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -730,6 +719,18 @@ static int inic_init_one(struct pci_dev 
 		return rc;
 	}
 
+	/*
+	 * This controller is braindamaged.  dma_boundary is 0xffff
+	 * like others but it will lock up the whole machine HARD if
+	 * 65536 byte PRD entry is fed. Reduce maximum segment size.
+	 */
+	rc = pci_set_dma_max_seg_size(pdev, 65536 - 512);
+	if (rc) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "failed to set the maximum segment size.\n");
+		return rc;
+	}
+
 	rc = init_controller(iomap[MMIO_BAR], hpriv->cached_hctl);
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
