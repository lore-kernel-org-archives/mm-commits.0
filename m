From: akpm@linux-foundation.org
Subject: + memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch added to -mm tree
Date: Wed, 31 Oct 2012 17:11:57 -0700
Message-ID: <20121101001158.610E5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44977 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2KAAL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2012 20:11:59 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so233618yen.1
        for <mm-commits@vger.kernel.org>; Wed, 31 Oct 2012 17:11:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, vasilis.liaskovitis@profitbricks.com


The patch titled
     Subject: memory-hotplug, mm/sparse.c: clear the memory to store struct page
has been added to the -mm tree.  Its filename is
     memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -760,6 +759,8 @@ int __meminit sparse_add_one_section(str
 		goto out;
 	}
 
+	memset(memmap, 0, sizeof(struct page) * nr_pages);
+
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

