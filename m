From: akpm@linux-foundation.org
Subject: + mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions.patch added to -mm tree
Date: Wed, 25 Aug 2010 12:19:40 -0700
Message-ID: <201008251919.o7PJJelL010995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab0HYTUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 15:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jy0922.shim@samsung.com, kyungmin.park@samsung.com, mcuos.com@gmail.com, sameo@linux.intel.com


The patch titled
     mfd: MAX8998: use struct i2c_client to argument on i2c operation functions
has been added to the -mm tree.  Its filename is
     mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions.patch

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
Subject: mfd: MAX8998: use struct i2c_client to argument on i2c operation functions
From: Joonyoung Shim <jy0922.shim@samsung.com>

The MAX8998 chip have regulator and rtc features.  The i2c slave address
of regulator and rtc is different, so needs each i2c client on i2c
operation functions.

Also, this patch exports i2c operation functions instead of callback to
make easy to read.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/max8998.c               |   29 ++++++++++++-------------
 drivers/regulator/max8998.c         |   17 +++++++++-----
 include/linux/mfd/max8998-private.h |   30 ++++----------------------
 3 files changed, 30 insertions(+), 46 deletions(-)

diff -puN drivers/mfd/max8998.c~mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions drivers/mfd/max8998.c
--- a/drivers/mfd/max8998.c~mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions
+++ a/drivers/mfd/max8998.c
@@ -36,13 +36,13 @@ static struct mfd_cell max8998_devs[] = 
 	}
 };
 
