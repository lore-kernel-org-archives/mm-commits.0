From: akpm@linux-foundation.org
Subject: + fbdev-fix-obvious-bug-in-show_pan.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:10:08 -0800
Message-ID: <200702272110.l1RLACTV028694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXB0VKO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:10:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: fix obvious bug in show_pan()
has been added to the -mm tree.  Its filename is
     fbdev-fix-obvious-bug-in-show_pan.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

patch-maintainers-update-email-address.patch
atyfb-fix-kconfig-error.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
