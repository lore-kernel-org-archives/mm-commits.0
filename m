From: akpm@linux-foundation.org
Subject: - w1-w1_therm-fix-user-buffer-overflow-and-cat.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:58 -0700
Message-ID: <200810182319.m9INJwmW029608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbYJRXUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: w1_therm fix user buffer overflow and cat
has been removed from the -mm tree.  Its filename was
     w1-w1_therm-fix-user-buffer-overflow-and-cat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: w1_therm fix user buffer overflow and cat
From: David Fries <david@fries.net>

Fixed data reading bug by replacing binary attribute with device one.

Switching the sysfs read from bin_attribute to device_attribute.  The data
is far under PAGE_SIZE so the binary interface isn't required.  As the
device_attribute interface will make one call to w1_therm_read per file
open and buffer, the result is, the following problems go away.

buffer overflow:
	Execute a short read on w1_slave and w1_therm_read_bin would still
	return the full string size worth of data clobbering the user space
	buffer when it returned.  Switching to device_attribute avoids the
	buffer overflow problems.  With the snprintf formatted output dealing
	with short reads without doing a conversion per read would have
	been difficult.
bad behavior:
	`cat w1_slave` would cause two temperature conversions to take place.
	Previously the code assumed W1_SLAVE_DATA_SIZE would be returned with
	each read.  It would not return 0 unless the offset was less
	than W1_SLAVE_DATA_SIZE.  The result was the first read did a
	temperature conversion, filled the buffer and returned, the
	offset in the second read would be less than
	W1_SLAVE_DATA_SIZE and also fill the buffer and return, the
	third read would finnally have a big enough offset to return 0
	and cause cat to stop.  Now w1_therm_read will be called at
	most once per open.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |   55 ++++++++++++---------------------
 drivers/w1/w1.h              |    1 
 2 files changed, 20 insertions(+), 36 deletions(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1_therm-fix-user-buffer-overflow-and-cat drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1_therm-fix-user-buffer-overflow-and-cat
+++ a/drivers/w1/slaves/w1_therm.c
@@ -50,26 +50,20 @@ static u8 bad_roms[][9] = {
 				{}
 			};
 
-static ssize_t w1_therm_read_bin(struct kobject *, struct bin_attribute *,
-				 char *, loff_t, size_t);
+static ssize_t w1_therm_read(struct device *device,
+	struct device_attribute *attr, char *buf);
 
-static struct bin_attribute w1_therm_bin_attr = {
-	.attr = {
-		.name = "w1_slave",
-		.mode = S_IRUGO,
-	},
-	.size = W1_SLAVE_DATA_SIZE,
-	.read = w1_therm_read_bin,
-};
+static struct device_attribute w1_therm_attr =
+	__ATTR(w1_slave, S_IRUGO, w1_therm_read, NULL);
 
 static int w1_therm_add_slave(struct w1_slave *sl)
 {
-	return sysfs_create_bin_file(&sl->dev.kobj, &w1_therm_bin_attr);
+	return device_create_file(&sl->dev, &w1_therm_attr);
 }
 
 static void w1_therm_remove_slave(struct w1_slave *sl)
 {
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_therm_bin_attr);
+	device_remove_file(&sl->dev, &w1_therm_attr);
 }
 
 static struct w1_family_ops w1_therm_fops = {
@@ -168,30 +162,19 @@ static int w1_therm_check_rom(u8 rom[9])
 	return 0;
 }
 
-static ssize_t w1_therm_read_bin(struct kobject *kobj,
-				 struct bin_attribute *bin_attr,
-				 char *buf, loff_t off, size_t count)
+static ssize_t w1_therm_read(struct device *device,
+	struct device_attribute *attr, char *buf)
 {
-	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	struct w1_slave *sl = dev_to_w1_slave(device);
 	struct w1_master *dev = sl->master;
 	u8 rom[9], crc, verdict;
 	int i, max_trying = 10;
+	ssize_t c = PAGE_SIZE;
 
 	mutex_lock(&sl->master->mutex);
 
-	if (off > W1_SLAVE_DATA_SIZE) {
-		count = 0;
-		goto out;
-	}
-	if (off + count > W1_SLAVE_DATA_SIZE) {
-		count = 0;
-		goto out;
-	}
-
-	memset(buf, 0, count);
 	memset(rom, 0, sizeof(rom));
 
-	count = 0;
 	verdict = 0;
 	crc = 0;
 
@@ -211,7 +194,9 @@ static ssize_t w1_therm_read_bin(struct 
 
 				w1_write_8(dev, W1_READ_SCRATCHPAD);
 				if ((count = w1_read_block(dev, rom, 9)) != 9) {
-					dev_warn(&dev->dev, "w1_read_block() returned %d instead of 9.\n", count);
+					dev_warn(device, "w1_read_block() "
+						"returned %u instead of 9.\n",
+						count);
 				}
 
 				crc = w1_calc_crc8(rom, 8);
@@ -226,22 +211,22 @@ static ssize_t w1_therm_read_bin(struct 
 	}
 
 	for (i = 0; i < 9; ++i)
-		count += sprintf(buf + count, "%02x ", rom[i]);
-	count += sprintf(buf + count, ": crc=%02x %s\n",
+		c -= snprintf(buf + PAGE_SIZE - c, c, "%02x ", rom[i]);
+	c -= snprintf(buf + PAGE_SIZE - c, c, ": crc=%02x %s\n",
 			   crc, (verdict) ? "YES" : "NO");
 	if (verdict)
 		memcpy(sl->rom, rom, sizeof(sl->rom));
 	else
-		dev_warn(&dev->dev, "18S20 doesn't respond to CONVERT_TEMP.\n");
+		dev_warn(device, "18S20 doesn't respond to CONVERT_TEMP.\n");
 
 	for (i = 0; i < 9; ++i)
-		count += sprintf(buf + count, "%02x ", sl->rom[i]);
+		c -= snprintf(buf + PAGE_SIZE - c, c, "%02x ", sl->rom[i]);
 
-	count += sprintf(buf + count, "t=%d\n", w1_convert_temp(rom, sl->family->fid));
-out:
+	c -= snprintf(buf + PAGE_SIZE - c, c, "t=%d\n",
+		w1_convert_temp(rom, sl->family->fid));
 	mutex_unlock(&dev->mutex);
 
-	return count;
+	return PAGE_SIZE - c;
 }
 
 static int __init w1_therm_init(void)
diff -puN drivers/w1/w1.h~w1-w1_therm-fix-user-buffer-overflow-and-cat drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-w1_therm-fix-user-buffer-overflow-and-cat
+++ a/drivers/w1/w1.h
@@ -46,7 +46,6 @@ struct w1_reg_num
 #include "w1_family.h"
 
 #define W1_MAXNAMELEN		32
-#define W1_SLAVE_DATA_SIZE	128
 
 #define W1_SEARCH		0xF0
 #define W1_ALARM_SEARCH		0xEC
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

