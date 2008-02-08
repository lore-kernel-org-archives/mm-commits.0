From: akpm@linux-foundation.org
Subject: - pwm-led-driver.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:07 -0800
Message-ID: <200802082018.m18KImVV010961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbYBHVCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, linux@maxim.org.za, nicolas.ferre@atmel.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     PWM LED driver
has been removed from the -mm tree.  Its filename was
     pwm-led-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PWM LED driver
From: David Brownell <david-b@pacbell.net>

This is a LED driver using the PWM on newer SOCs from Atmel; brightness is
controlled by changing the PWM duty cycle.  So for example if you've set up
two leds labeled "pwm0" and "pwm1":

	echo 0 > /sys/class/leds/pwm2/brightness	# off (0%)
	echo 80 > /sys/class/leds/pwm2/brightness
	echo 255 > /sys/class/leds/pwm2/brightness	# on (100%)

Note that "brightness" here isn't linear; maybe that should change.  Going
from 4 to 8 probably doubles perceived brightness, while 244 to 248 is
imperceptible.

This is mostly intended to be a simple example of PWM, although it's
realistic since LCD backlights are often driven with PWM to conserve
battery power (and offer brightness options).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig          |    7 +
 drivers/leds/Makefile         |    1 
 drivers/leds/leds-atmel-pwm.c |  157 ++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)

diff -puN drivers/leds/Kconfig~pwm-led-driver drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~pwm-led-driver
+++ a/drivers/leds/Kconfig
@@ -18,6 +18,13 @@ config LEDS_CLASS
 
 comment "LED drivers"
 
+config LEDS_ATMEL_PWM
+	tristate "LED Support using Atmel PWM outputs"
+	depends on LEDS_CLASS && ATMEL_PWM
+	help
+	  This option enables support for LEDs driven using outputs
+	  of the dedicated PWM controller found on newer Atmel SOCs.
+
 config LEDS_CORGI
 	tristate "LED Support for the Sharp SL-C7x0 series"
 	depends on LEDS_CLASS && PXA_SHARP_C7xx
diff -puN drivers/leds/Makefile~pwm-led-driver drivers/leds/Makefile
--- a/drivers/leds/Makefile~pwm-led-driver
+++ a/drivers/leds/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
+obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_CORGI)		+= leds-corgi.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_SPITZ)		+= leds-spitz.o
diff -puN /dev/null drivers/leds/leds-atmel-pwm.c
--- /dev/null
+++ a/drivers/leds/leds-atmel-pwm.c
@@ -0,0 +1,157 @@
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/io.h>
+#include <linux/atmel_pwm.h>
+
+
+struct pwmled {
+	struct led_classdev	cdev;
+	struct pwm_channel	pwmc;
+	struct gpio_led		*desc;
+	u32			mult;
+	u8			active_low;
+};
+
+
+/*
+ * For simplicity, we use "brightness" as if it were a linear function
+ * of PWM duty cycle.  However, a logarithmic function of duty cycle is
+ * probably a better match for perceived brightness: two is half as bright
+ * as four, four is half as bright as eight, etc
+ */
+static void pwmled_brightness(struct led_classdev *cdev, enum led_brightness b)
+{
+	struct pwmled		 *led;
+
+	/* update the duty cycle for the *next* period */
+	led = container_of(cdev, struct pwmled, cdev);
+	pwm_channel_writel(&led->pwmc, PWM_CUPD, led->mult * (unsigned) b);
+}
+
+/*
+ * NOTE:  we reuse the platform_data structure of GPIO leds,
+ * but repurpose its "gpio" number as a PWM channel number.
+ */
+static int __init pwmled_probe(struct platform_device *pdev)
+{
+	const struct gpio_led_platform_data	*pdata;
+	struct pwmled				*leds;
+	unsigned				i;
+	int					status;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata || pdata->num_leds < 1)
+		return -ENODEV;
+
+	leds = kcalloc(pdata->num_leds, sizeof(*leds), GFP_KERNEL);
+	if (!leds)
+		return -ENOMEM;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		struct pwmled		*led = leds + i;
+		const struct gpio_led	*dat = pdata->leds + i;
+		u32			tmp;
+
+		led->cdev.name = dat->name;
+		led->cdev.brightness = LED_OFF;
+		led->cdev.brightness_set = pwmled_brightness;
+		led->cdev.default_trigger = dat->default_trigger;
+
+		led->active_low = dat->active_low;
+
+		status = pwm_channel_alloc(dat->gpio, &led->pwmc);
+		if (status < 0)
+			goto err;
+
+		/*
+		 * Prescale clock by 2^x, so PWM counts in low MHz.
+		 * Start each cycle with the LED active, so increasing
+		 * the duty cycle gives us more time on (== brighter).
+		 */
+		tmp = 5;
+		if (!led->active_low)
+			tmp |= PWM_CPR_CPOL;
+		pwm_channel_writel(&led->pwmc, PWM_CMR, tmp);
+
+		/*
+		 * Pick a period so PWM cycles at 100+ Hz; and a multiplier
+		 * for scaling duty cycle:  brightness * mult.
+		 */
+		tmp = (led->pwmc.mck / (1 << 5)) / 100;
+		tmp /= 255;
+		led->mult = tmp;
+		pwm_channel_writel(&led->pwmc, PWM_CDTY,
+				led->cdev.brightness * 255);
+		pwm_channel_writel(&led->pwmc, PWM_CPRD,
+				LED_FULL * tmp);
+
+		pwm_channel_enable(&led->pwmc);
+
+		/* Hand it over to the LED framework */
+		status = led_classdev_register(&pdev->dev, &led->cdev);
+		if (status < 0) {
+			pwm_channel_free(&led->pwmc);
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, leds);
+	return 0;
+
+err:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			led_classdev_unregister(&leds[i].cdev);
+			pwm_channel_free(&leds[i].pwmc);
+		}
+	}
+	kfree(leds);
+
+	return status;
+}
+
+static int __exit pwmled_remove(struct platform_device *pdev)
+{
+	const struct gpio_led_platform_data	*pdata;
+	struct pwmled				*leds;
+	unsigned				i;
+
+	pdata = pdev->dev.platform_data;
+	leds = platform_get_drvdata(pdev);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		struct pwmled		*led = leds + i;
+
+		led_classdev_unregister(&led->cdev);
+		pwm_channel_free(&led->pwmc);
+	}
+
+	kfree(leds);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver pwmled_driver = {
+	.driver = {
+		.name =		"leds-atmel-pwm",
+		.owner =	THIS_MODULE,
+	},
+	/* REVISIT add suspend() and resume() methods */
+	.remove =	__exit_p(pwmled_remove),
+};
+
+static int __init modinit(void)
+{
+	return platform_driver_probe(&pwmled_driver, pwmled_probe);
+}
+module_init(modinit);
+
+static void __exit modexit(void)
+{
+	platform_driver_unregister(&pwmled_driver);
+}
+module_exit(modexit);
+
+MODULE_DESCRIPTION("Driver for LEDs with PWM-controlled brightness");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-mmc.patch
