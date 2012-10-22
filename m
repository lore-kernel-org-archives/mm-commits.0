From: akpm@linux-foundation.org
Subject: + backlight-ili9320-add-missing-spi-dependency.patch added to -mm tree
Date: Mon, 22 Oct 2012 13:49:27 -0700
Message-ID: <20121022204928.27B9B5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38517 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2JVUtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 16:49:31 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so189280lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 13:49:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, ben-linux@fluff.org, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ili9320: add missing SPI dependency
has been added to the -mm tree.  Its filename is
     backlight-ili9320-add-missing-spi-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

backlight-ili9320-add-missing-spi-dependency.patch
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

