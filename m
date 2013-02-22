From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-use-sleep-instead-of-delay.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:44 -0800
Message-ID: <20130222204044.A1F0C5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47314 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab3BVUkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:45 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so103721vcd.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: use sleep instead of delay
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-use-sleep-instead-of-delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

