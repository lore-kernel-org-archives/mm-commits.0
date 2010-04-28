From: akpm@linux-foundation.org
Subject: + s3c2410fb-correct-sections.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:58:38 -0700
Message-ID: <201004281858.o3SIwcmu013680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0D1S6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, support@simtec.co.uk


The patch titled
     s3c2410fb: fix sections
has been added to the -mm tree.  Its filename is
     s3c2410fb-correct-sections.patch

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
Subject: s3c2410fb: fix sections
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Since the drivers probe calls were changed from .init.text to
.devinit.text in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b
("platform-drivers: move probe to .devinit.text in drivers/video") all the
function from .init.text should be moved to .devinit.text, too.

The drivers remove calls can also be move from .text to .devexit.text.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Vincent Sanders <support@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-correct-sections drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-correct-sections
+++ a/drivers/video/s3c2410fb.c
@@ -631,7 +631,7 @@ static struct fb_ops s3c2410fb_ops = {
  *	cache.  Once this area is remapped, all virtual memory
  *	access to the video memory should occur at the new region.
  */
-static int __init s3c2410fb_map_video_memory(struct fb_info *info)
+static int __devinit s3c2410fb_map_video_memory(struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
 	dma_addr_t map_dma;
@@ -814,7 +814,7 @@ static inline void s3c2410fb_cpufreq_der
 
 static char driver_name[] = "s3c2410fb";
 
-static int __init s3c24xxfb_probe(struct platform_device *pdev,
+static int __devinit s3c24xxfb_probe(struct platform_device *pdev,
 				  enum s3c_drv_type drv_type)
 {
 	struct s3c2410fb_info *info;
@@ -1018,7 +1018,7 @@ static int __devinit s3c2412fb_probe(str
 /*
  *  Cleanup
  */
-static int s3c2410fb_remove(struct platform_device *pdev)
+static int __devexit s3c2410fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
 	struct s3c2410fb_info *info = fbinfo->par;
@@ -1096,7 +1096,7 @@ static int s3c2410fb_resume(struct platf
 
 static struct platform_driver s3c2410fb_driver = {
 	.probe		= s3c2410fb_probe,
-	.remove		= s3c2410fb_remove,
+	.remove		= __devexit_p(s3c2410fb_remove),
 	.suspend	= s3c2410fb_suspend,
 	.resume		= s3c2410fb_resume,
 	.driver		= {
@@ -1107,7 +1107,7 @@ static struct platform_driver s3c2410fb_
 
 static struct platform_driver s3c2412fb_driver = {
 	.probe		= s3c2412fb_probe,
-	.remove		= s3c2410fb_remove,
+	.remove		= __devexit_p(s3c2410fb_remove),
 	.suspend	= s3c2410fb_suspend,
 	.resume		= s3c2410fb_resume,
 	.driver		= {
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

