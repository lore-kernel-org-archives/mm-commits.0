From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:44:55 -0800
Message-ID: <20130115214455.AEC27820055@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:44026 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3AOVo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:44:56 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so78784ghb.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:44:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: Bug fix: Reuse the storage of /sys/firmware/memmap/X/ allocated by bootmem.
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch

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
Subject: Bug fix: Reuse the storage of /sys/firmware/memmap/X/ allocated by bootmem.

Now we don't free firmware_map_entry which is allocated by bootmem because
there is no way to do so when the system is up. But we can at least remember
the address of that memory and reuse the storage when the memory is added
next time.

This patch introduces a new list map_entries_bootmem to link the map entries
allocated by bootmem when they are removed, and a lock to protect it.
And these entries will be reused when the memory is hot-added again.

The idea is suggestted by Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |  103 ++++++++++++++++++++++++++++++------
 1 file changed, 88 insertions(+), 15 deletions(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix
+++ a/drivers/firmware/memmap.c
@@ -53,6 +53,9 @@ static ssize_t start_show(struct firmwar
 static ssize_t end_show(struct firmware_map_entry *entry, char *buf);
 static ssize_t type_show(struct firmware_map_entry *entry, char *buf);
 
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry(u64 start, u64 end, const char *type);
+
 /*
  * Static data -----------------------------------------------------------------
  */
@@ -80,6 +83,19 @@ static const struct sysfs_ops memmap_att
 	.show = memmap_attr_show,
 };
 
+/* Firmware memory map entries. */
+static LIST_HEAD(map_entries);
+static DEFINE_SPINLOCK(map_entries_lock);
+
+/*
+ * For memory hotplug, there is no way to free memory map entries allocated
+ * by boot mem after the system is up. So when we hot-remove memory whose
+ * map entry is allocated by bootmem, we need to remember the storage and
+ * reuse it when the memory is hot-added again.
+ */
+static LIST_HEAD(map_entries_bootmem);
+static DEFINE_SPINLOCK(map_entries_bootmem_lock);
+
 
 static inline struct firmware_map_entry *
 to_memmap_entry(struct kobject *kobj)
@@ -91,9 +107,22 @@ static void release_firmware_map_entry(s
 {
 	struct firmware_map_entry *entry = to_memmap_entry(kobj);
 
-	if (PageReserved(virt_to_page(entry)))
-		/* There is no way to free memory allocated from bootmem */
+	if (PageReserved(virt_to_page(entry))) {
+		/*
+		 * Remember the storage allocated by bootmem, and reuse it when
+		 * the memory is hot-added again. The entry will be added to
+		 * map_entries_bootmem here, and deleted from &map_entries in
+		 * firmware_map_remove_entry().
+		 */
+		if (firmware_map_find_entry(entry->start, entry->end,
+		    entry->type)) {
+			spin_lock(&map_entries_bootmem_lock);
+			list_add(&entry->list, &map_entries_bootmem);
+			spin_unlock(&map_entries_bootmem_lock);
+		}
+
 		return;
+	}
 
 	kfree(entry);
 }
@@ -108,10 +137,6 @@ static struct kobj_type memmap_ktype = {
  * Registration functions ------------------------------------------------------
  */
 
-/* Firmware memory map entries. */
-static LIST_HEAD(map_entries);
-static DEFINE_SPINLOCK(map_entries_lock);
-
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
@@ -184,23 +209,25 @@ static inline void remove_sysfs_fw_map_e
 }
 
 /*
- * firmware_map_find_entry: Search memmap entry.
+ * firmware_map_find_entry_in_list: Search memmap entry in a given list.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
+ * @list:  In which to find the entry.
  *
- * This function is to find the memmap entey of a given memory range.
- * The caller must hold map_entries_lock, and must not release the lock
- * until the processing of the returned entry has completed.
+ * This function is to find the memmap entey of a given memory range in a
+ * given list. The caller must hold map_entries_lock, and must not release
+ * the lock until the processing of the returned entry has completed.
  *
  * Return pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
-firmware_map_find_entry(u64 start, u64 end, const char *type)
+firmware_map_find_entry_in_list(u64 start, u64 end, const char *type,
+				struct list_head *list)
 {
 	struct firmware_map_entry *entry;
 
-	list_for_each_entry(entry, &map_entries, list)
+	list_for_each_entry(entry, list, list)
 		if ((entry->start == start) && (entry->end == end) &&
 		    (!strcmp(entry->type, type))) {
 			return entry;
@@ -209,6 +236,42 @@ firmware_map_find_entry(u64 start, u64 e
 	return NULL;
 }
 
+/*
+ * firmware_map_find_entry: Search memmap entry in map_entries.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function is to find the memmap entey of a given memory range.
+ * The caller must hold map_entries_lock, and must not release the lock
+ * until the processing of the returned entry has completed.
+ *
+ * Return pointer to the entry to be found on success, or NULL on failure.
+ */
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry(u64 start, u64 end, const char *type)
+{
+	return firmware_map_find_entry_in_list(start, end, type, &map_entries);
+}
+
+/*
+ * firmware_map_find_entry_bootmem: Search memmap entry in map_entries_bootmem.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function is similar to firmware_map_find_entry except that it find the
+ * given entry in map_entries_bootmem.
+ *
+ * Return pointer to the entry to be found on success, or NULL on failure.
+ */
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry_bootmem(u64 start, u64 end, const char *type)
+{
+	return firmware_map_find_entry_in_list(start, end, type,
+					       &map_entries_bootmem);
+}
+
 /**
  * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
  * memory hotplug.
@@ -226,9 +289,19 @@ int __meminit firmware_map_add_hotplug(u
 {
 	struct firmware_map_entry *entry;
 
-	entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
-	if (!entry)
-		return -ENOMEM;
+	entry = firmware_map_find_entry_bootmem(start, end, type);
+	if (!entry) {
+		entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
+		if (!entry)
+			return -ENOMEM;
+	} else {
+		/* Reuse storage allocated by bootmem. */
+		spin_lock(&map_entries_bootmem_lock);
+		list_del(&entry->list);
+		spin_unlock(&map_entries_bootmem_lock);
+
+		memset(entry, 0, sizeof(*entry));
+	}
 
 	firmware_map_add_entry(start, end, type, entry);
 	/* create the memmap entry */
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
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

