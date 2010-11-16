From: akpm@linux-foundation.org
Subject: [merged] leds-update-lp552x-support-kconfig-and-makefile.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:45 -0800
Message-ID: <201011161933.oAGJXvl2003157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145Ab0KPTej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, khali@linux-fr.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: update LP552x support Kconfig and Makefile
has been removed from the -mm tree.  Its filename was
     leds-update-lp552x-support-kconfig-and-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: update LP552x support Kconfig and Makefile
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Provide configuration and compilation support for LP5521 and LP5523

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig  |   18 ++++++++++++++++++
 drivers/leds/Makefile |    2 ++
 2 files changed, 20 insertions(+)

diff -puN drivers/leds/Kconfig~leds-update-lp552x-support-kconfig-and-makefile drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-update-lp552x-support-kconfig-and-makefile
+++ a/drivers/leds/Kconfig
@@ -181,6 +181,24 @@ config LEDS_LP3944
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-lp3944.
 
+config LEDS_LP5521
+	tristate "LED Support for N.S. LP5521 LED driver chip"
+	depends on LEDS_CLASS && I2C
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  LP5521 LED driver. It is 3 channel chip with programmable engines.
+	  Driver provides direct control via LED class and interface for
+	  programming the engines.
+
+config LEDS_LP5523
+	tristate "LED Support for N.S. LP5523 LED driver chip"
+	depends on LEDS_CLASS && I2C
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  LP5523 LED driver. It is 9 channel chip with programmable engines.
+	  Driver provides direct control via LED class and interface for
+	  programming the engines.
+
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
 	depends on X86 && SERIO_I8042 && DMI
diff -puN drivers/leds/Makefile~leds-update-lp552x-support-kconfig-and-makefile drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-update-lp552x-support-kconfig-and-makefile
+++ a/drivers/leds/Makefile
@@ -24,6 +24,8 @@ obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunf
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
+obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
+obj-$(CONFIG_LEDS_LP5523)		+= leds-lp5523.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch
drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch

