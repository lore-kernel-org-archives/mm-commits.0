From: akpm@linux-foundation.org
Subject: + scsi-remove-__gfp_dma.patch added to -mm tree
Date: Mon, 21 May 2007 14:24:02 -0700
Message-ID: <200705212124.l4LLO2Tl020358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757758AbXEUVZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, James.Bottomley@SteelEye.com


The patch titled
     scsi: remove __GFP_DMA
has been added to the -mm tree.  Its filename is
     scsi-remove-__gfp_dma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: remove __GFP_DMA
From: Bernhard Walle <bwalle@suse.de>

After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to
allocate a DMA buffer any more in sd.c.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
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
scsi-remove-__gfp_dma.patch
