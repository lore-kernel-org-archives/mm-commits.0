From: akpm@linux-foundation.org
Subject: - sata_nv-allow-changing-queue-depth.patch removed from -mm tree
Date: Wed, 15 Aug 2007 23:57:30 -0700
Message-ID: <200708160657.l7G6vUo1004019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbXHPG5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 02:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     sata_nv: allow changing queue depth
has been removed from the -mm tree.  Its filename was
     sata_nv-allow-changing-queue-depth.patch

This patch was dropped because it was folded into ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch

------------------------------------------------------
Subject: sata_nv: allow changing queue depth
From: Robert Hancock <hancockr@shaw.ca>

The sata_nv driver was missing the change_queue_depth hook in the SCSI host
template which the other NCQ-capable libata drivers had.  This made it
impossible to change the queue depth by user request.  Add this in.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/sata_nv.c~sata_nv-allow-changing-queue-depth drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-allow-changing-queue-depth
+++ a/drivers/ata/sata_nv.c
@@ -420,6 +420,7 @@ static struct scsi_host_template nv_swnc
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= ATA_MAX_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
_

Patches currently in -mm which might be from hancockr@shaw.ca are

mmconfig-validate-against-acpi-motherboard-resources.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
sata_nv-allow-changing-queue-depth.patch
libata-add-human-readable-error-value-decoding-v3.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
