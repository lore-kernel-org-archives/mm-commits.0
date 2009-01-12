From: akpm@linux-foundation.org
Subject: + input-pcf50633-input-driver.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:44:53 -0800
Message-ID: <200901122244.n0CMirMM009416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759723AbZALWpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 17:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, dmitry.torokhov@gmail.com


The patch titled
     input: PCF50633 input driver
has been added to the -mm tree.  Its filename is
     input-pcf50633-input-driver.patch

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
Subject: input: PCF50633 input driver
From: Balaji Rao <balajirrao@openmoko.org>

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig          |    7 +
 drivers/input/misc/Makefile         |    1 
 drivers/input/misc/pcf50633-input.c |  132 ++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff -puN drivers/input/misc/Kconfig~input-pcf50633-input-driver drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~input-pcf50633-input-driver
+++ a/drivers/input/misc/Kconfig
@@ -220,4 +220,11 @@ config HP_SDC_RTC
 	  Say Y here if you want to support the built-in real time clock
 	  of the HP SDC controller.
 
+config INPUT_PCF50633_PMU
+	tristate "PCF50633 PMU events"
+	depends on MFD_PCF50633
+	help
+	 Say Y to include support for delivering  PMU events via  input
+	 layer on NXP PCF50633.
+
 endif
diff -puN drivers/input/misc/Makefile~input-pcf50633-input-driver drivers/input/misc/Makefile
--- a/drivers/input/misc/Makefile~input-pcf50633-input-driver
+++ a/drivers/input/misc/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
+obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
diff -puN /dev/null drivers/input/misc/pcf50633-input.c
--- /dev/null
+++ a/drivers/input/misc/pcf50633-input.c
@@ -0,0 +1,132 @@
+/* NXP PCF50633 Input Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+
+#include <linux/mfd/pcf50633/core.h>
+
+#define PCF50633_OOCSTAT_ONKEY	0x01
+#define PCF50633_REG_OOCSTAT	0x12
+#define PCF50633_REG_OOCMODE	0x10
+
+struct pcf50633_input {
+	struct pcf50633 *pcf;
+	struct input_dev *input_dev;
+};
+
+static void
+pcf50633_input_irq(int irq, void *data)
+{
+	struct pcf50633_input *input;
+	int onkey_released;
+
+	input = data;
+
+	/* We report only one event depending on the key press status */
+	onkey_released = pcf50633_reg_read(input->pcf, PCF50633_REG_OOCSTAT)
+						& PCF50633_OOCSTAT_ONKEY;
+
+	if (irq == PCF50633_IRQ_ONKEYF && !onkey_released)
+		input_report_key(input->input_dev, KEY_POWER, 1);
+	else if (irq == PCF50633_IRQ_ONKEYR && onkey_released)
+		input_report_key(input->input_dev, KEY_POWER, 0);
+
+	input_sync(input->input_dev);
+}
+
+static int __devinit pcf50633_input_probe(struct platform_device *pdev)
+{
+	struct pcf50633_input *input;
+	struct pcf50633_subdev_pdata *pdata = pdev->dev.platform_data;
+	struct input_dev *input_dev;
+	int ret;
+
+
+	input = kzalloc(sizeof(*input), GFP_KERNEL);
+	if (!input)
+		return -ENOMEM;
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		kfree(input);
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, input);
+	input->pcf = pdata->pcf;
+	input->input_dev = input_dev;
+
+	input_dev->name = "PCF50633 PMU events";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_PWR);
+	set_bit(KEY_POWER, input_dev->keybit);
+
+	ret = input_register_device(input_dev);
+	if (ret) {
+		input_free_device(input_dev);
+		kfree(input);
+		return ret;
+	}
+	pcf50633_register_irq(pdata->pcf, PCF50633_IRQ_ONKEYR,
+				pcf50633_input_irq, input);
+	pcf50633_register_irq(pdata->pcf, PCF50633_IRQ_ONKEYF,
+				pcf50633_input_irq, input);
+
+	return 0;
+}
+
+static int __devexit pcf50633_input_remove(struct platform_device *pdev)
+{
+	struct pcf50633_input *input  = platform_get_drvdata(pdev);
+
+	pcf50633_free_irq(input->pcf, PCF50633_IRQ_ONKEYR);
+	pcf50633_free_irq(input->pcf, PCF50633_IRQ_ONKEYF);
+
+	input_unregister_device(input->input_dev);
+	kfree(input);
+
+	return 0;
+}
+
+static struct platform_driver pcf50633_input_driver = {
+	.driver = {
+		.name = "pcf50633-input",
+	},
+	.probe = pcf50633_input_probe,
+	.remove = __devexit_p(pcf50633_input_remove),
+};
+
+static int __init pcf50633_input_init(void)
+{
+	return platform_driver_register(&pcf50633_input_driver);
+}
+module_init(pcf50633_input_init);
+
+static void __exit pcf50633_input_exit(void)
+{
+	platform_driver_unregister(&pcf50633_input_driver);
+}
+module_exit(pcf50633_input_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 input driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-input");
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

mfd-pcf50633-core-driver.patch
mfd-pcf50633-adc-driver.patch
mfd-pcf50633-gpio-support.patch
rtc-pcf50633-rtc-driver.patch
power_supply-pcf50633-battery-charger-driver.patch
input-pcf50633-input-driver.patch
regulator-pcf50633-pmic-driver.patch

