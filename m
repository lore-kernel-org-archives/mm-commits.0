From: akpm@linux-foundation.org
Subject: + backlight-ld9040-replace-efault-with-einval.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:34:09 -0800
Message-ID: <20121220203410.1623C100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:58764 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTUeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:34:11 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so405862yhr.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:34:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ld9040: replace EFAULT with EINVAL
has been added to the -mm tree.  Its filename is
     backlight-ld9040-replace-efault-with-einval.patch

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
Subject: backlight: ld9040: replace EFAULT with EINVAL

Replace EFAULT with EINVAL, because EFAULT tends to be for the invalid
memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-replace-efault-with-einval drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-replace-efault-with-einval
+++ a/drivers/video/backlight/ld9040.c
@@ -583,7 +583,7 @@ static int ld9040_power_on(struct ld9040
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -724,7 +724,7 @@ static int ld9040_probe(struct spi_devic
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	mutex_init(&lcd->lock);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch

