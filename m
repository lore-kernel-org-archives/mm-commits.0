From: akpm@linux-foundation.org
Subject: + memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:33:48 -0800
Message-ID: <20130109233348.D3AB920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:53564 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:33:53 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so1798lbo.0
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:33:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wujianguo@huawei.com


The patch titled
     Subject: memory-hotplug: common APIs to support page tables hot-remove
has been added to the -mm tree.  Its filename is
     memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch

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
Subject: memory-hotplug: common APIs to support page tables hot-remove

When memory is removed, the corresponding pagetables should alse be
removed.  This patch introduces some common APIs to support vmemmap
pagetable and x86_64 architecture pagetable removing.

All pages of virtual mapping in removed memory cannot be freed if some
pages used as PGD/PUD includes not only removed memory but also other
memory.  So the patch uses the following way to check whether page can be
freed or not.

 1. When removing memory, the page structs of the removed memory are filled
    with 0FD.
 2. All page structs are filled with 0xFD on PT/PMD, PT/PMD can be cleared.
    In this case, the page used as PT/PMD can be freed.

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
 arch/x86/mm/init_64.c                |  299 +++++++++++++++++++++++++
 arch/x86/mm/pageattr.c               |   47 ++-
 include/linux/bootmem.h              |    1 
 4 files changed, 326 insertions(+), 22 deletions(-)

diff -puN arch/x86/include/asm/pgtable_types.h~memory-hotplug-common-apis-to-support-page-tables-hot-remove arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~memory-hotplug-common-apis-to-support-page-tables-hot-remove
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -352,6 +352,7 @@ static inline void update_page_count(int
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase);
 
 #endif	/* !__ASSEMBLY__ */
 
diff -puN arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove
+++ a/arch/x86/mm/init_64.c
@@ -682,6 +682,305 @@ int arch_add_memory(int nid, u64 start, 
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
+			if (!direct) {
+				free_pagetable(pte_page(*pte), 0);
+				pages++;
+			}
+
+			spin_lock(&init_mm.page_table_lock);
+			pte_clear(&init_mm, addr, pte);
+			spin_unlock(&init_mm.page_table_lock);
+		} else {
+			/*
+			 * If we are not removing the whole page, it means
+			 * other ptes in this page are being used and we canot
+			 * remove them. So fill the unused ptes with 0xFD, and
+			 * remove the page when it is wholly filled with 0xFD.
+			 */
+			memset((void *)addr, PAGE_INUSE, next - addr);
+			page_addr = page_address(pte_page(*pte));
+
+			if (!memchr_inv(page_addr, PAGE_INUSE, PAGE_SIZE)) {
+				free_pagetable(pte_page(*pte), 0);
+				pages++;
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
+	unsigned long pte_phys, next, pages = 0;
+	pte_t *pte_base;
+	pmd_t *pmd;
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
+				if (!direct) {
+					free_pagetable(pmd_page(*pmd),
+						       get_order(PMD_SIZE));
+					pages++;
+				}
+
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(pmd);
+				spin_unlock(&init_mm.page_table_lock);
+				continue;
+			}
+
+			/*
+			 * We use 2M page, but we need to remove part of them,
+			 * so split 2M page to 4K page.
+			 */
+			pte_base = (pte_t *)alloc_low_page(&pte_phys);
+			BUG_ON(!pte_base);
+			__split_large_page((pte_t *)pmd, addr,
+					   (pte_t *)pte_base);
+
+			spin_lock(&init_mm.page_table_lock);
+			pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
+			spin_unlock(&init_mm.page_table_lock);
+
+			flush_tlb_all();
+		}
+
+		pte_base = (pte_t *)map_low_page((pte_t *)pmd_page_vaddr(*pmd));
+		remove_pte_table(pte_base, addr, next, direct);
+		free_pte_table(pte_base, pmd);
+		unmap_low_page(pte_base);
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
+	unsigned long pmd_phys, next, pages = 0;
+	pmd_t *pmd_base;
+	pud_t *pud;
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
+				if (!direct) {
+					free_pagetable(pud_page(*pud),
+						       get_order(PUD_SIZE));
+					pages++;
+				}
+
+				spin_lock(&init_mm.page_table_lock);
+				pud_clear(pud);
+				spin_unlock(&init_mm.page_table_lock);
+				continue;
+			}
+
+			/*
+			 * We use 1G page, but we need to remove part of them,
+			 * so split 1G page to 2M page.
+			 */
+			pmd_base = (pmd_t *)alloc_low_page(&pmd_phys);
+			BUG_ON(!pmd_base);
+			__split_large_page((pte_t *)pud, addr,
+					   (pte_t *)pmd_base);
+
+			spin_lock(&init_mm.page_table_lock);
+			pud_populate(&init_mm, pud, __va(pmd_phys));
+			spin_unlock(&init_mm.page_table_lock);
+
+			flush_tlb_all();
+		}
+
+		pmd_base = (pmd_t *)map_low_page((pmd_t *)pud_page_vaddr(*pud));
+		remove_pmd_table(pmd_base, addr, next, direct);
+		free_pmd_table(pmd_base, pud);
+		unmap_low_page(pmd_base);
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
+		pgd = pgd_offset_k(start);
+		if (!pgd_present(*pgd))
+			continue;
+
+		next = pgd_addr_end(start, end);
+
+		pud = (pud_t *)map_low_page((pud_t *)pgd_page_vaddr(*pgd));
+		remove_pud_table(pud, start, next, direct);
+		if (free_pud_table(pud, pgd))
+			pgd_changed = true;
+		unmap_low_page(pud);
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
@@ -514,21 +514,13 @@ out_unlock:
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
@@ -536,10 +528,11 @@ static int split_large_page(pte_t *kpte,
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
@@ -611,17 +604,27 @@ static int split_large_page(pte_t *kpte,
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

