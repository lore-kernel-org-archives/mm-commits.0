From: akpm@linux-foundation.org
Subject: [merged] mfd-pcf50633-core-driver.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:06 -0800
Message-ID: <200901132013.n0DKD6M4012234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbZAMUN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@openmoko.org, andy@openmoko.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: PCF50633 core driver
has been removed from the -mm tree.  Its filename was
     mfd-pcf50633-core-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: PCF50633 core driver
From: Balaji Rao <balajirrao@openmoko.org>

Implement the core of the PCF50633 driver.  This core driver has generic
register read/write functions and does interrupt management for its sub
devices.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig               |    9 
 drivers/mfd/Makefile              |    2 
 drivers/mfd/pcf50633-core.c       |  710 ++++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/core.h |  218 ++++++++
 4 files changed, 939 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-pcf50633-core-driver drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-pcf50633-core-driver
+++ a/drivers/mfd/Kconfig
@@ -217,6 +217,15 @@ config MFD_WM8350_I2C
 	  I2C as the control interface.  Additional options must be
 	  selected to enable support for the functionality of the chip.
 
+config MFD_PCF50633
+	tristate "Support for NXP PCF50633"
+	depends on I2C
+	help
+	  Say yes here if you have NXP PCF50633 chip on your board.
+	  This core driver provides register access and IRQ handling
+	  facilities, and registers devices for the various functions
+	  so that function-specific drivers can bind to them.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -puN drivers/mfd/Makefile~mfd-pcf50633-core-driver drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-pcf50633-core-driver
+++ a/drivers/mfd/Makefile
@@ -37,3 +37,5 @@ endif
 obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
