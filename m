From: akpm@linux-foundation.org
Subject: + arm-exynos-add-thermal-sensor-driver-platform-data-support.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:02:51 -0700
Message-ID: <20120713210252.48148100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46671 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2GMVCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:02:53 -0400
Received: by qabg24 with SMTP id g24so99223qab.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:02:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, lenb@kernel.org, sw.ju@samsung.com


The patch titled
     Subject: ARM: exynos: add thermal sensor driver platform data support
has been added to the -mm tree.  Its filename is
     arm-exynos-add-thermal-sensor-driver-platform-data-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -838,9 +945,11 @@ static struct platform_driver exynos_tmu
 		.name   = "exynos-tmu",
 		.owner  = THIS_MODULE,
 		.pm     = EXYNOS_TMU_PM,
+		.of_match_table = exynos_tmu_match,
 	},
 	.probe = exynos_tmu_probe,
 	.remove	= __devexit_p(exynos_tmu_remove),
+	.id_table = exynos_tmu_driver_ids,
 };
 
 module_platform_driver(exynos_tmu_driver);
_
Subject: Subject: ARM: exynos: add thermal sensor driver platform data support

Patches currently in -mm which might be from amit.kachhap@linaro.org are

thermal-add-generic-cpufreq-cooling-implementation.patch
hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
arm-exynos-add-thermal-sensor-driver-platform-data-support.patch

