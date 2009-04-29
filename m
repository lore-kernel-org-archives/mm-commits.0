From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-gpioc-fix-a-section-mismatch.patch added to -mm tree
Date: Wed, 29 Apr 2009 13:08:30 -0700
Message-ID: <200904292008.n3TK8Ugs025173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbZD2UJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 16:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helight.xu@gmail.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-gpio.c: fix a section mismatch 
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-gpioc-fix-a-section-mismatch.patch

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
Subject: drivers/leds/leds-gpio.c: fix a section mismatch 
From: Zhenwen Xu <helight.xu@gmail.com>

WARNING: drivers/leds/leds-gpio.o(.text+0x153): Section mismatch in reference from the function gpio_led_probe() to the function .devinit.text:create_gpio_led()

The function gpio_led_probe() references the function __devinit
create_gpio_led().  This is often because gpio_led_probe lacks a __devinit
annotation or the annotation of create_gpio_led is wrong.

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-gpio.c~drivers-leds-leds-gpioc-fix-a-section-mismatch drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~drivers-leds-leds-gpioc-fix-a-section-mismatch
+++ a/drivers/leds/leds-gpio.c
@@ -129,7 +129,7 @@ static void delete_gpio_led(struct gpio_
 }
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM
-static int gpio_led_probe(struct platform_device *pdev)
+static int __devinit gpio_led_probe(struct platform_device *pdev)
 {
 	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_led_data *leds_data;
_

Patches currently in -mm which might be from helight.xu@gmail.com are

drivers-leds-leds-gpioc-fix-a-section-mismatch.patch
drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit.patch
drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch

