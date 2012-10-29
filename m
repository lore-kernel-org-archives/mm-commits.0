From: akpm@linux-foundation.org
Subject: [merged] backlight-ili9320-add-missing-spi-dependency.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:54 -0700
Message-ID: <20121029194955.20BD45C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:51708 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2Tt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:57 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so344046lah.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ili9320: add missing SPI dependency
has been removed from the -mm tree.  Its filename was
     backlight-ili9320-add-missing-spi-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili9320: add missing SPI dependency

Add this missing SPI dependency and prevent the driver from building
without SPI, because functions of the spi driver are used in this driver. 

drivers/video/backlight/ili9320.c:51: undefined reference to `spi_sync'

Also, a prompt string for CONFIG_LCD_ILI9320 is added for explicit
selection.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/Kconfig~backlight-ili9320-add-missing-spi-dependency drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-ili9320-add-missing-spi-dependency
+++ a/drivers/video/backlight/Kconfig
@@ -60,7 +60,8 @@ config LCD_LTV350QV
 	  The LTV350QV panel is present on all ATSTK1000 boards.
 
 config LCD_ILI9320
-	tristate
+	tristate "ILI Technology ILI9320 controller support"
+	depends on SPI
 	help
 	  If you have a panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch
drivers-video-backlight-da9052_blc-add-missing-const.patch
drivers-video-backlight-lms283gf05c-add-missing-const.patch
drivers-video-backlight-tdo24mc-add-missing-const.patch
drivers-video-backlight-vgg2432a4c-add-missing-const.patch
drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch

