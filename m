From: akpm@linux-foundation.org
Subject: + driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:09:33 -0800
Message-ID: <200802280709.m1S79XKl020898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbYB1HVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dbaryshkov@gmail.com, dtor@mail.ru, gg@opensource.wolfsonmicro.com, giometti@enneenne.com, jikos@jikos.cz, liam.girdwood@wolfsonmicro.com, linux01@architechnical.net, mike.arthur@wolfsonmicro.com, mkl@pengutronix.de, rmk@arm.linux.org.uk, spyro@f2s.com, stanley.cai@intel.com, vince@kyllikki.org, zap@homelink.ru


The patch titled
     Driver for WM97xx touchscreens in streaming mode on Mainstone
has been added to the -mm tree.  Its filename is
     driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Driver for WM97xx touchscreens in streaming mode on Mainstone
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Signed-off-by: Graeme Gregory <gg@opensource.wolfsonmicro.com>
Signed-off-by: Mike Arthur <mike.arthur@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Stanley Cai <stanley.cai@intel.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Pete MacKay <linux01@architechnical.net>
Cc: Ian Molton <spyro@f2s.com>
Cc: Vince Sanders <vince@kyllikki.org>
Cc: Andrew Zabolotny <zap@homelink.ru>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/mainstone-wm97xx.c |  298 +++++++++++++++++
 1 file changed, 298 insertions(+)

diff -puN /dev/null drivers/input/touchscreen/mainstone-wm97xx.c
--- /dev/null
+++ a/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -0,0 +1,298 @@
+/*
+ * mainstone-wm97xx.c  --  Mainstone Continuous Touch screen driver for
+ *                         Wolfson WM97xx AC97 Codecs.
+ *
+ * Copyright 2004, 2007 Wolfson Microelectronics PLC.
+ * Author: Liam Girdwood
+ *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Parts Copyright : Ian Molton <spyro@f2s.com>
+ *                   Andrew Zabolotny <zap@homelink.ru>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ * Notes:
+ *     This is a wm97xx extended touch driver to capture touch
+ *     data in a continuous manner on the Intel XScale archictecture
+ *
+ *  Features:
+ *       - codecs supported:- WM9705, WM9712, WM9713
+ *       - processors supported:- Intel XScale PXA25x, PXA26x, PXA27x
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/wm97xx.h>
+#include <linux/io.h>
+#include <asm/arch/pxa-regs.h>
+
+#define VERSION		"0.13"
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
+/* continuous speed index */
+static int sp_idx;
+static u16 last, tries;
+
+/*
+ * Pen sampling frequency (Hz) in continuous mode.
+ */
+static int cont_rate = 200;
+module_param(cont_rate, int, 0);
+MODULE_PARM_DESC(cont_rate, "Sampling rate in continuous mode (Hz)");
+
+/*
+ * Pen down detection.
+ *
+ * This driver can either poll or use an interrupt to indicate a pen down
+ * event. If the irq request fails then it will fall back to polling mode.
+ */
+static int pen_int;
+module_param(pen_int, int, 0);
+MODULE_PARM_DESC(pen_int, "Pen down detection (1 = interrupt, 0 = polling)");
+
+/*
+ * Pressure readback.
+ *
+ * Set to 1 to read back pen down pressure
+ */
+static int pressure;
+module_param(pressure, int, 0);
+MODULE_PARM_DESC(pressure, "Pressure readback (1 = pressure, 0 = no pressure)");
+
+/*
+ * AC97 touch data slot.
+ *
+ * Touch screen readback data ac97 slot
+ */
+static int ac97_touch_slot = 5;
+module_param(ac97_touch_slot, int, 0);
+MODULE_PARM_DESC(ac97_touch_slot, "Touch screen data slot AC97 number");
+
+
+/* flush AC97 slot 5 FIFO on pxa machines */
+#ifdef CONFIG_PXA27x
+static void wm97xx_acc_pen_up(struct wm97xx *wm)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(1);
+
+	while (MISR & (1 << 2))
+		MODR;
+}
+#else
+static void wm97xx_acc_pen_up(struct wm97xx *wm)
+{
+	int count = 16;
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(1);
+
+	while (count < 16) {
+		MODR;
+		count--;
+	}
+}
+#endif
+
+static int wm97xx_acc_pen_down(struct wm97xx *wm)
+{
+	u16 x, y, p = 0x100 | WM97XX_ADCSEL_PRES;
+	int reads = 0;
+
+	/* data is never immediately available after pen down irq */
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(1);
+
+	if (tries > 5) {
+		tries = 0;
+		return RC_PENUP;
+	}
+
+	x = MODR;
+	if (x == last) {
+		tries++;
+		return RC_AGAIN;
+	}
+	last = x;
+	do {
+		if (reads)
+			x = MODR;
+		y = MODR;
+		if (pressure)
+			p = MODR;
+
+		/* are samples valid */
+		if ((x & 0x7000) != WM97XX_ADCSEL_X ||
+			(y & 0x7000) != WM97XX_ADCSEL_Y ||
+			(p & 0x7000) != WM97XX_ADCSEL_PRES)
+			goto up;
+
+		/* coordinate is good */
+		tries = 0;
+		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
+		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
+		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
+		input_sync(wm->input_dev);
+		reads++;
+	} while (reads < cinfo[sp_idx].reads);
+up:
+	return RC_PENDOWN | RC_AGAIN;
+}
+
+static int wm97xx_acc_startup(struct wm97xx *wm)
+{
+	int idx = 0;
+
+	/* check we have a codec */
+	if (wm->ac97 == NULL)
+		return -ENODEV;
+
+	/* Go you big red fire engine */
+	for (idx = 0; idx < ARRAY_SIZE(cinfo); idx++) {
+		if (wm->id != cinfo[idx].id)
+			continue;
+		sp_idx = idx;
+		if (cont_rate <= cinfo[idx].speed)
+			break;
+	}
+	wm->acc_rate = cinfo[sp_idx].code;
+	wm->acc_slot = ac97_touch_slot;
+	dev_info(wm->dev,
+		 "mainstone accelerated touchscreen driver, %d samples/sec\n",
+		 cinfo[sp_idx].speed);
+
+	/* codec specific irq config */
+	if (pen_int) {
+		switch (wm->id) {
+		case WM9705_ID2:
+			wm->pen_irq = IRQ_GPIO(4);
+			set_irq_type(IRQ_GPIO(4), IRQT_BOTHEDGE);
+			break;
+		case WM9712_ID2:
+		case WM9713_ID2:
+			/* enable pen down interrupt */
+			/* use PEN_DOWN GPIO 13 to assert IRQ on GPIO line 2 */
+			wm->pen_irq = MAINSTONE_AC97_IRQ;
+			wm97xx_config_gpio(wm, WM97XX_GPIO_13, WM97XX_GPIO_IN,
+					   WM97XX_GPIO_POL_HIGH,
+					   WM97XX_GPIO_STICKY,
+					   WM97XX_GPIO_WAKE);
+			wm97xx_config_gpio(wm, WM97XX_GPIO_2, WM97XX_GPIO_OUT,
+					   WM97XX_GPIO_POL_HIGH,
+					   WM97XX_GPIO_NOTSTICKY,
+					   WM97XX_GPIO_NOWAKE);
+			break;
+		default:
+			dev_err(wm->dev,
+				"pen down irq not supported on this device\n");
+			pen_int = 0;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void wm97xx_acc_shutdown(struct wm97xx *wm)
+{
+	/* codec specific deconfig */
+	if (pen_int) {
+		switch (wm->id & 0xffff) {
+		case WM9705_ID2:
+			wm->pen_irq = 0;
+			break;
+		case WM9712_ID2:
+		case WM9713_ID2:
+			/* disable interrupt */
+			wm->pen_irq = 0;
+			break;
+		}
+	}
+}
+
+static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
+{
+	if (enable)
+		enable_irq(wm->pen_irq);
+	else
+		disable_irq(wm->pen_irq);
+}
+
+static struct wm97xx_mach_ops mainstone_mach_ops = {
+	.acc_enabled = 1,
+	.acc_pen_up = wm97xx_acc_pen_up,
+	.acc_pen_down = wm97xx_acc_pen_down,
+	.acc_startup = wm97xx_acc_startup,
+	.acc_shutdown = wm97xx_acc_shutdown,
+	.irq_enable = wm97xx_irq_enable,
+};
+
+static int mainstone_wm97xx_probe(struct platform_device *pdev)
+{
+	struct wm97xx *wm = platform_get_drvdata(pdev);
+	return wm97xx_register_mach_ops(wm, &mainstone_mach_ops);
+}
+
+static int mainstone_wm97xx_remove(struct platform_device *pdev)
+{
+	struct wm97xx *wm = platform_get_drvdata(pdev);
+	wm97xx_unregister_mach_ops(wm);
+	return 0;
+}
+
+static struct platform_driver mainstone_wm97xx_driver = {
+	.probe = mainstone_wm97xx_probe,
+	.remove = mainstone_wm97xx_remove,
+	.driver = {
+		.name = "wm97xx-touch",
+	},
+};
+
+static int __init mainstone_wm97xx_init(void)
+{
+	return platform_driver_register(&mainstone_wm97xx_driver);
+}
+
+static void __exit mainstone_wm97xx_exit(void)
+{
+	platform_driver_unregister(&mainstone_wm97xx_driver);
+}
+
+module_init(mainstone_wm97xx_init);
+module_exit(mainstone_wm97xx_exit);
+
+/* Module information */
+MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_DESCRIPTION("wm97xx continuous touch driver for mainstone");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa.patch
core-driver-for-wm97xx-touchscreens.patch
add-chip-driver-for-wm9705-touchscreen.patch
add-chip-driver-for-wm9712-touchscreen.patch
add-chip-driver-for-wm9713-touchscreen.patch
driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
