From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lm3530c-add-__devexit_p-where-needed.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:27 -0700
Message-ID: <201111012115.pA1LFRRE008980@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KAVPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, linus.walleij@linaro.org, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lm3530.c: add __devexit_p where needed
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-add-__devexit_p-where-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lm3530.c: add __devexit_p where needed

According to the comments in include/linux/init.h:

"Pointers to __devexit functions must use __devexit_p(function_name), the
wrapper will insert either the function_name or NULL, depending on the config
options."

We have __devexit annotation for lm3530_remove(), so add __devexit_p to
the `struct i2c_driver'.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-__devexit_p-where-needed drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-__devexit_p-where-needed
+++ a/drivers/leds/leds-lm3530.c
@@ -448,7 +448,7 @@ MODULE_DEVICE_TABLE(i2c, lm3530_id);
 
 static struct i2c_driver lm3530_i2c_driver = {
 	.probe = lm3530_probe,
-	.remove = lm3530_remove,
+	.remove = __devexit_p(lm3530_remove),
 	.id_table = lm3530_id,
 	.driver = {
 		.name = LM3530_NAME,
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

