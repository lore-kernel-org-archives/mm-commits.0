From: akpm@linux-foundation.org
Subject: + arm-omap-switch-over-to-gpio_set_debounce.patch added to -mm tree
Date: Thu, 20 May 2010 11:12:02 -0700
Message-ID: <201005201812.o4KIC2qA029231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093Ab0ETSMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 14:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.balbi@nokia.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, tony@atomide.com


The patch titled
     arm: omap: switch over to gpio_set_debounce
has been added to the -mm tree.  Its filename is
     arm-omap-switch-over-to-gpio_set_debounce.patch

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
Subject: arm: omap: switch over to gpio_set_debounce
From: Felipe Balbi <felipe.balbi@nokia.com>

Stop using the omap-specific implementations for gpio debouncing now that
gpiolib provides its own support.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/board-3430sdp.c        |    4 +---
 arch/arm/mach-omap2/board-ldp.c            |    3 +--
 arch/arm/mach-omap2/board-omap3evm.c       |    4 +---
 arch/arm/mach-omap2/board-omap3pandora.c   |    4 ++--
 arch/arm/mach-omap2/board-omap3touchbook.c |    3 +--
 5 files changed, 6 insertions(+), 12 deletions(-)

diff -puN arch/arm/mach-omap2/board-3430sdp.c~arm-omap-switch-over-to-gpio_set_debounce arch/arm/mach-omap2/board-3430sdp.c
--- a/arch/arm/mach-omap2/board-3430sdp.c~arm-omap-switch-over-to-gpio_set_debounce
+++ a/arch/arm/mach-omap2/board-3430sdp.c
@@ -137,9 +137,7 @@ static void ads7846_dev_init(void)
 	}
 
 	gpio_direction_input(ts_gpio);
-
-	omap_set_gpio_debounce(ts_gpio, 1);
-	omap_set_gpio_debounce_time(ts_gpio, 0xa);
+	gpio_set_debounce(ts_gpio, 310);
 }
 
 static int ads7846_get_pendown_state(void)
diff -puN arch/arm/mach-omap2/board-ldp.c~arm-omap-switch-over-to-gpio_set_debounce arch/arm/mach-omap2/board-ldp.c
--- a/arch/arm/mach-omap2/board-ldp.c~arm-omap-switch-over-to-gpio_set_debounce
+++ a/arch/arm/mach-omap2/board-ldp.c
@@ -209,8 +209,7 @@ static void ads7846_dev_init(void)
 	}
 
 	gpio_direction_input(ts_gpio);
-	omap_set_gpio_debounce(ts_gpio, 1);
-	omap_set_gpio_debounce_time(ts_gpio, 0xa);
+	gpio_set_debounce(ts_gpio, 310);
 }
 
 static int ads7846_get_pendown_state(void)
diff -puN arch/arm/mach-omap2/board-omap3evm.c~arm-omap-switch-over-to-gpio_set_debounce arch/arm/mach-omap2/board-omap3evm.c
--- a/arch/arm/mach-omap2/board-omap3evm.c~arm-omap-switch-over-to-gpio_set_debounce
+++ a/arch/arm/mach-omap2/board-omap3evm.c
@@ -579,9 +579,7 @@ static void ads7846_dev_init(void)
 		printk(KERN_ERR "can't get ads7846 pen down GPIO\n");
 
 	gpio_direction_input(OMAP3_EVM_TS_GPIO);
-
-	omap_set_gpio_debounce(OMAP3_EVM_TS_GPIO, 1);
-	omap_set_gpio_debounce_time(OMAP3_EVM_TS_GPIO, 0xa);
+	gpio_set_debounce(OMAP3_EVM_TS_GPIO, 310);
 }
 
 static int ads7846_get_pendown_state(void)
diff -puN arch/arm/mach-omap2/board-omap3pandora.c~arm-omap-switch-over-to-gpio_set_debounce arch/arm/mach-omap2/board-omap3pandora.c
--- a/arch/arm/mach-omap2/board-omap3pandora.c~arm-omap-switch-over-to-gpio_set_debounce
+++ a/arch/arm/mach-omap2/board-omap3pandora.c
@@ -130,8 +130,8 @@ static struct platform_device pandora_ke
 static void __init pandora_keys_gpio_init(void)
 {
 	/* set debounce time for GPIO banks 4 and 6 */
-	omap_set_gpio_debounce_time(32 * 3, GPIO_DEBOUNCE_TIME);
-	omap_set_gpio_debounce_time(32 * 5, GPIO_DEBOUNCE_TIME);
+	gpio_set_debounce(32 * 3, GPIO_DEBOUNCE_TIME);
+	gpio_set_debounce(32 * 5, GPIO_DEBOUNCE_TIME);
 }
 
 static int board_keymap[] = {
diff -puN arch/arm/mach-omap2/board-omap3touchbook.c~arm-omap-switch-over-to-gpio_set_debounce arch/arm/mach-omap2/board-omap3touchbook.c
--- a/arch/arm/mach-omap2/board-omap3touchbook.c~arm-omap-switch-over-to-gpio_set_debounce
+++ a/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -328,8 +328,7 @@ static void __init omap3_ads7846_init(vo
 	}
 
 	gpio_direction_input(OMAP3_TS_GPIO);
-	omap_set_gpio_debounce(OMAP3_TS_GPIO, 1);
-	omap_set_gpio_debounce_time(OMAP3_TS_GPIO, 0xa);
+	gpio_set_debounce(OMAP3_TS_GPIO, 310);
 }
 
 static struct ads7846_platform_data ads7846_config = {
_

Patches currently in -mm which might be from felipe.balbi@nokia.com are

linux-next.patch
gpiolib-introduce-set_debounce-method.patch
arm-omap-gpio-implement-set_debounce-method.patch
arm-omap-switch-over-to-gpio_set_debounce.patch
arm-omap-remove-the-unused-omap_gpio_set_debounce-methods.patch

