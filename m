From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-fix-__devinitexit-markings.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:59 -0700
Message-ID: <200906171839.n5HIdxAf005949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbZFQSp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: *bfin*: fix __dev{init,exit} markings
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-fix-__devinitexit-markings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: *bfin*: fix __dev{init,exit} markings
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the platform_driver bfin_t350mcqb_driver should use
__devexit_p() to refer to the remove function, and that function should
get __devexit markings.  Likewise, the probe function should be marked
with __devinit and not __init.

Also, module_init() functions should be marked with __init rather than
__devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c    |    8 ++++----
 drivers/video/bfin-t350mcqb-fb.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~fbdev-bfin-fix-__devinitexit-markings drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~fbdev-bfin-fix-__devinitexit-markings
+++ a/drivers/video/bf54x-lq043fb.c
@@ -529,7 +529,7 @@ static irqreturn_t bfin_bf54x_irq_error(
 	return IRQ_HANDLED;
 }
 
-static int __init bfin_bf54x_probe(struct platform_device *pdev)
+static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 {
 	struct bfin_bf54xfb_info *info;
 	struct fb_info *fbinfo;
@@ -709,7 +709,7 @@ out1:
 	return ret;
 }
 
-static int bfin_bf54x_remove(struct platform_device *pdev)
+static int __devexit bfin_bf54x_remove(struct platform_device *pdev)
 {
 
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
@@ -778,7 +778,7 @@ static int bfin_bf54x_resume(struct plat
 
 static struct platform_driver bfin_bf54x_driver = {
 	.probe = bfin_bf54x_probe,
-	.remove = bfin_bf54x_remove,
+	.remove = __devexit_p(bfin_bf54x_remove),
 	.suspend = bfin_bf54x_suspend,
 	.resume = bfin_bf54x_resume,
 	.driver = {
@@ -787,7 +787,7 @@ static struct platform_driver bfin_bf54x
 		   },
 };
 
-static int __devinit bfin_bf54x_driver_init(void)
+static int __init bfin_bf54x_driver_init(void)
 {
 	return platform_driver_register(&bfin_bf54x_driver);
 }
diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-fix-__devinitexit-markings drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-fix-__devinitexit-markings
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -599,7 +599,7 @@ out1:
 	return ret;
 }
 
-static int bfin_t350mcqb_remove(struct platform_device *pdev)
+static int __devexit bfin_t350mcqb_remove(struct platform_device *pdev)
 {
 
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
@@ -655,7 +655,7 @@ static int bfin_t350mcqb_resume(struct p
 
 static struct platform_driver bfin_t350mcqb_driver = {
 	.probe = bfin_t350mcqb_probe,
-	.remove = bfin_t350mcqb_remove,
+	.remove = __devexit_p(bfin_t350mcqb_remove),
 	.suspend = bfin_t350mcqb_suspend,
 	.resume = bfin_t350mcqb_resume,
 	.driver = {
@@ -664,7 +664,7 @@ static struct platform_driver bfin_t350m
 		   },
 };
 
-static int __devinit bfin_t350mcqb_driver_init(void)
+static int __init bfin_t350mcqb_driver_init(void)
 {
 	return platform_driver_register(&bfin_t350mcqb_driver);
 }
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

