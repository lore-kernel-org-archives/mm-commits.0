From: akpm@linux-foundation.org
Subject: - pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch removed from -mm tree
Date: Sun, 03 Feb 2008 20:02:35 -0800
Message-ID: <200802040402.m1442GaZ012947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbYBDEEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:04:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, abelay@novell.com, akpm@linux-foundation.org, arjan@infradead.org, lenb@kernel.org, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pm-qos: static initialization with blocking notifiers
has been removed from the -mm tree.  Its filename was
     pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch

This patch was dropped because it was folded into pm-qos-infrastructure-and-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-qos: static initialization with blocking notifiers
From: Mark Gross <mgross@linux.intel.com>

Update the pm_qos code in the mm1 tree.  It removes the PM_QOS_CPUIDLE
parameter (replacing it with PM_CPU_DMA_LATENCY), It changes the
notifications from srcu to blocking in hopes of fixing the WARNS reported
by xxx, and it changes the initialization to me largely static to avoid
initialization race with cpu-idle.

I think we will have to re-visit the static vrs dynamic initialization and
this init race in a while to support pm_qos parameters per power domain
(i.e.  per cpu-socket) based on platform information (ACPI) but for now
lets see if this fixes the warnings reported.

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
DESC
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes
EDESC

ERROR: use tabs not spaces
#37: FILE: drivers/cpuidle/cpuidle.c:271:
$

WARNING: line over 80 characters
#61: FILE: drivers/cpuidle/governors/menu.c:51:
+		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Adam Belay <abelay@novell.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Mark Gross <mgross@linux.intel.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: mark gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c          |    2 
 drivers/cpuidle/governors/ladder.c |    2 
 drivers/cpuidle/governors/menu.c   |    2 
 include/linux/pm_qos_params.h      |   13 --
 kernel/pm_qos_params.c             |  151 ++++++++++++++-------------
 5 files changed, 85 insertions(+), 85 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers
+++ a/drivers/cpuidle/cpuidle.c
@@ -267,7 +267,7 @@ static struct notifier_block cpuidle_lat
 
 static inline void latency_notifier_init(struct notifier_block *n)
 {
-        pm_qos_add_notifier(PM_QOS_CPUIDLE, n);
+	pm_qos_add_notifier(PM_QOS_CPU_DMA_LATENCY, n);
 }
 
 #else /* CONFIG_SMP */
diff -puN drivers/cpuidle/governors/ladder.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers
+++ a/drivers/cpuidle/governors/ladder.c
@@ -82,7 +82,7 @@ static int ladder_select_state(struct cp
 	if (last_idx < dev->state_count - 1 &&
 	    last_residency > last_state->threshold.promotion_time &&
 	    dev->states[last_idx + 1].exit_latency <=
-			pm_qos_requirement(PM_QOS_CPUIDLE)) {
+			pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY)) {
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
diff -puN drivers/cpuidle/governors/menu.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers
+++ a/drivers/cpuidle/governors/menu.c
@@ -48,7 +48,7 @@ static int menu_select(struct cpuidle_de
 			break;
 		if (s->target_residency > data->predicted_us)
 			break;
-		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPUIDLE))
+		if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
 			break;
 	}
 
diff -puN include/linux/pm_qos_params.h~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers include/linux/pm_qos_params.h
--- a/include/linux/pm_qos_params.h~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers
+++ a/include/linux/pm_qos_params.h
@@ -6,23 +6,12 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 
-struct requirement_list {
-	struct list_head list;
-	union {
-		s32 value;
-		s32 usec;
-		s32 kbps;
-	};
-	char *name;
-};
-
 #define PM_QOS_RESERVED 0
 #define PM_QOS_CPU_DMA_LATENCY 1
 #define PM_QOS_NETWORK_LATENCY 2
 #define PM_QOS_NETWORK_THROUGHPUT 3
-#define PM_QOS_CPUIDLE 4
 
-#define PM_QOS_NUM_CLASSES 5
+#define PM_QOS_NUM_CLASSES 4
 #define PM_QOS_DEFAULT_VALUE -1
 
 int pm_qos_add_requirement(int qos, char *name, s32 value);
