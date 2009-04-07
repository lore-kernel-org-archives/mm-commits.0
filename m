From: akpm@linux-foundation.org
Subject: + fbdev-fix-color-component-field-length-documentation.patch added to -mm tree
Date: Mon, 06 Apr 2009 23:51:49 -0700
Message-ID: <200904070651.n376pnWY029861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbZDGGze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 02:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, geert.uytterhoeven@gmail.com, krzysztof.h1@poczta.fm, syrjala@sci.fi


The patch titled
     fbdev: fix color component field length documentation
has been added to the -mm tree.  Its filename is
     fbdev-fix-color-component-field-length-documentation.patch

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
Subject: fbdev: fix color component field length documentation
From: Michal Januszewski <spock@gentoo.org>

The documentation about the meaning of the color component bitfield
lengths in pseudocolor modes is inconsistent.  Fix it, so that it
indicates the correct interpretation everywhere, i.e.  that 1 << length is
the number of palette entries.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <syrjala@sci.fi>
Acked-by: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |    8 +++++---
 drivers/video/vfb.c        |   11 +++++++----
 include/linux/fb.h         |    8 ++++++--
 3 files changed, 18 insertions(+), 9 deletions(-)

diff -puN drivers/video/skeletonfb.c~fbdev-fix-color-component-field-length-documentation drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~fbdev-fix-color-component-field-length-documentation
+++ a/drivers/video/skeletonfb.c
@@ -308,9 +308,11 @@ static int xxxfb_setcolreg(unsigned regn
      *   color depth = SUM(var->{color}.length)
      *
      * Pseudocolor:
-     *    var->{color}.offset is 0
-     *    var->{color}.length contains width of DAC or the number of unique
-     *                        colors available (color depth)
+     *    var->{color}.offset is 0 unless the palette index takes less than
+     *                        bits_per_pixel bits and is stored in the upper
+     *                        bits of the pixel value
+     *    var->{color}.length is set so that 1 << length is the number of
+     *                        available palette entries
      *    pseudo_palette is not used
      *    RAMDAC[X] is programmed to (red, green, blue)
      *    color depth = var->{color}.length
diff -puN drivers/video/vfb.c~fbdev-fix-color-component-field-length-documentation drivers/video/vfb.c
--- a/drivers/video/vfb.c~fbdev-fix-color-component-field-length-documentation
+++ a/drivers/video/vfb.c
@@ -318,13 +318,16 @@ static int vfb_setcolreg(u_int regno, u_
 	 *   {hardwarespecific} contains width of RAMDAC
 	 *   cmap[X] is programmed to (X << red.offset) | (X << green.offset) | (X << blue.offset)
 	 *   RAMDAC[X] is programmed to (red, green, blue)
-	 * 
+	 *
 	 * Pseudocolor:
-	 *    uses offset = 0 && length = RAMDAC register width.
-	 *    var->{color}.offset is 0
-	 *    var->{color}.length contains widht of DAC
+	 *    var->{color}.offset is 0 unless the palette index takes less than
+	 *                        bits_per_pixel bits and is stored in the upper
+	 *                        bits of the pixel value
+	 *    var->{color}.length is set so that 1 << length is the number of available
+	 *                        palette entries
 	 *    cmap is not used
 	 *    RAMDAC[X] is programmed to (red, green, blue)
+	 *
 	 * Truecolor:
 	 *    does not use DAC. Usually 3 are present.
 	 *    var->{color}.offset contains start of bitfield
diff -puN include/linux/fb.h~fbdev-fix-color-component-field-length-documentation include/linux/fb.h
--- a/include/linux/fb.h~fbdev-fix-color-component-field-length-documentation
+++ a/include/linux/fb.h
@@ -173,8 +173,12 @@ struct fb_fix_screeninfo {
 /* Interpretation of offset for color fields: All offsets are from the right,
  * inside a "pixel" value, which is exactly 'bits_per_pixel' wide (means: you
  * can use the offset as right argument to <<). A pixel afterwards is a bit
- * stream and is written to video memory as that unmodified. This implies
- * big-endian byte order if bits_per_pixel is greater than 8.
+ * stream and is written to video memory as that unmodified.
+ *
+ * For pseudocolor: offset and length should be the same for all color
+ * components. Offset specifies the position of the least significant bit
+ * of the pallette index in a pixel value. Length indicates the number
+ * of available palette entries (i.e. # of entries = 1 << length).
  */
 struct fb_bitfield {
 	__u32 offset;			/* beginning of bitfield	*/
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
uvesafb-documentation-update.patch
linux-next.patch
fbdev-fix-color-component-field-length-documentation.patch

