From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:33:28 -0800
Message-ID: <20130222233329.220E431C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38358 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3BVXda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:33:30 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so120297yhr.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:33:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Bug fix: Hold spinlock across find|remove /sys/firmware/memmap/X operation.
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch

This patch was dropped because it was folded into memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Bug fix: Hold spinlock across find|remove /sys/firmware/memmap/X operation.

It is unsafe to return an entry pointer and release the map_entries_lock. 
So we should not hold the map_entries_lock separately in
firmware_map_find_entry() and firmware_map_remove_entry().  Hold the
map_entries_lock across find and remove /sys/firmware/memmap/X operation.

And also, users of these two functions need to be careful to hold the lock
when using these two functions.

The suggestion is from Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix
+++ a/drivers/firmware/memmap.c
@@ -150,12 +150,12 @@ static int firmware_map_add_entry(u64 st
  * firmware_map_remove_entry() - Does the real work to remove a firmware
  * memmap entry.
  * @entry: removed entry.
+ *
+ * The caller must hold map_entries_lock, and release it properly.
  **/
 static inline void firmware_map_remove_entry(struct firmware_map_entry *entry)
 {
-	spin_lock(&map_entries_lock);
 	list_del(&entry->list);
-	spin_unlock(&map_entries_lock);
 }
 
 /*
@@ -188,23 +188,28 @@ static inline void remove_sysfs_fw_map_e
 }
 
 /*
- * Search memmap entry
+ * firmware_map_find_entry: Search memmap entry.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function is to find the memmap entey of a given memory range.
+ * The caller must hold map_entries_lock, and must not release the lock
+ * until the processing of the returned entry has completed.
+ *
+ * Return pointer to the entry to be found on success, or NULL on failure.
  */
-
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
-	spin_lock(&map_entries_lock);
 	list_for_each_entry(entry, &map_entries, list)
 		if ((entry->start == start) && (entry->end == end) &&
 		    (!strcmp(entry->type, type))) {
-			spin_unlock(&map_entries_lock);
 			return entry;
 		}
 
-	spin_unlock(&map_entries_lock);
 	return NULL;
 }
 
@@ -274,11 +279,15 @@ int __meminit firmware_map_remove(u64 st
 {
 	struct firmware_map_entry *entry;
 
+	spin_lock(&map_entries_lock);
 	entry = firmware_map_find_entry(start, end - 1, type);
-	if (!entry)
+	if (!entry) {
+		spin_unlock(&map_entries_lock);
 		return -EINVAL;
+	}
 
 	firmware_map_remove_entry(entry);
+	spin_unlock(&map_entries_lock);
 
 	/* remove the memmap entry */
 	remove_sysfs_fw_map_entry(entry);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix-fix.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
memory-hotplug-export-the-function-try_offline_node.patch
memory-hotplug-export-the-function-try_offline_node-fix.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes-fix.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch
mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch

