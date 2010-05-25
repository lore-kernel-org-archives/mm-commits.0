From: akpm@linux-foundation.org
Subject: + fbdev-bf54x-lq043fb-fix-unused-warnings-with-backlight-code.patch added to -mm tree
Date: Tue, 25 May 2010 16:12:49 -0700
Message-ID: <201005252312.o4PNCnxV020842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903Ab0EYXMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     fbdev: bf54x-lq043fb: fix unused warnings with backlight code
has been added to the -mm tree.  Its filename is
     fbdev-bf54x-lq043fb-fix-unused-warnings-with-backlight-code.patch

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
Subject: fbdev: bf54x-lq043fb: fix unused warnings with backlight code
From: Mike Frysinger <vapier@gentoo.org>

The current backlight code is stubbed out, so the new props changes added
some warnings:
drivers/video/bf54x-lq043fb.c: In function 'bfin_bf54x_probe':
drivers/video/bf54x-lq043fb.c:666: warning: label 'out9' defined but not used
drivers/video/bf54x-lq043fb.c:504: warning: unused variable 'props'

Fix em !

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~fbdev-bf54x-lq043fb-fix-unused-warnings-with-backlight-code drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~fbdev-bf54x-lq043fb-fix-unused-warnings-with-backlight-code
+++ a/drivers/video/bf54x-lq043fb.c
@@ -501,7 +501,9 @@ static irqreturn_t bfin_bf54x_irq_error(
 
 static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 {
+#ifndef NO_BL_SUPPORT
 	struct backlight_properties props;
+#endif
 	struct bfin_bf54xfb_info *info;
 	struct fb_info *fbinfo;
 	int ret;
@@ -654,7 +656,8 @@ static int __devinit bfin_bf54x_probe(st
 		printk(KERN_ERR DRIVER_NAME
 			": unable to register backlight.\n");
 		ret = -EINVAL;
-		goto out9;
+		unregister_framebuffer(fbinfo);
+		goto out8;
 	}
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
@@ -663,8 +666,6 @@ static int __devinit bfin_bf54x_probe(st
 
 	return 0;
 
-out9:
-	unregister_framebuffer(fbinfo);
 out8:
 	free_irq(info->irq, info);
 out7:
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
nommu-allow-private-mappings-of-read-only-devices.patch
linux-next.patch
fbdev-bfin-t350mcqb-fb-avoid-unused-warnings-in-backlight-code.patch
fbdev-bf54x-lq043fb-fix-unused-warnings-with-backlight-code.patch
ptrace-unify-fdpic-implementations.patch
blackfin-use-use-asm-generic-scatterlisth.patch

