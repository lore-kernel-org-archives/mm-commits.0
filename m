From: akpm@linux-foundation.org
Subject: +
 mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch added to
 -mm tree
Date: Mon, 02 Dec 2013 15:15:38 -0800
Message-ID: <529d149a.Cv0kOgrM+DPXhvGY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3LBXPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 18:15:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lgirdwood@gmail.com, lee.jones@linaro.org, kyungmin.park@samsung.com, geert@linux-m68k.org, broonie@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: + mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch added to -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,broonie@linaro.org,geert@linux-m68k.org,kyungmin.park@samsung.com,lee.jones@linaro.org,lgirdwood@gmail.com,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 15:15:38 -0800


The patch titled
     Subject: mfd/rtc: s5m: fix register updating by adding regmap for RTC
has been added to the -mm tree.  Its filename is
     mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: mfd/rtc: s5m: fix register updating by adding regmap for RTC

Rename old regmap field of "struct sec_pmic_dev" to "regmap_pmic" and add
new regmap for RTC.

On S5M8767A registers were not properly updated and read due to usage of
the same regmap as the PMIC.  This could be observed in various hangs,
e.g.  in infinite loop during waiting for UDR field change.

On this chip family the RTC has different I2C address than PMIC so
additional regmap is needed.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviwed-by: Mark Brown <broonie@linaro.org>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sec-core.c           |   30 +++++++++++++++++++++--------
 drivers/mfd/sec-irq.c            |    6 ++---
 drivers/regulator/s5m8767.c      |    2 -
 drivers/rtc/rtc-s5m.c            |    2 -
 include/linux/mfd/samsung/core.h |    3 +-
 5 files changed, 29 insertions(+), 14 deletions(-)

diff -puN drivers/mfd/sec-core.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc drivers/mfd/sec-core.c
--- a/drivers/mfd/sec-core.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc
+++ a/drivers/mfd/sec-core.c
@@ -81,31 +81,31 @@ static struct of_device_id sec_dt_match[
 
 int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 {
-	return regmap_read(sec_pmic->regmap, reg, dest);
+	return regmap_read(sec_pmic->regmap_pmic, reg, dest);
 }
 EXPORT_SYMBOL_GPL(sec_reg_read);
 
 int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_bulk_read(sec_pmic->regmap, reg, buf, count);
+	return regmap_bulk_read(sec_pmic->regmap_pmic, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(sec_bulk_read);
 
 int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value)
 {
-	return regmap_write(sec_pmic->regmap, reg, value);
+	return regmap_write(sec_pmic->regmap_pmic, reg, value);
 }
 EXPORT_SYMBOL_GPL(sec_reg_write);
 
 int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
 {
-	return regmap_raw_write(sec_pmic->regmap, reg, buf, count);
+	return regmap_raw_write(sec_pmic->regmap_pmic, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(sec_bulk_write);
 
 int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask)
 {
-	return regmap_update_bits(sec_pmic->regmap, reg, mask, val);
+	return regmap_update_bits(sec_pmic->regmap_pmic, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(sec_reg_update);
 
@@ -166,6 +166,11 @@ static struct regmap_config s5m8767_regm
 	.cache_type = REGCACHE_FLAT,
 };
 
+static const struct regmap_config sec_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
 #ifdef CONFIG_OF
 /*
  * Only the common platform data elements for s5m8767 are parsed here from the
@@ -266,9 +271,9 @@ static int sec_pmic_probe(struct i2c_cli
 		break;
 	}
 
-	sec_pmic->regmap = devm_regmap_init_i2c(i2c, regmap);
-	if (IS_ERR(sec_pmic->regmap)) {
-		ret = PTR_ERR(sec_pmic->regmap);
+	sec_pmic->regmap_pmic = devm_regmap_init_i2c(i2c, regmap);
+	if (IS_ERR(sec_pmic->regmap_pmic)) {
+		ret = PTR_ERR(sec_pmic->regmap_pmic);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
 		return ret;
@@ -277,6 +282,15 @@ static int sec_pmic_probe(struct i2c_cli
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
+	sec_pmic->regmap_rtc = devm_regmap_init_i2c(sec_pmic->rtc,
+			&sec_rtc_regmap_config);
+	if (IS_ERR(sec_pmic->regmap_rtc)) {
+		ret = PTR_ERR(sec_pmic->regmap_rtc);
+		dev_err(&i2c->dev, "Failed to allocate RTC register map: %d\n",
+			ret);
+		return ret;
+	}
+
 	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
diff -puN drivers/mfd/sec-irq.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc drivers/mfd/sec-irq.c
--- a/drivers/mfd/sec-irq.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc
+++ a/drivers/mfd/sec-irq.c
@@ -280,19 +280,19 @@ int sec_irq_init(struct sec_pmic_dev *se
 
 	switch (type) {
 	case S5M8763X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				  sec_pmic->irq_base, &s5m8763_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
 	case S5M8767X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				  sec_pmic->irq_base, &s5m8767_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
 	case S2MPS11X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				  sec_pmic->irq_base, &s2mps11_irq_chip,
 				  &sec_pmic->irq_data);
diff -puN drivers/regulator/s5m8767.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc drivers/regulator/s5m8767.c
--- a/drivers/regulator/s5m8767.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc
+++ a/drivers/regulator/s5m8767.c
@@ -925,7 +925,7 @@ static int s5m8767_pmic_probe(struct pla
 		config.dev = s5m8767->dev;
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s5m8767;
-		config.regmap = iodev->regmap;
+		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
 
 		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
diff -puN drivers/rtc/rtc-s5m.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc
+++ a/drivers/rtc/rtc-s5m.c
@@ -542,7 +542,7 @@ static int s5m_rtc_probe(struct platform
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->regmap = s5m87xx->regmap;
+	info->regmap = s5m87xx->regmap_rtc;
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
diff -puN include/linux/mfd/samsung/core.h~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc include/linux/mfd/samsung/core.h
--- a/include/linux/mfd/samsung/core.h~mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc
+++ a/include/linux/mfd/samsung/core.h
@@ -39,7 +39,8 @@ enum sec_device_type {
 struct sec_pmic_dev {
 	struct device *dev;
 	struct sec_platform_data *pdata;
-	struct regmap *regmap;
+	struct regmap *regmap_pmic;
+	struct regmap *regmap_rtc;
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-sec-constify-regmap-configs-and-regmap-irqs.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
linux-next.patch

