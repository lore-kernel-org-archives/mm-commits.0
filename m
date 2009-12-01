From: akpm@linux-foundation.org
Subject: + da850-omap-l138-add-callback-to-control-lcd-panel-power.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:00:30 -0800
Message-ID: <200912012200.nB1M0U3l012625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbZLAWAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:00:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, khilman@deeprootsystems.com, krzysztof.h1@poczta.fm


The patch titled
     da850/omap-l138: add callback to control LCD panel power
has been added to the -mm tree.  Its filename is
     da850-omap-l138-add-callback-to-control-lcd-panel-power.patch

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
Subject: da850/omap-l138: add callback to control LCD panel power
From: Chaithrika U S <chaithrika@ti.com>

Add the platform specific callback to control LCD panel and backlight
power.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/board-da850-evm.c |   24 ++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-davinci/board-da850-evm.c~da850-omap-l138-add-callback-to-control-lcd-panel-power arch/arm/mach-davinci/board-da850-evm.c
--- a/arch/arm/mach-davinci/board-da850-evm.c~da850-omap-l138-add-callback-to-control-lcd-panel-power
+++ a/arch/arm/mach-davinci/board-da850-evm.c
@@ -339,6 +339,15 @@ static struct davinci_mmc_config da850_m
 	.version	= MMC_CTLR_VERSION_2,
 };
 
+static void da850_panel_power_ctrl(int val)
+{
+	/* lcd backlight */
+	gpio_set_value(DA850_LCD_BL_PIN, val);
+
+	/* lcd power */
+	gpio_set_value(DA850_LCD_PWR_PIN, val);
+}
+
 static int da850_lcd_hw_init(void)
 {
 	int status;
@@ -356,17 +365,11 @@ static int da850_lcd_hw_init(void)
 	gpio_direction_output(DA850_LCD_BL_PIN, 0);
 	gpio_direction_output(DA850_LCD_PWR_PIN, 0);
 
-	/* disable lcd backlight */
-	gpio_set_value(DA850_LCD_BL_PIN, 0);
-
-	/* disable lcd power */
-	gpio_set_value(DA850_LCD_PWR_PIN, 0);
-
-	/* enable lcd power */
-	gpio_set_value(DA850_LCD_PWR_PIN, 1);
+	/* Switch off panel power and backlight */
+	da850_panel_power_ctrl(0);
 
-	/* enable lcd backlight */
-	gpio_set_value(DA850_LCD_BL_PIN, 1);
+	/* Switch on panel power and backlight */
+	da850_panel_power_ctrl(1);
 
 	return 0;
 }
@@ -674,6 +677,7 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: lcd initialization failed: %d\n",
 				ret);
 
+	sharp_lk043t1dg01_pdata.panel_power_ctrl = da850_panel_power_ctrl,
 	ret = da8xx_register_lcdc(&sharp_lk043t1dg01_pdata);
 	if (ret)
 		pr_warning("da850_evm_init: lcdc registration failed: %d\n",
_

Patches currently in -mm which might be from chaithrika@ti.com are

origin.patch
linux-next.patch
davinci-mmc-add-cpufreq-support.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch
davinci-fb-add-cpufreq-support.patch
davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features.patch
da850-omap-l138-add-callback-to-control-lcd-panel-power.patch
davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver.patch
davinci-fb-add-framebuffer-blank-operation.patch

