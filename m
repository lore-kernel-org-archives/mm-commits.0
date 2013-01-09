From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:27 -0800
Message-ID: <20130109233328.42C88100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34121 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab3AIXda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:33:30 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so317038vbi.3
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: remove /sys/firmware/memmap/X sysfs
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug: remove /sys/firmware/memmap/X sysfs

When (hot)adding memory into system, /sys/firmware/memmap/X/{end, start,
type} sysfs files are created.  But there is no code to remove these
files.  The patch implements the function to remove them.

Note: The code does not free firmware_map_entry which is allocated
      by bootmem.  So the patch adds a memory leak.  But I think the
      memory leak size is very small.  And it does not affect the system.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c    |   96 ++++++++++++++++++++++++++++++++-
 include/linux/firmware-map.h |    6 ++
 mm/memory_hotplug.c          |    5 +
 3 files changed, 104 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs
+++ a/drivers/firmware/memmap.c
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 
 /*
  * Data types ------------------------------------------------------------------
@@ -79,7 +80,26 @@ static const struct sysfs_ops memmap_att
 	.show = memmap_attr_show,
 };
 
+
+static inline struct firmware_map_entry *
+to_memmap_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct firmware_map_entry, kobj);
+}
+
+static void release_firmware_map_entry(struct kobject *kobj)
+{
+	struct firmware_map_entry *entry = to_memmap_entry(kobj);
+
+	if (PageReserved(virt_to_page(entry)))
+		/* There is no way to free memory allocated from bootmem */
+		return;
+
+	kfree(entry);
+}
+
 static struct kobj_type memmap_ktype = {
+	.release	= release_firmware_map_entry,
 	.sysfs_ops	= &memmap_attr_ops,
 	.default_attrs	= def_attrs,
 };
@@ -94,6 +114,7 @@ static struct kobj_type memmap_ktype = {
  * in firmware initialisation code in one single thread of execution.
  */
 static LIST_HEAD(map_entries);
+static DEFINE_SPINLOCK(map_entries_lock);
 
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
@@ -118,11 +139,25 @@ static int firmware_map_add_entry(u64 st
 	INIT_LIST_HEAD(&entry->list);
 	kobject_init(&entry->kobj, &memmap_ktype);
 
+	spin_lock(&map_entries_lock);
 	list_add_tail(&entry->list, &map_entries);
+	spin_unlock(&map_entries_lock);
 
 	return 0;
 }
 
+/**
+ * firmware_map_remove_entry() - Does the real work to remove a firmware
+ * memmap entry.
+ * @entry: removed entry.
+ **/
+static inline void firmware_map_remove_entry(struct firmware_map_entry *entry)
+{
+	spin_lock(&map_entries_lock);
+	list_del(&entry->list);
+	spin_unlock(&map_entries_lock);
+}
+
 /*
  * Add memmap entry on sysfs
  */
@@ -144,6 +179,35 @@ static int add_sysfs_fw_map_entry(struct
 	return 0;
 }
 
+/*
+ * Remove memmap entry on sysfs
+ */
+static inline void remove_sysfs_fw_map_entry(struct firmware_map_entry *entry)
+{
+	kobject_put(&entry->kobj);
+}
+
+/*
+ * Search memmap entry
+ */
+
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry(u64 start, u64 end, const char *type)
+{
+	struct firmware_map_entry *entry;
+
+	spin_lock(&map_entries_lock);
+	list_for_each_entry(entry, &map_entries, list)
+		if ((entry->start == start) && (entry->end == end) &&
+		    (!strcmp(entry->type, type))) {
+			spin_unlock(&map_entries_lock);
+			return entry;
+		}
+
+	spin_unlock(&map_entries_lock);
+	return NULL;
+}
+
 /**
  * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
  * memory hotplug.
@@ -196,6 +260,32 @@ int __init firmware_map_add_early(u64 st
 	return firmware_map_add_entry(start, end, type, entry);
 }
 
+/**
+ * firmware_map_remove() - remove a firmware mapping entry
+ * @start: Start of the memory range.
+ * @end:   End of the memory range.
+ * @type:  Type of the memory range.
+ *
+ * removes a firmware mapping entry.
+ *
+ * Returns 0 on success, or -EINVAL if no entry.
+ **/
+int __meminit firmware_map_remove(u64 start, u64 end, const char *type)
+{
+	struct firmware_map_entry *entry;
+
+	entry = firmware_map_find_entry(start, end - 1, type);
+	if (!entry)
+		return -EINVAL;
+
+	firmware_map_remove_entry(entry);
+
+	/* remove the memmap entry */
+	remove_sysfs_fw_map_entry(entry);
+
+	return 0;
+}
+
 /*
  * Sysfs functions -------------------------------------------------------------
  */
@@ -217,8 +307,10 @@ static ssize_t type_show(struct firmware
 	return snprintf(buf, PAGE_SIZE, "%s\n", entry->type);
 }
 
-#define to_memmap_attr(_attr) container_of(_attr, struct memmap_attribute, attr)
-#define to_memmap_entry(obj) container_of(obj, struct firmware_map_entry, kobj)
+static inline struct memmap_attribute *to_memmap_attr(struct attribute *attr)
+{
+	return container_of(attr, struct memmap_attribute, attr);
+}
 
 static ssize_t memmap_attr_show(struct kobject *kobj,
 				struct attribute *attr, char *buf)
diff -puN include/linux/firmware-map.h~memory-hotplug-remove-sys-firmware-memmap-x-sysfs include/linux/firmware-map.h
--- a/include/linux/firmware-map.h~memory-hotplug-remove-sys-firmware-memmap-x-sysfs
+++ a/include/linux/firmware-map.h
@@ -25,6 +25,7 @@
 
 int firmware_map_add_early(u64 start, u64 end, const char *type);
 int firmware_map_add_hotplug(u64 start, u64 end, const char *type);
+int firmware_map_remove(u64 start, u64 end, const char *type);
 
 #else /* CONFIG_FIRMWARE_MEMMAP */
 
@@ -38,6 +39,11 @@ static inline int firmware_map_add_hotpl
 	return 0;
 }
 
+static inline int firmware_map_remove(u64 start, u64 end, const char *type)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FIRMWARE_MEMMAP */
 
 #endif /* _LINUX_FIRMWARE_MAP_H */
diff -puN mm/memory_hotplug.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs
+++ a/mm/memory_hotplug.c
@@ -1460,7 +1460,7 @@ static int is_memblock_offlined_cb(struc
 	return ret;
 }
 
-int remove_memory(u64 start, u64 size)
+int __ref remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
 	int ret = 0;
@@ -1510,6 +1510,9 @@ repeat:
 		return ret;
 	}
 
+	/* remove memmap entry */
+	firmware_map_remove(start, start + size, "System RAM");
+
 	unlock_memory_hotplug();
 
 	return 0;
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

