From: akpm@linux-foundation.org
Subject: + memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:09 -0800
Message-ID: <20130109233311.1538F200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:51832 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:33:15 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so1734lbo.2
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: try to offline the memory twice to avoid dependence
has been added to the -mm tree.  Its filename is
     memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch

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
Subject: memory-hotplug: try to offline the memory twice to avoid dependence

memory can't be offlined when CONFIG_MEMCG is selected.  For example:
there is a memory device on node 1.  The address range is [1G, 1.5G).  You
will find 4 new directories memory8, memory9, memory10, and memory11 under
the directory /sys/devices/system/memory/.

If CONFIG_MEMCG is selected, we will allocate memory to store page cgroup
when we online pages.  When we online memory8, the memory stored page
cgroup is not provided by this memory device.  But when we online memory9,
the memory stored page cgroup may be provided by memory8.  So we can't
offline memory8 now.  We should offline the memory in the reversed order.

When the memory device is hotremoved, we will auto offline memory provided
by this memory device.  But we don't know which memory is onlined first,
so offlining memory may fail.  In such case, iterate twice to offline the
memory.  1st iterate: offline every non primary memory block.  2nd
iterate: offline primary (i.e.  first added) memory block.

This idea is suggested by KOSAKI Motohiro.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence
+++ a/mm/memory_hotplug.c
@@ -1387,10 +1387,13 @@ int remove_memory(u64 start, u64 size)
 	unsigned long start_pfn, end_pfn;
 	unsigned long pfn, section_nr;
 	int ret;
+	int return_on_error = 0;
+	int retry = 0;
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = start_pfn + PFN_DOWN(size);
 
+repeat:
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		section_nr = pfn_to_section_nr(pfn);
 		if (!present_section_nr(section_nr))
@@ -1409,14 +1412,23 @@ int remove_memory(u64 start, u64 size)
 
 		ret = offline_memory_block(mem);
 		if (ret) {
-			kobject_put(&mem->dev.kobj);
-			return ret;
+			if (return_on_error) {
+				kobject_put(&mem->dev.kobj);
+				return ret;
+			} else {
+				retry = 1;
+			}
 		}
 	}
 
 	if (mem)
 		kobject_put(&mem->dev.kobj);
 
+	if (retry) {
+		return_on_error = 1;
+		goto repeat;
+	}
+
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

x86-numa-dont-check-if-node-is-numa_no_node.patch
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
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

