From: akpm@linux-foundation.org
Subject: + i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-update.patch added to -mm tree
Date: Mon, 14 May 2007 17:46:23 -0700
Message-ID: <200705150046.l4F0kN3P030386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbXEOAqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder update
has been added to the -mm tree.  Its filename is
     i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder update
From: Grant Likely <grant.likely@secretlab.ca>

- Modified to be an i2c "new style" driver based on David Brownell's work
- uses the new prototype for i2c_smbus_read_i2c_block_data() for block data
  reads instead of a single byte at a time.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/ds1682.c |  333 ++++++++++++-----------------------
 1 files changed, 121 insertions(+), 212 deletions(-)

diff -puN drivers/i2c/chips/ds1682.c~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-update drivers/i2c/chips/ds1682.c
--- a/drivers/i2c/chips/ds1682.c~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-update
+++ a/drivers/i2c/chips/ds1682.c
@@ -16,132 +16,106 @@
 
 /*
  * The DS1682 elapsed timer recorder is a simple device that implements
- * one elapsed time counters, one event counter, an alarm signal and 10
+ * one elapsed time counter, one event counter, an alarm signal and 10
  * bytes of general purpose EEPROM.
  *
  * This driver provides access to the DS1682 counters and user data via
  * the sysfs.  The following attributes are added to the device node:
- *     elapsed_time (u32): Total elapsed event time in 1/4s resolution
+ *     elapsed_time (u32): Total elapsed event time in ms resolution
  *     alarm_time (u32): When elapsed time exceeds the value in alarm_time,
  *                       then the alarm pin is asserted.
  *     event_count (u16): number of times the event pin has gone low.
- *     user_data (u8[10]): general purpose EEPROM
+ *     eeprom (u8[10]): general purpose EEPROM
  *
  * Counter registers and user data are both read/write unless the device
- * has been write protected.  This driver does not support turning on write
+ * has been write protected.  This driver does not support turning off write
  * protection.  Once write protection is turned on, it is impossible to
- * turn off so I have left the feature out of this driver to avoid
+ * turn it off again, so I have left the feature out of this driver to avoid
  * accidental enabling, but it is trivial to add write protect support.
  *
  */
 
-#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/string.h>
-#include <linux/bcd.h>
 #include <linux/list.h>
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
+#include <linux/hwmon-sysfs.h>
 
 /* Device registers */
-#define DS1682_ADDR			0x6B
-
 #define DS1682_REG_CONFIG		0x00
 #define DS1682_REG_ALARM		0x01
 #define DS1682_REG_ELAPSED		0x05
 #define DS1682_REG_EVT_CNTR		0x09
-#define DS1682_REG_USER_DATA		0x0b
+#define DS1682_REG_EEPROM		0x0b
 #define DS1682_REG_RESET		0x1d
 #define DS1682_REG_WRITE_DISABLE	0x1e
 #define DS1682_REG_WRITE_MEM_DISABLE	0x1f
 
-/*
- * Probing class
- */
-static unsigned short normal_i2c[] = { DS1682_ADDR, I2C_CLIENT_END };
-
-I2C_CLIENT_INSMOD;
-
-/*
- * Low level chip access functions
- */
-static int ds1682_read(struct i2c_client *client, int reg, void *buf, int len)
-{
-	u8 *bytes = buf;
-	int val;
-
-	while (len--) {
-		val = i2c_smbus_read_byte_data(client, reg++);
-		if (val < 0)
-			return -EIO;
-		*bytes++ = val;
-	}
-	return 0;
-}
+#define DS1682_EEPROM_SIZE		10
 
 /*
  * Generic counter attributes
  */
-static int ds1682_attr_to_reg(struct device_attribute *attr, int *regsize);
-
-static ssize_t ds1682_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
+static ssize_t ds1682_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
-	u32 val = 0;
-	int reg;
-	int regsize;
-
-	dev_dbg(dev, "ds1682_show() called for %s\n", attr->attr.name);
-
-	/* Get the register address */
-	reg = ds1682_attr_to_reg(attr, &regsize);
-	if (reg < 0)
-		return -EIO;
+	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct i2c_client *client = to_i2c_client(dev);
+	__le32 val = 0;
+	int rc;
+
+	dev_dbg(dev, "ds1682_show() called on %s\n", attr->attr.name);
 
 	/* Read the register */
