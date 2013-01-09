From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-sysfs-file-of-node.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:34:20 -0800
Message-ID: <20130109233420.9FB4E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55900 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:34:22 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so316456vcd.5
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:34:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: remove sysfs file of node
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-sysfs-file-of-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -273,9 +273,11 @@ static int acpi_memory_enable_device(str
 
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
@@ -288,7 +290,9 @@ static int acpi_memory_remove_memory(str
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
@@ -242,7 +242,7 @@ extern int arch_add_memory(int nid, u64 
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
 
@@ -1677,7 +1678,58 @@ static int is_memblock_offlined_cb(struc
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
@@ -1732,6 +1784,8 @@ repeat:
 
 	arch_remove_memory(start, size);
 
+	try_offline_node(nid);
+
 	unlock_memory_hotplug();
 
 	return 0;
@@ -1741,7 +1795,7 @@ int offline_pages(unsigned long start_pf
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

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

