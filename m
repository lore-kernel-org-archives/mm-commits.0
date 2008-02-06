From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-backlight-control-tiny-rework.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:31:35 -0800
Message-ID: <200802060731.m167VGF1031845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758949AbYBFHce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, adaplas@pol.net, dbrownell@users.sourceforge.net, linux@maxim.org.za, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: backlight control - tiny rework
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-backlight-control-tiny-rework.patch

This patch was dropped because it was folded into atmel_lcdfb-backlight-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: backlight control - tiny rework
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Tiny patch that removes not needed "inline" and renames function :
exit_contrast() -> exit_backlight().  It adds the missing exit_backlight() in
probe() error path.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-backlight-control-tiny-rework drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-backlight-control-tiny-rework
+++ a/drivers/video/atmel_lcdfb.c
@@ -118,7 +118,7 @@ static struct backlight_ops atmel_lcdc_b
 	.get_brightness = atmel_bl_get_brightness,
 };
 
-static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
+static void init_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	struct backlight_device	*bl;
 
@@ -142,7 +142,7 @@ static inline void init_backlight(struct
 	bl->props.brightness = atmel_bl_get_brightness(bl);
 }
 
-static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
+static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	if (sinfo->backlight)
 		backlight_device_unregister(sinfo->backlight);
@@ -150,18 +150,18 @@ static inline void exit_contrast(struct 
 
 #else
 
-static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
+static void init_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	dev_warn(&sinfo->pdev->dev, "backlight control is not available\n");
 }
 
-static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
+static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
 }
 
 #endif
 
-static inline void init_contrast(struct atmel_lcdfb_info *sinfo)
+static void init_contrast(struct atmel_lcdfb_info *sinfo)
 {
 	/* have some default contrast/backlight settings */
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, contrast_ctr);
@@ -843,6 +843,7 @@ free_cmap:
 unregister_irqs:
 	free_irq(sinfo->irq_base, info);
 unmap_mmio:
+	exit_backlight(sinfo);
 	iounmap(sinfo->mmio);
 release_mem:
  	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
@@ -877,7 +878,7 @@ static int __exit atmel_lcdfb_remove(str
 	if (!sinfo)
 		return 0;
 
-	exit_contrast(sinfo);
+	exit_backlight(sinfo);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);
 	unregister_framebuffer(info);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
atmel_lcdfb-backlight-control.patch
atmel_lcdfb-backlight-control-tiny-rework.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
