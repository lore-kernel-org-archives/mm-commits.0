From: akpm@linux-foundation.org
Subject: + pm2fb-panning-and-hardware-cursor-fixes.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:54 -0700
Message-ID: <200708272223.l7RMNs1R031692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758220AbXH0WX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: panning and hardware cursor fixes
has been added to the -mm tree.  Its filename is
     pm2fb-panning-and-hardware-cursor-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: panning and hardware cursor fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch:
- disallows setting of virtual height above 2048 as it does
  not work for accelerated copyarea and imageblit
- fixes blinking of pm2v cursor by pushing cursor outside
  the display (x=2047)
- fixes hardware cursor position on Permedia 2 chips with
  panning enabled
- enables hardware cursor by default

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-panning-and-hardware-cursor-fixes drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-panning-and-hardware-cursor-fixes
+++ a/drivers/video/pm2fb.c
@@ -66,7 +66,7 @@
 /*
  * Driver data
  */
-static int hwcursor;
+static int hwcursor = 1;
 static char *mode __devinitdata;
 
 /*
@@ -587,6 +587,11 @@ static int pm2fb_check_var(struct fb_var
 		return -EINVAL;
 	}
 
+	/* permedia cannot blit over 2048 */
+	if (var->yres_virtual > 2047) {
+		var->yres_virtual = 2047;
+	}
+
 	if (var->xoffset) {
 		DPRINTK("xoffset not supported\n");
 		return -EINVAL;
@@ -1258,12 +1263,21 @@ static int pm2vfb_cursor(struct fb_info 
 {
 	struct pm2fb_par *par = info->par;
 	u8 mode = PM2F_CURSORMODE_TYPE_X;
+	int x = cursor->image.dx - info->var.xoffset;
+	int y = cursor->image.dy - info->var.yoffset;
 
 	if (cursor->enable)
 		mode |= PM2F_CURSORMODE_CURSOR_ENABLE;
 
 	pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_MODE, mode);
 
+	if (!cursor->enable)
+		x = 2047;	/* push it outside display */
+	pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_LOW, x & 0xff);
+	pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_HIGH, (x >> 8) & 0xf);
+	pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_LOW, y & 0xff);
+	pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_HIGH, (y >> 8) & 0xf);
+
 	/*
 	 * If the cursor is not be changed this means either we want the
 	 * current cursor state (if enable is set) or we want to query what
@@ -1272,16 +1286,6 @@ static int pm2vfb_cursor(struct fb_info 
 	if (!cursor->set)
 		return 0;
 
-	if (cursor->set & FB_CUR_SETPOS) {
-		int x = cursor->image.dx - info->var.xoffset;
-		int y = cursor->image.dy - info->var.yoffset;
-
-		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_LOW, x & 0xff);
-		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_HIGH, (x >> 8) & 0xf);
-		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_LOW, y & 0xff);
-		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_Y_HIGH, (y >> 8) & 0xf);
-	}
-
 	if (cursor->set & FB_CUR_SETHOT) {
 		pm2v_RDAC_WR(par, PM2VI_RD_CURSOR_X_HOT,
 			     cursor->hot.x & 0x3f);
@@ -1373,7 +1377,7 @@ static int pm2fb_cursor(struct fb_info *
 	if (par->type == PM2_TYPE_PERMEDIA2V)
 		return pm2vfb_cursor(info, cursor);
 
-	mode = 0;
+	mode = 0x40;
 	if (cursor->enable)
 		 mode = 0x43;
 
@@ -1388,10 +1392,9 @@ static int pm2fb_cursor(struct fb_info *
 		return 0;
 
 	if (cursor->set & FB_CUR_SETPOS) {
-		int x, y;
+		int x = cursor->image.dx - info->var.xoffset + 63;
+		int y = cursor->image.dy - info->var.yoffset + 63;
 
-		x = cursor->image.dx + 63;
-		y = cursor->image.dy + 63;
 		WAIT_FIFO(par, 4);
 		pm2_WR(par, PM2R_RD_CURSOR_X_LSB, x & 0xff);
 		pm2_WR(par, PM2R_RD_CURSOR_X_MSB, (x >> 8) & 0x7);
@@ -1838,7 +1841,7 @@ module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "Disable acceleration");
 module_param(hwcursor, int, 0644);
 MODULE_PARM_DESC(hwcursor, "Enable hardware cursor "
-			"(1=enable, 0=disable, default=0)");
+			"(1=enable, 0=disable, default=1)");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
