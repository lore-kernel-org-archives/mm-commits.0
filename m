From: akpm@linux-foundation.org
Subject: + regulator-implement-list_voltage-for-wm8400-dcdcs-and-ldos.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:36:54 -0700
Message-ID: <200903112036.n2BKataR001268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbZCKUij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk


The patch titled
     regulator: implement list_voltage() for WM8400 DCDCs and LDOs
has been added to the -mm tree.  Its filename is
     regulator-implement-list_voltage-for-wm8400-dcdcs-and-ldos.patch

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
Subject: regulator: implement list_voltage() for WM8400 DCDCs and LDOs
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

All DCDCs and LDOs are identical.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/wm8400-regulator.c |   34 ++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 4 deletions(-)

diff -puN drivers/regulator/wm8400-regulator.c~regulator-implement-list_voltage-for-wm8400-dcdcs-and-ldos drivers/regulator/wm8400-regulator.c
--- a/drivers/regulator/wm8400-regulator.c~regulator-implement-list_voltage-for-wm8400-dcdcs-and-ldos
+++ a/drivers/regulator/wm8400-regulator.c
@@ -43,6 +43,18 @@ static int wm8400_ldo_disable(struct reg
 			       WM8400_LDO1_ENA, 0);
 }
 
+static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
+				   unsigned selector)
+{
+	if (selector > WM8400_LDO1_VSEL_MASK)
+		return -EINVAL;
+
+	if (selector < 15)
+		return 900000 + (selector * 50000);
+	else
+		return 1600000 + ((selector - 14) * 100000);
+}
+
 static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
@@ -51,10 +63,7 @@ static int wm8400_ldo_get_voltage(struct
 	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
 	val &= WM8400_LDO1_VSEL_MASK;
 
-	if (val < 15)
-		return 900000 + (val * 50000);
-	else
-		return 1600000 + ((val - 14) * 100000);
+	return wm8400_ldo_list_voltage(dev, val);
 }
 
 static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
@@ -92,6 +101,7 @@ static struct regulator_ops wm8400_ldo_o
 	.is_enabled = wm8400_ldo_is_enabled,
 	.enable = wm8400_ldo_enable,
 	.disable = wm8400_ldo_disable,
+	.list_voltage = wm8400_ldo_list_voltage,
 	.get_voltage = wm8400_ldo_get_voltage,
 	.set_voltage = wm8400_ldo_set_voltage,
 };
@@ -124,6 +134,15 @@ static int wm8400_dcdc_disable(struct re
 			       WM8400_DC1_ENA, 0);
 }
 
+static int wm8400_dcdc_list_voltage(struct regulator_dev *dev,
+				    unsigned selector)
+{
+	if (selector > WM8400_DC1_VSEL_MASK)
+		return -EINVAL;
+
+	return 850000 + (selector * 25000);
+}
+
 static int wm8400_dcdc_get_voltage(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
@@ -237,6 +256,7 @@ static struct regulator_ops wm8400_dcdc_
 	.is_enabled = wm8400_dcdc_is_enabled,
 	.enable = wm8400_dcdc_enable,
 	.disable = wm8400_dcdc_disable,
+	.list_voltage = wm8400_dcdc_list_voltage,
 	.get_voltage = wm8400_dcdc_get_voltage,
 	.set_voltage = wm8400_dcdc_set_voltage,
 	.get_mode = wm8400_dcdc_get_mode,
@@ -249,6 +269,7 @@ static struct regulator_desc regulators[
 		.name = "LDO1",
 		.id = WM8400_LDO1,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO1_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -256,6 +277,7 @@ static struct regulator_desc regulators[
 		.name = "LDO2",
 		.id = WM8400_LDO2,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO2_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -263,6 +285,7 @@ static struct regulator_desc regulators[
 		.name = "LDO3",
 		.id = WM8400_LDO3,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO3_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -270,6 +293,7 @@ static struct regulator_desc regulators[
 		.name = "LDO4",
 		.id = WM8400_LDO4,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO4_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -277,6 +301,7 @@ static struct regulator_desc regulators[
 		.name = "DCDC1",
 		.id = WM8400_DCDC1,
 		.ops = &wm8400_dcdc_ops,
+		.n_voltages = WM8400_DC1_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -284,6 +309,7 @@ static struct regulator_desc regulators[
 		.name = "DCDC2",
 		.id = WM8400_DCDC2,
 		.ops = &wm8400_dcdc_ops,
+		.n_voltages = WM8400_DC2_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
regulator-implement-list_voltage-for-wm8400-dcdcs-and-ldos.patch
regulator-dont-warn-on-omitted-voltage-constraints.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

