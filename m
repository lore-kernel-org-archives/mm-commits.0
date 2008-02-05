From: akpm@linux-foundation.org
Subject: - pm-qos-infrastructure-and-interface.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:07 -0800
Message-ID: <200802052233.m15MXmis012456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762875AbYBEWpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, abelay@novell.com, arjan@infradead.org, lenb@kernel.org, linville@tuxdriver.com, perex@suse.cz, tiwai@suse.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pm qos infrastructure and interface
has been removed from the -mm tree.  Its filename was
     pm-qos-infrastructure-and-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm qos infrastructure and interface
From: Mark Gross <mgross@linux.intel.com>

The following patch is a generalization of the latency.c implementation done
by Arjan last year.  It provides infrastructure for more than one parameter,
and exposes a user mode interface for processes to register pm_qos
expectations of processes.

This interface provides a kernel and user mode interface for registering
performance expectations by drivers, subsystems and user space applications on
one of the parameters.

Currently we have {cpu_dma_latency, network_latency, network_throughput} as
the initial set of pm_qos parameters.

The infrastructure exposes multiple misc device nodes one per implemented
parameter.  The set of parameters implement is defined by pm_qos_power_init()
and pm_qos_params.h.  This is done because having the available parameters
being runtime configurable or changeable from a driver was seen as too easy to
abuse.

For each parameter a list of performance requirements is maintained along with
an aggregated target value.  The aggregated target value is updated with
changes to the requirement list or elements of the list.  Typically the
aggregated target value is simply the max or min of the requirement values
held in the parameter list elements.

From kernel mode the use of this interface is simple:

pm_qos_add_requirement(param_id, name, target_value):

  Will insert a named element in the list for that identified PM_QOS
  parameter with the target value.  Upon change to this list the new target is
  recomputed and any registered notifiers are called only if the target value
  is now different.

pm_qos_update_requirement(param_id, name, new_target_value):

  Will search the list identified by the param_id for the named list element
  and then update its target value, calling the notification tree if the
  aggregated target is changed.  with that name is already registered.

pm_qos_remove_requirement(param_id, name):

  Will search the identified list for the named element and remove it, after
  removal it will update the aggregate target and call the notification tree
  if the target was changed as a result of removing the named requirement.

From user mode:

  Only processes can register a pm_qos requirement.  To provide for
  automatic cleanup for process the interface requires the process to register
  its parameter requirements in the following way:

  To register the default pm_qos target for the specific parameter, the
  process must open one of /dev/[cpu_dma_latency, network_latency,
  network_throughput]

  As long as the device node is held open that process has a registered
  requirement on the parameter.  The name of the requirement is
  "process_<PID>" derived from the current->pid from within the open system
  call.

  To change the requested target value the process needs to write a s32
  value to the open device node.  This translates to a
  pm_qos_update_requirement call.

  To remove the user mode request for a target value simply close the device
  node.

[akpm@linux-foundation.org: fix warnings]
[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: fix build again]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pm_qos_interface.txt |   59 +++
 drivers/cpuidle/cpuidle.c          |    7 
 drivers/cpuidle/governors/ladder.c |    5 
 drivers/cpuidle/governors/menu.c   |    4 
 include/linux/pm_qos_params.h      |   25 +
 kernel/Makefile                    |    2 
 kernel/pm_qos_params.c             |  425 +++++++++++++++++++++++++++
 7 files changed, 520 insertions(+), 7 deletions(-)

