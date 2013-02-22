From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-use-sleep-instead-of-delay.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:29 -0800
Message-ID: <20130222204029.98E2931C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58928 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3BVUka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:30 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so118924qaj.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: use sleep instead of delay
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-use-sleep-instead-of-delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: use sleep instead of delay

Replace mdelay with msleep to remove the busy loop waiting.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-sleep-instead-of-delay drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-sleep-instead-of-delay
+++ a/drivers/video/backlight/s6e63m0.c
@@ -406,8 +406,9 @@ static int s6e63m0_panel_send_sequence(s
 			ret = s6e63m0_spi_write(lcd, wbuf[i], wbuf[i+1]);
 			if (ret)
 				break;
-		} else
-			udelay(wbuf[i+1]*1000);
+		} else {
+			msleep(wbuf[i+1]);
+		}
 		i += 2;
 	}
 
@@ -523,7 +524,7 @@ static int s6e63m0_power_on(struct s6e63
 		return -EFAULT;
 	} else {
 		pd->power_on(lcd->ld, 1);
-		mdelay(pd->power_on_delay);
+		msleep(pd->power_on_delay);
 	}
 
 	if (!pd->reset) {
@@ -531,7 +532,7 @@ static int s6e63m0_power_on(struct s6e63
 		return -EFAULT;
 	} else {
 		pd->reset(lcd->ld);
-		mdelay(pd->reset_delay);
+		msleep(pd->reset_delay);
 	}
 
 	ret = s6e63m0_ldi_init(lcd);
@@ -573,7 +574,7 @@ static int s6e63m0_power_off(struct s6e6
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

