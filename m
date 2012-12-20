From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-replace-efault-with-einval.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:37:14 -0800
Message-ID: <20121220203715.1DD1B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59279 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:37:17 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so406259vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:37:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ams369fg06: replace EFAULT with EINVAL
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-replace-efault-with-einval.patch

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
Subject: backlight: ams369fg06: replace EFAULT with EINVAL

Replace EFAULT with EINVAL, because EFAULT tends to be for the invalid
memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-replace-efault-with-einval drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-replace-efault-with-einval
+++ a/drivers/video/backlight/ams369fg06.c
@@ -328,7 +328,7 @@ static int ams369fg06_power_on(struct am
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
@@ -336,7 +336,7 @@ static int ams369fg06_power_on(struct am
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -485,7 +485,7 @@ static int ams369fg06_probe(struct spi_d
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
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
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch

