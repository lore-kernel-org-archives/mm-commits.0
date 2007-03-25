From: akpm@linux-foundation.org
Subject: + use-unchecked_isa_dma-in-sd_revalidate_disk.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:30:24 -0800
Message-ID: <200703250730.l2P7UOIY022852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbXCYHae (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, James.Bottomley@steeleye.com, jens.axboe@oracle.com


The patch titled
     Use unchecked_isa_dma in sd_revalidate_disk()
has been added to the -mm tree.  Its filename is
     use-unchecked_isa_dma-in-sd_revalidate_disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use unchecked_isa_dma in sd_revalidate_disk()
From: Bernhard Walle <bwalle@suse.de>

In sd_revalidate_disk(), the SCSI Disk driver needs a few bytes DMA memory,
allocated by kmalloc() and __GFP_DMA.  This patch uses __GFP_DMA only if
the corresponding host structure has unchecked_isa_dma set.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~use-unchecked_isa_dma-in-sd_revalidate_disk drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~use-unchecked_isa_dma-in-sd_revalidate_disk
+++ a/drivers/scsi/sd.c
@@ -1516,7 +1516,8 @@ static int sd_revalidate_disk(struct gen
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
x86_64-i386-add-command-line-length-to-boot-protocol.patch
