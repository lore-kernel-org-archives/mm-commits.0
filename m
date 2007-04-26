From: akpm@linux-foundation.org
Subject: + fbcon-font-setting-should-check-limitation-of-driver.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:10 -0700
Message-ID: <200704260033.l3Q0XAYP016985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423440AbXDZAdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: font setting should check limitation of driver
has been added to the -mm tree.  Its filename is
     fbcon-font-setting-should-check-limitation-of-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: font setting should check limitation of driver
From: "Antonino A. Daplas" <adaplas@gmail.com>

fbcon_set_font() will now check if the new font dimensions can be drawn by the
driver (by checking pixmap.blit_x and blit_y).  Similarly, add 2 new
parameters to get_default_font(), font_w and font_h, to further aid in the
font selection process.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c   |   17 ++++++++++++++---
 drivers/video/console/fonts.c   |   10 +++++++++-
 drivers/video/console/sticore.c |    2 +-
 include/linux/font.h            |    3 ++-
 4 files changed, 26 insertions(+), 6 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-font-setting-should-check-limitation-of-driver drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-font-setting-should-check-limitation-of-driver
+++ a/drivers/video/console/fbcon.c
@@ -988,7 +988,9 @@ static const char *fbcon_startup(void)
 	if (!p->fontdata) {
 		if (!fontname[0] || !(font = find_font(fontname)))
 			font = get_default_font(info->var.xres,
-						info->var.yres);
+						info->var.yres,
+						info->pixmap.blit_x,
+						info->pixmap.blit_y);
 		vc->vc_font.width = font->width;
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
@@ -1108,7 +1110,9 @@ static void fbcon_init(struct vc_data *v
 
 			if (!fontname[0] || !(font = find_font(fontname)))
 				font = get_default_font(info->var.xres,
-							info->var.yres);
+							info->var.yres,
+							info->pixmap.blit_x,
+							info->pixmap.blit_y);
 			vc->vc_font.width = font->width;
 			vc->vc_font.height = font->height;
 			vc->vc_font.data = (void *)(p->fontdata = font->data);
