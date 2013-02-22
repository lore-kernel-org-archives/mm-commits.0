From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-use-sleep-instead-of-delay.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:11 -0800
Message-ID: <20130222204011.9EA765A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61256 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3BVUkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:12 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so103714yen.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: use sleep instead of delay
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-use-sleep-instead-of-delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

