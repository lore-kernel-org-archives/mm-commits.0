From: akpm@linux-foundation.org
Subject: - cpu-hotplug-topology-remove-topology_dev_map.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:59 -0700
Message-ID: <200710190341.l9J3fx54012859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966396AbXJSD4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ego@in.ibm.com, gregkh@suse.de, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: topology: remove topology_dev_map
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-topology-remove-topology_dev_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-x86.patch
