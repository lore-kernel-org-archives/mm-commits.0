From: akpm@linux-foundation.org
Subject: - cirrusfb-check_par-fixes.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:26 -0700
Message-ID: <200809031611.m83GBQ0U023771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYICQLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: check_par fixes
has been removed from the -mm tree.  Its filename was
     cirrusfb-check_par-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: check_par fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

1. Check if virtual resolution fits into memory.
   Otherwise, Linux hangs during panning.
2. When selected use all available memory to
    maximize yres_virtual to speed up panning
   (previously also xres_virtual was increased).
3. Simplify memory restriction calculations.

Signed-off-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   59 +++++++++++--------------------------
 1 file changed, 18 insertions(+), 41 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-check_par-fixes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-check_par-fixes
+++ a/drivers/video/cirrusfb.c
@@ -628,27 +628,18 @@ static long cirrusfb_get_mclk(long freq,
 static int cirrusfb_check_var(struct fb_var_screeninfo *var,
 			      struct fb_info *info)
 {
-	int nom, den;		/* translyting from pixels->bytes */
-	int yres, i;
-	static struct { int xres, yres; } modes[] =
-	{ { 1600, 1280 },
-	  { 1280, 1024 },
-	  { 1024, 768 },
-	  { 800, 600 },
-	  { 640, 480 },
-	  { -1, -1 } };
+	int yres;
+	/* memory size in pixels */
+	unsigned pixels = info->screen_size * 8 / var->bits_per_pixel;
 
 	switch (var->bits_per_pixel) {
 	case 1:
-		nom = 4;
-		den = 8;
+		pixels /= 4;
 		break;		/* 8 pixel per byte, only 1/4th of mem usable */
 	case 8:
 	case 16:
 	case 24:
 	case 32:
-		nom = var->bits_per_pixel / 8;
-		den = 1;
 		break;		/* 1 pixel == 1 byte */
 	default:
 		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
@@ -658,43 +649,29 @@ static int cirrusfb_check_var(struct fb_
 		return -EINVAL;
 	}
 
-	if (var->xres * nom / den * var->yres > info->screen_size) {
-		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
-			"resolution too high to fit into video memory!\n",
-			var->xres, var->yres, var->bits_per_pixel);
-		DPRINTK("EXIT - EINVAL error\n");
-		return -EINVAL;
-	}
-
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
 	/* use highest possible virtual resolution */
-	if (var->xres_virtual == -1 &&
-	    var->yres_virtual == -1) {
-		printk(KERN_INFO
-		     "cirrusfb: using maximum available virtual resolution\n");
-		for (i = 0; modes[i].xres != -1; i++) {
-			int size = modes[i].xres * nom / den * modes[i].yres;
-			if (size < info->screen_size / 2)
-				break;
-		}
-		if (modes[i].xres == -1) {
-			printk(KERN_ERR "cirrusfb: could not find a virtual "
-				"resolution that fits into video memory!!\n");
-			DPRINTK("EXIT - EINVAL error\n");
-			return -EINVAL;
-		}
-		var->xres_virtual = modes[i].xres;
-		var->yres_virtual = modes[i].yres;
+	if (var->yres_virtual == -1) {
+		var->yres_virtual = pixels / var->xres_virtual;
 
 		printk(KERN_INFO "cirrusfb: virtual resolution set to "
 			"maximum of %dx%d\n", var->xres_virtual,
 			var->yres_virtual);
 	}
-
-	if (var->xres_virtual < var->xres)
-		var->xres_virtual = var->xres;
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
 
+	if (var->xres_virtual * var->yres_virtual > pixels) {
+		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected... "
+		      "virtual resolution too high to fit into video memory!\n",
+			var->xres_virtual, var->yres_virtual,
+			var->bits_per_pixel);
+		DPRINTK("EXIT - EINVAL error\n");
+		return -EINVAL;
+	}
+
+
 	if (var->xoffset < 0)
 		var->xoffset = 0;
 	if (var->yoffset < 0)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch

