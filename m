From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-remove-sysfs-file-of-node.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:23 -0800
Message-ID: <20130225205023.D0D915A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:44730 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:25 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so347345ves.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove sysfs file of node
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-sysfs-file-of-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: remove sysfs file of node

Introduce a new function try_offline_node() to remove sysfs file of node
when all memory sections of this node are removed.  If some memory
sections of this node are not removed, this function does nothing.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    8 +++-
 include/linux/memory_hotplug.h |    2 -
 mm/memory_hotplug.c            |   58 +++++++++++++++++++++++++++++--
 3 files changed, 63 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~memory-hotplug-remove-sysfs-file-of-node drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~memory-hotplug-remove-sysfs-file-of-node
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -280,9 +280,11 @@ static int acpi_memory_enable_device(str
 
 static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 {
-	int result = 0;
+	int result = 0, nid;
 	struct acpi_memory_info *info, *n;
 
+	nid = acpi_get_node(mem_device->device->handle);
+
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (info->failed)
 			/* The kernel does not use this memory block */
@@ -295,7 +297,9 @@ static int acpi_memory_remove_memory(str
 			 */
 			return -EBUSY;
 
-		result = remove_memory(info->start_addr, info->length);
+		if (nid < 0)
+			nid = memory_add_physaddr_to_nid(info->start_addr);
+		result = remove_memory(nid, info->start_addr, info->length);
 		if (result)
 			return result;
 
diff -puN include/linux/memory_hotplug.h~memory-hotplug-remove-sysfs-file-of-node include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-remove-sysfs-file-of-node
+++ a/include/linux/memory_hotplug.h
@@ -248,7 +248,7 @@ extern int arch_add_memory(int nid, u64 
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int offline_memory_block(struct memory_block *mem);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern int remove_memory(u64 start, u64 size);
+extern int remove_memory(int nid, u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
diff -puN mm/memory_hotplug.c~memory-hotplug-remove-sysfs-file-of-node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-remove-sysfs-file-of-node
+++ a/mm/memory_hotplug.c
@@ -29,6 +29,7 @@
 #include <linux/suspend.h>
 #include <linux/mm_inline.h>
 #include <linux/firmware-map.h>
+#include <linux/stop_machine.h>
 
 #include <asm/tlbflush.h>
 
@@ -1679,7 +1680,58 @@ static int is_memblock_offlined_cb(struc
 	return ret;
 }
 
-int __ref remove_memory(u64 start, u64 size)
+static int check_cpu_on_node(void *data)
+{
+	struct pglist_data *pgdat = data;
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		if (cpu_to_node(cpu) == pgdat->node_id)
+			/*
+			 * the cpu on this node isn't removed, and we can't
+			 * offline this node.
+			 */
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+/* offline the node if all memory sections of this node are removed */
+static void try_offline_node(int nid)
+{
+	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
+	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(pfn);
+
+		if (!present_section_nr(section_nr))
+			continue;
+
+		if (pfn_to_nid(pfn) != nid)
+			continue;
+
+		/*
+		 * some memory sections of this node are not removed, and we
+		 * can't offline node now.
+		 */
+		return;
+	}
+
+	if (stop_machine(check_cpu_on_node, NODE_DATA(nid), NULL))
+		return;
+
+	/*
+	 * all memory/cpu of this node are removed, we can offline this
+	 * node now.
+	 */
+	node_set_offline(nid);
+	unregister_one_node(nid);
+}
+
+int __ref remove_memory(int nid, u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
 	int ret = 0;
@@ -1734,6 +1786,8 @@ repeat:
 
 	arch_remove_memory(start, size);
 
+	try_offline_node(nid);
+
 	unlock_memory_hotplug();
 
 	return 0;
@@ -1743,7 +1797,7 @@ int offline_pages(unsigned long start_pf
 {
 	return -EINVAL;
 }
-int remove_memory(u64 start, u64 size)
+int remove_memory(int nid, u64 start, u64 size)
 {
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

