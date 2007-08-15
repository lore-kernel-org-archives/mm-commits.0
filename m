From: akpm@linux-foundation.org
Subject: + pm3fb-hardware-cursor-support.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:20:58 -0700
Message-ID: <200708152320.l7FNKwCg020310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbXHOXVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: hardware cursor support
has been added to the -mm tree.  Its filename is
     pm3fb-hardware-cursor-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: hardware cursor support
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds hardware cursor support to the pm3fb driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |  118 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 118 insertions(+)

diff -puN drivers/video/pm3fb.c~pm3fb-hardware-cursor-support drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-hardware-cursor-support
+++ a/drivers/video/pm3fb.c
@@ -55,6 +55,7 @@
 /*
  * Driver data
  */
+static int hwcursor = 1;
 static char *mode_option __devinitdata;
 static int noaccel __devinitdata;
 
@@ -604,6 +605,117 @@ static void pm3fb_imageblit(struct fb_in
 }
 /* end of acceleration functions */
 
+/*
+ *	Hardware Cursor support.
+ */
+static const u8 cursor_bits_lookup[16] = {
+	0x00, 0x40, 0x10, 0x50, 0x04, 0x44, 0x14, 0x54,
+	0x01, 0x41, 0x11, 0x51, 0x05, 0x45, 0x15, 0x55
+};
+
+static int pm3fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+{
+	struct pm3_par *par = info->par;
+	u8 mode;
+
+	if (!hwcursor)
+		return -EINVAL;	/* just to force soft_cursor() call */
+
+	/* Too large of a cursor or wrong bpp :-( */
+	if (cursor->image.width > 64 ||
+	    cursor->image.height > 64 ||
+	    cursor->image.depth > 1)
+		return -EINVAL;
+
+	mode = PM3RD_CursorMode_TYPE_X;
+	if (cursor->enable)
+		 mode |= PM3RD_CursorMode_CURSOR_ENABLE;
+
+	PM3_WRITE_DAC_REG(par, PM3RD_CursorMode, mode);
+
+	/*
+	 * If the cursor is not be changed this means either we want the
+	 * current cursor state (if enable is set) or we want to query what
+	 * we can do with the cursor (if enable is not set)
+	 */
+	if (!cursor->set)
+		return 0;
+
+	if (cursor->set & FB_CUR_SETPOS) {
+		int x = cursor->image.dx - info->var.xoffset;
+		int y = cursor->image.dy - info->var.yoffset;
+
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorXLow, x & 0xff);
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorXHigh, (x >> 8) & 0xf);
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorYLow, y & 0xff);
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorYHigh, (y >> 8) & 0xf);
+	}
+
+	if (cursor->set & FB_CUR_SETHOT) {
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorHotSpotX,
+				  cursor->hot.x & 0x3f);
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorHotSpotY,
+				  cursor->hot.y & 0x3f);
+	}
+
+	if (cursor->set & FB_CUR_SETCMAP) {
+		u32 fg_idx = cursor->image.fg_color;
+		u32 bg_idx = cursor->image.bg_color;
+		struct fb_cmap cmap = info->cmap;
+
+		/* the X11 driver says one should use these color registers */
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorPalette(39),
+				  cmap.red[fg_idx] >> 8 );
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorPalette(40),
+				  cmap.green[fg_idx] >> 8 );
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorPalette(41),
+				  cmap.blue[fg_idx] >> 8 );
+
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorPalette(42),
+				  cmap.red[bg_idx] >> 8 );
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorPalette(43),
+				  cmap.green[bg_idx] >> 8 );
+		PM3_WRITE_DAC_REG(par, PM3RD_CursorPalette(44),
+				  cmap.blue[bg_idx] >> 8 );
+	}
+
+	if (cursor->set & (FB_CUR_SETSHAPE | FB_CUR_SETIMAGE)) {
+		u8 *bitmap = (u8 *)cursor->image.data;
+		u8 *mask = (u8 *)cursor->mask;
+		int i;
+		int pos = PM3RD_CursorPattern(0);
+
+		for (i = 0; i < cursor->image.height; i++) {
+			int j = (cursor->image.width + 7) >> 3;
+			int k = 8 - j;
+
+			for (; j > 0; j--) {
+				u8 data = *bitmap ^ *mask;
+
+				if (cursor->rop == ROP_COPY)
+					data = *mask & *bitmap;
+				/* Upper 4 bits of bitmap data */
+				PM3_WRITE_DAC_REG(par, pos++,
+					cursor_bits_lookup[data >> 4] |
+					(cursor_bits_lookup[*mask >> 4] << 1));
+				/* Lower 4 bits of bitmap */
+				PM3_WRITE_DAC_REG(par, pos++,
+					cursor_bits_lookup[data & 0xf] |
+					(cursor_bits_lookup[*mask & 0xf] << 1));
+				bitmap++;
+				mask++;
+			}
+			for (; k > 0; k--) {
+				PM3_WRITE_DAC_REG(par, pos++, 0);
+				PM3_WRITE_DAC_REG(par, pos++, 0);
+			}
+		}
+		while (pos < PM3RD_CursorPattern(1024))
+			PM3_WRITE_DAC_REG(par, pos++, 0);
+	}
+	return 0;
+}
+
 /* write the mode to registers */
 static void pm3fb_write_mode(struct fb_info *info)
 {
@@ -1105,6 +1217,7 @@ static struct fb_ops pm3fb_ops = {
 	.fb_imageblit	= pm3fb_imageblit,
 	.fb_blank	= pm3fb_blank,
 	.fb_sync	= pm3fb_sync,
+	.fb_cursor	= pm3fb_cursor,
 };
 
 /* ------------------------------------------------------------------------- */
@@ -1420,6 +1533,8 @@ static int __init pm3fb_setup(char *opti
 			continue;
 		else if (!strncmp(this_opt, "noaccel", 7))
 			noaccel = 1;
+		else if (!strncmp(this_opt, "hwcursor=", 9))
+			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
 #ifdef CONFIG_MTRR
 		else if (!strncmp(this_opt, "nomtrr", 6))
 			nomtrr = 1;
@@ -1459,6 +1574,9 @@ module_init(pm3fb_init);
 
 module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "Disable acceleration");
+module_param(hwcursor, int, 0644);
+MODULE_PARM_DESC(hwcursor, "Enable hardware cursor "
+			"(1=enable, 0=disable, default=1)");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

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