-	if (ds1682_read(to_i2c_client(dev), reg, &val, regsize))
+	rc = i2c_smbus_read_i2c_block_data(client, sattr->index, sattr->nr,
+					   (u8 *) & val);
+	if (rc < 0)
 		return -EIO;
 
+	/* Special case: the 32 bit regs are time values with 1/4s
+	 * resolution, scale them up to milliseconds */
+	if (sattr->nr == 4)
+		return sprintf(buf, "%lli\n", ((u64) le32_to_cpu(val)) * 250);
+
 	/* Format the output string and return # of bytes */
-	return sprintf(buf, "0x%.2x\n", le32_to_cpu(val));
+	return sprintf(buf, "%li\n", (long)le32_to_cpu(val));
 }
 
-static ssize_t ds1682_store(struct device *dev,
-			    struct device_attribute *attr, const char *buf,
-			    size_t count)
+static ssize_t ds1682_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
 {
+	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
 	struct i2c_client *client = to_i2c_client(dev);
-	int reg;
-	int regsize;
 	char *endp;
-	u32 val;
+	u64 val;
+	__le32 val_le;
 	int rc;
 
-	/* Sanitize the input */
-	reg = ds1682_attr_to_reg(attr, &regsize);
-
-	if ((reg < 0) || (count >= 16) || (buf[count] != '\0')) {
-		dev_dbg(dev, "insane input; reg=0x%i count=%zd%s\n",
-			reg, count, buf[count] == '\0' ? " unterminated" : "");
-		return -EIO;
-	}
+	dev_dbg(dev, "ds1682_store() called on %s\n", attr->attr.name);
 
 	/* Decode input */
-	val = simple_strtoul(buf, &endp, 0);
+	val = simple_strtoull(buf, &endp, 0);
 	if (buf == endp) {
 		dev_dbg(dev, "input string not a number\n");
 		return -EIO;
 	}
 
+	/* Special case: the 32 bit regs are time values with 1/4s
+	 * resolution, scale input down to quarter-seconds */
+	if (sattr->nr == 4)
+		do_div(val, 250);
+
 	/* write out the value */
-	val = cpu_to_le32(val);
-	rc = i2c_smbus_write_i2c_block_data(client, reg, regsize, (void *)&val);
+	val_le = cpu_to_le32(val);
+	rc = i2c_smbus_write_i2c_block_data(client, sattr->index, sattr->nr,
+					    (u8 *) & val);
 	if (rc < 0) {
 		dev_err(dev, "register write failed; reg=0x%x, size=%i\n",
-			reg, regsize);
+			sattr->index, sattr->nr);
 		return -EIO;
 	}
 
@@ -151,196 +125,131 @@ static ssize_t ds1682_store(struct devic
 /*
  * Simple register attributes
  */
-DEVICE_ATTR(config, S_IRUGO, ds1682_show, NULL);
-DEVICE_ATTR(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
-DEVICE_ATTR(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
-DEVICE_ATTR(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
-
-/* Get register size and address from device_attribute structure.  This
- * function must come after the DEVICE_ATTR() lines as it depends on the
- * device_attribute lines being declared */
-static int ds1682_attr_to_reg(struct device_attribute *attr, int *regsize)
-{
-	if (attr == &dev_attr_elapsed_time) {
-		*regsize = 4;
-		return DS1682_REG_ELAPSED;
-	}
-
-	if (attr == &dev_attr_alarm_time) {
-		*regsize = 4;
-		return DS1682_REG_ALARM;
-	}
-
-	if (attr == &dev_attr_event_count) {
-		*regsize = 2;
-		return DS1682_REG_EVT_CNTR;
-	}
-
-	if (attr == &dev_attr_config) {
-		*regsize = 1;
-		return DS1682_REG_CONFIG;
-	}
-
-	pr_debug("Cannot find registers for device_attribute %p\n", attr);
-	return -ENODEV;
-}
+SENSOR_DEVICE_ATTR_2(config, S_IRUGO, ds1682_show, NULL, DS1682_REG_CONFIG, 1);
+SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
+		     4, DS1682_REG_ELAPSED);
+SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
+		     4, DS1682_REG_ALARM);
+SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
+		     2, DS1682_REG_EVT_CNTR);
+
+static const struct attribute_group ds1682_group = {
+	.attrs = (struct attribute *[]) {
+		&sensor_dev_attr_config.dev_attr.attr,
+		&sensor_dev_attr_elapsed_time.dev_attr.attr,
+		&sensor_dev_attr_alarm_time.dev_attr.attr,
+		&sensor_dev_attr_event_count.dev_attr.attr,
+		NULL,
+	},
+};
 
 /*
  * User data attribute
  */
-static ssize_t ds1682_user_data_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
+static ssize_t ds1682_eeprom_read(struct kobject *kobj, char *buf, loff_t off,
+				  size_t count)
 {
-	char *end = buf;
-	u8 val[10];
-	int i;
+	struct i2c_client *client = kobj_to_i2c_client(kobj);
+	int rc;
 
-	if (ds1682_read(to_i2c_client(dev), DS1682_REG_USER_DATA, &val, 10))
-		return -EIO;
+	dev_dbg(&client->dev, "ds1682_eeprom_read(p=%p, off=%lli, c=%zi)\n",
+		buf, off, count);
 
-	for (i = 0; i < 10; i++)
-		end += sprintf(end, "%.2x ", val[i]);
+	if (off > DS1682_EEPROM_SIZE)
+		return 0;
 
-	*(end - 1) = '\n';	/* Eliminate trailing space */
-	return end - buf;
+	if (off + count > DS1682_EEPROM_SIZE)
+		count = DS1682_EEPROM_SIZE - off;
+
+	rc = i2c_smbus_read_i2c_block_data(client, DS1682_REG_EEPROM + off,
+					   count, buf);
+	if (rc < 0)
+		return -EIO;
+
+	return count;
 }
 
-static ssize_t ds1682_user_data_store(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t count)
+static ssize_t ds1682_eeprom_write(struct kobject *kobj, char *buf, loff_t off,
+				   size_t count)
 {
-	u8 data[10];
-	char *endp;
-	int bytecount = 0;
-
-	/* Check input for sanity */
-	if ((count >= 80) || (buf[count] != '\0')) {
-		dev_dbg(dev, "insane input; count=%zd%s\n",
-			count, buf[count] == '\0' ? " unterminated" : "");
-		return -EIO;
-	}
+	struct i2c_client *client = kobj_to_i2c_client(kobj);
 
-	/* Parse the data */
-	while (bytecount < 10) {
-		while (isspace(*buf))
-			buf++;
-
-		data[bytecount] = simple_strtoul(buf, &endp, 16);
-		if (endp == buf)	/* make sure it's a real data value */
-			break;
+	dev_dbg(&client->dev, "ds1682_eeprom_write(p=%p, off=%lli, c=%zi)\n",
+		buf, off, count);
 
-		buf = endp;
-		bytecount++;
-	}
-	while (isspace(*endp))
-		endp++;
+	if (off >= DS1682_EEPROM_SIZE)
+		return -ENOSPC;
 
-	/* Abort on invalid data */
-	if ((bytecount == 0) || (*endp != '\0')) {
-		dev_dbg(dev, "invalid input *buf=\"%s\" *endp=\"%s\"\n",
-			buf, endp);
-		return -EIO;
-	}
+	if (off + count > DS1682_EEPROM_SIZE)
+		count = DS1682_EEPROM_SIZE - off;
 
 	/* Write out to the device */
-	if (i2c_smbus_write_i2c_block_data(to_i2c_client(dev),
-					   DS1682_REG_USER_DATA, bytecount,
-					   data) < 0)
+	if (i2c_smbus_write_i2c_block_data(client, DS1682_REG_EEPROM + off,
+					   count, buf) < 0)
 		return -EIO;
+
 	return count;
 }
 
-DEVICE_ATTR(user_data, S_IRUGO | S_IWUSR, ds1682_user_data_show,
-	    ds1682_user_data_store);
+static struct bin_attribute ds1682_eeprom_attr = {
+	.attr = {
+		.name = "eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = DS1682_EEPROM_SIZE,
+	.read = ds1682_eeprom_read,
+	.write = ds1682_eeprom_write,
+};
 
 /*
  * Called when a device is found at the ds1682 address
  */
-static struct i2c_driver ds1682_driver;
-static int ds1682_detect(struct i2c_adapter *adapter, int address, int kind)
+static int ds1682_probe(struct i2c_client *client)
 {
-	struct i2c_client *new_client;
 	int err = 0;
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_I2C))
-		goto exit;
+	if (client->addr != 0x6b) {
+		dev_err(&client->dev, "%x is not a valid address\n",
+			client->addr);
+		return -ENODEV;
+	}
 
-	if (!(new_client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
-		err = -ENOMEM;
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_READ_BYTE_DATA |
+				     I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
+		dev_err(&client->dev, "i2c bus does not support the ds1682\n");
 		goto exit;
 	}
 
-	new_client->addr = address;
-	new_client->adapter = adapter;
-	new_client->driver = &ds1682_driver;
-	new_client->flags = 0;
-
-	/* Note: Ignoring 'kind' value as the ds1682 uses a fixed address */
-
-	/* We can fill in the remaining client fields */
-	strlcpy(new_client->name, "ds1682", I2C_NAME_SIZE);
-
-	/* Tell the I2C layer a new client has arrived */
-	if ((err = i2c_attach_client(new_client)))
-		goto exit_free;
-
-	if (device_create_file(&new_client->dev, &dev_attr_config))
-		goto exit_attr_config;
-	if (device_create_file(&new_client->dev, &dev_attr_elapsed_time))
-		goto exit_attr_elapsed;
-	if (device_create_file(&new_client->dev, &dev_attr_alarm_time))
-		goto exit_attr_alarm;
-	if (device_create_file(&new_client->dev, &dev_attr_event_count))
-		goto exit_attr_event;
-	if (device_create_file(&new_client->dev, &dev_attr_user_data))
-		goto exit_attr_userdata;
+	if (sysfs_create_group(&client->dev.kobj, &ds1682_group))
+		goto exit;
+
+	if (sysfs_create_bin_file(&client->dev.kobj, &ds1682_eeprom_attr))
+		goto exit_bin_attr;
 
 	return 0;
 
-      exit_attr_userdata:
-	device_remove_file(&new_client->dev, &dev_attr_event_count);
-      exit_attr_event:
-	device_remove_file(&new_client->dev, &dev_attr_alarm_time);
-      exit_attr_alarm:
-	device_remove_file(&new_client->dev, &dev_attr_elapsed_time);
-      exit_attr_elapsed:
-	device_remove_file(&new_client->dev, &dev_attr_config);
-      exit_attr_config:
-	i2c_detach_client(new_client);
-      exit_free:
-	kfree(new_client);
+      exit_bin_attr:
+	sysfs_remove_group(&client->dev.kobj, &ds1682_group);
       exit:
 	return err;
 }
 
-static int ds1682_attach_adapter(struct i2c_adapter *adapter)
+static int ds1682_remove(struct i2c_client *client)
 {
-	return i2c_probe(adapter, &addr_data, ds1682_detect);
-}
-
-static int ds1682_detach_client(struct i2c_client *client)
-{
-	int err;
-	device_remove_file(&client->dev, &dev_attr_user_data);
-	device_remove_file(&client->dev, &dev_attr_event_count);
-	device_remove_file(&client->dev, &dev_attr_alarm_time);
-	device_remove_file(&client->dev, &dev_attr_elapsed_time);
-	device_remove_file(&client->dev, &dev_attr_config);
-
-	if ((err = i2c_detach_client(client)))
-		return err;
+	sysfs_remove_bin_file(&client->dev.kobj, &ds1682_eeprom_attr);
+	sysfs_remove_group(&client->dev.kobj, &ds1682_group);
 
-	kfree(client);
 	return 0;
 }
 
 static struct i2c_driver ds1682_driver = {
 	.driver = {
-		   .name = "ds1682",
-		   },
-	.attach_adapter = ds1682_attach_adapter,
-	.detach_client = ds1682_detach_client,
+		.name = "ds1682",
+	},
+	.probe = ds1682_probe,
+	.remove = ds1682_remove,
 };
 
 static int __init ds1682_init(void)
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-update.patch
add-support-for-xilinx-systemace-compactflash-interface.patch
