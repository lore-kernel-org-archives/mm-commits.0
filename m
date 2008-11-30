From: akpm@linux-foundation.org
Subject: + neofb-fix-sparse-warnings.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:34:30 -0800
Message-ID: <200811300334.mAU3YUPR021325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYK3Dei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, krzysztof.h1@poczta.fm


The patch titled
     neofb: fix sparse warnings
has been added to the -mm tree.  Its filename is
     neofb-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
hugetlb-fix-sparse-warnings.patch
rtc-ds1511-fix-sparse-warning.patch
rtc-stk17ta8-fix-sparse-warning.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

