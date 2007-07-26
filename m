From: akpm@linux-foundation.org
Subject: + cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:34 -0700
Message-ID: <200707262051.l6QKpYbG020297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935087AbXGZUvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ashok.raj@intel.com, ego@in.ibm.com, oleg@tv-sign.ru


The patch titled
     cpu hotplug: intel_cacheinfo: fix cpu hotplug error handling
has been added to the -mm tree.  Its filename is
     cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: intel_cacheinfo: fix cpu hotplug error handling
From: Akinobu Mita <akinobu.mita@gmail.com>

- Fix resource leakage in error case within detect_cache_attributes()

- Don't register hotcpu notifier when cache_add_dev() returns error

- Introduce cache_dev_map cpumask to track whether cache interface for
  CPU is successfully added by cache_add_dev() or not.

  cache_add_dev() may fail with out of memory error. In order to
  avoid cache_remove_dev() with that uninitialized cache interface when
  CPU_DEAD event is delivered we need to have the cache_dev_map cpumask.

  (We cannot change cache_add_dev() from CPU_ONLINE event handler
  to CPU_UP_PREPARE event handler. Because cache_add_dev() needs
  to do cpuid and store the results with its CPU online.)

Cc: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |   64 ++++++++++++++++-------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -499,6 +499,11 @@ static void __init cache_remove_shared_c
 
 static void free_cache_attributes(unsigned int cpu)
 {
+	int i;
+
+	for (i = 0; i < num_cache_leaves; i++)
+		cache_remove_shared_cpu_map(cpu, i);
+
 	kfree(cpuid4_info[cpu]);
 	cpuid4_info[cpu] = NULL;
 }
@@ -506,8 +511,8 @@ static void free_cache_attributes(unsign
 static int __cpuinit detect_cache_attributes(unsigned int cpu)
 {
 	struct _cpuid4_info	*this_leaf;
-	unsigned long 		j;
-	int 			retval;
+	unsigned long		j;
+	int			retval;
 	cpumask_t		oldmask;
 
 	if (num_cache_leaves == 0)
@@ -524,19 +529,26 @@ static int __cpuinit detect_cache_attrib
 		goto out;
 
 	/* Do cpuid and store the results */
-	retval = 0;
 	for (j = 0; j < num_cache_leaves; j++) {
 		this_leaf = CPUID4_INFO_IDX(cpu, j);
 		retval = cpuid4_cache_lookup(j, this_leaf);
-		if (unlikely(retval < 0))
+		if (unlikely(retval < 0)) {
+			int i;
+
+			for (i = 0; i < j; i++)
+				cache_remove_shared_cpu_map(cpu, i);
 			break;
+		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
 	set_cpus_allowed(current, oldmask);
 
 out:
-	if (retval)
-		free_cache_attributes(cpu);
+	if (retval) {
+		kfree(cpuid4_info[cpu]);
+		cpuid4_info[cpu] = NULL;
+	}
+
 	return retval;
 }
 
@@ -680,13 +692,14 @@ static void cpuid4_cache_sysfs_exit(unsi
 
 static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
 {
+	int err;
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
 
-	detect_cache_attributes(cpu);
-	if (cpuid4_info[cpu] == NULL)
-		return -ENOENT;
+	err = detect_cache_attributes(cpu);
+	if (err)
+		return err;
 
 	/* Allocate all required memory */
 	cache_kobject[cpu] = kzalloc(sizeof(struct kobject), GFP_KERNEL);
@@ -705,13 +718,15 @@ err_out:
 	return -ENOMEM;
 }
 
+static cpumask_t cache_dev_map = CPU_MASK_NONE;
+
 /* Add/Remove cache interface for CPU device */
 static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
-	int retval = 0;
+	int retval;
 
 	retval = cpuid4_cache_sysfs_init(cpu);
 	if (unlikely(retval < 0))
@@ -721,6 +736,10 @@ static int __cpuinit cache_add_dev(struc
 	kobject_set_name(cache_kobject[cpu], "%s", "cache");
 	cache_kobject[cpu]->ktype = &ktype_percpu_entry;
 	retval = kobject_register(cache_kobject[cpu]);
+	if (retval < 0) {
+		cpuid4_cache_sysfs_exit(cpu);
+		return retval;
+	}
 
 	for (i = 0; i < num_cache_leaves; i++) {
 		this_object = INDEX_KOBJECT_PTR(cpu,i);
@@ -740,6 +759,9 @@ static int __cpuinit cache_add_dev(struc
 			break;
 		}
 	}
+	if (!retval)
+		cpu_set(cpu, cache_dev_map);
+
 	return retval;
 }
 
@@ -748,13 +770,14 @@ static void __cpuinit cache_remove_dev(s
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
 
-	for (i = 0; i < num_cache_leaves; i++) {
-		cache_remove_shared_cpu_map(cpu, i);
+	if (!cpu_isset(cpu, cache_dev_map))
+		return;
+	cpu_clear(cpu, cache_dev_map);
+
+	for (i = 0; i < num_cache_leaves; i++)
 		kobject_unregister(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
-	}
 	kobject_unregister(cache_kobject[cpu]);
 	cpuid4_cache_sysfs_exit(cpu);
-	return;
 }
 
 static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
@@ -779,7 +802,7 @@ static int __cpuinit cacheinfo_cpu_callb
 
 static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
 {
-    .notifier_call = cacheinfo_cpu_callback,
+	.notifier_call = cacheinfo_cpu_callback,
 };
 
 static int __cpuinit cache_sysfs_init(void)
@@ -789,12 +812,15 @@ static int __cpuinit cache_sysfs_init(vo
 	if (num_cache_leaves == 0)
 		return 0;
 
-	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
-
 	for_each_online_cpu(i) {
-		cacheinfo_cpu_callback(&cacheinfo_cpu_notifier, CPU_ONLINE,
-			(void *)(long)i);
+		int err;
+		struct sys_device *sys_dev = get_cpu_sysdev(i);
+
+		err = cache_add_dev(sys_dev);
+		if (err)
+			return err;
 	}
+	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
