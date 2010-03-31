From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-hgafb.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:44:37 -0700
Message-ID: <201003312144.o2VLic3e010453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab0CaVpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, arnaud.patard@rtp-net.org, fero@drama.obuda.kando.hu


The patch titled
     fbdev: hgafb: fix section mismatches
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-hgafb.patch

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
Subject: fbdev: hgafb: fix section mismatches
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix section mismatches in the hgafb driver.

WARNING: drivers/video/hgafb.o(.devinit.text+0x18): Section mismatch in referenc
e from the function hgafb_probe() to the function .init.text:hga_card_detect()
The function __devinit hgafb_probe() references
a function __init hga_card_detect().
If hga_card_detect is only used by hgafb_probe then
annotate hga_card_detect with a matching annotation.

WARNING: drivers/video/hgafb.o(.devinit.text+0xfe): Section mismatch in referenc
e from the function hgafb_probe() to the variable .init.data:hga_fix
The function __devinit hgafb_probe() references
a variable __initdata hga_fix.
If hga_fix is only used by hgafb_probe then
annotate hga_fix with a matching annotation.

WARNING: drivers/video/hgafb.o(.devinit.text+0x105): Section mismatch in reference from the function hgafb_probe() to the variable .init.data:hga_default_var
The function __devinit hgafb_probe() references
a variable __initdata hga_default_var.
If hga_default_var is only used by hgafb_probe then
annotate hga_default_var with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hgafb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/hgafb.c~fbdev-section-cleanup-in-hgafb drivers/video/hgafb.c
--- a/drivers/video/hgafb.c~fbdev-section-cleanup-in-hgafb
+++ a/drivers/video/hgafb.c
@@ -106,7 +106,7 @@ static DEFINE_SPINLOCK(hga_reg_lock);
 
 /* Framebuffer driver structures */
 
-static struct fb_var_screeninfo __initdata hga_default_var = {
+static struct fb_var_screeninfo hga_default_var __devinitdata = {
 	.xres		= 720,
 	.yres 		= 348,
 	.xres_virtual 	= 720,
@@ -120,7 +120,7 @@ static struct fb_var_screeninfo __initda
 	.width 		= -1,
 };
 
-static struct fb_fix_screeninfo __initdata hga_fix = {
+static struct fb_fix_screeninfo hga_fix __devinitdata = {
 	.id 		= "HGA",
 	.type 		= FB_TYPE_PACKED_PIXELS,	/* (not sure) */
 	.visual 	= FB_VISUAL_MONO10,
@@ -276,7 +276,7 @@ static void hga_blank(int blank_mode)
 	spin_unlock_irqrestore(&hga_reg_lock, flags);
 }
 
-static int __init hga_card_detect(void)
+static int __devinit hga_card_detect(void)
 {
 	int count = 0;
 	void __iomem *p, *q;
@@ -596,7 +596,7 @@ static int __devinit hgafb_probe(struct 
 	return 0;
 }
 
-static int hgafb_remove(struct platform_device *pdev)
+static int __devexit hgafb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
@@ -621,7 +621,7 @@ static int hgafb_remove(struct platform_
 
 static struct platform_driver hgafb_driver = {
 	.probe = hgafb_probe,
-	.remove = hgafb_remove,
+	.remove = __devexit_p(hgafb_remove),
 	.driver = {
 		.name = "hgafb",
 	},
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-arcfb.patch
fbdev-section-cleanup-in-efifb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vesafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

