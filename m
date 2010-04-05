From: akpm@linux-foundation.org
Subject: [to-be-updated] fbdev-section-cleanup-in-vga16fb.patch removed from -mm tree
Date: Mon, 05 Apr 2010 12:25:21 -0700
Message-ID: <201004051925.o35JPL3V004288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710Ab0DETZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, arnaud.patard@rtp-net.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: vga16fb: fix section mismatches
has been removed from the -mm tree.  Its filename was
     fbdev-section-cleanup-in-vga16fb.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: vga16fb: fix section mismatches
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix section mismatches in the vga16fb driver.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a420): Section mismatch in re
ference from the function vga16fb_probe() to the (unknown reference) .init.data:
(unknown)
The function __devinit vga16fb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by vga16fb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a437): Section mismatch in reference from the function vga16fb_probe() to the variable .init.data:vga16fb_defined
The function __devinit vga16fb_probe() references
a variable __initdata vga16fb_defined.
If vga16fb_defined is only used by vga16fb_probe then
annotate vga16fb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a457): Section mismatch in reference from the function vga16fb_probe() to the variable .init.data:vga16fb_fix
The function __devinit vga16fb_probe() references
a variable __initdata vga16fb_fix.
If vga16fb_fix is only used by vga16fb_probe then
annotate vga16fb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vga16fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/vga16fb.c~fbdev-section-cleanup-in-vga16fb drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~fbdev-section-cleanup-in-vga16fb
+++ a/drivers/video/vga16fb.c
@@ -65,7 +65,7 @@ struct vga16fb_par {
 
 /* --------------------------------------------------------------------- */
 
-static struct fb_var_screeninfo vga16fb_defined __initdata = {
+static struct fb_var_screeninfo vga16fb_defined __devinitdata = {
 	.xres		= 640,
 	.yres		= 480,
 	.xres_virtual	= 640,
@@ -85,7 +85,7 @@ static struct fb_var_screeninfo vga16fb_
 };
 
 /* name should not depend on EGA/VGA */
-static struct fb_fix_screeninfo vga16fb_fix __initdata = {
+static struct fb_fix_screeninfo vga16fb_fix __devinitdata = {
 	.id		= "VGA16 VGA",
 	.smem_start	= VGA_FB_PHYS,
 	.smem_len	= VGA_FB_PHYS_LEN,
@@ -1278,7 +1278,7 @@ static struct fb_ops vga16fb_ops = {
 };
 
 #ifndef MODULE
-static int vga16fb_setup(char *options)
+static int __init vga16fb_setup(char *options)
 {
 	char *this_opt;
 	
@@ -1376,7 +1376,7 @@ static int __devinit vga16fb_probe(struc
 	return ret;
 }
 
-static int vga16fb_remove(struct platform_device *dev)
+static int __devexit vga16fb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -1393,7 +1393,7 @@ static int vga16fb_remove(struct platfor
 
 static struct platform_driver vga16fb_driver = {
 	.probe = vga16fb_probe,
-	.remove = vga16fb_remove,
+	.remove = __devexit_p(vga16fb_remove),
 	.driver = {
 		.name = "vga16fb",
 	},
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

