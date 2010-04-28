From: akpm@linux-foundation.org
Subject: + hitfb-correct-sections.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:58:36 -0700
Message-ID: <201004281858.o3SIwaPu013677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0D1S6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, lethal@linux-sh.org


The patch titled
     hitfb: fix sections
has been added to the -mm tree.  Its filename is
     hitfb-correct-sections.patch

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
Subject: hitfb: fix sections
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Since the drivers probe call was changed from .init.text to .devinit.text
in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b ("platform-drivers:
move probe to .devinit.text in drivers/video") the fb_fix_screeninfo and
fb_var_screeninfo structures must be changed from .init.data to
.devinit.data, too.

Also the drivers remove routine should be moved from .exit.text to
.devexit.text

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hitfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/hitfb.c~hitfb-correct-sections drivers/video/hitfb.c
--- a/drivers/video/hitfb.c~hitfb-correct-sections
+++ a/drivers/video/hitfb.c
@@ -30,14 +30,14 @@
 
 #define	WIDTH 640
 
-static struct fb_var_screeninfo hitfb_var __initdata = {
+static struct fb_var_screeninfo hitfb_var __devinitdata = {
 	.activate	= FB_ACTIVATE_NOW,
 	.height		= -1,
 	.width		= -1,
 	.vmode		= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo hitfb_fix __initdata = {
+static struct fb_fix_screeninfo hitfb_fix __devinitdata = {
 	.id		= "Hitachi HD64461",
 	.type		= FB_TYPE_PACKED_PIXELS,
 	.accel		= FB_ACCEL_NONE,
@@ -417,7 +417,7 @@ err_fb:
 	return ret;
 }
 
-static int __exit hitfb_remove(struct platform_device *dev)
+static int __devexit hitfb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -462,7 +462,7 @@ static const struct dev_pm_ops hitfb_dev
 
 static struct platform_driver hitfb_driver = {
 	.probe		= hitfb_probe,
-	.remove		= __exit_p(hitfb_remove),
+	.remove		= __devexit_p(hitfb_remove),
 	.driver		= {
 		.name	= "hitfb",
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-arcfb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch
hitfb-correct-sections.patch
s3c2410fb-correct-sections.patch
sgivwfb-correct-sections.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

