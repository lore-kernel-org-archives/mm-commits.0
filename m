From: akpm@linux-foundation.org
Subject: - fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:27 -0800
Message-ID: <200802070029.m170T8NZ007247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764611AbYBGAon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     FB/S3C2410: ensure S3C2410 framebuffer clears initial memory to black
has been removed from the -mm tree.  Its filename was
     fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-mtd.patch
