From: akpm@linux-foundation.org
Subject: - fbcon-delay-screen-update-when-setting-the-mode-of.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:52 -0700
Message-ID: <200705090300.l4930qgr010619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032902AbXEIDA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: delay screen update when setting the mode of all consoles
has been removed from the -mm tree.  Its filename was
     fbcon-delay-screen-update-when-setting-the-mode-of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: delay screen update when setting the mode of all consoles
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the current framebuffer console is rotated (rotate != 0), doing an
"fbset -a" will corrupt the current console.  Fix by updating the current
console only after all non-visible consoles have been updated.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-delay-screen-update-when-setting-the-mode-of drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-delay-screen-update-when-setting-the-mode-of
+++ a/drivers/video/console/fbcon.c
@@ -2849,7 +2849,7 @@ static void fbcon_set_all_vcs(struct fb_
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct vc_data *vc;
 	struct display *p;
-	int i, rows, cols;
+	int i, rows, cols, fg = -1;
 
 	if (!ops || ops->currcon < 0)
 		return;
@@ -2860,34 +2860,23 @@ static void fbcon_set_all_vcs(struct fb_
 		    registered_fb[con2fb_map[i]] != info)
 			continue;
 
+		if (CON_IS_VISIBLE(vc)) {
+			fg = i;
+			continue;
+		}
+
 		p = &fb_display[vc->vc_num];
 		set_blitting_type(vc, info);
 		var_to_display(p, &info->var, info);
-		cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
-		rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
+		cols = FBCON_SWAP(p->rotate, info->var.xres, info->var.yres);
+		rows = FBCON_SWAP(p->rotate, info->var.yres, info->var.xres);
 		cols /= vc->vc_font.width;
 		rows /= vc->vc_font.height;
 		vc_resize(vc, cols, rows);
-
-		if (CON_IS_VISIBLE(vc)) {
-			updatescrollmode(p, info, vc);
-			scrollback_max = 0;
-			scrollback_current = 0;
-
-			if (!fbcon_is_inactive(vc, info)) {
-			    ops->var.xoffset = ops->var.yoffset =
-				p->yscroll = 0;
-			    ops->update_start(info);
-			}
-
-			fbcon_set_palette(vc, color_table);
-			update_screen(vc);
-			if (softback_buf)
-				fbcon_update_softback(vc);
-		}
 	}
 
-	ops->p = &fb_display[ops->currcon];
+	if (fg != -1)
+		fbcon_modechanged(info);
 }
 
 static int fbcon_mode_deleted(struct fb_info *info,
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
