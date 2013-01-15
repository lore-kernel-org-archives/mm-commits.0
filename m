From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:25:17 -0800
Message-ID: <20130115212518.5DA5920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:42500 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3AOVZY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:25:24 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so41877fav.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:25:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: Bug fix: Hold spinlock across find|remove /sys/firmware/memmap/X operation.
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch

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
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
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
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

