From: akpm@linux-foundation.org
Subject: - cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:33 -0700
Message-ID: <200709202117.l8KLHXsN003090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbXITV3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, ego@in.ibm.com, hpa@zytor.com, jbeulich@novell.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: cpuid: fix cpu hotplug error handling
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpu hotplug: cpuid: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

Do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpuid.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN arch/i386/kernel/cpuid.c~cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling
+++ a/arch/i386/kernel/cpuid.c
@@ -136,15 +136,18 @@ static const struct file_operations cpui
 	.open = cpuid_open,
 };
 
-static int __cpuinit cpuid_device_create(int i)
+static int cpuid_device_create(int cpu)
 {
-	int err = 0;
 	struct device *dev;
 
-	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, i), "cpu%d",i);
-	if (IS_ERR(dev))
-		err = PTR_ERR(dev);
-	return err;
+	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu),
+			    "cpu%d", cpu);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static void cpuid_device_destroy(int cpu)
+{
+	device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
 }
 
 static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
@@ -152,18 +155,21 @@ static int __cpuinit cpuid_class_cpu_cal
 					      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		cpuid_device_create(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = cpuid_device_create(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		cpuid_device_destroy(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata cpuid_class_cpu_notifier =
@@ -200,7 +206,7 @@ static int __init cpuid_init(void)
 out_class:
 	i = 0;
 	for_each_online_cpu(i) {
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, i));
+		cpuid_device_destroy(i);
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
@@ -214,7 +220,7 @@ static void __exit cpuid_exit(void)
 	int cpu = 0;
 
 	for_each_online_cpu(cpu)
-		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
 	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
