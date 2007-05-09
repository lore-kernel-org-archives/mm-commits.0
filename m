From: akpm@linux-foundation.org
Subject: - fbdev-clean-up-exit-patch-of-fb_set_var.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:29 -0700
Message-ID: <200705090302.l4932TdD010840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033249AbXEIDCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: clean up exit patch of fb_set_var
has been removed from the -mm tree.  Its filename was
     fbdev-clean-up-exit-patch-of-fb_set_var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: clean up exit patch of fb_set_var
From: "Antonino A. Daplas" <adaplas@gmail.com>

Clean up exit patch of fb_set_var():

- consolidate all return values into a single local variable
- ensure that return values are valid error codes
- fix fb_set_var() returning success when fb_check_caps() failed

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-clean-up-exit-patch-of-fb_set_var drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-clean-up-exit-patch-of-fb_set_var
+++ a/drivers/video/fbmem.c
@@ -799,11 +799,11 @@ static int fb_check_caps(struct fb_info 
 int
 fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 {
-	int err, flags = info->flags;
+	int flags = info->flags;
+	int ret = 0;
 
 	if (var->activate & FB_ACTIVATE_INV_MODE) {
 		struct fb_videomode mode1, mode2;
-		int ret = 0;
 
 		fb_var_to_videomode(&mode1, var);
 		fb_var_to_videomode(&mode2, &info->var);
@@ -821,7 +821,9 @@ fb_set_var(struct fb_info *info, struct 
 		if (!ret)
 		    fb_delete_videomode(&mode1, &info->modelist);
 
-		return ret;
+
+		ret = (ret) ? -EINVAL : 0;
+		goto done;
 	}
 
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
@@ -830,20 +832,21 @@ fb_set_var(struct fb_info *info, struct 
 
 		if (!info->fbops->fb_check_var) {
 			*var = info->var;
-			return 0;
+			goto done;
 		}
 
-		if ((err = info->fbops->fb_check_var(var, info)))
-			return err;
+		ret = info->fbops->fb_check_var(var, info);
+
+		if (ret)
+			goto done;
 
 		if ((var->activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW) {
 			struct fb_videomode mode;
-			int err = 0;
 
 			if (info->fbops->fb_get_caps) {
-				err = fb_check_caps(info, var, activate);
+				ret = fb_check_caps(info, var, activate);
 
-				if (err)
+				if (ret)
 					goto done;
 			}
 
@@ -853,16 +856,14 @@ fb_set_var(struct fb_info *info, struct 
 				info->fbops->fb_set_par(info);
 
 			fb_pan_display(info, &info->var);
-
 			fb_set_cmap(&info->cmap, info);
-
 			fb_var_to_videomode(&mode, &info->var);
 
 			if (info->modelist.prev && info->modelist.next &&
 			    !list_empty(&info->modelist))
-				err = fb_add_videomode(&mode, &info->modelist);
+				ret = fb_add_videomode(&mode, &info->modelist);
 
-			if (!err && (flags & FBINFO_MISC_USEREVENT)) {
+			if (!ret && (flags & FBINFO_MISC_USEREVENT)) {
 				struct fb_event event;
 				int evnt = (activate & FB_ACTIVATE_ALL) ?
 					FB_EVENT_MODE_CHANGE_ALL :
@@ -876,7 +877,7 @@ fb_set_var(struct fb_info *info, struct 
 	}
 
  done:
-	return 0;
+	return ret;
 }
 
 int
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
