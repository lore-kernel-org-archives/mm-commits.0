From: akpm@linux-foundation.org
Subject: + ad525x_dpot-add-support-for-one-time-programmable-pots.patch added to -mm tree
Date: Mon, 10 May 2010 15:11:38 -0700
Message-ID: <201005102211.o4AMBcSS025623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850Ab0EJWLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     ad525x_dpot: add support for one time programmable pots
has been added to the -mm tree.  Its filename is
     ad525x_dpot-add-support-for-one-time-programmable-pots.patch

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
Subject: ad525x_dpot: add support for one time programmable pots
From: Michael Hennerich <michael.hennerich@analog.com>

New parts supported:
	AD5170, AD5171, AD5172, AD5173, AD5273

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig           |    2 
 drivers/misc/ad525x_dpot-i2c.c |    5 +
 drivers/misc/ad525x_dpot.c     |  121 +++++++++++++++++++++++++++++--
 drivers/misc/ad525x_dpot.h     |   42 +++++++---
 4 files changed, 150 insertions(+), 20 deletions(-)

diff -puN drivers/misc/Kconfig~ad525x_dpot-add-support-for-one-time-programmable-pots drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~ad525x_dpot-add-support-for-one-time-programmable-pots
+++ a/drivers/misc/Kconfig
@@ -24,7 +24,7 @@ config AD525X_DPOT
 	  AD5260, AD5262, AD5263, AD5290, AD5291, AD5292, AD5293,
 	  AD7376, AD8400, AD8402, AD8403, ADN2850, AD5241, AD5242,
 	  AD5243, AD5245, AD5246, AD5247, AD5248, AD5280, AD5282,
-	  ADN2860
+	  ADN2860, AD5273, AD5171, AD5170, AD5172, AD5173
 	  digital potentiometer chips.
 
 	  See Documentation/misc-devices/ad525x_dpot.txt for the
diff -puN drivers/misc/ad525x_dpot-i2c.c~ad525x_dpot-add-support-for-one-time-programmable-pots drivers/misc/ad525x_dpot-i2c.c
--- a/drivers/misc/ad525x_dpot-i2c.c~ad525x_dpot-add-support-for-one-time-programmable-pots
+++ a/drivers/misc/ad525x_dpot-i2c.c
@@ -97,6 +97,11 @@ static const struct i2c_device_id ad_dpo
 	{"ad5280", AD5280_ID},
 	{"ad5282", AD5282_ID},
 	{"adn2860", ADN2860_ID},
+	{"ad5273", AD5273_ID},
+	{"ad5171", AD5171_ID},
+	{"ad5170", AD5170_ID},
+	{"ad5172", AD5172_ID},
+	{"ad5173", AD5173_ID},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, ad_dpot_id);
diff -puN drivers/misc/ad525x_dpot.c~ad525x_dpot-add-support-for-one-time-programmable-pots drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~ad525x_dpot-add-support-for-one-time-programmable-pots
+++ a/drivers/misc/ad525x_dpot.c
@@ -47,6 +47,11 @@
  * AD5280		1		256		20, 50, 200
  * AD5282		2		256		20, 50, 200
  * ADN2860		3		512		25, 250
+ * AD5273		1		64		1, 10, 50, 100 (OTP)
+ * AD5171		1		64		5, 10, 50, 100 (OTP)
+ * AD5170		1		256		2.5, 10, 50, 100 (OTP)
+ * AD5172		2		256		2.5, 10, 50, 100 (OTP)
+ * AD5173		2		256		2.5, 10, 50, 100 (OTP)
  *
  * See Documentation/misc-devices/ad525x_dpot.txt for more info.
  *
@@ -83,7 +88,8 @@ struct dpot_data {
 	unsigned uid;
 	unsigned feat;
 	unsigned wipers;
-	u16 rdac_cache[8];
+	u16 rdac_cache[MAX_RDACS];
+	DECLARE_BITMAP(otp_en_mask, MAX_RDACS);
 };
 
 static inline int dpot_read_d8(struct dpot_data *dpot)
