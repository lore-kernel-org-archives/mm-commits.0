From: akpm@linux-foundation.org
Subject: + metronomefb-dont-free-firmware-twice-in-error-path.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:58:22 -0700
Message-ID: <200804272058.m3RKwMSd024487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbYD0U65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:58:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frame+buffer@ml.breakpoint.cc, adaplas@pol.net, jayakumar.lkml@gmail.com, sebastian@breakpoint.cc


The patch titled
     metronomefb: don't free firmware twice in error path
has been added to the -mm tree.  Its filename is
     metronomefb-dont-free-firmware-twice-in-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

metronomefb-dont-free-firmware-twice-in-error-path.patch

