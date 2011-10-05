From: akpm@google.com
Subject: + drivers-leds-leds-lm3530c-add-__devexit_p-where-needed.patch added to -mm tree
Date: Wed, 05 Oct 2011 14:49:16 -0700
Message-ID: <201110052149.p95LnGFp019960@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53231 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 17:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, linus.walleij@linaro.org, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lm3530.c: add __devexit_p where needed
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lm3530c-add-__devexit_p-where-needed.patch

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
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/leds/leds-lm3530.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-__devexit_p-where-needed drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-__devexit_p-where-needed
+++ a/drivers/leds/leds-lm3530.c
@@ -449,7 +449,7 @@ MODULE_DEVICE_TABLE(i2c, lm3530_id);
 
 static struct i2c_driver lm3530_i2c_driver = {
 	.probe = lm3530_probe,
-	.remove = lm3530_remove,
+	.remove = __devexit_p(lm3530_remove),
 	.id_table = lm3530_id,
 	.driver = {
 		.name = LM3530_NAME,
_
Subject: Subject: drivers/leds/leds-lm3530.c: add __devexit_p where needed

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch
leds-renesas-tpu-led-driver-v2-fix.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch
drivers-leds-leds-lm3530c-add-__devexit_p-where-needed.patch