@@ -2495,6 +2499,7 @@ static int fbcon_copy_font(struct vc_dat
 
 static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigned flags)
 {
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	unsigned charcount = font->charcount;
 	int w = font->width;
 	int h = font->height;
@@ -2508,6 +2513,11 @@ static int fbcon_set_font(struct vc_data
 	if (charcount != 256 && charcount != 512)
 		return -EINVAL;
 
+	/* Make sure drawing engine can handle the font */
+	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
+	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
+		return -EINVAL;
+
 	size = h * pitch * charcount;
 
 	new_data = kmalloc(FONT_EXTRA_WORDS * sizeof(int) + size, GFP_USER);
@@ -2552,7 +2562,8 @@ static int fbcon_set_def_font(struct vc_
 	const struct font_desc *f;
 
 	if (!name)
-		f = get_default_font(info->var.xres, info->var.yres);
+		f = get_default_font(info->var.xres, info->var.yres,
+				     info->pixmap.blit_x, info->pixmap.blit_y);
 	else if (!(f = find_font(name)))
 		return -ENOENT;
 
diff -puN drivers/video/console/fonts.c~fbcon-font-setting-should-check-limitation-of-driver drivers/video/console/fonts.c
--- a/drivers/video/console/fonts.c~fbcon-font-setting-should-check-limitation-of-driver
+++ a/drivers/video/console/fonts.c
@@ -98,6 +98,8 @@ const struct font_desc *find_font(const 
  *	get_default_font - get default font
  *	@xres: screen size of X
  *	@yres: screen size of Y
+ *      @font_w: bit array of supported widths (1 - 32)
+ *      @font_h: bit array of supported heights (1 - 32)
  *
  *	Get the default font for a specified screen size.
  *	Dimensions are in pixels.
@@ -107,7 +109,8 @@ const struct font_desc *find_font(const 
  *
  */
 
-const struct font_desc *get_default_font(int xres, int yres)
+const struct font_desc *get_default_font(int xres, int yres, u32 font_w,
+					 u32 font_h)
 {
     int i, c, cc;
     const struct font_desc *f, *g;
@@ -129,6 +132,11 @@ const struct font_desc *get_default_font
 #endif
 	if ((yres < 400) == (f->height <= 8))
 	    c += 1000;
+
+	if (!(font_w & (1 << (f->width - 1))) ||
+	    !(font_w & (1 << (f->height - 1))))
+	    c += 1000;
+
 	if (c > cc) {
 	    cc = c;
 	    g = f;
diff -puN drivers/video/console/sticore.c~fbcon-font-setting-should-check-limitation-of-driver drivers/video/console/sticore.c
--- a/drivers/video/console/sticore.c~fbcon-font-setting-should-check-limitation-of-driver
+++ a/drivers/video/console/sticore.c
@@ -495,7 +495,7 @@ sti_select_fbfont(struct sti_cooked_rom 
 		return NULL;
 	fbfont = find_font(fbfont_name);
 	if (!fbfont)
-		fbfont = get_default_font(1024,768);
+		fbfont = get_default_font(1024,768, ~(u32)0, ~(u32)0);
 	if (!fbfont)
 		return NULL;
 
diff -puN include/linux/font.h~fbcon-font-setting-should-check-limitation-of-driver include/linux/font.h
--- a/include/linux/font.h~fbcon-font-setting-should-check-limitation-of-driver
+++ a/include/linux/font.h
@@ -49,7 +49,8 @@ extern const struct font_desc *find_font
 
 /* Get the default font for a specific screen size */
 
-extern const struct font_desc *get_default_font(int xres, int yres);
+extern const struct font_desc *get_default_font(int xres, int yres,
+						u32 font_w, u32 font_h);
 
 /* Max. length for the name of a predefined font */
 #define MAX_FONT_NAME	32
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
skeletonfb-various-corrections.patch
epson1355fbc-fix-error-handling-code.patch
nvidiafb-vga-state-save-and-restore.patch
savagefb-rework-i2c-bit-access.patch
savagefb-vga-state-save-and-restore.patch
fbdev-link-vgastateo-using-kconfig.patch
fbcon-delay-screen-update-when-setting-the-mode-of.patch
nvidiafb-fix-sparse-warning.patch
rivafb-fix-io-access.patch
fbdev-kill-sparse-warning-in-deferred-io.patch
fbdev-add-sparse-annotations-in-svgalibc.patch
arcfb-kill-sparse-warning.patch
s3fb-add-sparse-annotations.patch
hecubafb-kill-sparse-warnings.patch
i810fb-fix-incorrect-frequency-mask.patch
vt-add-documentation-for-new-boot-sysfs-options.patch
skeletonfb-documentation-error-fixes.patch
fbdev-add-drawing-functions-for-framebuffers-in-system.patch
arcfb-use-sys-instead-of-cfb-drawing-functions.patch
hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
vfb-use-sys-instead-of-cfb-drawing-functions.patch
fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
arcfb-us-fb_sys_read.patch
hecubafb-us-fb_sys_read.patch
vfb-us-fb_sys_read-and-fb_sys_write.patch
fbdev-consolidate-common-drawing-functions-into-a.patch
fbdev-advertise-limitation-of-drawing-engine.patch
fbcon-font-setting-should-check-limitation-of-driver.patch
vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
fbdev-add-tile-operation-to-get-the-maximum-length.patch
s3fb-implement-fb_get_tilemax.patch
fbcon-check-if-the-character-count-can-be-handled.patch
fbdev-save-the-activate-field-before-calling-fb_check_var.patch
s3fb-driver-fixes.patch
vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
nvidiafb-prevent-triggering-of-softlockup.patch
