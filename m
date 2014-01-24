From: akpm@linux-foundation.org
Subject: [merged]
 backlight-hp680_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:01:11 -0800
Message-ID: <52e2b877.ut/cpdLnJGC4iejN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: [merged] backlight-hp680_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:11 -0800


The patch titled
     Subject: backlight: hp680_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-hp680_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
