From: akpm@linux-foundation.org
Subject: [merged]
 backlight-platform_lcd-remove-unnecessary-oom-messages.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:38 -0700
Message-ID: <533f0912.s+EmixKtQA4Dq0ZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaDDTdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-platform_lcd-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:38 -0700


The patch titled
     Subject: backlight: platform_lcd: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-platform_lcd-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: platform_lcd: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-platform_lcd-remove-unnecessary-oom-messages drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-platform_lcd-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/platform_lcd.c
@@ -94,10 +94,8 @@ static int platform_lcd_probe(struct pla
 
 	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
 			    GFP_KERNEL);
-	if (!plcd) {
-		dev_err(dev, "no memory for state\n");
+	if (!plcd)
 		return -ENOMEM;
-	}
 
 	plcd->us = dev;
 	plcd->pdata = pdata;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

