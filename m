From: akpm@linux-foundation.org
Subject: + leds-remove-config-option-leds_gpio_platform-from-kconfig.patch added to -mm tree
Date: Mon, 06 Jun 2011 16:29:28 -0700
Message-ID: <201106062329.p56NTSK6029829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab1FFX3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 19:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shawn.guo@linaro.org, grant.likely@secretlab.ca, rpurdie@rpsys.net


The patch titled
     leds: remove config option LEDS_GPIO_PLATFORM from Kconfig
has been added to the -mm tree.  Its filename is
     leds-remove-config-option-leds_gpio_platform-from-kconfig.patch

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
