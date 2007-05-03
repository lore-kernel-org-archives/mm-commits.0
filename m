From: akpm@linux-foundation.org
Subject: + spi-kerneldoc-fix.patch added to -mm tree
Date: Thu, 03 May 2007 00:06:58 -0700
Message-ID: <200705030706.l4376w0I006900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161105AbXECHHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 03:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, rdunlap@xenotime.net


The patch titled
     spi-kerneldoc fix
has been added to the -mm tree.  Its filename is
     spi-kerneldoc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi-kerneldoc fix
From: David Brownell <david-b@pacbell.net>

Address some comments from Randy Dunlap; add kerneldoc for
driver register/unregister functions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    2 +-
 drivers/spi/spi.c                     |    7 +++++++
 include/linux/spi/spi.h               |   21 +++++++++++++--------
 3 files changed, 21 insertions(+), 9 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~spi-kerneldoc-fix Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~spi-kerneldoc-fix
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -636,7 +636,7 @@ X!Idrivers/video/console/fonts.c
 	objects, each of which wraps a full duplex SPI transfer.
 	A variety of protocol tweaking options are needed, because
 	different chips adopt very different policies for how they
-	use the bits tranferred with SPI.
+	use the bits transferred with SPI.
   </para>
 !Iinclude/linux/spi/spi.h
 !Fdrivers/spi/spi.c spi_register_board_info
diff -puN drivers/spi/spi.c~spi-kerneldoc-fix drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-kerneldoc-fix
+++ a/drivers/spi/spi.c
@@ -152,6 +152,11 @@ static void spi_drv_shutdown(struct devi
 	sdrv->shutdown(to_spi_device(dev));
 }
 
+/**
+ * spi_register_driver - register a SPI driver
+ * @sdrv: the driver to register
+ * Context: can sleep
+ */
 int spi_register_driver(struct spi_driver *sdrv)
 {
 	sdrv->driver.bus = &spi_bus_type;
@@ -187,6 +192,7 @@ static DECLARE_MUTEX(board_lock);
  * spi_new_device - instantiate one new SPI device
  * @master: Controller to which device is connected
  * @chip: Describes the SPI device
+ * Context: can sleep
  *
  * On typical mainboards, this is purely internal; and it's not needed
  * after board init creates the hard-wired devices.  Some development
@@ -260,6 +266,7 @@ EXPORT_SYMBOL_GPL(spi_new_device);
  * spi_register_board_info - register SPI devices for a given board
  * @info: array of chip descriptors
  * @n: how many descriptors are provided
+ * Context: can sleep
  *
  * Board-specific early init code calls this (probably during arch_initcall)
  * with segments of the SPI device table.  Any device nodes are created later,
diff -puN include/linux/spi/spi.h~spi-kerneldoc-fix include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-kerneldoc-fix
+++ a/include/linux/spi/spi.h
@@ -83,14 +83,14 @@ struct spi_device {
 	const char		*modalias;
 
 	/*
-	// likely need more hooks for more protocol options affecting how
-	// the controller talks to each chip, like:
-	//  - memory packing (12 bit samples into low bits, others zeroed)
-	//  - priority
-	//  - drop chipselect after each word
-	//  - chipselect delays
-	//  - ...
-	*/
+	 * likely need more hooks for more protocol options affecting how
+	 * the controller talks to each chip, like:
+	 *  - memory packing (12 bit samples into low bits, others zeroed)
+	 *  - priority
+	 *  - drop chipselect after each word
+	 *  - chipselect delays
+	 *  - ...
+	 */
 };
 
 static inline struct spi_device *to_spi_device(struct device *dev)
@@ -153,6 +153,11 @@ static inline struct spi_driver *to_spi_
 
 extern int spi_register_driver(struct spi_driver *sdrv);
 
+/**
+ * spi_unregister_driver - reverse effect of spi_register_driver
+ * @sdrv: the driver to unregister
+ * Context: can sleep
+ */
 static inline void spi_unregister_driver(struct spi_driver *sdrv)
 {
 	if (sdrv)
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
at91_cf-minor-fix.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
spi-kerneldoc.patch
spi-kerneldoc-fix.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
