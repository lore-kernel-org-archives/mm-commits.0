From: akpm@linux-foundation.org
Subject: + gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch added to -mm tree
Date: Sat, 29 Nov 2008 00:32:08 -0800
Message-ID: <200811290832.mAT8W8Xo021845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbYK2IcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 03:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, tsbogend@alpha.franken.de


The patch titled
     gbefb: unsigned var->pixclock cannot be less than 0
has been added to the -mm tree.  Its filename is
     gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch

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
Subject: gbefb: unsigned var->pixclock cannot be less than 0
From: roel kluin <roel.kluin@gmail.com>

unsigned var->pixclock cannot be less than 0

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/gbefb.c~gbefb-unsigned-var-pixclock-cannot-be-less-than-0 drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~gbefb-unsigned-var-pixclock-cannot-be-less-than-0
+++ a/drivers/video/gbefb.c
@@ -912,6 +912,7 @@ static int gbefb_check_var(struct fb_var
 {
 	unsigned int line_length;
 	struct gbe_timing_info timing;
+	int ret;
 
 	/* Limit bpp to 8, 16, and 32 */
 	if (var->bits_per_pixel <= 8)
@@ -930,8 +931,10 @@ static int gbefb_check_var(struct fb_var
 
 	var->grayscale = 0;	/* No grayscale for now */
 
-	if ((var->pixclock = compute_gbe_timing(var, &timing)) < 0)
-		return(-EINVAL);
+	ret = compute_gbe_timing(var, &timing);
+	var->pixclock = ret;
+	if (ret < 0)
+		return -EINVAL;
 
 	/* Adjust virtual resolution, if necessary */
 	if (var->xres > var->xres_virtual || (!ywrap && !ypan))
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

spi-documentation-__initdata-on-struct.patch
linux-next.patch
gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch
ufs-sector_t-cannot-be-negative.patch
make-various-things-static.patch

