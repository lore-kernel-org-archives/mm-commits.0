From: akpm@linux-foundation.org
Subject: - use-unchecked_isa_dma-in-sd_revalidate_disk.patch removed from -mm tree
Date: Fri, 11 May 2007 09:09:44 -0700
Message-ID: <200705111609.l4BG9iQ0020666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758264AbXEKQKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 12:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, James.Bottomley@steeleye.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Use unchecked_isa_dma in sd_revalidate_disk()
has been removed from the -mm tree.  Its filename was
     use-unchecked_isa_dma-in-sd_revalidate_disk.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Use unchecked_isa_dma in sd_revalidate_disk()
From: Bernhard Walle <bwalle@suse.de>

In sd_revalidate_disk(), the SCSI Disk driver needs a few bytes DMA memory,
allocated by kmalloc() and __GFP_DMA.  This patch uses __GFP_DMA only if
the corresponding host structure has unchecked_isa_dma set.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~use-unchecked_isa_dma-in-sd_revalidate_disk drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~use-unchecked_isa_dma-in-sd_revalidate_disk
+++ a/drivers/scsi/sd.c
@@ -1515,7 +1515,8 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL |
+			(sdp->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
 			  "allocation failure.\n");
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