diff -puN /dev/null Documentation/pm_qos_interface.txt
--- /dev/null
+++ a/Documentation/pm_qos_interface.txt
@@ -0,0 +1,59 @@
+PM quality of Service interface.
+
+This interface provides a kernel and user mode interface for registering
+performance expectations by drivers, subsystems and user space applications on
+one of the parameters.
+
+Currently we have {cpu_dma_latency, network_latency, network_throughput} as the
+initial set of pm_qos parameters.
+
+The infrastructure exposes multiple misc device nodes one per implemented
+parameter.  The set of parameters implement is defined by pm_qos_power_init()
+and pm_qos_params.h.  This is done because having the available parameters
+being runtime configurable or changeable from a driver was seen as too easy to
+abuse.
+
+For each parameter a list of performance requirements is maintained along with
+an aggregated target value.  The aggregated target value is updated with
+changes to the requirement list or elements of the list.  Typically the
+aggregated target value is simply the max or min of the requirement values held
+in the parameter list elements.
+
+From kernel mode the use of this interface is simple:
+pm_qos_add_requirement(param_id, name, target_value):
+Will insert a named element in the list for that identified PM_QOS parameter
+with the target value.  Upon change to this list the new target is recomputed
+and any registered notifiers are called only if the target value is now
+different.
+
+pm_qos_update_requirement(param_id, name, new_target_value):
+Will search the list identified by the param_id for the named list element and
+then update its target value, calling the notification tree if the aggregated
+target is changed.  with that name is already registered.
+
+pm_qos_remove_requirement(param_id, name):
+Will search the identified list for the named element and remove it, after
+removal it will update the aggregate target and call the notification tree if
+the target was changed as a result of removing the named requirement.
+
+
+From user mode:
+Only processes can register a pm_qos requirement.  To provide for automatic
+cleanup for process the interface requires the process to register its
+parameter requirements in the following way:
+
+To register the default pm_qos target for the specific parameter, the process
+must open one of /dev/[cpu_dma_latency, network_latency, network_throughput]
+
+As long as the device node is held open that process has a registered
+requirement on the parameter.  The name of the requirement is "process_<PID>"
+derived from the current->pid from within the open system call.
+
+To change the requested target value the process needs to write a s32 value to
+the open device node.  This translates to a pm_qos_update_requirement call.
+
+To remove the user mode request for a target value simply close the device
+node.
+
+
+
diff -puN drivers/cpuidle/cpuidle.c~pm-qos-infrastructure-and-interface drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~pm-qos-infrastructure-and-interface
+++ a/drivers/cpuidle/cpuidle.c
@@ -12,7 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/notifier.h>
-#include <linux/latency.h>
+#include <linux/pm_qos_params.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 
@@ -265,7 +265,10 @@ static struct notifier_block cpuidle_lat
 	.notifier_call = cpuidle_latency_notify,
 };
 
-#define latency_notifier_init(x) do { register_latency_notifier(x); } while (0)
+static inline void latency_notifier_init(struct notifier_block *n)
+{
+	pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY, n);
+}
 
 #else /* CONFIG_SMP */
 
diff -puN drivers/cpuidle/governors/ladder.c~pm-qos-infrastructure-and-interface drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c~pm-qos-infrastructure-and-interface
+++ a/drivers/cpuidle/governors/ladder.c
@@ -14,7 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/cpuidle.h>
-#include <linux/latency.h>
+#include <linux/pm_qos_params.h>
 #include <linux/moduleparam.h>
 #include <linux/jiffies.h>
 
@@ -81,7 +81,8 @@ static int ladder_select_state(struct cp
 	/* consider promotion */
 	if (last_idx < dev->state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
-	    dev->states[last_idx + 1].exit_latency <= system_latency_constraint()) {
+	    dev->states[last_idx + 1].exit_latency <=
+			pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY)) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
diff -puN drivers/cpuidle/governors/menu.c~pm-qos-infrastructure-and-interface drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~pm-qos-infrastructure-and-interface
+++ a/drivers/cpuidle/governors/menu.c
@@ -8,7 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/cpuidle.h>
-#include <linux/latency.h>
+#include <linux/pm_qos_params.h>
 #include <linux/time.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
@@ -48,7 +48,7 @@ static int menu_select(struct cpuidle_de
 			break;
 		if (s->target_residency > data->predicted_us)
 			break;
-		if (s->exit_latency > system_latency_constraint())
+		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
 			break;
 	}
 
