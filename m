From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:47 -0800
Message-ID: <20130225204948.1241731C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49874 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:49 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so346111ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, julian.calaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove /sys/firmware/memmap/X sysfs
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug: remove /sys/firmware/memmap/X sysfs

When (hot)adding memory into system, /sys/firmware/memmap/X/{end, start,
type} sysfs files are created.  But there is no code to remove these
files.  This patch implements the function to remove them.

We cannot free firmware_map_entry which is allocated by bootmem because
there is no way to do so when the system is up.  But we can at least
remember the address of that memory and reuse the storage when the memory
is added next time.

This patch also introduces a new list map_entries_bootmem to link the map
entries allocated by bootmem when they are removed, and a lock to protect
it.  And these entries will be reused when the memory is hot-added again.

The idea is suggestted by Andrew Morton.

NOTE: It is unsafe to return an entry pointer and release the
      map_entries_lock.  So we should not hold the map_entries_lock
      separately in firmware_map_find_entry() and
      firmware_map_remove_entry().  Hold the map_entries_lock across find
      and remove /sys/firmware/memmap/X operation.

       And also, users of these two functions need to be careful to
      hold the lock when using these two functions.

[tangchen@cn.fujitsu.com: Hold spinlock across find|remove /sys operation]
[tangchen@cn.fujitsu.com: fix the wrong comments of map_entries]
[tangchen@cn.fujitsu.com: reuse the storage of /sys/firmware/memmap/X/ allocated by bootmem]
[tangchen@cn.fujitsu.com: fix section mismatch problem]
[tangchen@cn.fujitsu.com: fix the doc format in drivers/firmware/memmap.c]
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
Cc: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c    |  196 ++++++++++++++++++++++++++++++---
 include/linux/firmware-map.h |    6 +
 mm/memory_hotplug.c          |    5 
 3 files changed, 193 insertions(+), 14 deletions(-)

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
@@ -52,6 +53,9 @@ static ssize_t start_show(struct firmwar
 static ssize_t end_show(struct firmware_map_entry *entry, char *buf);
 static ssize_t type_show(struct firmware_map_entry *entry, char *buf);
 
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry(u64 start, u64 end, const char *type);
+
 /*
  * Static data -----------------------------------------------------------------
  */
@@ -79,7 +83,52 @@ static const struct sysfs_ops memmap_att
 	.show = memmap_attr_show,
 };
 
-static struct kobj_type memmap_ktype = {
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
+
+static inline struct firmware_map_entry *
+to_memmap_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct firmware_map_entry, kobj);
+}
+
+static void __meminit release_firmware_map_entry(struct kobject *kobj)
+{
+	struct firmware_map_entry *entry = to_memmap_entry(kobj);
+
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
+		return;
+	}
+
+	kfree(entry);
+}
+
+static struct kobj_type __refdata memmap_ktype = {
+	.release	= release_firmware_map_entry,
 	.sysfs_ops	= &memmap_attr_ops,
 	.default_attrs	= def_attrs,
 };
@@ -88,13 +137,6 @@ static struct kobj_type memmap_ktype = {
  * Registration functions ------------------------------------------------------
  */
 
-/*
- * Firmware memory map entries. No locking is needed because the
- * firmware_map_add() and firmware_map_add_early() functions are called
- * in firmware initialisation code in one single thread of execution.
- */
-static LIST_HEAD(map_entries);
-
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
@@ -118,11 +160,25 @@ static int firmware_map_add_entry(u64 st
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
+ *
+ * The caller must hold map_entries_lock, and release it properly.
+ **/
+static inline void firmware_map_remove_entry(struct firmware_map_entry *entry)
+{
+	list_del(&entry->list);
+}
+
 /*
  * Add memmap entry on sysfs
  */
@@ -144,6 +200,78 @@ static int add_sysfs_fw_map_entry(struct
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
+ * firmware_map_find_entry_in_list() - Search memmap entry in a given list.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ * @list:  In which to find the entry.
+ *
+ * This function is to find the memmap entey of a given memory range in a
+ * given list. The caller must hold map_entries_lock, and must not release
+ * the lock until the processing of the returned entry has completed.
+ *
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
+ */
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry_in_list(u64 start, u64 end, const char *type,
+				struct list_head *list)
+{
+	struct firmware_map_entry *entry;
+
+	list_for_each_entry(entry, list, list)
+		if ((entry->start == start) && (entry->end == end) &&
+		    (!strcmp(entry->type, type))) {
+			return entry;
+		}
+
+	return NULL;
+}
+
+/*
+ * firmware_map_find_entry() - Search memmap entry in map_entries.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function is to find the memmap entey of a given memory range.
+ * The caller must hold map_entries_lock, and must not release the lock
+ * until the processing of the returned entry has completed.
+ *
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
+ */
+static struct firmware_map_entry * __meminit
+firmware_map_find_entry(u64 start, u64 end, const char *type)
+{
+	return firmware_map_find_entry_in_list(start, end, type, &map_entries);
+}
+
+/*
+ * firmware_map_find_entry_bootmem() - Search memmap entry in map_entries_bootmem.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (exclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function is similar to firmware_map_find_entry except that it find the
+ * given entry in map_entries_bootmem.
+ *
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
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
@@ -161,9 +289,19 @@ int __meminit firmware_map_add_hotplug(u
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
@@ -196,6 +334,36 @@ int __init firmware_map_add_early(u64 st
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
+	spin_lock(&map_entries_lock);
+	entry = firmware_map_find_entry(start, end - 1, type);
+	if (!entry) {
+		spin_unlock(&map_entries_lock);
+		return -EINVAL;
+	}
+
+	firmware_map_remove_entry(entry);
+	spin_unlock(&map_entries_lock);
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
@@ -217,8 +385,10 @@ static ssize_t type_show(struct firmware
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

origin.patch
linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
block-partitions-mac-obey-the-state-limit-constraint.patch
block-partitions-optimize-memory-allocation-in-check_partition.patch

