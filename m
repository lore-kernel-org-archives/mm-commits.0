From: akpm@linux-foundation.org
Subject: - fbdev-save-the-activate-field-before-calling-fb_check_var.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:50 -0700
Message-ID: <200705090301.l4931oFY010760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033046AbXEIDBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: save the activate field before calling fb_check_var()
has been removed from the -mm tree.  Its filename was
     fbdev-save-the-activate-field-before-calling-fb_check_var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: save the activate field before calling fb_check_var()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Some drivers may reset the var->activate field on fb_check_var(). This can
lead to undefined behavior. For example, doing fbset -a <option> with vga16fb
will only modify the active console instead of modifying all.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fbdev-save-the-activate-field-before-calling-fb_check_var drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-save-the-activate-field-before-calling-fb_check_var
+++ a/drivers/video/fbmem.c
@@ -803,6 +803,8 @@ fb_set_var(struct fb_info *info, struct 
 
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
 	    memcmp(&info->var, var, sizeof(struct fb_var_screeninfo))) {
+		u32 activate = var->activate;
+
 		if (!info->fbops->fb_check_var) {
 			*var = info->var;
 			return 0;
@@ -831,7 +833,7 @@ fb_set_var(struct fb_info *info, struct 
 
 			if (!err && (flags & FBINFO_MISC_USEREVENT)) {
 				struct fb_event event;
-				int evnt = (var->activate & FB_ACTIVATE_ALL) ?
+				int evnt = (activate & FB_ACTIVATE_ALL) ?
 					FB_EVENT_MODE_CHANGE_ALL :
 					FB_EVENT_MODE_CHANGE;
 
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
