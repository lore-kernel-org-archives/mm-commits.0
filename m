From: akpm@linux-foundation.org
Subject: + regulator-framework-core.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:40:18 -0800
Message-ID: <200803070840.m278eIdr013452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079AbYCGIlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com


The patch titled
     regulator: framework core
has been added to the -mm tree.  Its filename is
     regulator-framework-core.patch

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
Subject: regulator: framework core
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This patch provides the regulator framework core.  The core also provides a
sysfs interface for userspace information.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/reg-core.c | 1311 +++++++++++++++++++++++++++++++++
 1 file changed, 1311 insertions(+)

diff -puN /dev/null drivers/regulator/reg-core.c
--- /dev/null
+++ a/drivers/regulator/reg-core.c
@@ -0,0 +1,1311 @@
+/*
+ * regulator.c  --  Voltage/Current Regulator framework.
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/regulator/regulator.h>
+#include <linux/regulator/regulator-drv.h>
+#include <linux/regulator/regulator-platform.h>
+
+#define REGULATOR_VERSION "0.4"
+
+static DEFINE_MUTEX(regulator_list_mutex);
+static LIST_HEAD(regulator_list);
+
+/**
+ * struct regulator_cdev
+ *
+ * Voltage / Current regulator class device. One for each regulator.
+ */
+struct regulator_cdev {
+	struct regulator_desc *desc;
+	int use_count;
+
+	struct list_head list;
+	struct list_head consumer_list;
+	struct blocking_notifier_head notifier;
+	struct mutex mutex; /* consumer lock */
+	struct module *owner;
+	struct class_device cdev;
+	struct regulation_constraints *constraints;
+	struct regulator_cdev *parent;	/* for tree */
+
+	void *reg_data;		/* regulator_cdev data */
+};
+
+static inline struct regulator_cdev *to_rcdev(struct class_device *cd)
+{
+	return container_of(cd, struct regulator_cdev, cdev);
+}
+
+/*
+ * struct regulator
+ *
+ * One for each consumer device.
+ */
+struct regulator {
+	struct device *dev;
+	struct list_head list;
+	int uA_load;
+	int uV_required;
+	int enabled; /* client has called enabled */
+	struct device_attribute dev_attr;
+	struct regulator_cdev *rcdev;
+};
+
+static int _regulator_is_enabled(struct regulator_cdev *rcdev);
+static int _regulator_disable(struct regulator_cdev *rcdev);
+static int _regulator_get_voltage(struct regulator_cdev *rcdev);
+static int _regulator_get_current(struct regulator_cdev *rcdev);
+static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev);
+
+/* gets the regulator for a given consumer device */
+static struct regulator *get_device_regulator(struct device *dev)
+{
+	struct regulator *regulator = NULL;
+	struct regulator_cdev *rcdev;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rcdev, &regulator_list, list) {
+		mutex_lock(&rcdev->mutex);
+		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
+			if (regulator->dev == dev) {
+				mutex_unlock(&rcdev->mutex);
+				return regulator;
+			}
+		}
+		mutex_unlock(&rcdev->mutex);
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return NULL;
+}
+
+/* voltage constraint check */
+static int regulator_check_voltage(struct regulator_cdev *rcdev, int uV)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+		       rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+		       __func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	if (uV > rcdev->constraints->max_uV ||
+		uV < rcdev->constraints->min_uV) {
+		printk(KERN_ERR "%s: invalid voltage %duV for %s\n",
+		       __func__, uV, rcdev->desc->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* current constraint check */
+static int regulator_check_current(struct regulator_cdev *rcdev, int uA)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+		       rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+		       __func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	if (uA > rcdev->constraints->max_uA ||
+		uA < rcdev->constraints->min_uA) {
+		printk(KERN_ERR "%s: invalid current %duA for %s\n",
+		       __func__, uA, rcdev->desc->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* operating mode constraint check */
+static int regulator_check_mode(struct regulator_cdev *rcdev, int mode)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+		       rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+		       __func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	if (!(rcdev->constraints->valid_modes_mask & mode)) {
+		printk(KERN_ERR "%s: invalid mode %x for %s\n",
+		       __func__, mode, rcdev->desc->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* dynamic regulator mode switching constraint check */
+static int regulator_check_drms(struct regulator_cdev *rcdev)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+		       rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!(rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+		       __func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static ssize_t device_requested_uA_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct regulator *regulator;
+
+	regulator = get_device_regulator(dev);
+	if (regulator == NULL)
+		return 0;
+
+	return sprintf(buf, "%d\n", regulator->uA_load);
+}
+
+static ssize_t regulator_uV_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	return sprintf(buf, "%d\n", _regulator_get_voltage(rcdev));
+}
+
+static ssize_t regulator_uA_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	return sprintf(buf, "%d\n", _regulator_get_current(rcdev));
+}
+
+static ssize_t regulator_opmode_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	int mode = _regulator_get_mode(rcdev);
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		return sprintf(buf, "fast\n");
+	case REGULATOR_MODE_NORMAL:
+		return sprintf(buf, "normal\n");
+	case REGULATOR_MODE_IDLE:
+		return sprintf(buf, "idle\n");
+	case REGULATOR_MODE_STANDBY:
+		return sprintf(buf, "standby\n");
+	}
+	return sprintf(buf, "unknown\n");
+}
+
+static ssize_t regulator_state_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	int state = _regulator_is_enabled(rcdev);
+
+	if (state > 0)
+		return sprintf(buf, "enabled\n");
+	else if (state == 0)
+		return sprintf(buf, "disabled\n");
+	else
+		return sprintf(buf, "unknown\n");
+}
+
+static ssize_t regulator_min_uA_show(struct class_device *cdev,
+					    char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraint not defined\n");
+
+	return sprintf(buf, "%d\n", rcdev->constraints->min_uA);
+}
+
+static ssize_t regulator_max_uA_show(struct class_device *cdev,
+					    char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraint not defined\n");
+
+	return sprintf(buf, "%d\n", rcdev->constraints->max_uA);
+}
+
+static ssize_t regulator_min_uV_show(struct class_device *cdev,
+					    char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraint not defined\n");
+
+	return sprintf(buf, "%d\n", rcdev->constraints->min_uV);
+}
+
+static ssize_t regulator_max_uV_show(struct class_device *cdev,
+					    char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraint not defined\n");
+
+	return sprintf(buf, "%d\n", rcdev->constraints->max_uV);
+}
+
+static ssize_t regulator_total_uA_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator *regulator;
+	int uA = 0;
+
+	mutex_lock(&rcdev->mutex);
+	list_for_each_entry(regulator, &rcdev->consumer_list, list)
+	    uA += regulator->uA_load;
+	mutex_unlock(&rcdev->mutex);
+	return sprintf(buf, "%d\n", uA);
+}
+
+static ssize_t regulator_num_users_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	return sprintf(buf, "%d\n", rcdev->use_count);
+}
+
+static ssize_t regulator_type_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	switch (rcdev->desc->type) {
+	case REGULATOR_VOLTAGE:
+		return sprintf(buf, "voltage\n");
+	case REGULATOR_CURRENT:
+		return sprintf(buf, "current\n");
+	}
+	return sprintf(buf, "unknown\n");
+}
+
+static struct class_device_attribute regulator_dev_attrs[] = {
+	__ATTR(microvolts, 0444, regulator_uV_show, NULL),
+	__ATTR(microamps, 0444, regulator_uA_show, NULL),
+	__ATTR(opmode, 0444, regulator_opmode_show, NULL),
+	__ATTR(state, 0444, regulator_state_show, NULL),
+	__ATTR(min_microvolts, 0444, regulator_min_uV_show, NULL),
+	__ATTR(min_microamps, 0444, regulator_min_uA_show, NULL),
+	__ATTR(max_microvolts, 0444, regulator_max_uV_show, NULL),
+	__ATTR(max_microamps, 0444, regulator_max_uA_show, NULL),
+	__ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL),
+	__ATTR(num_users, 0444, regulator_num_users_show, NULL),
+	__ATTR(type, 0444, regulator_type_show, NULL),
+	__ATTR_NULL,
+};
+
+static void regulator_dev_release(struct class_device *cdev)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	kfree(rcdev);
+}
+
+struct class regulator_class = {
+	.name = "regulator",
+	.release = regulator_dev_release,
+	.class_dev_attrs = regulator_dev_attrs,
+};
+
+/* find the lowest stable voltage that all enabled clients can operate at */
+static inline int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
+{
+	struct regulator *regulator;
+	int highest_uV = 0;
+
+	/* lock is held by caller */
+	list_for_each_entry(regulator, &rcdev->consumer_list, list) {
+		if (regulator->enabled && regulator->uV_required > highest_uV)
+			highest_uV = regulator->uV_required;
+	}
+	return highest_uV;
+}
+
+/* Set the regulator voltage to the lowest possible value that can safely
+ * support all the client devices */
+static int regulator_set_stable_voltage(struct regulator_cdev *rcdev)
+{
+	int ret = 0, uV;
+
+	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
+		uV = get_lowest_stable_voltage(rcdev);
+		if (uV && rcdev->desc->ops->set_voltage)
+			ret = rcdev->desc->ops->set_voltage(rcdev, uV);
+	}
+	return ret;
+}
+
+/* Calculate the new optimum regulator operating mode based on the new total
+ * consumer load. All locks held by caller */
+static void drms_uA_update(struct regulator_cdev *rcdev)
+{
+	struct regulator *sibling;
+	int current_uA = 0, output_uV, input_uV, err;
+	unsigned int mode;
+
+	err = regulator_check_drms(rcdev);
+	if (err < 0 || !rcdev->desc->ops->get_optimum_mode ||
+	    !rcdev->desc->ops->get_voltage || !rcdev->desc->ops->set_mode);
+	return;
+
+	/* get output voltage */
+	output_uV = rcdev->desc->ops->get_voltage(rcdev);
+
+	/* get input voltage */
+	if (rcdev->parent && rcdev->parent->desc->ops->get_voltage)
+		input_uV = rcdev->parent->desc->ops->get_voltage(rcdev->parent);
+	else
+		input_uV = rcdev->constraints->input_uV;
+
+	/* calc total requested load */
+	list_for_each_entry(sibling, &rcdev->consumer_list, list)
+	    current_uA += sibling->uA_load;
+
+	/* now get the optimum mode for our new total regulator load */
+	mode = rcdev->desc->ops->get_optimum_mode(rcdev, input_uV,
+						  output_uV, current_uA);
+
+	/* check the new mode is allowed */
+	err = regulator_check_mode(rcdev, mode);
+	if (err == 0)
+		rcdev->desc->ops->set_mode(rcdev, mode);
+}
+
+static void print_constraints(struct regulator_cdev *rcdev)
+{
+	struct regulation_constraints *constraints = rcdev->constraints;
+	char buf[80];
+	int count;
+
+	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
+		if (constraints->min_uV == constraints->max_uV)
+			count = sprintf(buf, "%d mV ",
+					uV_to_mV(constraints->min_uV));
+		else
+			count = sprintf(buf, "%d <--> %d mV ",
+					uV_to_mV(constraints->min_uV),
+					uV_to_mV(constraints->max_uV));
+	} else {
+		if (constraints->min_uA == constraints->max_uA)
+			count = sprintf(buf, "%d mA ",
+					uA_to_mA(constraints->min_uA));
+		else
+			count = sprintf(buf, "%d <--> %d mA ",
+					uA_to_mA(constraints->min_uA),
+					uA_to_mA(constraints->max_uA));
+	}
+	if (constraints->valid_modes_mask & REGULATOR_MODE_FAST)
+		count += sprintf(buf + count, "fast ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_NORMAL)
+		count += sprintf(buf + count, "normal ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
+		count += sprintf(buf + count, "idle ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
+		count += sprintf(buf + count, "standby");
+
+	printk(KERN_INFO "regulator: %s: %s\n", rcdev->desc->name, buf);
+}
+
+#define REG_STR_SIZE	32
+
+static struct regulator *create_regulator(struct regulator_cdev *rcdev,
+					  struct device *dev)
+{
+	struct regulator *regulator;
+	char buf[REG_STR_SIZE];
+	int err, size;
+
+	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
+	if (regulator == NULL)
+		return NULL;
+
+	mutex_lock(&rcdev->mutex);
+	regulator->rcdev = rcdev;
+	list_add(&regulator->list, &rcdev->consumer_list);
+
+	if (dev) {
+		/* create a 'requested_microamps_name' sysfs entry */
+		size = scnprintf(buf, REG_STR_SIZE, "microamps_requested_%s",
+			regulator->rcdev->desc->name);
+		if (size >= REG_STR_SIZE)
+			goto overflow_err;
+
+		regulator->dev = dev;
+		regulator->dev_attr.attr.name = kstrdup(buf, GFP_KERNEL);
+		if (regulator->dev_attr.attr.name == NULL)
+			goto err_out;
+
+		regulator->dev_attr.attr.owner = THIS_MODULE;
+		regulator->dev_attr.attr.mode = 0444;
+		regulator->dev_attr.show = device_requested_uA_show;
+		err = device_create_file(dev, &regulator->dev_attr);
+		if (err < 0) {
+			printk(KERN_WARNING "%s: could not add regulator_cdev"
+				" load sysfs\n", __func__);
+			goto err_out;
+		}
+
+		/* also add a link to the device sysfs entry */
+		err = sysfs_create_link(&rcdev->cdev.kobj, &dev->kobj,
+			dev->kobj.name);
+		if (err) {
+			printk(KERN_WARNING
+			       "%s: could not add device link %s err %d\n",
+			       __func__, dev->kobj.name, err);
+			device_remove_file(dev, &regulator->dev_attr);
+			goto err_out;
+		}
+	}
+	mutex_unlock(&rcdev->mutex);
+	return regulator;
+err_out:
+	kfree(regulator->dev_attr.attr.name);
+overflow_err:
+	list_del(&regulator->list);
+	kfree(regulator);
+	mutex_unlock(&rcdev->mutex);
+	return NULL;
+}
+
+/**
+ * regulator_get - lookup and obtain a reference to a regulator.
+ * @dev: device for regulator "consumer"
+ * @id: regulator ID
+ *
+ * Returns a struct regulator corresponding to the regulator producer, or
+ * IS_ERR() condition containing errno.
+ */
+struct regulator *regulator_get(struct device *dev, const char *id)
+{
+	struct regulator_cdev *rcdev;
+	struct regulator *regulator = ERR_PTR(-ENODEV);
+
+	if (id == NULL)
+		return regulator;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rcdev, &regulator_list, list) {
+		if (strcmp(id, rcdev->desc->name) == 0 &&
+		    try_module_get(rcdev->owner)) {
+			goto found;
+		}
+	}
+	printk(KERN_ERR "regulator: Unable to get requested regulator: %s\n",
+	       id);
+	mutex_unlock(&regulator_list_mutex);
+	return regulator;
+
+found:
+	regulator = create_regulator(rcdev, dev);
+	if (regulator == NULL) {
+		regulator = ERR_PTR(-ENOMEM);
+		module_put(rcdev->owner);
+	}
+
+	mutex_unlock(&regulator_list_mutex);
+	return regulator;
+}
+EXPORT_SYMBOL_GPL(regulator_get);
+
+/**
+ * regulator_put - "free" the regulator source
+ * @regulator: regulator source
+ *
+ * Note: drivers must ensure that all regulator_enable calls made on this
+ * regulator source are balanced by regulator_disable calls prior to calling
+ * this function.
+ */
+void regulator_put(struct regulator *regulator)
+{
+	struct regulator_cdev *rcdev;
+
+	if (regulator == NULL || IS_ERR(regulator))
+		return;
+
+	mutex_lock(&regulator_list_mutex);
+	rcdev = regulator->rcdev;
+
+	/* remove any sysfs entries */
+	if (regulator->dev) {
+		sysfs_remove_link(&rcdev->cdev.kobj, regulator->dev->kobj.name);
+		device_remove_file(regulator->dev, &regulator->dev_attr);
+		kfree(regulator->dev_attr.attr.name);
+	}
+	list_del(&regulator->list);
+	kfree(regulator);
+
+	module_put(rcdev->owner);
+	mutex_unlock(&regulator_list_mutex);
+}
+EXPORT_SYMBOL_GPL(regulator_put);
+
+/* locks held by regulator_enable() */
+static int _regulator_enable(struct regulator_cdev *rcdev)
+{
+	int ret = -EINVAL;
+
+	/* do we need to enable the parent regulator first */
+	if (rcdev->parent) {
+		ret = _regulator_enable(rcdev->parent);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to enable %s\n",
+			       __func__, rcdev->desc->name);
+			return ret;
+		}
+	}
+
+	/* check voltage and requested load before enabling */
+	if (rcdev->desc->ops->enable) {
+		ret = regulator_set_stable_voltage(rcdev);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: invalid voltage for %s\n",
+			       __func__, rcdev->desc->name);
+			return ret;
+		}
+
+		if (rcdev->constraints &&
+			(rcdev->constraints->valid_ops_mask &
+			REGULATOR_CHANGE_DRMS))
+			drms_uA_update(rcdev);
+
+		ret = rcdev->desc->ops->enable(rcdev);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to enable %s\n",
+			       __func__, rcdev->desc->name);
+			return ret;
+		}
+
+		rcdev->use_count++;
+		return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * regulator_enable - enable regulator output
+ * @regulator: regulator source
+ *
+ * Enable the regulator output at the predefined voltage or current value.
+ * NOTE: the output value can be set by other drivers, boot loader or may be
+ * hardwired in the regulator.
+ * NOTE: calls to regulator_enable() must be balanced with calls to
+ * regulator_disable().
+ */
+int regulator_enable(struct regulator *regulator)
+{
+	int ret;
+
+	mutex_lock(&regulator->rcdev->mutex);
+	regulator->enabled = 0;
+	ret = _regulator_enable(regulator->rcdev);
+	if (ret == 0)
+		regulator->enabled = 1;
+	mutex_unlock(&regulator->rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_enable);
+
+/* locks held by regulator_disable() */
+static int _regulator_disable(struct regulator_cdev *rcdev)
+{
+	int ret = 0;
+
+	/* are we the last user of this regulator */
+	if (rcdev->use_count == 1) {
+
+		/* last user - then disable */
+		if (rcdev->desc->ops->disable) {
+			ret = rcdev->desc->ops->disable(rcdev);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to disable %s\n",
+				       __func__, rcdev->desc->name);
+				return ret;
+			}
+		}
+
+		/* decrease our parents ref count and disable if required */
+		if (rcdev->parent)
+			_regulator_disable(rcdev->parent);
+
+		rcdev->use_count = 0;
+	} else if (rcdev->use_count > 1) {
+		/* find the most efficient voltage and mode now that we
+		 * have one less consumer device. */
+		ret = regulator_set_stable_voltage(rcdev);
+
+		if (rcdev->constraints &&
+			(rcdev->constraints->valid_ops_mask &
+			REGULATOR_CHANGE_DRMS))
+			drms_uA_update(rcdev);
+
+		rcdev->use_count--;
+	}
+	return ret;
+}
+
+/**
+ * regulator_disable - disable regulator output
+ * @regulator: regulator source
+ *
+ * Disable the regulator output voltage or current.
+ * NOTE: this will only disable the regulator output iff no other consumer
+ * devices have it enabled.
+ * NOTE: calls to regulator_enable() must be balanced with calls to
+ * regulator_disable().
+ */
+int regulator_disable(struct regulator *regulator)
+{
+	int ret;
+
+	mutex_lock(&regulator->rcdev->mutex);
+	regulator->enabled = 0;
+	regulator->uA_load = 0;
+	ret = _regulator_disable(regulator->rcdev);
+	mutex_unlock(&regulator->rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_disable);
+
+static int _regulator_is_enabled(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->is_enabled) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->is_enabled(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+/**
+ * regulator_is_enabled - is the regulator output enabled
+ * @regulator: regulator source
+ *
+ * Returns zero for disabled otherwise return number of enable requests.
+ */
+int regulator_is_enabled(struct regulator *regulator)
+{
+	return _regulator_is_enabled(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_is_enabled);
+
+/**
+ * regulator_set_voltage - set regulator output voltage
+ * @regulator: regulator source
+ * @uV: voltage in uV
+ *
+ * Sets a voltage regulator to the desired output voltage. This can be set
+ * during any regulator state. IOW, regulator can be disabled or enabled.
+ *
+ * If the regulator is enabled then the voltage will change to the new value
+ * immediately otherwise if the regulator is disabled the regulator will
+ * output at the new voltage when enabled.
+ *
+ * NOTE: If the regulator is shared between several devices then the lowest
+ * request voltage that meets the system constraints will be used.
+ * NOTE: Regulator system constraints must be set for this regulator before
+ * calling this function otherwise this call will fail.
+ */
+int regulator_set_voltage(struct regulator *regulator, int uV)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->set_voltage) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* constraints check */
+	ret = regulator_check_voltage(rcdev, uV);
+	if (ret < 0)
+		goto out;
+	regulator->uV_required = uV;
+
+	/* only set the new voltage if it's all clients can use it */
+	ret = regulator_set_stable_voltage(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_voltage);
+
+static int _regulator_get_voltage(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_voltage) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_voltage(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+/**
+ * regulator_get_voltage - get regulator output voltage
+ * @regulator: regulator source
+ *
+ * This returns the current regulator voltage in uV.
+ *
+ * NOTE: If the regulator is disabled it will return the voltage value. This
+ * function should not be used to determine regulator state.
+ */
+int regulator_get_voltage(struct regulator *regulator)
+{
+	return _regulator_get_voltage(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_get_voltage);
+
+/**
+ * regulator_set_current - set regulator output current for a current sink
+ * @regulator: regulator source
+ * @uA: current in uA
+ *
+ * Sets current sink to the desired output current. This can be set during
+ * any regulator state. IOW, regulator can be disabled or enabled.
+ *
+ * If the regulator is enabled then the current will change to the new value
+ * immediately otherwise if the regulator is disabled the regulator will
+ * output at the new current when enabled.
+ *
+ * NOTE: Regulator system constraints must be set for this regulator before
+ * calling this function otherwise this call will fail.
+ */
+int regulator_set_current(struct regulator *regulator, int uA)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->set_current) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* constraints check */
+	ret = regulator_check_current(rcdev, uA);
+	if (ret < 0)
+		goto out;
+
+	ret = rcdev->desc->ops->set_current(rcdev, uA);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_current);
+
+static int _regulator_get_current(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_current) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_current(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+/**
+ * regulator_get_current - get regulator output current
+ * @regulator: regulator source
+ *
+ * This returns the current supplied by the specified current sink in uA.
+ *
+ * NOTE: If the regulator is disabled it will return the current value. This
+ * function should not be used to determine regulator state.
+ */
+int regulator_get_current(struct regulator *regulator)
+{
+	return _regulator_get_current(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_get_current);
+
+/**
+ * regulator_set_mode - set regulator operating mode
+ * @regulator: regulator source
+ * @mode: operating mode - one of the REGULATOR_MODE constants
+ *
+ * Set regulator operating mode to increase regulator efficiency or improve
+ * regulation performance.
+ *
+ * NOTE: Regulator system constraints must be set for this regulator before
+ * calling this function otherwise this call will fail.
+ */
+int regulator_set_mode(struct regulator *regulator, unsigned int mode)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->set_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* constraints check */
+	ret = regulator_check_mode(rcdev, mode);
+	if (ret < 0)
+		goto out;
+
+	ret = rcdev->desc->ops->set_mode(rcdev, mode);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_mode);
+
+static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_mode(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+/**
+ * regulator_get_mode - get regulator operating mode
+ * @regulator: regulator source
+ *
+ * Get the current regulator operating mode.
+ */
+unsigned int regulator_get_mode(struct regulator *regulator)
+{
+	return _regulator_get_mode(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_get_mode);
+
+static unsigned int _regulator_get_optimum_mode(struct regulator_cdev *rcdev,
+						int input_uV, int output_uV,
+						int load_uA)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_optimum_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_optimum_mode(rcdev,
+						 input_uV, output_uV, load_uA);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+/**
+ * regulator_get_optimum_mode - get regulator optimum operating mode
+ * @regulator: regulator source
+ * @input_uV: input voltage
+ * @output_uV: output voltage
+ * @load_uV: load current
+ *
+ * Get the most efficient regulator operating mode for the given input
+ * and output voltages at a specific load..
+ */
+unsigned int regulator_get_optimum_mode(struct regulator *regulator,
+					int input_uV, int output_uV,
+					int load_uA)
+{
+	return _regulator_get_optimum_mode(regulator->rcdev, input_uV,
+					   output_uV, load_uA);
+}
+EXPORT_SYMBOL_GPL(regulator_get_optimum_mode);
+
+/**
+ * regulator_register_client - register regulator event notifier
+ * @regulator: regulator source
+ * @notifier_block: notifier block
+ *
+ * Register notifier block to receive regulator events.
+ */
+int regulator_register_client(struct regulator *regulator,
+			      struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&regulator->rcdev->notifier,
+						nb);
+}
+EXPORT_SYMBOL_GPL(regulator_register_client);
+
+/**
+ * regulator_unregister_client - unregister regulator event notifier
+ * @regulator: regulator source
+ * @notifier_block: notifier block
+ *
+ * Unregister regulator event notifier block.
+ */
+int regulator_unregister_client(struct regulator *regulator,
+				struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&regulator->rcdev->notifier,
+						  nb);
+}
+EXPORT_SYMBOL_GPL(regulator_unregister_client);
+
+/**
+ * regulator_notifier_call_chain - call regulator event notifier
+ * @regulator: regulator source
+ * @event: notifier block
+ * @data:
+ *
+ * Called by regulator drivers to notify clients a regulator event has
+ * occurred.
+ */
+int regulator_notifier_call_chain(struct regulator_cdev *rcdev,
+				  unsigned long event, void *data)
+{
+	return blocking_notifier_call_chain(&rcdev->notifier, event, data);
+}
+EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
+
+/**
+ * regulator_register - register regulator
+ * @regulator: regulator source
+ * @reg_data: private regulator data
+ *
+ * Called by regulator drivers to register a regulator.
+ * Returns 0 on success.
+ */
+struct regulator_cdev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data)
+{
+	static atomic_t regulator_no = ATOMIC_INIT(0);
+	struct regulator_cdev *rcdev;
+	int ret;
+
+	if (regulator_desc == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (!regulator_desc->type == REGULATOR_VOLTAGE &&
+	    !regulator_desc->type == REGULATOR_CURRENT)
+		return ERR_PTR(-EINVAL);
+
+	rcdev = kzalloc(sizeof(struct regulator_cdev), GFP_KERNEL);
+	if (rcdev == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&regulator_list_mutex);
+
+	mutex_init(&rcdev->mutex);
+	rcdev->reg_data = reg_data;
+	rcdev->owner = regulator_desc->owner;
+	rcdev->desc = regulator_desc;
+	INIT_LIST_HEAD(&rcdev->consumer_list);
+	INIT_LIST_HEAD(&rcdev->list);
+	BLOCKING_INIT_NOTIFIER_HEAD(&rcdev->notifier);
+
+	rcdev->cdev.class = &regulator_class;
+	class_device_initialize(&rcdev->cdev);
+	snprintf(rcdev->cdev.class_id, sizeof(rcdev->cdev.class_id),
+		 "regulator_%ld_%s",
+		 (unsigned long)atomic_inc_return(&regulator_no) - 1,
+		 regulator_desc->name);
+
+	ret = class_device_add(&rcdev->cdev);
+	if (ret == 0)
+		list_add(&rcdev->list, &regulator_list);
+	else {
+		kfree(rcdev);
+		rcdev = ERR_PTR(ret);
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return rcdev;
+}
+EXPORT_SYMBOL_GPL(regulator_register);
+
+/**
+ * regulator_unregister - unregister regulator
+ * @regulator: regulator source
+ *
+ * Called by regulator drivers to unregister a regulator.
+ */
+void regulator_unregister(struct regulator_cdev *rcdev)
+{
+	if (rcdev == NULL)
+		return;
+
+	mutex_lock(&regulator_list_mutex);
+	list_del(&rcdev->list);
+	if (rcdev->parent)
+		sysfs_remove_link(&rcdev->cdev.kobj, "parent");
+	class_device_unregister(&rcdev->cdev);
+	mutex_unlock(&regulator_list_mutex);
+}
+EXPORT_SYMBOL_GPL(regulator_unregister);
+
+/**
+ * regulator_set_parent - set regulator parent (or supply) regulator
+ * @regulator: regulator name
+ * @parent: parent (or supply) regulator name
+ *
+ * Called by platform initialisation code to set the parent or "supply"
+ * regulator for this regulator. This ensures that a regulator parent will
+ * also be enabled by the core if it's child is enabled.
+ */
+int regulator_set_parent(const char *regulator, const char *parent)
+{
+	struct regulator_cdev *rcdev, *parent_rcdev;
+	int err;
+
+	if (regulator == NULL || parent == NULL)
+		return -EINVAL;
+
+	mutex_lock(&regulator_list_mutex);
+
+	list_for_each_entry(rcdev, &regulator_list, list) {
+		if (!strcmp(rcdev->desc->name, regulator))
+			goto found_regulator;
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return -ENODEV;
+
+found_regulator:
+	list_for_each_entry(parent_rcdev, &regulator_list, list) {
+		if (!strcmp(parent_rcdev->desc->name, parent))
+			goto found_parent;
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return -ENODEV;
+
+found_parent:
+	rcdev->parent = parent_rcdev;
+	err = sysfs_create_link(&rcdev->cdev.kobj, &parent_rcdev->cdev.kobj,
+				"parent");
+	if (err) {
+		printk(KERN_ERR
+		       "%s: could not add device link %s err %d\n",
+		       __func__, parent_rcdev->cdev.kobj.name, err);
+		rcdev->parent = NULL;
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(regulator_set_parent);
+
+/**
+ * regulator_get_parent - get regulator parent (or supply) regulator
+ * @regulator: regulator name
+ *
+ * Returns the parent supply regulator name or NULL if no supply regulator
+ * exists (i.e the regulator is supplied directly from USB, Line, Battery, etc)
+ */
+const char *regulator_get_parent(const char *regulator)
+{
+	struct regulator_cdev *rcdev;
+
+	if (regulator == NULL)
+		return NULL;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rcdev, &regulator_list, list) {
+		if (!strcmp(rcdev->desc->name, regulator))
+			goto found;
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return NULL;
+
+found:
+	mutex_unlock(&regulator_list_mutex);
+	if (rcdev->parent)
+		return rcdev->parent->desc->name;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(regulator_get_parent);
+
+/**
+ * regulator_set_platform_constraints - sets regulator constraints
+ * @regulator: regulator source
+ *
+ * Allows platform initialisation code to define and constrain regulator
+ * circuits e.g. valid voltage/current ranges, etc.
+ * NOTE: Constraints *must* be set by platform code in order for some
+ * regulator operations to proceed i.e. set_voltage, set_current, set_mode.
+ */
+int regulator_set_platform_constraints(const char *regulator_name,
+	struct regulation_constraints *constraints)
+{
+	struct regulator_cdev *rcdev;
+
+	if (regulator_name == NULL)
+		return -EINVAL;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rcdev, &regulator_list, list) {
+		if (!strcmp(regulator_name, rcdev->desc->name)) {
+			mutex_lock(&rcdev->mutex);
+			rcdev->constraints = constraints;
+			print_constraints(rcdev);
+			mutex_unlock(&rcdev->mutex);
+			mutex_unlock(&regulator_list_mutex);
+			return 0;
+		}
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(regulator_set_platform_constraints);
+
+/**
+ * regulator_notify_load - notify regulator of new device load
+ * @regulator: regulator
+ * @dev: device
+ * @uA: load
+ *
+ * Notifies the regulator core of a new device load. This is then used by
+ * DRMS (if enabled by constraints) to select the most efficient regulator
+ * operating mode for the new regulator loading.
+ *
+ * Client devices notify their supply regulator of the maximum power
+ * they will require (can be taken from device datasheet in the power
+ * consumption tables) when they change operational status and hence power
+ * state. Examples of operational state changes that can affect power
+ * consumption are :-
+ *
+ *    o Device is opened / closed.
+ *    o Device I/O is about to begin or has just finished.
+ *    o Device is idling in between work.
+ *
+ * This information is also exported via sysfs to userspace.
+ *
+ * DRMS will sum the total requested load on the regulator and change
+ * to the most efficient operating mode if platform constraints allow.
+ */
+void regulator_drms_notify_load(struct regulator *regulator, int uA)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+
+	mutex_lock(&rcdev->mutex);
+	regulator->uA_load = uA;
+	drms_uA_update(rcdev);
+	mutex_unlock(&rcdev->mutex);
+}
+EXPORT_SYMBOL_GPL(regulator_drms_notify_load);
+
+/**
+ * rcdev_get_drvdata - get rcdev regulator driver data
+ * @regulator: regulator
+ *
+ * Get rcdev regulator driver private data. This call can be used in the
+ * regulator driver context.
+ */
+void *rcdev_get_drvdata(struct regulator_cdev *rcdev)
+{
+	return rcdev->reg_data;
+}
+EXPORT_SYMBOL_GPL(rcdev_get_drvdata);
+
+/**
+ * regulator_get_drvdata - get regulator driver data
+ * @regulator: regulator
+ *
+ * Get regulator driver private data. This call can be used in the consumer
+ * driver context when non API regulator specific functions need to be called.
+ */
+void *regulator_get_drvdata(struct regulator *regulator)
+{
+	return regulator->rcdev->reg_data;
+}
+EXPORT_SYMBOL_GPL(regulator_get_drvdata);
+
+/**
+ * regulator_set_drvdata - set regulator driver data
+ * @regulator: regulator
+ * @data: data
+ */
+void regulator_set_drvdata(struct regulator *regulator, void *data)
+{
+	regulator->rcdev->reg_data = data;
+}
+EXPORT_SYMBOL_GPL(regulator_set_drvdata);
+
+/**
+ * regulator_get_id - get regulator ID
+ * @regulator: regulator
+ */
+int rcdev_get_id(struct regulator_cdev *rcdev)
+{
+	return rcdev->desc->id;
+}
+EXPORT_SYMBOL_GPL(rcdev_get_id);
+
+static int __init regulator_init(void)
+{
+	printk(KERN_INFO "regulator: core version %s\n", REGULATOR_VERSION);
+	return class_register(&regulator_class);
+}
+
+/* init early to allow our consumers to complete system booting */
+core_initcall(regulator_init);
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-interface.patch
regulator-regulator-driver-interface.patch
regulator-platform-interface.patch
regulator-framework-core.patch
regulator-sysfs-abi.patch
regulator-kbuild.patch
regulator-maintainers.patch

