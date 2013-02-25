From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-remove-page-table-of-x86_64-architecture.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:07 -0800
Message-ID: <20130225205007.D566231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57041 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab3BYUuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:10 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so347616yhz.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove page table of x86_64 architecture
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-page-table-of-x86_64-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: remove page table of x86_64 architecture

Search a page table about the removed memory, and clear page table for
x86_64 architecture.

[akpm@linux-foundation.org: make kernel_physical_mapping_remove() static]
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
@@ -1011,6 +1011,15 @@ remove_pagetable(unsigned long start, un
 	flush_tlb_all();
 }
 
+static void __meminit
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
@@ -1020,6 +1029,7 @@ int __ref arch_remove_memory(u64 start, 
 	int ret;
 
 	zone = page_zone(pfn_to_page(start_pfn));
+	kernel_physical_mapping_remove(start, start + size);
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

