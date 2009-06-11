From: akpm@linux-foundation.org
Subject: [to-be-updated] input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch removed from -mm tree
Date: Thu, 11 Jun 2009 16:17:27 -0700
Message-ID: <200906112317.n5BNHRZh016357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbZFKXRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 19:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, broonie@opensource.wolfsonmicro.com, dtor@mail.ru, jirislaby@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     input: add wm97xx accelerated driver for AVR32 AT32AP700X microprocessors
has been removed from the -mm tree.  Its filename was
     input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add wm97xx accelerated driver for AVR32 AT32AP700X microprocessors
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Add an accelerated driver for Atmel AVR32 AT32AP700X microprocessors.  It
uses interrupts on the channel B in the AC97 controller.  Thus, offloading
the work queue in the wm97xx-ts driver.

The driver has been tested with Atmel AVR32 AT32AP7000 and Wolfson WM9712
codec.

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
[akpm@linux-foundation.org: fix leak, spotted by jirislaby@gmail.com]
[akpm@linux-foundation.org: handle wm97xx_register_mach_ops() failure, spotted by jirislaby@gmail.com]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig       |   15 
 drivers/input/touchscreen/Makefile      |    1 
 drivers/input/touchscreen/at32-wm97xx.c |  423 ++++++++++++++++++++++
 drivers/input/touchscreen/at32-wm97xx.h |   48 ++
 4 files changed, 487 insertions(+)

diff -puN drivers/input/touchscreen/Kconfig~input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors
+++ a/drivers/input/touchscreen/Kconfig
@@ -365,6 +365,21 @@ config TOUCHSCREEN_WM97XX_ATMEL
 	  To compile this driver as a module, choose M here: the module will
 	  be called atmel-wm97xx.
 
+config TOUCHSCREEN_WM97XX_AT32
+	tristate "WM97xx Atmel AVR32 accelerated touch"
+	depends on TOUCHSCREEN_WM97XX && AVR32
+	help
+	  Say Y here for support for streaming mode with WM97xx touchscreens on
+	  Atmel AVR32 systems with an AC97 controller.
+
+	  Be aware that this will use channel B in the controller for streaming
+	  data, this must not conflict with other AC97 drivers.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called at32-wm97xx.
+
 config TOUCHSCREEN_WM97XX_MAINSTONE
 	tristate "WM97xx Mainstone accelerated touch"
 	depends on TOUCHSCREEN_WM97XX && ARCH_PXA
diff -puN drivers/input/touchscreen/Makefile~input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors drivers/input/touchscreen/Makefile
--- a/drivers/input/touchscreen/Makefile~input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors
+++ a/drivers/input/touchscreen/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_TOUCHSCREEN_TSC2007)	+= tsc
 obj-$(CONFIG_TOUCHSCREEN_UCB1400)	+= ucb1400_ts.o
 obj-$(CONFIG_TOUCHSCREEN_WACOM_W8001)	+= wacom_w8001.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX)	+= wm97xx-ts.o
+obj-$(CONFIG_TOUCHSCREEN_WM97XX_AT32)	+= at32-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
diff -puN /dev/null drivers/input/touchscreen/at32-wm97xx.c
--- /dev/null
+++ a/drivers/input/touchscreen/at32-wm97xx.c
@@ -0,0 +1,423 @@
+/*
+ * Atmel AVR32 continuous touch screen driver for Wolfson WM97xx AC97 codecs.
+ *
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/wm97xx.h>
+#include <linux/io.h>
+#include <linux/timer.h>
+
+#include <asm/gpio.h>
+
+#include "at32-wm97xx.h"
+
+#ifdef CONFIG_CPU_AT32AP700X
+#define AT32_WM97XX_AC97C_IOMEM		0xfff02800
+#define AT32_WM97XX_AC97C_IRQ		29
+#define AT32_WM97XX_GPIO_DEFAULT	(32+16) /* Pin 16 on port B. */
+#else
+#error Unkown CPU, this driver only supports AT32AP700X CPUs.
+#endif
+
+struct continuous {
+	u16 id;    /* codec id */
+	u8 code;   /* continuous code */
+	u8 reads;  /* number of coord reads per read cycle */
+	u32 speed; /* number of coords per second */
+};
+
+#define WM_READS(sp) ((sp / HZ) + 1)
+
+static const struct continuous cinfo[] = {
+	{WM9705_ID2, 0, WM_READS(94), 94},
+	{WM9705_ID2, 1, WM_READS(188), 188},
+	{WM9705_ID2, 2, WM_READS(375), 375},
+	{WM9705_ID2, 3, WM_READS(750), 750},
+	{WM9712_ID2, 0, WM_READS(94), 94},
+	{WM9712_ID2, 1, WM_READS(188), 188},
+	{WM9712_ID2, 2, WM_READS(375), 375},
+	{WM9712_ID2, 3, WM_READS(750), 750},
+	{WM9713_ID2, 0, WM_READS(94), 94},
+	{WM9713_ID2, 1, WM_READS(120), 120},
+	{WM9713_ID2, 2, WM_READS(154), 154},
+	{WM9713_ID2, 3, WM_READS(188), 188},
+};
+
+/* Continuous speed index. */
+static int sp_idx;
+
+/*
+ * Pen sampling frequency (Hz) in continuous mode.
+ */
+static int cont_rate = 188;
+module_param(cont_rate, int, 0);
+MODULE_PARM_DESC(cont_rate, "Sampling rate in continuous mode (Hz)");
+
+/*
+ * Pen down detection.
+ *
+ * This driver can either poll or use an interrupt to indicate a pen down
+ * event. If the irq request fails then it will fall back to polling mode.
+ */
+static int pen_int = 1;
+module_param(pen_int, int, 0);
+MODULE_PARM_DESC(pen_int, "Pen down detection (1 = interrupt, 0 = polling)");
+
+/*
+ * Pressure readback.
+ *
+ * Set to 1 to read back pen down pressure.
+ */
+static int pressure;
+module_param(pressure, int, 0);
+MODULE_PARM_DESC(pressure, "Pressure readback (1 = pressure, 0 = no pressure)");
+
+/*
+ * AC97 touch data slot.
+ *
+ * Touch screen readback data ac97 slot.
+ */
+static int ac97_touch_slot = 5;
+module_param(ac97_touch_slot, int, 0);
+MODULE_PARM_DESC(ac97_touch_slot, "Touch screen data slot AC97 number");
+
+/*
+ * AT32AP700X GPIO line number.
+ *
+ * Set to GPIO number where the signal from the WM97xx device is hooked up.
+ */
+static int at32_gpio_line = AT32_WM97XX_GPIO_DEFAULT;
+module_param(at32_gpio_line, int, 0);
+MODULE_PARM_DESC(at32_gpio_line,
+		"GPIO line number on AT32AP700X connected to WM97xx");
+
+struct at32_wm97xx {
+	struct wm97xx		*wm;
+	struct timer_list	pen_timer;
+	void __iomem		*regs;
+	unsigned long		ac97c_irq;
+	unsigned long		gpio_pen;
+	unsigned long		gpio_irq;
+	unsigned short		x;
+	unsigned short		y;
+};
+
+static irqreturn_t at32_wm97xx_channel_b_interrupt(int irq, void *dev_id)
+{
+	struct at32_wm97xx *at32_wm97xx = dev_id;
+	struct wm97xx *wm = at32_wm97xx->wm;
+	int status = ac97c_readl(at32_wm97xx, CBSR);
+	int retval = IRQ_NONE;
+
+	if (status & AC97C_OVRUN) {
+		dev_dbg(&wm->touch_dev->dev, "AC97C overrun\n");
+		ac97c_readl(at32_wm97xx, CBRHR);
+		retval = IRQ_HANDLED;
+	} else if (status & AC97C_RXRDY) {
+		u16 data;
+		u16 value;
+		u16 source;
+		u16 pen_down;
+
+		data = ac97c_readl(at32_wm97xx, CBRHR);
+		value = data & 0x0fff;
+		source = data & WM97XX_ADCSRC_MASK;
+		pen_down = (data & WM97XX_PEN_DOWN) >> 8;
+
+		if (source == WM97XX_ADCSEL_X)
+			at32_wm97xx->x = value;
+		if (source == WM97XX_ADCSEL_Y)
+			at32_wm97xx->y = value;
+
+		if (!pressure && source == WM97XX_ADCSEL_Y) {
+			input_report_abs(wm->input_dev, ABS_X, at32_wm97xx->x);
+			input_report_abs(wm->input_dev, ABS_Y, at32_wm97xx->y);
+			input_report_abs(wm->input_dev, ABS_PRESSURE, pen_down);
+			input_report_key(wm->input_dev, BTN_TOUCH,
+					 (pen_down != 0));
+			input_sync(wm->input_dev);
+		} else if (pressure && source == WM97XX_ADCSEL_PRES) {
+			input_report_abs(wm->input_dev, ABS_X, at32_wm97xx->x);
+			input_report_abs(wm->input_dev, ABS_Y, at32_wm97xx->y);
+			input_report_abs(wm->input_dev, ABS_PRESSURE, value);
+			input_report_key(wm->input_dev, BTN_TOUCH,
+					 (value != 0));
+			input_sync(wm->input_dev);
+		}
+
+		retval = IRQ_HANDLED;
+	}
+
+	return retval;
+}
+
+static void at32_wm97xx_pen_timer(unsigned long data)
+{
+	struct at32_wm97xx *at32_wm97xx = (struct at32_wm97xx *)data;
+	struct wm97xx *wm = at32_wm97xx->wm;
+	int pen_down = gpio_get_value(at32_wm97xx->gpio_pen);
+
+	if (pen_down != 0) {
+		mod_timer(&at32_wm97xx->pen_timer, jiffies
+				+ msecs_to_jiffies(1));
+	} else {
+		input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
+		input_report_key(wm->input_dev, BTN_TOUCH, 0);
+		input_sync(wm->input_dev);
+	}
+}
+
+static void at32_wm97xx_acc_pen_up(struct wm97xx *wm)
+{
+	struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(wm->touch_dev);
+	int pen_down = gpio_get_value(at32_wm97xx->gpio_pen);
+
+	if (pen_down != 0) {
+		mod_timer(&at32_wm97xx->pen_timer, jiffies
+				+ msecs_to_jiffies(1));
+	} else {
+		input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
+		input_report_key(wm->input_dev, BTN_TOUCH, 0);
+		input_sync(wm->input_dev);
+	}
+}
+
+static int at32_wm97xx_acc_startup(struct wm97xx *wm)
+{
+	struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(wm->touch_dev);
+	int idx = 0;
+
+	if (wm->ac97 == NULL)
+		return -ENODEV;
+
+	for (idx = 0; idx < ARRAY_SIZE(cinfo); idx++) {
+		if (wm->id != cinfo[idx].id)
+			continue;
+
+		sp_idx = idx;
+
+		if (cont_rate <= cinfo[idx].speed)
+			break;
+	}
+
+	wm->acc_rate = cinfo[sp_idx].code;
+	wm->acc_slot = ac97_touch_slot;
+	dev_info(&wm->touch_dev->dev, "atmel accelerated touchscreen driver, "
+			"%d samples/sec\n", cinfo[sp_idx].speed);
+
+	if (pen_int) {
+		unsigned long reg;
+
+		wm->pen_irq = at32_wm97xx->gpio_irq;
+
+		switch (wm->id) {
+		case WM9712_ID2: /* Fall through. */
+		case WM9713_ID2:
+			/*
+			 * Use GPIO 13 (PEN_DOWN) to assert GPIO line 3
+			 * (PENDOWN).
+			 */
+			wm97xx_config_gpio(wm, WM97XX_GPIO_13, WM97XX_GPIO_IN,
+					WM97XX_GPIO_POL_HIGH,
+					WM97XX_GPIO_STICKY,
+					WM97XX_GPIO_WAKE);
+			wm97xx_config_gpio(wm, WM97XX_GPIO_3, WM97XX_GPIO_OUT,
+					WM97XX_GPIO_POL_HIGH,
+					WM97XX_GPIO_NOTSTICKY,
+					WM97XX_GPIO_NOWAKE);
+		case WM9705_ID2: /* Fall through. */
+			/*
+			 * Enable touch data slot in AC97 controller channel B.
+			 */
+			reg = ac97c_readl(at32_wm97xx, ICA);
+			reg &= ~AC97C_CH_MASK(wm->acc_slot);
+			reg |= AC97C_CH_ASSIGN(wm->acc_slot, B);
+			ac97c_writel(at32_wm97xx, ICA, reg);
+
+			/*
+			 * Enable channel and interrupt for RXRDY and OVERRUN.
+			 */
+			ac97c_writel(at32_wm97xx, CBMR, AC97C_CMR_CENA
+					| AC97C_CMR_CEM_BIG
+					| AC97C_CMR_SIZE_16
+					| AC97C_OVRUN
+					| AC97C_RXRDY);
+			/* Dummy read to empty RXRHR. */
+			ac97c_readl(at32_wm97xx, CBRHR);
+			/*
+			 * Enable interrupt for channel B in the AC97
+			 * controller.
+			 */
+			ac97c_writel(at32_wm97xx, IER, AC97C_INT_CBEVT);
+			break;
+		default:
+			dev_err(&wm->touch_dev->dev, "pen down irq not "
+					"supported on this device\n");
+			pen_int = 0;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void at32_wm97xx_acc_shutdown(struct wm97xx *wm)
+{
+	if (pen_int) {
+		struct at32_wm97xx *at32_wm97xx =
+			platform_get_drvdata(wm->touch_dev);
+		unsigned long ica;
+
+		switch (wm->id & 0xffff) {
+		case WM9705_ID2: /* Fall through. */
+		case WM9712_ID2: /* Fall through. */
+		case WM9713_ID2:
+			/* Disable slot and turn off channel B interrupts. */
+			ica = ac97c_readl(at32_wm97xx, ICA);
+			ica &= ~AC97C_CH_MASK(wm->acc_slot);
+			ac97c_writel(at32_wm97xx, ICA, ica);
+			ac97c_writel(at32_wm97xx, IDR, AC97C_INT_CBEVT);
+			ac97c_writel(at32_wm97xx, CBMR, 0);
+			wm->pen_irq = 0;
+			break;
+		default:
+			dev_err(&wm->touch_dev->dev, "unknown codec\n");
+			break;
+		}
+	}
+}
+
+static void at32_wm97xx_irq_enable(struct wm97xx *wm, int enable)
+{
+	/* Intentionally left empty. */
+}
+
+static struct wm97xx_mach_ops at32_mach_ops = {
+	.acc_enabled	= 1,
+	.acc_pen_up	= at32_wm97xx_acc_pen_up,
+	.acc_startup	= at32_wm97xx_acc_startup,
+	.acc_shutdown	= at32_wm97xx_acc_shutdown,
+	.irq_enable	= at32_wm97xx_irq_enable,
+	.irq_gpio	= WM97XX_GPIO_3,
+};
+
+static int __init at32_wm97xx_probe(struct platform_device *pdev)
+{
+	struct wm97xx *wm = platform_get_drvdata(pdev);
+	struct at32_wm97xx *at32_wm97xx;
+	int ret;
+
+	at32_wm97xx = kzalloc(sizeof(struct at32_wm97xx), GFP_KERNEL);
+	if (!at32_wm97xx) {
+		dev_dbg(&pdev->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	at32_wm97xx->wm		= wm;
+	at32_wm97xx->regs	= (void *)AT32_WM97XX_AC97C_IOMEM;
+	at32_wm97xx->ac97c_irq	= AT32_WM97XX_AC97C_IRQ;
+	at32_wm97xx->gpio_pen	= at32_gpio_line;
+	at32_wm97xx->gpio_irq	= gpio_to_irq(at32_wm97xx->gpio_pen);
+
+	setup_timer(&at32_wm97xx->pen_timer, at32_wm97xx_pen_timer,
+			(unsigned long)at32_wm97xx);
+
+	ret = request_irq(at32_wm97xx->ac97c_irq,
+			at32_wm97xx_channel_b_interrupt,
+			IRQF_SHARED, "at32-wm97xx-ch-b", at32_wm97xx);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not request ac97c irq\n");
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, at32_wm97xx);
+
+	ret = wm97xx_register_mach_ops(wm, &at32_mach_ops);
+	if (!ret)
+		return 0;
+
+	free_irq(at32_wm97xx->ac97c_irq, at32_wm97xx);
+err:
+	kfree(at32_wm97xx);
+	return ret;
+}
+
+static int __exit at32_wm97xx_remove(struct platform_device *pdev)
+{
+	struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(pdev);
+	struct wm97xx *wm = at32_wm97xx->wm;
+
+	ac97c_writel(at32_wm97xx, IDR, AC97C_INT_CBEVT);
+	free_irq(at32_wm97xx->ac97c_irq, at32_wm97xx);
+	wm97xx_unregister_mach_ops(wm);
+	kfree(at32_wm97xx);
+
+	platform_set_drvdata(wm->touch_dev, wm);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int at32_wm97xx_suspend(struct platform_device *pdev, pm_message_t msg)
+{
+	struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(pdev);
+
+	ac97c_writel(at32_wm97xx, IDR, AC97C_INT_CBEVT);
+	disable_irq(at32_wm97xx->gpio_irq);
+
+	return 0;
+}
+
+static int at32_wm97xx_resume(struct platform_device *pdev)
+{
+	struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(pdev);
+	struct wm97xx *wm = at32_wm97xx->wm;
+
+	if (wm->input_dev->users) {
+		enable_irq(at32_wm97xx->gpio_irq);
+		ac97c_writel(at32_wm97xx, IER, AC97C_INT_CBEVT);
+	}
+
+	return 0;
+}
+#else
+#define at32_wm97xx_suspend	NULL
+#define at32_wm97xx_resume	NULL
+#endif
+
+static struct platform_driver at32_wm97xx_driver = {
+	.remove		= __exit_p(at32_wm97xx_remove),
+	.driver		= {
+		.name = "wm97xx-touch",
+	},
+	.suspend	= at32_wm97xx_suspend,
+	.resume		= at32_wm97xx_resume,
+};
+
+static int __init at32_wm97xx_init(void)
+{
+	return platform_driver_probe(&at32_wm97xx_driver, at32_wm97xx_probe);
+}
+module_init(at32_wm97xx_init);
+
+static void __exit at32_wm97xx_exit(void)
+{
+	platform_driver_unregister(&at32_wm97xx_driver);
+}
+module_exit(at32_wm97xx_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("wm97xx continuous touch driver for Atmel AVR32");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/input/touchscreen/at32-wm97xx.h
--- /dev/null
+++ a/drivers/input/touchscreen/at32-wm97xx.h
@@ -0,0 +1,48 @@
+/*
+ * Atmel AVR32 continuous touch screen driver for Wolfson WM97xx AC97 codecs.
+ *
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _AT32_WM97XX_H
+#define _AT32_WM97XX_H
+
+#define AC97C_ICA		0x10
+#define AC97C_CBRHR		0x30
+#define AC97C_CBSR		0x38
+#define AC97C_CBMR		0x3c
+#define AC97C_IER		0x54
+#define AC97C_IDR		0x58
+
+#define AC97C_RXRDY		(1 << 4)
+#define AC97C_OVRUN		(1 << 5)
+
+#define AC97C_CMR_SIZE_20	(0 << 16)
+#define AC97C_CMR_SIZE_18	(1 << 16)
+#define AC97C_CMR_SIZE_16	(2 << 16)
+#define AC97C_CMR_SIZE_10	(3 << 16)
+#define AC97C_CMR_CEM_LITTLE	(1 << 18)
+#define AC97C_CMR_CEM_BIG	(0 << 18)
+#define AC97C_CMR_CENA		(1 << 21)
+
+#define AC97C_INT_CBEVT		(1 << 4)
+
+#define AC97C_SR_CAEVT		(1 << 3)
+
+#define AC97C_CH_MASK(slot)						\
+	(0x7 << (3 * (slot - 3)))
+#define AC97C_CH_ASSIGN(slot, channel)					\
+	(AC97C_CHANNEL_##channel << (3 * (slot - 3)))
+#define AC97C_CHANNEL_NONE	0x0
+#define AC97C_CHANNEL_B		0x2
+
+#define ac97c_writel(chip, reg, val)			\
+	__raw_writel((val), (chip)->regs + AC97C_##reg)
+#define ac97c_readl(chip, reg)				\
+	__raw_readl((chip)->regs + AC97C_##reg)
+
+#endif /* _AT32_WM97XX_H */
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch

