From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-suspend-resume-support.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:39 -0700
Message-ID: <200804282158.m3SLwdaP018507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965126AbYD1V6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, adaplas@pol.net, avictor.za@gmail.com, hcegtvedt@atmel.com, hskinnemoen@atmel.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: suspend/resume support
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-suspend-resume-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: suspend/resume support
From: David Brownell <dbrownell@users.sourceforge.net>

Teach atmel_lcdfb driver how to suspend/resume.

Note that the backlight control should probably do more of the same stuff:
turning off display power (more than just the backlight) and stopping the
clocks (and dma to drive the no-longer-seen display).  No point in wasting
power to generate images that can't be observed, after all...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   36 ++++++++++++++++++++++++++++++++--
 include/video/atmel_lcdc.h  |    1 
 2 files changed, 35 insertions(+), 2 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-suspend-resume-support drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-suspend-resume-support
+++ a/drivers/video/atmel_lcdfb.c
@@ -909,10 +909,42 @@ static int __exit atmel_lcdfb_remove(str
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static int atmel_lcdfb_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+	struct atmel_lcdfb_info *sinfo = info->par;
+
+	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
+	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
+	if (sinfo->atmel_lcdfb_power_control)
+		sinfo->atmel_lcdfb_power_control(0);
+	atmel_lcdfb_stop_clock(sinfo);
+	return 0;
+}
+
+static int atmel_lcdfb_resume(struct platform_device *pdev)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+	struct atmel_lcdfb_info *sinfo = info->par;
+
+	atmel_lcdfb_start_clock(sinfo);
+	if (sinfo->atmel_lcdfb_power_control)
+		sinfo->atmel_lcdfb_power_control(1);
+	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);
+	return 0;
+}
+
+#else
+#define atmel_lcdfb_suspend	NULL
+#define atmel_lcdfb_resume	NULL
+#endif
+
 static struct platform_driver atmel_lcdfb_driver = {
 	.remove		= __exit_p(atmel_lcdfb_remove),
-
-// FIXME need suspend, resume
+	.suspend	= atmel_lcdfb_suspend,
+	.resume		= atmel_lcdfb_resume,
 
 	.driver		= {
 		.name	= "atmel_lcdfb",
diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-suspend-resume-support include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-suspend-resume-support
+++ a/include/video/atmel_lcdc.h
@@ -39,6 +39,7 @@ struct atmel_lcdfb_info {
 	u8			bl_power;
 #endif
 	bool			lcdcon_is_backlight;
+	u8			saved_lcdcon;
 
 	u8			default_bpp;
 	unsigned int		default_lcdcon2;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
git-acpi.patch
usb-gadget-switch-to-put_char-returning-int.patch
mmc-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch

