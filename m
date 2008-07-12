From: akpm@linux-foundation.org
Subject: + dev_printk-constify-the-dev-argument.patch added to -mm tree
Date: Fri, 11 Jul 2008 19:21:26 -0700
Message-ID: <200807120221.m6C2LQkV016196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbYGLCVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 22:21:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     dev_printk(): constify the `dev' argument
has been added to the -mm tree.  Its filename is
     dev_printk-constify-the-dev-argument.patch

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
Subject: dev_printk(): constify the `dev' argument
From: Jean Delvare <khali@linux-fr.org>

Add const markings to dev_name and dev_driver_string to make it clear that
dev_printk doesn't modify dev.  This is a prerequisite to adding more
const markings to other functions make it clearer, which functions can
modify dev and which can't.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c    |    2 +-
 include/linux/device.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/base/core.c~dev_printk-constify-the-dev-argument drivers/base/core.c
--- a/drivers/base/core.c~dev_printk-constify-the-dev-argument
+++ a/drivers/base/core.c
@@ -53,7 +53,7 @@ static inline int device_is_not_partitio
  * it is attached to.  If it is not attached to a bus either, an empty
  * string will be returned.
  */
-const char *dev_driver_string(struct device *dev)
+const char *dev_driver_string(const struct device *dev)
 {
 	return dev->driver ? dev->driver->name :
 			(dev->bus ? dev->bus->name :
diff -puN include/linux/device.h~dev_printk-constify-the-dev-argument include/linux/device.h
--- a/include/linux/device.h~dev_printk-constify-the-dev-argument
+++ a/include/linux/device.h
@@ -406,7 +406,7 @@ struct device {
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
-static inline const char *dev_name(struct device *dev)
+static inline const char *dev_name(const struct device *dev)
 {
 	/* will be changed into kobject_name(&dev->kobj) in the near future */
 	return dev->bus_id;
@@ -519,7 +519,7 @@ extern void device_shutdown(void);
 extern void sysdev_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
-extern const char *dev_driver_string(struct device *dev);
+extern const char *dev_driver_string(const struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , \
 	       dev_name(dev) , ## arg)
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
dev_printk-constify-the-dev-argument.patch
i2c-renesas-highlander-fpga-smbus-support.patch
pci-dynidsuse_driver_data-considered-harmful.patch
rtc-convert-the-pcf8583-driver-to-the-new-i2c-style-framework-with-device_ids.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

