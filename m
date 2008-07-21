From: akpm@linux-foundation.org
Subject: + mmc-add-gpio-based-mmc-sd-driver-v3.patch added to -mm tree
Date: Sun, 20 Jul 2008 18:34:29 -0700
Message-ID: <200807210134.m6L1YTgT010998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314AbYGUBeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 21:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx


The patch titled
     mmc-add-gpio-based-mmc-sd-driver-v3
has been added to the -mm tree.  Its filename is
     mmc-add-gpio-based-mmc-sd-driver-v3.patch

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
Subject: mmc-add-gpio-based-mmc-sd-driver-v3
From: Michael Buesch <mb@bu3sch.de>

Changes since v2: The sysfs interface has been replaced by a configfs
interface.  Although I don't really like the bloat this adds (this is a
driver for embedded machines), I do like the much cleaner interface and
I think it's worth the bloat.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpiommc.txt   |  105 +++---
 drivers/mmc/host/Kconfig    |   14 
 drivers/mmc/host/gpiommc.c  |  556 +++++++++++++++++++++++++---------
 include/linux/mmc/gpiommc.h |   17 -
 4 files changed, 493 insertions(+), 199 deletions(-)

diff -puN Documentation/gpiommc.txt~mmc-add-gpio-based-mmc-sd-driver-v3 Documentation/gpiommc.txt
--- a/Documentation/gpiommc.txt~mmc-add-gpio-based-mmc-sd-driver-v3
+++ a/Documentation/gpiommc.txt
@@ -4,8 +4,8 @@ GPIOMMC - Driver for an MMC/SD card on a
 The gpiommc module hooks up the mmc_spi and spi_gpio modules for running an
 MMC or SD card on GPIO pins.
 
-Two interfaces for registering a new MMC/SD card device are provided.
-A static platform-device based mechanism and a dynamic sysfs based interface.
+Two interfaces for registering a new MMC/SD card device are provided:
+A static platform-device based mechanism and a dynamic configfs based interface.
 
 
 Registering devices via platform-device
@@ -15,7 +15,7 @@ The platform-device interface is used fo
 part of the hardware platform. This is most useful only for embedded machines
 with MMC/SD devices statically connected to the platform GPIO bus.
 
-The data structures are declared in <linux/mmc/gpiommc.h>
+The data structures are declared in <linux/mmc/gpiommc.h>.
 
 To register a new device, define an instance of struct gpiommc_platform_data.
 This structure holds any information about how the device is hooked up to the
@@ -32,65 +32,66 @@ Then add the gpiommc_platform_data to th
 
 	err = platform_device_add_data(pdev, pdata, sizeof(struct gpiommc_platform_data));
 
-You may free the local instance of struct gpiommc_platform_data now.
+You may free the local instance of struct gpiommc_platform_data now. (So the
+struct may be allocated on the stack, too).
 Now simply register the platform device.
 
 	err = platform_device_add(pdev);
 
-Done. The gpiommc probe routine should be called and you should see a dmesg
-message for the added device.
+Done. The gpiommc probe routine will be invoked now and you should see a kernel
+log message for the added device.
 
 
-Registering devices via sysfs
-=============================
+Registering devices via configfs
+================================
 
-MMC/SD cards connected via GPIO often are a pretty dynamic thing. For example
+MMC/SD cards connected via GPIO often are a pretty dynamic thing, as for example
 selfmade hacks for soldering an MMC/SD card to standard GPIO pins on embedded
 hardware are a common situation.
 So we provide a dynamic interface to conveniently handle adding and removing
 devices from userspace, without the need to recompile the kernel.
 
-There are two sysfs files responsible for that:
-export ADD=/sys/bus/platform/drivers/gpiommc/add
-export REMOVE=/sys/bus/platform/drivers/gpiommc/remove
-
-To add a new device, simply echo the configuration string to the "add" file.
-The config string is composed out of the following elements:
-
-DEVNAME DIpin DOpin CLKpin CSpin SPIMODE MAXBUSSPEED NO_SPI_DELAY CSACTIVELOW
-
-DEVNAME is a unique name string for the device.
-DIpin is the SPI DI GPIO pin.
-DOpin is the SPI DO GPIO pin.
-CLKpin is the SPI CLOCK GPIO pin.
-CSpin is the SPI CHIPSELECT GPIO pin.
-SPIMODE is the hardware mode the device will run at. Can be 0-3.
-MAXBUSSPEED is the maximum bus speed in Hertz.
-NO_SPI_DELAY can be 1 or 0. If it is 1, then the lowlevel SPI delay
-will not be performed. This is not standards compliant, but may be required
-to gain reasonable speeds on embedded hardware.
-CSACTIVELOW can be 1 or 0. If it is 1, the chip is considered to be selected, if CS
-is at a logical 0.
-
-Note that the elements SPIMODE, MAXBUSSPEED and NO_SPI_DELAY are optional
-and can be omitted.
-SPIMODE will default to 0.
-MAXBUSSSPEED will default to 5Mhz.
-NO_SPI_DELAY will default to 0.
-CSACTIVELOW will default to 1.
-
-Example:
-
-	echo -n "my_device 5 4 3 7 0 1000000 1" > $ADD
-
-This will add a new device called "my_device" with the GPIO pins assigned as
-DI=5, DO=4, CLK=3, CS=7
-The hardware mode will be SPI_MODE_0.
-The maximum bus speed will be 1000000 Hz (1Mhz)
-And the explicit SPI delay at the lowlevel bitbang loop will be switched off.
+The "gpiommc" subdirectory at the configfs mountpoint is used for handling
+the dynamic configuration.
 
-To remove a device, simply echo the device name string to the "remove" file.
-
-Example:
-
-	echo -n "my_device" > $REMOVE
+To create a new device, it must first be allocated with mkdir.
+The following command will allocate a device named "my_mmc":
+	mkdir /config/gpiommc/my_mmc
+
+There are several configuration files available in the new
+/config/gpiommc/my_mmc/ directory:
+
+gpio_data_in			= The SPI data-IN GPIO pin number.
+gpio_data_out			= The SPI data-OUT GPIO pin number.
+gpio_clock			= The SPI Clock GPIO pin number.
+gpio_chipselect			= The SPI Chipselect GPIO pin number.
+gpio_chipselect_activelow	= Boolean. If 0, Chipselect is active-HIGH.
+				  If 1, Chipselect is active-LOW.
+spi_mode			= The SPI data mode. Can be 0-3.
+spi_delay			= Enable all delays in the lowlevel bitbanging.
+max_bus_speed			= The maximum SPI bus speed. In Hertz.
+
+register			= Not a configuration parameter.
+				  Used to register the configured card
+				  with the kernel.
+
+The device must first get configured and then registered by writing "1" to
+the "register" file.
+The configuration parameters "gpio_data_in", "gpio_data_out", "gpio_clock"
+and "gpio_chipselect" are essential and _must_ be configured before writing
+"1" to the "register" file. The registration will fail, otherwise.
+
+The default values for the other parameters are:
+gpio_chipselect_activelow	= 1		(CS active-LOW)
+spi_mode			= 0		(SPI_MODE_0)
+spi_delay			= 1		(enabled)
+max_bus_speed			= 5000000	(5 Mhz)
+
+Configuration values can not be changed after registration. To unregister
+the device, write a "0" to the "register" file. The configuration can be
+changed again after unregistering.
+
+To completely remove the device, simply rmdir the directory
+(/config/gpiommc/my_mmc in this example).
+There's no need to first unregister the device before removing it. That will
+be done automatically.
diff -puN drivers/mmc/host/Kconfig~mmc-add-gpio-based-mmc-sd-driver-v3 drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-add-gpio-based-mmc-sd-driver-v3
+++ a/drivers/mmc/host/Kconfig
@@ -182,8 +182,8 @@ config GPIOMMC
 	  MMC/SD cards can be used on a GPIO based bus by bitbanging
 	  the SPI protocol in software.
 
-	  This driver provides a sysfs interface to dynamically create
-	  and destroy GPIO-based MMC/SD card interfaces. It also provides
+	  This driver provides a configfs interface to dynamically create
+	  and destroy GPIO-based MMC/SD card devices. It also provides
 	  a platform device interface API.
 	  See Documentation/gpiommc.txt for details.
 
@@ -191,6 +191,10 @@ config GPIOMMC
 
 	  If unsure, say N.
 
-config MMC_S3C
-	tristate "Samsung S3C SD/MMC Card Interface support"
-	depends on ARCH_S3C2410 && MMC
+config GPIOMMC_CONFIGFS
+	bool
+	depends on GPIOMMC && CONFIGFS_FS
+	default y
+	help
+	  This option automatically enables configfs support for gpiommc
+	  if configfs is available.
diff -puN drivers/mmc/host/gpiommc.c~mmc-add-gpio-based-mmc-sd-driver-v3 drivers/mmc/host/gpiommc.c
--- a/drivers/mmc/host/gpiommc.c~mmc-add-gpio-based-mmc-sd-driver-v3
+++ a/drivers/mmc/host/gpiommc.c
@@ -1,7 +1,7 @@
 /*
  * Driver an MMC/SD card on a bitbanging GPIO SPI bus.
  * This module hooks up the mmc_spi and spi_gpio modules and also
- * provides a sysfs interface.
+ * provides a configfs interface.
  *
  * Copyright 2008 Michael Buesch <mb@bu3sch.de>
  *
@@ -13,10 +13,13 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spi/spi_gpio.h>
+#include <linux/configfs.h>
+#include <linux/gpio.h>
+#include <asm/atomic.h>
 
 
 #define PFX				"gpio-mmc: "
-#define GPIOMMC_MAX_NAMELEN_STR		__stringify(GPIOMMC_MAX_NAMELEN)
+
 
 struct gpiommc_device {
 	struct platform_device *pdev;
@@ -58,6 +61,14 @@ static int gpiommc_probe(struct platform
 	if (!mmc_pdata)
 		goto error;
 
+#ifdef CONFIG_MMC_SPI_MODULE
+	err = request_module("mmc_spi");
+	if (err) {
+		printk(KERN_WARNING PFX
+		       "Failed to request mmc_spi module.\n");
+	}
+#endif /* CONFIG_MMC_SPI_MODULE */
+
 	/* Allocate the GPIO-MMC device */
 	err = -ENOMEM;
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
@@ -116,152 +127,438 @@ static int gpiommc_remove(struct platfor
 	struct gpiommc_platform_data *pdata = d->pdev->dev.platform_data;
 
 	platform_device_unregister(d->spi_pdev);
-	printk(KERN_INFO PFX "GPIO based MMC-Card \"%s\" removed\n", pdata->name);
+	printk(KERN_INFO PFX "GPIO based MMC-Card \"%s\" removed\n",
+	       pdata->name);
 	platform_device_put(d->spi_pdev);
 
 	return 0;
 }
 
-/* Wrapper for the platform data with context data for the sysfs interface. */
-struct gpiommc_sysfs_platform_data {
-	struct gpiommc_platform_data p; /* Keep as first element */
+#ifdef CONFIG_GPIOMMC_CONFIGFS
 
-	/* The platform device that we allocated. */
+/* A device that was created through configfs */
+struct gpiommc_configfs_device {
+	struct config_item item;
+	/* The platform device, after registration. */
 	struct platform_device *pdev;
-	/* gpiommc_sysfs_list */
-	struct list_head list;
+	/* The configuration */
+	struct gpiommc_platform_data pdata;
 };
 
-static LIST_HEAD(gpiommc_sysfs_list);
-static DEFINE_MUTEX(gpiommc_sysfs_mutex);
+#define GPIO_INVALID	-1
+
+static inline bool gpiommc_is_registered(struct gpiommc_configfs_device *dev)
+{
+	return (dev->pdev != NULL);
+}
 
-static struct gpiommc_sysfs_platform_data *gpiommc_sysfs_find_dev(const char *name)
+static inline struct gpiommc_configfs_device *ci_to_gpiommc(struct config_item *item)
 {
-	struct gpiommc_sysfs_platform_data *pdata;
+	return item ? container_of(item, struct gpiommc_configfs_device, item) : NULL;
+}
 
-	list_for_each_entry(pdata, &gpiommc_sysfs_list, list) {
-		if (strcmp(pdata->p.name, name) == 0)
-			return pdata;
-	}
+static struct configfs_attribute gpiommc_attr_DI = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "gpio_data_in",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_DO = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "gpio_data_out",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_CLK = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "gpio_clock",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_CS = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "gpio_chipselect",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
 
-	return NULL;
+static struct configfs_attribute gpiommc_attr_CS_activelow = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "gpio_chipselect_activelow",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_spimode = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "spi_mode",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_spidelay = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "spi_delay",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_max_bus_speed = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "max_bus_speed",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute gpiommc_attr_register = {
+	.ca_owner = THIS_MODULE,
+	.ca_name = "register",
+	.ca_mode = S_IRUGO | S_IWUSR,
+};
+
+static struct configfs_attribute *gpiommc_config_attrs[] = {
+	&gpiommc_attr_DI,
+	&gpiommc_attr_DO,
+	&gpiommc_attr_CLK,
+	&gpiommc_attr_CS,
+	&gpiommc_attr_CS_activelow,
+	&gpiommc_attr_spimode,
+	&gpiommc_attr_spidelay,
+	&gpiommc_attr_max_bus_speed,
+	&gpiommc_attr_register,
+	NULL,
+};
+
+static ssize_t gpiommc_config_attr_show(struct config_item *item,
+					struct configfs_attribute *attr,
+					char *page)
+{
+	struct gpiommc_configfs_device *dev = ci_to_gpiommc(item);
+	ssize_t count = 0;
+	unsigned int gpio;
+	int err = 0;
+
+	if (attr == &gpiommc_attr_DI) {
+		gpio = dev->pdata.pins.gpio_di;
+		if (gpio == GPIO_INVALID)
+			count = snprintf(page, PAGE_SIZE, "not configured\n");
+		else
+			count = snprintf(page, PAGE_SIZE, "%u\n", gpio);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_DO) {
+		gpio = dev->pdata.pins.gpio_do;
+		if (gpio == GPIO_INVALID)
+			count = snprintf(page, PAGE_SIZE, "not configured\n");
+		else
+			count = snprintf(page, PAGE_SIZE, "%u\n", gpio);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_CLK) {
+		gpio = dev->pdata.pins.gpio_clk;
+		if (gpio == GPIO_INVALID)
+			count = snprintf(page, PAGE_SIZE, "not configured\n");
+		else
+			count = snprintf(page, PAGE_SIZE, "%u\n", gpio);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_CS) {
+		gpio = dev->pdata.pins.gpio_cs;
+		if (gpio == GPIO_INVALID)
+			count = snprintf(page, PAGE_SIZE, "not configured\n");
+		else
+			count = snprintf(page, PAGE_SIZE, "%u\n", gpio);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_CS_activelow) {
+		count = snprintf(page, PAGE_SIZE, "%u\n",
+				 dev->pdata.pins.cs_activelow);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_spimode) {
+		count = snprintf(page, PAGE_SIZE, "%u\n",
+				 dev->pdata.mode);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_spidelay) {
+		count = snprintf(page, PAGE_SIZE, "%u\n",
+				 !dev->pdata.no_spi_delay);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_max_bus_speed) {
+		count = snprintf(page, PAGE_SIZE, "%u\n",
+				 dev->pdata.max_bus_speed);
+		goto out;
+	}
+	if (attr == &gpiommc_attr_register) {
+		count = snprintf(page, PAGE_SIZE, "%u\n",
+				 gpiommc_is_registered(dev));
+		goto out;
+	}
+	WARN_ON(1);
+	err = -ENOSYS;
+out:
+	return err ? err : count;
 }
 
-static ssize_t gpiommc_add_store(struct device_driver *drv,
-				 const char *buf, size_t count)
+static int gpiommc_do_register(struct gpiommc_configfs_device *dev,
+			       const char *name)
 {
-	int res, err;
-	struct gpiommc_sysfs_platform_data pdata_local, *pdata;
-	struct platform_device *pdev;
-	unsigned int no_spi_delay = 0, mode = 0, csactivelow = 0;
+	int err;
 
-	mutex_lock(&gpiommc_sysfs_mutex);
+	if (gpiommc_is_registered(dev))
+		return 0;
 
-	pdata = &pdata_local;
-	memset(pdata, 0, sizeof(*pdata));
+	if (!gpio_is_valid(dev->pdata.pins.gpio_di) ||
+	    !gpio_is_valid(dev->pdata.pins.gpio_do) ||
+	    !gpio_is_valid(dev->pdata.pins.gpio_clk) ||
+	    !gpio_is_valid(dev->pdata.pins.gpio_cs)) {
+		printk(KERN_ERR PFX
+		       "configfs: Invalid GPIO pin number(s)\n");
+		return -EINVAL;
+	}
+
+	strlcpy(dev->pdata.name, name,
+		sizeof(dev->pdata.name));
 
-	err = -EINVAL;
-	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u %u %u %u %u %u %u %u",
-		     pdata->p.name,
-		     &pdata->p.pins.gpio_di,
-		     &pdata->p.pins.gpio_do,
-		     &pdata->p.pins.gpio_clk,
-		     &pdata->p.pins.gpio_cs,
-		     &mode,
-		     &pdata->p.max_bus_speed,
-		     &no_spi_delay,
-		     &csactivelow);
-	pdata->p.mode = mode;
-	pdata->p.no_spi_delay = !!no_spi_delay;
-	pdata->p.pins.cs_activelow = !!csactivelow;
-	if (res < 9)
-		pdata->p.pins.cs_activelow = 1; /* Default: CS = activelow */
-	if (res < 8)
-		pdata->p.no_spi_delay = 0; /* Default: Delay turned on */
-	if (res < 7)
-		pdata->p.max_bus_speed = 5000000; /* Default: 5Mhz */
-	if (res < 6)
-		pdata->p.mode = 0; /* Default: SPI mode 0 */
-	if (res < 5 || res > 9)
-		goto out; /* First 5 args are mandatory. */
-
-	/* Convert mode so that the SPI subsystem does understand it. */
-	switch (pdata->p.mode) {
-	case 0:
-		pdata->p.mode = SPI_MODE_0;
-		break;
-	case 1:
-		pdata->p.mode = SPI_MODE_1;
-		break;
-	case 2:
-		pdata->p.mode = SPI_MODE_2;
-		break;
-	case 3:
-		pdata->p.mode = SPI_MODE_3;
-		break;
-	default:
-		goto out; /* Invalid mode */
+	dev->pdev = platform_device_alloc(GPIOMMC_PLATDEV_NAME,
+					  gpiommc_next_id());
+	if (!dev->pdev)
+		return -ENOMEM;
+	err = platform_device_add_data(dev->pdev, &dev->pdata,
+				       sizeof(dev->pdata));
+	if (err) {
+		platform_device_put(dev->pdev);
+		return err;
+	}
+	err = platform_device_add(dev->pdev);
+	if (err) {
+		platform_device_put(dev->pdev);
+		return err;
 	}
 
-	err = -EEXIST;
-	if (gpiommc_sysfs_find_dev(pdata->p.name))
-		goto out;
+	return 0;
+}
 
-	err = -ENOMEM;
-	pdev = platform_device_alloc(GPIOMMC_PLATDEV_NAME, gpiommc_next_id());
-	if (!pdev)
-		goto out;
+static void gpiommc_do_unregister(struct gpiommc_configfs_device *dev)
+{
+	if (!gpiommc_is_registered(dev))
+		return;
 
-	err = platform_device_add_data(pdev, pdata, sizeof(*pdata));
-	if (err)
-		goto err_free_pdev;
-	pdata = pdev->dev.platform_data;
+	platform_device_unregister(dev->pdev);
+	dev->pdev = NULL;
+}
 
-	err = platform_device_add(pdev);
-	if (err)
-		goto err_free_pdev;
+static ssize_t gpiommc_config_attr_store(struct config_item *item,
+					 struct configfs_attribute *attr,
+					 const char *page, size_t count)
+{
+	struct gpiommc_configfs_device *dev = ci_to_gpiommc(item);
+	int err = -EINVAL;
+	unsigned long data;
+
+	if (attr == &gpiommc_attr_register) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (data == 1)
+			err = gpiommc_do_register(dev, item->ci_name);
+		if (data == 0) {
+			gpiommc_do_unregister(dev);
+			err = 0;
+		}
+		goto out;
+	}
 
-	pdata->pdev = pdev;
-	INIT_LIST_HEAD(&pdata->list);
-	list_add(&pdata->list, &gpiommc_sysfs_list);
+	if (gpiommc_is_registered(dev)) {
+		/* The rest of the config parameters can only be set
+		 * as long as the device is not registered, yet. */
+		err = -EBUSY;
+		goto out;
+	}
 
-	err = 0;
+	if (attr == &gpiommc_attr_DI) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (!gpio_is_valid(data))
+			goto out;
+		dev->pdata.pins.gpio_di = data;
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_DO) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (!gpio_is_valid(data))
+			goto out;
+		dev->pdata.pins.gpio_do = data;
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_CLK) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (!gpio_is_valid(data))
+			goto out;
+		dev->pdata.pins.gpio_clk = data;
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_CS) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (!gpio_is_valid(data))
+			goto out;
+		dev->pdata.pins.gpio_cs = data;
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_CS_activelow) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (data != 0 && data != 1)
+			goto out;
+		dev->pdata.pins.cs_activelow = data;
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_spimode) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		switch (data) {
+		case 0:
+			dev->pdata.mode = SPI_MODE_0;
+			break;
+		case 1:
+			dev->pdata.mode = SPI_MODE_1;
+			break;
+		case 2:
+			dev->pdata.mode = SPI_MODE_2;
+			break;
+		case 3:
+			dev->pdata.mode = SPI_MODE_3;
+			break;
+		default:
+			goto out;
+		}
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_spidelay) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (data != 0 && data != 1)
+			goto out;
+		dev->pdata.no_spi_delay = !data;
+		err = 0;
+		goto out;
+	}
+	if (attr == &gpiommc_attr_max_bus_speed) {
+		err = strict_strtoul(page, 10, &data);
+		if (err)
+			goto out;
+		err = -EINVAL;
+		if (data > UINT_MAX)
+			goto out;
+		dev->pdata.max_bus_speed = data;
+		err = 0;
+		goto out;
+	}
+	WARN_ON(1);
+	err = -ENOSYS;
 out:
-	mutex_unlock(&gpiommc_sysfs_mutex);
-
 	return err ? err : count;
+}
 
-err_free_pdev:
-	platform_device_put(pdev);
-	goto out;
+static void gpiommc_config_item_release(struct config_item *item)
+{
+	struct gpiommc_configfs_device *dev = ci_to_gpiommc(item);
+
+	kfree(dev);
 }
 
-static ssize_t gpiommc_remove_store(struct device_driver *drv,
-				    const char *buf, size_t count)
+static struct configfs_item_operations gpiommc_config_item_ops = {
+	.release		= gpiommc_config_item_release,
+	.show_attribute		= gpiommc_config_attr_show,
+	.store_attribute	= gpiommc_config_attr_store,
+};
+
+static struct config_item_type gpiommc_dev_ci_type = {
+	.ct_item_ops	= &gpiommc_config_item_ops,
+	.ct_attrs	= gpiommc_config_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct config_item *gpiommc_make_item(struct config_group *group,
+					     const char *name)
 {
-	struct gpiommc_sysfs_platform_data *pdata;
-	int err;
+	struct gpiommc_configfs_device *dev;
 
-	mutex_lock(&gpiommc_sysfs_mutex);
+	if (strlen(name) > GPIOMMC_MAX_NAMELEN) {
+		printk(KERN_ERR PFX "configfs: device name too long\n");
+		return NULL;
+	}
 
-	err = -ENODEV;
-	pdata = gpiommc_sysfs_find_dev(buf);
-	if (!pdata)
-		goto out;
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	config_item_init_type_name(&dev->item, name,
+				   &gpiommc_dev_ci_type);
+
+	/* Assign default configuration */
+	dev->pdata.pins.gpio_di = GPIO_INVALID;
+	dev->pdata.pins.gpio_do = GPIO_INVALID;
+	dev->pdata.pins.gpio_clk = GPIO_INVALID;
+	dev->pdata.pins.gpio_cs = GPIO_INVALID;
+	dev->pdata.pins.cs_activelow = 1;
+	dev->pdata.mode = SPI_MODE_0;
+	dev->pdata.no_spi_delay = 0;
+	dev->pdata.max_bus_speed = 5000000; /* 5 MHz */
 
-	list_del(&pdata->list);
-	platform_device_unregister(pdata->pdev);
+	return &(dev->item);
+}
 
-out:
-	mutex_unlock(&gpiommc_sysfs_mutex);
+static void gpiommc_drop_item(struct config_group *group,
+			      struct config_item *item)
+{
+	struct gpiommc_configfs_device *dev = ci_to_gpiommc(item);
 
-	return err ? err : count;
+	gpiommc_do_unregister(dev);
+	kfree(dev);
 }
 
-static DRIVER_ATTR(add, 0200,
-		   NULL, gpiommc_add_store);
-static DRIVER_ATTR(remove, 0200,
-		   NULL, gpiommc_remove_store);
+static struct configfs_group_operations gpiommc_ct_group_ops = {
+	.make_item	= gpiommc_make_item,
+	.drop_item	= gpiommc_drop_item,
+};
+
+static struct config_item_type gpiommc_ci_type = {
+	.ct_group_ops	= &gpiommc_ct_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct configfs_subsystem gpiommc_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = GPIOMMC_PLATDEV_NAME,
+			.ci_type = &gpiommc_ci_type,
+		},
+	},
+	.su_mutex = __MUTEX_INITIALIZER(gpiommc_subsys.su_mutex),
+};
+
+#endif /* CONFIG_GPIOMMC_CONFIGFS */
 
 static struct platform_driver gpiommc_plat_driver = {
 	.probe	= gpiommc_probe,
@@ -287,42 +584,25 @@ static int __init gpiommc_modinit(void)
 	err = platform_driver_register(&gpiommc_plat_driver);
 	if (err)
 		return err;
-	err = driver_create_file(&gpiommc_plat_driver.driver,
-				 &driver_attr_add);
-	if (err)
-		goto err_drv_unreg;
-	err = driver_create_file(&gpiommc_plat_driver.driver,
-				 &driver_attr_remove);
-	if (err)
-		goto err_remove_add;
 
-	return 0;
+#ifdef CONFIG_GPIOMMC_CONFIGFS
+	config_group_init(&gpiommc_subsys.su_group);
+	err = configfs_register_subsystem(&gpiommc_subsys);
+	if (err) {
+		platform_driver_unregister(&gpiommc_plat_driver);
+		return err;
+	}
+#endif /* CONFIG_GPIOMMC_CONFIGFS */
 
-err_remove_add:
-	driver_remove_file(&gpiommc_plat_driver.driver,
-			   &driver_attr_add);
-err_drv_unreg:
-	platform_driver_unregister(&gpiommc_plat_driver);
-	return err;
+	return 0;
 }
 module_init(gpiommc_modinit);
 
 static void __exit gpiommc_modexit(void)
 {
-	struct gpiommc_sysfs_platform_data *pdata, *pdata_tmp;
-
-	driver_remove_file(&gpiommc_plat_driver.driver,
-			   &driver_attr_remove);
-	driver_remove_file(&gpiommc_plat_driver.driver,
-			   &driver_attr_add);
-
-	mutex_lock(&gpiommc_sysfs_mutex);
-	list_for_each_entry_safe(pdata, pdata_tmp, &gpiommc_sysfs_list, list) {
-		list_del(&pdata->list);
-		platform_device_unregister(pdata->pdev);
-	}
-	mutex_unlock(&gpiommc_sysfs_mutex);
-
+#ifdef CONFIG_GPIOMMC_CONFIGFS
+	configfs_unregister_subsystem(&gpiommc_subsys);
+#endif
 	platform_driver_unregister(&gpiommc_plat_driver);
 }
 module_exit(gpiommc_modexit);
diff -puN include/linux/mmc/gpiommc.h~mmc-add-gpio-based-mmc-sd-driver-v3 include/linux/mmc/gpiommc.h
--- a/include/linux/mmc/gpiommc.h~mmc-add-gpio-based-mmc-sd-driver-v3
+++ a/include/linux/mmc/gpiommc.h
@@ -12,8 +12,11 @@
 
 
 #define GPIOMMC_MAX_NAMELEN		15
+#define GPIOMMC_MAX_NAMELEN_STR		__stringify(GPIOMMC_MAX_NAMELEN)
 
-/** struct gpiommc_pins - Hardware pin assignments
+/**
+ * struct gpiommc_pins - Hardware pin assignments
+ *
  * @gpio_di: The GPIO number of the DATA IN pin
  * @gpio_do: The GPIO number of the DATA OUT pin
  * @gpio_clk: The GPIO number of the CLOCK pin
@@ -28,7 +31,9 @@ struct gpiommc_pins {
 	bool cs_activelow;
 };
 
-/** struct gpiommc_platform_data - Platform data for a MMC-over-SPI-GPIO device.
+/**
+ * struct gpiommc_platform_data - Platform data for a MMC-over-SPI-GPIO device.
+ *
  * @name: The unique name string of the device.
  * @pins: The hardware pin assignments.
  * @mode: The hardware mode. This is either SPI_MODE_0,
@@ -46,13 +51,17 @@ struct gpiommc_platform_data {
 	unsigned int max_bus_speed;
 };
 
-/** GPIOMMC_PLATDEV_NAME - The platform device name string.
+/**
+ * GPIOMMC_PLATDEV_NAME - The platform device name string.
+ *
  * The name string that has to be used for platform_device_alloc
  * when allocating a gpiommc device.
  */
 #define GPIOMMC_PLATDEV_NAME	"gpiommc"
 
-/** gpiommc_next_id - Get another platform device ID number.
+/**
+ * gpiommc_next_id - Get another platform device ID number.
+ *
  * This returns the next platform device ID number that has to be used
  * for platform_device_alloc. The ID is opaque and should not be used for
  * anything else.
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
linux-next.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch

