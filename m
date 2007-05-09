From: akpm@linux-foundation.org
Subject: - fbdev-fix-obvious-bug-in-show_pan.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:24 -0700
Message-ID: <200705090259.l492xO90010397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970204AbXEIC70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix obvious bug in show_pan()
has been removed from the -mm tree.  Its filename was
     fbdev-fix-obvious-bug-in-show_pan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: fix obvious bug in show_pan()
From: "Antonino A. Daplas" <adaplas@gmail.com>

show_pan will display the value of the xoffset twice, instead of the xoffset
and yoffset.  Fix.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbsysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbsysfs.c~fbdev-fix-obvious-bug-in-show_pan drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~fbdev-fix-obvious-bug-in-show_pan
+++ a/drivers/video/fbsysfs.c
@@ -376,7 +376,7 @@ static ssize_t show_pan(struct device *d
 {
 	struct fb_info *fb_info = dev_get_drvdata(device);
 	return snprintf(buf, PAGE_SIZE, "%d,%d\n", fb_info->var.xoffset,
-			fb_info->var.xoffset);
+			fb_info->var.yoffset);
 }
 
 static ssize_t show_name(struct device *device,
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
