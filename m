From: akpm@linux-foundation.org
Subject: + s3c2410fb-make-use-of-default_display-settings.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:34 -0700
Message-ID: <200708272223.l7RMNYJr031661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757822AbXH0WXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: make use of default_display settings
has been added to the -mm tree.  Its filename is
     s3c2410fb-make-use-of-default_display-settings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: make use of default_display settings
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch changes mode selection to always prefer default mode if possible
and always honor type of display set by default mode settings.

This patch is required in case the same display modes were defined for
different panels (e.g.  STN and TFT).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-make-use-of-default_display-settings drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-make-use-of-default_display-settings
+++ a/drivers/video/s3c2410fb.c
@@ -172,19 +172,28 @@ static int s3c2410fb_check_var(struct fb
 	struct s3c2410fb_info *fbi = info->par;
 	struct s3c2410fb_mach_info *mach_info = fbi->dev->platform_data;
 	struct s3c2410fb_display *display = NULL;
+	struct s3c2410fb_display *default_display = mach_info->displays +
+						    mach_info->default_display;
+	int type = default_display->type;
 	unsigned i;
 
 	dprintk("check_var(var=%p, info=%p)\n", var, info);
 
 	/* validate x/y resolution */
-
-	for (i = 0; i < mach_info->num_displays; i++)
-		if (var->yres == mach_info->displays[i].yres &&
-		    var->xres == mach_info->displays[i].xres &&
-		    var->bits_per_pixel == mach_info->displays[i].bpp) {
-			display = mach_info->displays + i;
-			break;
-		}
+	/* choose default mode if possible */
+	if (var->yres == default_display->yres &&
+	    var->xres == default_display->xres &&
+	    var->bits_per_pixel == default_display->bpp)
+		display = default_display;
+	else
+		for (i = 0; i < mach_info->num_displays; i++)
+			if (type == mach_info->displays[i].type &&
+			    var->yres == mach_info->displays[i].yres &&
+			    var->xres == mach_info->displays[i].xres &&
+			    var->bits_per_pixel == mach_info->displays[i].bpp) {
+				display = mach_info->displays + i;
+				break;
+			}
 
 	if (!display) {
 		dprintk("wrong resolution or depth %dx%d at %d bpp\n",
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
