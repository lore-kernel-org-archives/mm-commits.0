From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:03 -0800
Message-ID: <20130225205004.109785A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42647 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3BYUuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:05 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so346708ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: common APIs to support page tables hot-remove
has been removed from the -mm tree.  Its filename was
     memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: common APIs to support page tables hot-remove

When memory is removed, the corresponding pagetables should alse be
removed.  This patch introduces some common APIs to support vmemmap
pagetable and x86_64 architecture direct mapping pagetable removing.

All pages of virtual mapping in removed memory cannot be freed if some
pages used as PGD/PUD include not only removed memory but also other
memory.  So this patch uses the following way to check whether a page can
be freed or not.

1) When removing memory, the page structs of the removed memory are
   filled with 0FD.

2) All page structs are filled with 0xFD on PT/PMD, PT/PMD can be
   cleared.  In this case, the page used as PT/PMD can be freed.

For direct mapping pages, update direct_pages_count[level] when we freed
their pagetables.  And do not free the pages again because they were freed
when offlining.

For vmemmap pages, free the pages and their pagetables.

For larger pages, do not split them into smaller ones because there is no
way to know if the larger page has been split.  As a result, there is no
way to decide when to split.  We deal the larger pages in the following
way:

1) For direct mapped pages, all the pages were freed when they were
   offlined.  And since menmory offline is done section by section, all
   the memory ranges being removed are aligned to PAGE_SIZE.  So only need
   to deal with unaligned pages when freeing vmemmap pages.

2) For vmemmap pages being used to store page_struct, if part of the
   larger page is still in use, just fill the unused part with 0xFD.  And
   when the whole page is fulfilled with 0xFD, then free the larger page.

[akpm@linux-foundation.org: fix typo in comment]
[tangchen@cn.fujitsu.com: do not calculate direct mapping pages when freeing vmemmap pagetables]
[tangchen@cn.fujitsu.com: do not free direct mapping pages twice]
[tangchen@cn.fujitsu.com: do not free page split from hugepage one by one]
[tangchen@cn.fujitsu.com: do not split pages when freeing pagetable pages]
[akpm@linux-foundation.org: use pmd_page_vaddr()]
[akpm@linux-foundation.org: fix used-uninitialised bug]
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

 arch/x86/include/asm/pgtable_types.h |    1 
 arch/x86/mm/init_64.c                |  304 +++++++++++++++++++++++++
 arch/x86/mm/pageattr.c               |   47 ++-
 include/linux/bootmem.h              |    1 
 4 files changed, 331 insertions(+), 22 deletions(-)

