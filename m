From: akpm@linux-foundation.org
Subject: - tosa-add-support-for-power_supply.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:23 -0700
Message-ID: <200807020747.m627lN5V005645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbYGBHsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, cbou@mail.ru, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tosa: add support for power_supply
has been removed from the -mm tree.  Its filename was
     tosa-add-support-for-power_supply.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tosa: add support for power_supply
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Support the battery management on Sharp Zaurus SL-6000.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig        |    7 
 drivers/power/Makefile       |    1 
 drivers/power/tosa_battery.c |  485 +++++++++++++++++++++++++++++++++
 3 files changed, 493 insertions(+)

diff -puN drivers/power/Kconfig~tosa-add-support-for-power_supply drivers/power/Kconfig
--- a/drivers/power/Kconfig~tosa-add-support-for-power_supply
+++ a/drivers/power/Kconfig
@@ -49,4 +49,11 @@ config BATTERY_OLPC
 	help
 	  Say Y to enable support for the battery on the OLPC laptop.
 
+config BATTERY_TOSA
+	tristate "Sharp SL-6000 (tosa) battery"
+	depends on MACH_TOSA && MFD_TC6393XB
+	help
+	  Say Y to enable support for the battery on the Sharp Zaurus
+	  SL-6000 (tosa) models.
+
 endif # POWER_SUPPLY
diff -puN drivers/power/Makefile~tosa-add-support-for-power_supply drivers/power/Makefile
--- a/drivers/power/Makefile~tosa-add-support-for-power_supply
+++ a/drivers/power/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_APM_POWER)		+= apm_power.o
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
+obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
diff -puN /dev/null drivers/power/tosa_battery.c
--- /dev/null
+++ a/drivers/power/tosa_battery.c
@@ -0,0 +1,485 @@
+/*
+ * Battery and Power Management code for the Sharp SL-6000x
+ *
+ * Copyright (c) 2005 Dirk Opfer
+ * Copyright (c) 2008 Dmitry Baryshkov
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/power_supply.h>
+#include <linux/wm97xx.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <asm/mach-types.h>
+#include <asm/arch/tosa.h>
+
+static DEFINE_MUTEX(bat_lock); /* protects gpio pins */
+static struct work_struct bat_work;
+
+struct tosa_bat {
+	int status;
+	struct power_supply psy;
+	int full_chrg;
+
+	struct mutex work_lock; /* protects data */
+
+	bool (*is_present)(struct tosa_bat *bat);
+	int gpio_full;
+	int gpio_charge_off;
+
+	int technology;
+
+	int gpio_bat;
+	int adc_bat;
+	int adc_bat_divider;
+	int bat_max;
+	int bat_min;
+
+	int gpio_temp;
+	int adc_temp;
+	int adc_temp_divider;
+};
+
+static struct tosa_bat tosa_bat_main;
+static struct tosa_bat tosa_bat_jacket;
+
+static unsigned long tosa_read_bat(struct tosa_bat *bat)
+{
+	unsigned long value = 0;
+
+	if (bat->gpio_bat < 0 || bat->adc_bat < 0)
+		return 0;
+
+	mutex_lock(&bat_lock);
+	gpio_set_value(bat->gpio_bat, 1);
+	mdelay(5);
+	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
+			bat->adc_bat);
+	gpio_set_value(bat->gpio_bat, 0);
+	mutex_unlock(&bat_lock);
+
+	value = value * 1000000 / bat->adc_bat_divider;
+
+	return value;
+}
+
+static unsigned long tosa_read_temp(struct tosa_bat *bat)
+{
+	unsigned long value = 0;
+
+	if (bat->gpio_temp < 0 || bat->adc_temp < 0)
+		return 0;
+
+	mutex_lock(&bat_lock);
+	gpio_set_value(bat->gpio_temp, 1);
+	mdelay(5);
+	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
+			bat->adc_temp);
+	gpio_set_value(bat->gpio_temp, 0);
+	mutex_unlock(&bat_lock);
+
+	value = value * 10000 / bat->adc_temp_divider;
+
+	return value;
+}
+
+static int tosa_bat_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	int ret = 0;
+	struct tosa_bat *bat = container_of(psy, struct tosa_bat, psy);
+
+	if (bat->is_present && !bat->is_present(bat)
+			&& psp != POWER_SUPPLY_PROP_PRESENT) {
+		return -ENODEV;
+	}
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = bat->status;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = bat->technology;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = tosa_read_bat(bat);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
+		if (bat->full_chrg == -1)
+			val->intval = bat->bat_max;
+		else
+			val->intval = bat->full_chrg;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = bat->bat_max;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = bat->bat_min;
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = tosa_read_temp(bat);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = bat->is_present ? bat->is_present(bat) : 1;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static bool tosa_jacket_bat_is_present(struct tosa_bat *bat)
+{
+	return gpio_get_value(TOSA_GPIO_JACKET_DETECT) == 0;
+}
+
+static void tosa_bat_external_power_changed(struct power_supply *psy)
+{
+	schedule_work(&bat_work);
+}
+
+static irqreturn_t tosa_bat_gpio_isr(int irq, void *data)
+{
+	printk(KERN_ERR "bat_gpio irq: %d\n", gpio_get_value(irq_to_gpio(irq)));
+	schedule_work(&bat_work);
+	return IRQ_HANDLED;
+}
+
+static char *status_text[] = {
+	[POWER_SUPPLY_STATUS_UNKNOWN] =		"Unknown",
+	[POWER_SUPPLY_STATUS_CHARGING] =	"Charging",
+	[POWER_SUPPLY_STATUS_DISCHARGING] =	"Discharging",
+	[POWER_SUPPLY_STATUS_NOT_CHARGING] =	"Not charging",
+	[POWER_SUPPLY_STATUS_FULL] =		"Full",
+};
+
+static void tosa_bat_update(struct tosa_bat *bat)
+{
+	int old;
+	struct power_supply *psy = &bat->psy;
+
+	mutex_lock(&bat->work_lock);
+
+	old = bat->status;
+
+	if (bat->is_present && !bat->is_present(bat)) {
+		printk(KERN_NOTICE "%s not present\n", psy->name);
+		bat->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		bat->full_chrg = -1;
+	} else if (power_supply_am_i_supplied(psy)) {
+		if (bat->status == POWER_SUPPLY_STATUS_DISCHARGING) {
+			gpio_set_value(bat->gpio_charge_off, 0);
+			mdelay(15);
+		}
+
+		if (gpio_get_value(bat->gpio_full)) {
+			if (old == POWER_SUPPLY_STATUS_CHARGING ||
+					bat->full_chrg == -1)
+				bat->full_chrg = tosa_read_bat(bat);
+
+			gpio_set_value(bat->gpio_charge_off, 1);
+			bat->status = POWER_SUPPLY_STATUS_FULL;
+		} else {
+			gpio_set_value(bat->gpio_charge_off, 0);
+			bat->status = POWER_SUPPLY_STATUS_CHARGING;
+		}
+	} else {
+		gpio_set_value(bat->gpio_charge_off, 1);
+		bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	}
+
+	if (old != bat->status) {
+		printk(KERN_NOTICE "%s %s -> %s\n", psy->name,
+				status_text[old],
+				status_text[bat->status]);
+		power_supply_changed(psy);
+	}
+
+	mutex_unlock(&bat->work_lock);
+}
+
+static void tosa_bat_work(struct work_struct *work)
+{
+	tosa_bat_update(&tosa_bat_main);
+	tosa_bat_update(&tosa_bat_jacket);
+}
+
+
+static enum power_supply_property tosa_bat_main_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_PRESENT,
+};
+
+static enum power_supply_property tosa_bat_bu_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_PRESENT,
+};
+
+static struct tosa_bat tosa_bat_main = {
+	.status = POWER_SUPPLY_STATUS_DISCHARGING,
+	.full_chrg = -1,
+	.psy = {
+		.name		= "main-battery",
+		.type		= POWER_SUPPLY_TYPE_BATTERY,
+		.properties	= tosa_bat_main_props,
+		.num_properties	= ARRAY_SIZE(tosa_bat_main_props),
+		.get_property	= tosa_bat_get_property,
+		.external_power_changed = tosa_bat_external_power_changed,
+		.use_for_apm	= 1,
+	},
+
+	.gpio_full = TOSA_GPIO_BAT0_CRG,
+	.gpio_charge_off = TOSA_GPIO_CHARGE_OFF,
+
+	.technology = POWER_SUPPLY_TECHNOLOGY_LIPO,
+
+	.gpio_bat = TOSA_GPIO_BAT0_V_ON,
+	.adc_bat = WM97XX_AUX_ID3,
+	.adc_bat_divider = 414,
+	.bat_max = 4310000,
+	.bat_min = 1551 * 1000000 / 414,
+
+	.gpio_temp = TOSA_GPIO_BAT1_TH_ON,
+	.adc_temp = WM97XX_AUX_ID2,
+	.adc_temp_divider = 10000,
+};
+
+static struct tosa_bat tosa_bat_jacket = {
+	.status = POWER_SUPPLY_STATUS_DISCHARGING,
+	.full_chrg = -1,
+	.psy = {
+		.name		= "jacket-battery",
+		.type		= POWER_SUPPLY_TYPE_BATTERY,
+		.properties	= tosa_bat_main_props,
+		.num_properties	= ARRAY_SIZE(tosa_bat_main_props),
+		.get_property	= tosa_bat_get_property,
+		.external_power_changed = tosa_bat_external_power_changed,
+	},
+
+	.is_present = tosa_jacket_bat_is_present,
+	.gpio_full = TOSA_GPIO_BAT1_CRG,
+	.gpio_charge_off = TOSA_GPIO_CHARGE_OFF_JC,
+
+	.technology = POWER_SUPPLY_TECHNOLOGY_LIPO,
+
+	.gpio_bat = TOSA_GPIO_BAT1_V_ON,
+	.adc_bat = WM97XX_AUX_ID3,
+	.adc_bat_divider = 414,
+	.bat_max = 4310000,
+	.bat_min = 1551 * 1000000 / 414,
+
+	.gpio_temp = TOSA_GPIO_BAT0_TH_ON,
+	.adc_temp = WM97XX_AUX_ID2,
+	.adc_temp_divider = 10000,
+};
+
+static struct tosa_bat tosa_bat_bu = {
+	.status = POWER_SUPPLY_STATUS_UNKNOWN,
+	.full_chrg = -1,
+
+	.psy = {
+		.name		= "backup-battery",
+		.type		= POWER_SUPPLY_TYPE_BATTERY,
+		.properties	= tosa_bat_bu_props,
+		.num_properties	= ARRAY_SIZE(tosa_bat_bu_props),
+		.get_property	= tosa_bat_get_property,
+		.external_power_changed = tosa_bat_external_power_changed,
+	},
+
+	.gpio_full = -1,
+	.gpio_charge_off = -1,
+
+	.technology = POWER_SUPPLY_TECHNOLOGY_LiMn,
+
+	.gpio_bat = TOSA_GPIO_BU_CHRG_ON,
+	.adc_bat = WM97XX_AUX_ID4,
+	.adc_bat_divider = 1266,
+
+	.gpio_temp = -1,
+	.adc_temp = -1,
+	.adc_temp_divider = -1,
+};
+
+static struct {
+	int gpio;
+	char *name;
+	bool output;
+	int value;
+} gpios[] = {
+	{ TOSA_GPIO_CHARGE_OFF,		"main charge off",	1, 1 },
+	{ TOSA_GPIO_CHARGE_OFF_JC,	"jacket charge off",	1, 1 },
+	{ TOSA_GPIO_BAT_SW_ON,		"battery switch",	1, 0 },
+	{ TOSA_GPIO_BAT0_V_ON,		"main battery",		1, 0 },
+	{ TOSA_GPIO_BAT1_V_ON,		"jacket battery",	1, 0 },
+	{ TOSA_GPIO_BAT1_TH_ON,		"main battery temp",	1, 0 },
+	{ TOSA_GPIO_BAT0_TH_ON,		"jacket battery temp",	1, 0 },
+	{ TOSA_GPIO_BU_CHRG_ON,		"backup battery",	1, 0 },
+	{ TOSA_GPIO_BAT0_CRG,		"main battery full",	0, 0 },
+	{ TOSA_GPIO_BAT1_CRG,		"jacket battery full",	0, 0 },
+	{ TOSA_GPIO_BAT0_LOW,		"main battery low",	0, 0 },
+	{ TOSA_GPIO_BAT1_LOW,		"jacket battery low",	0, 0 },
+	{ TOSA_GPIO_JACKET_DETECT,	"jacket detect",	0, 0 },
+};
+
+#ifdef CONFIG_PM
+static int tosa_bat_suspend(struct platform_device *dev, pm_message_t state)
+{
+	/* do nothing */
+	flush_scheduled_work();
+	return 0;
+}
+
+static int tosa_bat_resume(struct platform_device *dev)
+{
+	schedule_work(&bat_work);
+	return 0;
+}
+#else
+#define tosa_bat_suspend NULL
+#define tosa_bat_resume NULL
+#endif
+
+static int __devinit tosa_bat_probe(struct platform_device *dev)
+{
+	int ret;
+	int i;
+
+	if (!machine_is_tosa())
+		return -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
+		ret = gpio_request(gpios[i].gpio, gpios[i].name);
+		if (ret) {
+			i--;
+			goto err_gpio;
+		}
+
+		if (gpios[i].output)
+			ret = gpio_direction_output(gpios[i].gpio,
+					gpios[i].value);
+		else
+			ret = gpio_direction_input(gpios[i].gpio);
+
+		if (ret)
+			goto err_gpio;
+	}
+
+	mutex_init(&tosa_bat_main.work_lock);
+	mutex_init(&tosa_bat_jacket.work_lock);
+
+	INIT_WORK(&bat_work, tosa_bat_work);
+
+	ret = power_supply_register(&dev->dev, &tosa_bat_main.psy);
+	if (ret)
+		goto err_psy_reg_main;
+	ret = power_supply_register(&dev->dev, &tosa_bat_jacket.psy);
+	if (ret)
+		goto err_psy_reg_jacket;
+	ret = power_supply_register(&dev->dev, &tosa_bat_bu.psy);
+	if (ret)
+		goto err_psy_reg_bu;
+
+	ret = request_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG),
+				tosa_bat_gpio_isr,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"main full", &tosa_bat_main);
+	if (ret)
+		goto err_req_main;
+
+	ret = request_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG),
+				tosa_bat_gpio_isr,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"jacket full", &tosa_bat_jacket);
+	if (ret)
+		goto err_req_jacket;
+
+	ret = request_irq(gpio_to_irq(TOSA_GPIO_JACKET_DETECT),
+				tosa_bat_gpio_isr,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"jacket detect", &tosa_bat_jacket);
+	if (!ret) {
+		schedule_work(&bat_work);
+		return 0;
+	}
+
+	free_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG), &tosa_bat_jacket);
+err_req_jacket:
+	free_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG), &tosa_bat_main);
+err_req_main:
+	power_supply_unregister(&tosa_bat_bu.psy);
+err_psy_reg_bu:
+	power_supply_unregister(&tosa_bat_jacket.psy);
+err_psy_reg_jacket:
+	power_supply_unregister(&tosa_bat_main.psy);
+err_psy_reg_main:
+
+	i--;
+err_gpio:
+	for (; i >= 0; i--)
+		gpio_free(gpios[i].gpio);
+
+	return ret;
+}
+
+static int __devexit tosa_bat_remove(struct platform_device *dev)
+{
+	int i;
+
+	free_irq(gpio_to_irq(TOSA_GPIO_JACKET_DETECT), &tosa_bat_jacket);
+	free_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG), &tosa_bat_jacket);
+	free_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG), &tosa_bat_main);
+
+	power_supply_unregister(&tosa_bat_bu.psy);
+	power_supply_unregister(&tosa_bat_jacket.psy);
+	power_supply_unregister(&tosa_bat_main.psy);
+
+	for (i = ARRAY_SIZE(gpios) - 1; i >= 0; i--)
+		gpio_free(gpios[i].gpio);
+
+	return 0;
+}
+
+static struct platform_driver tosa_bat_driver = {
+	.driver.name	= "wm97xx-battery",
+	.driver.owner	= THIS_MODULE,
+	.probe		= tosa_bat_probe,
+	.remove		= __devexit_p(tosa_bat_remove),
+	.suspend	= tosa_bat_suspend,
+	.resume		= tosa_bat_resume,
+};
+
+static int __init tosa_bat_init(void)
+{
+	return platform_driver_register(&tosa_bat_driver);
+}
+
+static void __exit tosa_bat_exit(void)
+{
+	platform_driver_unregister(&tosa_bat_driver);
+}
+
+module_init(tosa_bat_init);
+module_exit(tosa_bat_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dmitry Baryshkov");
+MODULE_DESCRIPTION("Tosa battery driver");
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

mfd-maintainer.patch
linux-next.patch
leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate.patch

