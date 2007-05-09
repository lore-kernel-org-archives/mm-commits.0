From: akpm@linux-foundation.org
Subject: - s3fb-driver-fixes.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:52 -0700
Message-ID: <200705090301.l4931qgn010765@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032712AbXEIDB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3fb: driver fixes
has been removed from the -mm tree.  Its filename was
     s3fb-driver-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3fb: driver fixes
From: Ondrej Zajicek <santiago@crfreenet.org>

This fixes broken fbcon on Virge VX in 24 bpp mode, and contains several
other small updates.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/s3fb.txt |   12 ++++++++----
 drivers/video/s3fb.c      |   21 ++++++++++-----------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -puN Documentation/fb/s3fb.txt~s3fb-driver-fixes Documentation/fb/s3fb.txt
--- a/Documentation/fb/s3fb.txt~s3fb-driver-fixes
+++ a/Documentation/fb/s3fb.txt
@@ -35,10 +35,12 @@ Supported Features
 	* suspend/resume support
 	* DPMS support
 
-Text mode is supported even in higher resolutions, but there is limitation
-to lower pixclocks (maximum between 50-60 MHz, depending on specific hardware).
-This limitation is not enforced by driver. Text mode supports 8bit wide fonts
-only (hardware limitation) and 16bit tall fonts (driver limitation).
+Text mode is supported even in higher resolutions, but there is limitation to
+lower pixclocks (maximum usually between 50-60 MHz, depending on specific
+hardware, i get best results from plain S3 Trio32 card - about 75 MHz). This
+limitation is not enforced by driver. Text mode supports 8bit wide fonts only
+(hardware limitation) and 16bit tall fonts (driver limitation). Text mode
+support is broken on S3 Trio64 V2/DX.
 
 There are two 4 bpp modes. First mode (selected if nonstd == 0) is mode with
 packed pixels, high nibble first. Second mode (selected if nonstd == 1) is mode
@@ -73,6 +75,8 @@ Known bugs
 ==========
 
 	* cursor disable in text mode doesn't work
+	* text mode broken on S3 Trio64 V2/DX
+
 
 --
 Ondrej Zajicek <santiago@crfreenet.org>
diff -puN drivers/video/s3fb.c~s3fb-driver-fixes drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-driver-fixes
+++ a/drivers/video/s3fb.c
@@ -65,7 +65,7 @@ static const struct svga_fb_format s3fb_
 
 
 static const struct svga_pll s3_pll = {3, 129, 3, 33, 0, 3,
-	60000, 240000, 14318};
+	35000, 240000, 14318};
 
 static const int s3_memsizes[] = {4096, 0, 3072, 8192, 2048, 6144, 1024, 512};
 
@@ -331,8 +331,13 @@ static void s3_set_pixclock(struct fb_in
 {
 	u16 m, n, r;
 	u8 regval;
+	int rv;
 
-	svga_compute_pll(&s3_pll, 1000000000 / pixclock, &m, &n, &r, info->node);
+	rv = svga_compute_pll(&s3_pll, 1000000000 / pixclock, &m, &n, &r, info->node);
+	if (rv < 0) {
+		printk(KERN_ERR "fb%d: cannot set requested pixclock, keeping old value\n", info->node);
+		return;
+	}
 
 	/* Set VGA misc register  */
 	regval = vga_r(NULL, VGA_MIS_R);
@@ -710,7 +715,7 @@ static int s3fb_setcolreg(u_int regno, u
 		break;
 	case 16:
 		if (regno >= 16)
-			return -EINVAL;
+			return 0;
 
 		if (fb->var.green.length == 5)
 			((u32*)fb->pseudo_palette)[regno] = ((red & 0xF800) >> 1) |
@@ -723,9 +728,9 @@ static int s3fb_setcolreg(u_int regno, u
 	case 24:
 	case 32:
 		if (regno >= 16)
-			return -EINVAL;
+			return 0;
 
-		((u32*)fb->pseudo_palette)[regno] = ((transp & 0xFF00) << 16) | ((red & 0xFF00) << 8) |
+		((u32*)fb->pseudo_palette)[regno] = ((red & 0xFF00) << 8) |
 			(green & 0xFF00) | ((blue & 0xFF00) >> 8);
 		break;
 	default:
@@ -778,12 +783,6 @@ static int s3fb_pan_display(struct fb_va
 
 	unsigned int offset;
 
-	/* Validate the offsets */
-	if ((var->xoffset + var->xres) > var->xres_virtual)
-		return -EINVAL;
-	if ((var->yoffset + var->yres) > var->yres_virtual)
-		return -EINVAL;
-
 	/* Calculate the offset */
 	if (var->bits_per_pixel == 0) {
 		offset = (var->yoffset / 16) * (var->xres_virtual / 2) + (var->xoffset / 2);
_

Patches currently in -mm which might be from santiago@crfreenet.org are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
