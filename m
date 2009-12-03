From: akpm@linux-foundation.org
Subject: + ioc3-ioc4-fix-error-path-on-driver-registration.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:58:23 -0800
Message-ID: <200912032258.nB3MwNEI005340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbZLCW60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:58:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, pfg@sgi.com


The patch titled
     ioc3/ioc4: fix error path on driver registration
has been added to the -mm tree.  Its filename is
     ioc3-ioc4-fix-error-path-on-driver-registration.patch

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
Subject: ioc3/ioc4: fix error path on driver registration
From: Jean Delvare <khali@linux-fr.org>

Two IOC3 and IOC4 drivers have broken error paths on registration.  Fix
them.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Pat Gefre <pfg@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/ioc4_serial.c |   16 +++++++++++++---
 drivers/sn/ioc3.c            |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/serial/ioc4_serial.c~ioc3-ioc4-fix-error-path-on-driver-registration drivers/serial/ioc4_serial.c
--- a/drivers/serial/ioc4_serial.c~ioc3-ioc4-fix-error-path-on-driver-registration
+++ a/drivers/serial/ioc4_serial.c
@@ -2913,17 +2913,27 @@ static int __init ioc4_serial_init(void)
 		printk(KERN_WARNING
 			"%s: Couldn't register rs232 IOC4 serial driver\n",
 			__func__);
-		return ret;
+		goto out;
 	}
 	if ((ret = uart_register_driver(&ioc4_uart_rs422)) < 0) {
 		printk(KERN_WARNING
 			"%s: Couldn't register rs422 IOC4 serial driver\n",
 			__func__);
-		return ret;
+		goto out_uart_rs232;
 	}
 
 	/* register with IOC4 main module */
-	return ioc4_register_submodule(&ioc4_serial_submodule);
+	ret = ioc4_register_submodule(&ioc4_serial_submodule);
+	if (ret)
+		goto out_uart_rs422;
+	return 0;
+
+out_uart_rs422:
+	uart_unregister_driver(&ioc4_uart_rs422);
+out_uart_rs232:
+	uart_unregister_driver(&ioc4_uart_rs232);
+out:
+	return ret;
 }
 
 static void __exit ioc4_serial_exit(void)
diff -puN drivers/sn/ioc3.c~ioc3-ioc4-fix-error-path-on-driver-registration drivers/sn/ioc3.c
--- a/drivers/sn/ioc3.c~ioc3-ioc4-fix-error-path-on-driver-registration
+++ a/drivers/sn/ioc3.c
@@ -820,7 +820,7 @@ static int __init ioc3_init(void)
 {
 	if (ia64_platform_is("sn2"))
 		return pci_register_driver(&ioc3_driver);
-	return 0;
+	return -ENODEV;
 }
 
 /* Module unload */
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
ioc3-ioc4-various-section-fixes.patch
ioc3-ioc4-fix-error-path-on-driver-registration.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
hwmon-w83627ehf-updates.patch
k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
resource-constify-arg-to-resource_size-and-resource_type.patch

