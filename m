From: akpm@linux-foundation.org
Subject: - cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:31 -0700
Message-ID: <200805021943.m42JhVOZ011297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508AbYEBToL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ashok.raj@intel.com, gregkh@suse.de, kay.sievers@vrfy.org, suresh.b.siddha@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: change cpu_sys_devices from array to per_cpu variable
has been removed from the -mm tree.  Its filename was
     cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: change cpu_sys_devices from array to per_cpu variable
From: Mike Travis <travis@sgi.com>

Change cpu_sys_devices from array to per_cpu variable in drivers/base/cpu.c.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/base/cpu.c~cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable drivers/base/cpu.c
--- a/drivers/base/cpu.c~cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable
+++ a/drivers/base/cpu.c
@@ -18,7 +18,7 @@ struct sysdev_class cpu_sysdev_class = {
 };
 EXPORT_SYMBOL(cpu_sysdev_class);
 
-static struct sys_device *cpu_sys_devices[NR_CPUS];
+static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
 static ssize_t show_online(struct sys_device *dev, char *buf)
@@ -68,7 +68,7 @@ void unregister_cpu(struct cpu *cpu)
 	sysdev_remove_file(&cpu->sysdev, &attr_online);
 
 	sysdev_unregister(&cpu->sysdev);
-	cpu_sys_devices[logical_cpu] = NULL;
+	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -167,7 +167,7 @@ int __cpuinit register_cpu(struct cpu *c
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
 	if (!error)
-		cpu_sys_devices[num] = &cpu->sysdev;
+		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
@@ -180,8 +180,8 @@ int __cpuinit register_cpu(struct cpu *c
 
 struct sys_device *get_cpu_sysdev(unsigned cpu)
 {
-	if (cpu < NR_CPUS)
-		return cpu_sys_devices[cpu];
+	if (cpu < nr_cpu_ids && cpu_possible(cpu))
+		return per_cpu(cpu_sys_devices, cpu);
 	else
 		return NULL;
 }
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
show_schedstat-fix-memleak.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch

