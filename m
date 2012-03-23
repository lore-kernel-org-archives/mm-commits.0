From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:26:16 -0700
Message-ID: <20120323212616.A52ADA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:57570 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208Ab2CWV0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2012 17:26:19 -0400
Received: by laai8 with SMTP id i8so187938laa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:26:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-pca9633.c: fix kcalloc parameters swapped
has been removed from the -mm tree.  Its filename was
     drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3.patch

This patch was dropped because it was folded into drivers-leds-add-driver-for-pca9663-i2c-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-pca9633.c: fix kcalloc parameters swapped

The first parameter should be "number of elements" and the second
parameter should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9633.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca9633.c~drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3 drivers/leds/leds-pca9633.c
--- a/drivers/leds/leds-pca9633.c~drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3
+++ a/drivers/leds/leds-pca9633.c
@@ -110,7 +110,7 @@ static int __devinit pca9633_probe(struc
 		}
 	}
 
-	pca9633 = kcalloc(sizeof(*pca9633), 4, GFP_KERNEL);
+	pca9633 = kcalloc(4, sizeof(*pca9633), GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
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
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

