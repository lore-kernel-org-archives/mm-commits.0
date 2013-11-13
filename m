From: akpm@linux-foundation.org
Subject: [merged]
 backlight-generic_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:08 -0800
Message-ID: <5283e3e4.+RwKRo/fV0e0erTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3KMUlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-generic_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:08 -0800


The patch titled
     Subject: backlight: generic_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-generic_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: generic_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/generic_bl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/generic_bl.c~backlight-generic_bl-use-devm_backlight_device_register drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-generic_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/generic_bl.c
@@ -93,8 +93,8 @@ static int genericbl_probe(struct platfo
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
-	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
-				       &props);
+	bd = devm_backlight_device_register(&pdev->dev, name, &pdev->dev,
+					NULL, &genericbl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
@@ -118,8 +118,6 @@ static int genericbl_remove(struct platf
 	bd->props.brightness = 0;
 	backlight_update_status(bd);
 
-	backlight_device_unregister(bd);
