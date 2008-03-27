From: akpm@linux-foundation.org
Subject: + cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:00:36 -0700
Message-ID: <200803270800.m2R80aJp024712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbYC0IAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:00:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ashok.raj@intel.com, gregkh@suse.de, kay.sievers@vrfy.org, suresh.b.siddha@intel.com, vgoyal@in.ibm.com


The patch titled
     cpu: change cpu_sys_devices from array to per_cpu variable
has been added to the -mm tree.  Its filename is
     cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

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
@@ -122,7 +122,7 @@ int __cpuinit register_cpu(struct cpu *c
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
 	if (!error)
-		cpu_sys_devices[num] = &cpu->sysdev;
+		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
@@ -135,8 +135,8 @@ int __cpuinit register_cpu(struct cpu *c
 
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

git-cpufreq.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpumask-add-cpumask_scnprintf_len-function.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch
sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc.patch

