From: akpm@linux-foundation.org
Subject: [merged] leds-bd2802-use-gpio_request_one.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:29 -0800
Message-ID: <20120111213030.251D85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62274 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2AKVab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:31 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32568eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-bd2802.c: use gpio_request_one()
has been removed from the -mm tree.  Its filename was
     leds-bd2802-use-gpio_request_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-bd2802.c: use gpio_request_one()

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-bd2802-use-gpio_request_one drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-bd2802-use-gpio_request_one
+++ a/drivers/leds/leds-bd2802.c
@@ -688,8 +688,7 @@ static int __devinit bd2802_probe(struct
 	i2c_set_clientdata(client, led);
 
 	/* Configure RESET GPIO (L: RESET, H: RESET cancel) */
-	gpio_request(pdata->reset_gpio, "RGB_RESETB");
-	gpio_direction_output(pdata->reset_gpio, 1);
+	gpio_request_one(pdata->reset_gpio, GPIOF_OUT_INIT_HIGH, "RGB_RESETB");
 
 	/* Tacss = min 0.1ms */
 	udelay(100);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