+
+obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
diff -puN /dev/null drivers/mfd/pcf50633-core.c
--- /dev/null
+++ a/drivers/mfd/pcf50633-core.c
@@ -0,0 +1,710 @@
+/* NXP PCF50633 Power Management Unit (PMU) driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * 	   Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+
+#include <linux/mfd/pcf50633/core.h>
+
+/* Two MBCS registers used during cold start */
+#define PCF50633_REG_MBCS1		0x4b
+#define PCF50633_REG_MBCS2		0x4c
+#define PCF50633_MBCS1_USBPRES 		0x01
+#define PCF50633_MBCS1_ADAPTPRES	0x01
+
+static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(pcf->i2c_client, reg,
+				num, data);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error reading %d regs at %d\n", num, reg);
+
+	return ret;
+}
+
+static int __pcf50633_write(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
+{
+	int ret;
+
+	ret = i2c_smbus_write_i2c_block_data(pcf->i2c_client, reg,
+				num, data);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error writing %d regs at %d\n", num, reg);
+
+	return ret;
+
+}
+
+/* Read a block of upto 32 regs  */
+int pcf50633_read_block(struct pcf50633 *pcf, u8 reg,
+					int nr_regs, u8 *data)
+{
+	int ret;
+
+	mutex_lock(&pcf->lock);
+	ret = __pcf50633_read(pcf, reg, nr_regs, data);
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_read_block);
+
+/* Write a block of upto 32 regs  */
+int pcf50633_write_block(struct pcf50633 *pcf , u8 reg,
+					int nr_regs, u8 *data)
+{
+	int ret;
+
+	mutex_lock(&pcf->lock);
+	ret = __pcf50633_write(pcf, reg, nr_regs, data);
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_write_block);
+
+u8 pcf50633_reg_read(struct pcf50633 *pcf, u8 reg)
+{
+	u8 val;
+
+	mutex_lock(&pcf->lock);
+	__pcf50633_read(pcf, reg, 1, &val);
+	mutex_unlock(&pcf->lock);
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_read);
+
+int pcf50633_reg_write(struct pcf50633 *pcf, u8 reg, u8 val)
+{
+	int ret;
+
+	mutex_lock(&pcf->lock);
+	ret = __pcf50633_write(pcf, reg, 1, &val);
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_write);
+
+int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	val &= mask;
+
+	mutex_lock(&pcf->lock);
+	ret = __pcf50633_read(pcf, reg, 1, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp &= ~mask;
+	tmp |= val;
+	ret = __pcf50633_write(pcf, reg, 1, &tmp);
+
+out:
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_set_bit_mask);
+
+int pcf50633_reg_clear_bits(struct pcf50633 *pcf, u8 reg, u8 val)
+{
+	int ret;
+	u8 tmp;
+
+	mutex_lock(&pcf->lock);
+	ret = __pcf50633_read(pcf, reg, 1, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp &= ~val;
+	ret = __pcf50633_write(pcf, reg, 1, &tmp);
+
+out:
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_reg_clear_bits);
+
+/* sysfs attributes */
+static ssize_t show_dump_regs(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct pcf50633 *pcf = dev_get_drvdata(dev);
+	u8 dump[16];
+	int n, n1, idx = 0;
+	char *buf1 = buf;
+	static u8 address_no_read[] = { /* must be ascending */
+		PCF50633_REG_INT1,
+		PCF50633_REG_INT2,
+		PCF50633_REG_INT3,
+		PCF50633_REG_INT4,
+		PCF50633_REG_INT5,
+		0 /* terminator */
+	};
+
+	for (n = 0; n < 256; n += sizeof(dump)) {
+		for (n1 = 0; n1 < sizeof(dump); n1++)
+			if (n == address_no_read[idx]) {
+				idx++;
+				dump[n1] = 0x00;
+			} else
+				dump[n1] = pcf50633_reg_read(pcf, n + n1);
+
+		hex_dump_to_buffer(dump, sizeof(dump), 16, 1, buf1, 128, 0);
+		buf1 += strlen(buf1);
+		*buf1++ = '\n';
+		*buf1 = '\0';
+	}
+
+	return buf1 - buf;
+}
+static DEVICE_ATTR(dump_regs, 0400, show_dump_regs, NULL);
+
+static ssize_t show_resume_reason(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pcf50633 *pcf = dev_get_drvdata(dev);
+	int n;
+
+	n = sprintf(buf, "%02x%02x%02x%02x%02x\n",
+				pcf->resume_reason[0],
+				pcf->resume_reason[1],
+				pcf->resume_reason[2],
+				pcf->resume_reason[3],
+				pcf->resume_reason[4]);
+
+	return n;
+}
+static DEVICE_ATTR(resume_reason, 0400, show_resume_reason, NULL);
+
+static struct attribute *pcf_sysfs_entries[] = {
+	&dev_attr_dump_regs.attr,
+	&dev_attr_resume_reason.attr,
+	NULL,
+};
+
+static struct attribute_group pcf_attr_group = {
+	.name	= NULL,			/* put in device directory */
+	.attrs	= pcf_sysfs_entries,
+};
+
+int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
+			void (*handler) (int, void *), void *data)
+{
+	if (irq < 0 || irq > PCF50633_NUM_IRQ || !handler)
+		return -EINVAL;
+
+	if (WARN_ON(pcf->irq_handler[irq].handler))
+		return -EBUSY;
+
+	mutex_lock(&pcf->lock);
+	pcf->irq_handler[irq].handler = handler;
+	pcf->irq_handler[irq].data = data;
+	mutex_unlock(&pcf->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcf50633_register_irq);
+
+int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
+{
+	if (irq < 0 || irq > PCF50633_NUM_IRQ)
+		return -EINVAL;
+
+	mutex_lock(&pcf->lock);
+	pcf->irq_handler[irq].handler = NULL;
+	mutex_unlock(&pcf->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcf50633_free_irq);
+
+static int __pcf50633_irq_mask_set(struct pcf50633 *pcf, int irq, u8 mask)
+{
+	u8 reg, bits, tmp;
+	int ret = 0, idx;
+
+	idx = irq >> 3;
+	reg =  PCF50633_REG_INT1M + idx;
+	bits = 1 << (irq & 0x07);
+
+	mutex_lock(&pcf->lock);
+
+	if (mask) {
+		ret = __pcf50633_read(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		tmp |= bits;
+
+		ret = __pcf50633_write(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		pcf->mask_regs[idx] &= ~bits;
+		pcf->mask_regs[idx] |= bits;
+	} else {
+		ret = __pcf50633_read(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		tmp &= ~bits;
+
+		ret = __pcf50633_write(pcf, reg, 1, &tmp);
+		if (ret < 0)
+			goto out;
+
+		pcf->mask_regs[idx] &= ~bits;
+	}
+out:
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+
+int pcf50633_irq_mask(struct pcf50633 *pcf, int irq)
+{
+	dev_info(pcf->dev, "Masking IRQ %d\n", irq);
+
+	return __pcf50633_irq_mask_set(pcf, irq, 1);
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_mask);
+
+int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq)
+{
+	dev_info(pcf->dev, "Unmasking IRQ %d\n", irq);
+
+	return __pcf50633_irq_mask_set(pcf, irq, 0);
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_unmask);
+
+int pcf50633_irq_mask_get(struct pcf50633 *pcf, int irq)
+{
+	u8 reg, bits;
+
+	reg =  irq >> 3;
+	bits = 1 << (irq & 0x07);
+
+	return pcf->mask_regs[reg] & bits;
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_mask_get);
+
+static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
+{
+	if (pcf->irq_handler[irq].handler)
+		pcf->irq_handler[irq].handler(irq, pcf->irq_handler[irq].data);
+}
+
+/* Maximum amount of time ONKEY is held before emergency action is taken */
+#define PCF50633_ONKEY1S_TIMEOUT 8
+
+static void pcf50633_irq_worker(struct work_struct *work)
+{
+	struct pcf50633 *pcf;
+	int ret, i, j;
+	u8 pcf_int[5], chgstat;
+
+	pcf = container_of(work, struct pcf50633, irq_work);
+
+	/* Read the 5 INT regs in one transaction */
+	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
+						ARRAY_SIZE(pcf_int), pcf_int);
+	if (ret != ARRAY_SIZE(pcf_int)) {
+		dev_err(pcf->dev, "Error reading INT registers\n");
+
+		/*
+		 * If this doesn't ACK the interrupt to the chip, we'll be
+		 * called once again as we're level triggered.
+		 */
+		goto out;
+	}
+
+	/* We immediately read the usb and adapter status. We thus make sure
+	 * only of USBINS/USBREM IRQ handlers are called */
+	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
+		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+		if (chgstat & (0x3 << 4))
+			pcf_int[0] &= ~(1 << PCF50633_INT1_USBREM);
+		else
+			pcf_int[0] &= ~(1 << PCF50633_INT1_USBINS);
+	}
+
+	/* Make sure only one of ADPINS or ADPREM is set */
+	if (pcf_int[0] & (PCF50633_INT1_ADPINS | PCF50633_INT1_ADPREM)) {
+		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+		if (chgstat & (0x3 << 4))
+			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPREM);
+		else
+			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPINS);
+	}
+
+	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
+			"INT4=0x%02x INT5=0x%02x\n", pcf_int[0],
+			pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
+
+	/* Some revisions of the chip don't have a 8s standby mode on
+	 * ONKEY1S press. We try to manually do it in such cases. */
+	if ((pcf_int[0] & PCF50633_INT1_SECOND) && pcf->onkey1s_held) {
+		dev_info(pcf->dev, "ONKEY1S held for %d secs\n",
+							pcf->onkey1s_held);
+		if (pcf->onkey1s_held++ == PCF50633_ONKEY1S_TIMEOUT)
+			if (pcf->pdata->force_shutdown)
+				pcf->pdata->force_shutdown(pcf);
+	}
+
+	if (pcf_int[2] & PCF50633_INT3_ONKEY1S) {
+		dev_info(pcf->dev, "ONKEY1S held\n");
+		pcf->onkey1s_held = 1 ;
+
+		/* Unmask IRQ_SECOND */
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT1M,
+						PCF50633_INT1_SECOND);
+
+		/* Unmask IRQ_ONKEYR */
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT2M,
+						PCF50633_INT2_ONKEYR);
+	}
+
+	if ((pcf_int[1] & PCF50633_INT2_ONKEYR) && pcf->onkey1s_held) {
+		pcf->onkey1s_held = 0;
+
+		/* Mask SECOND and ONKEYR interrupts */
+		if (pcf->mask_regs[0] & PCF50633_INT1_SECOND)
+			pcf50633_reg_set_bit_mask(pcf,
+					PCF50633_REG_INT1M,
+					PCF50633_INT1_SECOND,
+					PCF50633_INT1_SECOND);
+
+		if (pcf->mask_regs[1] & PCF50633_INT2_ONKEYR)
+			pcf50633_reg_set_bit_mask(pcf,
+					PCF50633_REG_INT2M,
+					PCF50633_INT2_ONKEYR,
+					PCF50633_INT2_ONKEYR);
+	}
+
+	/* Have we just resumed ? */
+	if (pcf->is_suspended) {
+		pcf->is_suspended = 0;
+
+		/* Set the resume reason filtering out non resumers */
+		for (i = 0; i < ARRAY_SIZE(pcf_int); i++)
+			pcf->resume_reason[i] = pcf_int[i] &
+						pcf->pdata->resumers[i];
+
+		/* Make sure we don't pass on any ONKEY events to
+		 * userspace now */
+		pcf_int[1] &= ~(PCF50633_INT2_ONKEYR | PCF50633_INT2_ONKEYF);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pcf_int); i++) {
+		/* Unset masked interrupts */
+		pcf_int[i] &= ~pcf->mask_regs[i];
+
+		for (j = 0; j < 8 ; j++)
+			if (pcf_int[i] & (1 << j))
+				pcf50633_irq_call_handler(pcf, (i * 8) + j);
+	}
+
+out:
+	put_device(pcf->dev);
+	enable_irq(pcf->irq);
+}
+
+static irqreturn_t pcf50633_irq(int irq, void *data)
+{
+	struct pcf50633 *pcf = data;
+
+	dev_dbg(pcf->dev, "pcf50633_irq\n");
+
+	get_device(pcf->dev);
+	disable_irq(pcf->irq);
+	schedule_work(&pcf->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static void
+pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
+						struct platform_device **pdev)
+{
+	struct pcf50633_subdev_pdata *subdev_pdata;
+	int ret;
+
+	*pdev = platform_device_alloc(name, -1);
+	if (!*pdev) {
+		dev_err(pcf->dev, "Falied to allocate %s\n", name);
+		return;
+	}
+
+	subdev_pdata = kmalloc(sizeof(*subdev_pdata), GFP_KERNEL);
+	if (!subdev_pdata) {
+		dev_err(pcf->dev, "Error allocating subdev pdata\n");
+		platform_device_put(*pdev);
+	}
+
+	subdev_pdata->pcf = pcf;
+	platform_device_add_data(*pdev, subdev_pdata, sizeof(*subdev_pdata));
+
+	(*pdev)->dev.parent = pcf->dev;
+
+	ret = platform_device_add(*pdev);
+	if (ret) {
+		dev_err(pcf->dev, "Failed to register %s: %d\n", name, ret);
+		platform_device_put(*pdev);
+		*pdev = NULL;
+	}
+}
+
+#ifdef CONFIG_PM
+static int pcf50633_suspend(struct device *dev, pm_message_t state)
+{
+	struct pcf50633 *pcf;
+	int ret = 0, i;
+	u8 res[5];
+
+	pcf = dev_get_drvdata(dev);
+
+	/* Make sure our interrupt handlers are not called
+	 * henceforth */
+	disable_irq(pcf->irq);
+
+	/* Make sure that any running IRQ worker has quit */
+	cancel_work_sync(&pcf->irq_work);
+
+	/* Save the masks */
+	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
+				ARRAY_SIZE(pcf->suspend_irq_masks),
+					pcf->suspend_irq_masks);
+	if (ret < 0) {
+		dev_err(pcf->dev, "error saving irq masks\n");
+		goto out;
+	}
+
+	/* Write wakeup irq masks */
+	for (i = 0; i < ARRAY_SIZE(res); i++)
+		res[i] = ~pcf->pdata->resumers[i];
+
+	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
+					ARRAY_SIZE(res), &res[0]);
+	if (ret < 0) {
+		dev_err(pcf->dev, "error writing wakeup irq masks\n");
+		goto out;
+	}
+
+	pcf->is_suspended = 1;
+
+out:
+	return ret;
+}
+
+static int pcf50633_resume(struct device *dev)
+{
+	struct pcf50633 *pcf;
+	int ret;
+
+	pcf = dev_get_drvdata(dev);
+
+	/* Write the saved mask registers */
+	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
+				ARRAY_SIZE(pcf->suspend_irq_masks),
+					pcf->suspend_irq_masks);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
+
+	/* Restore regulators' state */
+
+
+	get_device(pcf->dev);
+
+	/*
+	 * Clear any pending interrupts and set resume reason if any.
+	 * This will leave with enable_irq()
+	 */
+	pcf50633_irq_worker(&pcf->irq_work);
+
+	return 0;
+}
+#else
+#define pcf50633_suspend NULL
+#define pcf50633_resume NULL
+#endif
+
+static int __devinit pcf50633_probe(struct i2c_client *client,
+				const struct i2c_device_id *ids)
+{
+	struct pcf50633 *pcf;
+	struct pcf50633_platform_data *pdata = client->dev.platform_data;
+	int i, ret = 0;
+	int version, variant;
+
+	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
+	if (!pcf)
+		return -ENOMEM;
+
+	pcf->pdata = pdata;
+
+	mutex_init(&pcf->lock);
+
+	i2c_set_clientdata(client, pcf);
+	pcf->dev = &client->dev;
+	pcf->i2c_client = client;
+	pcf->irq = client->irq;
+
+	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
+
+	version = pcf50633_reg_read(pcf, 0);
+	variant = pcf50633_reg_read(pcf, 1);
+	if (version < 0 || variant < 0) {
+		dev_err(pcf->dev, "Unable to probe pcf50633\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	dev_info(pcf->dev, "Probed device version %d variant %d\n",
+							version, variant);
+
+	/* Enable all interrupts except RTC SECOND */
+	pcf->mask_regs[0] = 0x80;
+	pcf50633_reg_write(pcf, PCF50633_REG_INT1M, pcf->mask_regs[0]);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT2M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT3M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
+
+	/* Create sub devices */
+	pcf50633_client_dev_register(pcf, "pcf50633-input",
+						&pcf->input_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-rtc",
+						&pcf->rtc_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-mbc",
+						&pcf->mbc_pdev);
+	pcf50633_client_dev_register(pcf, "pcf50633-adc",
+						&pcf->adc_pdev);
+
+	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("pcf50633-regltr", i);
+		if (!pdev) {
+			dev_err(pcf->dev, "Cannot create regulator\n");
+			continue;
+		}
+
+		pdev->dev.parent = pcf->dev;
+		pdev->dev.platform_data = &pdata->reg_init_data[i];
+		pdev->dev.driver_data = pcf;
+		pcf->regulator_pdev[i] = pdev;
+
+		platform_device_add(pdev);
+	}
+
+	if (client->irq) {
+		set_irq_handler(client->irq, handle_level_irq);
+		ret = request_irq(client->irq, pcf50633_irq,
+				IRQF_TRIGGER_LOW, "pcf50633", pcf);
+
+		if (ret) {
+			dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
+			goto err;
+		}
+	} else {
+		dev_err(pcf->dev, "No IRQ configured\n");
+		goto err;
+	}
+
+	if (enable_irq_wake(client->irq) < 0)
+		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
+			"in this hardware revision", client->irq);
+
+	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
+	if (ret)
+		dev_err(pcf->dev, "error creating sysfs entries\n");
+
+	if (pdata->probe_done)
+		pdata->probe_done(pcf);
+
+	return 0;
+
+err:
+	kfree(pcf);
+	return ret;
+}
+
+static int __devexit pcf50633_remove(struct i2c_client *client)
+{
+	struct pcf50633 *pcf = i2c_get_clientdata(client);
+	int i;
+
+	free_irq(pcf->irq, pcf);
+
+	platform_device_unregister(pcf->input_pdev);
+	platform_device_unregister(pcf->rtc_pdev);
+	platform_device_unregister(pcf->mbc_pdev);
+	platform_device_unregister(pcf->adc_pdev);
+
+	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
+		platform_device_unregister(pcf->regulator_pdev[i]);
+
+	kfree(pcf);
+
+	return 0;
+}
+
+static struct i2c_device_id pcf50633_id_table[] = {
+	{"pcf50633", 0x73},
+};
+
+static struct i2c_driver pcf50633_driver = {
+	.driver = {
+		.name	= "pcf50633",
+		.suspend = pcf50633_suspend,
+		.resume	= pcf50633_resume,
+	},
+	.id_table = pcf50633_id_table,
+	.probe = pcf50633_probe,
+	.remove = __devexit_p(pcf50633_remove),
+};
+
+static int __init pcf50633_init(void)
+{
+	return i2c_add_driver(&pcf50633_driver);
+}
+
+static void __exit pcf50633_exit(void)
+{
+	i2c_del_driver(&pcf50633_driver);
+}
+
+MODULE_DESCRIPTION("I2C chip driver for NXP PCF50633 PMU");
+MODULE_AUTHOR("Harald Welte <laforge@openmoko.org>");
+MODULE_LICENSE("GPL");
+
+module_init(pcf50633_init);
+module_exit(pcf50633_exit);
diff -puN /dev/null include/linux/mfd/pcf50633/core.h
--- /dev/null
+++ a/include/linux/mfd/pcf50633/core.h
@@ -0,0 +1,218 @@
+/*
+ * core.h  -- Core driver for NXP PCF50633
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
+#ifndef __LINUX_MFD_PCF50633_CORE_H
+#define __LINUX_MFD_PCF50633_CORE_H
+
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/power_supply.h>
+
+struct pcf50633;
+
+#define PCF50633_NUM_REGULATORS	11
+
+struct pcf50633_platform_data {
+	struct regulator_init_data reg_init_data[PCF50633_NUM_REGULATORS];
+
+	char **batteries;
+	int num_batteries;
+
+	/* Callbacks */
+	void (*probe_done)(struct pcf50633 *);
+	void (*mbc_event_callback)(struct pcf50633 *, int);
+	void (*regulator_registered)(struct pcf50633 *, int);
+	void (*force_shutdown)(struct pcf50633 *);
+
+	u8 resumers[5];
+};
+
+struct pcf50633_subdev_pdata {
+	struct pcf50633 *pcf;
+};
+
+struct pcf50633_irq {
+	void (*handler) (int, void *);
+	void *data;
+};
+
+int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
+			void (*handler) (int, void *), void *data);
+int pcf50633_free_irq(struct pcf50633 *pcf, int irq);
+
+int pcf50633_irq_mask(struct pcf50633 *pcf, int irq);
+int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq);
+int pcf50633_irq_mask_get(struct pcf50633 *pcf, int irq);
+
+int pcf50633_read_block(struct pcf50633 *, u8 reg,
+					int nr_regs, u8 *data);
+int pcf50633_write_block(struct pcf50633 *pcf, u8 reg,
+					int nr_regs, u8 *data);
+u8 pcf50633_reg_read(struct pcf50633 *, u8 reg);
+int pcf50633_reg_write(struct pcf50633 *pcf, u8 reg, u8 val);
+
+int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val);
+int pcf50633_reg_clear_bits(struct pcf50633 *pcf, u8 reg, u8 bits);
+
+/* Interrupt registers */
+
+#define PCF50633_REG_INT1	0x02
+#define PCF50633_REG_INT2	0x03
+#define PCF50633_REG_INT3	0x04
+#define PCF50633_REG_INT4	0x05
+#define PCF50633_REG_INT5	0x06
+
+#define PCF50633_REG_INT1M	0x07
+#define PCF50633_REG_INT2M	0x08
+#define PCF50633_REG_INT3M	0x09
+#define PCF50633_REG_INT4M	0x0a
+#define PCF50633_REG_INT5M	0x0b
+
+enum {
+	/* Chip IRQs */
+	PCF50633_IRQ_ADPINS,
+	PCF50633_IRQ_ADPREM,
+	PCF50633_IRQ_USBINS,
+	PCF50633_IRQ_USBREM,
+	PCF50633_IRQ_RESERVED1,
+	PCF50633_IRQ_RESERVED2,
+	PCF50633_IRQ_ALARM,
+	PCF50633_IRQ_SECOND,
+	PCF50633_IRQ_ONKEYR,
+	PCF50633_IRQ_ONKEYF,
+	PCF50633_IRQ_EXTON1R,
+	PCF50633_IRQ_EXTON1F,
+	PCF50633_IRQ_EXTON2R,
+	PCF50633_IRQ_EXTON2F,
+	PCF50633_IRQ_EXTON3R,
+	PCF50633_IRQ_EXTON3F,
+	PCF50633_IRQ_BATFULL,
+	PCF50633_IRQ_CHGHALT,
+	PCF50633_IRQ_THLIMON,
+	PCF50633_IRQ_THLIMOFF,
+	PCF50633_IRQ_USBLIMON,
+	PCF50633_IRQ_USBLIMOFF,
+	PCF50633_IRQ_ADCRDY,
+	PCF50633_IRQ_ONKEY1S,
+	PCF50633_IRQ_LOWSYS,
+	PCF50633_IRQ_LOWBAT,
+	PCF50633_IRQ_HIGHTMP,
+	PCF50633_IRQ_AUTOPWRFAIL,
+	PCF50633_IRQ_DWN1PWRFAIL,
+	PCF50633_IRQ_DWN2PWRFAIL,
+	PCF50633_IRQ_LEDPWRFAIL,
+	PCF50633_IRQ_LEDOVP,
+	PCF50633_IRQ_LDO1PWRFAIL,
+	PCF50633_IRQ_LDO2PWRFAIL,
+	PCF50633_IRQ_LDO3PWRFAIL,
+	PCF50633_IRQ_LDO4PWRFAIL,
+	PCF50633_IRQ_LDO5PWRFAIL,
+	PCF50633_IRQ_LDO6PWRFAIL,
+	PCF50633_IRQ_HCLDOPWRFAIL,
+	PCF50633_IRQ_HCLDOOVL,
+
+	/* Always last */
+	PCF50633_NUM_IRQ,
+};
+
+struct pcf50633 {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+
+	struct pcf50633_platform_data *pdata;
+	int irq;
+	struct pcf50633_irq irq_handler[PCF50633_NUM_IRQ];
+	struct work_struct irq_work;
+	struct mutex lock;
+
+	u8 mask_regs[5];
+
+	u8 suspend_irq_masks[5];
+	u8 resume_reason[5];
+	int is_suspended;
+
+	int onkey1s_held;
+
+	struct platform_device *rtc_pdev;
+	struct platform_device *mbc_pdev;
+	struct platform_device *adc_pdev;
+	struct platform_device *input_pdev;
+	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];
+};
+
+enum pcf50633_reg_int1 {
+	PCF50633_INT1_ADPINS	= 0x01,	/* Adapter inserted */
+	PCF50633_INT1_ADPREM	= 0x02,	/* Adapter removed */
+	PCF50633_INT1_USBINS	= 0x04,	/* USB inserted */
+	PCF50633_INT1_USBREM	= 0x08,	/* USB removed */
+	/* reserved */
+	PCF50633_INT1_ALARM	= 0x40, /* RTC alarm time is reached */
+	PCF50633_INT1_SECOND	= 0x80,	/* RTC periodic second interrupt */
+};
+
+enum pcf50633_reg_int2 {
+	PCF50633_INT2_ONKEYR	= 0x01, /* ONKEY rising edge */
+	PCF50633_INT2_ONKEYF	= 0x02, /* ONKEY falling edge */
+	PCF50633_INT2_EXTON1R	= 0x04, /* EXTON1 rising edge */
+	PCF50633_INT2_EXTON1F	= 0x08, /* EXTON1 falling edge */
+	PCF50633_INT2_EXTON2R	= 0x10, /* EXTON2 rising edge */
+	PCF50633_INT2_EXTON2F	= 0x20, /* EXTON2 falling edge */
+	PCF50633_INT2_EXTON3R	= 0x40, /* EXTON3 rising edge */
+	PCF50633_INT2_EXTON3F	= 0x80, /* EXTON3 falling edge */
+};
+
+enum pcf50633_reg_int3 {
+	PCF50633_INT3_BATFULL	= 0x01, /* Battery full */
+	PCF50633_INT3_CHGHALT	= 0x02,	/* Charger halt */
+	PCF50633_INT3_THLIMON	= 0x04,
+	PCF50633_INT3_THLIMOFF	= 0x08,
+	PCF50633_INT3_USBLIMON	= 0x10,
+	PCF50633_INT3_USBLIMOFF	= 0x20,
+	PCF50633_INT3_ADCRDY	= 0x40, /* ADC result ready */
+	PCF50633_INT3_ONKEY1S	= 0x80,	/* ONKEY pressed 1 second */
+};
+
+enum pcf50633_reg_int4 {
+	PCF50633_INT4_LOWSYS		= 0x01,
+	PCF50633_INT4_LOWBAT		= 0x02,
+	PCF50633_INT4_HIGHTMP		= 0x04,
+	PCF50633_INT4_AUTOPWRFAIL	= 0x08,
+	PCF50633_INT4_DWN1PWRFAIL	= 0x10,
+	PCF50633_INT4_DWN2PWRFAIL	= 0x20,
+	PCF50633_INT4_LEDPWRFAIL	= 0x40,
+	PCF50633_INT4_LEDOVP		= 0x80,
+};
+
+enum pcf50633_reg_int5 {
+	PCF50633_INT5_LDO1PWRFAIL	= 0x01,
+	PCF50633_INT5_LDO2PWRFAIL	= 0x02,
+	PCF50633_INT5_LDO3PWRFAIL	= 0x04,
+	PCF50633_INT5_LDO4PWRFAIL	= 0x08,
+	PCF50633_INT5_LDO5PWRFAIL	= 0x10,
+	PCF50633_INT5_LDO6PWRFAIL	= 0x20,
+	PCF50633_INT5_HCLDOPWRFAIL	= 0x40,
+	PCF50633_INT5_HCLDOOVL		= 0x80,
+};
+
+/* misc. registers */
+#define PCF50633_REG_OOCSHDWN	0x0c
+
+/* LED registers */
+#define PCF50633_REG_LEDOUT 0x28
+#define PCF50633_REG_LEDENA 0x29
+#define PCF50633_REG_LEDCTL 0x2a
+#define PCF50633_REG_LEDDIM 0x2b
+
+#endif
+
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

origin.patch
linux-next.patch

