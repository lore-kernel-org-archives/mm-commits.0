From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-gpioc-use-linux-gpioh-rather-than-asm-gpioh.patch added to -mm tree
Date: Mon, 06 Feb 2012 16:12:56 -0800
Message-ID: <20120207001256.4D7D7A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40057 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab2BGAM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 19:12:58 -0500
Received: by eaag13 with SMTP id g13so92393eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 16:12:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-gpio.c: use linux/gpio.h rather than asm/gpio.h
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-gpioc-use-linux-gpioh-rather-than-asm-gpioh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: drivers/leds/leds-gpio.c: use linux/gpio.h rather than asm/gpio.h

Direct usage of the asm include has long been deprecated by the
introduction of gpiolib.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/leds/leds-gpio.c~drivers-leds-leds-gpioc-use-linux-gpioh-rather-than-asm-gpioh drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~drivers-leds-leds-gpioc-use-linux-gpioh-rather-than-asm-gpioh
+++ a/drivers/leds/leds-gpio.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
@@ -20,8 +21,6 @@
 #include <linux/workqueue.h>
 #include <linux/module.h>
 
-#include <asm/gpio.h>
