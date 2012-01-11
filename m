From: akpm@linux-foundation.org
Subject: [merged] leds-netxbig-use-gpio_request_one.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:33 -0800
Message-ID: <20120111213033.AB3F2100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33196 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2AKVae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:34 -0500
Received: by ghrr15 with SMTP id r15so137318ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, sguinot@lacie.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-netxbig.c: use gpio_request_one()
has been removed from the -mm tree.  Its filename was
     leds-netxbig-use-gpio_request_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-netxbig.c: use gpio_request_one()

Use gpio_request_one() instead of multiple gpiolib calls.  This also
simplifies error handling a bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Simon Guinot <sguinot@lacie.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-netxbig.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN drivers/leds/leds-netxbig.c~leds-netxbig-use-gpio_request_one drivers/leds/leds-netxbig.c
--- a/drivers/leds/leds-netxbig.c~leds-netxbig-use-gpio_request_one
+++ a/drivers/leds/leds-netxbig.c
@@ -81,35 +81,23 @@ static int __devinit gpio_ext_init(struc
 
 	/* Configure address GPIOs. */
 	for (i = 0; i < gpio_ext->num_addr; i++) {
-		err = gpio_request(gpio_ext->addr[i], "GPIO extension addr");
+		err = gpio_request_one(gpio_ext->addr[i], GPIOF_OUT_INIT_LOW,
+				       "GPIO extension addr");
 		if (err)
 			goto err_free_addr;
-		err = gpio_direction_output(gpio_ext->addr[i], 0);
-		if (err) {
-			gpio_free(gpio_ext->addr[i]);
-			goto err_free_addr;
-		}
 	}
 	/* Configure data GPIOs. */
 	for (i = 0; i < gpio_ext->num_data; i++) {
-		err = gpio_request(gpio_ext->data[i], "GPIO extension data");
+		err = gpio_request_one(gpio_ext->data[i], GPIOF_OUT_INIT_LOW,
+				   "GPIO extension data");
 		if (err)
 			goto err_free_data;
-		err = gpio_direction_output(gpio_ext->data[i], 0);
-		if (err) {
-			gpio_free(gpio_ext->data[i]);
-			goto err_free_data;
-		}
 	}
 	/* Configure "enable select" GPIO. */
-	err = gpio_request(gpio_ext->enable, "GPIO extension enable");
+	err = gpio_request_one(gpio_ext->enable, GPIOF_OUT_INIT_LOW,
+			       "GPIO extension enable");
 	if (err)
 		goto err_free_data;
-	err = gpio_direction_output(gpio_ext->enable, 0);
-	if (err) {
-		gpio_free(gpio_ext->enable);
-		goto err_free_data;
-	}
 
 	return 0;
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