@@ -161,6 +167,15 @@ static s32 dpot_read_i2c(struct dpot_dat
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
 			0 : DPOT_AD5291_RDAC_AB;
 		return dpot_read_r8d8(dpot, ctrl);
+	case DPOT_UID(AD5170_ID):
+	case DPOT_UID(AD5171_ID):
+	case DPOT_UID(AD5273_ID):
+			return dpot_read_d8(dpot);
+	case DPOT_UID(AD5172_ID):
+	case DPOT_UID(AD5173_ID):
+		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
+			0 : DPOT_AD5272_3_A0;
+		return dpot_read_r8d8(dpot, ctrl);
 	default:
 		if ((reg & DPOT_REG_TOL) || (dpot->max_pos > 256))
 			return dpot_read_r8d16(dpot, (reg & 0xF8) |
@@ -241,7 +256,7 @@ static s32 dpot_write_spi(struct dpot_da
 static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 {
 	/* Only write the instruction byte for certain commands */
-	unsigned ctrl = 0;
+	unsigned tmp = 0, ctrl = 0;
 
 	switch (dpot->uid) {
 	case DPOT_UID(AD5246_ID):
@@ -260,6 +275,37 @@ static s32 dpot_write_i2c(struct dpot_da
 			0 : DPOT_AD5291_RDAC_AB;
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
+	case DPOT_UID(AD5171_ID):
+	case DPOT_UID(AD5273_ID):
+		if (reg & DPOT_ADDR_OTP) {
+			tmp = dpot_read_d8(dpot);
+			if (tmp >> 6) /* Ready to Program? */
+				return -EFAULT;
+			ctrl = DPOT_AD5273_FUSE;
+		}
+		return dpot_write_r8d8(dpot, ctrl, value);
+		break;
+	case DPOT_UID(AD5172_ID):
+	case DPOT_UID(AD5173_ID):
+		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
+			0 : DPOT_AD5272_3_A0;
+		if (reg & DPOT_ADDR_OTP) {
+			tmp = dpot_read_r8d16(dpot, ctrl);
+			if (tmp >> 14) /* Ready to Program? */
+				return -EFAULT;
+			ctrl |= DPOT_AD5270_2_3_FUSE;
+		}
+		return dpot_write_r8d8(dpot, ctrl, value);
+		break;
+	case DPOT_UID(AD5170_ID):
+		if (reg & DPOT_ADDR_OTP) {
+			tmp = dpot_read_r8d16(dpot, tmp);
+			if (tmp >> 14) /* Ready to Program? */
+				return -EFAULT;
+			ctrl = DPOT_AD5270_2_3_FUSE;
+		}
+		return dpot_write_r8d8(dpot, ctrl, value);
+		break;
 	default:
 		if (reg & DPOT_ADDR_CMD)
 			return dpot_write_d8(dpot, reg);
@@ -291,6 +337,12 @@ static ssize_t sysfs_show_reg(struct dev
 	struct dpot_data *data = dev_get_drvdata(dev);
 	s32 value;
 
+	if (reg & DPOT_ADDR_OTP_EN)
+		return sprintf(buf, "%s\n",
+			test_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask) ?
+			"enabled" : "disabled");
+
+
 	mutex_lock(&data->update_lock);
 	value = dpot_read(data, reg);
 	mutex_unlock(&data->update_lock);
@@ -319,6 +371,19 @@ static ssize_t sysfs_set_reg(struct devi
 	unsigned long value;
 	int err;
 
+	if (reg & DPOT_ADDR_OTP_EN) {
+		if (!strncmp(buf, "enabled", sizeof("enabled")))
+			set_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask);
+		else
+			clear_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask);
+
+		return count;
+	}
+
+	if ((reg & DPOT_ADDR_OTP) &&
+		!test_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask))
+		return -EPERM;
+
 	err = strict_strtoul(buf, 10, &value);
 	if (err)
 		return err;
@@ -330,6 +395,8 @@ static ssize_t sysfs_set_reg(struct devi
 	dpot_write(data, reg, value);
 	if (reg & DPOT_ADDR_EEPROM)
 		msleep(26);	/* Sleep while the EEPROM updates */
+	else if (reg & DPOT_ADDR_OTP)
+		msleep(400);	/* Sleep while the OTP updates */
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -377,26 +444,38 @@ static DEVICE_ATTR(name, S_IWUSR | S_IRU
 DPOT_DEVICE_SHOW_SET(rdac0, DPOT_ADDR_RDAC | DPOT_RDAC0);
 DPOT_DEVICE_SHOW_SET(eeprom0, DPOT_ADDR_EEPROM | DPOT_RDAC0);
 DPOT_DEVICE_SHOW_ONLY(tolerance0, DPOT_ADDR_EEPROM | DPOT_TOL_RDAC0);
+DPOT_DEVICE_SHOW_SET(otp0, DPOT_ADDR_OTP | DPOT_RDAC0);
+DPOT_DEVICE_SHOW_SET(otp0en, DPOT_ADDR_OTP_EN | DPOT_RDAC0);
 
 DPOT_DEVICE_SHOW_SET(rdac1, DPOT_ADDR_RDAC | DPOT_RDAC1);
 DPOT_DEVICE_SHOW_SET(eeprom1, DPOT_ADDR_EEPROM | DPOT_RDAC1);
 DPOT_DEVICE_SHOW_ONLY(tolerance1, DPOT_ADDR_EEPROM | DPOT_TOL_RDAC1);
+DPOT_DEVICE_SHOW_SET(otp1, DPOT_ADDR_OTP | DPOT_RDAC1);
+DPOT_DEVICE_SHOW_SET(otp1en, DPOT_ADDR_OTP_EN | DPOT_RDAC1);
 
 DPOT_DEVICE_SHOW_SET(rdac2, DPOT_ADDR_RDAC | DPOT_RDAC2);
 DPOT_DEVICE_SHOW_SET(eeprom2, DPOT_ADDR_EEPROM | DPOT_RDAC2);
 DPOT_DEVICE_SHOW_ONLY(tolerance2, DPOT_ADDR_EEPROM | DPOT_TOL_RDAC2);
+DPOT_DEVICE_SHOW_SET(otp2, DPOT_ADDR_OTP | DPOT_RDAC2);
+DPOT_DEVICE_SHOW_SET(otp2en, DPOT_ADDR_OTP_EN | DPOT_RDAC2);
 
 DPOT_DEVICE_SHOW_SET(rdac3, DPOT_ADDR_RDAC | DPOT_RDAC3);
 DPOT_DEVICE_SHOW_SET(eeprom3, DPOT_ADDR_EEPROM | DPOT_RDAC3);
 DPOT_DEVICE_SHOW_ONLY(tolerance3, DPOT_ADDR_EEPROM | DPOT_TOL_RDAC3);
+DPOT_DEVICE_SHOW_SET(otp3, DPOT_ADDR_OTP | DPOT_RDAC3);
+DPOT_DEVICE_SHOW_SET(otp3en, DPOT_ADDR_OTP_EN | DPOT_RDAC3);
 
 DPOT_DEVICE_SHOW_SET(rdac4, DPOT_ADDR_RDAC | DPOT_RDAC4);
 DPOT_DEVICE_SHOW_SET(eeprom4, DPOT_ADDR_EEPROM | DPOT_RDAC4);
 DPOT_DEVICE_SHOW_ONLY(tolerance4, DPOT_ADDR_EEPROM | DPOT_TOL_RDAC4);
+DPOT_DEVICE_SHOW_SET(otp4, DPOT_ADDR_OTP | DPOT_RDAC4);
+DPOT_DEVICE_SHOW_SET(otp4en, DPOT_ADDR_OTP_EN | DPOT_RDAC4);
 
 DPOT_DEVICE_SHOW_SET(rdac5, DPOT_ADDR_RDAC | DPOT_RDAC5);
 DPOT_DEVICE_SHOW_SET(eeprom5, DPOT_ADDR_EEPROM | DPOT_RDAC5);
 DPOT_DEVICE_SHOW_ONLY(tolerance5, DPOT_ADDR_EEPROM | DPOT_TOL_RDAC5);
+DPOT_DEVICE_SHOW_SET(otp5, DPOT_ADDR_OTP | DPOT_RDAC5);
+DPOT_DEVICE_SHOW_SET(otp5en, DPOT_ADDR_OTP_EN | DPOT_RDAC5);
 
 static const struct attribute *dpot_attrib_wipers[] = {
 	&dev_attr_rdac0.attr,
@@ -418,6 +497,26 @@ static const struct attribute *dpot_attr
 	NULL
 };
 
+static const struct attribute *dpot_attrib_otp[] = {
+	&dev_attr_otp0.attr,
+	&dev_attr_otp1.attr,
+	&dev_attr_otp2.attr,
+	&dev_attr_otp3.attr,
+	&dev_attr_otp4.attr,
+	&dev_attr_otp5.attr,
+	NULL
+};
+
+static const struct attribute *dpot_attrib_otp_en[] = {
+	&dev_attr_otp0en.attr,
+	&dev_attr_otp1en.attr,
+	&dev_attr_otp2en.attr,
+	&dev_attr_otp3en.attr,
+	&dev_attr_otp4en.attr,
+	&dev_attr_otp5en.attr,
+	NULL
+};
+
 static const struct attribute *dpot_attrib_tolerance[] = {
 	&dev_attr_tolerance0.attr,
 	&dev_attr_tolerance1.attr,
@@ -467,6 +566,12 @@ __devinit int ad_dpot_add_files(struct d
 	if (features & F_CMD_TOL)
 		err |= sysfs_create_file(&dev->kobj,
 			dpot_attrib_tolerance[rdac]);
+	if (features & F_CMD_OTP) {
+		err |= sysfs_create_file(&dev->kobj,
+			dpot_attrib_otp_en[rdac]);
+		err |= sysfs_create_file(&dev->kobj,
+			dpot_attrib_otp[rdac]);
+	}
 
 	if (err)
 		dev_err(dev, "failed to register sysfs hooks for RDAC%d\n",
@@ -486,6 +591,12 @@ inline void ad_dpot_remove_files(struct 
 	if (features & F_CMD_TOL)
 		sysfs_remove_file(&dev->kobj,
 			dpot_attrib_tolerance[rdac]);
+	if (features & F_CMD_OTP) {
+		sysfs_remove_file(&dev->kobj,
+			dpot_attrib_otp_en[rdac]);
+		sysfs_remove_file(&dev->kobj,
+			dpot_attrib_otp[rdac]);
+	}
 }
 
 __devinit int ad_dpot_probe(struct device *dev,
@@ -513,7 +624,7 @@ __devinit int ad_dpot_probe(struct devic
 	data->uid = DPOT_UID(data->devid);
 	data->wipers = DPOT_WIPERS(data->devid);
 
-	for (i = DPOT_RDAC0; i <= DPOT_RDAC5; i++)
+	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
 		if (data->wipers & (1 << i)) {
 			err = ad_dpot_add_files(dev, data->feat, i);
 			if (err)
@@ -537,7 +648,7 @@ __devinit int ad_dpot_probe(struct devic
 	return 0;
 
 exit_remove_files:
-	for (i = DPOT_RDAC0; i <= DPOT_RDAC5; i++)
+	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
 		if (data->wipers & (1 << i))
 			ad_dpot_remove_files(dev, data->feat, i);
 
@@ -556,7 +667,7 @@ __devexit int ad_dpot_remove(struct devi
 	struct dpot_data *data = dev_get_drvdata(dev);
 	int i;
 
-	for (i = DPOT_RDAC0; i <= DPOT_RDAC5; i++)
+	for (i = DPOT_RDAC0; i < MAX_RDACS; i++)
 		if (data->wipers & (1 << i))
 			ad_dpot_remove_files(dev, data->feat, i);
 
diff -puN drivers/misc/ad525x_dpot.h~ad525x_dpot-add-support-for-one-time-programmable-pots drivers/misc/ad525x_dpot.h
--- a/drivers/misc/ad525x_dpot.h~ad525x_dpot-add-support-for-one-time-programmable-pots
+++ a/drivers/misc/ad525x_dpot.h
@@ -15,17 +15,18 @@
 		(((features) << 18) | (((wipers) & 0xFF) << 10) | \
 		((max_pos & 0xF) << 6) | (uid & 0x3F))
 
-#define DPOT_UID(conf) (conf & 0x3F)
-#define DPOT_MAX_POS(conf) ((conf >> 6) & 0xF)
-#define DPOT_WIPERS(conf) ((conf >> 10) & 0xFF)
-#define DPOT_FEAT(conf) (conf >> 18)
-
-#define BRDAC0	(1 << 0)
-#define BRDAC1	(1 << 1)
-#define BRDAC2	(1 << 2)
-#define BRDAC3	(1 << 3)
-#define BRDAC4	(1 << 4)
-#define BRDAC5	(1 << 5)
+#define DPOT_UID(conf)		(conf & 0x3F)
+#define DPOT_MAX_POS(conf)	((conf >> 6) & 0xF)
+#define DPOT_WIPERS(conf)	((conf >> 10) & 0xFF)
+#define DPOT_FEAT(conf)		(conf >> 18)
+
+#define BRDAC0			(1 << 0)
+#define BRDAC1			(1 << 1)
+#define BRDAC2			(1 << 2)
+#define BRDAC3			(1 << 3)
+#define BRDAC4			(1 << 4)
+#define BRDAC5			(1 << 5)
+#define MAX_RDACS		6
 
 #define F_CMD_INC		(1 << 0)	/* Features INC/DEC ALL, 6dB */
 #define F_CMD_EEP		(1 << 1)	/* Features EEPROM */
@@ -116,6 +117,11 @@ enum dpot_devid {
 	AD5282_ID = DPOT_CONF(F_RDACS_RW, BRDAC0 | BRDAC1, 8, 41),
 	ADN2860_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
 			BRDAC0 | BRDAC1 | BRDAC2, 9, 42),
+	AD5273_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0, 6, 43),
+	AD5171_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0, 6, 44),
+	AD5170_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0, 8, 45),
+	AD5172_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0 | BRDAC1, 8, 46),
+	AD5173_ID = DPOT_CONF(F_RDACS_RW | F_CMD_OTP, BRDAC0 | BRDAC1, 8, 47),
 };
 
 #define DPOT_RDAC0		0
@@ -136,9 +142,11 @@ enum dpot_devid {
 #define DPOT_TOL_RDAC5		(DPOT_REG_TOL | DPOT_RDAC5)
 
 /* RDAC-to-EEPROM Interface Commands */
-#define DPOT_ADDR_RDAC		(0x00 << 5)
-#define DPOT_ADDR_EEPROM	(0x01 << 5)
-#define DPOT_ADDR_CMD		(0x80)
+#define DPOT_ADDR_RDAC		(0x0 << 5)
+#define DPOT_ADDR_EEPROM	(0x1 << 5)
+#define DPOT_ADDR_OTP		(0x1 << 6)
+#define DPOT_ADDR_CMD		(0x1 << 7)
+#define DPOT_ADDR_OTP_EN	(0x1 << 9)
 
 #define DPOT_DEC_ALL_6DB	(DPOT_ADDR_CMD | (0x4 << 3))
 #define DPOT_INC_ALL_6DB	(DPOT_ADDR_CMD | (0x9 << 3))
@@ -161,6 +169,12 @@ enum dpot_devid {
 /* AD524x use special commands */
 #define DPOT_AD5291_RDAC_AB	0x80
 
+#define DPOT_AD5273_FUSE	0x80
+#define DPOT_AD5270_2_3_FUSE	0x20
+#define DPOT_AD5270_2_3_OW	0x08
+#define DPOT_AD5272_3_A0	0x08
+#define DPOT_AD5270_2FUSE	0x80
+
 struct dpot_data;
 
 struct ad_dpot_bus_ops {
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

fbdev-bfin-t350mcqb-fb-fix-fbmem-allocation-with-blanking-lines.patch
linux-next.patch
backlight-new-driver-for-the-adp8860-backlight-parts.patch
ad525x_dpot-simplify-duplicated-sysfs-defines.patch
ad525x_dpot-extend-write-argument-to-16bits.patch
ad525x_dpot-add-support-for-spi-parts.patch
ad525x_dpot-add-support-for-ad524x-pots.patch
ad525x_dpot-add-support-for-adn2860-and-ad528x-pots.patch
ad525x_dpot-add-support-for-one-time-programmable-pots.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch

