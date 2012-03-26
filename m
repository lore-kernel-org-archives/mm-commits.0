From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-gpioc-use-linux-gpioh-rather-than-asm-gpioh.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:44 -0700
Message-ID: <20120326192944.53193A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63241 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:46 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so290130wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-gpio.c: use linux/gpio.h rather than asm/gpio.h
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-gpioc-use-linux-gpioh-rather-than-asm-gpioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
