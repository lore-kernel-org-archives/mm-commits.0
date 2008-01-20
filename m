From: akpm@linux-foundation.org
Subject: + s3c2410_fb-fix-line-length-calculation.patch added to -mm tree
Date: Sun, 20 Jan 2008 11:45:37 -0800
Message-ID: <200801201945.m0KJjHPG032680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbYATTrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 14:47:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefan@openmoko.org, adaplas@pol.net, arnaud.patard@rtp-net.org, ben-linux@fluff.org, johnpcass@yahoo.com, krzysztof.h1@wp.pl, laforge@openmoko.org, rmk@arm.linux.org.uk


The patch titled
     s3c2410_fb: fix line length calculation
has been added to the -mm tree.  Its filename is
     s3c2410_fb-fix-line-length-calculation.patch

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

s3c2410_fb-fix-line-length-calculation.patch
