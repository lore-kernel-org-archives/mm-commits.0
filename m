From: akpm@linux-foundation.org
Subject: + memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:36 -0800
Message-ID: <20130109233337.02810200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46925 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3AIXdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:33:41 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so146203wey.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: implement register_page_bootmem_info_section of sparse-vmemmap
has been added to the -mm tree.  Its filename is
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug: implement register_page_bootmem_info_section of sparse-vmemmap

For removing memmap region of sparse-vmemmap which is allocated bootmem,
memmap region of sparse-vmemmap needs to be registered by
get_page_bootmem().  So the patch searches pages of virtual mapping and
registers the pages by get_page_bootmem().

Note: register_page_bootmem_memmap() is not implemented for ia64, ppc, s390,
and sparc.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wu Jianguo <wujianguo@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c       |    6 +++
 arch/powerpc/mm/init_64.c      |    6 +++
 arch/s390/mm/vmem.c            |    6 +++
 arch/sparc/mm/init_64.c        |    6 +++
 arch/x86/mm/init_64.c          |   58 +++++++++++++++++++++++++++++++
 include/linux/memory_hotplug.h |   11 +----
 include/linux/mm.h             |    3 +
 mm/memory_hotplug.c            |   33 +++++++++++++++--
 8 files changed, 115 insertions(+), 14 deletions(-)

diff -puN arch/ia64/mm/discontig.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/arch/ia64/mm/discontig.c
@@ -822,4 +822,10 @@ int __meminit vmemmap_populate(struct pa
 {
 	return vmemmap_populate_basepages(start_page, size, node);
 }
+
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	/* TODO */
+}
 #endif
diff -puN arch/powerpc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/arch/powerpc/mm/init_64.c
@@ -297,5 +297,11 @@ int __meminit vmemmap_populate(struct pa
 
 	return 0;
 }
+
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	/* TODO */
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff -puN arch/s390/mm/vmem.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/arch/s390/mm/vmem.c
@@ -272,6 +272,12 @@ out:
 	return ret;
 }
 
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	/* TODO */
+}
+
 /*
  * Add memory segment to the segment list if it doesn't overlap with
  * an already present segment.
diff -puN arch/sparc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/arch/sparc/mm/init_64.c
@@ -2231,6 +2231,12 @@ void __meminit vmemmap_populate_print_la
 		node_start = 0;
 	}
 }
+
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	/* TODO */
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
diff -puN arch/x86/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/arch/x86/mm/init_64.c
@@ -1000,6 +1000,64 @@ vmemmap_populate(struct page *start_page
 	return 0;
 }
 
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	unsigned int nr_pages;
+	struct page *page;
+
+	for (; addr < end; addr = next) {
+		pte_t *pte = NULL;
+
+		pgd = pgd_offset_k(addr);
+		if (pgd_none(*pgd)) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			continue;
+		}
+		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
+
+		pud = pud_offset(pgd, addr);
+		if (pud_none(*pud)) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			continue;
+		}
+		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
+
+		if (!cpu_has_pse) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			pmd = pmd_offset(pud, addr);
+			if (pmd_none(*pmd))
+				continue;
+			get_page_bootmem(section_nr, pmd_page(*pmd),
+					 MIX_SECTION_INFO);
+
+			pte = pte_offset_kernel(pmd, addr);
+			if (pte_none(*pte))
+				continue;
+			get_page_bootmem(section_nr, pte_page(*pte),
+					 SECTION_INFO);
+		} else {
+			next = pmd_addr_end(addr, end);
+
+			pmd = pmd_offset(pud, addr);
+			if (pmd_none(*pmd))
+				continue;
+
+			nr_pages = 1 << (get_order(PMD_SIZE));
+			page = pmd_page(*pmd);
+			while (nr_pages--)
+				get_page_bootmem(section_nr, page++,
+						 SECTION_INFO);
+		}
+	}
+}
+
 void __meminit vmemmap_populate_print_last(void)
 {
 	if (p_start) {
diff -puN include/linux/memory_hotplug.h~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/include/linux/memory_hotplug.h
@@ -174,17 +174,10 @@ static inline void arch_refresh_nodedata
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-static inline void put_page_bootmem(struct page *page)
-{
-}
-#else
 extern void register_page_bootmem_info_node(struct pglist_data *pgdat);
 extern void put_page_bootmem(struct page *page);
-#endif
+extern void get_page_bootmem(unsigned long ingo, struct page *page,
+			     unsigned long type);
 
 /*
  * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug
diff -puN include/linux/mm.h~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap include/linux/mm.h
--- a/include/linux/mm.h~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/include/linux/mm.h
@@ -1720,7 +1720,8 @@ int vmemmap_populate_basepages(struct pa
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
-
+void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
+				  unsigned long size);
 
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
diff -puN mm/memory_hotplug.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap
+++ a/mm/memory_hotplug.c
@@ -91,9 +91,8 @@ static void release_memory_resource(stru
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void get_page_bootmem(unsigned long info,  struct page *page,
-			     unsigned long type)
+void get_page_bootmem(unsigned long info,  struct page *page,
+		      unsigned long type)
 {
 	page->lru.next = (struct list_head *) type;
 	SetPagePrivate(page);
@@ -128,6 +127,7 @@ void __ref put_page_bootmem(struct page 
 
 }
 
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 static void register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long *usemap, mapsize, section_nr, i;
@@ -161,6 +161,32 @@ static void register_page_bootmem_info_s
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 
 }
+#else
+static void register_page_bootmem_info_section(unsigned long start_pfn)
+{
+	unsigned long *usemap, mapsize, section_nr, i;
+	struct mem_section *ms;
+	struct page *page, *memmap;
+
+	if (!pfn_valid(start_pfn))
+		return;
+
+	section_nr = pfn_to_section_nr(start_pfn);
+	ms = __nr_to_section(section_nr);
+
+	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+
+	register_page_bootmem_memmap(section_nr, memmap, PAGES_PER_SECTION);
+
+	usemap = __nr_to_section(section_nr)->pageblock_flags;
+	page = virt_to_page(usemap);
+
+	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
+
+	for (i = 0; i < mapsize; i++, page++)
+		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
+}
+#endif
 
 void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
@@ -203,7 +229,6 @@ void register_page_bootmem_info_node(str
 			register_page_bootmem_info_section(pfn);
 	}
 }
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 			   unsigned long end_pfn)
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

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
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

