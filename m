From: akpm@linux-foundation.org
Subject: + leds-remove-an-unnecessary-goto-on-drivers-leds-leds-s3c24c.patch added to -mm tree
Date: Wed, 04 Mar 2009 14:24:36 -0800
Message-ID: <200903042224.n24MOaXR009991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbZCDWZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 17:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helight.xu@gmail.com, rmk@arm.linux.org.uk, rpurdie@rpsys.net


The patch titled
     leds: remove an unnecessary "goto" on drivers/leds/leds-s3c24.c
has been added to the -mm tree.  Its filename is
     leds-remove-an-unnecessary-goto-on-drivers-leds-leds-s3c24c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
