From: akpm@linux-foundation.org
Subject: [merged] leds-remove-config-option-leds_gpio_platform-from-kconfig.patch removed from -mm tree
Date: Tue, 07 Jun 2011 13:18:27 -0700
Message-ID: <201106072017.p57KHPfP024486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab1FGURj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 16:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shawn.guo@linaro.org, grant.likely@secretlab.ca, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: remove config option LEDS_GPIO_PLATFORM from Kconfig
has been removed from the -mm tree.  Its filename was
     leds-remove-config-option-leds_gpio_platform-from-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: remove config option LEDS_GPIO_PLATFORM from Kconfig
From: Shawn Guo <shawn.guo@linaro.org>

Since a314c5c004 ("leds/leds-gpio: merge platform_driver with
of_platform_driver"), the config option LEDS_GPIO_PLATFORM becomes
useless, so remove it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN drivers/leds/Kconfig~leds-remove-config-option-leds_gpio_platform-from-kconfig drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-remove-config-option-leds_gpio_platform-from-kconfig
+++ a/drivers/leds/Kconfig
@@ -93,7 +93,7 @@ config LEDS_NET48XX
 config LEDS_NET5501
 	tristate "LED Support for Soekris net5501 series Error LED"
 	depends on LEDS_TRIGGERS
-	depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	depends on X86 && GPIO_CS5535
 	select LEDS_TRIGGER_DEFAULT_ON
 	default n
 	help
@@ -183,14 +183,6 @@ config LEDS_GPIO
 	  defined as platform devices and/or OpenFirmware platform devices.
 	  The code to use these bindings can be selected below.
 
-config LEDS_GPIO_PLATFORM
-	bool "Platform device bindings for GPIO LEDs"
-	depends on LEDS_GPIO
-	default y
-	help
-	  Let the leds-gpio driver drive LEDs which have been defined as
-	  platform devices.  If you don't know what this means, say yes.
