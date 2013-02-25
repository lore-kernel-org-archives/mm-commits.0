From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:51 -0800
Message-ID: <20130225204951.F1DF95A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55414 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:53 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so141037yen.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: introduce new arch_remove_memory() for removing page table
has been removed from the -mm tree.  Its filename was
     memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: introduce new arch_remove_memory() for removing page table

For removing memory, we need to remove page tables.  But it depends on
architecture.  So the patch introduce arch_remove_memory() for removing
page table.  Now it only calls __remove_pages().

Note: __remove_pages() for some archtecuture is not implemented
      (I don't know how to implement it for s390).

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

 arch/ia64/mm/init.c            |   18 ++++++++++++++++++
 arch/powerpc/mm/mem.c          |   12 ++++++++++++
 arch/s390/mm/init.c            |   12 ++++++++++++
 arch/sh/mm/init.c              |   17 +++++++++++++++++
 arch/tile/mm/init.c            |    8 ++++++++
 arch/x86/mm/init_32.c          |   12 ++++++++++++
 arch/x86/mm/init_64.c          |   15 +++++++++++++++
 include/linux/memory_hotplug.h |    1 +
 mm/memory_hotplug.c            |    2 ++
 9 files changed, 97 insertions(+)

diff -puN arch/ia64/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/ia64/mm/init.c
@@ -688,6 +688,24 @@ int arch_add_memory(int nid, u64 start, 
 
 	return ret;
 }
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int arch_remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct zone *zone;
+	int ret;
+
+	zone = page_zone(pfn_to_page(start_pfn));
+	ret = __remove_pages(zone, start_pfn, nr_pages);
+	if (ret)
+		pr_warn("%s: Problem encountered in __remove_pages() as"
+			" ret=%d\n", __func__,  ret);
+
+	return ret;
+}
+#endif
 #endif
 
 /*
diff -puN arch/powerpc/mm/mem.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/powerpc/mm/mem.c
@@ -133,6 +133,18 @@ int arch_add_memory(int nid, u64 start, 
 
 	return __add_pages(nid, zone, start_pfn, nr_pages);
 }
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int arch_remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct zone *zone;
+
+	zone = page_zone(pfn_to_page(start_pfn));
+	return __remove_pages(zone, start_pfn, nr_pages);
+}
+#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 /*
diff -puN arch/s390/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/s390/mm/init.c
@@ -228,4 +228,16 @@ int arch_add_memory(int nid, u64 start, 
 		vmem_remove_mapping(start, size);
 	return rc;
 }
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int arch_remove_memory(u64 start, u64 size)
+{
+	/*
+	 * There is no hardware or firmware interface which could trigger a
+	 * hot memory remove on s390. So there is nothing that needs to be
+	 * implemented.
+	 */
+	return -EBUSY;
+}
+#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff -puN arch/sh/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/sh/mm/init.c
@@ -558,4 +558,21 @@ int memory_add_physaddr_to_nid(u64 addr)
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int arch_remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct zone *zone;
+	int ret;
+
+	zone = page_zone(pfn_to_page(start_pfn));
+	ret = __remove_pages(zone, start_pfn, nr_pages);
+	if (unlikely(ret))
+		pr_warn("%s: Failed, __remove_pages() == %d\n", __func__,
+			ret);
+
+	return ret;
+}
+#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff -puN arch/tile/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/tile/mm/init.c
@@ -935,6 +935,14 @@ int remove_memory(u64 start, u64 size)
 {
 	return -EINVAL;
 }
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int arch_remove_memory(u64 start, u64 size)
+{
+	/* TODO */
+	return -EBUSY;
+}
+#endif
 #endif
 
 struct kmem_cache *pgd_cache;
diff -puN arch/x86/mm/init_32.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/x86/mm/init_32.c
@@ -862,6 +862,18 @@ int arch_add_memory(int nid, u64 start, 
 
 	return __add_pages(nid, zone, start_pfn, nr_pages);
 }
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int arch_remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct zone *zone;
+
+	zone = page_zone(pfn_to_page(start_pfn));
+	return __remove_pages(zone, start_pfn, nr_pages);
+}
+#endif
 #endif
 
 /*
diff -puN arch/x86/mm/init_64.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/arch/x86/mm/init_64.c
@@ -707,6 +707,21 @@ int arch_add_memory(int nid, u64 start, 
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int __ref arch_remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct zone *zone;
+	int ret;
+
+	zone = page_zone(pfn_to_page(start_pfn));
+	ret = __remove_pages(zone, start_pfn, nr_pages);
+	WARN_ON_ONCE(ret);
+
+	return ret;
+}
+#endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 static struct kcore_list kcore_vsyscall;
diff -puN include/linux/memory_hotplug.h~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/include/linux/memory_hotplug.h
@@ -96,6 +96,7 @@ extern void __online_page_free(struct pa
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
+extern int arch_remove_memory(u64 start, u64 size);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 /* reasonably generic interface to expand the physical pages in a zone  */
diff -puN mm/memory_hotplug.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table
+++ a/mm/memory_hotplug.c
@@ -1513,6 +1513,8 @@ repeat:
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
+	arch_remove_memory(start, size);
+
 	unlock_memory_hotplug();
 
 	return 0;
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

