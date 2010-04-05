From: akpm@linux-foundation.org
Subject: [to-be-updated] fbdev-section-cleanup-in-w100fb.patch removed from -mm tree
Date: Mon, 05 Apr 2010 12:25:24 -0700
Message-ID: <201004051925.o35JPOwV004292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab0DETZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, arnaud.patard@rtp-net.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbdev: w100fb: fix section mismatches
has been removed from the -mm tree.  Its filename was
     fbdev-section-cleanup-in-w100fb.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: w100fb: fix section mismatches
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix section mismatches in the w100fb driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/w100fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/w100fb.c~fbdev-section-cleanup-in-w100fb drivers/video/w100fb.c
--- a/drivers/video/w100fb.c~fbdev-section-cleanup-in-w100fb
+++ a/drivers/video/w100fb.c
@@ -53,7 +53,7 @@ static void w100_update_enable(void);
 static void w100_update_disable(void);
 static void calc_hsync(struct w100fb_par *par);
 static void w100_init_graphic_engine(struct w100fb_par *par);
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq);
+struct w100_pll_info *w100_get_xtal_table(unsigned int freq) __devinit;
 
 /* Pseudo palette size */
 #define MAX_PALETTES      16
@@ -782,7 +782,7 @@ out:
 }
 
 
-static int w100fb_remove(struct platform_device *pdev)
+static int __devexit w100fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 	struct w100fb_par *par=info->par;
@@ -1020,7 +1020,7 @@ static struct pll_entries {
 	{ 0 },
 };
 
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq)
+struct w100_pll_info __devinit *w100_get_xtal_table(unsigned int freq)
 {
 	struct pll_entries *pll_entry = w100_pll_tables;
 
@@ -1611,7 +1611,7 @@ static void w100_vsync(void)
 
 static struct platform_driver w100fb_driver = {
 	.probe		= w100fb_probe,
-	.remove		= w100fb_remove,
+	.remove		= __devexit_p(w100fb_remove),
 	.suspend	= w100fb_suspend,
 	.resume		= w100fb_resume,
 	.driver		= {
@@ -1619,7 +1619,7 @@ static struct platform_driver w100fb_dri
 	},
 };
 
-int __devinit w100fb_init(void)
+int __init w100fb_init(void)
 {
 	return platform_driver_register(&w100fb_driver);
 }
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-w100fb.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

