From: akpm@osdl.org
Subject: - better-config_w1_slave_ds2433_crc-handling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:14:54 -0800
Message-ID: <200612072314.kB7NEsJ7030664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59111 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1164204AbWLHATv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 19:19:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, bunk@stusta.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     better CONFIG_W1_SLAVE_DS2433_CRC handling
has been removed from the -mm tree.  Its filename was
     better-config_w1_slave_ds2433_crc-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: better CONFIG_W1_SLAVE_DS2433_CRC handling
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

CONFIG_W1_SLAVE_DS2433_CRC can be used directly, there's no reason for the
indirection of defining a different variable in the Makefile.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/w1/Makefile           |    4 ----
 drivers/w1/slaves/Makefile    |    4 ----
 drivers/w1/slaves/w1_ds2433.c |   30 +++++++++++++++---------------
 3 files changed, 15 insertions(+), 23 deletions(-)

diff -puN drivers/w1/Makefile~better-config_w1_slave_ds2433_crc-handling drivers/w1/Makefile
--- a/drivers/w1/Makefile~better-config_w1_slave_ds2433_crc-handling
+++ a/drivers/w1/Makefile
@@ -2,10 +2,6 @@
 # Makefile for the Dallas's 1-wire bus.
 #
 
-ifeq ($(CONFIG_W1_DS2433_CRC), y)
-EXTRA_CFLAGS	+= -DCONFIG_W1_F23_CRC
-endif
-
 obj-$(CONFIG_W1)	+= wire.o
 wire-objs		:= w1.o w1_int.o w1_family.o w1_netlink.o w1_io.o
 
diff -puN drivers/w1/slaves/Makefile~better-config_w1_slave_ds2433_crc-handling drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~better-config_w1_slave_ds2433_crc-handling
+++ a/drivers/w1/slaves/Makefile
@@ -2,10 +2,6 @@
 # Makefile for the Dallas's 1-wire slaves.
 #
 
-ifeq ($(CONFIG_W1_SLAVE_DS2433_CRC), y)
-EXTRA_CFLAGS += -DCONFIG_W1_F23_CRC
-endif
-
 obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
diff -puN drivers/w1/slaves/w1_ds2433.c~better-config_w1_slave_ds2433_crc-handling drivers/w1/slaves/w1_ds2433.c
--- a/drivers/w1/slaves/w1_ds2433.c~better-config_w1_slave_ds2433_crc-handling
+++ a/drivers/w1/slaves/w1_ds2433.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/delay.h>
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 #include <linux/crc16.h>
 
 #define CRC16_INIT		0
@@ -62,7 +62,7 @@ static inline size_t w1_f23_fix_count(lo
 	return count;
 }
 
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 static int w1_f23_refresh_block(struct w1_slave *sl, struct w1_f23_data *data,
 				int block)
 {
@@ -89,13 +89,13 @@ static int w1_f23_refresh_block(struct w
 
 	return 0;
 }
-#endif	/* CONFIG_W1_F23_CRC */
+#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
 static ssize_t w1_f23_read_bin(struct kobject *kobj, char *buf, loff_t off,
 			       size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 	struct w1_f23_data *data = sl->family_data;
 	int i, min_page, max_page;
 #else
@@ -107,7 +107,7 @@ static ssize_t w1_f23_read_bin(struct ko
 
 	mutex_lock(&sl->master->mutex);
 
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 
 	min_page = (off >> W1_PAGE_BITS);
 	max_page = (off + count - 1) >> W1_PAGE_BITS;
@@ -119,7 +119,7 @@ static ssize_t w1_f23_read_bin(struct ko
 	}
 	memcpy(buf, &data->memory[off], count);
 
-#else 	/* CONFIG_W1_F23_CRC */
+#else 	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
 	/* read directly from the EEPROM */
 	if (w1_reset_select_slave(sl)) {
@@ -133,7 +133,7 @@ static ssize_t w1_f23_read_bin(struct ko
 	w1_write_block(sl->master, wrbuf, 3);
 	w1_read_block(sl->master, buf, count);
 
-#endif	/* CONFIG_W1_F23_CRC */
+#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
 out_up:
 	mutex_unlock(&sl->master->mutex);
@@ -208,7 +208,7 @@ static ssize_t w1_f23_write_bin(struct k
 	if ((count = w1_f23_fix_count(off, count, W1_EEPROM_SIZE)) == 0)
 		return 0;
 
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 	/* can only write full blocks in cached mode */
 	if ((off & W1_PAGE_MASK) || (count & W1_PAGE_MASK)) {
 		dev_err(&sl->dev, "invalid offset/count off=%d cnt=%zd\n",
@@ -223,7 +223,7 @@ static ssize_t w1_f23_write_bin(struct k
 			return -EINVAL;
 		}
 	}
-#endif	/* CONFIG_W1_F23_CRC */
+#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
 	mutex_lock(&sl->master->mutex);
 
@@ -262,7 +262,7 @@ static struct bin_attribute w1_f23_bin_a
 static int w1_f23_add_slave(struct w1_slave *sl)
 {
 	int err;
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 	struct w1_f23_data *data;
 
 	data = kmalloc(sizeof(struct w1_f23_data), GFP_KERNEL);
@@ -271,24 +271,24 @@ static int w1_f23_add_slave(struct w1_sl
 	memset(data, 0, sizeof(struct w1_f23_data));
 	sl->family_data = data;
 
-#endif	/* CONFIG_W1_F23_CRC */
+#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
 	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f23_bin_attr);
 
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 	if (err)
 		kfree(data);
-#endif	/* CONFIG_W1_F23_CRC */
+#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
 	return err;
 }
 
 static void w1_f23_remove_slave(struct w1_slave *sl)
 {
-#ifdef CONFIG_W1_F23_CRC
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
 	kfree(sl->family_data);
 	sl->family_data = NULL;
-#endif	/* CONFIG_W1_F23_CRC */
+#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f23_bin_attr);
 }
 
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

origin.patch

