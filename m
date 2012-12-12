From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:50 -0800
Message-ID: <20121212195751.929BF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:65257 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2LLT5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:55 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so66419lbc.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, vasilis.liaskovitis@profitbricks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug, mm/sparse.c: clear the memory to store struct page
has been removed from the -mm tree.  Its filename was
     memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug, mm/sparse.c: clear the memory to store struct page

If sparse memory vmemmap is enabled, we can't free the memory to store
struct page when a memory device is hotremoved, because we may store
struct page in the memory to manage the memory which doesn't belong to
this memory device.  When we hotadded this memory device again, we will
reuse this memory to store struct page, and struct page may contain some
obsolete information, and we will get bad-page state:

[   59.611278] init_memory_mapping: [mem 0x80000000-0x9fffffff]
[   59.637836] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 547617
[   59.638739] Policy zone: Normal
[   59.650840] BUG: Bad page state in process bash  pfn:9b6dc
[   59.651124] page:ffffea0002200020 count:0 mapcount:0 mapping:          (null) index:0xfdfdfdfdfdfdfdfd
[   59.651494] page flags: 0x2fdfdfdfd5df9fd(locked|referenced|uptodate|dirty|lru|active|slab|owner_priv_1|private|private_2|writeback|head|tail|swapcache|reclaim|swapbacked|unevictable|uncached|compound_lock)
[   59.653604] Modules linked in: netconsole acpiphp pci_hotplug acpi_memhotplug loop kvm_amd kvm microcode tpm_tis tpm tpm_bios evdev psmouse serio_raw i2c_piix4 i2c_core parport_pc parport processor button thermal_sys ext3 jbd mbcache sg sr_mod cdrom ata_generic virtio_net ata_piix virtio_blk libata virtio_pci virtio_ring virtio scsi_mod
[   59.656998] Pid: 988, comm: bash Not tainted 3.6.0-rc7-guest #12
[   59.657172] Call Trace:
[   59.657275]  [<ffffffff810e9b30>] ? bad_page+0xb0/0x100
[   59.657434]  [<ffffffff810ea4c3>] ? free_pages_prepare+0xb3/0x100
[   59.657610]  [<ffffffff810ea668>] ? free_hot_cold_page+0x48/0x1a0
[   59.657787]  [<ffffffff8112cc08>] ? online_pages_range+0x68/0xa0
[   59.657961]  [<ffffffff8112cba0>] ? __online_page_increment_counters+0x10/0x10
[   59.658162]  [<ffffffff81045561>] ? walk_system_ram_range+0x101/0x110
[   59.658346]  [<ffffffff814c4f95>] ? online_pages+0x1a5/0x2b0
[   59.658515]  [<ffffffff8135663d>] ? __memory_block_change_state+0x20d/0x270
[   59.658710]  [<ffffffff81356756>] ? store_mem_state+0xb6/0xf0
[   59.658878]  [<ffffffff8119e482>] ? sysfs_write_file+0xd2/0x160
[   59.659052]  [<ffffffff8113769a>] ? vfs_write+0xaa/0x160
[   59.659212]  [<ffffffff81137977>] ? sys_write+0x47/0x90
[   59.659371]  [<ffffffff814e2f25>] ? async_page_fault+0x25/0x30
[   59.659543]  [<ffffffff814ea239>] ? system_call_fastpath+0x16/0x1b
[   59.659720] Disabling lock debugging due to kernel taint

This patch clears the memory to store struct page to avoid unexpected error.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reported-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/sparse.c~memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page
+++ a/mm/sparse.c
@@ -638,7 +638,6 @@ static struct page *__kmalloc_section_me
 got_map_page:
 	ret = (struct page *)pfn_to_kaddr(page_to_pfn(page));
 got_map_ptr:
-	memset(ret, 0, memmap_size);
 
 	return ret;
 }
@@ -758,6 +757,8 @@ int __meminit sparse_add_one_section(str
 		goto out;
 	}
 
+	memset(memmap, 0, sizeof(struct page) * nr_pages);
+
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
linux-next.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

