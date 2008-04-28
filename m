From: akpm@linux-foundation.org
Subject: - metronomefb-dont-free-firmware-twice-in-error-path.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:28 -0700
Message-ID: <200804282159.m3SLxSK4018592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965394AbYD1V77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frame+buffer@ml.breakpoint.cc, adaplas@pol.net, jayakumar.lkml@gmail.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     metronomefb: don't free firmware twice in error path
has been removed from the -mm tree.  Its filename was
     metronomefb-dont-free-firmware-twice-in-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: metronomefb: don't free firmware twice in error path
From: Sebastian Siewior <frame+buffer@ml.breakpoint.cc>

Right now, if request_irq or anthing after it fails than we free the firmware
for the second time what might end bad :)

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/metronomefb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/metronomefb.c~metronomefb-dont-free-firmware-twice-in-error-path drivers/video/metronomefb.c
--- a/drivers/video/metronomefb.c~metronomefb-dont-free-firmware-twice-in-error-path
+++ a/drivers/video/metronomefb.c
@@ -671,14 +671,14 @@ static int __devinit metronomefb_probe(s
 
 	retval = load_waveform((u8 *) fw_entry->data, fw_entry->size,
 				par->metromem_wfm, 3, 31, &par->frame_count);
+	release_firmware(fw_entry);
 	if (retval < 0) {
 		printk(KERN_ERR "metronomefb: couldn't process waveform\n");
-		goto err_ld_wfm;
+		goto err_dma_free;
 	}
-	release_firmware(fw_entry);
 
 	if (board->setup_irq(info))
-		goto err_ld_wfm;
+		goto err_dma_free;
 
 	retval = metronome_init_regs(par);
 	if (retval < 0)
@@ -719,8 +719,6 @@ err_fb_rel:
 	framebuffer_release(info);
 err_free_irq:
 	board->free_irq(info);
-err_ld_wfm:
-	release_firmware(fw_entry);
 err_dma_free:
 	dma_free_writecombine(&dev->dev, par->metromemsize, par->metromem,
 				par->metromem_dma);
_

Patches currently in -mm which might be from frame+buffer@ml.breakpoint.cc are

origin.patch

