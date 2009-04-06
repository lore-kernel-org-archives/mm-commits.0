From: akpm@linux-foundation.org
Subject: [merged] memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:17 -0700
Message-ID: <200904061933.n36JXHmR011061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529AbZDFTgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@deeprootsystems.com, dbrownell@users.sourceforge.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     memory_accessor: implement the new memory_accessor interface for I2C EEPROM
has been removed from the -mm tree.  Its filename was
     memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_accessor: implement the new memory_accessor interface for I2C EEPROM
From: Kevin Hilman <khilman@deeprootsystems.com>

In the case of at24, the platform code registers a 'setup' callback with
the at24_platform_data.  When the at24 driver detects an EEPROM, it fills
out the read and write functions of the memory_accessor and calls the
setup callback passing the memory_accessor struct.  The platform code can
then use the read/write functions in the memory_accessor struct for
reading and writing the EEPROM.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/at24.c |   67 ++++++++++++++++++++++++++++-------
 include/linux/i2c/at24.h   |    4 ++
 2 files changed, 58 insertions(+), 13 deletions(-)

diff -puN drivers/misc/eeprom/at24.c~memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom drivers/misc/eeprom/at24.c
--- a/drivers/misc/eeprom/at24.c~memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom
+++ a/drivers/misc/eeprom/at24.c
@@ -53,6 +53,7 @@
 
 struct at24_data {
 	struct at24_platform_data chip;
+	struct memory_accessor macc;
 	bool use_smbus;
 
 	/*
@@ -225,14 +226,11 @@ static ssize_t at24_eeprom_read(struct a
 		return status;
 }
 
-static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_read(struct at24_data *at24,
 		char *buf, loff_t off, size_t count)
 {
-	struct at24_data *at24;
 	ssize_t retval = 0;
 
-	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
-
 	if (unlikely(!count))
 		return count;
 
@@ -262,12 +260,14 @@ static ssize_t at24_bin_read(struct kobj
 	return retval;
 }
 
+static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct at24_data *at24;
 
-/*
- * REVISIT: export at24_bin{read,write}() to let other kernel code use
- * eeprom data. For example, it might hold a board's Ethernet address, or
- * board-specific calibration data generated on the manufacturing floor.
- */
+	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	return at24_read(at24, buf, off, count);
+}
 
 
 /*
@@ -347,14 +347,11 @@ static ssize_t at24_eeprom_write(struct 
 	return -ETIMEDOUT;
 }
 
-static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_write(struct at24_data *at24,
 		char *buf, loff_t off, size_t count)
 {
-	struct at24_data *at24;
 	ssize_t retval = 0;
 
-	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
-
 	if (unlikely(!count))
 		return count;
 
@@ -384,6 +381,39 @@ static ssize_t at24_bin_write(struct kob
 	return retval;
 }
 
+static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct at24_data *at24;
+
+	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	return at24_write(at24, buf, off, count);
+}
+
+/*-------------------------------------------------------------------------*/
+
+/*
+ * This lets other kernel code access the eeprom data. For example, it
+ * might hold a board's Ethernet address, or board-specific calibration
+ * data generated on the manufacturing floor.
+ */
+
+static ssize_t at24_macc_read(struct memory_accessor *macc, char *buf,
+			 off_t offset, size_t count)
+{
+	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
+
+	return at24_read(at24, buf, offset, count);
+}
+
+static ssize_t at24_macc_write(struct memory_accessor *macc, char *buf,
+			  off_t offset, size_t count)
+{
+	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
+
+	return at24_write(at24, buf, offset, count);
+}
+
 /*-------------------------------------------------------------------------*/
 
 static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -413,6 +443,9 @@ static int at24_probe(struct i2c_client 
 		 * is recommended anyhow.
 		 */
 		chip.page_size = 1;
+
+		chip.setup = NULL;
+		chip.context = NULL;
 	}
 
 	if (!is_power_of_2(chip.byte_len))
@@ -463,6 +496,8 @@ static int at24_probe(struct i2c_client 
 	at24->bin.read = at24_bin_read;
 	at24->bin.size = chip.byte_len;
 
+	at24->macc.read = at24_macc_read;
+
 	writable = !(chip.flags & AT24_FLAG_READONLY);
 	if (writable) {
 		if (!use_smbus || i2c_check_functionality(client->adapter,
@@ -470,6 +505,8 @@ static int at24_probe(struct i2c_client 
 
 			unsigned write_max = chip.page_size;
 
+			at24->macc.write = at24_macc_write;
+
 			at24->bin.write = at24_bin_write;
 			at24->bin.attr.mode |= S_IWUSR;
 
@@ -520,6 +557,10 @@ static int at24_probe(struct i2c_client 
 		at24->write_max,
 		use_smbus ? ", use_smbus" : "");
 
+	/* export data to kernel code */
+	if (chip.setup)
+		chip.setup(&at24->macc, chip.context);
+
 	return 0;
 
 err_clients:
diff -puN include/linux/i2c/at24.h~memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom include/linux/i2c/at24.h
--- a/include/linux/i2c/at24.h~memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom
+++ a/include/linux/i2c/at24.h
@@ -2,6 +2,7 @@
 #define _LINUX_AT24_H
 
 #include <linux/types.h>
+#include <linux/memory.h>
 
 /*
  * As seen through Linux I2C, differences between the most common types of I2C
@@ -23,6 +24,9 @@ struct at24_platform_data {
 #define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
 #define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
 #define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
+
+	void		(*setup)(struct memory_accessor *, void *context);
+	void		*context;
 };
 
 #endif /* _LINUX_AT24_H */
_

Patches currently in -mm which might be from khilman@deeprootsystems.com are

origin.patch
linux-next.patch

