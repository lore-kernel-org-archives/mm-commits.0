From: akpm@linux-foundation.org
Subject: - s3c2410_fb-fix-line-length-calculation.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:33 -0800
Message-ID: <200801290147.m0T1lXwq027288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYA2BuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan@openmoko.org, adaplas@pol.net, arnaud.patard@rtp-net.org, ben-linux@fluff.org, johnpcass@yahoo.com, krzysztof.h1@wp.pl, laforge@openmoko.org, rmk@arm.linux.org.uk, mm-commits@v


The patch titled
     s3c2410_fb: fix line length calculation
has been removed from the -mm tree.  Its filename was
     s3c2410_fb-fix-line-length-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c2410_fb: fix line length calculation
From: Stefan Schmidt <stefan@openmoko.org>

Fix line length calculation. var->width is the size of the display in mm. We
like to use the pixel size.

Without this fix, dynamic (fbset) based resolution and depths changes with
s3c2410_fb don't work at all.

Spotted by john cass <johnpcass@yahoo.com>

Signed-off-by: Stefan Schmidt <stefan@openmoko.org>
Signed-off-by: Harald Welte <laforge@openmoko.org>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410_fb-fix-line-length-calculation drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410_fb-fix-line-length-calculation
+++ a/drivers/video/s3c2410fb.c
@@ -488,7 +488,7 @@ static int s3c2410fb_set_par(struct fb_i
 		break;
 	}
 
-	info->fix.line_length = (var->width * var->bits_per_pixel) / 8;
+	info->fix.line_length = (var->xres_virtual * var->bits_per_pixel) / 8;
 
 	/* activate this new configuration */
 
_

Patches currently in -mm which might be from stefan@openmoko.org are
