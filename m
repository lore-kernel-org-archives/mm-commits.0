From: akpm@linux-foundation.org
Subject: [to-be-updated] lis3-power-control-for-the-chip.patch removed from -mm tree
Date: Fri, 05 Mar 2010 11:56:13 -0800
Message-ID: <201003051956.o25JuDJB024436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755511Ab0CET4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 14:56:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: power control for the chip
has been removed from the -mm tree.  Its filename was
     lis3-power-control-for-the-chip.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: power control for the chip
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Chip operational state is controlled by number of the users.  When no-one
is really using the chip, it is powered down.  Typical saving for 8bit
device is 300 uA based on chip datasheet.  Not much, but in small devices
everything counts.

New entry is added to sysfs: active It tells when position entry in sysfs
is in operational state.  Initial setting is chip active to keep
functionality similar as before.  When "active" is set to 0, position
entry return error code.

Regardless of the active sysfs entry state, chip is also powered on / off
according to /dev/freefall or /dev/input/eventx / /dev/input/jsx use.  If
some of the device handles is open, chip is on operational state.

Chip is in powerdown:
- sysfs active == 0 and
- /dev/freefall is not open and
- /dev/input/... is not open

Chip is in active mode:
- active == 1 or
- /dev/freefall is open or
- /dev/input/.... is open

Initial state:
active == 1

When chip is powered on, it takes 30-125 ms depending on the chip type and
current sampling rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c     |   75 ++++++++++++++++++++++++++++++--
 drivers/hwmon/lis3lv02d.h     |    2 
 drivers/hwmon/lis3lv02d_i2c.c |    8 ++-
 drivers/hwmon/lis3lv02d_spi.c |   12 ++---
 4 files changed, 87 insertions(+), 10 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-power-control-for-the-chip drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-power-control-for-the-chip
+++ a/drivers/hwmon/lis3lv02d.c
@@ -248,6 +248,31 @@ void lis3lv02d_poweron(struct lis3lv02d 
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
+static void lis3lv02d_add_users(struct lis3lv02d *lis3)
+{
+	mutex_lock(&lis3->mutex);
+	if (!lis3->users++)
+		lis3lv02d_poweron(lis3);
+	mutex_unlock(&lis3->mutex);
+}
+
+static void lis3lv02d_remove_users(struct lis3lv02d *lis3)
+{
+	mutex_lock(&lis3->mutex);
+	if (!--lis3->users)
+		lis3lv02d_poweroff(lis3);
+	mutex_unlock(&lis3->mutex);
+}
+
+static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
+{
+	lis3lv02d_add_users(&lis3_dev);
+}
+
+static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
+{
+	lis3lv02d_remove_users(&lis3_dev);
+}
 
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
@@ -270,6 +295,7 @@ static int lis3lv02d_misc_open(struct in
 	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
+	lis3lv02d_add_users(&lis3_dev);
 	atomic_set(&lis3_dev.count, 0);
 
 	/*
@@ -299,6 +325,7 @@ static int lis3lv02d_misc_release(struct
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
 	free_irq(lis3_dev.irq, &lis3_dev);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
+	lis3lv02d_remove_users(&lis3_dev);
 	return 0;
 }
 
@@ -404,8 +431,10 @@ int lis3lv02d_joystick_enable(void)
 	if (!lis3_dev.idev)
 		return -ENOMEM;
 
-	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
-	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
+	lis3_dev.idev->poll  = lis3lv02d_joystick_poll;
+	lis3_dev.idev->open  = lis3lv02d_joystick_open;
+	lis3_dev.idev->close = lis3lv02d_joystick_close;
+	lis3_dev.idev->poll_interval	 = MDPS_POLL_INTERVAL;
 	input_dev = lis3_dev.idev->input;
 
 	input_dev->name       = "ST LIS3LV02DL Accelerometer";
@@ -462,6 +491,9 @@ static ssize_t lis3lv02d_position_show(s
 {
 	int x, y, z;
 
+	if (lis3_dev.active == 0)
+		return -ENODATA;
+
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
@@ -487,15 +519,51 @@ static ssize_t lis3lv02d_rate_set(struct
 	return count;
 }
 
+static ssize_t lis3lv02d_active_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", lis3_dev.active);
+}
+
+static ssize_t lis3lv02d_active_set(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	unsigned long active;
+
+	if (strict_strtoul(buf, 0, &active))
+		return -EINVAL;
+
+	if (active > 1)
+		return -EINVAL;
+
+	mutex_lock(&lis3_dev.mutex);
+	if (active == lis3_dev.active) {
+		mutex_unlock(&lis3_dev.mutex);
+		return count;
+	}
+	lis3_dev.active = active;
+	mutex_unlock(&lis3_dev.mutex);
+
+	if (active)
+		lis3lv02d_add_users(&lis3_dev);
+	else
+		lis3lv02d_remove_users(&lis3_dev);
+	return count;
+}
+
 static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
 static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
 					    lis3lv02d_rate_set);
+static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, lis3lv02d_active_show,
+					      lis3lv02d_active_set);
 
 static struct attribute *lis3lv02d_attributes[] = {
 	&dev_attr_selftest.attr,
 	&dev_attr_position.attr,
 	&dev_attr_rate.attr,
+	&dev_attr_active.attr,
 	NULL
 };
 
@@ -592,7 +660,8 @@ int lis3lv02d_init_device(struct lis3lv0
 	mutex_init(&dev->mutex);
 
 	lis3lv02d_add_fs(dev);
-	lis3lv02d_poweron(dev);
+	lis3lv02d_add_users(dev);
+	lis3_dev.active = 1; /* By default, chip is in operational state */
 
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
diff -puN drivers/hwmon/lis3lv02d.h~lis3-power-control-for-the-chip drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-power-control-for-the-chip
+++ a/drivers/hwmon/lis3lv02d.h
@@ -221,9 +221,11 @@ struct lis3lv02d {
 	int                     *odrs;     /* Supported output data rates */
 	u8                      odr_mask;  /* ODR bit mask */
 	u8			whoami;    /* indicates measurement precision */
+	u8			active;
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 	int			pwron_delay;
+	int			users;
 	int                     scale; /*
 					* relationship between 1 LBS and mG
 					* (1/1000th of earth gravity)
diff -puN drivers/hwmon/lis3lv02d_i2c.c~lis3-power-control-for-the-chip drivers/hwmon/lis3lv02d_i2c.c
--- a/drivers/hwmon/lis3lv02d_i2c.c~lis3-power-control-for-the-chip
+++ a/drivers/hwmon/lis3lv02d_i2c.c
@@ -121,8 +121,10 @@ static int lis3lv02d_i2c_suspend(struct 
 {
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	if (!lis3->pdata->wakeup_flags)
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
 		lis3lv02d_poweroff(lis3);
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
@@ -130,8 +132,10 @@ static int lis3lv02d_i2c_resume(struct i
 {
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	if (!lis3->pdata->wakeup_flags)
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
 		lis3lv02d_poweron(lis3);
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3-power-control-for-the-chip drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3-power-control-for-the-chip
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -92,9 +92,10 @@ static int lis3lv02d_spi_suspend(struct 
 {
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
 
-	if (!lis3->pdata->wakeup_flags)
-		lis3lv02d_poweroff(&lis3_dev);
-
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
+		lis3lv02d_poweroff(lis3);
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
@@ -102,9 +103,10 @@ static int lis3lv02d_spi_resume(struct s
 {
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
 
-	if (!lis3->pdata->wakeup_flags)
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
 		lis3lv02d_poweron(lis3);
