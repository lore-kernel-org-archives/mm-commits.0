From: akpm@linux-foundation.org
Subject: [merged]
 mm-hotplug-remove-stop_machine-from-try_offline_node.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:57 -0700
Message-ID: <5232197d.si8c5IN97UyMhUgU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3ILTn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, rafael.j.wysocki@intel.com, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, toshi.kani@hp.com

Subject: [merged] mm-hotplug-remove-stop_machine-from-try_offline_node.patch removed from -mm tree
To: toshi.kani@hp.com,isimatu.yasuaki@jp.fujitsu.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,rafael.j.wysocki@intel.com,tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:57 -0700


The patch titled
     Subject: mm/hotplug: remove stop_machine() from try_offline_node()
has been removed from the -mm tree.  Its filename was
     mm-hotplug-remove-stop_machine-from-try_offline_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm/hotplug: remove stop_machine() from try_offline_node()

lock_device_hotplug() serializes hotplug & online/offline operations.  The
lock is held in common sysfs online/offline interfaces and ACPI hotplug
code paths.

And here are the code paths:

- CPU & Mem online/offline via sysfs online
	store_online()->lock_device_hotplug()

- Mem online via sysfs state:
	store_mem_state()->lock_device_hotplug()

- ACPI CPU & Mem hot-add:
	acpi_scan_bus_device_check()->lock_device_hotplug()

- ACPI CPU & Mem hot-delete:
	acpi_scan_hot_remove()->lock_device_hotplug()

try_offline_node() off-lines a node if all memory sections and cpus are
removed on the node.  It is called from acpi_processor_remove() and
acpi_memory_remove_memory()->remove_memory() paths, both of which are in
the ACPI hotplug code.

try_offline_node() calls stop_machine() to stop all cpus while checking
all cpu status with the assumption that the caller is not protected from
CPU hotplug or CPU online/offline operations.  However, the caller is
always serialized with lock_device_hotplug().  Also, the code needs to be
properly serialized with a lock, not by stopping all cpus at a random
place with stop_machine().

This patch removes the use of stop_machine() in try_offline_node() and
adds comments to try_offline_node() and remove_memory() that
lock_device_hotplug() is required.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-remove-stop_machine-from-try_offline_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-remove-stop_machine-from-try_offline_node
+++ a/mm/memory_hotplug.c
@@ -1695,9 +1695,8 @@ static int is_memblock_offlined_cb(struc
 	return ret;
 }
 
-static int check_cpu_on_node(void *data)
+static int check_cpu_on_node(pg_data_t *pgdat)
 {
-	struct pglist_data *pgdat = data;
 	int cpu;
 
 	for_each_present_cpu(cpu) {
@@ -1712,10 +1711,9 @@ static int check_cpu_on_node(void *data)
 	return 0;
 }
 
-static void unmap_cpu_on_node(void *data)
+static void unmap_cpu_on_node(pg_data_t *pgdat)
 {
 #ifdef CONFIG_ACPI_NUMA
-	struct pglist_data *pgdat = data;
 	int cpu;
 
 	for_each_possible_cpu(cpu)
@@ -1724,10 +1722,11 @@ static void unmap_cpu_on_node(void *data
 #endif
 }
 
-static int check_and_unmap_cpu_on_node(void *data)
+static int check_and_unmap_cpu_on_node(pg_data_t *pgdat)
 {
-	int ret = check_cpu_on_node(data);
+	int ret;
 
+	ret = check_cpu_on_node(pgdat);
 	if (ret)
 		return ret;
 
@@ -1736,11 +1735,18 @@ static int check_and_unmap_cpu_on_node(v
 	 * the cpu_to_node() now.
 	 */
 
-	unmap_cpu_on_node(data);
+	unmap_cpu_on_node(pgdat);
 	return 0;
 }
 
-/* offline the node if all memory sections of this node are removed */
+/**
+ * try_offline_node
+ *
+ * Offline a node if all memory sections and cpus of the node are removed.
+ *
+ * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
+ * and online/offline operations before this call.
+ */
 void try_offline_node(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
@@ -1766,7 +1772,7 @@ void try_offline_node(int nid)
 		return;
 	}
 
-	if (stop_machine(check_and_unmap_cpu_on_node, pgdat, NULL))
+	if (check_and_unmap_cpu_on_node(pgdat))
 		return;
 
 	/*
@@ -1803,6 +1809,13 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
 
+/**
+ * remove_memory
+ *
+ * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
+ * and online/offline operations before this call, as required by
+ * try_offline_node().
+ */
 void __ref remove_memory(int nid, u64 start, u64 size)
 {
 	int ret;
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch

