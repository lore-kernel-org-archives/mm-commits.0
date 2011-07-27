From: akpm@linux-foundation.org
Subject: + leds-renesas-tpu-led-driver-v2.patch added to -mm tree
Date: Wed, 27 Jul 2011 15:34:18 -0700
Message-ID: <201107272234.p6RMYItv012560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1G0Wen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 18:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, grant.likely@secretlab.ca, lethal@linux-sh.org, rpurdie@rpsys.net


The patch titled
     leds: Renesas TPU LED driver
has been added to the -mm tree.  Its filename is
     leds-renesas-tpu-led-driver-v2.patch

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
Subject: leds: Renesas TPU LED driver
From: Magnus Damm <damm@opensource.se>

Add V2 of the LED driver for a single timer channel for the TPU hardware
block commonly found in Renesas SoCs.

The driver has been written with optimal Power Management in mind, so to
save power the LED is driven as a regular GPIO pin in case of maximum
brightness and power off which allows the TPU hardware to be idle and
which in turn allows the clocks to be stopped and the power domain to be
turned off transparently.

Any other brightness level requires use of the TPU hardware in PWM mode. 
TPU hardware device clocks and power are managed through Runtime PM. 
System suspend and resume is known to be working - during suspend the LED
is set to off by the generic LED code.

The TPU hardware timer is equipeed with a 16-bit counter together with an
up-to-divide-by-64 prescaler which makes the hardware suitable for
brightness control.  Hardware blink is unsupported.

The LED PWM waveform has been verified with a Fluke 123 Scope meter on a
sh7372 Mackerel board.  Tested with experimental sh7372 A3SP power domain
patches.  Platform device bind/unbind tested ok.

V2 has been tested on the DS2 LED of the sh73a0-based AG5EVM.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig             |   12 +
 drivers/leds/Makefile            |    1 
 drivers/leds/leds-renesas-tpu.c  |  343 +++++++++++++++++++++++++++++
 include/linux/leds-renesas-tpu.h |   14 +
 4 files changed, 370 insertions(+)

diff -puN drivers/leds/Kconfig~leds-renesas-tpu-led-driver-v2 drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-renesas-tpu-led-driver-v2
+++ a/drivers/leds/Kconfig
@@ -375,6 +375,18 @@ config LEDS_ASIC3
 	  cannot be used. This driver supports hardware blinking with an on+off
 	  period from 62ms to 125s. Say Y to enable LEDs on the HP iPAQ hx4700.
 
