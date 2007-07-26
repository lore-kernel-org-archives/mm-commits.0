From: akpm@linux-foundation.org
Subject: + cpu-hotplug-topology-remove-topology_dev_map.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:28 -0700
Message-ID: <200707262051.l6QKpSWv020282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934931AbXGZUvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ego@in.ibm.com, gregkh@suse.de, oleg@tv-sign.ru


The patch titled
     cpu hotplug: topology: remove topology_dev_map
has been added to the -mm tree.  Its filename is
     cpu-hotplug-topology-remove-topology_dev_map.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: topology: remove topology_dev_map
From: Akinobu Mita <akinobu.mita@gmail.com>

By previous cpu hotplug notifier change, we don't need to track topology_dev
existence for each cpu by topology_dev_map.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/topology.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/base/topology.c~cpu-hotplug-topology-remove-topology_dev_map drivers/base/topology.c
--- a/drivers/base/topology.c~cpu-hotplug-topology-remove-topology_dev_map
+++ a/drivers/base/topology.c
@@ -94,27 +94,18 @@ static struct attribute_group topology_a
 	.name = "topology"
 };
 
-static cpumask_t topology_dev_map = CPU_MASK_NONE;
-
 /* Add/Remove cpu_topology interface for CPU device */
 static int __cpuinit topology_add_dev(unsigned int cpu)
 {
-	int rc;
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	rc = sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
-	if (!rc)
-		cpu_set(cpu, topology_dev_map);
-	return rc;
+	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
 }
 
 static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	if (!cpu_isset(cpu, topology_dev_map))
-		return;
-	cpu_clear(cpu, topology_dev_map);
 	sysfs_remove_group(&sys_dev->kobj, &topology_attr_group);
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
