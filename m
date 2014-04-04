From: akpm@linux-foundation.org
Subject: [merged]
 backlight-tps65217_bl-remove-unnecessary-oom-messages.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:40 -0700
Message-ID: <533f0914.2qSNurecl0QbqZfd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaDDTdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-tps65217_bl-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:40 -0700


The patch titled
     Subject: backlight: tps65217_bl: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-tps65217_bl-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tps65217_bl: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tps65217_bl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/backlight/tps65217_bl.c~backlight-tps65217_bl-remove-unnecessary-oom-messages drivers/video/backlight/tps65217_bl.c
--- a/drivers/video/backlight/tps65217_bl.c~backlight-tps65217_bl-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/tps65217_bl.c
@@ -200,7 +200,6 @@ tps65217_bl_parse_dt(struct platform_dev
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
-		dev_err(&pdev->dev, "failed to allocate platform data\n");
 		err = ERR_PTR(-ENOMEM);
 		goto err;
 	}
@@ -296,10 +295,8 @@ static int tps65217_bl_probe(struct plat
 
 	tps65217_bl = devm_kzalloc(&pdev->dev, sizeof(*tps65217_bl),
 				GFP_KERNEL);
-	if (tps65217_bl == NULL) {
-		dev_err(&pdev->dev, "allocation of struct tps65217_bl failed\n");
+	if (tps65217_bl == NULL)
 		return -ENOMEM;
-	}
 
 	tps65217_bl->tps = tps;
 	tps65217_bl->dev = &pdev->dev;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

