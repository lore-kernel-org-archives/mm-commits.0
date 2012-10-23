From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-vgg2432a4c-add-missing-const.patch added to -mm tree
Date: Tue, 23 Oct 2012 12:47:44 -0700
Message-ID: <20121023194745.7CB4E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:32856 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2JWTrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 15:47:48 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so254657eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 12:47:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, ben-linux@fluff.org, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/vgg2432a4.c: add missing const
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-vgg2432a4c-add-missing-const.patch

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
Subject: drivers/video/backlight/vgg2432a4.c: add missing const

Add 'const' to static array that was missing it in its definition.  Also,
'const' is added to ili9320_write_regs(), because it is called by
vgg2432a4 driver.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c   |    2 +-
 drivers/video/backlight/ili9320.h   |    2 +-
 drivers/video/backlight/vgg2432a4.c |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~drivers-video-backlight-vgg2432a4c-add-missing-const drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~drivers-video-backlight-vgg2432a4c-add-missing-const
+++ a/drivers/video/backlight/ili9320.c
@@ -59,7 +59,7 @@ int ili9320_write(struct ili9320 *ili, u
 EXPORT_SYMBOL_GPL(ili9320_write);
 
 int ili9320_write_regs(struct ili9320 *ili,
-		       struct ili9320_reg *values,
+		       const struct ili9320_reg *values,
 		       int nr_values)
 {
 	int index;
diff -puN drivers/video/backlight/ili9320.h~drivers-video-backlight-vgg2432a4c-add-missing-const drivers/video/backlight/ili9320.h
--- a/drivers/video/backlight/ili9320.h~drivers-video-backlight-vgg2432a4c-add-missing-const
+++ a/drivers/video/backlight/ili9320.h
@@ -63,7 +63,7 @@ extern int ili9320_write(struct ili9320 
 			 unsigned int reg, unsigned int value);
 
 extern int ili9320_write_regs(struct ili9320 *ili,
-			      struct ili9320_reg *values,
+			      const struct ili9320_reg *values,
 			      int nr_values);
 
 /* Device probe */
diff -puN drivers/video/backlight/vgg2432a4.c~drivers-video-backlight-vgg2432a4c-add-missing-const drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~drivers-video-backlight-vgg2432a4c-add-missing-const
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -26,7 +26,7 @@
 
 /* Device initialisation sequences */
 
-static struct ili9320_reg vgg_init1[] = {
+static const struct ili9320_reg vgg_init1[] = {
 	{
 		.address = ILI9320_POWER1,
 		.value	 = ILI9320_POWER1_AP(0) | ILI9320_POWER1_BT(0),
@@ -43,7 +43,7 @@ static struct ili9320_reg vgg_init1[] = 
 	},
 };
 
-static struct ili9320_reg vgg_init2[] = {
+static const struct ili9320_reg vgg_init2[] = {
 	{
 		.address = ILI9320_POWER1,
 		.value   = (ILI9320_POWER1_AP(3) | ILI9320_POWER1_APE |
@@ -54,7 +54,7 @@ static struct ili9320_reg vgg_init2[] = 
 	}
 };
 
-static struct ili9320_reg vgg_gamma[] = {
+static const struct ili9320_reg vgg_gamma[] = {
 	{
 		.address = ILI9320_GAMMA1,
 		.value	 = 0x0000,
@@ -89,7 +89,7 @@ static struct ili9320_reg vgg_gamma[] = 
 
 };
 
-static struct ili9320_reg vgg_init0[] = {
+static const struct ili9320_reg vgg_init0[] = {
 	[0]	= {
 		/* set direction and scan mode gate */
 		.address = ILI9320_DRIVER,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-ili9320-add-missing-spi-dependency.patch
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

