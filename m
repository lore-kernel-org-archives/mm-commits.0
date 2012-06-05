From: akpm@linux-foundation.org
Subject: [merged] arm-exynos-add-thermal-sensor-driver-platform-data-support.patch removed from -mm tree
Date: Tue, 05 Jun 2012 12:56:29 -0700
Message-ID: <20120605195629.89AD6A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45935 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2FET4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:56:31 -0400
Received: by wibhn6 with SMTP id hn6so276621wib.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:56:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, lenb@kernel.org, sw.ju@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: exynos: add thermal sensor driver platform data support
has been removed from the -mm tree.  Its filename was
     arm-exynos-add-thermal-sensor-driver-platform-data-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Subject: ARM: exynos: add thermal sensor driver platform data support

Add necessary default platform data support needed for TMU driver.  This
dt/non-dt values are tested for origen exynos4210 and smdk exynos5250
platforms.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: SangWook Ju <sw.ju@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c |  111 ++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff -puN drivers/thermal/exynos_thermal.c~arm-exynos-add-thermal-sensor-driver-platform-data-support drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~arm-exynos-add-thermal-sensor-driver-platform-data-support
+++ a/drivers/thermal/exynos_thermal.c
@@ -662,14 +662,121 @@ static irqreturn_t exynos_tmu_irq(int ir
 static struct thermal_sensor_conf exynos_sensor_conf = {
 	.name			= "exynos-therm",
 	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+};
+
+#if defined(CONFIG_CPU_EXYNOS4210)
+static struct exynos_tmu_platform_data const exynos4_default_tmu_data = {
+	.threshold = 80,
+	.trigger_levels[0] = 5,
+	.trigger_levels[1] = 20,
+	.trigger_levels[2] = 30,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 0,
+	.gain = 15,
+	.reference_voltage = 7,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.freq_tab[0] = {
+		.freq_clip_max = 800 * 1000,
+		.temp_level = 85,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+		.temp_level = 100,
+	},
+	.freq_tab_count = 2,
+	.type = SOC_ARCH_EXYNOS4,
+};
+#define EXYNOS4_TMU_DRV_DATA (&exynos4_default_tmu_data)
+#else
+#define EXYNOS4_TMU_DRV_DATA (NULL)
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS5250)
+static struct exynos_tmu_platform_data const exynos5_default_tmu_data = {
+	.trigger_levels[0] = 85,
+	.trigger_levels[1] = 103,
+	.trigger_levels[2] = 110,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 0,
+	.gain = 8,
+	.reference_voltage = 16,
+	.noise_cancel_mode = 4,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.efuse_value = 55,
+	.freq_tab[0] = {
+		.freq_clip_max = 800 * 1000,
+		.temp_level = 85,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+		.temp_level = 103,
+	},
+	.freq_tab_count = 2,
+	.type = SOC_ARCH_EXYNOS5,
+};
+#define EXYNOS5_TMU_DRV_DATA (&exynos5_default_tmu_data)
+#else
+#define EXYNOS5_TMU_DRV_DATA (NULL)
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_tmu_match[] = {
+	{
+		.compatible = "samsung,exynos4-tmu",
+		.data = (void *)EXYNOS4_TMU_DRV_DATA,
+	},
+	{
+		.compatible = "samsung,exynos5-tmu",
+		.data = (void *)EXYNOS5_TMU_DRV_DATA,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_tmu_match);
+#else
+#define  exynos_tmu_match NULL
+#endif
+
+static struct platform_device_id exynos_tmu_driver_ids[] = {
+	{
+		.name		= "exynos4-tmu",
+		.driver_data    = (kernel_ulong_t)EXYNOS4_TMU_DRV_DATA,
+	},
+	{
+		.name		= "exynos5-tmu",
+		.driver_data    = (kernel_ulong_t)EXYNOS5_TMU_DRV_DATA,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
+
+static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
+			struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(exynos_tmu_match, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (struct exynos_tmu_platform_data *) match->data;
+	}
+#endif
+	return (struct exynos_tmu_platform_data *)
+			platform_get_device_id(pdev)->driver_data;
 }
-;
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
 	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
 	int ret, i;
 
+	if (!pdata)
+		pdata = exynos_get_driver_data(pdev);
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
@@ -832,11 +939,13 @@ static struct platform_driver exynos_tmu
 	.driver = {
 		.name   = "exynos-tmu",
 		.owner  = THIS_MODULE,
+		.of_match_table = exynos_tmu_match,
 	},
 	.probe = exynos_tmu_probe,
 	.remove	= __devexit_p(exynos_tmu_remove),
 	.suspend = exynos_tmu_suspend,
 	.resume = exynos_tmu_resume,
+	.id_table = exynos_tmu_driver_ids,
 };
 
 module_platform_driver(exynos_tmu_driver);
_

Patches currently in -mm which might be from amit.kachhap@linaro.org are

linux-next.patch

