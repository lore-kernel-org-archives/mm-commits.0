From: akpm@linux-foundation.org
Subject: [merged] gpio-led-properly-initialize-return-value.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:49 -0800
Message-ID: <201011161934.oAGJY13m003164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422Ab0KPTeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-gpio.c: properly initialize return value
has been removed from the -mm tree.  Its filename was
     gpio-led-properly-initialize-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-gpio.c: properly initialize return value
From: Davidlohr Bueso <dave@gnu.org>

In the event that none of the configs are set (CONFIG_LEDS_GPIO_PLATFORM,
CONFIG_LEDS_GPIO_OF, CONFIG_LEDS_GPIO_PLATFORM), we will return a bogus
value when initializing the module.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-gpio.c~gpio-led-properly-initialize-return-value drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~gpio-led-properly-initialize-return-value
+++ a/drivers/leds/leds-gpio.c
@@ -316,7 +316,7 @@ static struct of_platform_driver of_gpio
 
 static int __init gpio_led_init(void)
 {
-	int ret;
+	int ret = 0;
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM	
 	ret = platform_driver_register(&gpio_led_driver);
_

Patches currently in -mm which might be from dave@gnu.org are