+config LEDS_RENESAS_TPU
+	bool "LED support for Renesas TPU"
+	depends on LEDS_CLASS && HAVE_CLK && GENERIC_GPIO
+	help
+	  This option enables build of the LED TPU platform driver,
+	  suitable to drive any TPU channel on newer Renesas SoCs.
+	  The driver controls the GPIO pin connected to the LED via
+	  the GPIO framework and expects the LED to be connected to
+	  a pin that can be driven in both GPIO mode and using TPU
+	  pin function. The latter to support brightness control.
+	  Brightness control is supported but hardware blinking is not.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~leds-renesas-tpu-led-driver-v2 drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-renesas-tpu-led-driver-v2
+++ a/drivers/leds/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
+obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -puN /dev/null drivers/leds/leds-renesas-tpu.c
--- /dev/null
+++ a/drivers/leds/leds-renesas-tpu.c
@@ -0,0 +1,343 @@
+/*
+ * LED control using Renesas TPU
+ *
+ *  Copyright (C) 2011 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/printk.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/leds.h>
+#include <linux/leds-renesas-tpu.h>
+#include <linux/gpio.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+
+enum r_tpu_pin { R_TPU_PIN_UNUSED, R_TPU_PIN_GPIO, R_TPU_PIN_GPIO_FN };
+enum r_tpu_timer { R_TPU_TIMER_UNUSED, R_TPU_TIMER_ON };
+
+struct r_tpu_priv {
+	struct led_classdev ldev;
+	void __iomem *mapbase;
+	struct clk *clk;
+	struct platform_device *pdev;
+	enum r_tpu_pin pin_state;
+	enum r_tpu_timer timer_state;
+	unsigned long min_rate;
+	unsigned int refresh_rate;
+};
+
+static DEFINE_SPINLOCK(r_tpu_lock);
+
+#define TSTR -1 /* Timer start register (shared register) */
+#define TCR  0 /* Timer control register (+0x00) */
+#define TMDR 1 /* Timer mode register (+0x04) */
+#define TIOR 2 /* Timer I/O control register (+0x08) */
+#define TIER 3 /* Timer interrupt enable register (+0x0c) */
+#define TSR  4 /* Timer status register (+0x10) */
+#define TCNT 5 /* Timer counter (+0x14) */
+#define TGRA 6 /* Timer general register A (+0x18) */
+#define TGRB 7 /* Timer general register B (+0x1c) */
+#define TGRC 8 /* Timer general register C (+0x20) */
+#define TGRD 9 /* Timer general register D (+0x24) */
+
+static inline unsigned short r_tpu_read(struct r_tpu_priv *p, int reg_nr)
+{
+	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
+	void __iomem *base = p->mapbase;
+	unsigned long offs = reg_nr << 2;
+
+	if (reg_nr == TSTR)
+		return ioread16(base - cfg->channel_offset);
+
+	return ioread16(base + offs);
+}
+
+static inline void r_tpu_write(struct r_tpu_priv *p, int reg_nr,
+			       unsigned short value)
+{
+	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
+	void __iomem *base = p->mapbase;
+	unsigned long offs = reg_nr << 2;
+
+	if (reg_nr == TSTR) {
+		iowrite16(value, base - cfg->channel_offset);
+		return;
+	}
+
+	iowrite16(value, base + offs);
+}
+
+static void r_tpu_start_stop_ch(struct r_tpu_priv *p, int start)
+{
+	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
+	unsigned long flags, value;
+
+	/* start stop register shared by multiple timer channels */
+	spin_lock_irqsave(&r_tpu_lock, flags);
+	value = r_tpu_read(p, TSTR);
+
+	if (start)
+		value |= 1 << cfg->timer_bit;
+	else
+		value &= ~(1 << cfg->timer_bit);
+
+	r_tpu_write(p, TSTR, value);
+	spin_unlock_irqrestore(&r_tpu_lock, flags);
+}
+
+static int r_tpu_enable(struct r_tpu_priv *p, enum led_brightness brightness)
+{
+	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
+	int prescaler[] = { 1, 4, 16, 64 };
+	int k, ret;
+	unsigned long rate, tmp;
+
+	if (p->timer_state == R_TPU_TIMER_ON)
+		return 0;
+
+	/* wake up device and enable clock */
+	pm_runtime_get_sync(&p->pdev->dev);
+	ret = clk_enable(p->clk);
+	if (ret) {
+		dev_err(&p->pdev->dev, "cannot enable clock\n");
+		return ret;
+	}
+
+	/* make sure channel is disabled */
+	r_tpu_start_stop_ch(p, 0);
+
+	/* get clock rate after enabling it */
+	rate = clk_get_rate(p->clk);
+
+	/* pick the lowest acceptable rate */
+	for (k = 0; k < ARRAY_SIZE(prescaler); k++)
+		if ((rate / prescaler[k]) < p->min_rate)
+			break;
+
+	if (!k) {
+		dev_err(&p->pdev->dev, "clock rate mismatch\n");
+		goto err0;
+	}
+	dev_dbg(&p->pdev->dev, "rate = %lu, prescaler %u\n",
+		rate, prescaler[k - 1]);
+
+	/* clear TCNT on TGRB match, count on rising edge, set prescaler */
+	r_tpu_write(p, TCR, 0x0040 | (k - 1));
+
+	/* output 0 until TGRA, output 1 until TGRB */
+	r_tpu_write(p, TIOR, 0x0002);
+
+	rate /= prescaler[k - 1] * p->refresh_rate;
+	r_tpu_write(p, TGRB, rate);
+	dev_dbg(&p->pdev->dev, "TRGB = 0x%04lx\n", rate);
+
+	tmp = (cfg->max_brightness - brightness) * rate;
+	r_tpu_write(p, TGRA, tmp / cfg->max_brightness);
+	dev_dbg(&p->pdev->dev, "TRGA = 0x%04lx\n", tmp / cfg->max_brightness);
+
+	/* PWM mode */
+	r_tpu_write(p, TMDR, 0x0002);
+
+	/* enable channel */
+	r_tpu_start_stop_ch(p, 1);
+
+	p->timer_state = R_TPU_TIMER_ON;
+	return 0;
+ err0:
+	clk_disable(p->clk);
+	pm_runtime_put_sync(&p->pdev->dev);
+	return -ENOTSUPP;
+}
+
+static void r_tpu_disable(struct r_tpu_priv *p)
+{
+	if (p->timer_state == R_TPU_TIMER_UNUSED)
+		return;
+
+	/* disable channel */
+	r_tpu_start_stop_ch(p, 0);
+
+	/* stop clock and mark device as idle */
+	clk_disable(p->clk);
+	pm_runtime_put_sync(&p->pdev->dev);
+
+	p->timer_state = R_TPU_TIMER_UNUSED;
+}
+
+static void r_tpu_set_pin(struct r_tpu_priv *p, enum r_tpu_pin new_state,
+			  enum led_brightness brightness)
+{
+	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
+
+	if (p->pin_state == new_state) {
+		if (p->pin_state == R_TPU_PIN_GPIO)
+			gpio_set_value(cfg->pin_gpio, brightness);
+		return;
+	}
+
+	if (p->pin_state == R_TPU_PIN_GPIO)
+		gpio_free(cfg->pin_gpio);
+
+	if (p->pin_state == R_TPU_PIN_GPIO_FN)
+		gpio_free(cfg->pin_gpio_fn);
+
+	if (new_state == R_TPU_PIN_GPIO) {
+		gpio_request(cfg->pin_gpio, cfg->name);
+		gpio_direction_output(cfg->pin_gpio, !!brightness);
+	}
+	if (new_state == R_TPU_PIN_GPIO_FN)
+		gpio_request(cfg->pin_gpio_fn, cfg->name);
+
+	p->pin_state = new_state;
+}
+
+static void r_tpu_set_brightness(struct led_classdev *ldev,
+				 enum led_brightness brightness)
+{
+	struct r_tpu_priv *p = container_of(ldev, struct r_tpu_priv, ldev);
+
+	r_tpu_disable(p);
+
+	/* off and maximum are handled as GPIO pins, in between PWM */
+	if ((brightness == 0) || (brightness == ldev->max_brightness))
+		r_tpu_set_pin(p, R_TPU_PIN_GPIO, brightness);
+	else {
+		r_tpu_set_pin(p, R_TPU_PIN_GPIO_FN, 0);
+		r_tpu_enable(p, brightness);
+	}
+}
+
+static int __devinit r_tpu_probe(struct platform_device *pdev)
+{
+	struct led_renesas_tpu_config *cfg = pdev->dev.platform_data;
+	struct r_tpu_priv *p;
+	struct resource *res;
+	int ret = -ENXIO;
+
+	if (!cfg) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		goto err0;
+	}
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (p == NULL) {
+		dev_err(&pdev->dev, "failed to allocate driver data\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get I/O memory\n");
+		goto err1;
+	}
+
+	/* map memory, let mapbase point to our channel */
+	p->mapbase = ioremap_nocache(res->start, resource_size(res));
+	if (p->mapbase == NULL) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		goto err1;
+	}
+
+	/* get hold of clock */
+	p->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(p->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		ret = PTR_ERR(p->clk);
+		goto err2;
+	}
+
+	p->pdev = pdev;
+	p->pin_state = R_TPU_PIN_UNUSED;
+	p->timer_state = R_TPU_TIMER_UNUSED;
+	p->refresh_rate = cfg->refresh_rate ? cfg->refresh_rate : 100;
+	r_tpu_set_pin(p, R_TPU_PIN_GPIO, LED_OFF);
+	platform_set_drvdata(pdev, p);
+
+
+	p->ldev.name = cfg->name;
+	p->ldev.brightness = LED_OFF;
+	p->ldev.max_brightness = cfg->max_brightness;
+	p->ldev.brightness_set = r_tpu_set_brightness;
+	p->ldev.flags |= LED_CORE_SUSPENDRESUME;
+	ret = led_classdev_register(&pdev->dev, &p->ldev);
+	if (ret < 0)
+		goto err3;
+
+	/* max_brightness may be updated by the LED core code */
+	p->min_rate = p->ldev.max_brightness * p->refresh_rate;
+
+	pm_runtime_enable(&pdev->dev);
+	return 0;
+
+ err3:
+	r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
+	clk_put(p->clk);
+ err2:
+	iounmap(p->mapbase);
+ err1:
+	kfree(p);
+ err0:
+	return ret;
+}
+
+static int __devexit r_tpu_remove(struct platform_device *pdev)
+{
+	struct r_tpu_priv *p = platform_get_drvdata(pdev);
+
+	r_tpu_set_brightness(&p->ldev, LED_OFF);
+	led_classdev_unregister(&p->ldev);
+	r_tpu_disable(p);
+	r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
+
+	pm_runtime_disable(&pdev->dev);
+	clk_put(p->clk);
+
+	iounmap(p->mapbase);
+	kfree(p);
+	return 0;
+}
+
+static struct platform_driver r_tpu_device_driver = {
+	.probe		= r_tpu_probe,
+	.remove		= __devexit_p(r_tpu_remove),
+	.driver		= {
+		.name	= "leds-renesas-tpu",
+	}
+};
+
+static int __init r_tpu_init(void)
+{
+	return platform_driver_register(&r_tpu_device_driver);
+}
+
+static void __exit r_tpu_exit(void)
+{
+	platform_driver_unregister(&r_tpu_device_driver);
+}
+
+module_init(r_tpu_init);
+module_exit(r_tpu_exit);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("Renesas TPU LED Driver");
+MODULE_LICENSE("GPL v2");
diff -puN /dev/null include/linux/leds-renesas-tpu.h
--- /dev/null
+++ a/include/linux/leds-renesas-tpu.h
@@ -0,0 +1,14 @@
+#ifndef __LEDS_RENESAS_TPU_H__
+#define __LEDS_RENESAS_TPU_H__
+
+struct led_renesas_tpu_config {
+	char *name;
+	unsigned pin_gpio_fn;
+	unsigned pin_gpio;
+	unsigned int channel_offset;
+	unsigned int timer_bit;
+	unsigned int max_brightness;
+	unsigned int refresh_rate;
+};
+
+#endif /* __LEDS_RENESAS_TPU_H__ */
_

Patches currently in -mm which might be from damm@opensource.se are

origin.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2.patch

