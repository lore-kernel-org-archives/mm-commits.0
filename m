From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-use-sleep-instead-of-delay.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:37:08 -0800
Message-ID: <20121220203709.6614720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:33474 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUhL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:37:11 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so208034wgb.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:37:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ams369fg06: use sleep instead of delay
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-use-sleep-instead-of-delay.patch

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
Subject: backlight: ams369fg06: use sleep instead of delay

Replace mdelay with msleep to remove the busy loop waiting.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-sleep-instead-of-delay drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-sleep-instead-of-delay
+++ a/drivers/video/backlight/ams369fg06.c
@@ -210,8 +210,9 @@ static int ams369fg06_panel_send_sequenc
 			ret = ams369fg06_spi_write(lcd, wbuf[i], wbuf[i+1]);
 			if (ret)
 				break;
-		} else
-			mdelay(wbuf[i+1]);
+		} else {
+			msleep(wbuf[i+1]);
+		}
 		i += 2;
 	}
 
@@ -339,7 +340,7 @@ static int ams369fg06_power_on(struct am
 		return -EFAULT;
 	} else {
 		pd->power_on(lcd->ld, 1);
-		mdelay(pd->power_on_delay);
+		msleep(pd->power_on_delay);
 	}
 
 	if (!pd->reset) {
@@ -347,7 +348,7 @@ static int ams369fg06_power_on(struct am
 		return -EFAULT;
 	} else {
 		pd->reset(lcd->ld);
-		mdelay(pd->reset_delay);
+		msleep(pd->reset_delay);
 	}
 
 	ret = ams369fg06_ldi_init(lcd);
@@ -389,7 +390,7 @@ static int ams369fg06_power_off(struct a
 		return -EIO;
 	}
 
-	mdelay(pd->power_off_delay);
+	msleep(pd->power_off_delay);
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
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

