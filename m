From: akpm@linux-foundation.org
Subject: + tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:25:40 -0700
Message-ID: <200903312325.n2VNPeaD007564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764781AbZCaX1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:27:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, khali@linux-fr.org


The patch titled
     tdfxfb: make use of DDC information about connected monitor
has been added to the -mm tree.  Its filename is
     tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

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
Subject: tdfxfb: make use of DDC information about connected monitor
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Read DDC information from a connected monitor and use it to select initial
mode (if the mode is not specified).

Also, use the information to protect against modes outside the monitor
specs.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Tested-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |   67 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-make-use-of-ddc-information-about-connected-monitor drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-make-use-of-ddc-information-about-connected-monitor
+++ a/drivers/video/tdfxfb.c
@@ -487,6 +487,12 @@ static int tdfxfb_check_var(struct fb_va
 		return -EINVAL;
 	}
 
+	if (info->monspecs.hfmax && info->monspecs.vfmax &&
+	    info->monspecs.dclkmax && fb_validate_mode(var, info) < 0) {
+		DPRINTK("mode outside monitor's specs\n");
+		return -EINVAL;
+	}
+
 	var->xres = (var->xres + 15) & ~15; /* could sometimes be 8 */
 	lpitch = var->xres * ((var->bits_per_pixel + 7) >> 3);
 
@@ -1355,6 +1361,23 @@ static void tdfxfb_delete_i2c_busses(str
 		i2c_del_adapter(&par->chan[1].adapter);
 	par->chan[1].par = NULL;
 }
+
+static int tdfxfb_probe_i2c_connector(struct tdfx_par *par,
+				      struct fb_monspecs *specs)
+{
+	u8 *edid = NULL;
+
+	DPRINTK("Probe DDC Bus\n");
+	if (par->chan[0].par)
+		edid = fb_ddc_read(&par->chan[0].adapter);
+
+	if (edid) {
+		fb_edid_to_monspecs(edid, specs);
+		kfree(edid);
+		return 0;
+	}
+	return 1;
+}
 #endif /* CONFIG_FB_3DFX_I2C */
 
 /**
@@ -1372,6 +1395,8 @@ static int __devinit tdfxfb_probe(struct
 	struct tdfx_par *default_par;
 	struct fb_info *info;
 	int err, lpitch;
+	struct fb_monspecs *specs;
+	bool found;
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -1474,15 +1499,49 @@ static int __devinit tdfxfb_probe(struct
 	if (hwcursor)
 		info->fix.smem_len = (info->fix.smem_len - 1024) &
 					(PAGE_MASK << 1);
+	specs = &info->monspecs;
+	found = false;
+	info->var.bits_per_pixel = 8;
 #ifdef CONFIG_FB_3DFX_I2C
 	tdfxfb_create_i2c_busses(info);
+	err = tdfxfb_probe_i2c_connector(default_par, specs);
+
+	if (!err) {
+		if (specs->modedb == NULL)
+			DPRINTK("Unable to get Mode Database\n");
+		else {
+			const struct fb_videomode *m;
+
+			fb_videomode_to_modelist(specs->modedb,
+						 specs->modedb_len,
+						 &info->modelist);
+			m = fb_find_best_display(specs, &info->modelist);
+			if (m) {
+				fb_videomode_to_var(&info->var, m);
+				/* fill all other info->var's fields */
+				if (tdfxfb_check_var(&info->var, info) < 0)
+					info->var = tdfx_var;
+				else
+					found = true;
+			}
+		}
+	}
 #endif
-	if (!mode_option)
+	if (!mode_option && !found)
 		mode_option = "640x480@60";
 
-	err = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8);
-	if (!err || err == 4)
-		info->var = tdfx_var;
+	if (mode_option) {
+		err = fb_find_mode(&info->var, info, mode_option,
+				   specs->modedb, specs->modedb_len,
+				   NULL, info->var.bits_per_pixel);
+		if (!err || err == 4)
+			info->var = tdfx_var;
+	}
+
+	if (found) {
+		fb_destroy_modedb(specs->modedb);
+		specs->modedb = NULL;
+	}
 
 	/* maximize virtual vertical length */
 	lpitch = info->var.xres_virtual * ((info->var.bits_per_pixel + 7) >> 3);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-set-mclk-in-one-place.patch
cirrusfb-gd5434-aka-sd64-support-fixed.patch
cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch
cirrusfb-fix-interlaced-modes.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
remove-cyblafb-driver.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch
tridentfb-delete-acceleration-kconfig-option.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

