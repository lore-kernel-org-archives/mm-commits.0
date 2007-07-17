From: akpm@linux-foundation.org
Subject: - fbdev-add-fb_append_extra_logo-update.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:56:20 -0700
Message-ID: <200707170856.l6H8uKGS008729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758861AbXGQI5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: Add fb_append_extra_logo() (update)
has been removed from the -mm tree.  Its filename was
     fbdev-add-fb_append_extra_logo-update.patch

This patch was dropped because it was folded into fbdev-add-fb_append_extra_logo.patch

------------------------------------------------------
Subject: fbdev: Add fb_append_extra_logo() (update)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  - Introduce CONFIG_FB_LOGO_EXTRA to protect all new code
  - Move fb_prepare_logo() down to satisfy declaration dependencies

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c      |  232 +++++++++++++++++++----------------
 drivers/video/logo/Kconfig |    4 
 include/linux/linux_logo.h |    2 
 3 files changed, 137 insertions(+), 101 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-add-fb_append_extra_logo-update drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-fb_append_extra_logo-update
+++ a/drivers/video/fbmem.c
@@ -311,13 +311,6 @@ static struct logo_data {
 	const struct linux_logo *logo;
 } fb_logo __read_mostly;
 
-#define FB_LOGO_EX_NUM_MAX 10
-static struct logo_data_extra {
-	const struct linux_logo *logo;
-	unsigned int n;
-} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
-static unsigned int fb_logo_ex_num;
-
 static void fb_rotate_logo_ud(const u8 *in, u8 *out, u32 width, u32 height)
 {
 	u32 size = width * height, i;
@@ -411,7 +404,84 @@ static void fb_do_show_logo(struct fb_in
 	}
 }
 
-#ifdef CONFIG_FB
+static int fb_show_logo_line(struct fb_info *info, int rotate,
+			     const struct linux_logo *logo, int y,
+			     unsigned int n)
+{
+	u32 *palette = NULL, *saved_pseudo_palette = NULL;
+	unsigned char *logo_new = NULL, *logo_rotate = NULL;
+	struct fb_image image;
+
+	/* Return if the frame buffer is not mapped or suspended */
+	if (logo == NULL || info->state != FBINFO_STATE_RUNNING ||
+	    info->flags & FBINFO_MODULE)
+		return 0;
+
+	image.depth = 8;
+	image.data = logo->data;
+
+	if (fb_logo.needs_cmapreset)
+		fb_set_logocmap(info, logo);
+
+	if (fb_logo.needs_truepalette ||
+	    fb_logo.needs_directpalette) {
+		palette = kmalloc(256 * 4, GFP_KERNEL);
+		if (palette == NULL)
+			return 0;
+
+		if (fb_logo.needs_truepalette)
+			fb_set_logo_truepalette(info, logo, palette);
+		else
+			fb_set_logo_directpalette(info, logo, palette);
+
+		saved_pseudo_palette = info->pseudo_palette;
+		info->pseudo_palette = palette;
+	}
+
+	if (fb_logo.depth <= 4) {
+		logo_new = kmalloc(logo->width * logo->height, GFP_KERNEL);
+		if (logo_new == NULL) {
+			kfree(palette);
+			if (saved_pseudo_palette)
+				info->pseudo_palette = saved_pseudo_palette;
+			return 0;
+		}
+		image.data = logo_new;
+		fb_set_logo(info, logo, logo_new, fb_logo.depth);
+	}
+
+	image.dx = 0;
+	image.dy = y;
+	image.width = logo->width;
+	image.height = logo->height;
+
+	if (rotate) {
+		logo_rotate = kmalloc(logo->width *
+				      logo->height, GFP_KERNEL);
+		if (logo_rotate)
+			fb_rotate_logo(info, logo_rotate, &image, rotate);
+	}
+
+	fb_do_show_logo(info, &image, rotate, n);
+
+	kfree(palette);
+	if (saved_pseudo_palette != NULL)
+		info->pseudo_palette = saved_pseudo_palette;
+	kfree(logo_new);
+	kfree(logo_rotate);
+	return logo->height;
+}
+
+
+#ifdef CONFIG_FB_LOGO_EXTRA
+
+#define FB_LOGO_EX_NUM_MAX 10
+static struct logo_data_extra {
+	const struct linux_logo *logo;
+	unsigned int n;
+} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
+static unsigned int fb_logo_ex_num;
+
 void fb_append_extra_logo(const struct linux_logo *logo, unsigned int n)
 {
 	if (!n || fb_logo_ex_num == FB_LOGO_EX_NUM_MAX)
@@ -421,12 +491,59 @@ void fb_append_extra_logo(const struct l
 	fb_logo_ex[fb_logo_ex_num].n = n;
 	fb_logo_ex_num++;
 }
-#endif
+
+static int fb_prepare_extra_logos(struct fb_info *info, unsigned int height,
+				  unsigned int yres)
+{
+	unsigned int i;
+
+	/* FIXME: logo_ex supports only truecolor fb. */
+	if (info->fix.visual != FB_VISUAL_TRUECOLOR)
+		fb_logo_ex_num = 0;
+
+	for (i = 0; i < fb_logo_ex_num; i++) {
+		height += fb_logo_ex[i].logo->height;
+		if (height > yres) {
+			height -= fb_logo_ex[i].logo->height;
+			fb_logo_ex_num = i;
+			break;
+		}
+	}
+	return height;
+}
+
+static int fb_show_extra_logos(struct fb_info *info, int y, int rotate)
+{
+	unsigned int i;
+
+	for (i = 0; i < fb_logo_ex_num; i++)
+		y += fb_show_logo_line(info, rotate,
+				       fb_logo_ex[i].logo, y, fb_logo_ex[i].n);
+
+	return y;
+}
+
+#else /* !CONFIG_FB_LOGO_EXTRA */
+
+static inline int fb_prepare_extra_logos(struct fb_info *info,
+					 unsigned int height,
+					 unsigned int yres)
+{
+	return height;
+}
+
+static inline int fb_show_extra_logos(struct fb_info *info, int y, int rotate)
+{
+	return y;
+}
+
+#endif /* CONFIG_FB_LOGO_EXTRA */
+
 
 int fb_prepare_logo(struct fb_info *info, int rotate)
 {
 	int depth = fb_get_color_depth(&info->var, &info->fix);
-	unsigned int yres, height, i;
+	unsigned int yres;
 
 	memset(&fb_logo, 0, sizeof(struct logo_data));
 
@@ -468,7 +585,7 @@ int fb_prepare_logo(struct fb_info *info
 	if (!fb_logo.logo) {
 		return 0;
 	}
-	
+
 	if (rotate == FB_ROTATE_UR || rotate == FB_ROTATE_UD)
 		yres = info->var.yres;
 	else
@@ -485,103 +602,18 @@ int fb_prepare_logo(struct fb_info *info
 	else if (fb_logo.logo->type == LINUX_LOGO_VGA16)
 		fb_logo.depth = 4;
 	else
-		fb_logo.depth = 1;		
+		fb_logo.depth = 1;
 
-	/* FIXME: logo_ex supports only truecolor fb. */
-	if (info->fix.visual != FB_VISUAL_TRUECOLOR)
-		fb_logo_ex_num = 0;
-
-	height = fb_logo.logo->height;
-	for (i = 0; i < fb_logo_ex_num; i++) {
-		height += fb_logo_ex[i].logo->height;
-		if (height > yres) {
-			height -= fb_logo_ex[i].logo->height;
-			fb_logo_ex_num = i;
-			break;
-		}
-	}
-	return height;
-}
-
-static int fb_show_logo_line(struct fb_info *info, int rotate,
-			     const struct linux_logo *logo, int y,
-			     unsigned int n)
-{
-	u32 *palette = NULL, *saved_pseudo_palette = NULL;
-	unsigned char *logo_new = NULL, *logo_rotate = NULL;
-	struct fb_image image;
-
-	/* Return if the frame buffer is not mapped or suspended */
-	if (logo == NULL || info->state != FBINFO_STATE_RUNNING ||
-	    info->flags & FBINFO_MODULE)
-		return 0;
-
-	image.depth = 8;
-	image.data = logo->data;
-
-	if (fb_logo.needs_cmapreset)
-		fb_set_logocmap(info, logo);
-
-	if (fb_logo.needs_truepalette || 
-	    fb_logo.needs_directpalette) {
-		palette = kmalloc(256 * 4, GFP_KERNEL);
-		if (palette == NULL)
-			return 0;
-
-		if (fb_logo.needs_truepalette)
-			fb_set_logo_truepalette(info, logo, palette);
-		else
-			fb_set_logo_directpalette(info, logo, palette);
-
-		saved_pseudo_palette = info->pseudo_palette;
-		info->pseudo_palette = palette;
-	}
-
-	if (fb_logo.depth <= 4) {
-		logo_new = kmalloc(logo->width * logo->height, GFP_KERNEL);
-		if (logo_new == NULL) {
-			kfree(palette);
-			if (saved_pseudo_palette)
-				info->pseudo_palette = saved_pseudo_palette;
-			return 0;
-		}
-		image.data = logo_new;
-		fb_set_logo(info, logo, logo_new, fb_logo.depth);
-	}
-
-	image.dx = 0;
-	image.dy = y;
-	image.width = logo->width;
-	image.height = logo->height;
-
-	if (rotate) {
-		logo_rotate = kmalloc(logo->width *
-				      logo->height, GFP_KERNEL);
-		if (logo_rotate)
-			fb_rotate_logo(info, logo_rotate, &image, rotate);
-	}
-
-	fb_do_show_logo(info, &image, rotate, n);
-
-	kfree(palette);
-	if (saved_pseudo_palette != NULL)
-		info->pseudo_palette = saved_pseudo_palette;
-	kfree(logo_new);
-	kfree(logo_rotate);
-	return logo->height;
+	return fb_prepare_extra_logos(info, fb_logo.logo->height, yres);
 }
 
 int fb_show_logo(struct fb_info *info, int rotate)
 {
-	int y, i;
+	int y;
 
 	y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
 			      num_online_cpus());
-
-	for (i = 0; i < fb_logo_ex_num; i++) {
-		y += fb_show_logo_line(info, rotate,
-				       fb_logo_ex[i].logo, y, fb_logo_ex[i].n);
-	}
+	y = fb_show_extra_logos(info, y, rotate);
 
 	return y;
 }
diff -puN drivers/video/logo/Kconfig~fbdev-add-fb_append_extra_logo-update drivers/video/logo/Kconfig
--- a/drivers/video/logo/Kconfig~fbdev-add-fb_append_extra_logo-update
+++ a/drivers/video/logo/Kconfig
@@ -10,6 +10,10 @@ menuconfig LOGO
 
 if LOGO
 
+config FB_LOGO_EXTRA
+	bool
+	depends on FB
+
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
 	default y
diff -puN include/linux/linux_logo.h~fbdev-add-fb_append_extra_logo-update include/linux/linux_logo.h
--- a/include/linux/linux_logo.h~fbdev-add-fb_append_extra_logo-update
+++ a/include/linux/linux_logo.h
@@ -33,7 +33,7 @@ struct linux_logo {
 };
 
 extern const struct linux_logo *fb_find_logo(int depth);
-#if defined(CONFIG_LOGO) && defined(CONFIG_FB)
+#ifdef CONFIG_FB_LOGO_EXTRA
 extern void fb_append_extra_logo(const struct linux_logo *logo,
 				 unsigned int n);
 #else
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-extract-fb_show_logo_line.patch
fbdev-add-fb_append_extra_logo.patch
fbdev-add-fb_append_extra_logo-update.patch
fbdev-spe-helper-penguin-logo.patch
cell-draw-spe-helper-penguin-logos.patch
cell-draw-spe-helper-penguin-logos-update.patch
