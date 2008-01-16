From: akpm@linux-foundation.org
Subject: - hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:26 -0800
Message-ID: <200801160139.m0G1dQuS014005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101AbYAPBtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, dtor@mail.ru, lethal@linux-sh.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     HP6xx/HP7xx: clean up drivers/input/keyboard|touchscreen Kconfigs
has been removed from the -mm tree.  Its filename was
     hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: HP6xx/HP7xx: clean up drivers/input/keyboard|touchscreen Kconfigs
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Clean up the drivers/input/keyboard|touchscreen Kconfigs for platforms
hp6xx and hp7xx.  It unifies the naming and descriptions.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/Kconfig     |   12 ++++++------
 drivers/input/touchscreen/Kconfig  |   10 ++++------
 drivers/input/touchscreen/Makefile |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff -puN drivers/input/keyboard/Kconfig~hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs drivers/input/keyboard/Kconfig
--- a/drivers/input/keyboard/Kconfig~hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs
+++ a/drivers/input/keyboard/Kconfig
@@ -209,22 +209,22 @@ config KEYBOARD_HIL
 	  to your machine, so normally you should say Y here.
 
 config KEYBOARD_HP6XX
-	tristate "HP Jornada 6XX Keyboard support"
+	tristate "HP Jornada 6xx keyboard"
 	depends on SH_HP6XX
 	select INPUT_POLLDEV
 	help
-	  This adds support for the onboard keyboard found on
-	  HP Jornada 620/660/680/690.
+	  Say Y here if you have a HP Jornada 620/660/680/690 and want to
+	  support the built-in keyboard.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called jornada680_kbd.
 
 config KEYBOARD_HP7XX
-	tristate "HP Jornada 7XX Keyboard Driver"
+	tristate "HP Jornada 7xx keyboard"
 	depends on SA1100_JORNADA720_SSP && SA1100_SSP
 	help
-	  Say Y here to add support for the HP Jornada 7xx (710/720/728)
-	  onboard keyboard.
+	  Say Y here if you have a HP Jornada 710/720/728 and want to
+	  support the built-in keyboard.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called jornada720_kbd.
diff -puN drivers/input/touchscreen/Kconfig~hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs
+++ a/drivers/input/touchscreen/Kconfig
@@ -114,20 +114,18 @@ config TOUCHSCREEN_MK712
 	  To compile this driver as a module, choose M here: the
 	  module will be called mk712.
 
-config TOUCHSCREEN_HP600
-	tristate "HP Jornada 680/690 touchscreen"
+config TOUCHSCREEN_HP6XX
+	tristate "HP Jornada 6xx touchscreen"
 	depends on SH_HP6XX && SH_ADC
 	help
-	  Say Y here if you have a HP Jornada 680 or 690 and want to
+	  Say Y here if you have a HP Jornada 620/660/680/690 and want to
           support the built-in touchscreen.
 
-	  If unsure, say N.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called hp680_ts_input.
 
 config TOUCHSCREEN_HP7XX
-	tristate "HP Jornada 710/720/728 touchscreen"
+	tristate "HP Jornada 7xx touchscreen"
 	depends on SA1100_JORNADA720_SSP
 	help
 	  Say Y here if you have a HP Jornada 710/720/728 and want
diff -puN drivers/input/touchscreen/Makefile~hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs drivers/input/touchscreen/Makefile
--- a/drivers/input/touchscreen/Makefile~hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs
+++ a/drivers/input/touchscreen/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
 obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
 obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
-obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
+obj-$(CONFIG_TOUCHSCREEN_HP6XX)		+= hp680_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
 obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

origin.patch
