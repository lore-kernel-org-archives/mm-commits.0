From: akpm@linux-foundation.org
Subject: + davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:00:33 -0800
Message-ID: <200912012200.nB1M0YOU012801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbZLAWAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, khilman@deeprootsystems.com, krzysztof.h1@poczta.fm


The patch titled
     davinci: fb : add suspend/resume suuport for DA8xx/OMAP-L1xx fb driver
has been added to the -mm tree.  Its filename is
     davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver.patch

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
Subject: davinci: fb : add suspend/resume suuport for DA8xx/OMAP-L1xx fb driver
From: Chaithrika U S <chaithrika@ti.com>

Suspend/resume support DA8xx/OMAP-L1xx frame buffer driver.  This feature
has been tested on DA850/OMAP-L138 EVM.  For the purpose of testing, the
patch series[1] which adds suspend support for DA850/OMAP-L138 SoC was
applied.

[1] http://patchwork.kernel.org/patch/60260/

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver
+++ a/drivers/video/da8xx-fb.c
@@ -29,6 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
+#include <linux/console.h>
 #include <video/da8xx-fb.h>
 
 #define DRIVER_NAME "da8xx_lcdc"
@@ -930,11 +931,35 @@ err_request_mem:
 #ifdef CONFIG_PM
 static int fb_suspend(struct platform_device *dev, pm_message_t state)
 {
-	 return -EBUSY;
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct da8xx_fb_par *par = info->par;
+
+	acquire_console_sem();
+	if (par->panel_power_ctrl)
+		par->panel_power_ctrl(0);
+
+	fb_set_suspend(info, 1);
+	lcd_disable_raster();
+	clk_disable(par->lcdc_clk);
+	release_console_sem();
+
+	return 0;
 }
 static int fb_resume(struct platform_device *dev)
 {
-	 return -EBUSY;
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct da8xx_fb_par *par = info->par;
+
+	acquire_console_sem();
+	if (par->panel_power_ctrl)
+		par->panel_power_ctrl(1);
+
+	clk_enable(par->lcdc_clk);
+	lcd_enable_raster();
+	fb_set_suspend(info, 0);
+	release_console_sem();
+
+	return 0;
 }
 #else
 #define fb_suspend NULL
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

