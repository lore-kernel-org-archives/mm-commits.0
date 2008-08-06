From: akpm@linux-foundation.org
Subject: - backlight-add-more-information-output-to-pwm_backlight.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:42 -0700
Message-ID: <200808062056.m76Kug9R014694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422893AbYHFU6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, krzysztof.h1@wp.pl, rmk@arm.linux.org.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: add more information output to pwm_backlight
has been removed from the -mm tree.  Its filename was
     backlight-add-more-information-output-to-pwm_backlight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: add more information output to pwm_backlight
From: Ben Dooks <ben-linux@fluff.org>

Make the error paths in the pwm_backlight driver more informative in the
probe path, especially for the times that it finds an error.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-add-more-information-output-to-pwm_backlight drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-add-more-information-output-to-pwm_backlight
+++ a/drivers/video/backlight/pwm_bl.c
@@ -68,8 +68,10 @@ static int pwm_backlight_probe(struct pl
 	struct pwm_bl_data *pb;
 	int ret;
 
-	if (!data)
+	if (!data) {
+		dev_err(&pdev->dev, "failed to find platform data\n");
 		return -EINVAL;
+	}
 
 	if (data->init) {
 		ret = data->init(&pdev->dev);
@@ -79,6 +81,7 @@ static int pwm_backlight_probe(struct pl
 
 	pb = kzalloc(sizeof(*pb), GFP_KERNEL);
 	if (!pb) {
+		dev_err(&pdev->dev, "no memory for state\n");
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
@@ -91,7 +94,8 @@ static int pwm_backlight_probe(struct pl
 		dev_err(&pdev->dev, "unable to request PWM for backlight\n");
 		ret = PTR_ERR(pb->pwm);
 		goto err_pwm;
-	}
+	} else
+		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
 	bl = backlight_device_register(pdev->name, &pdev->dev,
 			pb, &pwm_backlight_ops);
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-update-debugging-low-information-messages.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

