From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:53 -0700
Message-ID: <20121009181453.CC608100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57225 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2JISOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574663yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, cl@linux.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: update memory block's state and notify userspace
has been removed from the -mm tree.  Its filename was
     memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: update memory block's state and notify userspace

remove_memory() will be called when hot removing a memory device.  But
even if offlining memory, we cannot notice it.  So the patch updates the
memory block's state and sends notification to userspace.

Additionally, the memory device may contain more than one memory block. 
If the memory block has been offlined, __offline_pages() will fail.  So we
should try to offline one memory block at a time.

Thus remove_memory() also check each memory block's state.  So there is no
need to check the memory block's state before calling remove_memory().


Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   31 +++++++++++++++++++++++++----
 include/linux/memory_hotplug.h |    2 +
 mm/memory_hotplug.c            |   33 ++++++++++++++++++++++++++++++-
 3 files changed, 61 insertions(+), 5 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace
+++ a/drivers/base/memory.c
@@ -275,13 +275,11 @@ memory_block_action(unsigned long phys_i
 	return ret;
 }
 
-static int memory_block_change_state(struct memory_block *mem,
+static int __memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
 	int ret = 0;
 
-	mutex_lock(&mem->state_mutex);
-
 	if (mem->state != from_state_req) {
 		ret = -EINVAL;
 		goto out;
@@ -309,10 +307,20 @@ static int memory_block_change_state(str
 		break;
 	}
 out:
-	mutex_unlock(&mem->state_mutex);
 	return ret;
 }
 
+static int memory_block_change_state(struct memory_block *mem,
+		unsigned long to_state, unsigned long from_state_req)
+{
+	int ret;
+
+	mutex_lock(&mem->state_mutex);
+	ret = __memory_block_change_state(mem, to_state, from_state_req);
+	mutex_unlock(&mem->state_mutex);
+
+	return ret;
+}
 static ssize_t
 store_mem_state(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -653,6 +661,21 @@ int unregister_memory_section(struct mem
 }
 
 /*
+ * offline one memory block. If the memory block has been offlined, do nothing.
+ */
+int offline_memory_block(struct memory_block *mem)
+{
+	int ret = 0;
+
+	mutex_lock(&mem->state_mutex);
+	if (mem->state != MEM_OFFLINE)
+		ret = __memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
+	mutex_unlock(&mem->state_mutex);
+
+	return ret;
+}
+
+/*
  * Initialize the sysfs support for memory devices...
  */
 int __init memory_dev_init(void)
diff -puN include/linux/memory_hotplug.h~memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace
+++ a/include/linux/memory_hotplug.h
@@ -10,6 +10,7 @@ struct page;
 struct zone;
 struct pglist_data;
 struct mem_section;
+struct memory_block;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
@@ -234,6 +235,7 @@ extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
+extern int offline_memory_block(struct memory_block *mem);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
diff -puN mm/memory_hotplug.c~memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace
+++ a/mm/memory_hotplug.c
@@ -1014,11 +1014,42 @@ int offline_pages(unsigned long start_pf
 
 int remove_memory(u64 start, u64 size)
 {
+	struct memory_block *mem = NULL;
+	struct mem_section *section;
 	unsigned long start_pfn, end_pfn;
+	unsigned long pfn, section_nr;
+	int ret;
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = start_pfn + PFN_DOWN(size);
-	return __offline_pages(start_pfn, end_pfn, 120 * HZ);
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		section_nr = pfn_to_section_nr(pfn);
+		if (!present_section_nr(section_nr))
+			continue;
+
+		section = __nr_to_section(section_nr);
+		/* same memblock? */
+		if (mem)
+			if ((section_nr >= mem->start_section_nr) &&
+			    (section_nr <= mem->end_section_nr))
+				continue;
+
+		mem = find_memory_block_hinted(section, mem);
+		if (!mem)
+			continue;
+
+		ret = offline_memory_block(mem);
+		if (ret) {
+			kobject_put(&mem->dev.kobj);
+			return ret;
+		}
+	}
+
+	if (mem)
+		kobject_put(&mem->dev.kobj);
+
+	return 0;
 }
 #else
 int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
linux-next.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch

