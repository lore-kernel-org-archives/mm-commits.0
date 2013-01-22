From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Tue, 22 Jan 2013 13:39:25 -0800
Message-ID: <20130122213925.C5EE831C1EB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40021 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3AVVj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:39:27 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so862819yen.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:39:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, julian.calaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: Bug fix: Fix the doc format in drivers/firmware/memmap.c
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch

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
Subject: Bug fix: Fix the doc format in drivers/firmware/memmap.c

Make the comments in drivers/firmware/memmap.c kernel-doc compliant.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix
+++ a/drivers/firmware/memmap.c
@@ -209,7 +209,7 @@ static inline void remove_sysfs_fw_map_e
 }
 
 /*
- * firmware_map_find_entry_in_list: Search memmap entry in a given list.
+ * firmware_map_find_entry_in_list() - Search memmap entry in a given list.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
@@ -219,7 +219,7 @@ static inline void remove_sysfs_fw_map_e
  * given list. The caller must hold map_entries_lock, and must not release
  * the lock until the processing of the returned entry has completed.
  *
- * Return pointer to the entry to be found on success, or NULL on failure.
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry_in_list(u64 start, u64 end, const char *type,
@@ -237,7 +237,7 @@ firmware_map_find_entry_in_list(u64 star
 }
 
 /*
- * firmware_map_find_entry: Search memmap entry in map_entries.
+ * firmware_map_find_entry() - Search memmap entry in map_entries.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
@@ -246,7 +246,7 @@ firmware_map_find_entry_in_list(u64 star
  * The caller must hold map_entries_lock, and must not release the lock
  * until the processing of the returned entry has completed.
  *
- * Return pointer to the entry to be found on success, or NULL on failure.
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry(u64 start, u64 end, const char *type)
@@ -255,7 +255,7 @@ firmware_map_find_entry(u64 start, u64 e
 }
 
 /*
- * firmware_map_find_entry_bootmem: Search memmap entry in map_entries_bootmem.
+ * firmware_map_find_entry_bootmem() - Search memmap entry in map_entries_bootmem.
  * @start: Start of the memory range.
  * @end:   End of the memory range (exclusive).
  * @type:  Type of the memory range.
@@ -263,7 +263,7 @@ firmware_map_find_entry(u64 start, u64 e
  * This function is similar to firmware_map_find_entry except that it find the
  * given entry in map_entries_bootmem.
  *
- * Return pointer to the entry to be found on success, or NULL on failure.
+ * Return: Pointer to the entry to be found on success, or NULL on failure.
  */
 static struct firmware_map_entry * __meminit
 firmware_map_find_entry_bootmem(u64 start, u64 end, const char *type)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
memory-hotplug-consider-compound-pages-when-free-memmap.patch
mempolicy-fix-is_valid_nodemask.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

