From: akpm@linux-foundation.org
Subject: - fix-microcode-related-suspend-problem.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:04:01 -0700
Message-ID: <200704022304.l32N41gD011952@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966017AbXDBXHq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, bunk@stusta.de, maximlevitsky@gmail.com, pavel@ucw.cz, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Fix microcode-related suspend problem
has been removed from the -mm tree.  Its filename was
     fix-microcode-related-suspend-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix microcode-related suspend problem
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix the regression resulting from the recent change of suspend code
ordering that causes systems based on Intel x86 CPUs using the microcode
driver to hang during the resume.

The problem occurs since the microcode driver uses request_firmware() in
its CPU hotplug notifier, which is called after tasks has been frozen and
hangs.  It can be fixed by telling the microcode driver to use the
microcode stored in memory during the resume instead of trying to load it
from disk.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Adrian Bunk <bunk@stusta.de>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Maxim <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/microcode.c |   71 +++++++++++++++++++++++++++++++--
 include/linux/cpu.h          |    4 +
 kernel/cpu.c                 |   32 +++++++-------
 3 files changed, 87 insertions(+), 20 deletions(-)

diff -puN arch/i386/kernel/microcode.c~fix-microcode-related-suspend-problem arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~fix-microcode-related-suspend-problem
+++ a/arch/i386/kernel/microcode.c
@@ -567,6 +567,53 @@ static int cpu_request_microcode(int cpu
 	return error;
 }
 
+static int apply_microcode_on_cpu(int cpu)
+{
+	struct cpuinfo_x86 *c = cpu_data + cpu;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	cpumask_t old;
+	unsigned int val[2];
+	int err = 0;
+
+	if (!uci->mc)
+		return -EINVAL;
+
+	old = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+
+	/* Check if the microcode we have in memory matches the CPU */
+	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
+	    cpu_has(c, X86_FEATURE_IA64) || uci->sig != cpuid_eax(0x00000001))
+		err = -EINVAL;
+
+	if (!err && ((c->x86_model >= 5) || (c->x86 > 6))) {
+		/* get processor flags from MSR 0x17 */
+		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
+		if (uci->pf != (1 << ((val[1] >> 18) & 7)))
+			err = -EINVAL;
+	}
+
+	if (!err) {
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		/* see notes above for revision 1.07.  Apparent chip bug */
+		sync_core();
+		/* get the current revision from MSR 0x8B */
+		rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+		if (uci->rev != val[1])
+			err = -EINVAL;
+	}
+
+	if (!err)
+		apply_microcode(cpu);
+	else
+		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
+			" sig=0x%x, pf=0x%x, rev=0x%x\n",
+			cpu, uci->sig, uci->pf, uci->rev);
+
+	set_cpus_allowed(current, old);
+	return err;
+}
+
 static void microcode_init_cpu(int cpu)
 {
 	cpumask_t old;
@@ -577,7 +624,8 @@ static void microcode_init_cpu(int cpu)
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING)
+	if (uci->valid && system_state == SYSTEM_RUNNING &&
+	    !suspend_cpu_hotplug)
 		cpu_request_microcode(cpu);
 	mutex_unlock(&microcode_mutex);
 	set_cpus_allowed(current, old);
@@ -663,13 +711,24 @@ static int mc_sysdev_add(struct sys_devi
 		return 0;
 
 	pr_debug("Microcode:CPU %d added\n", cpu);
-	memset(uci, 0, sizeof(*uci));
+	/* If suspend_cpu_hotplug is set, the system is resuming and we should
+	 * use the data from before the suspend.
+	 */
+	if (suspend_cpu_hotplug) {
+		err = apply_microcode_on_cpu(cpu);
+		if (err)
+			microcode_fini_cpu(cpu);
+	}
+	if (!uci->valid)
+		memset(uci, 0, sizeof(*uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu);
+	if (!uci->valid)
+		microcode_init_cpu(cpu);
+
 	return 0;
 }
 
@@ -680,7 +739,11 @@ static int mc_sysdev_remove(struct sys_d
 	if (!cpu_online(cpu))
 		return 0;
 	pr_debug("Microcode:CPU %d removed\n", cpu);
-	microcode_fini_cpu(cpu);
+	/* If suspend_cpu_hotplug is set, the system is suspending and we should
+	 * keep the microcode in memory for the resume.
+	 */
+	if (!suspend_cpu_hotplug)
+		microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
 }
diff -puN include/linux/cpu.h~fix-microcode-related-suspend-problem include/linux/cpu.h
--- a/include/linux/cpu.h~fix-microcode-related-suspend-problem
+++ a/include/linux/cpu.h
@@ -127,9 +127,13 @@ static inline int cpu_is_offline(int cpu
 #endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_SUSPEND_SMP
+extern int suspend_cpu_hotplug;
+
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
 #else
+#define suspend_cpu_hotplug	0
+
 static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif
diff -puN kernel/cpu.c~fix-microcode-related-suspend-problem kernel/cpu.c
--- a/kernel/cpu.c~fix-microcode-related-suspend-problem
+++ a/kernel/cpu.c
@@ -254,6 +254,12 @@ int __cpuinit cpu_up(unsigned int cpu)
 }
 
 #ifdef CONFIG_SUSPEND_SMP
+/* Needed to prevent the microcode driver from requesting firmware in its CPU
+ * hotplug notifier during the suspend/resume.
+ */
+int suspend_cpu_hotplug;
+EXPORT_SYMBOL(suspend_cpu_hotplug);
+
 static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
@@ -261,16 +267,8 @@ int disable_nonboot_cpus(void)
 	int cpu, first_cpu, error = 0;
 
 	mutex_lock(&cpu_add_remove_lock);
-	first_cpu = first_cpu(cpu_present_map);
-	if (!cpu_online(first_cpu)) {
-		error = _cpu_up(first_cpu);
-		if (error) {
-			printk(KERN_ERR "Could not bring CPU%d up.\n",
-				first_cpu);
-			goto out;
-		}
-	}
-
+	suspend_cpu_hotplug = 1;
+	first_cpu = first_cpu(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
@@ -296,7 +294,7 @@ int disable_nonboot_cpus(void)
 	} else {
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
-out:
+	suspend_cpu_hotplug = 0;
 	mutex_unlock(&cpu_add_remove_lock);
 	return error;
 }
@@ -308,20 +306,22 @@ void enable_nonboot_cpus(void)
 	/* Allow everyone to use the CPU hotplug again */
 	mutex_lock(&cpu_add_remove_lock);
 	cpu_hotplug_disabled = 0;
-	mutex_unlock(&cpu_add_remove_lock);
 	if (cpus_empty(frozen_cpus))
-		return;
+		goto out;
 
+	suspend_cpu_hotplug = 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
-		error = cpu_up(cpu);
+		error = _cpu_up(cpu);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
 			continue;
 		}
-		printk(KERN_WARNING "Error taking CPU%d up: %d\n",
-			cpu, error);
+		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
 	cpus_clear(frozen_cpus);
+	suspend_cpu_hotplug = 0;
+out:
+	mutex_unlock(&cpu_add_remove_lock);
 }
 #endif
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
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
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