-static int max8998_i2c_device_read(struct max8998_dev *max8998, u8 reg, u8 *dest)
+int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
 {
-	struct i2c_client *client = max8998->i2c_client;
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 	int ret;
 
 	mutex_lock(&max8998->iolock);
-	ret = i2c_smbus_read_byte_data(client, reg);
+	ret = i2c_smbus_read_byte_data(i2c, reg);
 	mutex_unlock(&max8998->iolock);
 	if (ret < 0)
 		return ret;
@@ -51,36 +51,38 @@ static int max8998_i2c_device_read(struc
 	*dest = ret;
 	return 0;
 }
+EXPORT_SYMBOL(max8998_read_reg);
 
-static int max8998_i2c_device_write(struct max8998_dev *max8998, u8 reg, u8 value)
+int max8998_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
 {
-	struct i2c_client *client = max8998->i2c_client;
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 	int ret;
 
 	mutex_lock(&max8998->iolock);
-	ret = i2c_smbus_write_byte_data(client, reg, value);
+	ret = i2c_smbus_write_byte_data(i2c, reg, value);
 	mutex_unlock(&max8998->iolock);
 	return ret;
 }
+EXPORT_SYMBOL(max8998_write_reg);
 
-static int max8998_i2c_device_update(struct max8998_dev *max8998, u8 reg,
-				     u8 val, u8 mask)
+int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 {
-	struct i2c_client *client = max8998->i2c_client;
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 	int ret;
 
 	mutex_lock(&max8998->iolock);
-	ret = i2c_smbus_read_byte_data(client, reg);
+	ret = i2c_smbus_read_byte_data(i2c, reg);
 	if (ret >= 0) {
 		u8 old_val = ret & 0xff;
 		u8 new_val = (val & mask) | (old_val & (~mask));
-		ret = i2c_smbus_write_byte_data(client, reg, new_val);
+		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
 		if (ret >= 0)
 			ret = 0;
 	}
 	mutex_unlock(&max8998->iolock);
 	return ret;
 }
+EXPORT_SYMBOL(max8998_update_reg);
 
 static int max8998_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
@@ -94,10 +96,7 @@ static int max8998_i2c_probe(struct i2c_
 
 	i2c_set_clientdata(i2c, max8998);
 	max8998->dev = &i2c->dev;
-	max8998->i2c_client = i2c;
-	max8998->dev_read = max8998_i2c_device_read;
-	max8998->dev_write = max8998_i2c_device_write;
-	max8998->dev_update = max8998_i2c_device_update;
+	max8998->i2c = i2c;
 	mutex_init(&max8998->iolock);
 
 	ret = mfd_add_devices(max8998->dev, -1,
diff -puN drivers/regulator/max8998.c~mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions drivers/regulator/max8998.c
--- a/drivers/regulator/max8998.c~mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions
+++ a/drivers/regulator/max8998.c
@@ -173,6 +173,7 @@ static int max8998_get_enable_register(s
 static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int ret, reg, shift = 8;
 	u8 val;
 
@@ -180,7 +181,7 @@ static int max8998_ldo_is_enabled(struct
 	if (ret)
 		return ret;
 
-	ret = max8998_read_reg(max8998->iodev, reg, &val);
+	ret = max8998_read_reg(i2c, reg, &val);
 	if (ret)
 		return ret;
 
@@ -190,25 +191,27 @@ static int max8998_ldo_is_enabled(struct
 static int max8998_ldo_enable(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int reg, shift = 8, ret;
 
 	ret = max8998_get_enable_register(rdev, &reg, &shift);
 	if (ret)
 		return ret;
 
-	return max8998_update_reg(max8998->iodev, reg, 1<<shift, 1<<shift);
+	return max8998_update_reg(i2c, reg, 1<<shift, 1<<shift);
 }
 
 static int max8998_ldo_disable(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int reg, shift = 8, ret;
 
 	ret = max8998_get_enable_register(rdev, &reg, &shift);
 	if (ret)
 		return ret;
 
-	return max8998_update_reg(max8998->iodev, reg, 0, 1<<shift);
+	return max8998_update_reg(i2c, reg, 0, 1<<shift);
 }
 
 static int max8998_get_voltage_register(struct regulator_dev *rdev,
@@ -276,6 +279,7 @@ static int max8998_get_voltage_register(
 static int max8998_get_voltage(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int reg, shift = 0, mask, ret;
 	u8 val;
 
@@ -283,7 +287,7 @@ static int max8998_get_voltage(struct re
 	if (ret)
 		return ret;
 
-	ret = max8998_read_reg(max8998->iodev, reg, &val);
+	ret = max8998_read_reg(i2c, reg, &val);
 	if (ret)
 		return ret;
 
@@ -297,6 +301,7 @@ static int max8998_set_voltage(struct re
 				int min_uV, int max_uV)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	int previous_vol = 0;
 	const struct voltage_map_desc *desc;
@@ -330,14 +335,14 @@ static int max8998_set_voltage(struct re
 	/* wait for RAMP_UP_DELAY if rdev is BUCK1/2 and
 	 * ENRAMP is ON */
 	if (ldo == MAX8998_BUCK1 || ldo == MAX8998_BUCK2) {
-		max8998_read_reg(max8998->iodev, MAX8998_REG_ONOFF4, &val);
+		max8998_read_reg(i2c, MAX8998_REG_ONOFF4, &val);
 		if (val & (1 << 4)) {
 			en_ramp = true;
 			previous_vol = max8998_get_voltage(rdev);
 		}
 	}
 
-	ret = max8998_update_reg(max8998->iodev, reg, i<<shift, mask<<shift);
+	ret = max8998_update_reg(i2c, reg, i<<shift, mask<<shift);
 
 	if (en_ramp == true) {
 		int difference = desc->min + desc->step*i - previous_vol/1000;
diff -puN include/linux/mfd/max8998-private.h~mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions include/linux/mfd/max8998-private.h
--- a/include/linux/mfd/max8998-private.h~mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions
+++ a/include/linux/mfd/max8998-private.h
@@ -75,38 +75,18 @@ enum {
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
- * @i2c_client: i2c client private data
- * @dev_read():	chip register read function
- * @dev_write(): chip register write function
- * @dev_update(): chip register update function
+ * @i2c: i2c client private data
  * @iolock: mutex for serializing io access
  */
 
 struct max8998_dev {
 	struct device *dev;
-	struct i2c_client *i2c_client;
-	int (*dev_read)(struct max8998_dev *max8998, u8 reg, u8 *dest);
-	int (*dev_write)(struct max8998_dev *max8998, u8 reg, u8 val);
-	int (*dev_update)(struct max8998_dev *max8998, u8 reg, u8 val, u8 mask);
+	struct i2c_client *i2c;
 	struct mutex iolock;
 };
 
-static inline int max8998_read_reg(struct max8998_dev *max8998, u8 reg,
-				   u8 *value)
-{
-	return max8998->dev_read(max8998, reg, value);
-}
-
-static inline int max8998_write_reg(struct max8998_dev *max8998, u8 reg,
-				    u8 value)
-{
-	return max8998->dev_write(max8998, reg, value);
-}
