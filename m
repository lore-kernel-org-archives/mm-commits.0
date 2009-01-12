From: akpm@linux-foundation.org
Subject: + mfd-pcf50633-adc-driver.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:44:42 -0800
Message-ID: <200901122244.n0CMigmQ009253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759735AbZALWpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 17:45:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, jonathan.cameron@gmail.com, sameo@openedhand.com


The patch titled
     mfd: PCF50633 adc driver
has been added to the -mm tree.  Its filename is
     mfd-pcf50633-adc-driver.patch

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
Subject: mfd: PCF50633 adc driver
From: Balaji Rao <balajirrao@openmoko.org>

Add basic support for the PCF50633 ADC.  The subtractive mode is not
supported yet.

Since we don't have adc subsystem, it currently lives in drivers/mfd.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Acked-by: Jonathan Cameron <jonathan.cameron@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig              |    7 
 drivers/mfd/Makefile             |    1 
 drivers/mfd/pcf50633-adc.c       |  277 +++++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/adc.h |   72 +++++++
 4 files changed, 357 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-pcf50633-adc-driver drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-pcf50633-adc-driver
+++ a/drivers/mfd/Kconfig
@@ -226,6 +226,13 @@ config MFD_PCF50633
 	  facilities, and registers devices for the various functions
 	  so that function-specific drivers can bind to them.
 
