From: akpm@linux-foundation.org
Subject: + pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch added to -mm tree
Date: Thu, 06 Mar 2008 23:59:22 -0800
Message-ID: <200803070759.m277xMNp012036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760963AbYCGH7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 02:59:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk


The patch titled
     pxafb: make lubbock/mainstone/zylonite/littleton to use new LCD connection type
has been added to the -mm tree.  Its filename is
     pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -287,8 +287,7 @@ static struct pxafb_mode_info tpo_tdo24m
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
@@ -360,8 +360,8 @@ static struct pxafb_mach_info sharp_lm8v
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
@@ -354,8 +354,7 @@ static struct pxafb_mode_info toshiba_lt
 
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
@@ -94,8 +94,7 @@ static struct pxafb_mode_info toshiba_lt
 
 static struct pxafb_mach_info zylonite_toshiba_lcd_info = {
 	.num_modes      	= 1,
-	.lccr0			= LCCR0_Act,
-	.lccr3			= LCCR3_PCP,
+	.lcd_conn		= LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
 	.pxafb_backlight_power	= zylonite_backlight_power,
 };
 
@@ -131,8 +130,7 @@ static struct pxafb_mode_info sharp_ls03
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

git-arm.patch
pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
pxafb-fix-various-coding-style-issues-for-pxafb.patch
pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch

