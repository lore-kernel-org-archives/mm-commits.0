From: akpm@linux-foundation.org
Subject: - fbdev-add-fb_append_extra_logo.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:08 -0700
Message-ID: <200707172308.l6HN88Ii012259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936810AbXGQXRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: Add fb_append_extra_logo()
has been removed from the -mm tree.  Its filename was
     fbdev-add-fb_append_extra_logo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: Add fb_append_extra_logo()
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add fb_append_extra_logo(), to append extra lines of logos below the standard
Linux logo.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c      |  212 +++++++++++++++++++++++------------
 drivers/video/logo/Kconfig |    4 
 include/linux/linux_logo.h |    8 +
 3 files changed, 155 insertions(+), 69 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-add-fb_append_extra_logo drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-fb_append_extra_logo
+++ a/drivers/video/fbmem.c
@@ -404,72 +404,6 @@ static void fb_do_show_logo(struct fb_in
 	}
 }
 
-int fb_prepare_logo(struct fb_info *info, int rotate)
-{
-	int depth = fb_get_color_depth(&info->var, &info->fix);
-	int yres;
-
-	memset(&fb_logo, 0, sizeof(struct logo_data));
-
-	if (info->flags & FBINFO_MISC_TILEBLITTING ||
-	    info->flags & FBINFO_MODULE)
-		return 0;
-
-	if (info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
-		depth = info->var.blue.length;
-		if (info->var.red.length < depth)
-			depth = info->var.red.length;
-		if (info->var.green.length < depth)
-			depth = info->var.green.length;
-	}
-
-	if (info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR && depth > 4) {
-		/* assume console colormap */
-		depth = 4;
-	}
-
-	if (depth >= 8) {
-		switch (info->fix.visual) {
-		case FB_VISUAL_TRUECOLOR:
-			fb_logo.needs_truepalette = 1;
-			break;
-		case FB_VISUAL_DIRECTCOLOR:
-			fb_logo.needs_directpalette = 1;
-			fb_logo.needs_cmapreset = 1;
-			break;
-		case FB_VISUAL_PSEUDOCOLOR:
-			fb_logo.needs_cmapreset = 1;
-			break;
-		}
-	}
-
-	/* Return if no suitable logo was found */
-	fb_logo.logo = fb_find_logo(depth);
-
-	if (!fb_logo.logo) {
-		return 0;
-	}
-	
-	if (rotate == FB_ROTATE_UR || rotate == FB_ROTATE_UD)
-		yres = info->var.yres;
-	else
-		yres = info->var.xres;
-
-	if (fb_logo.logo->height > yres) {
-		fb_logo.logo = NULL;
-		return 0;
-	}
-
-	/* What depth we asked for might be different from what we get */
-	if (fb_logo.logo->type == LINUX_LOGO_CLUT224)
-		fb_logo.depth = 8;
-	else if (fb_logo.logo->type == LINUX_LOGO_VGA16)
-		fb_logo.depth = 4;
-	else
-		fb_logo.depth = 1;		
-	return fb_logo.logo->height;
-}
-
 static int fb_show_logo_line(struct fb_info *info, int rotate,
 			     const struct linux_logo *logo, int y,
 			     unsigned int n)
@@ -489,7 +423,7 @@ static int fb_show_logo_line(struct fb_i
 	if (fb_logo.needs_cmapreset)
 		fb_set_logocmap(info, logo);
 
-	if (fb_logo.needs_truepalette || 
+	if (fb_logo.needs_truepalette ||
 	    fb_logo.needs_directpalette) {
 		palette = kmalloc(256 * 4, GFP_KERNEL);
 		if (palette == NULL)
@@ -538,10 +472,150 @@ static int fb_show_logo_line(struct fb_i
 	return logo->height;
 }
 
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
+void fb_append_extra_logo(const struct linux_logo *logo, unsigned int n)
+{
+	if (!n || fb_logo_ex_num == FB_LOGO_EX_NUM_MAX)
+		return;
+
+	fb_logo_ex[fb_logo_ex_num].logo = logo;
+	fb_logo_ex[fb_logo_ex_num].n = n;
+	fb_logo_ex_num++;
+}
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
+
+int fb_prepare_logo(struct fb_info *info, int rotate)
+{
+	int depth = fb_get_color_depth(&info->var, &info->fix);
+	unsigned int yres;
+
+	memset(&fb_logo, 0, sizeof(struct logo_data));
+
+	if (info->flags & FBINFO_MISC_TILEBLITTING ||
+	    info->flags & FBINFO_MODULE)
+		return 0;
+
+	if (info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
+		depth = info->var.blue.length;
+		if (info->var.red.length < depth)
+			depth = info->var.red.length;
+		if (info->var.green.length < depth)
+			depth = info->var.green.length;
+	}
+
+	if (info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR && depth > 4) {
+		/* assume console colormap */
+		depth = 4;
+	}
+
+	if (depth >= 8) {
+		switch (info->fix.visual) {
+		case FB_VISUAL_TRUECOLOR:
+			fb_logo.needs_truepalette = 1;
+			break;
+		case FB_VISUAL_DIRECTCOLOR:
+			fb_logo.needs_directpalette = 1;
+			fb_logo.needs_cmapreset = 1;
+			break;
+		case FB_VISUAL_PSEUDOCOLOR:
+			fb_logo.needs_cmapreset = 1;
+			break;
+		}
+	}
+
+	/* Return if no suitable logo was found */
+	fb_logo.logo = fb_find_logo(depth);
+
+	if (!fb_logo.logo) {
+		return 0;
+	}
+
+	if (rotate == FB_ROTATE_UR || rotate == FB_ROTATE_UD)
+		yres = info->var.yres;
+	else
+		yres = info->var.xres;
+
+	if (fb_logo.logo->height > yres) {
+		fb_logo.logo = NULL;
+		return 0;
+	}
+
+	/* What depth we asked for might be different from what we get */
+	if (fb_logo.logo->type == LINUX_LOGO_CLUT224)
+		fb_logo.depth = 8;
+	else if (fb_logo.logo->type == LINUX_LOGO_VGA16)
+		fb_logo.depth = 4;
+	else
+		fb_logo.depth = 1;
+
+	return fb_prepare_extra_logos(info, fb_logo.logo->height, yres);
+}
+
 int fb_show_logo(struct fb_info *info, int rotate)
 {
-	return fb_show_logo_line(info, rotate, fb_logo.logo, 0,
-				 num_online_cpus());
+	int y;
+
+	y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
+			      num_online_cpus());
+	y = fb_show_extra_logos(info, y, rotate);
+
+	return y;
 }
 #else
 int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
diff -puN drivers/video/logo/Kconfig~fbdev-add-fb_append_extra_logo drivers/video/logo/Kconfig
--- a/drivers/video/logo/Kconfig~fbdev-add-fb_append_extra_logo
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
diff -puN include/linux/linux_logo.h~fbdev-add-fb_append_extra_logo include/linux/linux_logo.h
--- a/include/linux/linux_logo.h~fbdev-add-fb_append_extra_logo
+++ a/include/linux/linux_logo.h
@@ -33,5 +33,13 @@ struct linux_logo {
 };
 
 extern const struct linux_logo *fb_find_logo(int depth);
+#ifdef CONFIG_FB_LOGO_EXTRA
+extern void fb_append_extra_logo(const struct linux_logo *logo,
+				 unsigned int n);
+#else
+static inline void fb_append_extra_logo(const struct linux_logo *logo,
+					unsigned int n)
+{}
+#endif
 
 #endif /* _LINUX_LINUX_LOGO_H */
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
