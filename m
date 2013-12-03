From: akpm@linux-foundation.org
Subject: + backlight-hp680_bl-use-devm_backlight_device_register.patch
 added to -mm tree
Date: Mon, 02 Dec 2013 17:00:32 -0800
Message-ID: <529d2d30.Lyf9ELM+RbbvLh6g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3LCBAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-hp680_bl-use-devm_backlight_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:32 -0800


The patch titled
     Subject: backlight: hp680_bl: use devm_backlight_device_register()
has been added to the -mm tree.  Its filename is
     backlight-hp680_bl-use-devm_backlight_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-hp680_bl-use-devm_backlight_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-hp680_bl-use-devm_backlight_device_register.patch

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
Subject: backlight: hp680_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hp680_bl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-use-devm_backlight_device_register drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/hp680_bl.c
@@ -110,8 +110,8 @@ static int hp680bl_probe(struct platform
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = HP680_MAX_INTENSITY;
-	bd = backlight_device_register("hp680-bl", &pdev->dev, NULL,
-				       &hp680bl_ops, &props);
+	bd = devm_backlight_device_register(&pdev->dev, "hp680-bl", &pdev->dev,
+					NULL, &hp680bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
@@ -131,8 +131,6 @@ static int hp680bl_remove(struct platfor
 	bd->props.power = 0;
 	hp680bl_send_intensity(bd);
 
-	backlight_device_unregister(bd);