diff -puN kernel/pm_qos_params.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers kernel/pm_qos_params.c
--- a/kernel/pm_qos_params.c~pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers
+++ a/kernel/pm_qos_params.c
@@ -46,17 +46,70 @@
  * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
  * held, taken with _irqsave.  One lock to rule them all
  */
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
 
 struct pm_qos_object {
 	struct requirement_list requirements;
-	struct srcu_notifier_head notifiers;
+	struct blocking_notifier_head *notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
 	s32 default_value;
 	s32 target_value;
 	s32 (*comparitor)(s32, s32);
 };
-static struct pm_qos_object pm_qos_array[PM_QOS_NUM_CLASSES];
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
 static DEFINE_SPINLOCK(pm_qos_lock);
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
@@ -81,29 +134,31 @@ static s32 min_compare(s32 v1, s32 v2)
 	return min(v1, v2);
 }
 
+
+
 /* assumes pm_qos_lock is held */
 static void update_target(int target)
 {
 	s32 extreme_value;
 	struct requirement_list *node;
 
-	extreme_value = pm_qos_array[target].default_value;
+	extreme_value = pm_qos_array[target]->default_value;
 	list_for_each_entry(node,
-			&pm_qos_array[target].requirements.list, list) {
-		extreme_value = pm_qos_array[target].comparitor(
+			&pm_qos_array[target]->requirements.list, list) {
+		extreme_value = pm_qos_array[target]->comparitor(
 				extreme_value, node->value);
 	}
-	if (pm_qos_array[target].target_value != extreme_value) {
-		pm_qos_array[target].target_value = extreme_value;
+	if (pm_qos_array[target]->target_value != extreme_value) {
+		pm_qos_array[target]->target_value = extreme_value;
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
-			pm_qos_array[target].target_value);
-		srcu_notifier_call_chain(&pm_qos_array[target].notifiers,
-			(unsigned long) pm_qos_array[target].target_value,
+			pm_qos_array[target]->target_value);
+		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
+			(unsigned long) pm_qos_array[target]->target_value,
 						NULL);
 	}
 }
 
