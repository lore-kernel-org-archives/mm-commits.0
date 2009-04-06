From: akpm@linux-foundation.org
Subject: [merged] leds-remove-an-unnecessary-goto-on-drivers-leds-leds-s3c24c.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:06 -0700
Message-ID: <200904061939.n36Jd6N8013698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbZDFULu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helight.xu@gmail.com, rmk@arm.linux.org.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: remove an unnecessary "goto" on drivers/leds/leds-s3c24.c
has been removed from the -mm tree.  Its filename was
     leds-remove-an-unnecessary-goto-on-drivers-leds-leds-s3c24c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: remove an unnecessary "goto" on drivers/leds/leds-s3c24.c
From: Zhenwen Xu <helight.xu@gmail.com>

This goto is unnecessary.

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-s3c24xx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-s3c24xx.c~leds-remove-an-unnecessary-goto-on-drivers-leds-leds-s3c24c drivers/leds/leds-s3c24xx.c
--- a/drivers/leds/leds-s3c24xx.c~leds-remove-an-unnecessary-goto-on-drivers-leds-leds-s3c24c
+++ a/drivers/leds/leds-s3c24xx.c
@@ -102,14 +102,11 @@ static int s3c24xx_led_probe(struct plat
 	ret = led_classdev_register(&dev->dev, &led->cdev);
 	if (ret < 0) {
 		dev_err(&dev->dev, "led_classdev_register failed\n");
-		goto exit_err1;
+		kfree(led);
+		return ret;
 	}
 
 	return 0;
