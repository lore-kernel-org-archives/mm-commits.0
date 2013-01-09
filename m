From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-page-table-of-x86_64-architecture.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:57 -0800
Message-ID: <20130109233358.59FF3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39517 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:34:00 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so317377yen.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: remove page table of x86_64 architecture
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-page-table-of-x86_64-architecture.patch

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
Subject: memory-hotplug: remove page table of x86_64 architecture

Search a page table about the removed memory, and clear page table for
x86_64 architecture.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/x86/mm/init_64.c~memory-hotplug-remove-page-table-of-x86_64-architecture arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-remove-page-table-of-x86_64-architecture
+++ a/arch/x86/mm/init_64.c
@@ -981,6 +981,15 @@ remove_pagetable(unsigned long start, un
 	flush_tlb_all();
 }
 
+void __meminit
+kernel_physical_mapping_remove(unsigned long start, unsigned long end)
+{
+	start = (unsigned long)__va(start);
+	end = (unsigned long)__va(end);
+
+	remove_pagetable(start, end, true);
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
@@ -990,6 +999,7 @@ int __ref arch_remove_memory(u64 start, 
 	int ret;
 
 	zone = page_zone(pfn_to_page(start_pfn));
+	kernel_physical_mapping_remove(start, start + size);
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
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

