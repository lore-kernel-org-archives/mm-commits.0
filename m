From: akpm@linux-foundation.org
Subject: + backlight-ot200_bl-use-devm_backlight_device_register.patch
 added to -mm tree
Date: Mon, 02 Dec 2013 17:00:34 -0800
Message-ID: <529d2d32.vAINcNgPlm55IoYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3LCBAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-ot200_bl-use-devm_backlight_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:34 -0800


The patch titled
     Subject: backlight: ot200_bl: use devm_backlight_device_register()
has been added to the -mm tree.  Its filename is
     backlight-ot200_bl-use-devm_backlight_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-ot200_bl-use-devm_backlight_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-ot200_bl-use-devm_backlight_device_register.patch

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
Subject: backlight: ot200_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ot200_bl.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/ot200_bl.c~backlight-ot200_bl-use-devm_backlight_device_register drivers/video/backlight/ot200_bl.c
--- a/drivers/video/backlight/ot200_bl.c~backlight-ot200_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/ot200_bl.c
@@ -118,8 +118,9 @@ static int ot200_backlight_probe(struct
 	props.brightness = 100;
 	props.type = BACKLIGHT_RAW;
 
-	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, data,
-					&ot200_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, dev_name(&pdev->dev),
+					&pdev->dev, data, &ot200_backlight_ops,
+					&props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		retval = PTR_ERR(bl);
@@ -137,10 +138,6 @@ error_devm_kzalloc:
 
 static int ot200_backlight_remove(struct platform_device *pdev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
