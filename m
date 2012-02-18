From: akpm@linux-foundation.org
Subject: + drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3.patch added to -mm tree
Date: Fri, 17 Feb 2012 16:02:52 -0800
Message-ID: <20120218000252.96408A01FC@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:60952 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BRACy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 19:02:54 -0500
Received: by vbbfp1 with SMTP id fp1so516380vbb.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 16:02:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com


The patch titled
     Subject: drivers/leds/leds-pca9633.c: fix kcalloc parameters swapped
has been added to the -mm tree.  Its filename is
     drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/leds/leds-pca9633.c: fix kcalloc parameters swapped

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices-fix.patch
backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch
backlight-lp855x_blc-small-cleanups.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix-3.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

