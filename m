From: akpm@linux-foundation.org
Subject: - neofb-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:53 -0800
Message-ID: <200901072219.n07MJr4O019185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761780AbZAGWUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     neofb: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     neofb-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: neofb: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:

  drivers/video/neofb.c:1456:4: warning: returning void-valued expression
  drivers/video/neofb.c:1464:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/neofb.c~neofb-fix-sparse-warnings drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-fix-sparse-warnings
+++ a/drivers/video/neofb.c
@@ -1453,7 +1453,8 @@ neo2200_imageblit(struct fb_info *info, 
 			 * is less than 16 bits wide. This is due to insufficient
 			 * padding when writing the image. We need to adjust
 			 * struct fb_pixmap. Not yet done. */
-			return cfb_imageblit(info, image);
+			cfb_imageblit(info, image);
+			return;
 		}
 		bltCntl_flags = NEO_BC0_SRC_MONO;
 	} else if (image->depth == info->var.bits_per_pixel) {
@@ -1461,7 +1462,8 @@ neo2200_imageblit(struct fb_info *info, 
 	} else {
 		/* We don't currently support hardware acceleration if image
 		 * depth is different from display */
-		return cfb_imageblit(info, image);
+		cfb_imageblit(info, image);
+		return;
 	}
 
 	switch (info->var.bits_per_pixel) {
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch

