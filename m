From: akpm@linux-foundation.org
Subject: + fbdev-xoffset-yoffset-and-yres-are-unsigned.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:45:13 -0700
Message-ID: <200806042345.m54NjDgr015308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbYFDXpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     fbdev: xoffset, yoffset and yres are unsigned
has been added to the -mm tree.  Its filename is
     fbdev-xoffset-yoffset-and-yres-are-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: xoffset, yoffset and yres are unsigned
From: Ville Syrjala <syrjala@sci.fi>

The xoffset, yoffset and yres members of fb_var_screeninfo are __u32. 
Make them unsigned in the code as well.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-xoffset-yoffset-and-yres-are-unsigned drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-xoffset-yoffset-and-yres-are-unsigned
+++ a/drivers/video/fbmem.c
@@ -848,9 +848,8 @@ int
 fb_pan_display(struct fb_info *info, struct fb_var_screeninfo *var)
 {
 	struct fb_fix_screeninfo *fix = &info->fix;
-        int xoffset = var->xoffset;
-        int yoffset = var->yoffset;
-        int err = 0, yres = info->var.yres;
+	unsigned int yres = info->var.yres;
+	int err = 0;
 
 	if (var->yoffset > 0) {
 		if (var->vmode & FB_VMODE_YWRAP) {
@@ -866,8 +865,8 @@ fb_pan_display(struct fb_info *info, str
 				 (var->xoffset % fix->xpanstep)))
 		err = -EINVAL;
 
-        if (err || !info->fbops->fb_pan_display || xoffset < 0 ||
-	    yoffset < 0 || var->yoffset + yres > info->var.yres_virtual ||
+	if (err || !info->fbops->fb_pan_display ||
+	    var->yoffset + yres > info->var.yres_virtual ||
 	    var->xoffset + info->var.xres > info->var.xres_virtual)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from syrjala@sci.fi are

fbdev-width-and-height-are-unsigned.patch
fbdev-xoffset-yoffset-and-yres-are-unsigned.patch
atyfb-remove-dead-code.patch
atyfb-correct_chipset-can-fail.patch
atyfb-use-a-pci-device-id-table.patch
atyfb-report-probe-errors.patch
atyfb-fix-a-cast.patch

