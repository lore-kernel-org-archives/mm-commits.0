From: akpm@linux-foundation.org
Subject: + video-ep93xx-fbc-fix-section-mismatch-and-use-module_platform_driver.patch added to -mm tree
Date: Wed, 20 Mar 2013 14:42:44 -0700
Message-ID: <20130320214244.7517B5A409A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:57286 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3CTVmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 17:42:46 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so202144ves.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 14:42:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, FlorianSchandinat@gmx.de, hsweeten@visionengravers.com, rmallon@gmail.com


The patch titled
     Subject: drivers/video/ep93xx-fb.c: fix section mismatch and use module_platform_driver
has been added to the -mm tree.  Its filename is
     video-ep93xx-fbc-fix-section-mismatch-and-use-module_platform_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: drivers/video/ep93xx-fb.c: fix section mismatch and use module_platform_driver

Remove the __init tags from the ep93xxfb_calc_fbsize() and
ep93xxfb_alloc_videomem() functions to fix the section mismatch warnings.

Use module_platform_driver() to remove the init/exit boilerplate.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ep93xx-fb.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/video/ep93xx-fb.c~video-ep93xx-fbc-fix-section-mismatch-and-use-module_platform_driver drivers/video/ep93xx-fb.c
--- a/drivers/video/ep93xx-fb.c~video-ep93xx-fbc-fix-section-mismatch-and-use-module_platform_driver
+++ a/drivers/video/ep93xx-fb.c
@@ -419,7 +419,7 @@ static struct fb_ops ep93xxfb_ops = {
 	.fb_mmap	= ep93xxfb_mmap,
 };
 
-static int __init ep93xxfb_calc_fbsize(struct ep93xxfb_mach_info *mach_info)
+static int ep93xxfb_calc_fbsize(struct ep93xxfb_mach_info *mach_info)
 {
 	int i, fb_size = 0;
 
@@ -441,7 +441,7 @@ static int __init ep93xxfb_calc_fbsize(s
 	return fb_size;
 }
 
-static int __init ep93xxfb_alloc_videomem(struct fb_info *info)
+static int ep93xxfb_alloc_videomem(struct fb_info *info)
 {
 	struct ep93xx_fbi *fbi = info->par;
 	char __iomem *virt_addr;
@@ -627,19 +627,7 @@ static struct platform_driver ep93xxfb_d
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int ep93xxfb_init(void)
-{
-	return platform_driver_register(&ep93xxfb_driver);
-}
-
-static void __exit ep93xxfb_exit(void)
-{
-	platform_driver_unregister(&ep93xxfb_driver);
-}
