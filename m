From: akpm@linux-foundation.org
Subject: [merged] thermal-add-generic-cpufreq-cooling-implementation.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:34 -0700
Message-ID: <20120911193235.7632C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45357 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:32:39 -0400
Received: by fass10 with SMTP id s10so66170fas.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:32:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, kmpark@infradead.org, lenb@kernel.org, sw.ju@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: add generic cpufreq cooling implementation
has been removed from the -mm tree.  Its filename was
     thermal-add-generic-cpufreq-cooling-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Subject: thermal: add generic cpufreq cooling implementation

This patchset introduces a new generic cooling device based on cpufreq
that can be used on non-ACPI platforms.  As a proof of concept, we have
drivers for the following platforms using this mechanism now:

 * Samsung Exynos (Exynos4 and Exynos5) in the current patchset.
 * TI OMAP (git://git.linaro.org/people/amitdanielk/linux.git omap4460_thermal)
 * Freescale i.MX (git://git.linaro.org/people/amitdanielk/linux.git imx6q_thermal)

There is a small change in cpufreq cooling registration APIs, so a minor
change is needed for OMAP and Freescale platforms.

Brief Description:

1) The generic cooling devices code is placed inside driver/thermal/*
   as placing inside acpi folder will need un-necessary enabling of acpi
   code.  This codes is architecture independent.

2) This patchset adds generic cpu cooling low level implementation
   through frequency clipping.  In future, other cpu related cooling
   devices may be added here.  An ACPI version of this already exists
   (drivers/acpi/processor_thermal.c) .  But this will be useful for
   platforms like ARM using the generic thermal interface along with the
   generic cpu cooling devices.  The cooling device registration API's
   return cooling device pointers which can be easily binded with the
   thermal zone trip points.  The important APIs exposed are,

   a) struct thermal_cooling_device *cpufreq_cooling_register(
	struct freq_clip_table *tab_ptr, unsigned int tab_size)
   b) void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)

3) Samsung exynos platform thermal implementation is done using the
   generic cpu cooling APIs and the new trip type.  The temperature sensor
   driver present in the hwmon folder(registered as hwmon driver) is moved
   to thermal folder and registered as a thermal driver.

A simple data/control flow diagrams is shown below,

Core Linux thermal <----->  Exynos thermal interface <----- Temperature Sensor
	  |                             |
	 \|/                            |
  Cpufreq cooling device <---------------

TODO:
*Will send the DT enablement patches later after the driver is merged.

This patch:

Add support for generic cpu thermal cooling low level implementations
using frequency scaling up/down based on the registration parameters.
Different cpu related cooling devices can be registered by the user and
the binding of these cooling devices to the corresponding trip points can
be easily done as the registration APIs return the cooling device pointer.
The user of these APIs are responsible for passing clipping frequency .
The drivers can also register to recieve notification about any cooling
action called.

[akpm@linux-foundation.org: fix comment layout]
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: SangWook Ju <sw.ju@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/thermal/cpu-cooling-api.txt |   60 ++
 drivers/thermal/Kconfig                   |   11 
 drivers/thermal/Makefile                  |    3 
 drivers/thermal/cpu_cooling.c             |  483 ++++++++++++++++++++
 include/linux/cpu_cooling.h               |   99 ++++
 5 files changed, 655 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/thermal/cpu-cooling-api.txt
--- /dev/null
+++ a/Documentation/thermal/cpu-cooling-api.txt
@@ -0,0 +1,60 @@
+CPU cooling APIs How To
+===================================
+
+Written by Amit Daniel Kachhap <amit.kachhap@linaro.org>
+
+Updated: 12 May 2012
+
+Copyright (c)  2012 Samsung Electronics Co., Ltd(http://www.samsung.com)
+
+0. Introduction
+
+The generic cpu cooling(freq clipping, cpuhotplug etc) provides
+registration/unregistration APIs to the caller. The binding of the cooling
+devices to the trip point is left for the user. The registration APIs returns
+the cooling device pointer.
+
+1. cpu cooling APIs
+
+1.1 cpufreq registration/unregistration APIs
+1.1.1 struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size)
+
+    This interface function registers the cpufreq cooling device with the name
+    "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
+    cooling devices.
+
+    tab_ptr: The table containing the maximum value of frequency to be clipped
+    for each cooling state.
+	.freq_clip_max: Value of frequency to be clipped for each allowed
+	 cpus.
+	.temp_level: Temperature level at which the frequency clamping will
+	happen.
+	.mask_val: cpumask of the allowed cpu's
+    tab_size: the total number of cpufreq cooling states.
+
+1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+
+    This interface function unregisters the "thermal-cpufreq-%x" cooling device.
+
+    cdev: Cooling device pointer which has to be unregistered.
+
+
+1.2 CPU cooling action notifier register/unregister interface
+1.2.1 int cputherm_register_notifier(struct notifier_block *nb,
+	unsigned int list)
+
+    This interface registers a driver with cpu cooling layer. The driver will
+    be notified when any cpu cooling action is called.
+
+    nb: notifier function to register
+    list: CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP
+
+1.2.2 int cputherm_unregister_notifier(struct notifier_block *nb,
+	unsigned int list)
+
+    This interface registers a driver with cpu cooling layer. The driver will
+    be notified when any cpu cooling action is called.
+
+    nb: notifier function to register
+    list: CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP
diff -puN drivers/thermal/Kconfig~thermal-add-generic-cpufreq-cooling-implementation drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~thermal-add-generic-cpufreq-cooling-implementation
+++ a/drivers/thermal/Kconfig
@@ -19,6 +19,17 @@ config THERMAL_HWMON
 	depends on HWMON=y || HWMON=THERMAL
 	default y
 
+config CPU_THERMAL
+	bool "generic cpu cooling support"
+	depends on THERMAL && CPU_FREQ
+	help
+	  This implements the generic cpu cooling mechanism through frequency
+	  reduction, cpu hotplug and any other ways of reducing temperature. An
+	  ACPI version of this already exists(drivers/acpi/processor_thermal.c).
+	  This will be useful for platforms using the generic thermal interface
+	  and not the ACPI interface.
+	  If you want this support, you should say Y here.
+
 config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on THERMAL
diff -puN drivers/thermal/Makefile~thermal-add-generic-cpufreq-cooling-implementation drivers/thermal/Makefile
--- a/drivers/thermal/Makefile~thermal-add-generic-cpufreq-cooling-implementation
+++ a/drivers/thermal/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
-obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
+obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
+obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
diff -puN /dev/null drivers/thermal/cpu_cooling.c
--- /dev/null
+++ a/drivers/thermal/cpu_cooling.c
@@ -0,0 +1,483 @@
+/*
+ *  linux/drivers/thermal/cpu_cooling.c
+ *
+ *  Copyright (C) 2012	Samsung Electronics Co., Ltd(http://www.samsung.com)
+ *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/thermal.h>
+#include <linux/platform_device.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <linux/cpu_cooling.h>
+
+/**
+ * struct cpufreq_cooling_device
+ * @id: unique integer value corresponding to each cpufreq_cooling_device
+ *	registered.
+ * @cool_dev: thermal_cooling_device pointer to keep track of the the
+ *	egistered cooling device.
+ * @tab_ptr: freq_clip_table table containing the maximum value of frequency to
+ *	be set for different cooling state.
+ * @tab_size: integer value representing a count of the above table.
+ * @cpufreq_state: integer value representing the current state of cpufreq
+ *	cooling	devices.
+ * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
+ * @node: list_head to link all cpufreq_cooling_device together.
+ *
+ * This structure is required for keeping information of each
+ * cpufreq_cooling_device registered as a list whose head is represented by
+ * cooling_cpufreq_list. In order to prevent corruption of this list a
+ * mutex lock cooling_cpufreq_lock is used.
+ */
+struct cpufreq_cooling_device {
+	int id;
+	struct thermal_cooling_device *cool_dev;
+	struct freq_clip_table *tab_ptr;
+	unsigned int tab_size;
+	unsigned int cpufreq_state;
+	struct cpumask allowed_cpus;
+	struct list_head node;
+};
+static LIST_HEAD(cooling_cpufreq_list);
+static DEFINE_MUTEX(cooling_cpufreq_lock);
+static DEFINE_IDR(cpufreq_idr);
+
+/* per cpu variable to store the previous max frequency allowed */
+static DEFINE_PER_CPU(unsigned int, max_policy_freq);
+
+/* notify_table passes value to the CPUFREQ_ADJUST callback function. */
+#define NOTIFY_INVALID NULL
+static struct freq_clip_table *notify_table;
+
+/* Head of the blocking notifier chain to inform about frequency clamping */
+static BLOCKING_NOTIFIER_HEAD(cputherm_state_notifier_list);
+
+/**
+ * get_idr - function to get a unique id.
+ * @idr: struct idr * handle used to create a id.
+ * @id: int * value generated by this function.
+ */
+static int get_idr(struct idr *idr, int *id)
+{
+	int err;
+again:
+	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	err = idr_get_new(idr, NULL, id);
+	mutex_unlock(&cooling_cpufreq_lock);
+
+	if (unlikely(err == -EAGAIN))
+		goto again;
+	else if (unlikely(err))
+		return err;
+
+	*id = *id & MAX_ID_MASK;
+	return 0;
+}
+
+/**
+ * release_idr - function to free the unique id.
+ * @idr: struct idr * handle used for creating the id.
+ * @id: int value representing the unique id.
+ */
+static void release_idr(struct idr *idr, int id)
+{
+	mutex_lock(&cooling_cpufreq_lock);
+	idr_remove(idr, id);
+	mutex_unlock(&cooling_cpufreq_lock);
+}
+
+/**
+ * cputherm_register_notifier - Register a notifier with cpu cooling interface.
+ * @nb:	struct notifier_block * with callback info.
+ * @list: integer value for which notification is needed. possible values are
+ *	CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
+ *
+ * This exported function registers a driver with cpu cooling layer. The driver
+ * will be notified when any cpu cooling action is called.
+ */
+int cputherm_register_notifier(struct notifier_block *nb, unsigned int list)
+{
+	int ret = 0;
+
+	switch (list) {
+	case CPUFREQ_COOLING_START:
+	case CPUFREQ_COOLING_STOP:
+		ret = blocking_notifier_chain_register(
+				&cputherm_state_notifier_list, nb);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(cputherm_register_notifier);
+
+/**
+ * cputherm_unregister_notifier - Un-register a notifier.
+ * @nb:	struct notifier_block * with callback info.
+ * @list: integer value for which notification is needed. values possible are
+ *	CPUFREQ_COOLING_START or CPUFREQ_COOLING_STOP.
+ *
+ * This exported function un-registers a driver with cpu cooling layer.
+ */
+int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list)
+{
+	int ret = 0;
+
+	switch (list) {
+	case CPUFREQ_COOLING_START:
+	case CPUFREQ_COOLING_STOP:
+		ret = blocking_notifier_chain_unregister(
+				&cputherm_state_notifier_list, nb);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(cputherm_unregister_notifier);
+
+/* Below code defines functions to be used for cpufreq as cooling device */
+
+/**
+ * is_cpufreq_valid - function to check if a cpu has frequency transition policy.
+ * @cpu: cpu for which check is needed.
+ */
+static int is_cpufreq_valid(int cpu)
+{
+	struct cpufreq_policy policy;
+	return !cpufreq_get_policy(&policy, cpu);
+}
+
+/**
+ * cpufreq_apply_cooling - function to apply frequency clipping.
+ * @cpufreq_device: cpufreq_cooling_device pointer containing frequency
+ *	clipping data.
+ * @cooling_state: value of the cooling state.
+ */
+static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
+				unsigned long cooling_state)
+{
+	unsigned int event, cpuid, state;
+	struct freq_clip_table *th_table, *table_ptr;
+	const struct cpumask *maskPtr = &cpufreq_device->allowed_cpus;
+	struct cpufreq_cooling_device *cpufreq_ptr;
+
+	if (cooling_state > cpufreq_device->tab_size)
+		return -EINVAL;
+
+	/* Check if the old cooling action is same as new cooling action */
+	if (cpufreq_device->cpufreq_state == cooling_state)
+		return 0;
+
+	/* pass cooling table info to the cpufreq_thermal_notifier callback */
+	notify_table = NOTIFY_INVALID;
+
+	if (cooling_state > 0) {
+		th_table = &(cpufreq_device->tab_ptr[cooling_state - 1]);
+		notify_table = th_table;
+	}
+
+	/* check if any lower clip frequency active in other cpufreq_device's */
+	list_for_each_entry(cpufreq_ptr, &cooling_cpufreq_list, node) {
+
+		state = cpufreq_ptr->cpufreq_state;
+		if (state == 0 || cpufreq_ptr == cpufreq_device)
+			continue;
+
+		if (!cpumask_equal(&cpufreq_ptr->allowed_cpus,
+				&cpufreq_device->allowed_cpus))
+			continue;
+
+		table_ptr = &(cpufreq_ptr->tab_ptr[state - 1]);
+		if (notify_table == NULL ||
+				(table_ptr->freq_clip_max <
+				notify_table->freq_clip_max))
+			notify_table =  table_ptr;
+	}
+
+	cpufreq_device->cpufreq_state = cooling_state;
+
+	if (notify_table != NOTIFY_INVALID) {
+		event = CPUFREQ_COOLING_START;
+		maskPtr = notify_table->mask_val;
+	} else {
+		event = CPUFREQ_COOLING_STOP;
+	}
+
+	blocking_notifier_call_chain(&cputherm_state_notifier_list,
+						event, notify_table);
+
+	for_each_cpu(cpuid, maskPtr) {
+		if (is_cpufreq_valid(cpuid))
+			cpufreq_update_policy(cpuid);
+	}
+
+	notify_table = NOTIFY_INVALID;
+
+	return 0;
+}
+
+/**
+ * cpufreq_thermal_notifier - notifier callback for cpufreq policy change.
+ * @nb:	struct notifier_block * with callback info.
+ * @event: value showing cpufreq event for which this function invoked.
+ * @data: callback-specific data
+ */
+static int cpufreq_thermal_notifier(struct notifier_block *nb,
+					unsigned long event, void *data)
+{
+	struct cpufreq_policy *policy = data;
+	unsigned long max_freq = 0;
+
+	if (event != CPUFREQ_ADJUST)
+		return 0;
+
+	if (notify_table != NOTIFY_INVALID) {
+		max_freq = notify_table->freq_clip_max;
+
+		if (!per_cpu(max_policy_freq, policy->cpu))
+			per_cpu(max_policy_freq, policy->cpu) = policy->max;
+	} else {
+		if (per_cpu(max_policy_freq, policy->cpu)) {
+			max_freq = per_cpu(max_policy_freq, policy->cpu);
+			per_cpu(max_policy_freq, policy->cpu) = 0;
+		} else {
+			max_freq = policy->max;
+		}
+	}
+
+	/* Never exceed user_policy.max*/
+	if (max_freq > policy->user_policy.max)
+		max_freq = policy->user_policy.max;
+
+	if (policy->max != max_freq)
+		cpufreq_verify_within_limits(policy, 0, max_freq);
+
+	return 0;
+}
+
+/*
+ * cpufreq cooling device callback functions are defined below
+ */
+
+/**
+ * cpufreq_get_max_state - callback function to get the max cooling state.
+ * @cdev: thermal cooling device pointer.
+ * @state: fill this variable with the max cooling state.
+ */
+static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int ret = -EINVAL;
+	struct cpufreq_cooling_device *cpufreq_device;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
+			*state = cpufreq_device->tab_size;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
+	return ret;
+}
+
+/**
+ * cpufreq_get_cur_state - callback function to get the current cooling state.
+ * @cdev: thermal cooling device pointer.
+ * @state: fill this variable with the current cooling state.
+ */
+static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	int ret = -EINVAL;
+	struct cpufreq_cooling_device *cpufreq_device;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
+			*state = cpufreq_device->cpufreq_state;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
+	return ret;
+}
+
+/**
+ * cpufreq_set_cur_state - callback function to set the current cooling state.
+ * @cdev: thermal cooling device pointer.
+ * @state: set this variable to the current cooling state.
+ */
+static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long state)
+{
+	int ret = -EINVAL;
+	struct cpufreq_cooling_device *cpufreq_device;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
+		if (cpufreq_device && cpufreq_device->cool_dev == cdev) {
+			ret = 0;
+			break;
+		}
+	}
+	if (!ret)
+		ret = cpufreq_apply_cooling(cpufreq_device, state);
+
+	mutex_unlock(&cooling_cpufreq_lock);
+
+	return ret;
+}
+
+/* Bind cpufreq callbacks to thermal cooling device ops */
+static struct thermal_cooling_device_ops const cpufreq_cooling_ops = {
+	.get_max_state = cpufreq_get_max_state,
+	.get_cur_state = cpufreq_get_cur_state,
+	.set_cur_state = cpufreq_set_cur_state,
+};
+
+/* Notifier for cpufreq policy change */
+static struct notifier_block thermal_cpufreq_notifier_block = {
+	.notifier_call = cpufreq_thermal_notifier,
+};
+
+/**
+ * cpufreq_cooling_register - function to create cpufreq cooling device.
+ * @tab_ptr: table ptr containing the maximum value of frequency to be clipped
+ *	for each cooling state.
+ * @tab_size: count of entries in the above table.
+ *	happen.
+ */
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size)
+{
+	struct thermal_cooling_device *cool_dev;
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	struct freq_clip_table *clip_tab;
+	unsigned int cpufreq_dev_count = 0;
+	char dev_name[THERMAL_NAME_LENGTH];
+	int ret = 0, id = 0, i;
+
+	if (tab_ptr == NULL || tab_size == 0)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
+		cpufreq_dev_count++;
+
+	cpufreq_dev = kzalloc(sizeof(struct cpufreq_cooling_device),
+			GFP_KERNEL);
+	if (!cpufreq_dev)
+		return ERR_PTR(-ENOMEM);
+
+	/* Verify that all the entries of freq_clip_table are present */
+	for (i = 0; i < tab_size; i++) {
+		clip_tab = ((struct freq_clip_table *)&tab_ptr[i]);
+		if (!clip_tab->freq_clip_max || !clip_tab->mask_val
+					|| !clip_tab->temp_level) {
+			kfree(cpufreq_dev);
+			return ERR_PTR(-EINVAL);
+		}
+		/*
+		 * Consolidate all the cpumask for all the individual entries
+		 * of the trip table. This is useful in resetting all the
+		 * clipped frequencies to the normal level for each cpufreq
+		 * cooling device.
+		 */
+		cpumask_or(&cpufreq_dev->allowed_cpus,
+			&cpufreq_dev->allowed_cpus, clip_tab->mask_val);
+	}
+
+	cpufreq_dev->tab_ptr = tab_ptr;
+	cpufreq_dev->tab_size = tab_size;
+
+	ret = get_idr(&cpufreq_idr, &cpufreq_dev->id);
+	if (ret) {
+		kfree(cpufreq_dev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
+
+	cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
+						&cpufreq_cooling_ops);
+	if (!cool_dev) {
+		release_idr(&cpufreq_idr, cpufreq_dev->id);
+		kfree(cpufreq_dev);
+		return ERR_PTR(-EINVAL);
+	}
+	cpufreq_dev->id = id;
+	cpufreq_dev->cool_dev = cool_dev;
+	mutex_lock(&cooling_cpufreq_lock);
+	list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list);
+
+	/* Register the notifier for first cpufreq cooling device */
+	if (cpufreq_dev_count == 0)
+		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
+						CPUFREQ_POLICY_NOTIFIER);
+
+	mutex_unlock(&cooling_cpufreq_lock);
+	return cool_dev;
+}
+EXPORT_SYMBOL(cpufreq_cooling_register);
+
+/**
+ * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
+ * @cdev: thermal cooling device pointer.
+ */
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+{
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	unsigned int cpufreq_dev_count = 0;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node) {
+		if (cpufreq_dev && cpufreq_dev->cool_dev == cdev)
+			break;
+		cpufreq_dev_count++;
+	}
+
+	if (!cpufreq_dev || cpufreq_dev->cool_dev != cdev) {
+		mutex_unlock(&cooling_cpufreq_lock);
+		return;
+	}
+
+	list_del(&cpufreq_dev->node);
+
+	/* Unregister the notifier for the last cpufreq cooling device */
+	if (cpufreq_dev_count == 1) {
+		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
+					CPUFREQ_POLICY_NOTIFIER);
+	}
+	mutex_unlock(&cooling_cpufreq_lock);
+	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
+	release_idr(&cpufreq_idr, cpufreq_dev->id);
+	kfree(cpufreq_dev);
+}
+EXPORT_SYMBOL(cpufreq_cooling_unregister);
diff -puN /dev/null include/linux/cpu_cooling.h
--- /dev/null
+++ a/include/linux/cpu_cooling.h
@@ -0,0 +1,99 @@
+/*
+ *  linux/include/linux/cpu_cooling.h
+ *
+ *  Copyright (C) 2012	Samsung Electronics Co., Ltd(http://www.samsung.com)
+ *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#ifndef __CPU_COOLING_H__
+#define __CPU_COOLING_H__
+
+#include <linux/thermal.h>
+
+#define CPUFREQ_COOLING_START		0
+#define CPUFREQ_COOLING_STOP		1
+
+/**
+ * struct freq_clip_table
+ * @freq_clip_max: maximum frequency allowed for this cooling state.
+ * @temp_level: Temperature level at which the temperature clipping will
+ *	happen.
+ * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
+ *
+ * This structure is required to be filled and passed to the
+ * cpufreq_cooling_unregister function.
+ */
+struct freq_clip_table {
+	unsigned int freq_clip_max;
+	unsigned int temp_level;
+	const struct cpumask *mask_val;
+};
+
+/**
+ * cputherm_register_notifier - Register a notifier with cpu cooling interface.
+ * @nb:	struct notifier_block * with callback info.
+ * @list: integer value for which notification is needed. possible values are
+ *	CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
+ *
+ * This exported function registers a driver with cpu cooling layer. The driver
+ * will be notified when any cpu cooling action is called.
+ */
+int cputherm_register_notifier(struct notifier_block *nb, unsigned int list);
+
+/**
+ * cputherm_unregister_notifier - Un-register a notifier.
+ * @nb:	struct notifier_block * with callback info.
+ * @list: integer value for which notification is needed. values possible are
+ *	CPUFREQ_COOLING_START and CPUFREQ_COOLING_STOP.
+ *
+ * This exported function un-registers a driver with cpu cooling layer.
+ */
+int cputherm_unregister_notifier(struct notifier_block *nb, unsigned int list);
+
+#ifdef CONFIG_CPU_FREQ
+/**
+ * cpufreq_cooling_register - function to create cpufreq cooling device.
+ * @tab_ptr: table ptr containing the maximum value of frequency to be clipped
+ *	for each cooling state.
+ * @tab_size: count of entries in the above table.
+ * @mask_val: cpumask containing the allowed cpu's where frequency clipping can
+ *	happen.
+ */
+struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size);
+
+/**
+ * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
+ * @cdev: thermal cooling device pointer.
+ */
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
+#else /* !CONFIG_CPU_FREQ */
+static inline struct thermal_cooling_device *cpufreq_cooling_register(
+	struct freq_clip_table *tab_ptr, unsigned int tab_size)
+{
+	return NULL;
+}
+static inline void cpufreq_cooling_unregister(
+		struct thermal_cooling_device *cdev)
+{
+	return;
+}
+#endif	/* CONFIG_CPU_FREQ */
+
+#endif /* __CPU_COOLING_H__ */
_

Patches currently in -mm which might be from amit.kachhap@linaro.org are

linux-next.patch