-static int register_new_pm_qos_misc(struct pm_qos_object *qos)
+static int register_pm_qos_misc(struct pm_qos_object *qos)
 {
 	qos->pm_qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
 	qos->pm_qos_power_miscdev.name = qos->name;
@@ -112,38 +167,6 @@ static int register_new_pm_qos_misc(stru
 	return misc_register(&qos->pm_qos_power_miscdev);
 }
 
-
-/* constructors */
-static int init_pm_qos_object(int pm_qos_class, const char *name,
-			s32 default_value, s32 (*comparitor)(s32, s32))
-{
-	int ret = -ENOMEM;
-	struct pm_qos_object *qos = NULL;
-
-	if (pm_qos_class < PM_QOS_NUM_CLASSES) {
-		qos = &pm_qos_array[pm_qos_class];
-		qos->name = kstrdup(name, GFP_KERNEL);
-		if (!qos->name)
-			goto cleanup;
-
-		qos->default_value = default_value;
-		qos->target_value = default_value;
-		qos->comparitor = comparitor;
-		srcu_init_notifier_head(&qos->notifiers);
-		INIT_LIST_HEAD(&qos->requirements.list);
-		ret = register_new_pm_qos_misc(qos);
-		if (ret < 0)
-			goto cleanup;
-	} else
-		ret = -EINVAL;
-
-	return ret;
-cleanup:
-	kfree(qos->name);
-
-	return ret;
-}
-
 static int find_pm_qos_object_by_minor(int minor)
 {
 	int pm_qos_class;
@@ -151,24 +174,12 @@ static int find_pm_qos_object_by_minor(i
 	for (pm_qos_class = 0;
 		pm_qos_class < PM_QOS_NUM_CLASSES; pm_qos_class++) {
 		if (minor ==
-			pm_qos_array[pm_qos_class].pm_qos_power_miscdev.minor)
+			pm_qos_array[pm_qos_class]->pm_qos_power_miscdev.minor)
 			return pm_qos_class;
 	}
 	return -1;
 }
 
-static int new_latency_qos(int pm_qos_class, const char *name)
-{
-	return init_pm_qos_object(pm_qos_class, name, 2000 * USEC_PER_SEC,
-			min_compare);
-	/* 2000 sec is about infinite */
-}
-
-static int new_throughput_qos(int pm_qos_class, const char *name)
-{
-	return init_pm_qos_object(pm_qos_class, name, 0, max_compare);
-}
-
 /**
  * pm_qos_requirement - returns current system wide qos expectation
  * @pm_qos_class: identification of which qos value is requested
@@ -181,7 +192,7 @@ int pm_qos_requirement(int pm_qos_class)
 	unsigned long flags;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	ret_val = pm_qos_array[pm_qos_class].target_value;
+	ret_val = pm_qos_array[pm_qos_class]->target_value;
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return ret_val;
@@ -206,7 +217,7 @@ int pm_qos_add_requirement(int pm_qos_cl
 	dep = kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
 	if (dep) {
 		if (value == PM_QOS_DEFAULT_VALUE)
-			dep->value = pm_qos_array[pm_qos_class].default_value;
+			dep->value = pm_qos_array[pm_qos_class]->default_value;
 		else
 			dep->value = value;
 		dep->name = kstrdup(name, GFP_KERNEL);
@@ -215,7 +226,7 @@ int pm_qos_add_requirement(int pm_qos_cl
 
 		spin_lock_irqsave(&pm_qos_lock, flags);
 		list_add(&dep->list,
-			&pm_qos_array[pm_qos_class].requirements.list);
+			&pm_qos_array[pm_qos_class]->requirements.list);
 		update_target(pm_qos_class);
 		spin_unlock_irqrestore(&pm_qos_lock, flags);
 
@@ -247,11 +258,11 @@ int pm_qos_update_requirement(int pm_qos
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
 	list_for_each_entry(node,
-		&pm_qos_array[pm_qos_class].requirements.list, list) {
+		&pm_qos_array[pm_qos_class]->requirements.list, list) {
 		if (strcmp(node->name, name) == 0) {
 			if (new_value == PM_QOS_DEFAULT_VALUE)
 				node->value =
-				pm_qos_array[pm_qos_class].default_value;
+				pm_qos_array[pm_qos_class]->default_value;
 			else
 				node->value = new_value;
 			pending_update = 1;
@@ -283,7 +294,7 @@ void pm_qos_remove_requirement(int pm_qo
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
 	list_for_each_entry(node,
-		&pm_qos_array[pm_qos_class].requirements.list, list) {
+		&pm_qos_array[pm_qos_class]->requirements.list, list) {
 		if (strcmp(node->name, name) == 0) {
 			kfree(node->name);
 			list_del(&node->list);
@@ -312,8 +323,8 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirem
 	int retval;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	retval = srcu_notifier_chain_register(
-			&pm_qos_array[pm_qos_class].notifiers, notifier);
+	retval = blocking_notifier_chain_register(
+			pm_qos_array[pm_qos_class]->notifiers, notifier);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
@@ -334,8 +345,8 @@ int pm_qos_remove_notifier(int pm_qos_cl
 	int retval;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	retval = srcu_notifier_chain_unregister(
-			&pm_qos_array[pm_qos_class].notifiers, notifier);
+	retval = blocking_notifier_chain_unregister(
+			pm_qos_array[pm_qos_class]->notifiers, notifier);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
@@ -395,18 +406,18 @@ static ssize_t pm_qos_power_write(struct
 static int __init pm_qos_power_init(void)
 {
 	int ret = 0;
-	ret = new_latency_qos(PM_QOS_CPU_DMA_LATENCY, "cpu_dma_latency");
+
+	ret = register_pm_qos_misc(&cpu_dma_pm_qos);
 	if (ret < 0) {
 		printk(KERN_ERR "pm_qos_param: cpu_dma_latency setup failed\n");
 		return ret;
 	}
-	ret = new_latency_qos(PM_QOS_NETWORK_LATENCY, "network_latency");
+	ret = register_pm_qos_misc(&network_lat_pm_qos);
 	if (ret < 0) {
 		printk(KERN_ERR "pm_qos_param: network_latency setup failed\n");
 		return ret;
 	}
-	ret = new_throughput_qos(PM_QOS_NETWORK_THROUGHPUT,
-			"network_throughput");
+	ret = register_pm_qos_misc(&network_throughput_pm_qos);
 	if (ret < 0)
 		printk(KERN_ERR
 			"pm_qos_param: network_throughput setup failed\n");
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
pm-qos-remove-locks-around-blocking-notifier.patch
latencyc-use-qos-infrastructure.patch
intel-iommu-pmen-support.patch
intel-iommu-pmen-support-fix.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
