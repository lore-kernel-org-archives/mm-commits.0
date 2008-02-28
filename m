From: akpm@linux-foundation.org
Subject: + build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:09:36 -0800
Message-ID: <200802280709.m1S79adk020903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbYB1HS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, jikos@jikos.cz, liam.girdwood@wolfsonmicro.com


The patch titled
     Build system and MAINTAINERS entry for WM97xx touchscreen drivers
has been added to the -mm tree.  Its filename is
     build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Build system and MAINTAINERS entry for WM97xx touchscreen drivers
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |   10 +++++
 drivers/input/touchscreen/Kconfig  |   52 +++++++++++++++++++++++++++
 drivers/input/touchscreen/Makefile |    7 +++
 3 files changed, 69 insertions(+)

diff -puN MAINTAINERS~build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers MAINTAINERS
--- a/MAINTAINERS~build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers
+++ a/MAINTAINERS
@@ -4317,6 +4317,16 @@ L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
 
+WM97XX TOUCHSCREEN DRIVERS
+P:	Mark Brown
+M:	broonie@opensource.wolfsonmicro.com
+P:	Liam Girdwood
+M:	liam.girdwood@wolfsonmicro.com
+L:	linux-input@vger.kernel.org
+T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
+W:	http://opensource.wolfsonmicro.com/node/7
+S:	Supported
+
 X.25 NETWORK LAYER
 P:	Henner Eisen
 M:	eis@baty.hanse.de
diff -puN drivers/input/touchscreen/Kconfig~build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers
+++ a/drivers/input/touchscreen/Kconfig
@@ -158,6 +158,58 @@ config TOUCHSCREEN_TOUCHRIGHT
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchright.
 
+config TOUCHSCREEN_WM97XX
+	tristate "Support for WM97xx AC97 touchscreen controllers"
+	depends on AC97_BUS
+
+config TOUCHSCREEN_WM9705
+	bool "WM9705 Touchscreen interface support"
+	depends on TOUCHSCREEN_WM97XX
+	help
+	  Say Y here if you have a Wolfson Microelectronics WM9705 touchscreen
+	  controller connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm9705.
+
+config TOUCHSCREEN_WM9712
+	bool "WM9712 Touchscreen interface support"
+	depends on TOUCHSCREEN_WM97XX
+	help
+	  Say Y here if you have a Wolfson Microelectronics WM9712 touchscreen
+	  controller connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm9712.
+
+config TOUCHSCREEN_WM9713
+	bool "WM9713 Touchscreen interface support"
+	depends on TOUCHSCREEN_WM97XX
+	help
+	  Say Y here if you have a Wolfson Microelectronics WM9713 touchscreen
+	  controller connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm9713.
+
+config TOUCHSCREEN_WM97XX_MAINSTONE
+	tristate "WM97xx Mainstone accelerated touch"
+	depends on TOUCHSCREEN_WM97XX && ARCH_PXA
+	help
+	  Say Y here for support for streaming mode with WM97xx touchscreens
+	  on Mainstone systems.
+
+	  If unsure, say N
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mainstone-wm97xx
+
 config TOUCHSCREEN_TOUCHWIN
 	tristate "Touchwin serial touchscreen"
 	select SERIO
diff -puN drivers/input/touchscreen/Makefile~build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers drivers/input/touchscreen/Makefile
--- a/drivers/input/touchscreen/Makefile~build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers
+++ a/drivers/input/touchscreen/Makefile
@@ -4,6 +4,8 @@
 
 # Each configuration option enables a list of files.
 
+wm97xx-ts-y := wm97xx-core.o
+
 obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
 obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_CORGI)		+= corgi_ts.o
@@ -19,3 +21,8 @@ obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= pe
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
 obj-$(CONFIG_TOUCHSCREEN_UCB1400)	+= ucb1400_ts.o
+obj-$(CONFIG_TOUCHSCREEN_WM97XX)	+= wm97xx-ts.o
+obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)  += wm9705.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)  += wm9712.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)  += wm9713.o
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa.patch
core-driver-for-wm97xx-touchscreens.patch
add-chip-driver-for-wm9705-touchscreen.patch
add-chip-driver-for-wm9712-touchscreen.patch
add-chip-driver-for-wm9713-touchscreen.patch
driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
