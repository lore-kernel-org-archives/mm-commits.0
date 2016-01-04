From: akpm@linux-foundation.org
Subject: [merged] iio-trigger-introduce-iio-hrtimer-based-trigger.patch
 removed from -mm tree
Date: Mon, 04 Jan 2016 11:06:31 -0800
Message-ID: <568ac2b7.rL1b0X7zmlSXcpyO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcADTGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 14:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, adriana.reus@intel.com, cristina.opriceana@gmail.com, hch@lst.de, jlbec@evilplan.org, knaack.h@gmx.de, lars@metafoo.de, marten@intuitiveaerial.com, octavian.purdila@intel.com, pebolle@tiscali.nl, pmeerw@pmeerw.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: iio: trigger: introduce IIO hrtimer based trigger
has been removed from the -mm tree.  Its filename was
     iio-trigger-introduce-iio-hrtimer-based-trigger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Baluta <daniel.baluta@intel.com>
Subject: iio: trigger: introduce IIO hrtimer based trigger

This patch registers a new IIO software trigger interrupt source
based on high resolution timers.

Notice that if configfs is enabled we create sampling_frequency
attribute allowing users to change hrtimer period (1/sampling_frequency).

The IIO hrtimer trigger has a long history, this patch is based on
an older version from Marten and Lars-Peter.

Signed-off-by: Marten Svanfeldt <marten@intuitiveaerial.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Adriana Reus <adriana.reus@intel.com>
Cc: Cristina Opriceana <cristina.opriceana@gmail.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/trigger/Kconfig            |   10 +
 drivers/iio/trigger/Makefile           |    2 
 drivers/iio/trigger/iio-trig-hrtimer.c |  193 +++++++++++++++++++++++
 3 files changed, 205 insertions(+)

diff -puN drivers/iio/trigger/Kconfig~iio-trigger-introduce-iio-hrtimer-based-trigger drivers/iio/trigger/Kconfig
--- a/drivers/iio/trigger/Kconfig~iio-trigger-introduce-iio-hrtimer-based-trigger
+++ a/drivers/iio/trigger/Kconfig
@@ -5,6 +5,16 @@
 
 menu "Triggers - standalone"
 
+config IIO_HRTIMER_TRIGGER
+	tristate "High resolution timer trigger"
+	depends on IIO_SW_TRIGGER
+	help
+	  Provides a frequency based IIO trigger using high resolution
+	  timers as interrupt source.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called iio-trig-hrtimer.
+
 config IIO_INTERRUPT_TRIGGER
 	tristate "Generic interrupt trigger"
 	help
diff -puN drivers/iio/trigger/Makefile~iio-trigger-introduce-iio-hrtimer-based-trigger drivers/iio/trigger/Makefile
--- a/drivers/iio/trigger/Makefile~iio-trigger-introduce-iio-hrtimer-based-trigger
+++ a/drivers/iio/trigger/Makefile
@@ -3,5 +3,7 @@
 #
 
 # When adding new entries keep the list in alphabetical order
+
+obj-$(CONFIG_IIO_HRTIMER_TRIGGER) += iio-trig-hrtimer.o
 obj-$(CONFIG_IIO_INTERRUPT_TRIGGER) += iio-trig-interrupt.o
 obj-$(CONFIG_IIO_SYSFS_TRIGGER) += iio-trig-sysfs.o
diff -puN /dev/null drivers/iio/trigger/iio-trig-hrtimer.c
--- /dev/null
+++ a/drivers/iio/trigger/iio-trig-hrtimer.c
@@ -0,0 +1,193 @@
+/**
+ * The industrial I/O periodic hrtimer trigger driver
+ *
+ * Copyright (C) Intuitive Aerial AB
+ * Written by Marten Svanfeldt, marten@intuitiveaerial.com
+ * Copyright (C) 2012, Analog Device Inc.
+ *	Author: Lars-Peter Clausen <lars@metafoo.de>
+ * Copyright (C) 2015, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/hrtimer.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/sw_trigger.h>
+
+/* default sampling frequency - 100Hz */
+#define HRTIMER_DEFAULT_SAMPLING_FREQUENCY 100
+
+struct iio_hrtimer_info {
+	struct iio_sw_trigger swt;
+	struct hrtimer timer;
+	unsigned long sampling_frequency;
+	ktime_t period;
+};
+
+static struct config_item_type iio_hrtimer_type = {
+	.ct_owner = THIS_MODULE,
+};
+
+static
+ssize_t iio_hrtimer_show_sampling_frequency(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct iio_trigger *trig = to_iio_trigger(dev);
+	struct iio_hrtimer_info *info = iio_trigger_get_drvdata(trig);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", info->sampling_frequency);
+}
+
+static
+ssize_t iio_hrtimer_store_sampling_frequency(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t len)
+{
+	struct iio_trigger *trig = to_iio_trigger(dev);
+	struct iio_hrtimer_info *info = iio_trigger_get_drvdata(trig);
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (!val || val > NSEC_PER_SEC)
+		return -EINVAL;
+
+	info->sampling_frequency = val;
+	info->period = ktime_set(0, NSEC_PER_SEC / val);
+
+	return len;
+}
+
+static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
+		   iio_hrtimer_show_sampling_frequency,
+		   iio_hrtimer_store_sampling_frequency);
+
+static struct attribute *iio_hrtimer_attrs[] = {
+	&dev_attr_sampling_frequency.attr,
+	NULL
+};
+
+static const struct attribute_group iio_hrtimer_attr_group = {
+	.attrs = iio_hrtimer_attrs,
+};
+
+static const struct attribute_group *iio_hrtimer_attr_groups[] = {
+	&iio_hrtimer_attr_group,
+	NULL
+};
+
+static enum hrtimer_restart iio_hrtimer_trig_handler(struct hrtimer *timer)
+{
+	struct iio_hrtimer_info *info;
+
+	info = container_of(timer, struct iio_hrtimer_info, timer);
+
+	hrtimer_forward_now(timer, info->period);
+	iio_trigger_poll(info->swt.trigger);
+
+	return HRTIMER_RESTART;
+}
+
+static int iio_trig_hrtimer_set_state(struct iio_trigger *trig, bool state)
+{
+	struct iio_hrtimer_info *trig_info;
+
+	trig_info = iio_trigger_get_drvdata(trig);
+
+	if (state)
+		hrtimer_start(&trig_info->timer, trig_info->period,
+			      HRTIMER_MODE_REL);
+	else
+		hrtimer_cancel(&trig_info->timer);
+
+	return 0;
+}
+
+static const struct iio_trigger_ops iio_hrtimer_trigger_ops = {
+	.owner = THIS_MODULE,
+	.set_trigger_state = iio_trig_hrtimer_set_state,
+};
+
+static struct iio_sw_trigger *iio_trig_hrtimer_probe(const char *name)
+{
+	struct iio_hrtimer_info *trig_info;
+	int ret;
+
+	trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
+	if (!trig_info)
+		return ERR_PTR(-ENOMEM);
+
+	trig_info->swt.trigger = iio_trigger_alloc("%s", name);
+	if (!trig_info->swt.trigger) {
+		ret = -ENOMEM;
+		goto err_free_trig_info;
+	}
+
+	iio_trigger_set_drvdata(trig_info->swt.trigger, trig_info);
+	trig_info->swt.trigger->ops = &iio_hrtimer_trigger_ops;
+	trig_info->swt.trigger->dev.groups = iio_hrtimer_attr_groups;
+
+	hrtimer_init(&trig_info->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	trig_info->timer.function = iio_hrtimer_trig_handler;
+
+	trig_info->sampling_frequency = HRTIMER_DEFAULT_SAMPLING_FREQUENCY;
+	trig_info->period = ktime_set(0, NSEC_PER_SEC /
+				      trig_info->sampling_frequency);
+
+	ret = iio_trigger_register(trig_info->swt.trigger);
+	if (ret)
+		goto err_free_trigger;
+
+	iio_swt_group_init_type_name(&trig_info->swt, name, &iio_hrtimer_type);
+	return &trig_info->swt;
+err_free_trigger:
+	iio_trigger_free(trig_info->swt.trigger);
+err_free_trig_info:
+	kfree(trig_info);
+
+	return ERR_PTR(ret);
+}
+
+static int iio_trig_hrtimer_remove(struct iio_sw_trigger *swt)
+{
+	struct iio_hrtimer_info *trig_info;
+
+	trig_info = iio_trigger_get_drvdata(swt->trigger);
+
+	iio_trigger_unregister(swt->trigger);
+
+	/* cancel the timer after unreg to make sure no one rearms it */
+	hrtimer_cancel(&trig_info->timer);
+	iio_trigger_free(swt->trigger);
+	kfree(trig_info);
+
+	return 0;
+}
+
+static const struct iio_sw_trigger_ops iio_trig_hrtimer_ops = {
+	.probe		= iio_trig_hrtimer_probe,
+	.remove		= iio_trig_hrtimer_remove,
+};
+
+static struct iio_sw_trigger_type iio_trig_hrtimer = {
+	.name = "hrtimer",
+	.owner = THIS_MODULE,
+	.ops = &iio_trig_hrtimer_ops,
+};
+
+module_iio_sw_trigger_driver(iio_trig_hrtimer);
+
+MODULE_AUTHOR("Marten Svanfeldt <marten@intuitiveaerial.com>");
+MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com>");
+MODULE_DESCRIPTION("Periodic hrtimer trigger for the IIO subsystem");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from daniel.baluta@intel.com are


