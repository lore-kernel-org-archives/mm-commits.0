From: akpm@linux-foundation.org
Subject: - cpu_idle-prevents-resuming-from-str.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:22 -0700
Message-ID: <200704302144.l3ULiM4k015592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031032AbXD3Voz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     CPU_IDLE prevents resuming from STR
has been removed from the -mm tree.  Its filename was
     cpu_idle-prevents-resuming-from-str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPU_IDLE prevents resuming from STR
From: Shaohua Li <shaohua.li@intel.com>

On Mon, 2007-04-16 at 22:50 -0400, Joshua Wise wrote:
> On Mon, 16 Apr 2007, Shaohua Li wrote:
> > On Sat, 2007-04-14 at 01:45 +0200, Mattia Dongili wrote:
> >> ...
> > please check if the patch at
> > http://marc.info/?l=linux-acpi&m=117523651630038&w=2 fixed the issue
>
> I have the same system as Mattia, and when I applied this patch and turned
> CPU_IDLE back on, I got a panic on boot. Unfortunately, the EIP scrolled off
> screen, so I can't get a line number.
>
> (I had the same STR breakage as him; STR did not work with CPU_IDLE turned
> on, and it did work with CPU_IDLE turned off.)
>
> I'm running +rc6+mm(April 11) on a Sony VAIO SZ.
Looks there is init order issue of sysfs files. The new refreshed patch
should fix your bug.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    2 -
 drivers/cpuidle/cpuidle.c     |   29 ++++++++++++----
 drivers/cpuidle/sysfs.c       |   57 +++++++++++++++++++++++++-------
 include/linux/cpuidle.h       |   13 ++++---
 4 files changed, 76 insertions(+), 25 deletions(-)

diff -puN drivers/acpi/processor_idle.c~cpu_idle-prevents-resuming-from-str drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~cpu_idle-prevents-resuming-from-str
+++ a/drivers/acpi/processor_idle.c
@@ -616,7 +616,7 @@ int acpi_processor_cst_has_changed(struc
 		return -ENODEV;
 
 	acpi_processor_get_power_info(pr);
-	return cpuidle_force_redetect(&per_cpu(cpuidle_devices, pr->id));
+	return cpuidle_force_redetect(per_cpu(cpuidle_devices, pr->id));
 }
 
 /* proc interface */
diff -puN drivers/cpuidle/cpuidle.c~cpu_idle-prevents-resuming-from-str drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpu_idle-prevents-resuming-from-str
+++ a/drivers/cpuidle/cpuidle.c
@@ -18,7 +18,7 @@
 
 #include "cpuidle.h"
 
-DEFINE_PER_CPU(struct cpuidle_device, cpuidle_devices);
+DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 EXPORT_PER_CPU_SYMBOL_GPL(cpuidle_devices);
 
 DEFINE_MUTEX(cpuidle_lock);
@@ -34,13 +34,13 @@ static void (*pm_idle_old)(void);
  */
 static void cpuidle_idle_call(void)
 {
-	struct cpuidle_device *dev = &__get_cpu_var(cpuidle_devices);
+	struct cpuidle_device *dev = __get_cpu_var(cpuidle_devices);
 
 	struct cpuidle_state *target_state;
 	int next_state;
 
 	/* check if the device is ready */
-	if (dev->status != CPUIDLE_STATUS_DOIDLE) {
+	if (!dev || dev->status != CPUIDLE_STATUS_DOIDLE) {
 		if (pm_idle_old)
 			pm_idle_old();
 		else
@@ -119,19 +119,32 @@ static int cpuidle_add_device(struct sys
 	int cpu = sys_dev->id;
 	struct cpuidle_device *dev;
 
-	dev = &per_cpu(cpuidle_devices, cpu);
+	dev = per_cpu(cpuidle_devices, cpu);
 
-	dev->cpu = cpu;
 	mutex_lock(&cpuidle_lock);
 	if (cpu_is_offline(cpu)) {
 		mutex_unlock(&cpuidle_lock);
 		return 0;
 	}
 
+	if (!dev) {
+		dev = kzalloc(sizeof(struct cpuidle_device), GFP_KERNEL);
+		if (!dev) {
+			mutex_unlock(&cpuidle_lock);
+			return -ENOMEM;
+		}
+		init_completion(&dev->kobj_unregister);
+		per_cpu(cpuidle_devices, cpu) = dev;
+	}
+	dev->cpu = cpu;
+
 	if (dev->status & CPUIDLE_STATUS_DETECTED) {
 		mutex_unlock(&cpuidle_lock);
 		return 0;
 	}
+
+	cpuidle_add_sysfs(sys_dev);
+
 	if (cpuidle_curr_driver) {
 		if (cpuidle_attach_driver(dev))
 			goto err_ret;
@@ -148,7 +161,6 @@ static int cpuidle_add_device(struct sys
 		cpuidle_install_idle_handler();
 
 	list_add(&dev->device_list, &cpuidle_detected_devices);
-	cpuidle_add_sysfs(sys_dev);
 	dev->status |= CPUIDLE_STATUS_DETECTED;
 
 err_ret:
@@ -167,7 +179,7 @@ static int __cpuidle_remove_device(struc
 {
 	struct cpuidle_device *dev;
 
-	dev = &per_cpu(cpuidle_devices, sys_dev->id);
+	dev = per_cpu(cpuidle_devices, sys_dev->id);
 
 	if (!(dev->status & CPUIDLE_STATUS_DETECTED)) {
 		return 0;
@@ -180,6 +192,9 @@ static int __cpuidle_remove_device(struc
 		cpuidle_detach_driver(dev);
 	cpuidle_remove_sysfs(sys_dev);
 	list_del(&dev->device_list);
+	wait_for_completion(&dev->kobj_unregister);
+	per_cpu(cpuidle_devices, sys_dev->id) = NULL;
+	kfree(dev);
 
 	return 0;
 }
diff -puN drivers/cpuidle/sysfs.c~cpu_idle-prevents-resuming-from-str drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpu_idle-prevents-resuming-from-str
+++ a/drivers/cpuidle/sysfs.c
@@ -210,8 +210,16 @@ static struct sysfs_ops cpuidle_sysfs_op
 	.store = cpuidle_store,
 };
 
+static void cpuidle_sysfs_release(struct kobject *kobj)
+{
+	struct cpuidle_device *dev = kobj_to_cpuidledev(kobj);
+
+	complete(&dev->kobj_unregister);
+}
+
 static struct kobj_type ktype_cpuidle = {
 	.sysfs_ops = &cpuidle_sysfs_ops,
+	.release = cpuidle_sysfs_release,
 };
 
 struct cpuidle_state_attr {
@@ -246,7 +254,8 @@ static struct attribute *cpuidle_state_d
 	NULL
 };
 
-#define kobj_to_state(k) container_of(k, struct cpuidle_state, kobj)
+#define kobj_to_state_obj(k) container_of(k, struct cpuidle_state_kobj, kobj)
+#define kobj_to_state(k) (kobj_to_state_obj(k)->state)
 #define attr_to_stateattr(a) container_of(a, struct cpuidle_state_attr, attr)
 static ssize_t cpuidle_state_show(struct kobject * kobj,
 	struct attribute * attr ,char * buf)
@@ -265,11 +274,27 @@ static struct sysfs_ops cpuidle_state_sy
 	.show = cpuidle_state_show,
 };
 
+static void cpuidle_state_sysfs_release(struct kobject *kobj)
+{
+	struct cpuidle_state_kobj *state_obj = kobj_to_state_obj(kobj);
+
+	complete(&state_obj->kobj_unregister);
+}
+
 static struct kobj_type ktype_state_cpuidle = {
 	.sysfs_ops = &cpuidle_state_sysfs_ops,
 	.default_attrs = cpuidle_state_default_attrs,
+	.release = cpuidle_state_sysfs_release,
 };
 
+static void inline cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
+{
+	kobject_unregister(&device->kobjs[i]->kobj);
+	wait_for_completion(&device->kobjs[i]->kobj_unregister);
+	kfree(device->kobjs[i]);
+	device->kobjs[i] = NULL;
+}
+
 /**
  * cpuidle_add_driver_sysfs - adds driver-specific sysfs attributes
  * @device: the target device
@@ -277,24 +302,32 @@ static struct kobj_type ktype_state_cpui
 int cpuidle_add_driver_sysfs(struct cpuidle_device *device)
 {
 	int i, ret;
-	struct cpuidle_state *state;
+	struct cpuidle_state_kobj *kobj;
 
 	/* state statistics */
 	for (i = 0; i < device->state_count; i++) {
-		state = &device->states[i];
-		state->kobj.parent = &device->kobj;
-		state->kobj.ktype = &ktype_state_cpuidle;
-		kobject_set_name(&state->kobj, "state%d", i);
-		ret = kobject_register(&state->kobj);
-		if (ret)
+		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
+		if (!kobj)
+			goto error_state;
+		kobj->state = &device->states[i];
+		init_completion(&kobj->kobj_unregister);
+
+		kobj->kobj.parent = &device->kobj;
+		kobj->kobj.ktype = &ktype_state_cpuidle;
+		kobject_set_name(&kobj->kobj, "state%d", i);
+		ret = kobject_register(&kobj->kobj);
+		if (ret) {
+			kfree(kobj);
 			goto error_state;
+		}
+		device->kobjs[i] = kobj;
 	}
 
 	return 0;
 
 error_state:
 	for (i = i - 1; i >= 0; i--)
-		kobject_unregister(&device->states[i].kobj);
+		cpuidle_free_state_kobj(device, i);
 	return ret;
 }
 
@@ -307,7 +340,7 @@ void cpuidle_remove_driver_sysfs(struct 
 	int i;
 
 	for (i = 0; i < device->state_count; i++)
-		kobject_unregister(&device->states[i].kobj);
+		cpuidle_free_state_kobj(device, i);
 }
 
 /**
@@ -319,7 +352,7 @@ int cpuidle_add_sysfs(struct sys_device 
 	int cpu = sysdev->id;
 	struct cpuidle_device *dev;
 
-	dev = &per_cpu(cpuidle_devices, cpu);
+	dev = per_cpu(cpuidle_devices, cpu);
 	dev->kobj.parent = &sysdev->kobj;
 	dev->kobj.ktype = &ktype_cpuidle;
 	kobject_set_name(&dev->kobj, "%s", "cpuidle");
@@ -335,6 +368,6 @@ void cpuidle_remove_sysfs(struct sys_dev
 	int cpu = sysdev->id;
 	struct cpuidle_device *dev;
 
-	dev = &per_cpu(cpuidle_devices, cpu);
+	dev = per_cpu(cpuidle_devices, cpu);
 	kobject_unregister(&dev->kobj);
 }
diff -puN include/linux/cpuidle.h~cpu_idle-prevents-resuming-from-str include/linux/cpuidle.h
--- a/include/linux/cpuidle.h~cpu_idle-prevents-resuming-from-str
+++ a/include/linux/cpuidle.h
@@ -41,8 +41,6 @@ struct cpuidle_state {
 
 	int (*enter)	(struct cpuidle_device *dev,
 			 struct cpuidle_state *state);
-
-	struct kobject	kobj;
 };
 
 /* Idle State Flags */
@@ -74,6 +72,12 @@ cpuidle_set_statedata(struct cpuidle_sta
 	state->driver_data = data;
 }
 
+struct cpuidle_state_kobj {
+	struct cpuidle_state *state;
+	struct completion kobj_unregister;
+	struct kobject kobj;
+};
+
 struct cpuidle_device {
 	unsigned int		status;
 	int			cpu;
@@ -81,6 +85,7 @@ struct cpuidle_device {
 	int			last_residency;
 	int			state_count;
 	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
+	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_state	*last_state;
 
 	struct list_head 	device_list;
@@ -89,9 +94,7 @@ struct cpuidle_device {
 	void			*governor_data;
 };
 
-#define to_cpuidle_device(n) container_of(n, struct cpuidle_device, kobj);
-
-DECLARE_PER_CPU(struct cpuidle_device, cpuidle_devices);
+DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 
 /* Device Status Flags */
 #define CPUIDLE_STATUS_DETECTED		 (0x1)
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
git-acpi.patch
