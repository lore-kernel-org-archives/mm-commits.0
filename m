From: akpm@linux-foundation.org
Subject: [folded] backlight-new-backlight-driver-for-lp855x-devices-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:21:31 -0700
Message-ID: <20120323212131.F2B93A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58428 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2CWVVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:21:33 -0400
Received: by yenq2 with SMTP id q2so564978yen.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:21:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byte error path
has been removed from the -mm tree.  Its filename was
     backlight-new-backlight-driver-for-lp855x-devices-fix.patch

This patch was dropped because it was folded into backlight-new-backlight-driver-for-lp855x-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byte error path

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-new-backlight-driver-for-lp855x-devices-fix drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-new-backlight-driver-for-lp855x-devices-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -41,6 +41,7 @@ static int lp855x_read_byte(struct lp855
 	mutex_lock(&lp->xfer_lock);
 	ret = i2c_smbus_read_byte_data(lp->client, reg);
 	if (ret < 0) {
+		mutex_unlock(&lp->xfer_lock);
 		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
 		return ret;
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch
backlight-lp855x_blc-small-cleanups.patch
lp855x-bl-remove-unnecessary-platform-data.patch
lp855x-bl-remove-unnecessary-headers.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

