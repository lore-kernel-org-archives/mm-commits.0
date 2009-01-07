From: akpm@linux-foundation.org
Subject: - adt7470-fix-pwm-at-a-certain-level-during-temperature-sensor-scan.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:16 -0800
Message-ID: <200901072217.n07MHGO5016899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757294AbZAGWSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     adt7470: fix pwm at a certain level during temperature sensor scan
has been removed from the -mm tree.  Its filename was
     adt7470-fix-pwm-at-a-certain-level-during-temperature-sensor-scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7470: fix pwm at a certain level during temperature sensor scan
From: "Darrick J. Wong" <djwong@us.ibm.com>

In the small window that it takes to read the temperature sensors, the pwm
outputs momentarily drop to 0.  This causes a noticeable hiccup in fan
speed, which is slightly annoying.  The solution is to manually program
the pwm output with whatever the automatic value is and then shift the
fans to manual control while reading temperatures.  Once that is done, put
the fans back to whatever mode of control was there before.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7470.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/adt7470.c~adt7470-fix-pwm-at-a-certain-level-during-temperature-sensor-scan drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~adt7470-fix-pwm-at-a-certain-level-during-temperature-sensor-scan
+++ a/drivers/hwmon/adt7470.c
@@ -74,6 +74,7 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define ADT7470_REG_PWM12_CFG			0x68
 #define		ADT7470_PWM2_AUTO_MASK		0x40
 #define		ADT7470_PWM1_AUTO_MASK		0x80
+#define		ADT7470_PWM_AUTO_MASK		0xC0
 #define ADT7470_REG_PWM34_CFG			0x69
 #define		ADT7470_PWM3_AUTO_MASK		0x40
 #define		ADT7470_PWM4_AUTO_MASK		0x80
@@ -223,7 +224,7 @@ static struct adt7470_data *adt7470_upda
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
 	unsigned long local_jiffies = jiffies;
-	u8 cfg;
+	u8 cfg, pwm[4], pwm_cfg[2];
 	int i;
 
 	mutex_lock(&data->lock);
@@ -232,6 +233,24 @@ static struct adt7470_data *adt7470_upda
 		&& data->sensors_valid)
 		goto no_sensor_update;
 
+	/* save pwm[1-4] config register */
+	pwm_cfg[0] = i2c_smbus_read_byte_data(client, ADT7470_REG_PWM_CFG(0));
+	pwm_cfg[1] = i2c_smbus_read_byte_data(client, ADT7470_REG_PWM_CFG(2));
+
+	/* set manual pwm to whatever it is set to now */
+	for (i = 0; i < ADT7470_FAN_COUNT; i++)
+		pwm[i] = i2c_smbus_read_byte_data(client, ADT7470_REG_PWM(i));
+
+	/* put pwm in manual mode */
+	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(0),
+		pwm_cfg[0] & ~(ADT7470_PWM_AUTO_MASK));
+	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(2),
+		pwm_cfg[1] & ~(ADT7470_PWM_AUTO_MASK));
+
+	/* write pwm control to whatever it was */
+	for (i = 0; i < ADT7470_FAN_COUNT; i++)
+		i2c_smbus_write_byte_data(client, ADT7470_REG_PWM(i), pwm[i]);
+
 	/* start reading temperature sensors */
 	cfg = i2c_smbus_read_byte_data(client, ADT7470_REG_CFG);
 	cfg |= 0x80;
@@ -249,6 +268,10 @@ static struct adt7470_data *adt7470_upda
 	cfg &= ~0x80;
 	i2c_smbus_write_byte_data(client, ADT7470_REG_CFG, cfg);
 
+	/* restore pwm[1-4] config registers */
+	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(0), pwm_cfg[0]);
+	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(2), pwm_cfg[1]);
+
 	for (i = 0; i < ADT7470_TEMP_COUNT; i++)
 		data->temp[i] = i2c_smbus_read_byte_data(client,
 						ADT7470_TEMP_REG(i));
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
fakephp-allocate-pci-resources-before-adding-the-device.patch

