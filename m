From: akpm@linux-foundation.org
Subject: + backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
 added to -mm tree
Date: Thu, 06 Feb 2014 14:02:55 -0800
Message-ID: <52f4068f.LWedMLMGihsI0232%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbaBFWC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 17:02:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-tps65217_bl-remove-unnecessary-oom-messages.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 14:02:55 -0800


The patch titled
     Subject: backlight: tps65217_bl: remove unnecessary OOM messages
has been added to the -mm tree.  Its filename is
     backlight-tps65217_bl-remove-unnecessary-oom-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-tps65217_bl-remove-unnecessary-oom-messages.patch

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

backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
backlight-aat2870-remove-unnecessary-oom-messages.patch
backlight-adp8860-remove-unnecessary-oom-messages.patch
backlight-adp8870-remove-unnecessary-oom-messages.patch
backlight-corgi_lcd-remove-unnecessary-oom-messages.patch
backlight-hx8357-remove-unnecessary-oom-messages.patch
backlight-ili922x-remove-unnecessary-oom-messages.patch
backlight-ili9320-remove-unnecessary-oom-messages.patch
backlight-l4f00242t03-remove-unnecessary-oom-messages.patch
backlight-lm3533_bl-remove-unnecessary-oom-messages.patch
backlight-lms283gf05-remove-unnecessary-oom-messages.patch
backlight-platform_lcd-remove-unnecessary-oom-messages.patch
backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

