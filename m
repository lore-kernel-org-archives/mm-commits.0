From: akpm@linux-foundation.org
Subject: + misc-update-apds990x-driver-to-kconfig-and-makefile.patch added to -mm tree
Date: Tue, 19 Oct 2010 16:21:00 -0700
Message-ID: <201010192321.o9JNL0iQ012483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0JSXVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 19:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, jic23@cam.ac.uk


The patch titled
     drivers/misc: update apds990x driver to Kconfig and Makefile
has been added to the -mm tree.  Its filename is
     misc-update-apds990x-driver-to-kconfig-and-makefile.patch

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
Subject: drivers/misc: update apds990x driver to Kconfig and Makefile
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Compilation support for apds990x driver

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig  |   11 +++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 12 insertions(+)

diff -puN drivers/misc/Kconfig~misc-update-apds990x-driver-to-kconfig-and-makefile drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-update-apds990x-driver-to-kconfig-and-makefile
+++ a/drivers/misc/Kconfig
@@ -334,6 +334,17 @@ config SENSORS_BH1770
            To compile this driver as a module, choose M here: the
            module will be called bh1770glc. If unsure, say N here.
 
+config SENSORS_APDS990X
+	 tristate "APDS990X combined als and proximity sensors"
+	 depends on I2C
+	 default n
+	 ---help---
+	   Say Y here if you want to build a driver for Avago APDS990x
+	   combined ambient light and proximity sensor chip.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called apds990x. If unsure, say N here.
+
 config HMC6352
 	tristate "Honeywell HMC6352 compass"
 	depends on I2C
diff -puN drivers/misc/Makefile~misc-update-apds990x-driver-to-kconfig-and-makefile drivers/misc/Makefile
--- a/drivers/misc/Makefile~misc-update-apds990x-driver-to-kconfig-and-makefile
+++ a/drivers/misc/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
 obj-$(CONFIG_SENSORS_BH1770)	+= bh1770glc.o
+obj-$(CONFIG_SENSORS_APDS990X)	+= apds990x.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

linux-next.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch
misc-driver-for-bh1770glc-sfh7770-als-and-proximity-sensor.patch
misc-update-bh1770glc-driver-to-kconfig-and-makefile.patch
misc-driver-for-apds990x-als-and-proximity-sensors.patch
misc-update-apds990x-driver-to-kconfig-and-makefile.patch
documentation-short-descriptions-for-bh1770glc-and-apds990x-drivers.patch

