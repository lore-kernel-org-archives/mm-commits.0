From: akpm@linux-foundation.org
Subject: + sgivwfb-correct-sections.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:58:41 -0700
Message-ID: <201004281858.o3SIwfXs013684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0D1S6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, arnaud.patard@rtp-net.org


The patch titled
     sgivwfb: fix sections
has been added to the -mm tree.  Its filename is
     sgivwfb-correct-sections.patch

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
Subject: sgivwfb: fix sections
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Since the drivers probe call was changed from .init.text to .devinit.text
in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b ("platform-drivers:
move probe to .devinit.text in drivers/video") the fb_fix_screeninfo and
fb_var_screeninfo structures must be changed from .init.data to
.devinit.data, too.

Also the drivers remove routine should be moved from .text to .devexit.text

It removes these 7 section mismatch warnings from modpost:

WARNING: vmlinux.o(.devinit.text+0x1e28): Section mismatch in reference from the function sgivwfb_probe() to the variable .init.data:sgivwfb_fix
The function __devinit sgivwfb_probe() references
a variable __initdata sgivwfb_fix.
If sgivwfb_fix is only used by sgivwfb_probe then
annotate sgivwfb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x1e50): Section mismatch in reference from the function sgivwfb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit sgivwfb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by sgivwfb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x1e59): Section mismatch in reference from the function sgivwfb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit sgivwfb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by sgivwfb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x1e60): Section mismatch in reference from the function sgivwfb_probe() to the variable .init.data:sgivwfb_fix
The function __devinit sgivwfb_probe() references
a variable __initdata sgivwfb_fix.
If sgivwfb_fix is only used by sgivwfb_probe then
annotate sgivwfb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x1e6a): Section mismatch in reference from the function sgivwfb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit sgivwfb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by sgivwfb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x1e7f): Section mismatch in reference from the function sgivwfb_probe() to the variable .init.data:sgivwfb_var1600sw
The function __devinit sgivwfb_probe() references
a variable __initdata sgivwfb_var1600sw.
If sgivwfb_var1600sw is only used by sgivwfb_probe then
annotate sgivwfb_var1600sw with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x1e91): Section mismatch in reference from the function sgivwfb_probe() to the variable .init.data:sgivwfb_var
The function __devinit sgivwfb_probe() references
a variable __initdata sgivwfb_var.
If sgivwfb_var is only used by sgivwfb_probe then
annotate sgivwfb_var with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sgivwfb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/sgivwfb.c~sgivwfb-correct-sections drivers/video/sgivwfb.c
--- a/drivers/video/sgivwfb.c~sgivwfb-correct-sections
+++ a/drivers/video/sgivwfb.c
@@ -47,7 +47,7 @@ static int ywrap = 0;
 
 static int flatpanel_id = -1;
 
-static struct fb_fix_screeninfo sgivwfb_fix __initdata = {
+static struct fb_fix_screeninfo sgivwfb_fix __devinitdata = {
 	.id		= "SGI Vis WS FB",
 	.type		= FB_TYPE_PACKED_PIXELS,
         .visual		= FB_VISUAL_PSEUDOCOLOR,
@@ -57,7 +57,7 @@ static struct fb_fix_screeninfo sgivwfb_
 	.line_length	= 640,
 };
 
-static struct fb_var_screeninfo sgivwfb_var __initdata = {
+static struct fb_var_screeninfo sgivwfb_var __devinitdata = {
 	/* 640x480, 8 bpp */
 	.xres		= 640,
 	.yres		= 480,
@@ -79,7 +79,7 @@ static struct fb_var_screeninfo sgivwfb_
 	.vmode		= FB_VMODE_NONINTERLACED
 };
 
-static struct fb_var_screeninfo sgivwfb_var1600sw __initdata = {
+static struct fb_var_screeninfo sgivwfb_var1600sw __devinitdata = {
 	/* 1600x1024, 8 bpp */
 	.xres		= 1600,
 	.yres		= 1024,
@@ -825,7 +825,7 @@ fail_ioremap_regs:
 	return -ENXIO;
 }
 
-static int sgivwfb_remove(struct platform_device *dev)
+static int __devexit sgivwfb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -845,7 +845,7 @@ static int sgivwfb_remove(struct platfor
 
 static struct platform_driver sgivwfb_driver = {
 	.probe	= sgivwfb_probe,
-	.remove	= sgivwfb_remove,
+	.remove	= __devexit_p(sgivwfb_remove),
 	.driver	= {
 		.name	= "sgivwfb",
 	},
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-arcfb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch
hitfb-correct-sections.patch
s3c2410fb-correct-sections.patch
sgivwfb-correct-sections.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