diff -puN arch/x86/include/asm/pgtable_types.h~memory-hotplug-common-apis-to-support-page-tables-hot-remove arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~memory-hotplug-common-apis-to-support-page-tables-hot-remove
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -351,6 +351,7 @@ static inline void update_page_count(int
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
diff -puN arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove
+++ a/arch/x86/mm/init_64.c
@@ -707,6 +707,310 @@ int arch_add_memory(int nid, u64 start, 
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
+#define PAGE_INUSE 0xFD
+
+static void __meminit free_pagetable(struct page *page, int order)
+{
+	struct zone *zone;
+	bool bootmem = false;
+	unsigned long magic;
+	unsigned int nr_pages = 1 << order;
+
+	/* bootmem page has reserved flag */
+	if (PageReserved(page)) {
+		__ClearPageReserved(page);
+		bootmem = true;
+
+		magic = (unsigned long)page->lru.next;
+		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
+			while (nr_pages--)
+				put_page_bootmem(page++);
+		} else
+			__free_pages_bootmem(page, order);
+	} else
+		free_pages((unsigned long)page_address(page), order);
+
+	/*
+	 * SECTION_INFO pages and MIX_SECTION_INFO pages
+	 * are all allocated by bootmem.
+	 */
+	if (bootmem) {
+		zone = page_zone(page);
+		zone_span_writelock(zone);
+		zone->present_pages += nr_pages;
+		zone_span_writeunlock(zone);
+		totalram_pages += nr_pages;
+	}
+}
+
+static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
+{
+	pte_t *pte;
+	int i;
+
+	for (i = 0; i < PTRS_PER_PTE; i++) {
+		pte = pte_start + i;
+		if (pte_val(*pte))
+			return;
+	}
+
+	/* free a pte talbe */
+	free_pagetable(pmd_page(*pmd), 0);
+	spin_lock(&init_mm.page_table_lock);
+	pmd_clear(pmd);
+	spin_unlock(&init_mm.page_table_lock);
+}
+
+static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
+{
+	pmd_t *pmd;
+	int i;
+
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		pmd = pmd_start + i;
+		if (pmd_val(*pmd))
+			return;
+	}
+
+	/* free a pmd talbe */
+	free_pagetable(pud_page(*pud), 0);
+	spin_lock(&init_mm.page_table_lock);
+	pud_clear(pud);
+	spin_unlock(&init_mm.page_table_lock);
+}
+
+/* Return true if pgd is changed, otherwise return false. */
+static bool __meminit free_pud_table(pud_t *pud_start, pgd_t *pgd)
+{
+	pud_t *pud;
+	int i;
+
+	for (i = 0; i < PTRS_PER_PUD; i++) {
+		pud = pud_start + i;
+		if (pud_val(*pud))
+			return false;
+	}
+
+	/* free a pud table */
+	free_pagetable(pgd_page(*pgd), 0);
+	spin_lock(&init_mm.page_table_lock);
+	pgd_clear(pgd);
+	spin_unlock(&init_mm.page_table_lock);
+
+	return true;
+}
+
+static void __meminit
+remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
+		 bool direct)
+{
+	unsigned long next, pages = 0;
+	pte_t *pte;
+	void *page_addr;
+	phys_addr_t phys_addr;
+
+	pte = pte_start + pte_index(addr);
+	for (; addr < end; addr = next, pte++) {
+		next = (addr + PAGE_SIZE) & PAGE_MASK;
+		if (next > end)
+			next = end;
+
+		if (!pte_present(*pte))
+			continue;
+
+		/*
+		 * We mapped [0,1G) memory as identity mapping when
+		 * initializing, in arch/x86/kernel/head_64.S. These
+		 * pagetables cannot be removed.
+		 */
+		phys_addr = pte_val(*pte) + (addr & PAGE_MASK);
+		if (phys_addr < (phys_addr_t)0x40000000)
+			return;
+
+		if (IS_ALIGNED(addr, PAGE_SIZE) &&
+		    IS_ALIGNED(next, PAGE_SIZE)) {
+			/*
+			 * Do not free direct mapping pages since they were
+			 * freed when offlining, or simplely not in use.
+			 */
+			if (!direct)
+				free_pagetable(pte_page(*pte), 0);
+
+			spin_lock(&init_mm.page_table_lock);
+			pte_clear(&init_mm, addr, pte);
+			spin_unlock(&init_mm.page_table_lock);
+
+			/* For non-direct mapping, pages means nothing. */
+			pages++;
+		} else {
+			/*
+			 * If we are here, we are freeing vmemmap pages since
+			 * direct mapped memory ranges to be freed are aligned.
+			 *
+			 * If we are not removing the whole page, it means
+			 * other page structs in this page are being used and
+			 * we canot remove them. So fill the unused page_structs
+			 * with 0xFD, and remove the page when it is wholly
+			 * filled with 0xFD.
+			 */
+			memset((void *)addr, PAGE_INUSE, next - addr);
+
+			page_addr = page_address(pte_page(*pte));
+			if (!memchr_inv(page_addr, PAGE_INUSE, PAGE_SIZE)) {
+				free_pagetable(pte_page(*pte), 0);
+
+				spin_lock(&init_mm.page_table_lock);
+				pte_clear(&init_mm, addr, pte);
+				spin_unlock(&init_mm.page_table_lock);
+			}
+		}
+	}
+
+	/* Call free_pte_table() in remove_pmd_table(). */
+	flush_tlb_all();
+	if (direct)
+		update_page_count(PG_LEVEL_4K, -pages);
+}
+
+static void __meminit
+remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
+		 bool direct)
+{
+	unsigned long next, pages = 0;
+	pte_t *pte_base;
+	pmd_t *pmd;
+	void *page_addr;
+
+	pmd = pmd_start + pmd_index(addr);
+	for (; addr < end; addr = next, pmd++) {
+		next = pmd_addr_end(addr, end);
+
+		if (!pmd_present(*pmd))
+			continue;
+
+		if (pmd_large(*pmd)) {
+			if (IS_ALIGNED(addr, PMD_SIZE) &&
+			    IS_ALIGNED(next, PMD_SIZE)) {
+				if (!direct)
+					free_pagetable(pmd_page(*pmd),
+						       get_order(PMD_SIZE));
+
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(pmd);
+				spin_unlock(&init_mm.page_table_lock);
+				pages++;
+			} else {
+				/* If here, we are freeing vmemmap pages. */
+				memset((void *)addr, PAGE_INUSE, next - addr);
+
+				page_addr = page_address(pmd_page(*pmd));
+				if (!memchr_inv(page_addr, PAGE_INUSE,
+						PMD_SIZE)) {
+					free_pagetable(pmd_page(*pmd),
+						       get_order(PMD_SIZE));
+
+					spin_lock(&init_mm.page_table_lock);
+					pmd_clear(pmd);
+					spin_unlock(&init_mm.page_table_lock);
+				}
+			}
+
+			continue;
+		}
+
+		pte_base = (pte_t *)pmd_page_vaddr(*pmd);
+		remove_pte_table(pte_base, addr, next, direct);
+		free_pte_table(pte_base, pmd);
+	}
+
+	/* Call free_pmd_table() in remove_pud_table(). */
+	if (direct)
+		update_page_count(PG_LEVEL_2M, -pages);
+}
+
+static void __meminit
+remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
+		 bool direct)
+{
+	unsigned long next, pages = 0;
+	pmd_t *pmd_base;
+	pud_t *pud;
+	void *page_addr;
+
+	pud = pud_start + pud_index(addr);
+	for (; addr < end; addr = next, pud++) {
+		next = pud_addr_end(addr, end);
+
+		if (!pud_present(*pud))
+			continue;
+
+		if (pud_large(*pud)) {
+			if (IS_ALIGNED(addr, PUD_SIZE) &&
+			    IS_ALIGNED(next, PUD_SIZE)) {
+				if (!direct)
+					free_pagetable(pud_page(*pud),
+						       get_order(PUD_SIZE));
+
+				spin_lock(&init_mm.page_table_lock);
+				pud_clear(pud);
+				spin_unlock(&init_mm.page_table_lock);
+				pages++;
+			} else {
+				/* If here, we are freeing vmemmap pages. */
+				memset((void *)addr, PAGE_INUSE, next - addr);
+
+				page_addr = page_address(pud_page(*pud));
+				if (!memchr_inv(page_addr, PAGE_INUSE,
+						PUD_SIZE)) {
+					free_pagetable(pud_page(*pud),
+						       get_order(PUD_SIZE));
+
+					spin_lock(&init_mm.page_table_lock);
+					pud_clear(pud);
+					spin_unlock(&init_mm.page_table_lock);
+				}
+			}
+
+			continue;
+		}
+
+		pmd_base = (pmd_t *)pud_page_vaddr(*pud);
+		remove_pmd_table(pmd_base, addr, next, direct);
+		free_pmd_table(pmd_base, pud);
+	}
+
+	if (direct)
+		update_page_count(PG_LEVEL_1G, -pages);
+}
+
+/* start and end are both virtual address. */
+static void __meminit
+remove_pagetable(unsigned long start, unsigned long end, bool direct)
+{
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	bool pgd_changed = false;
+
+	for (; start < end; start = next) {
+		next = pgd_addr_end(start, end);
+
+		pgd = pgd_offset_k(start);
+		if (!pgd_present(*pgd))
+			continue;
+
+		pud = (pud_t *)pgd_page_vaddr(*pgd);
+		remove_pud_table(pud, start, next, direct);
+		if (free_pud_table(pud, pgd))
+			pgd_changed = true;
+	}
+
+	if (pgd_changed)
+		sync_global_pgds(start, end - 1);
+
+	flush_tlb_all();
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
diff -puN arch/x86/mm/pageattr.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove
+++ a/arch/x86/mm/pageattr.c
@@ -529,21 +529,13 @@ out_unlock:
 	return do_split;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
 {
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
-	pte_t *pbase, *tmp;
+	pte_t *tmp;
 	pgprot_t ref_prot;
-	struct page *base;
-
-	if (!debug_pagealloc)
-		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
-		spin_lock(&cpa_lock);
-	if (!base)
-		return -ENOMEM;
+	struct page *base = virt_to_page(pbase);
 
 	spin_lock(&pgd_lock);
 	/*
@@ -551,10 +543,11 @@ static int split_large_page(pte_t *kpte,
 	 * up for us already:
 	 */
 	tmp = lookup_address(address, &level);
-	if (tmp != kpte)
-		goto out_unlock;
+	if (tmp != kpte) {
+		spin_unlock(&pgd_lock);
+		return 1;
+	}
 
-	pbase = (pte_t *)page_address(base);
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
 	/*
@@ -601,17 +594,27 @@ static int split_large_page(pte_t *kpte,
 	 * going on.
 	 */
 	__flush_tlb_all();
+	spin_unlock(&pgd_lock);
 
-	base = NULL;
+	return 0;
+}
 
-out_unlock:
-	/*
-	 * If we dropped out via the lookup_address check under
-	 * pgd_lock then stick the page back into the pool:
-	 */
-	if (base)
+static int split_large_page(pte_t *kpte, unsigned long address)
+{
+	pte_t *pbase;
+	struct page *base;
+
+	if (!debug_pagealloc)
+		spin_unlock(&cpa_lock);
+	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
+	if (!debug_pagealloc)
+		spin_lock(&cpa_lock);
+	if (!base)
+		return -ENOMEM;
+
+	pbase = (pte_t *)page_address(base);
+	if (__split_large_page(kpte, address, pbase))
 		__free_page(base);
-	spin_unlock(&pgd_lock);
 
 	return 0;
 }
diff -puN include/linux/bootmem.h~memory-hotplug-common-apis-to-support-page-tables-hot-remove include/linux/bootmem.h
--- a/include/linux/bootmem.h~memory-hotplug-common-apis-to-support-page-tables-hot-remove
+++ a/include/linux/bootmem.h
@@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t 
 			      unsigned long size);
 extern void free_bootmem(unsigned long physaddr, unsigned long size);
 extern void free_bootmem_late(unsigned long physaddr, unsigned long size);
+extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

