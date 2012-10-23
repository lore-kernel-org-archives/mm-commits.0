From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lms283gf05c-add-missing-const.patch added to -mm tree
Date: Tue, 23 Oct 2012 12:47:38 -0700
Message-ID: <20121023194738.6A1CF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41363 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2JWTrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 15:47:39 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so529647yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 12:47:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, marex@denx.de, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/lms283gf05.c: add missing const
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lms283gf05c-add-missing-const.patch

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
Subject: drivers/video/backlight/lms283gf05.c: add missing const

Add 'const' to static array that was missing it in its definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Marek Vasut <marex@denx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-add-missing-const drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-add-missing-const
+++ a/drivers/video/backlight/lms283gf05.c
@@ -31,7 +31,7 @@ struct lms283gf05_seq {
 };
 
 /* Magic sequences supplied by manufacturer, for details refer to datasheet */
-static struct lms283gf05_seq disp_initseq[] = {
+static const struct lms283gf05_seq disp_initseq[] = {
 	/* REG, VALUE, DELAY */
 	{ 0x07, 0x0000, 0 },
 	{ 0x13, 0x0000, 10 },
@@ -78,7 +78,7 @@ static struct lms283gf05_seq disp_initse
 	{ 0x22, 0x0000, 0 }
 };
 
-static struct lms283gf05_seq disp_pdwnseq[] = {
+static const struct lms283gf05_seq disp_pdwnseq[] = {
 	{ 0x07, 0x0016, 30 },
 
 	{ 0x07, 0x0004, 0 },
@@ -104,7 +104,7 @@ static void lms283gf05_reset(unsigned lo
 }
 
 static void lms283gf05_toggle(struct spi_device *spi,
-			struct lms283gf05_seq *seq, int sz)
+				const struct lms283gf05_seq *seq, int sz)
 {
 	char buf[3];
 	int i;
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

