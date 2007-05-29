From: akpm@linux-foundation.org
Subject: - scsi-remove-__gfp_dma.patch removed from -mm tree
Date: Tue, 29 May 2007 11:55:50 -0700
Message-ID: <200705291855.l4TItndX008608@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763664AbXE2S4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, James.Bottomley@SteelEye.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: remove __GFP_DMA
has been removed from the -mm tree.  Its filename was
     scsi-remove-__gfp_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: remove __GFP_DMA
From: Bernhard Walle <bwalle@suse.de>

After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to
allocate a DMA buffer any more in sd.c.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~scsi-remove-__gfp_dma drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-remove-__gfp_dma
+++ a/drivers/scsi/sd.c
@@ -1515,7 +1515,7 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
 			  "allocation failure.\n");
_

Patches currently in -mm which might be from bwalle@suse.de are

git-r8169.patch
git-scsi-misc.patch
