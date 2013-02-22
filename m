From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:33:38 -0800
Message-ID: <20130222233339.087C831C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:43659 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3BVXdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:33:43 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so119792vea.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:33:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Bug fix: Fix section mismatch problem of release_firmware_map_entry().
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Bug fix: Fix section mismatch problem of release_firmware_map_entry().

The function release_firmware_map_entry() references the function
__meminit firmware_map_find_entry_in_list(). So it should also have
__meminit.

And since the firmware_map_entry->kobj is initialized with memmap_ktype,
the memmap_ktype should also be prefixed by __refdata.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix
+++ a/drivers/firmware/memmap.c
@@ -103,7 +103,7 @@ to_memmap_entry(struct kobject *kobj)
 	return container_of(kobj, struct firmware_map_entry, kobj);
 }
 
-static void release_firmware_map_entry(struct kobject *kobj)
+static void __meminit release_firmware_map_entry(struct kobject *kobj)
 {
 	struct firmware_map_entry *entry = to_memmap_entry(kobj);
 
@@ -127,7 +127,7 @@ static void release_firmware_map_entry(s
 	kfree(entry);
 }
 
-static struct kobj_type memmap_ktype = {
+static struct kobj_type __refdata memmap_ktype = {
 	.release	= release_firmware_map_entry,
 	.sysfs_ops	= &memmap_attr_ops,
 	.default_attrs	= def_attrs,
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
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

