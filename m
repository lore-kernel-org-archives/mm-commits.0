From: akpm@linux-foundation.org
Subject: + backlight-ld9040-use-sleep-instead-of-delay.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:34:04 -0800
Message-ID: <20121220203405.159FC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:57326 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTUeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:34:06 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so94687ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:34:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ld9040: use sleep instead of delay
has been added to the -mm tree.  Its filename is
     backlight-ld9040-use-sleep-instead-of-delay.patch

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
Subject: backlight: ld9040: use sleep instead of delay

Replace mdelay with msleep to remove the busy loop waiting.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-use-sleep-instead-of-delay drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-use-sleep-instead-of-delay
+++ a/drivers/video/backlight/ld9040.c
@@ -78,7 +78,7 @@ static void ld9040_regulator_enable(stru
 
 		lcd->enabled = true;
 	}
-	mdelay(pd->power_on_delay);
+	msleep(pd->power_on_delay);
 out:
 	mutex_unlock(&lcd->lock);
 }
@@ -474,8 +474,9 @@ static int ld9040_panel_send_sequence(st
 			ret = ld9040_spi_write(lcd, wbuf[i], wbuf[i+1]);
 			if (ret)
 				break;
-		} else
-			udelay(wbuf[i+1]*1000);
+		} else {
+			msleep(wbuf[i+1]);
+		}
 		i += 2;
 	}
 
@@ -539,7 +540,7 @@ static int ld9040_ldi_init(struct ld9040
 	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
 		ret = ld9040_panel_send_sequence(lcd, init_seq[i]);
 		/* workaround: minimum delay time for transferring CMD */
-		udelay(300);
+		usleep_range(300, 310);
 		if (ret)
 			break;
 	}
@@ -584,7 +585,7 @@ static int ld9040_power_on(struct ld9040
 		return -EFAULT;
 	} else {
 		pd->reset(lcd->ld);
-		mdelay(pd->reset_delay);
+		msleep(pd->reset_delay);
 	}
 
 	ret = ld9040_ldi_init(lcd);
@@ -619,7 +620,7 @@ static int ld9040_power_off(struct ld904
 		return -EIO;
 	}
 
-	mdelay(pd->power_off_delay);
+	msleep(pd->power_off_delay);
 
 	/* lcd power off */
 	ld9040_regulator_disable(lcd);
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

