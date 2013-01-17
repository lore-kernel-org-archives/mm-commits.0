From: akpm@linux-foundation.org
Subject: + drivers-rtc-use-of_match_ptr-macro-fix.patch added to -mm tree
Date: Thu, 17 Jan 2013 14:42:15 -0800
Message-ID: <20130117224215.9A3B031C129@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42499 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3AQWmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 17:42:16 -0500
Received: by mail-ie0-f202.google.com with SMTP id s9so805247iec.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 14:42:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-twl: use of_match_ptr() macro
has been added to the -mm tree.  Its filename is
     drivers-rtc-use-of_match_ptr-macro-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-twl: use of_match_ptr() macro

Used of_match_ptr() macro with CONFIG_OF defined.
This maintains code consistency with the rest of the drivers.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-use-of_match_ptr-macro-fix drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-use-of_match_ptr-macro-fix
+++ a/drivers/rtc/rtc-twl.c
@@ -27,6 +27,7 @@
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 
 #include <linux/i2c/twl.h>
 
@@ -588,11 +589,14 @@ static int twl_rtc_resume(struct platfor
 #define twl_rtc_resume  NULL
 #endif
 
+#ifdef CONFIG_OF
 static const struct of_device_id twl_rtc_of_match[] = {
 	{.compatible = "ti,twl4030-rtc", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, twl_rtc_of_match);
+#endif
+
 MODULE_ALIAS("platform:twl_rtc");
 
 static struct platform_driver twl4030rtc_driver = {
@@ -604,7 +608,7 @@ static struct platform_driver twl4030rtc
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "twl_rtc",
-		.of_match_table = twl_rtc_of_match,
+		.of_match_table = of_match_ptr(twl_rtc_of_match),
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch
drivers-rtc-use-of_match_ptr-macro.patch
drivers-rtc-use-of_match_ptr-macro-fix.patch

