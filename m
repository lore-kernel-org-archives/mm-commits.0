From: akpm@linux-foundation.org
Subject: + sata_nv-allow-changing-queue-depth.patch added to -mm tree
Date: Thu, 28 Jun 2007 18:13:41 -0700
Message-ID: <200706290113.l5T1DfLW005716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762807AbXF2BNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 21:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     sata_nv: allow changing queue depth
has been added to the -mm tree.  Its filename is
     sata_nv-allow-changing-queue-depth.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: allow changing queue depth
From: Robert Hancock <hancockr@shaw.ca>

The sata_nv driver was missing the change_queue_depth hook in the SCSI host
template which the other NCQ-capable libata drivers had.  This made it
impossible to change the queue depth by user request.  Add this in.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/ata/sata_nv.c~sata_nv-allow-changing-queue-depth drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-allow-changing-queue-depth
+++ a/drivers/ata/sata_nv.c
@@ -398,6 +398,7 @@ static struct scsi_host_template nv_adma
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= NV_ADMA_MAX_CPBS,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
@@ -416,6 +417,7 @@ static struct scsi_host_template nv_swnc
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= ATA_MAX_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
_

Patches currently in -mm which might be from hancockr@shaw.ca are

sata_nv-allow-changing-queue-depth.patch
libata-add-human-readable-error-value-decoding.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch
