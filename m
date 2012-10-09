From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:48 -0700
Message-ID: <20121009181449.474FC5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36134 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2JISOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:52 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so363236lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, cl@linux.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: preparation to notify memory block's state at memory hot remove
has been removed from the -mm tree.  Its filename was
     memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: preparation to notify memory block's state at memory hot remove

remove_memory() is called in two cases:
1. echo offline >/sys/devices/system/memory/memoryXX/state
2. hot remove a memory device

In the 1st case, the memory block's state is changed and the notification
that memory block's state changed is sent to userland after calling
remove_memory().  So user can notice memory block is changed.

But in the 2nd case, the memory block's state is not changed and the
notification is not also sent to userspcae even if calling
remove_memory().  So user cannot notice memory block is changed.

For adding the notification at memory hot remove, the patch just prepare
as follows:
1st case uses offline_pages() for offlining memory.
2nd case uses remove_memory() for offlining memory and changing memory block's
    state and notifing the information.

The patch does not implement notification to remove_memory().

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

 drivers/base/memory.c          |    9 +++------
 include/linux/memory_hotplug.h |    1 +
 mm/memory_hotplug.c            |   13 +++++++++++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove
+++ a/drivers/base/memory.c
@@ -248,26 +248,23 @@ static bool pages_correctly_reserved(uns
 static int
 memory_block_action(unsigned long phys_index, unsigned long action)
 {
-	unsigned long start_pfn, start_paddr;
+	unsigned long start_pfn;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	struct page *first_page;
 	int ret;
 
 	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
+	start_pfn = page_to_pfn(first_page);
 
 	switch (action) {
 		case MEM_ONLINE:
-			start_pfn = page_to_pfn(first_page);
-
 			if (!pages_correctly_reserved(start_pfn, nr_pages))
 				return -EBUSY;
 
 			ret = online_pages(start_pfn, nr_pages);
 			break;
 		case MEM_OFFLINE:
-			start_paddr = page_to_pfn(first_page) << PAGE_SHIFT;
-			ret = remove_memory(start_paddr,
-					    nr_pages << PAGE_SHIFT);
+			ret = offline_pages(start_pfn, nr_pages);
 			break;
 		default:
 			WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
diff -puN include/linux/memory_hotplug.h~memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove
+++ a/include/linux/memory_hotplug.h
@@ -233,6 +233,7 @@ static inline int is_mem_section_removab
 extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
+extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
diff -puN mm/memory_hotplug.c~memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove
+++ a/mm/memory_hotplug.c
@@ -874,7 +874,7 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-static int __ref offline_pages(unsigned long start_pfn,
+static int __ref __offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
 	unsigned long pfn, nr_pages, expire;
@@ -1007,15 +1007,24 @@ out:
 	return ret;
 }
 
+int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+{
+	return __offline_pages(start_pfn, start_pfn + nr_pages, 120 * HZ);
+}
+
 int remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = start_pfn + PFN_DOWN(size);
-	return offline_pages(start_pfn, end_pfn, 120 * HZ);
+	return __offline_pages(start_pfn, end_pfn, 120 * HZ);
 }
 #else
+int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+{
+	return -EINVAL;
+}
 int remove_memory(u64 start, u64 size)
 {
 	return -EINVAL;
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

