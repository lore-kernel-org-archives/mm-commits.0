From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-memmap-of-sparse-vmemmap.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:34:06 -0800
Message-ID: <20130109233407.823FA200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64831 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:34:11 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so146173eei.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:34:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: remove memmap of sparse-vmemmap
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-memmap-of-sparse-vmemmap.patch

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
Subject: memory-hotplug: remove memmap of sparse-vmemmap

Introduce a new API vmemmap_free() to free and remove vmemmap pagetables. 
Since pagetable implements are different, each architecture has to provide
its own version of vmemmap_free(), just like vmemmap_populate().

Note:  vmemmap_free() is not implemented for ia64, ppc, s390, and sparc.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c       |    3 +++
 arch/ia64/mm/discontig.c  |    4 ++++
 arch/powerpc/mm/init_64.c |    4 ++++
 arch/s390/mm/vmem.c       |    4 ++++
 arch/sparc/mm/init_64.c   |    4 ++++
 arch/x86/mm/init_64.c     |    8 ++++++++
 include/linux/mm.h        |    1 +
 mm/sparse.c               |    3 ++-
 8 files changed, 30 insertions(+), 1 deletion(-)

diff -puN arch/arm64/mm/mmu.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/arm64/mm/mmu.c
@@ -392,4 +392,7 @@ int __meminit vmemmap_populate(struct pa
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
@@ -823,6 +823,10 @@ int __meminit vmemmap_populate(struct pa
 	return vmemmap_populate_basepages(start_page, size, node);
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff -puN arch/powerpc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/powerpc/mm/init_64.c
@@ -298,6 +298,10 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff -puN arch/s390/mm/vmem.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/s390/mm/vmem.c
@@ -272,6 +272,10 @@ out:
 	return ret;
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff -puN arch/sparc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/sparc/mm/init_64.c
@@ -2232,6 +2232,10 @@ void __meminit vmemmap_populate_print_la
 	}
 }
 
+void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+}
+
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff -puN arch/x86/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/arch/x86/mm/init_64.c
@@ -1309,6 +1309,14 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }
 
+void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + nr_pages);
+
+	remove_pagetable(start, end, false);
+}
+
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff -puN include/linux/mm.h~memory-hotplug-remove-memmap-of-sparse-vmemmap include/linux/mm.h
--- a/include/linux/mm.h~memory-hotplug-remove-memmap-of-sparse-vmemmap
+++ a/include/linux/mm.h
@@ -1720,6 +1720,7 @@ int vmemmap_populate_basepages(struct pa
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
+void vmemmap_free(struct page *memmap, unsigned long nr_pages);
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

