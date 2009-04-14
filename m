From: akpm@linux-foundation.org
Subject: [merged] sa1100fb-fix-color-component-length-for-pseudocolor-modes.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:02 -0700
Message-ID: <200904141949.n3EJn2qm019343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbZDNTv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, krzysztof.h1@poczta.fm, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sa1100fb: fix color component length for pseudocolor modes
has been removed from the -mm tree.  Its filename was
     sa1100fb-fix-color-component-length-for-pseudocolor-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sa1100fb: fix color component length for pseudocolor modes
From: Michal Januszewski <spock@gentoo.org>

sa1100fb incorrectly sets the length of the color fields to 8 bits for
PSEUDOCOLOR modes for which only 4 bits are used per pixel.  Fix this by
setting the length to 4 bits for these modes.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sa1100fb.c |   15 ++++++++++-----
 drivers/video/sa1100fb.h |    7 ++++---
 2 files changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/video/sa1100fb.c~sa1100fb-fix-color-component-length-for-pseudocolor-modes drivers/video/sa1100fb.c
--- a/drivers/video/sa1100fb.c~sa1100fb-fix-color-component-length-for-pseudocolor-modes
+++ a/drivers/video/sa1100fb.c
@@ -199,16 +199,20 @@
 extern void (*sa1100fb_backlight_power)(int on);
 extern void (*sa1100fb_lcd_power)(int on);
 
-/*
- * IMHO this looks wrong.  In 8BPP, length should be 8.
- */
-static struct sa1100fb_rgb rgb_8 = {
+static struct sa1100fb_rgb rgb_4 = {
 	.red	= { .offset = 0,  .length = 4, },
 	.green	= { .offset = 0,  .length = 4, },
 	.blue	= { .offset = 0,  .length = 4, },
 	.transp	= { .offset = 0,  .length = 0, },
 };
 
+static struct sa1100fb_rgb rgb_8 = {
+	.red	= { .offset = 0,  .length = 8, },
+	.green	= { .offset = 0,  .length = 8, },
+	.blue	= { .offset = 0,  .length = 8, },
+	.transp	= { .offset = 0,  .length = 0, },
+};
+
 static struct sa1100fb_rgb def_rgb_16 = {
 	.red	= { .offset = 11, .length = 5, },
 	.green	= { .offset = 5,  .length = 6, },
@@ -613,7 +617,7 @@ sa1100fb_check_var(struct fb_var_screeni
 	DPRINTK("var->bits_per_pixel=%d\n", var->bits_per_pixel);
 	switch (var->bits_per_pixel) {
 	case 4:
-		rgbidx = RGB_8;
+		rgbidx = RGB_4;
 		break;
 	case 8:
 		rgbidx = RGB_8;
@@ -1382,6 +1386,7 @@ static struct sa1100fb_info * __init sa1
 	fbi->fb.monspecs	= monspecs;
 	fbi->fb.pseudo_palette	= (fbi + 1);
 
+	fbi->rgb[RGB_4]		= &rgb_4;
 	fbi->rgb[RGB_8]		= &rgb_8;
 	fbi->rgb[RGB_16]	= &def_rgb_16;
 
diff -puN drivers/video/sa1100fb.h~sa1100fb-fix-color-component-length-for-pseudocolor-modes drivers/video/sa1100fb.h
--- a/drivers/video/sa1100fb.h~sa1100fb-fix-color-component-length-for-pseudocolor-modes
+++ a/drivers/video/sa1100fb.h
@@ -57,9 +57,10 @@ struct sa1100fb_lcd_reg {
 	unsigned long lccr3;
 };
 
-#define RGB_8	(0)
-#define RGB_16	(1)
-#define NR_RGB	2
+#define RGB_4	(0)
+#define RGB_8	(1)
+#define RGB_16	(2)
+#define NR_RGB	3
 
 struct sa1100fb_info {
 	struct fb_info		fb;
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
linux-next.patch

