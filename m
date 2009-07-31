From: akpm@linux-foundation.org
Subject: + spi-add-support-for-device-table-matching.patch added to -mm tree
Date: Fri, 31 Jul 2009 13:49:57 -0700
Message-ID: <200907312049.n6VKnvcC000638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbZGaUvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 16:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     spi: add support for device table matching
has been added to the -mm tree.  Its filename is
     spi-add-support-for-device-table-matching.patch

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
Subject: spi: add support for device table matching
From: Anton Vorontsov <avorontsov@ru.mvista.com>

With this patch spi drivers can use standard spi_driver.id_table and
MODULE_DEVICE_TABLE() mechanisms to bind against the devices.  Just like
we do with I2C drivers.

This is useful when a single driver supports several variants of devices
but it is not possible to detect them in run-time (like non-JEDEC chips
probing in drivers/mtd/devices/m25p80.c), and when platform_data usage is
overkill.

This patch also makes life a lot easier on OpenFirmware platforms, since
with OF we extensively use proper device IDs in modaliases.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c               |   23 +++++++++++++++++++++++
 include/linux/mod_devicetable.h |   10 ++++++++++
 include/linux/spi/spi.h         |   10 ++++++++--
 scripts/mod/file2alias.c        |   13 +++++++++++++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spi-add-support-for-device-table-matching drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-add-support-for-device-table-matching
+++ a/drivers/spi/spi.c
@@ -59,9 +59,32 @@ static struct device_attribute spi_dev_a
  * and the sysfs version makes coldplug work too.
  */
 
+static const struct spi_device_id *spi_match_id(const struct spi_device_id *id,
+						const struct spi_device *sdev)
+{
+	while (id->name[0]) {
+		if (!strcmp(sdev->modalias, id->name))
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
+const struct spi_device_id *spi_get_device_id(const struct spi_device *sdev)
+{
+	const struct spi_driver *sdrv = to_spi_driver(sdev->dev.driver);
+
+	return spi_match_id(sdrv->id_table, sdev);
+}
+EXPORT_SYMBOL_GPL(spi_get_device_id);
+
 static int spi_match_device(struct device *dev, struct device_driver *drv)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
+	const struct spi_driver	*sdrv = to_spi_driver(drv);
+
+	if (sdrv->id_table)
+		return !!spi_match_id(sdrv->id_table, spi);
 
 	return strcmp(spi->modalias, drv->name) == 0;
 }
diff -puN include/linux/mod_devicetable.h~spi-add-support-for-device-table-matching include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~spi-add-support-for-device-table-matching
+++ a/include/linux/mod_devicetable.h
@@ -399,6 +399,16 @@ struct i2c_device_id {
 			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
+/* spi */
+
+#define SPI_NAME_SIZE	32
+
+struct spi_device_id {
+	char name[SPI_NAME_SIZE];
+	kernel_ulong_t driver_data	/* Data private to the driver */
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+
 /* dmi */
 enum dmi_field {
 	DMI_NONE,
diff -puN include/linux/spi/spi.h~spi-add-support-for-device-table-matching include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-add-support-for-device-table-matching
+++ a/include/linux/spi/spi.h
@@ -20,6 +20,7 @@
 #define __LINUX_SPI_H
 
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 
 /*
  * INTERFACES between SPI master-side drivers and SPI infrastructure.
@@ -86,7 +87,7 @@ struct spi_device {
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
-	char			modalias[32];
+	char			modalias[SPI_NAME_SIZE];
 
 	/*
 	 * likely need more hooks for more protocol options affecting how
@@ -145,6 +146,7 @@ struct spi_message;
 
 /**
  * struct spi_driver - Host side "protocol" driver
+ * @id_table: List of SPI devices supported by this driver
  * @probe: Binds this driver to the spi device.  Drivers can verify
  *	that the device is actually present, and may need to configure
  *	characteristics (such as bits_per_word) which weren't needed for
@@ -170,6 +172,7 @@ struct spi_message;
  * MMC, RTC, filesystem character device nodes, and hardware monitoring.
  */
 struct spi_driver {
+	const struct spi_device_id *id_table;
 	int			(*probe)(struct spi_device *spi);
 	int			(*remove)(struct spi_device *spi);
 	void			(*shutdown)(struct spi_device *spi);
@@ -734,7 +737,7 @@ struct spi_board_info {
 	 * controller_data goes to spi_device.controller_data,
 	 * irq is copied too
 	 */
-	char		modalias[32];
+	char		modalias[SPI_NAME_SIZE];
 	const void	*platform_data;
 	void		*controller_data;
 	int		irq;
@@ -802,4 +805,7 @@ spi_unregister_device(struct spi_device 
 		device_unregister(&spi->dev);
 }
 
+extern const struct spi_device_id *
+spi_get_device_id(const struct spi_device *sdev);
+
 #endif /* __LINUX_SPI_H */
diff -puN scripts/mod/file2alias.c~spi-add-support-for-device-table-matching scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~spi-add-support-for-device-table-matching
+++ a/scripts/mod/file2alias.c
@@ -657,6 +657,15 @@ static int do_i2c_entry(const char *file
 	return 1;
 }
 
+/* Looks like: S */
+static int do_spi_entry(const char *filename, struct spi_device_id *id,
+			char *alias)
+{
+	sprintf(alias, "%s", id->name);
+
+	return 1;
+}
+
 static const struct dmifield {
 	const char *prefix;
 	int field;
@@ -853,6 +862,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct i2c_device_id), "i2c",
 			 do_i2c_entry, mod);
+	else if (sym_is(symname, "__mod_spi_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct spi_device_id), "spi",
+			 do_spi_entry, mod);
 	else if (sym_is(symname, "__mod_dmi_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct dmi_system_id), "dmi",
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
spi-merge-probe-and-probe_id-callbacks.patch

