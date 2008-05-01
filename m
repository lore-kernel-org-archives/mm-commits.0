From: akpm@linux-foundation.org
Subject: - pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:15 -0700
Message-ID: <200805010925.m419PFax030184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758203AbYEAJp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: make lubbock/mainstone/zylonite/littleton to use new LCD connection type
has been removed from the -mm tree.  Its filename was
     pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: make lubbock/mainstone/zylonite/littleton to use new LCD connection type
From: eric miao <eric.miao@marvell.com>

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/littleton.c |    3 +--
 arch/arm/mach-pxa/lubbock.c   |    4 ++--
 arch/arm/mach-pxa/mainstone.c |    3 +--
 arch/arm/mach-pxa/zylonite.c  |    6 ++----
 4 files changed, 6 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-pxa/littleton.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type arch/arm/mach-pxa/littleton.c
--- a/arch/arm/mach-pxa/littleton.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type
+++ a/arch/arm/mach-pxa/littleton.c
@@ -301,8 +301,7 @@ static struct pxafb_mode_info tpo_tdo24m
 static struct pxafb_mach_info littleton_lcd_info = {
 	.modes			= tpo_tdo24mtea1_modes,
 	.num_modes		= 2,
-	.lccr0			= LCCR0_Act,
-	.lccr3			= LCCR3_HSP | LCCR3_VSP,
+	.lcd_conn		= LCD_COLOR_TFT_16BPP,
 	.pxafb_lcd_power	= littleton_lcd_power,
 };
 
diff -puN arch/arm/mach-pxa/lubbock.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type arch/arm/mach-pxa/lubbock.c
--- a/arch/arm/mach-pxa/lubbock.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type
+++ a/arch/arm/mach-pxa/lubbock.c
@@ -395,8 +395,8 @@ static struct pxafb_mach_info sharp_lm8v
 	.num_modes	= 1,
 	.cmap_inverse	= 0,
 	.cmap_static	= 0,
-	.lccr0		= LCCR0_SDS,
-	.lccr3		= LCCR3_PCP | LCCR3_Acb(255),
+	.lcd_conn	= LCD_COLOR_DSTN_16BPP | LCD_PCLK_EDGE_FALL |
+			  LCD_AC_BIAS_FREQ(255);
 };
 
 #define	MMC_POLL_RATE		msecs_to_jiffies(1000)
diff -puN arch/arm/mach-pxa/mainstone.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type arch/arm/mach-pxa/mainstone.c
--- a/arch/arm/mach-pxa/mainstone.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type
+++ a/arch/arm/mach-pxa/mainstone.c
@@ -434,8 +434,7 @@ static struct pxafb_mode_info toshiba_lt
 
 static struct pxafb_mach_info mainstone_pxafb_info = {
 	.num_modes      	= 1,
-	.lccr0			= LCCR0_Act,
-	.lccr3			= LCCR3_PCP,
+	.lcd_conn		= LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
 };
 
 static int mainstone_mci_init(struct device *dev, irq_handler_t mstone_detect_int, void *data)
diff -puN arch/arm/mach-pxa/zylonite.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type arch/arm/mach-pxa/zylonite.c
--- a/arch/arm/mach-pxa/zylonite.c~pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type
+++ a/arch/arm/mach-pxa/zylonite.c
@@ -97,8 +97,7 @@ static struct pxafb_mode_info toshiba_lt
 
 static struct pxafb_mach_info zylonite_toshiba_lcd_info = {
 	.num_modes      	= 1,
-	.lccr0			= LCCR0_Act,
-	.lccr3			= LCCR3_PCP,
+	.lcd_conn		= LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
 	.pxafb_backlight_power	= zylonite_backlight_power,
 };
 
@@ -134,8 +133,7 @@ static struct pxafb_mode_info sharp_ls03
 static struct pxafb_mach_info zylonite_sharp_lcd_info = {
 	.modes			= sharp_ls037_modes,
 	.num_modes		= 2,
-	.lccr0			= LCCR0_Act,
-	.lccr3			= LCCR3_PCP | LCCR3_HSP | LCCR3_VSP,
+	.lcd_conn		= LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
 	.pxafb_backlight_power	= zylonite_backlight_power,
 };
 
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

