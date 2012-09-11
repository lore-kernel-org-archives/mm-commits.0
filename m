From: akpm@linux-foundation.org
Subject: [merged] thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:48 -0700
Message-ID: <20120911193249.8062020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:38451 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:32:52 -0400
Received: by wibhr14 with SMTP id hr14so66944wib.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:32:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, kmpark@infradead.org, lenb@kernel.org, sw.ju@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: exynos: register the tmu sensor with the kernel thermal layer
has been removed from the -mm tree.  Its filename was
     thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Subject: thermal: exynos: register the tmu sensor with the kernel thermal layer

This code added creates a link between temperature sensors, linux thermal
framework and cooling devices for samsung exynos platform.  This layer
monitors the temperature from the sensor and informs the generic thermal
layer to take the necessary cooling action.

[akpm@linux-foundation.org: fix comment layout]
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: SangWook Ju <sw.ju@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c             |  344 ++++++++++++++++-
 include/linux/platform_data/exynos_thermal.h |    6 
 2 files changed, 348 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer
+++ a/drivers/thermal/exynos_thermal.c
@@ -35,6 +35,9 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/platform_data/exynos_thermal.h>
+#include <linux/thermal.h>
+#include <linux/cpufreq.h>
+#include <linux/cpu_cooling.h>
 #include <linux/of.h>
 
 #include <plat/cpu.h>
@@ -95,6 +98,7 @@
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
+#define MCELSIUS	1000
 
 /* CPU Zone information */
 #define PANIC_ZONE      4
@@ -105,6 +109,8 @@
 #define GET_ZONE(trip) (trip + 2)
 #define GET_TRIP(zone) (zone - 2)
 
+#define EXYNOS_ZONE_COUNT	3
+
 struct exynos_tmu_data {
 	struct exynos_tmu_platform_data *pdata;
 	struct resource *mem;
@@ -117,6 +123,309 @@ struct exynos_tmu_data {
 	u8 temp_error1, temp_error2;
 };
 
+struct	thermal_trip_point_conf {
+	int trip_val[MAX_TRIP_COUNT];
+	int trip_count;
+};
+
+struct	thermal_cooling_conf {
+	struct freq_clip_table freq_data[MAX_TRIP_COUNT];
+	int freq_clip_count;
+};
+
+struct thermal_sensor_conf {
+	char name[SENSOR_NAME_LEN];
+	int (*read_temperature)(void *data);
+	struct thermal_trip_point_conf trip_data;
+	struct thermal_cooling_conf cooling_data;
+	void *private_data;
+};
+
+struct exynos_thermal_zone {
+	enum thermal_device_mode mode;
+	struct thermal_zone_device *therm_dev;
+	struct thermal_cooling_device *cool_dev[MAX_COOLING_DEVICE];
+	unsigned int cool_dev_size;
+	struct platform_device *exynos4_dev;
+	struct thermal_sensor_conf *sensor_conf;
+};
+
+static struct exynos_thermal_zone *th_zone;
+static void exynos_unregister_thermal(void);
+static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
+
+/* Get mode callback functions for thermal zone */
+static int exynos_get_mode(struct thermal_zone_device *thermal,
+			enum thermal_device_mode *mode)
+{
+	if (th_zone)
+		*mode = th_zone->mode;
+	return 0;
+}
+
+/* Set mode callback functions for thermal zone */
+static int exynos_set_mode(struct thermal_zone_device *thermal,
+			enum thermal_device_mode mode)
+{
+	if (!th_zone->therm_dev) {
+		pr_notice("thermal zone not registered\n");
+		return 0;
+	}
+
+	mutex_lock(&th_zone->therm_dev->lock);
+
+	if (mode == THERMAL_DEVICE_ENABLED)
+		th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
+	else
+		th_zone->therm_dev->polling_delay = 0;
+
+	mutex_unlock(&th_zone->therm_dev->lock);
+
+	th_zone->mode = mode;
+	thermal_zone_device_update(th_zone->therm_dev);
+	pr_info("thermal polling set for duration=%d msec\n",
+				th_zone->therm_dev->polling_delay);
+	return 0;
+}
+
+/*
+ * This function may be called from interrupt based temperature sensor
+ * when threshold is changed.
+ */
+static void exynos_report_trigger(void)
+{
+	unsigned int i;
+	char data[10];
+	char *envp[] = { data, NULL };
+
+	if (!th_zone || !th_zone->therm_dev)
+		return;
+
+	thermal_zone_device_update(th_zone->therm_dev);
+
+	mutex_lock(&th_zone->therm_dev->lock);
+	/* Find the level for which trip happened */
+	for (i = 0; i < th_zone->sensor_conf->trip_data.trip_count; i++) {
+		if (th_zone->therm_dev->last_temperature <
+			th_zone->sensor_conf->trip_data.trip_val[i] * MCELSIUS)
+			break;
+	}
+
+	if (th_zone->mode == THERMAL_DEVICE_ENABLED) {
+		if (i > 0)
+			th_zone->therm_dev->polling_delay = ACTIVE_INTERVAL;
+		else
+			th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
+	}
+
+	snprintf(data, sizeof(data), "%u", i);
+	kobject_uevent_env(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE, envp);
+	mutex_unlock(&th_zone->therm_dev->lock);
+}
+
+/* Get trip type callback functions for thermal zone */
+static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
+				 enum thermal_trip_type *type)
+{
+	switch (GET_ZONE(trip)) {
+	case MONITOR_ZONE:
+	case WARN_ZONE:
+		*type = THERMAL_TRIP_ACTIVE;
+		break;
+	case PANIC_ZONE:
+		*type = THERMAL_TRIP_CRITICAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Get trip temperature callback functions for thermal zone */
+static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
+				unsigned long *temp)
+{
+	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
+		return -EINVAL;
+
+	*temp = th_zone->sensor_conf->trip_data.trip_val[trip];
+	/* convert the temperature into millicelsius */
+	*temp = *temp * MCELSIUS;
+
+	return 0;
+}
+
+/* Get critical temperature callback functions for thermal zone */
+static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
+				unsigned long *temp)
+{
+	int ret;
+	/* Panic zone */
+	ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
+	return ret;
+}
+
+/* Bind callback functions for thermal zone */
+static int exynos_bind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	int ret = 0, i;
+
+	/* find the cooling device registered*/
+	for (i = 0; i < th_zone->cool_dev_size; i++)
+		if (cdev == th_zone->cool_dev[i])
+			break;
+
+	/* No matching cooling device */
+	if (i == th_zone->cool_dev_size)
+		return 0;
+
+	switch (GET_ZONE(i)) {
+	case MONITOR_ZONE:
+	case WARN_ZONE:
+		if (thermal_zone_bind_cooling_device(thermal, i, cdev)) {
+			pr_err("error binding cooling dev inst 0\n");
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* Unbind callback functions for thermal zone */
+static int exynos_unbind(struct thermal_zone_device *thermal,
+			struct thermal_cooling_device *cdev)
+{
+	int ret = 0, i;
+
+	/* find the cooling device registered*/
+	for (i = 0; i < th_zone->cool_dev_size; i++)
+		if (cdev == th_zone->cool_dev[i])
+			break;
+
+	/* No matching cooling device */
+	if (i == th_zone->cool_dev_size)
+		return 0;
+
+	switch (GET_ZONE(i)) {
+	case MONITOR_ZONE:
+	case WARN_ZONE:
+		if (thermal_zone_unbind_cooling_device(thermal, i, cdev)) {
+			pr_err("error unbinding cooling dev\n");
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/* Get temperature callback functions for thermal zone */
+static int exynos_get_temp(struct thermal_zone_device *thermal,
+			unsigned long *temp)
+{
+	void *data;
+
+	if (!th_zone->sensor_conf) {
+		pr_info("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+	data = th_zone->sensor_conf->private_data;
+	*temp = th_zone->sensor_conf->read_temperature(data);
+	/* convert the temperature into millicelsius */
+	*temp = *temp * MCELSIUS;
+	return 0;
+}
+
+/* Operation callback functions for thermal zone */
+static struct thermal_zone_device_ops const exynos_dev_ops = {
+	.bind = exynos_bind,
+	.unbind = exynos_unbind,
+	.get_temp = exynos_get_temp,
+	.get_mode = exynos_get_mode,
+	.set_mode = exynos_set_mode,
+	.get_trip_type = exynos_get_trip_type,
+	.get_trip_temp = exynos_get_trip_temp,
+	.get_crit_temp = exynos_get_crit_temp,
+};
+
+/* Register with the in-kernel thermal management */
+static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
+{
+	int ret, count, tab_size;
+	struct freq_clip_table *tab_ptr, *clip_data;
+
+	if (!sensor_conf || !sensor_conf->read_temperature) {
+		pr_err("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+
+	th_zone = kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
+	if (!th_zone)
+		return -ENOMEM;
+
+	th_zone->sensor_conf = sensor_conf;
+
+	tab_ptr = (struct freq_clip_table *)sensor_conf->cooling_data.freq_data;
+	tab_size = sensor_conf->cooling_data.freq_clip_count;
+
+	/* Register the cpufreq cooling device */
+	for (count = 0; count < tab_size; count++) {
+		clip_data = (struct freq_clip_table *)&(tab_ptr[count]);
+		clip_data->mask_val = cpumask_of(0);
+		th_zone->cool_dev[count] = cpufreq_cooling_register(
+						clip_data, 1);
+		if (IS_ERR(th_zone->cool_dev[count])) {
+			pr_err("Failed to register cpufreq cooling device\n");
+			ret = -EINVAL;
+			th_zone->cool_dev_size = count;
+			goto err_unregister;
+		}
+	}
+	th_zone->cool_dev_size = count;
+
+	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
+			EXYNOS_ZONE_COUNT, NULL, &exynos_dev_ops, 0, 0, 0,
+			IDLE_INTERVAL);
+
+	if (IS_ERR(th_zone->therm_dev)) {
+		pr_err("Failed to register thermal zone device\n");
+		ret = -EINVAL;
+		goto err_unregister;
+	}
+	th_zone->mode = THERMAL_DEVICE_ENABLED;
+
+	pr_info("Exynos: Kernel Thermal management registered\n");
+
+	return 0;
+
+err_unregister:
+	exynos_unregister_thermal();
+	return ret;
+}
+
+/* Un-Register with the in-kernel thermal management */
+static void exynos_unregister_thermal(void)
+{
+	int i;
+
+	for (i = 0; i < th_zone->cool_dev_size; i++) {
+		if (th_zone && th_zone->cool_dev[i])
+			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
+	}
+
+	if (th_zone && th_zone->therm_dev)
+		thermal_zone_device_unregister(th_zone->therm_dev);
+
+	kfree(th_zone);
+
+	pr_info("Exynos: Kernel Thermal management unregistered\n");
+}
+
 /*
  * TMU treats temperature as a mapped temperature code.
  * The temperature is converted differently depending on the calibration type.
@@ -337,6 +646,7 @@ static void exynos_tmu_work(struct work_
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	exynos_report_trigger();
 	enable_irq(data->irq);
 }
 
@@ -349,12 +659,16 @@ static irqreturn_t exynos_tmu_irq(int ir
 
 	return IRQ_HANDLED;
 }
-
+static struct thermal_sensor_conf exynos_sensor_conf = {
+	.name			= "exynos-therm",
+	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+}
+;
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
 	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
-	int ret;
+	int ret, i;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
@@ -432,6 +746,30 @@ static int __devinit exynos_tmu_probe(st
 
 	exynos_tmu_control(pdev, true);
 
+	/* Register the sensor with thermal management interface */
+	(&exynos_sensor_conf)->private_data = data;
+	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
+			pdata->trigger_level1_en + pdata->trigger_level2_en +
+			pdata->trigger_level3_en;
+
+	for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
+		exynos_sensor_conf.trip_data.trip_val[i] =
+			pdata->threshold + pdata->trigger_levels[i];
+
+	exynos_sensor_conf.cooling_data.freq_clip_count =
+						pdata->freq_tab_count;
+	for (i = 0; i < pdata->freq_tab_count; i++) {
+		exynos_sensor_conf.cooling_data.freq_data[i].freq_clip_max =
+					pdata->freq_tab[i].freq_clip_max;
+		exynos_sensor_conf.cooling_data.freq_data[i].temp_level =
+					pdata->freq_tab[i].temp_level;
+	}
+
+	ret = exynos_register_thermal(&exynos_sensor_conf);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		goto err_clk;
+	}
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -454,6 +792,8 @@ static int __devexit exynos_tmu_remove(s
 
 	exynos_tmu_control(pdev, false);
 
+	exynos_unregister_thermal();
+
 	clk_put(data->clk);
 
 	free_irq(data->irq, data);
diff -puN include/linux/platform_data/exynos_thermal.h~thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer include/linux/platform_data/exynos_thermal.h
--- a/include/linux/platform_data/exynos_thermal.h~thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer
+++ a/include/linux/platform_data/exynos_thermal.h
@@ -21,6 +21,7 @@
 
 #ifndef _LINUX_EXYNOS_THERMAL_H
 #define _LINUX_EXYNOS_THERMAL_H
+#include <linux/cpu_cooling.h>
 
 enum calibration_type {
 	TYPE_ONE_POINT_TRIMMING,
@@ -72,6 +73,9 @@ enum soc_type {
  * @type: determines the type of SOC
  * @efuse_value: platform defined fuse value
  * @cal_type: calibration type for temperature
+ * @freq_clip_table: Table representing frequency reduction percentage.
+ * @freq_tab_count: Count of the above table as frequency reduction may
+ *	applicable to only some of the trigger levels.
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -90,5 +94,7 @@ struct exynos_tmu_platform_data {
 
 	enum calibration_type cal_type;
 	enum soc_type type;
+	struct freq_clip_table freq_tab[4];
+	unsigned int freq_tab_count;
 };
 #endif /* _LINUX_EXYNOS_THERMAL_H */
_

Patches currently in -mm which might be from amit.kachhap@linaro.org are

linux-next.patch

