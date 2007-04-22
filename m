From: akpm@linux-foundation.org
Subject: + microcode-use-suspend-related-cpu-hotplug-notifications.patch added to -mm tree
Date: Sat, 21 Apr 2007 20:06:03 -0700
Message-ID: <200704220306.l3M363gE018371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192AbXDVDGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 23:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ego@in.ibm.com, pavel@ucw.cz


The patch titled
     microcode: use suspend-related CPU hotplug notifications
has been added to the -mm tree.  Its filename is
     microcode-use-suspend-related-cpu-hotplug-notifications.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: microcode: use suspend-related CPU hotplug notifications
From: Rafael J. Wysocki <rjw@sisk.pl>

Make the microcode driver use the suspend-related CPU hotplug notifications
to handle the CPU hotplug events occuring during system-wide suspend and
resume transitions.  Remove the global variable suspend_cpu_hotplug
previously used for this purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/microcode.c |   62 +++++++++++++++++++--------------
 kernel/cpu.c                 |   10 -----
 2 files changed, 36 insertions(+), 36 deletions(-)

diff -puN arch/i386/kernel/microcode.c~microcode-use-suspend-related-cpu-hotplug-notifications arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~microcode-use-suspend-related-cpu-hotplug-notifications
+++ a/arch/i386/kernel/microcode.c
@@ -567,7 +567,7 @@ static int cpu_request_microcode(int cpu
 	return error;
 }
 
-static int apply_microcode_on_cpu(int cpu)
+static int apply_microcode_check_cpu(int cpu)
 {
 	struct cpuinfo_x86 *c = cpu_data + cpu;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -575,8 +575,9 @@ static int apply_microcode_on_cpu(int cp
 	unsigned int val[2];
 	int err = 0;
 
+	/* Check if the microcode is available */
 	if (!uci->mc)
-		return -EINVAL;
+		return 0;
 
 	old = current->cpus_allowed;
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
@@ -614,7 +615,7 @@ static int apply_microcode_on_cpu(int cp
 	return err;
 }
 
-static void microcode_init_cpu(int cpu)
+static void microcode_init_cpu(int cpu, int resume)
 {
 	cpumask_t old;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -624,8 +625,7 @@ static void microcode_init_cpu(int cpu)
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING &&
-	    !suspend_cpu_hotplug)
+	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
 		cpu_request_microcode(cpu);
 	mutex_unlock(&microcode_mutex);
 	set_cpus_allowed(current, old);
@@ -702,7 +702,7 @@ static struct attribute_group mc_attr_gr
 	.name = "microcode",
 };
 
-static int mc_sysdev_add(struct sys_device *sys_dev)
+static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
 {
 	int err, cpu = sys_dev->id;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -711,39 +711,31 @@ static int mc_sysdev_add(struct sys_devi
 		return 0;
 
 	pr_debug("Microcode:CPU %d added\n", cpu);
-	/* If suspend_cpu_hotplug is set, the system is resuming and we should
-	 * use the data from before the suspend.
-	 */
-	if (suspend_cpu_hotplug) {
-		err = apply_microcode_on_cpu(cpu);
-		if (err)
-			microcode_fini_cpu(cpu);
-	}
-	if (!uci->valid)
-		memset(uci, 0, sizeof(*uci));
+	memset(uci, 0, sizeof(*uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	if (!uci->valid)
-		microcode_init_cpu(cpu);
+	microcode_init_cpu(cpu, resume);
 
 	return 0;
 }
 
+static int mc_sysdev_add(struct sys_device *sys_dev)
+{
+	return __mc_sysdev_add(sys_dev, 0);
+}
+
 static int mc_sysdev_remove(struct sys_device *sys_dev)
 {
 	int cpu = sys_dev->id;
 
 	if (!cpu_online(cpu))
 		return 0;
+
 	pr_debug("Microcode:CPU %d removed\n", cpu);
-	/* If suspend_cpu_hotplug is set, the system is suspending and we should
-	 * keep the microcode in memory for the resume.
-	 */
-	if (!suspend_cpu_hotplug)
-		microcode_fini_cpu(cpu);
+	microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
 }
@@ -774,16 +766,34 @@ mc_cpu_callback(struct notifier_block *n
 
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
+	case CPU_UP_CANCELED_FROZEN:
+		/* The CPU refused to come up during a system resume */
+		microcode_fini_cpu(cpu);
+		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		mc_sysdev_add(sys_dev);
 		break;
+	case CPU_ONLINE_FROZEN:
+		/* System-wide resume is in progress, try to apply microcode */
+		if (apply_microcode_check_cpu(cpu)) {
+			/* The application of microcode failed */
+			microcode_fini_cpu(cpu);
+			__mc_sysdev_add(sys_dev, 1);
+			break;
+		}
+	case CPU_DOWN_FAILED_FROZEN:
+		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
+			printk(KERN_ERR "Microcode: Failed to create the sysfs "
+				"group for CPU%d\n", cpu);
+		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		mc_sysdev_remove(sys_dev);
 		break;
+	case CPU_DOWN_PREPARE_FROZEN:
+		/* Suspend is in progress, only remove the interface */
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		break;
 	}
 	return NOTIFY_OK;
 }
diff -puN kernel/cpu.c~microcode-use-suspend-related-cpu-hotplug-notifications kernel/cpu.c
--- a/kernel/cpu.c~microcode-use-suspend-related-cpu-hotplug-notifications
+++ a/kernel/cpu.c
@@ -266,12 +266,6 @@ int __cpuinit cpu_up(unsigned int cpu)
 }
 
 #ifdef CONFIG_SUSPEND_SMP
-/* Needed to prevent the microcode driver from requesting firmware in its CPU
- * hotplug notifier during the suspend/resume.
- */
-int suspend_cpu_hotplug;
-EXPORT_SYMBOL(suspend_cpu_hotplug);
-
 static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
@@ -279,7 +273,6 @@ int disable_nonboot_cpus(void)
 	int cpu, first_cpu, error = 0;
 
 	mutex_lock(&cpu_add_remove_lock);
-	suspend_cpu_hotplug = 1;
 	first_cpu = first_cpu(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
@@ -306,7 +299,6 @@ int disable_nonboot_cpus(void)
 	} else {
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
-	suspend_cpu_hotplug = 0;
 	mutex_unlock(&cpu_add_remove_lock);
 	return error;
 }
@@ -321,7 +313,6 @@ void enable_nonboot_cpus(void)
 	if (cpus_empty(frozen_cpus))
 		goto out;
 
-	suspend_cpu_hotplug = 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
@@ -332,7 +323,6 @@ void enable_nonboot_cpus(void)
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
 	cpus_clear(frozen_cpus);
-	suspend_cpu_hotplug = 0;
 out:
 	mutex_unlock(&cpu_add_remove_lock);
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race.patch
freezer-document-task_lock-in-thaw_process.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
