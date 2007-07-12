From: akpm@linux-foundation.org
Subject: + fbdev-add-fb_append_extra_logo.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:06:30 -0700
Message-ID: <200707122306.l6CN6U0Q009888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbXGLXHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org


The patch titled
     fbdev: Add fb_append_extra_logo()
has been added to the -mm tree.  Its filename is
     fbdev-add-fb_append_extra_logo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/video/fbmem.c      |   50 ++++++++++++++++++++++++++++++++---
 include/linux/linux_logo.h |    8 +++++
 2 files changed, 54 insertions(+), 4 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-add-fb_append_extra_logo drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-fb_append_extra_logo
+++ a/drivers/video/fbmem.c
@@ -311,6 +311,13 @@ static struct logo_data {
 	const struct linux_logo *logo;
 } fb_logo __read_mostly;
 
+#define FB_LOGO_EX_NUM_MAX 10
+static struct logo_data_extra {
+	const struct linux_logo *logo;
+	unsigned int n;
+} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
+static unsigned int fb_logo_ex_num;
+
 static void fb_rotate_logo_ud(const u8 *in, u8 *out, u32 width, u32 height)
 {
 	u32 size = width * height, i;
@@ -404,10 +411,22 @@ static void fb_do_show_logo(struct fb_in
 	}
 }
 
+#ifdef CONFIG_FB
+void fb_append_extra_logo(const struct linux_logo *logo, unsigned int n)
+{
+	if (!n || fb_logo_ex_num == FB_LOGO_EX_NUM_MAX)
+		return;
+
+	fb_logo_ex[fb_logo_ex_num].logo = logo;
+	fb_logo_ex[fb_logo_ex_num].n = n;
+	fb_logo_ex_num++;
+}
+#endif
+
 int fb_prepare_logo(struct fb_info *info, int rotate)
 {
 	int depth = fb_get_color_depth(&info->var, &info->fix);
-	int yres;
+	unsigned int yres, height, i;
 
 	memset(&fb_logo, 0, sizeof(struct logo_data));
 
@@ -467,7 +486,21 @@ int fb_prepare_logo(struct fb_info *info
 		fb_logo.depth = 4;
 	else
 		fb_logo.depth = 1;		
-	return fb_logo.logo->height;
+
+	/* FIXME: logo_ex supports only truecolor fb. */
+	if (info->fix.visual != FB_VISUAL_TRUECOLOR)
+		fb_logo_ex_num = 0;
+
+	height = fb_logo.logo->height;
+	for (i = 0; i < fb_logo_ex_num; i++) {
+		height += fb_logo_ex[i].logo->height;
+		if (height > yres) {
+			height -= fb_logo_ex[i].logo->height;
+			fb_logo_ex_num = i;
+			break;
+		}
+	}
+	return height;
 }
 
 static int fb_show_logo_line(struct fb_info *info, int rotate,
@@ -540,8 +573,17 @@ static int fb_show_logo_line(struct fb_i
 
 int fb_show_logo(struct fb_info *info, int rotate)
 {
-	return fb_show_logo_line(info, rotate, fb_logo.logo, 0,
-				 num_online_cpus());
+	int y, i;
+
+	y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
+			      num_online_cpus());
+
+	for (i = 0; i < fb_logo_ex_num; i++) {
+		y += fb_show_logo_line(info, rotate,
+				       fb_logo_ex[i].logo, y, fb_logo_ex[i].n);
+	}
+
+	return y;
 }
 #else
 int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
diff -puN include/linux/linux_logo.h~fbdev-add-fb_append_extra_logo include/linux/linux_logo.h
--- a/include/linux/linux_logo.h~fbdev-add-fb_append_extra_logo
+++ a/include/linux/linux_logo.h
@@ -33,5 +33,13 @@ struct linux_logo {
 };
 
 extern const struct linux_logo *fb_find_logo(int depth);
+#if defined(CONFIG_LOGO) && defined(CONFIG_FB)
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
git-powerpc.patch
git-block.patch
compat32-ignore-the-loop_clr_fd-ioctl.patch
fbdev-extract-fb_show_logo_line.patch
fbdev-add-fb_append_extra_logo.patch
fbdev-spe-helper-penguin-logo.patch
cell-draw-spe-helper-penguin-logos.patch
