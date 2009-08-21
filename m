From: akpm@linux-foundation.org
Subject: + fb-do-not-ignore-fb_set_par-errors.patch added to -mm tree
Date: Fri, 21 Aug 2009 14:46:22 -0700
Message-ID: <200908212146.n7LLkMeI012895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932982AbZHUVqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, krzysztof.h1@poczta.fm


The patch titled
     fb: do not ignore fb_set_par errors
has been added to the -mm tree.  Its filename is
     fb-do-not-ignore-fb_set_par-errors.patch

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
Subject: fb: do not ignore fb_set_par errors
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

At the moment about half of the framebuffer drivers can return an error
code in fb_set_par. Until now it would be silently ignored by fbmem.c
and fbcon.c. This patch fixes fbmem.c to return the error code and
restore var on error.

But it is not clear in which video mode the device is when fb_set_par
fails.  It would be good and reasonable if it were in the old state but
there is no guarantee that this is true for all existing drivers. 
Additionally print a message if a failing fb_set_par is detected in
fbmem.c or fbcon.c.

Although most errors should be caught by the previous fb_check_var some
errors can't as they are dynamic (memory allocations, ...) and can only be
detected while performing the operations which is forbidden in
fb_check_var.

This patch shouldn't have a negative impact on normal operation as all
drivers return 0 on success.  The impact in case of error depends heavily
on the driver and caller but it's expected to be better than before.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   48 ++++++++++++++++++++++++--------
 drivers/video/fbmem.c         |   15 ++++++++--
 2 files changed, 50 insertions(+), 13 deletions(-)

diff -puN drivers/video/console/fbcon.c~fb-do-not-ignore-fb_set_par-errors drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fb-do-not-ignore-fb_set_par-errors
+++ a/drivers/video/console/fbcon.c
@@ -725,7 +725,7 @@ static int con2fb_release_oldinfo(struct
 				  int oldidx, int found)
 {
 	struct fbcon_ops *ops = oldinfo->fbcon_par;
-	int err = 0;
+	int err = 0, ret;
 
 	if (oldinfo->fbops->fb_release &&
 	    oldinfo->fbops->fb_release(oldinfo, 0)) {
@@ -752,8 +752,14 @@ static int con2fb_release_oldinfo(struct
 		  newinfo in an undefined state. Thus, a call to
 		  fb_set_par() may be needed for the newinfo.
 		*/
-		if (newinfo->fbops->fb_set_par)
-			newinfo->fbops->fb_set_par(newinfo);
+		if (newinfo->fbops->fb_set_par) {
+			ret = newinfo->fbops->fb_set_par(newinfo);
+
+			if (ret)
+				printk(KERN_ERR "con2fb_release_oldinfo: "
+					"detected unhandled fb_set_par error, "
+					"error code %d\n", ret);
+		}
 	}
 
 	return err;
@@ -763,11 +769,18 @@ static void con2fb_init_display(struct v
 				int unit, int show_logo)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
+	int ret;
 
 	ops->currcon = fg_console;
 
-	if (info->fbops->fb_set_par && !(ops->flags & FBCON_FLAGS_INIT))
-		info->fbops->fb_set_par(info);
+	if (info->fbops->fb_set_par && !(ops->flags & FBCON_FLAGS_INIT)) {
+		ret = info->fbops->fb_set_par(info);
+
+		if (ret)
+			printk(KERN_ERR "con2fb_init_display: detected "
+				"unhandled fb_set_par error, "
+				"error code %d\n", ret);
+	}
 
 	ops->flags |= FBCON_FLAGS_INIT;
 	ops->graphics = 0;
@@ -1006,7 +1019,7 @@ static void fbcon_init(struct vc_data *v
 	struct vc_data *svc = *default_mode;
 	struct display *t, *p = &fb_display[vc->vc_num];
 	int logo = 1, new_rows, new_cols, rows, cols, charcnt = 256;
-	int cap;
+	int cap, ret;
 
 	if (info_idx == -1 || info == NULL)
 	    return;
@@ -1092,8 +1105,15 @@ static void fbcon_init(struct vc_data *v
 	 */
 	if (CON_IS_VISIBLE(vc) && vc->vc_mode == KD_TEXT) {
 		if (info->fbops->fb_set_par &&
-		    !(ops->flags & FBCON_FLAGS_INIT))
-			info->fbops->fb_set_par(info);
+		    !(ops->flags & FBCON_FLAGS_INIT)) {
+			ret = info->fbops->fb_set_par(info);
+
+			if (ret)
+				printk(KERN_ERR "fbcon_init: detected "
+					"unhandled fb_set_par error, "
+					"error code %d\n", ret);
+		}
+
 		ops->flags |= FBCON_FLAGS_INIT;
 	}
 
@@ -2119,7 +2139,7 @@ static int fbcon_switch(struct vc_data *
 	struct fbcon_ops *ops;
 	struct display *p = &fb_display[vc->vc_num];
 	struct fb_var_screeninfo var;
-	int i, prev_console, charcnt = 256;
+	int i, ret, prev_console, charcnt = 256;
 
 	info = registered_fb[con2fb_map[vc->vc_num]];
 	ops = info->fbcon_par;
@@ -2174,8 +2194,14 @@ static int fbcon_switch(struct vc_data *
 
 	if (old_info != NULL && (old_info != info ||
 				 info->flags & FBINFO_MISC_ALWAYS_SETPAR)) {
-		if (info->fbops->fb_set_par)
-			info->fbops->fb_set_par(info);
+		if (info->fbops->fb_set_par) {
+			ret = info->fbops->fb_set_par(info);
+
+			if (ret)
+				printk(KERN_ERR "fbcon_switch: detected "
+					"unhandled fb_set_par error, "
+					"error code %d\n", ret);
+		}
 
 		if (old_info != info)
 			fbcon_del_cursor_timer(old_info);
diff -puN drivers/video/fbmem.c~fb-do-not-ignore-fb_set_par-errors drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-do-not-ignore-fb_set_par-errors
+++ a/drivers/video/fbmem.c
@@ -954,6 +954,7 @@ fb_set_var(struct fb_info *info, struct 
 			goto done;
 
 		if ((var->activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW) {
+			struct fb_var_screeninfo old_var;
 			struct fb_videomode mode;
 
 			if (info->fbops->fb_get_caps) {
@@ -963,10 +964,20 @@ fb_set_var(struct fb_info *info, struct 
 					goto done;
 			}
 
+			old_var = info->var;
 			info->var = *var;
 
-			if (info->fbops->fb_set_par)
-				info->fbops->fb_set_par(info);
+			if (info->fbops->fb_set_par) {
+				ret = info->fbops->fb_set_par(info);
+
+				if (ret) {
+					info->var = old_var;
+					printk(KERN_WARNING "detected "
+						"fb_set_par error, "
+						"error code: %d\n", ret);
+					goto done;
+				}
+			}
 
 			fb_pan_display(info, &info->var);
 			fb_set_cmap(&info->cmap, info);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

