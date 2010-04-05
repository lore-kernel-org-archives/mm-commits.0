From: akpm@linux-foundation.org
Subject: [to-be-updated] fbdev-section-cleanup-in-efifb.patch removed from -mm tree
Date: Mon, 05 Apr 2010 12:25:08 -0700
Message-ID: <201004051925.o35JP8uG004268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab0DETZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, pjones@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: efifb: fix section mismatches
has been removed from the -mm tree.  Its filename was
     fbdev-section-cleanup-in-efifb.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: efifb: fix section mismatches
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix section mismatches on the efifb driver.

WARNING: drivers/video/built-in.o(.devinit.text+0x19f8c): Section mismatch in re
ference from the function efifb_probe() to the (unknown reference) .init.data:(u
nknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x19f9a): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x19fa1): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x19fa7): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/efifb.c~fbdev-section-cleanup-in-efifb drivers/video/efifb.c
--- a/drivers/video/efifb.c~fbdev-section-cleanup-in-efifb
+++ a/drivers/video/efifb.c
@@ -16,7 +16,7 @@
 
 #include <video/vga.h>
 
-static struct fb_var_screeninfo efifb_defined __initdata = {
+static struct fb_var_screeninfo efifb_defined __devinitdata = {
 	.activate		= FB_ACTIVATE_NOW,
 	.height			= -1,
 	.width			= -1,
@@ -27,7 +27,7 @@ static struct fb_var_screeninfo efifb_de
 	.vmode			= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo efifb_fix __initdata = {
+static struct fb_fix_screeninfo efifb_fix __devinitdata = {
 	.id			= "EFI VGA",
 	.type			= FB_TYPE_PACKED_PIXELS,
 	.accel			= FB_ACCEL_NONE,
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-efifb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vesafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

