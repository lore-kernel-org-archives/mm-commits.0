From: akpm@linux-foundation.org
Subject: - atyfb-fix-kconfig-error.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:56:21 -0800
Message-ID: <200703052356.l25NuLi3005236@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbXCEX40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atyfb: Fix kconfig error
has been removed from the -mm tree.  Its filename was
     atyfb-fix-kconfig-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Fix kconfig error
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix the following compile error:

  MODPOST 327 modules
WARNING: "aty_st_lcd" [drivers/video/aty/atyfb.ko] undefined!
WARNING: "aty_ld_lcd" [drivers/video/aty/atyfb.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-kconfig-error drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-kconfig-error
+++ a/drivers/video/aty/atyfb_base.c
@@ -131,7 +131,8 @@
 #define PRINTKI(fmt, args...)	printk(KERN_INFO "atyfb: " fmt, ## args)
 #define PRINTKE(fmt, args...)	 printk(KERN_ERR "atyfb: " fmt, ## args)
 
-#if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || defined (CONFIG_FB_ATY_GENERIC_LCD)
+#if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || \
+defined (CONFIG_FB_ATY_GENERIC_LCD) || defined(CONFIG_FB_ATY_BACKLIGHT)
 static const u32 lt_lcd_regs[] = {
 	CONFIG_PANEL_LG,
 	LCD_GEN_CNTL_LG,
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch
atyfb-fix-kconfig-error-part-2.patch
fbdev-fix-kconfig-error-if-fb_ddc=n.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
