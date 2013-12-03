From: akpm@linux-foundation.org
Subject: + backlight-jornada720-use-devm_backlight_device_register.patch
 added to -mm tree
Date: Mon, 02 Dec 2013 17:00:31 -0800
Message-ID: <529d2d2f.7p9o+TAg1caCNVeO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3LCBAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-jornada720-use-devm_backlight_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:31 -0800


The patch titled
     Subject: backlight: jornada720: use devm_backlight_device_register()
has been added to the -mm tree.  Its filename is
     backlight-jornada720-use-devm_backlight_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-jornada720-use-devm_backlight_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-jornada720-use-devm_backlight_device_register.patch

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
Subject: backlight: jornada720: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/jornada720_bl.c~backlight-jornada720-use-devm_backlight_device_register drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~backlight-jornada720-use-devm_backlight_device_register
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -115,9 +115,10 @@ static int jornada_bl_probe(struct platf
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = BL_MAX_BRIGHT;
-	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
-				       &jornada_bl_ops, &props);
 
+	bd = devm_backlight_device_register(&pdev->dev, S1D_DEVICENAME,
+					&pdev->dev, NULL, &jornada_bl_ops,
+					&props);
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
 		dev_err(&pdev->dev, "failed to register device, err=%x\n", ret);
@@ -139,18 +140,8 @@ static int jornada_bl_probe(struct platf
 	return 0;
 }
 
-static int jornada_bl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bd);
-
-	return 0;
-}
