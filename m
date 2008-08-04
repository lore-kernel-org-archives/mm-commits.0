From: akpm@linux-foundation.org
Subject: - dev_printk-constify-the-dev-argument.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:17 -0700
Message-ID: <200808042006.m74K6HOR027671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbYHDUG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     dev_printk(): constify the `dev' argument
has been removed from the -mm tree.  Its filename was
     dev_printk-constify-the-dev-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -517,7 +517,7 @@ extern void device_shutdown(void);
 extern void sysdev_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
-extern const char *dev_driver_string(struct device *dev);
+extern const char *dev_driver_string(const struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , \
 	       dev_name(dev) , ## arg)
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch
radeonfb-give-i2c-buses-nicer-names.patch
applesmc-support-for-intel-imac.patch
applesmc-add-support-for-macbook-v3.patch
hwmon-adc124s501-generic-driver.patch
hwmon-adc124s501-generic-driver-update.patch
i5k_amb-provide-labels-for-temperature-sensors.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

