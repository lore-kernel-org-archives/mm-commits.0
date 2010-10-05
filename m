From: akpm@linux-foundation.org
Subject: + leds-update-lp552x-support-kconfig-and-makefile.patch added to -mm tree
Date: Tue, 05 Oct 2010 15:03:40 -0700
Message-ID: <201010052203.o95M3eAm022804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab0JEWEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 18:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, khali@linux-fr.org, rpurdie@rpsys.net


The patch titled
     leds: update LP552x support Kconfig and Makefile
has been added to the -mm tree.  Its filename is
     leds-update-lp552x-support-kconfig-and-makefile.patch

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

linux-next.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch

