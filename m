From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-remove-memmap-of-sparse-vmemmap.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:11 -0800
Message-ID: <20130225205011.D108F31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:63020 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab3BYUuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:14 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so141697yen.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mhocko@suse.cz, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove memmap of sparse-vmemmap
has been removed from the -mm tree.  Its filename was
     memory-hotplug-remove-memmap-of-sparse-vmemmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: remove memmap of sparse-vmemmap

Introduce a new API vmemmap_free() to free and remove vmemmap pagetables. 
Since pagetable implements are different, each architecture has to provide
its own version of vmemmap_free(), just like vmemmap_populate().

Note:  vmemmap_free() is not implemented for ia64, ppc, s390, and sparc.

[mhocko@suse.cz: fix implicit declaration of remove_pagetable]
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c       |    3 +++
 arch/ia64/mm/discontig.c  |    3 +++
 arch/powerpc/mm/init_64.c |    4 ++++
 arch/s390/mm/vmem.c       |    4 ++++
 arch/sparc/mm/init_64.c   |    4 ++++
 arch/x86/mm/init_64.c     |    8 ++++++++
 include/linux/mm.h        |    3 +++
 mm/sparse.c               |    3 ++-
 8 files changed, 31 insertions(+), 1 deletion(-)

diff -puN arch/arm64/mm/mmu.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/arm64/mm/mmu.c
@@ -434,4 +434,7 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 #endif	/* CONFIG_ARM64_64K_PAGES */
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
 #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
diff -puN arch/ia64/mm/discontig.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/ia64/mm/discontig.c
@@ -823,4 +823,7 @@ int __meminit vmemmap_populate(struct pa
 	return vmemmap_populate_basepages(start_page, size, node);
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
 #endif
diff -puN arch/powerpc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/powerpc/mm/init_64.c
@@ -298,5 +298,9 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff -puN arch/s390/mm/vmem.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/s390/mm/vmem.c
@@ -268,6 +268,10 @@ out:
 	return ret;
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 /*
  * Add memory segment to the segment list if it doesn't overlap with
  * an already present segment.
diff -puN arch/sparc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/sparc/mm/init_64.c
@@ -2236,6 +2236,10 @@ void __meminit vmemmap_populate_print_la
 	}
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
diff -puN arch/x86/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/x86/mm/init_64.c
@@ -1011,6 +1011,14 @@ remove_pagetable(unsigned long start, un
 	flush_tlb_all();
 }
 
+void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + nr_pages);
+
+	remove_pagetable(start, end, false);
+}
+
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
diff -puN include/linux/mm.h~memory-hotplug-remove-memmap-of-sparse-vmemmap include/linux/mm.h
--- a/include/linux/mm.h~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/include/linux/mm.h
@@ -1718,6 +1718,9 @@ int vmemmap_populate_basepages(struct pa
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
+#ifdef CONFIG_MEMORY_HOTPLUG
+void vmemmap_free(struct page *memmap, unsigned long nr_pages);
+#endif
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long size);
 
diff -puN mm/sparse.c~memory-hotplug-remove-memmap-of-sparse-vmemmap mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/mm/sparse.c
@@ -615,10 +615,11 @@ static inline struct page *kmalloc_secti
 }
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
-	return; /* XXX: Not implemented yet */
+	vmemmap_free(memmap, nr_pages);
 }
 static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
+	vmemmap_free(memmap, nr_pages);
 }
 #else
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

