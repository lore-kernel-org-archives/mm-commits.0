From: akpm@linux-foundation.org
Subject: + fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch added to -mm tree
Date: Tue, 29 Jan 2008 17:46:09 -0800
Message-ID: <200801300145.m0U1jo8H014963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYA3Bqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 20:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk


The patch titled
     FB/S3C2410: ensure S3C2410 framebuffer clears initial memory to black
has been added to the -mm tree.  Its filename is
     fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch

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
Subject: FB/S3C2410: ensure S3C2410 framebuffer clears initial memory to black
From: Ben Dooks <ben-linux@fluff.org>

Change the initial pattern in the s3c2410 framebuffer driver
to black.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black
+++ a/drivers/video/s3c2410fb.c
@@ -679,7 +679,7 @@ static int __init s3c2410fb_map_video_me
 		/* prevent initial garbage on screen */
 		dprintk("map_video_memory: clear %p:%08x\n",
 			info->screen_base, map_size);
-		memset(info->screen_base, 0xf0, map_size);
+		memset(info->screen_base, 0x00, map_size);
 
 		info->fix.smem_start = map_dma;
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-alsa.patch
git-arm.patch
git-mtd.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
fb-sm501-ensure-console-suspended-before-saving-state.patch
fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
