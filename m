From: akpm@linux-foundation.org
Subject: [merged] leds-lm3530-fix-setting-pltfm-als_vmax.patch removed from -mm tree
Date: Thu, 09 Feb 2012 12:21:13 -0800
Message-ID: <20120209202113.73B8AA016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39178 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2BIUVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 15:21:15 -0500
Received: by eaaf13 with SMTP id f13so61805eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 12:21:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lm3530.c: fix setting pltfm->als_vmax
has been removed from the -mm tree.  Its filename was
     leds-lm3530-fix-setting-pltfm-als_vmax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lm3530.c: fix setting pltfm->als_vmax

In current code, pltfm->als_vmin is set to LM3530_ALS_WINDOW_mV and
pltfm->als_vmax is 0.  This does not make sense.  I think what we want
here is setting pltfm->als_vmax to LM3530_ALS_WINDOW_mV.

Both als_vmin and als_vmax local variables will be set to pltfm->als_vmin
and pltfm->als_vmax by a few lines latter.  Thus also remove a redundant
assignment for als_vmin and als_vmax in this patch.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-fix-setting-pltfm-als_vmax drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-fix-setting-pltfm-als_vmax
+++ a/drivers/leds/leds-lm3530.c
@@ -164,8 +164,8 @@ static int lm3530_init_registers(struct 
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		if (pltfm->als_vmax == 0) {
-			pltfm->als_vmin = als_vmin = 0;
-			pltfm->als_vmin = als_vmax = LM3530_ALS_WINDOW_mV;
+			pltfm->als_vmin = 0;
+			pltfm->als_vmax = LM3530_ALS_WINDOW_mV;
 		}
 
 		als_vmin = pltfm->als_vmin;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices-fix.patch
backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch
backlight-lp855x_blc-small-cleanups.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