+config PCF50633_ADC
+	tristate "Support for NXP PCF50633 ADC"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support for ADC in the
+	 NXP PCF50633 chip.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -puN drivers/mfd/Makefile~mfd-pcf50633-adc-driver drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-pcf50633-adc-driver
+++ a/drivers/mfd/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_co
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
+obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
diff -puN /dev/null drivers/mfd/pcf50633-adc.c
--- /dev/null
+++ a/drivers/mfd/pcf50633-adc.c
@@ -0,0 +1,277 @@
+/* NXP PCF50633 ADC Driver
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
+ *  NOTE: This driver does not yet support subtractive ADC mode, which means
+ *  you can do only one measurement per read request.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/completion.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/adc.h>
+
+struct pcf50633_adc_request {
+	int mux;
+	int avg;
+	int result;
+	void (*callback)(struct pcf50633 *, void *, int);
+	void *callback_param;
+
+	/* Used in case of sync requests */
+	struct completion completion;
+
+};
+
+#define PCF50633_MAX_ADC_FIFO_DEPTH 8
+
+struct pcf50633_adc {
+	struct pcf50633 *pcf;
+
+	/* Private stuff */
+	struct pcf50633_adc_request *queue[PCF50633_MAX_ADC_FIFO_DEPTH];
+	int queue_head;
+	int queue_tail;
+	struct mutex queue_mutex;
+};
+
+static inline struct pcf50633_adc *__to_adc(struct pcf50633 *pcf)
+{
+	return platform_get_drvdata(pcf->adc_pdev);
+}
+
+static void adc_setup(struct pcf50633 *pcf, int channel, int avg)
+{
+	channel &= PCF50633_ADCC1_ADCMUX_MASK;
+
+	/* kill ratiometric, but enable ACCSW biasing */
+	pcf50633_reg_write(pcf, PCF50633_REG_ADCC2, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_ADCC3, 0x01);
+
+	/* start ADC conversion on selected channel */
+	pcf50633_reg_write(pcf, PCF50633_REG_ADCC1, channel | avg |
+		    PCF50633_ADCC1_ADCSTART | PCF50633_ADCC1_RES_10BIT);
+}
+
+static void trigger_next_adc_job_if_any(struct pcf50633 *pcf)
+{
+	struct pcf50633_adc *adc = __to_adc(pcf);
+	int head;
+
+	mutex_lock(&adc->queue_mutex);
+
+	head = adc->queue_head;
+
+	if (!adc->queue[head]) {
+		mutex_unlock(&adc->queue_mutex);
+		return;
+	}
+	mutex_unlock(&adc->queue_mutex);
+
+	adc_setup(pcf, adc->queue[head]->mux, adc->queue[head]->avg);
+}
+
+static int
+adc_enqueue_request(struct pcf50633 *pcf, struct pcf50633_adc_request *req)
+{
+	struct pcf50633_adc *adc = __to_adc(pcf);
+	int head, tail;
+
+	mutex_lock(&adc->queue_mutex);
+
+	head = adc->queue_head;
+	tail = adc->queue_tail;
+
+	if (adc->queue[tail]) {
+		mutex_unlock(&adc->queue_mutex);
+		return -EBUSY;
+	}
+
+	adc->queue[tail] = req;
+	adc->queue_tail = (tail + 1) & (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
+
+	mutex_unlock(&adc->queue_mutex);
+
+	trigger_next_adc_job_if_any(pcf);
+
+	return 0;
+}
+
+static void
+pcf50633_adc_sync_read_callback(struct pcf50633 *pcf, void *param, int result)
+{
+	struct pcf50633_adc_request *req = param;
+
+	req->result = result;
+	complete(&req->completion);
+}
+
+int pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg)
+{
+	struct pcf50633_adc_request *req;
+
+	/* req is freed when the result is ready, in interrupt handler */
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->mux = mux;
+	req->avg = avg;
+	req->callback =  pcf50633_adc_sync_read_callback;
+	req->callback_param = req;
+
+	init_completion(&req->completion);
+	adc_enqueue_request(pcf, req);
+	wait_for_completion(&req->completion);
+
+	return req->result;
+}
+EXPORT_SYMBOL_GPL(pcf50633_adc_sync_read);
+
+int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
+			     void (*callback)(struct pcf50633 *, void *, int),
+			     void *callback_param)
+{
+	struct pcf50633_adc_request *req;
+
+	/* req is freed when the result is ready, in interrupt handler */
+	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->mux = mux;
+	req->avg = avg;
+	req->callback = callback;
+	req->callback_param = callback_param;
+
+	adc_enqueue_request(pcf, req);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcf50633_adc_async_read);
+
+static int adc_result(struct pcf50633 *pcf)
+{
+	u8 adcs1, adcs3;
+	u16 result;
+
+	adcs1 = pcf50633_reg_read(pcf, PCF50633_REG_ADCS1);
+	adcs3 = pcf50633_reg_read(pcf, PCF50633_REG_ADCS3);
+	result = (adcs1 << 2) | (adcs3 & PCF50633_ADCS3_ADCDAT1L_MASK);
+
+	dev_dbg(pcf->dev, "adc result = %d\n", result);
+
+	return result;
+}
+
+static void pcf50633_adc_irq(int irq, void *data)
+{
+	struct pcf50633_adc *adc = data;
+	struct pcf50633 *pcf = adc->pcf;
+	struct pcf50633_adc_request *req;
+	int head;
+
+	mutex_lock(&adc->queue_mutex);
+	head = adc->queue_head;
+
+	req = adc->queue[head];
+	if (WARN_ON(!req)) {
+		dev_err(pcf->dev, "pcf50633-adc irq: ADC queue empty!\n");
+		mutex_unlock(&adc->queue_mutex);
+		return;
+	}
+	adc->queue[head] = NULL;
+	adc->queue_head = (head + 1) &
+				      (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
+
+	mutex_unlock(&adc->queue_mutex);
+
+	req->callback(pcf, req->callback_param, adc_result(pcf));
+	kfree(req);
+
+	trigger_next_adc_job_if_any(pcf);
+}
+
+static int __devinit pcf50633_adc_probe(struct platform_device *pdev)
+{
+	struct pcf50633_subdev_pdata *pdata = pdev->dev.platform_data;
+	struct pcf50633_adc *adc;
+
+	adc = kzalloc(sizeof(*adc), GFP_KERNEL);
+	if (!adc)
+		return -ENOMEM;
+
+	adc->pcf = pdata->pcf;
+	platform_set_drvdata(pdev, adc);
+
+	pcf50633_register_irq(pdata->pcf, PCF50633_IRQ_ADCRDY,
+					pcf50633_adc_irq, adc);
+
+	mutex_init(&adc->queue_mutex);
+
+	return 0;
+}
+
+static int __devexit pcf50633_adc_remove(struct platform_device *pdev)
+{
+	struct pcf50633_adc *adc = platform_get_drvdata(pdev);
+	int i, head;
+
+	pcf50633_free_irq(adc->pcf, PCF50633_IRQ_ADCRDY);
+
+	mutex_lock(&adc->queue_mutex);
+	head = adc->queue_head;
+
+	if (WARN_ON(adc->queue[head]))
+		dev_err(adc->pcf->dev,
+			"adc driver removed with request pending\n");
+
+	for (i = 0; i < PCF50633_MAX_ADC_FIFO_DEPTH; i++)
+		kfree(adc->queue[i]);
+
+	mutex_unlock(&adc->queue_mutex);
+	kfree(adc);
+
+	return 0;
+}
+
+static struct platform_driver pcf50633_adc_driver = {
+	.driver = {
+		.name = "pcf50633-adc",
+	},
+	.probe = pcf50633_adc_probe,
+	.remove = __devexit_p(pcf50633_adc_remove),
+};
+
+static int __init pcf50633_adc_init(void)
+{
+	return platform_driver_register(&pcf50633_adc_driver);
+}
+module_init(pcf50633_adc_init);
+
+static void __exit pcf50633_adc_exit(void)
+{
+	platform_driver_unregister(&pcf50633_adc_driver);
+}
+module_exit(pcf50633_adc_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 adc driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-adc");
+
diff -puN /dev/null include/linux/mfd/pcf50633/adc.h
--- /dev/null
+++ a/include/linux/mfd/pcf50633/adc.h
@@ -0,0 +1,72 @@
+/*
+ * adc.h  -- Driver for NXP PCF50633 ADC
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_ADC_H
+#define __LINUX_MFD_PCF50633_ADC_H
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/platform_device.h>
+
+/* ADC Registers */
+#define PCF50633_REG_ADCC3		0x52
+#define PCF50633_REG_ADCC2		0x53
+#define PCF50633_REG_ADCC1		0x54
+#define PCF50633_REG_ADCS1		0x55
+#define PCF50633_REG_ADCS2		0x56
+#define PCF50633_REG_ADCS3		0x57
+
+#define PCF50633_ADCC1_ADCSTART		0x01
+#define PCF50633_ADCC1_RES_10BIT	0x02
+#define PCF50633_ADCC1_AVERAGE_NO	0x00
+#define PCF50633_ADCC1_AVERAGE_4	0x04
+#define PCF50633_ADCC1_AVERAGE_8	0x08
+#define PCF50633_ADCC1_AVERAGE_16	0x0c
+#define PCF50633_ADCC1_MUX_BATSNS_RES	0x00
+#define PCF50633_ADCC1_MUX_BATSNS_SUBTR	0x10
+#define PCF50633_ADCC1_MUX_ADCIN2_RES	0x20
+#define PCF50633_ADCC1_MUX_ADCIN2_SUBTR	0x30
+#define PCF50633_ADCC1_MUX_BATTEMP	0x60
+#define PCF50633_ADCC1_MUX_ADCIN1	0x70
+#define PCF50633_ADCC1_AVERAGE_MASK	0x0c
+#define PCF50633_ADCC1_ADCMUX_MASK	0xf0
+
+#define PCF50633_ADCC2_RATIO_NONE	0x00
+#define PCF50633_ADCC2_RATIO_BATTEMP	0x01
+#define PCF50633_ADCC2_RATIO_ADCIN1	0x02
+#define PCF50633_ADCC2_RATIO_BOTH	0x03
+#define PCF50633_ADCC2_RATIOSETTL_100US 0x04
+
+#define PCF50633_ADCC3_ACCSW_EN		0x01
+#define PCF50633_ADCC3_NTCSW_EN		0x04
+#define PCF50633_ADCC3_RES_DIV_TWO	0x10
+#define PCF50633_ADCC3_RES_DIV_THREE	0x00
+
+#define PCF50633_ADCS3_REF_NTCSW	0x00
+#define PCF50633_ADCS3_REF_ACCSW	0x10
+#define PCF50633_ADCS3_REF_2V0		0x20
+#define PCF50633_ADCS3_REF_VISA		0x30
+#define PCF50633_ADCS3_REF_2V0_2	0x70
+#define PCF50633_ADCS3_ADCRDY		0x80
+
+#define PCF50633_ADCS3_ADCDAT1L_MASK	0x03
+#define PCF50633_ADCS3_ADCDAT2L_MASK	0x0c
+#define PCF50633_ADCS3_ADCDAT2L_SHIFT	2
+#define PCF50633_ASCS3_REF_MASK		0x70
+
+extern int
+pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
+		void (*callback)(struct pcf50633 *, void *, int),
+		void *callback_param);
+extern int
+pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg);
+
+#endif /* __LINUX_PCF50633_ADC_H */
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

mfd-pcf50633-core-driver.patch
mfd-pcf50633-adc-driver.patch
mfd-pcf50633-gpio-support.patch
rtc-pcf50633-rtc-driver.patch
power_supply-pcf50633-battery-charger-driver.patch
input-pcf50633-input-driver.patch
regulator-pcf50633-pmic-driver.patch

