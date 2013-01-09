From: akpm@linux-foundation.org
Subject: + memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:42 -0800
Message-ID: <20130109233342.ED22020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63074 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:33:47 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so146207wey.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: move pgdat_resize_lock into sparse_remove_one_section()
has been added to the -mm tree.  Its filename is
     memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch

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
Subject: memory-hotplug: move pgdat_resize_lock into sparse_remove_one_section()

In __remove_section(), we locked pgdat_resize_lock when calling
sparse_remove_one_section().  This lock will disable irq.  But we don't
need to lock the whole function.  If we do some work to free pagetables in
free_section_usemap(), we need to call flush_tlb_all(), which need irq
enabled.  Otherwise the WARN_ON_ONCE() in smp_call_function_many() will be
triggered.

If we lock the whole sparse_remove_one_section(), then we come to this call trace:

[  454.796248] ------------[ cut here ]------------
[  454.851408] WARNING: at kernel/smp.c:461 smp_call_function_many+0xbd/0x260()
[  454.935620] Hardware name: PRIMEQUEST 1800E
......
[  455.652201] Call Trace:
[  455.681391]  [<ffffffff8106e73f>] warn_slowpath_common+0x7f/0xc0
[  455.753151]  [<ffffffff810560a0>] ? leave_mm+0x50/0x50
[  455.814527]  [<ffffffff8106e79a>] warn_slowpath_null+0x1a/0x20
[  455.884208]  [<ffffffff810e7a9d>] smp_call_function_many+0xbd/0x260
[  455.959082]  [<ffffffff810e7ecb>] smp_call_function+0x3b/0x50
[  456.027722]  [<ffffffff810560a0>] ? leave_mm+0x50/0x50
[  456.089098]  [<ffffffff810e7f4b>] on_each_cpu+0x3b/0xc0
[  456.151512]  [<ffffffff81055f0c>] flush_tlb_all+0x1c/0x20
[  456.216004]  [<ffffffff8104f8de>] remove_pagetable+0x14e/0x1d0
[  456.285683]  [<ffffffff8104f978>] vmemmap_free+0x18/0x20
[  456.349139]  [<ffffffff811b8797>] sparse_remove_one_section+0xf7/0x100
[  456.427126]  [<ffffffff811c5fc2>] __remove_section+0xa2/0xb0
[  456.494726]  [<ffffffff811c6070>] __remove_pages+0xa0/0xd0
[  456.560258]  [<ffffffff81669c7b>] arch_remove_memory+0x6b/0xc0
[  456.629937]  [<ffffffff8166ad28>] remove_memory+0xb8/0xf0
[  456.694431]  [<ffffffff813e686f>] acpi_memory_device_remove+0x53/0x96
[  456.771379]  [<ffffffff813b33c4>] acpi_device_remove+0x90/0xb2
[  456.841059]  [<ffffffff8144b02c>] __device_release_driver+0x7c/0xf0
[  456.915928]  [<ffffffff8144b1af>] device_release_driver+0x2f/0x50
[  456.988719]  [<ffffffff813b4476>] acpi_bus_remove+0x32/0x6d
[  457.055285]  [<ffffffff813b4542>] acpi_bus_trim+0x91/0x102
[  457.120814]  [<ffffffff813b463b>] acpi_bus_hot_remove_device+0x88/0x16b
[  457.199840]  [<ffffffff813afda7>] acpi_os_execute_deferred+0x27/0x34
[  457.275756]  [<ffffffff81091ece>] process_one_work+0x20e/0x5c0
[  457.345434]  [<ffffffff81091e5f>] ? process_one_work+0x19f/0x5c0
[  457.417190]  [<ffffffff813afd80>] ? acpi_os_wait_events_complete+0x23/0x23
[  457.499332]  [<ffffffff81093f6e>] worker_thread+0x12e/0x370
[  457.565896]  [<ffffffff81093e40>] ? manage_workers+0x180/0x180
[  457.635574]  [<ffffffff8109a09e>] kthread+0xee/0x100
[  457.694871]  [<ffffffff810dfaf9>] ? __lock_release+0x129/0x190
[  457.764552]  [<ffffffff81099fb0>] ? __init_kthread_worker+0x70/0x70
[  457.839427]  [<ffffffff81690aac>] ret_from_fork+0x7c/0xb0
[  457.903914]  [<ffffffff81099fb0>] ? __init_kthread_worker+0x70/0x70
[  457.978784] ---[ end trace 25e85300f542aa01 ]---

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ----
 mm/sparse.c         |    5 ++++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section
+++ a/mm/memory_hotplug.c
@@ -442,8 +442,6 @@ static int __remove_section(struct zone 
 #else
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
-	unsigned long flags;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	int ret = -EINVAL;
 
 	if (!valid_section(ms))
@@ -453,9 +451,7 @@ static int __remove_section(struct zone 
 	if (ret)
 		return ret;
 
-	pgdat_resize_lock(pgdat, &flags);
 	sparse_remove_one_section(zone, ms);
-	pgdat_resize_unlock(pgdat, &flags);
 	return 0;
 }
 #endif
diff -puN mm/sparse.c~memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section
+++ a/mm/sparse.c
@@ -796,8 +796,10 @@ static inline void clear_hwpoisoned_page
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 {
 	struct page *memmap = NULL;
-	unsigned long *usemap = NULL;
+	unsigned long *usemap = NULL, flags;
+	struct pglist_data *pgdat = zone->zone_pgdat;
 
+	pgdat_resize_lock(pgdat, &flags);
 	if (ms->section_mem_map) {
 		usemap = ms->pageblock_flags;
 		memmap = sparse_decode_mem_map(ms->section_mem_map,
@@ -805,6 +807,7 @@ void sparse_remove_one_section(struct zo
 		ms->section_mem_map = 0;
 		ms->pageblock_flags = NULL;
 	}
+	pgdat_resize_unlock(pgdat, &flags);
 
 	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
 	free_section_usemap(memmap, usemap);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
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

