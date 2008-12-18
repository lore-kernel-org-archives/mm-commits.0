From: akpm@linux-foundation.org
Subject: - battery-add-prerequisites-for-dialog-da9030-battery-charger-driver.patch removed from -mm tree
Date: Thu, 18 Dec 2008 14:52:48 -0800
Message-ID: <200812182252.mBIMqnZB026639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbYLRWxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 17:53:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, cbouatmailru@gmail.com, dwmw2@infradead.org, eric.miao@marvell.com, jic23@cam.ac.uk, sameo@openedhand.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     battery: add prerequisites for Dialog DA9030 battery charger driver
has been removed from the -mm tree.  Its filename was
     battery-add-prerequisites-for-dialog-da9030-battery-charger-driver.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: battery: add prerequisites for Dialog DA9030 battery charger driver
From: Mike Rapoport <mike@compulab.co.il>

This patch amends DA903x MFD driver with definitions and methods needed
for battery charger driver.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Eric Miao <eric.miao@marvell.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/da903x.c       |   12 +++++++++
 include/linux/mfd/da903x.h |   44 +++++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/da903x.c~battery-add-prerequisites-for-dialog-da9030-battery-charger-driver drivers/mfd/da903x.c
--- a/drivers/mfd/da903x.c~battery-add-prerequisites-for-dialog-da9030-battery-charger-driver
+++ a/drivers/mfd/da903x.c
@@ -151,12 +151,24 @@ int da903x_write(struct device *dev, int
 }
 EXPORT_SYMBOL_GPL(da903x_write);
 
+int da903x_writes(struct device *dev, int reg, int len, uint8_t *val)
+{
+	return __da903x_writes(to_i2c_client(dev), reg, len, val);
+}
+EXPORT_SYMBOL_GPL(da903x_writes);
+
 int da903x_read(struct device *dev, int reg, uint8_t *val)
 {
 	return __da903x_read(to_i2c_client(dev), reg, val);
 }
 EXPORT_SYMBOL_GPL(da903x_read);
 
+int da903x_reads(struct device *dev, int reg, int len, uint8_t *val)
+{
+	return __da903x_reads(to_i2c_client(dev), reg, len, val);
+}
+EXPORT_SYMBOL_GPL(da903x_reads);
+
 int da903x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
 {
 	struct da903x_chip *chip = dev_get_drvdata(dev);
diff -puN include/linux/mfd/da903x.h~battery-add-prerequisites-for-dialog-da9030-battery-charger-driver include/linux/mfd/da903x.h
--- a/include/linux/mfd/da903x.h~battery-add-prerequisites-for-dialog-da9030-battery-charger-driver
+++ a/include/linux/mfd/da903x.h
@@ -32,6 +32,7 @@ enum {
 	DA9030_ID_LDO18,
 	DA9030_ID_LDO19,
 	DA9030_ID_LDO_INT,	/* LDO Internal */
+	DA9030_ID_BAT,		/* battery charger */
 
 	DA9034_ID_LED_1,
 	DA9034_ID_LED_2,
@@ -93,6 +94,43 @@ struct da9034_touch_pdata {
 	int	y_inverted;
 };
 
+/* DA9030 battery charger data */
+struct power_supply_info;
+
+struct da9030_battery_info {
+	/* battery parameters */
+	struct power_supply_info *battery_info;
+
+	/* current and voltage to use for battery charging */
+	unsigned int charge_milliamp;
+	unsigned int charge_millivolt;
+
+	/* voltage thresholds (in millivolts) */
+	int vbat_low;
+	int vbat_crit;
+	int vbat_charge_start;
+	int vbat_charge_stop;
+	int vbat_charge_restart;
+
+	/* battery nominal minimal and maximal voltages in millivolts */
+	int vcharge_min;
+	int vcharge_max;
+
+	/* Temperature thresholds. These are DA9030 register values
+	   "as is" and should be measured for each battery type */
+	int tbat_low;
+	int tbat_high;
+	int tbat_restart;
+
+
+	/* battery monitor interval (seconds) */
+	unsigned int batmon_interval;
+
+	/* platform callbacks for battery low and critical events */
+	void (*battery_low)(void);
+	void (*battery_critical)(void);
+};
+
 struct da903x_subdev_info {
 	int		id;
 	const char	*name;
@@ -190,11 +228,13 @@ extern int da903x_unregister_notifier(st
 extern int da903x_query_status(struct device *dev, unsigned int status);
 
 
-/* NOTE: the two functions below are not intended for use outside
- * of the DA9034 sub-device drivers
+/* NOTE: the functions below are not intended for use outside
+ * of the DA903x sub-device drivers
  */
 extern int da903x_write(struct device *dev, int reg, uint8_t val);
+extern int da903x_writes(struct device *dev, int reg, int len, uint8_t *val);
 extern int da903x_read(struct device *dev, int reg, uint8_t *val);
+extern int da903x_reads(struct device *dev, int reg, int len, uint8_t *val);
 extern int da903x_update(struct device *dev, int reg, uint8_t val, uint8_t mask);
 extern int da903x_set_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int da903x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
_

Patches currently in -mm which might be from mike@compulab.co.il are

linux-next.patch
battery-add-prerequisites-for-dialog-da9030-battery-charger-driver.patch
battery-add-dialog-da9030-battery-charger-driver.patch