diff -puN /dev/null include/linux/pm_qos_params.h
--- /dev/null
+++ a/include/linux/pm_qos_params.h
@@ -0,0 +1,25 @@
+/* interface for the pm_qos_power infrastructure of the linux kernel.
+ *
+ * Mark Gross
+ */
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/miscdevice.h>
+
+#define PM_QOS_RESERVED 0
+#define PM_QOS_CPU_DMA_LATENCY 1
+#define PM_QOS_NETWORK_LATENCY 2
+#define PM_QOS_NETWORK_THROUGHPUT 3
+
+#define PM_QOS_NUM_CLASSES 4
+#define PM_QOS_DEFAULT_VALUE -1
+
+int pm_qos_add_requirement(int qos, char *name, s32 value);
+int pm_qos_update_requirement(int qos, char *name, s32 new_value);
+void pm_qos_remove_requirement(int qos, char *name);
+
+int pm_qos_requirement(int qos);
+
+int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
+int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
+
diff -puN kernel/Makefile~pm-qos-infrastructure-and-interface kernel/Makefile
--- a/kernel/Makefile~pm-qos-infrastructure-and-interface
+++ a/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
-	    utsname.o notifier.o ksysfs.o
+	    utsname.o notifier.o ksysfs.o pm_qos_params.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff -puN /dev/null kernel/pm_qos_params.c
--- /dev/null
+++ a/kernel/pm_qos_params.c
@@ -0,0 +1,425 @@
+/*
+ * This module exposes the interface to kernel space for specifying
+ * QoS dependencies.  It provides infrastructure for registration of:
+ *
+ * Dependents on a QoS value : register requirements
+ * Watchers of QoS value : get notified when target QoS value changes
+ *
+ * This QoS design is best effort based.  Dependents register their QoS needs.
+ * Watchers register to keep track of the current QoS needs of the system.
+ *
+ * There are 3 basic classes of QoS parameter: latency, timeout, throughput
+ * each have defined units:
+ * latency: usec
+ * timeout: usec <-- currently not used.
+ * throughput: kbs (kilo byte / sec)
+ *
+ * There are lists of pm_qos_objects each one wrapping requirements, notifiers
+ *
+ * User mode requirements on a QOS parameter register themselves to the
+ * subsystem by opening the device node /dev/... and writing there request to
+ * the node.  As long as the process holds a file handle open to the node the
+ * client continues to be accounted for.  Upon file release the usermode
+ * requirement is removed and a new qos target is computed.  This way when the
+ * requirement that the application has is cleaned up when closes the file
+ * pointer or exits the pm_qos_object will get an opportunity to clean up.
+ *
+ * mark gross mgross@linux.intel.com
+ */
+
+#include <linux/pm_qos_params.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+
+#include <linux/uaccess.h>
+
+/*
+ * locking rule: all changes to target_value or requirements or notifiers lists
+ * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
+ * held, taken with _irqsave.  One lock to rule them all
+ */
+struct requirement_list {
+	struct list_head list;
+	union {
+		s32 value;
+		s32 usec;
+		s32 kbps;
+	};
+	char *name;
+};
+
+static s32 max_compare(s32 v1, s32 v2);
+static s32 min_compare(s32 v1, s32 v2);
+
+struct pm_qos_object {
+	struct requirement_list requirements;
+	struct blocking_notifier_head *notifiers;
+	struct miscdevice pm_qos_power_miscdev;
+	char *name;
+	s32 default_value;
+	s32 target_value;
+	s32 (*comparitor)(s32, s32);
+};
+
+static struct pm_qos_object null_pm_qos;
+static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
+static struct pm_qos_object cpu_dma_pm_qos = {
+	.requirements = {LIST_HEAD_INIT(cpu_dma_pm_qos.requirements.list)},
+	.notifiers = &cpu_dma_lat_notifier,
+	.name = "cpu_dma_latency",
+	.default_value = 2000 * USEC_PER_SEC,
+	.target_value = 2000 * USEC_PER_SEC,
+	.comparitor = min_compare
+};
+
+static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
+static struct pm_qos_object network_lat_pm_qos = {
+	.requirements = {LIST_HEAD_INIT(network_lat_pm_qos.requirements.list)},
+	.notifiers = &network_lat_notifier,
+	.name = "network_latency",
+	.default_value = 2000 * USEC_PER_SEC,
+	.target_value = 2000 * USEC_PER_SEC,
+	.comparitor = min_compare
+};
+
+
+static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
+static struct pm_qos_object network_throughput_pm_qos = {
+	.requirements =
+		{LIST_HEAD_INIT(network_throughput_pm_qos.requirements.list)},
+	.notifiers = &network_throughput_notifier,
+	.name = "network_throughput",
+	.default_value = 0,
+	.target_value = 0,
+	.comparitor = max_compare
+};
+
+
+static struct pm_qos_object *pm_qos_array[] = {
+	&null_pm_qos,
+	&cpu_dma_pm_qos,
+	&network_lat_pm_qos,
+	&network_throughput_pm_qos
+};
+
+static DEFINE_SPINLOCK(pm_qos_lock);
+
+static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos);
+static int pm_qos_power_open(struct inode *inode, struct file *filp);
+static int pm_qos_power_release(struct inode *inode, struct file *filp);
+
+static const struct file_operations pm_qos_power_fops = {
+	.write = pm_qos_power_write,
+	.open = pm_qos_power_open,
+	.release = pm_qos_power_release,
+};
+
+/* static helper functions */
+static s32 max_compare(s32 v1, s32 v2)
+{
+	return max(v1, v2);
+}
+
+static s32 min_compare(s32 v1, s32 v2)
+{
+	return min(v1, v2);
+}
+
+
+static void update_target(int target)
+{
+	s32 extreme_value;
+	struct requirement_list *node;
+	unsigned long flags;
+	int call_notifier = 0;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	extreme_value = pm_qos_array[target]->default_value;
+	list_for_each_entry(node,
+			&pm_qos_array[target]->requirements.list, list) {
+		extreme_value = pm_qos_array[target]->comparitor(
+				extreme_value, node->value);
+	}
+	if (pm_qos_array[target]->target_value != extreme_value) {
+		call_notifier = 1;
+		pm_qos_array[target]->target_value = extreme_value;
+		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
+			pm_qos_array[target]->target_value);
+	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	if (call_notifier)
+		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
+			(unsigned long) extreme_value, NULL);
+}
+
+static int register_pm_qos_misc(struct pm_qos_object *qos)
+{
+	qos->pm_qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
+	qos->pm_qos_power_miscdev.name = qos->name;
+	qos->pm_qos_power_miscdev.fops = &pm_qos_power_fops;
+
+	return misc_register(&qos->pm_qos_power_miscdev);
+}
+
+static int find_pm_qos_object_by_minor(int minor)
+{
+	int pm_qos_class;
+
+	for (pm_qos_class = 0;
+		pm_qos_class < PM_QOS_NUM_CLASSES; pm_qos_class++) {
+		if (minor ==
+			pm_qos_array[pm_qos_class]->pm_qos_power_miscdev.minor)
+			return pm_qos_class;
+	}
+	return -1;
+}
+
+/**
+ * pm_qos_requirement - returns current system wide qos expectation
+ * @pm_qos_class: identification of which qos value is requested
+ *
+ * This function returns the current target value in an atomic manner.
+ */
+int pm_qos_requirement(int pm_qos_class)
+{
+	int ret_val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	ret_val = pm_qos_array[pm_qos_class]->target_value;
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return ret_val;
+}
+EXPORT_SYMBOL_GPL(pm_qos_requirement);
+
+/**
+ * pm_qos_add_requirement - inserts new qos request into the list
+ * @pm_qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ * @value: defines the qos request
+ *
+ * This function inserts a new entry in the pm_qos_class list of requested qos
+ * performance charactoistics.  It recomputes the agregate QoS expectations for
+ * the pm_qos_class of parrameters.
+ */
+int pm_qos_add_requirement(int pm_qos_class, char *name, s32 value)
+{
+	struct requirement_list *dep;
+	unsigned long flags;
+
+	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
+	if (dep) {
+		if (value == PM_QOS_DEFAULT_VALUE)
+			dep->value = pm_qos_array[pm_qos_class]->default_value;
+		else
+			dep->value = value;
+		dep->name = kstrdup(name, GFP_KERNEL);
+		if (!dep->name)
+			goto cleanup;
+
+		spin_lock_irqsave(&pm_qos_lock, flags);
+		list_add(&dep->list,
+			&pm_qos_array[pm_qos_class]->requirements.list);
+		spin_unlock_irqrestore(&pm_qos_lock, flags);
+		update_target(pm_qos_class);
+
+		return 0;
+	}
+
+cleanup:
+	kfree(dep);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(pm_qos_add_requirement);
+
+/**
+ * pm_qos_update_requirement - modifies an existing qos request
+ * @pm_qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ * @value: defines the qos request
+ *
+ * Updates an existing qos requierement for the pm_qos_class of parameters along
+ * with updating the target pm_qos_class value.
+ *
+ * If the named request isn't in the lest then no change is made.
+ */
+int pm_qos_update_requirement(int pm_qos_class, char *name, s32 new_value)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	list_for_each_entry(node,
+		&pm_qos_array[pm_qos_class]->requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			if (new_value == PM_QOS_DEFAULT_VALUE)
+				node->value =
+				pm_qos_array[pm_qos_class]->default_value;
+			else
+				node->value = new_value;
+			pending_update = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	if (pending_update)
+		update_target(pm_qos_class);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pm_qos_update_requirement);
+
+/**
+ * pm_qos_remove_requirement - modifies an existing qos request
+ * @pm_qos_class: identifies which list of qos request to us
+ * @name: identifies the request
+ *
+ * Will remove named qos request from pm_qos_class list of parrameters and
+ * recompute the current target value for the pm_qos_class.
+ */
+void pm_qos_remove_requirement(int pm_qos_class, char *name)
+{
+	unsigned long flags;
+	struct requirement_list *node;
+	int pending_update = 0;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	list_for_each_entry(node,
+		&pm_qos_array[pm_qos_class]->requirements.list, list) {
+		if (strcmp(node->name, name) == 0) {
+			kfree(node->name);
+			list_del(&node->list);
+			kfree(node);
+			pending_update = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	if (pending_update)
+		update_target(pm_qos_class);
+}
+EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
+
+/**
+ * pm_qos_add_notifier - sets notification entry for changes to target value
+ * @pm_qos_class: identifies which qos target changes should be notified.
+ * @notifier: notifier block managed by caller.
+ *
+ * will register the notifier into a notification chain that gets called
+ * uppon changes to the pm_qos_class target value.
+ */
+ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
+{
+	int retval;
+
+	retval = blocking_notifier_chain_register(
+			pm_qos_array[pm_qos_class]->notifiers, notifier);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
+
+/**
+ * pm_qos_remove_notifier - deletes notification entry from chain.
+ * @pm_qos_class: identifies which qos target changes are notified.
+ * @notifier: notifier block to be removed.
+ *
+ * will remove the notifier from the notification chain that gets called
+ * uppon changes to the pm_qos_class target value.
+ */
+int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
+{
+	int retval;
+
+	retval = blocking_notifier_chain_unregister(
+			pm_qos_array[pm_qos_class]->notifiers, notifier);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
+
+#define PID_NAME_LEN sizeof("process_1234567890")
+static char name[PID_NAME_LEN];
+
+static int pm_qos_power_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	long pm_qos_class;
+
+	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
+	if (pm_qos_class >= 0) {
+		filp->private_data = (void *)pm_qos_class;
+		sprintf(name, "process_%d", current->pid);
+		ret = pm_qos_add_requirement(pm_qos_class, name,
+					PM_QOS_DEFAULT_VALUE);
+		if (ret >= 0)
+			return 0;
+	}
+
+	return -EPERM;
+}
+
+static int pm_qos_power_release(struct inode *inode, struct file *filp)
+{
+	int pm_qos_class;
+
+	pm_qos_class = (long)filp->private_data;
+	sprintf(name, "process_%d", current->pid);
+	pm_qos_remove_requirement(pm_qos_class, name);
+
+	return 0;
+}
+
+static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value;
+	int pm_qos_class;
+
+	pm_qos_class = (long)filp->private_data;
+	if (count != sizeof(s32))
+		return -EINVAL;
+	if (copy_from_user(&value, buf, sizeof(s32)))
+		return -EFAULT;
+	sprintf(name, "process_%d", current->pid);
+	pm_qos_update_requirement(pm_qos_class, name, value);
+
+	return  sizeof(s32);
+}
+
+
+static int __init pm_qos_power_init(void)
+{
+	int ret = 0;
+
+	ret = register_pm_qos_misc(&cpu_dma_pm_qos);
+	if (ret < 0) {
+		printk(KERN_ERR "pm_qos_param: cpu_dma_latency setup failed\n");
+		return ret;
+	}
+	ret = register_pm_qos_misc(&network_lat_pm_qos);
+	if (ret < 0) {
+		printk(KERN_ERR "pm_qos_param: network_latency setup failed\n");
+		return ret;
+	}
+	ret = register_pm_qos_misc(&network_throughput_pm_qos);
+	if (ret < 0)
+		printk(KERN_ERR
+			"pm_qos_param: network_throughput setup failed\n");
+
+	return ret;
+}
+
+late_initcall(pm_qos_power_init);
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
intel-iommu-pmen-support.patch
intel-iommu-pmen-support-fix.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
