From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:45 -0800
Message-ID: <201003091903.o29J3jD9030987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758Ab0CITD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohui.zheng@intel.com, ak@linux.intel.com, fengguang.wu@intel.com, haveblue@us.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory-hotplug: create /sys/firmware/memmap entry for new memory
has been removed from the -mm tree.  Its filename was
     memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-hotplug: create /sys/firmware/memmap entry for new memory


A memmap is a directory in sysfs which includes 3 text files: start, end
and type.  For example:

start: 	0x100000
end:	0x7e7b1cff
type:	System RAM

Interface firmware_map_add was not called explicitly.  Remove it and add
function firmware_map_add_hotplug as hotplug interface of memmap.  

Each memory entry has a memmap in sysfs, When we hot-add new memory, sysfs
does not export memmap entry for it.  We add a call in function add_memory
to function firmware_map_add_hotplug.

Add a new function add_sysfs_fw_map_entry() to create memmap entry, it
will be called when initialize memmap and hot-add memory.

[akpm@linux-foundation.org: un-kernedoc a no longer kerneldoc comment]
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c    |   57 ++++++++++++++++++++-------------
 include/linux/firmware-map.h |    6 +--
 mm/memory_hotplug.c          |    4 ++
 3 files changed, 43 insertions(+), 24 deletions(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory
+++ a/drivers/firmware/memmap.c
@@ -122,29 +122,53 @@ static int firmware_map_add_entry(u64 st
 	return 0;
 }
 
+/*
+ * Add memmap entry on sysfs
+ */
+static int add_sysfs_fw_map_entry(struct firmware_map_entry *entry)
+{
+	static int map_entries_nr;
+	static struct kset *mmap_kset;
+
+	if (!mmap_kset) {
+		mmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
+		if (!mmap_kset)
+			return -ENOMEM;
+	}
+
+	entry->kobj.kset = mmap_kset;
+	if (kobject_add(&entry->kobj, NULL, "%d", map_entries_nr++))
+		kobject_put(&entry->kobj);
+
+	return 0;
+}
+
 /**
- * firmware_map_add() - Adds a firmware mapping entry.
+ * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
+ * memory hotplug.
  * @start: Start of the memory range.
  * @end:   End of the memory range (inclusive).
  * @type:  Type of the memory range.
  *
- * This function uses kmalloc() for memory
- * allocation. Use firmware_map_add_early() if you want to use the bootmem
- * allocator.
- *
- * That function must be called before late_initcall.
+ * Adds a firmware mapping entry. This function is for memory hotplug, it is
+ * similar to function firmware_map_add_early(). The only difference is that
+ * it will create the syfs entry dynamically.
  *
  * Returns 0 on success, or -ENOMEM if no memory could be allocated.
  **/
-int firmware_map_add(u64 start, u64 end, const char *type)
+int __meminit firmware_map_add_hotplug(u64 start, u64 end, const char *type)
 {
 	struct firmware_map_entry *entry;
 
-	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
+	entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
-	return firmware_map_add_entry(start, end, type, entry);
+	firmware_map_add_entry(start, end, type, entry);
+	/* create the memmap entry */
+	add_sysfs_fw_map_entry(entry);
+
+	return 0;
 }
 
 /**
@@ -154,7 +178,7 @@ int firmware_map_add(u64 start, u64 end,
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function uses the bootmem allocator
- * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
+ * for memory allocation.
  *
  * That function must be called before late_initcall.
  *
@@ -214,19 +238,10 @@ static ssize_t memmap_attr_show(struct k
  */
 static int __init memmap_init(void)
 {
-	int i = 0;
 	struct firmware_map_entry *entry;
-	struct kset *memmap_kset;
-
-	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
-	if (WARN_ON(!memmap_kset))
-		return -ENOMEM;
 
-	list_for_each_entry(entry, &map_entries, list) {
-		entry->kobj.kset = memmap_kset;
-		if (kobject_add(&entry->kobj, NULL, "%d", i++))
-			kobject_put(&entry->kobj);
-	}
+	list_for_each_entry(entry, &map_entries, list)
+		add_sysfs_fw_map_entry(entry);
 
 	return 0;
 }
diff -puN include/linux/firmware-map.h~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory include/linux/firmware-map.h
--- a/include/linux/firmware-map.h~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory
+++ a/include/linux/firmware-map.h
@@ -24,17 +24,17 @@
  */
 #ifdef CONFIG_FIRMWARE_MEMMAP
 
-int firmware_map_add(u64 start, u64 end, const char *type);
 int firmware_map_add_early(u64 start, u64 end, const char *type);
+int firmware_map_add_hotplug(u64 start, u64 end, const char *type);
 
 #else /* CONFIG_FIRMWARE_MEMMAP */
 
-static inline int firmware_map_add(u64 start, u64 end, const char *type)
+static inline int firmware_map_add_early(u64 start, u64 end, const char *type)
 {
 	return 0;
 }
 
-static inline int firmware_map_add_early(u64 start, u64 end, const char *type)
+static inline int firmware_map_add_hotplug(u64 start, u64 end, const char *type)
 {
 	return 0;
 }
diff -puN mm/memory_hotplug.c~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory
+++ a/mm/memory_hotplug.c
@@ -28,6 +28,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/mm_inline.h>
+#include <linux/firmware-map.h>
 
 #include <asm/tlbflush.h>
 
@@ -523,6 +524,9 @@ int __ref add_memory(int nid, u64 start,
 		BUG_ON(ret);
 	}
 
+	/* create new memmap entry */
+	firmware_map_add_hotplug(start, start + size, "System RAM");
+
 	goto out;
 
 error:
_

Patches currently in -mm which might be from shaohui.zheng@intel.com are


