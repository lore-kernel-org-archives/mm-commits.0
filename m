From: akpm@linux-foundation.org
Subject: - x86-fix-change_page_attr-tlb-and-cache-flushing.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:13:22 -0700
Message-ID: <200706231913.l5NJDMIN021782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbXFWTNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix change_page_attr() TLB and cache flushing
has been removed from the -mm tree.  Its filename was
     x86-fix-change_page_attr-tlb-and-cache-flushing.patch

This patch was dropped because changes in Andi's tree destroyed it

------------------------------------------------------
Subject: x86: fix change_page_attr() TLB and cache flushing
From: "Jan Beulich" <jbeulich@novell.com>

change_page_attr() failed to flush the caches for the affected pages for quite
a while, and on x86-64 only recently got a brute-force fix to flush the entire
TLB (which now gets reduced to just the affected pages when possible).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/ioremap.c       |    4 
 arch/i386/mm/pageattr.c      |  181 +++++++++++++++++++++--------
 arch/x86_64/mm/ioremap.c     |    6 
 arch/x86_64/mm/pageattr.c    |  202 +++++++++++++++++++++++----------
 include/asm-i386/page.h      |   10 +
 include/asm-i386/pgtable.h   |    3 
 include/asm-x86_64/page.h    |    2 
 include/asm-x86_64/pgtable.h |    4 
 include/asm-x86_64/system.h  |    2 
 9 files changed, 292 insertions(+), 122 deletions(-)

diff -puN arch/i386/mm/ioremap.c~x86-fix-change_page_attr-tlb-and-cache-flushing arch/i386/mm/ioremap.c
--- a/arch/i386/mm/ioremap.c~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/arch/i386/mm/ioremap.c
@@ -193,10 +193,10 @@ void iounmap(volatile void __iomem *addr
 		return;
 	}
 
-	/* Reset the direct mapping. Can block */
+	/* Reset the direct mapping. Can block. Heed the trailing guard page. */
 	if ((p->flags >> 20) && p->phys_addr < virt_to_phys(high_memory) - 1) {
 		change_page_attr(virt_to_page(__va(p->phys_addr)),
-				 p->size >> PAGE_SHIFT,
+				 (p->size >> PAGE_SHIFT) - 1,
 				 PAGE_KERNEL);
 		global_flush_tlb();
 	} 
diff -puN arch/i386/mm/pageattr.c~x86-fix-change_page_attr-tlb-and-cache-flushing arch/i386/mm/pageattr.c
--- a/arch/i386/mm/pageattr.c~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/arch/i386/mm/pageattr.c
@@ -16,7 +16,29 @@
 
 static DEFINE_SPINLOCK(cpa_lock);
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
+static struct df_info {
+	unsigned long address;
+	int count;
+} deferred[2];
+#define TLB 0
+#define CACHE 1
 
+static inline void update_deferred(struct df_info *df,
+				   unsigned long address, int count)
+{
+	if (df->count == 0) {
+		df->address = address;
+		df->count = count;
+	} else if (df->count > 0) {
+		if (df->address + (df->count << PAGE_SHIFT) == address)
+			df->count += count;
+		else if (address + (count << PAGE_SHIFT) == df->address) {
+			df->address = address;
+			df->count += count;
+		} else
+			df->count = -1;
+	}
+}
 
 pte_t *lookup_address(unsigned long address) 
 { 
@@ -70,19 +92,29 @@ static struct page *split_large_page(uns
 
 static void flush_kernel_map(void *arg)
 { 
-	unsigned long adr = (unsigned long)arg;
-
-	if (adr && cpu_has_clflush) {
-		int i;
-		for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
-			asm volatile("clflush (%0)" :: "r" (adr + i));
-	} else if (boot_cpu_data.x86_model >= 4)
-		wbinvd();
+	const struct df_info *info = arg;
 
 	/* Flush all to work around Errata in early athlons regarding 
 	 * large page flushing. 
 	 */
 	__flush_tlb_all(); 	
+
+	if (info[CACHE].count != 0 && boot_cpu_data.x86_model >= 4) {
+		if (info[CACHE].count < 0)
+			wbinvd();
+		else {
+			unsigned long addr = info[CACHE].address;
+			int count = info[CACHE].count;
+
+			while (count-- > 0) {
+				int i;
+
+				for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+					asm volatile("clflush (%0)" :: "r" (addr + i));
+				addr += PAGE_SIZE;
+			}
+		}
+	}
 }
 
 static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte) 
@@ -107,32 +139,39 @@ static void set_pmd_pte(pte_t *kpte, uns
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
+static pgprot_t _ref_prot[KERNEL_PGD_PTRS * PTRS_PER_PMD];
+#define ref_prot(addr) _ref_prot[__pa(addr) >> PMD_SHIFT]
+
 /* 
  * No more special protections in this 2/4MB area - revert to a
  * large page again. 
  */
 static inline void revert_page(struct page *kpte_page, unsigned long address)
 {
-	pgprot_t ref_prot;
 	pte_t *linear;
 
-	ref_prot =
-	((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
-		? PAGE_KERNEL_LARGE_EXEC : PAGE_KERNEL_LARGE;
-
 	linear = (pte_t *)
 		pmd_offset(pud_offset(pgd_offset_k(address), address), address);
 	set_pmd_pte(linear,  address,
-		    pfn_pte((__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT,
-			    ref_prot));
+		    pte_mkhuge(pfn_pte((__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT,
+				       ref_prot(address))));
 }
 
-static int
-__change_page_attr(struct page *page, pgprot_t prot)
+static inline int pgprot_match(pgprot_t prot1, pgprot_t prot2)
+{
+	return !((pgprot_val(prot1) ^ pgprot_val(prot2))
+#ifdef CONFIG_X86_PAE
+		 & __supported_pte_mask
+#endif
+		 & ~(_PAGE_ACCESSED|_PAGE_DIRTY));
+}
+
+static int __change_page_attr(struct page *page, pgprot_t prot)
 { 
 	pte_t *kpte; 
 	unsigned long address;
 	struct page *kpte_page;
+	pgprot_t old_prot, ref_prot;
 
 	BUG_ON(PageHighMem(page));
 	address = (unsigned long)page_address(page);
@@ -141,37 +180,55 @@ __change_page_attr(struct page *page, pg
 	if (!kpte)
 		return -EINVAL;
 	kpte_page = virt_to_page(kpte);
-	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
+	old_prot = pte_pgprot(pte_clrhuge(*kpte));
+	ref_prot = ref_prot(address);
+	if (!pgprot_match(prot, ref_prot)) {
 		if (!pte_huge(*kpte)) {
 			set_pte_atomic(kpte, mk_pte(page, prot)); 
 		} else {
-			pgprot_t ref_prot;
-			struct page *split;
-
-			ref_prot =
-			((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
-				? PAGE_KERNEL_EXEC : PAGE_KERNEL;
-			split = split_large_page(address, prot, ref_prot);
-			if (!split)
+			BUG_ON(!pgprot_match(old_prot, ref_prot));
+			kpte_page = split_large_page(address, prot, ref_prot);
+			if (!kpte_page)
 				return -ENOMEM;
-			set_pmd_pte(kpte,address,mk_pte(split, ref_prot));
-			kpte_page = split;
+			set_pmd_pte(kpte, address,
+				    mk_pte(kpte_page, PAGE_KERNEL_EXEC));
+		}
+		if (!PageReserved(kpte_page)
+		    && pgprot_match(old_prot, ref_prot))
+			page_private(kpte_page)++;
+	} else if (!pgprot_match(ref_prot, old_prot)) {
+		BUG_ON(pte_huge(*kpte));
+		set_pte_atomic(kpte, mk_pte(page, ref_prot));
+		if (!PageReserved(kpte_page)) {
+			BUG_ON(page_private(kpte_page) == 0);
+			page_private(kpte_page)--;
 		}
-		page_private(kpte_page)++;
-	} else if (!pte_huge(*kpte)) {
-		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
-		BUG_ON(page_private(kpte_page) == 0);
-		page_private(kpte_page)--;
 	} else
-		BUG();
+		return 0;
+
+	if ((pgprot_val(prot) ^ pgprot_val(old_prot)) & (_PAGE_PCD|_PAGE_PWT)) {
+		if (!cpu_has_clflush || !pte_present(pfn_pte(0, prot)))
+			deferred[CACHE].count = -1;
+		else
+			update_deferred(deferred + CACHE, address, 1);
+	}
 
 	/*
 	 * If the pte was reserved, it means it was created at boot
 	 * time (not via split_large_page) and in turn we must not
 	 * replace it with a largepage.
 	 */
-	if (!PageReserved(kpte_page)) {
-		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
+	if (!PageReserved(kpte_page) && cpu_has_pse) {
+		if (page_private(kpte_page) == PTRS_PER_PTE) {
+			unsigned i;
+
+			kpte = page_address(kpte_page);
+			for (i = 0; i < PTRS_PER_PTE; ++i, ++kpte)
+				if (pgprot_match(pte_pgprot(*kpte), prot))
+					page_private(kpte_page)--;
+			ref_prot(address) = prot;
+		}
+		if (page_private(kpte_page) == 0) {
 			ClearPagePrivate(kpte_page);
 			paravirt_release_pt(page_to_pfn(kpte_page));
 			list_add(&kpte_page->lru, &df_list);
@@ -181,13 +238,8 @@ __change_page_attr(struct page *page, pg
 	return 0;
 } 
 
-static inline void flush_map(void *adr)
-{
-	on_each_cpu(flush_kernel_map, adr, 1, 1);
-}
-
 /*
- * Change the page attributes of an page in the linear mapping.
+ * Change the page attributes of a page in the linear mapping.
  *
  * This should be used when a page is mapped with a different caching policy
  * than write-back somewhere - some CPUs do not like it when mappings with
@@ -204,34 +256,59 @@ int change_page_attr(struct page *page, 
 	int err = 0; 
 	int i; 
 	unsigned long flags;
+	struct list_head l;
+	struct page *next;
+	static char first = 1;
 
 	spin_lock_irqsave(&cpa_lock, flags);
+
+	if (unlikely(first)) {
+		unsigned long addr = PAGE_OFFSET & PMD_MASK;
+
+		/* This must match is_kernel_text(). */
+		for (; addr <= (unsigned long)__init_end; addr += PMD_SIZE)
+			ref_prot(addr) = PAGE_KERNEL_EXEC;
+		for (; addr > PAGE_OFFSET; addr += PMD_SIZE)
+			ref_prot(addr) = PAGE_KERNEL;
+		first = 0;
+	}
+
+	/* No need to call update_deferred() as long flush_kernel_map()
+	 * uses __flush_tlb_all(). */
+	deferred[TLB].count = -1;
+
 	for (i = 0; i < numpages; i++, page++) { 
 		err = __change_page_attr(page, prot);
 		if (err) 
 			break; 
 	} 	
+
+	list_replace_init(&df_list, &l);
+
 	spin_unlock_irqrestore(&cpa_lock, flags);
+
+	list_for_each_entry_safe(page, next, &l, lru)
+		__free_page(page);
+
 	return err;
 }
 
 void global_flush_tlb(void)
 {
-	struct list_head l;
-	struct page *pg, *next;
+	unsigned i;
+	struct df_info info[ARRAY_SIZE(deferred)];
 
 	BUG_ON(irqs_disabled());
 
 	spin_lock_irq(&cpa_lock);
-	list_replace_init(&df_list, &l);
-	spin_unlock_irq(&cpa_lock);
-	if (!cpu_has_clflush)
-		flush_map(NULL);
-	list_for_each_entry_safe(pg, next, &l, lru) {
-		if (cpu_has_clflush)
-			flush_map(page_address(pg));
-		__free_page(pg);
+	for (i = 0; i < ARRAY_SIZE(info); ++i) {
+		info[i] = deferred[i];
+		deferred[i].count = 0;
 	}
+	spin_unlock_irq(&cpa_lock);
+
+	if (info[TLB].count)
+		on_each_cpu(flush_kernel_map, info, 1, 1);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
diff -puN arch/x86_64/mm/ioremap.c~x86-fix-change_page_attr-tlb-and-cache-flushing arch/x86_64/mm/ioremap.c
--- a/arch/x86_64/mm/ioremap.c~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/arch/x86_64/mm/ioremap.c
@@ -48,7 +48,7 @@ ioremap_change_attr(unsigned long phys_a
  		 * Must use a address here and not struct page because the phys addr
 		 * can be a in hole between nodes and not have an memmap entry.
 		 */
-		err = change_page_attr_addr(vaddr,npages,__pgprot(__PAGE_KERNEL|flags));
+		err = change_page_attr_addr(vaddr,npages,MAKE_GLOBAL(__PAGE_KERNEL|flags));
 		if (!err)
 			global_flush_tlb();
 	}
@@ -197,9 +197,9 @@ void iounmap(volatile void __iomem *addr
 		return;
 	}
 
-	/* Reset the direct mapping. Can block */
+	/* Reset the direct mapping. Can block. Heed the trailing guard page. */
 	if (p->flags >> 20)
-		ioremap_change_attr(p->phys_addr, p->size, 0);
+		ioremap_change_attr(p->phys_addr, p->size - PAGE_SIZE, 0);
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
diff -puN arch/x86_64/mm/pageattr.c~x86-fix-change_page_attr-tlb-and-cache-flushing arch/x86_64/mm/pageattr.c
--- a/arch/x86_64/mm/pageattr.c~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/arch/x86_64/mm/pageattr.c
@@ -61,7 +61,31 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-static void cache_flush_page(void *adr)
+struct deferred_info {
+	unsigned long address;
+	int count;
+};
+#define TLB 0
+#define CACHE 1
+
+static inline void update_deferred(struct deferred_info *df,
+				   unsigned long address, int count)
+{
+	if (df->count == 0) {
+		df->address = address;
+		df->count = count;
+	} else if (df->count > 0) {
+		if (df->address + (df->count << PAGE_SHIFT) == address)
+			df->count += count;
+		else if (address + (count << PAGE_SHIFT) == df->address) {
+			df->address = address;
+			df->count += count;
+		} else
+			df->count = -1;
+	}
+}
+
+static inline void cache_flush_page(unsigned long adr)
 {
 	int i;
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
@@ -70,38 +94,60 @@ static void cache_flush_page(void *adr)
 
 static void flush_kernel_map(void *arg)
 {
-	struct list_head *l = (struct list_head *)arg;
-	struct page *pg;
+	const struct deferred_info *info = arg;
+
+	if (info[TLB].count < 0)
+		__flush_tlb_all();
+	else {
+		unsigned long addr = info[TLB].address;
+		int count = info[TLB].count;
+
+		while (count-- > 0) {
+			__flush_tlb_one(addr);
+			if (__pa(addr) < KERNEL_TEXT_SIZE)
+				__flush_tlb_one(__START_KERNEL_map + __pa(addr));
+			addr += PAGE_SIZE;
+		}
+	}
 
+	if (info[CACHE].count == 0)
+		;
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD */
-	if (!cpu_has_clflush)
-		asm volatile("wbinvd" ::: "memory");
-	list_for_each_entry(pg, l, lru) {
-		void *adr = page_address(pg);
-		if (cpu_has_clflush)
-			cache_flush_page(adr);
+	else if (info[CACHE].count < 0)
+		wbinvd();
+	else {
+		unsigned long addr = info[CACHE].address;
+		int count = info[CACHE].count;
+
+		BUG_ON(!cpu_has_clflush);
+		while (count-- > 0) {
+			cache_flush_page(addr);
+			if (__pa(addr) < KERNEL_TEXT_SIZE) {
+				unsigned long kaddr = __START_KERNEL_map + __pa(addr);
+
+				if (lookup_address(kaddr))
+					cache_flush_page(kaddr);
+			}
+			addr += PAGE_SIZE;
+		}
 	}
-	__flush_tlb_all();
 }
 
-static inline void flush_map(struct list_head *l)
-{	
-	on_each_cpu(flush_kernel_map, l, 1, 1);
-}
-
-static LIST_HEAD(deferred_pages); /* protected by init_mm.mmap_sem */
-
-static inline void save_page(struct page *fpage)
-{
-	list_add(&fpage->lru, &deferred_pages);
-}
+/* protected by init_mm.mmap_sem */
+static LIST_HEAD(deferred_pages);
+static struct deferred_info deferred[2];
+static pgprot_t kref_prot[] =	{
+	[0 ... (KERNEL_TEXT_SIZE - 1) >> PMD_SHIFT] = PAGE_KERNEL_EXEC
+};
+#define kref_prot(kaddr) kref_prot[((kaddr) - __START_KERNEL_map) >> PMD_SHIFT]
 
 /* 
- * No more special protections in this 2/4MB area - revert to a
+ * No more special protections in this 2MB area - revert to a
  * large page again. 
  */
-static void revert_page(unsigned long address, pgprot_t ref_prot)
+static void revert_page(struct page *kpte_page, unsigned long address,
+			pgprot_t ref_prot)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -109,6 +155,8 @@ static void revert_page(unsigned long ad
 	pte_t large_pte;
 	unsigned long pfn;
 
+	list_add(&kpte_page->lru, &deferred_pages);
+
 	pgd = pgd_offset_k(address);
 	BUG_ON(pgd_none(*pgd));
 	pud = pud_offset(pgd,address);
@@ -121,52 +169,71 @@ static void revert_page(unsigned long ad
 	set_pte((pte_t *)pmd, large_pte);
 }      
 
-static int
-__change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
-				   pgprot_t ref_prot)
+static inline int pgprot_match(pgprot_t prot1, pgprot_t prot2)
+{
+	return !((pgprot_val(prot1) ^ pgprot_val(prot2))
+		 & __supported_pte_mask & ~(_PAGE_ACCESSED|_PAGE_DIRTY));
+}
+
+static int __change_page_attr(unsigned long address, unsigned long pfn,
+			      pgprot_t prot, pgprot_t ref_prot)
 { 
-	pte_t *kpte; 
+	pte_t *kpte = lookup_address(address);
 	struct page *kpte_page;
-	pgprot_t ref_prot2;
-	kpte = lookup_address(address);
+	pgprot_t old_prot;
+
 	if (!kpte) return 0;
-	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
-	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
+	kpte_page = virt_to_page(kpte);
+	old_prot = pte_pgprot(pte_clrhuge(*kpte));
+	if (!pgprot_match(prot, ref_prot)) {
 		if (!pte_huge(*kpte)) {
 			set_pte(kpte, pfn_pte(pfn, prot));
 		} else {
- 			/*
-			 * split_large_page will take the reference for this
-			 * change_page_attr on the split page.
- 			 */
-			struct page *split;
-			ref_prot2 = pte_pgprot(pte_clrhuge(*kpte));
-			split = split_large_page(address, prot, ref_prot2);
-			if (!split)
+			BUG_ON(!pgprot_match(old_prot, ref_prot));
+			kpte_page = split_large_page(address, prot, ref_prot);
+			if (!kpte_page)
 				return -ENOMEM;
-			set_pte(kpte, mk_pte(split, ref_prot2));
-			kpte_page = split;
+			set_pte(kpte, mk_pte(kpte_page, PAGE_KERNEL_EXEC));
 		}
-		page_private(kpte_page)++;
-	} else if (!pte_huge(*kpte)) {
+		if (pgprot_match(old_prot, ref_prot))
+			page_private(kpte_page)++;
+	} else if (!pgprot_match(ref_prot, old_prot)) {
+		BUG_ON(pte_huge(*kpte));
 		set_pte(kpte, pfn_pte(pfn, ref_prot));
 		BUG_ON(page_private(kpte_page) == 0);
 		page_private(kpte_page)--;
 	} else
-		BUG();
+		return 0;
+
+	if ((pgprot_val(prot) ^ pgprot_val(old_prot)) & (_PAGE_PCD|_PAGE_PWT)) {
+		if (!cpu_has_clflush || !pte_present(pfn_pte(0, prot)))
+			deferred[CACHE].count = -1;
+		else
+			update_deferred(deferred + CACHE, address, 1);
+	}
 
 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
  	BUG_ON(PageReserved(kpte_page));
 
-	if (page_private(kpte_page) == 0) {
-		save_page(kpte_page);
-		revert_page(address, ref_prot);
- 	}
+	if (page_private(kpte_page) == PTRS_PER_PTE
+	    && address >= __START_KERNEL_map
+	    && address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
+		unsigned i;
+
+		kpte = page_address(kpte_page);
+		for (i = 0; i < PTRS_PER_PTE; ++i, ++kpte)
+			if (pgprot_match(pte_pgprot(*kpte), prot))
+				page_private(kpte_page)--;
+		kref_prot(address) = ref_prot = prot;
+	}
+	if (page_private(kpte_page) == 0)
+		revert_page(kpte_page, address, ref_prot);
+
 	return 0;
 } 
 
 /*
- * Change the page attributes of an page in the linear mapping.
+ * Change the page attributes of a page in the linear mapping.
  *
  * This should be used when a page is mapped with a different caching policy
  * than write-back somewhere - some CPUs do not like it when mappings with
@@ -182,6 +249,8 @@ int change_page_attr_addr(unsigned long 
 {
 	int err = 0, kernel_map = 0;
 	int i; 
+	struct page *pg, *next;
+	struct list_head l;
 
 	if (address >= __START_KERNEL_map
 	    && address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
@@ -190,6 +259,9 @@ int change_page_attr_addr(unsigned long 
 	}
 
 	down_write(&init_mm.mmap_sem);
+
+	update_deferred(deferred + TLB, address, numpages);
+
 	for (i = 0; i < numpages; i++, address += PAGE_SIZE) {
 		unsigned long pfn = __pa(address) >> PAGE_SHIFT;
 
@@ -207,10 +279,19 @@ int change_page_attr_addr(unsigned long 
 			/* Make sure the kernel mappings stay executable */
 			prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
 			err = __change_page_attr(addr2, pfn, prot2,
-						 PAGE_KERNEL_EXEC);
+						 kref_prot(addr2));
 		} 
 	} 	
+
+	list_replace_init(&deferred_pages, &l);
+
 	up_write(&init_mm.mmap_sem); 
+
+	list_for_each_entry_safe(pg, next, &l, lru) {
+		ClearPagePrivate(pg);
+		__free_page(pg);
+	}
+
 	return err;
 }
 
@@ -223,19 +304,18 @@ int change_page_attr(struct page *page, 
 
 void global_flush_tlb(void)
 { 
-	struct page *pg, *next;
-	struct list_head l;
-
-	down_read(&init_mm.mmap_sem);
-	list_replace_init(&deferred_pages, &l);
-	up_read(&init_mm.mmap_sem);
+	unsigned i;
+	struct deferred_info info[ARRAY_SIZE(deferred)];
 
-	flush_map(&l);
+	down_write(&init_mm.mmap_sem);
+	for (i = 0; i < ARRAY_SIZE(info); ++i) {
+		info[i] = deferred[i];
+		deferred[i].count = 0;
+	}
+	up_write(&init_mm.mmap_sem);
 
-	list_for_each_entry_safe(pg, next, &l, lru) {
-		ClearPagePrivate(pg);
-		__free_page(pg);
-	} 
+	if (info[TLB].count)
+		on_each_cpu(flush_kernel_map, info, 1, 1);
 } 
 
 EXPORT_SYMBOL(change_page_attr);
diff -puN include/asm-i386/page.h~x86-fix-change_page_attr-tlb-and-cache-flushing include/asm-i386/page.h
--- a/include/asm-i386/page.h~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/include/asm-i386/page.h
@@ -6,6 +6,16 @@
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
+#ifdef CONFIG_X86_PAE
+#define __PHYSICAL_MASK_SHIFT	52
+#define __PHYSICAL_MASK		((1ULL << __PHYSICAL_MASK_SHIFT) - 1)
+#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE - 1ULL) & __PHYSICAL_MASK)
+#else
+#define __PHYSICAL_MASK_SHIFT	32
+#define __PHYSICAL_MASK		(~0UL)
+#define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
+#endif
+
 #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
 #define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
 
diff -puN include/asm-i386/pgtable.h~x86-fix-change_page_attr-tlb-and-cache-flushing include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/include/asm-i386/pgtable.h
@@ -237,6 +237,7 @@ static inline pte_t pte_exprotect(pte_t 
 static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte_low &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte_low &= ~_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte_low &= ~_PAGE_RW; return pte; }
+static inline pte_t pte_clrhuge(pte_t pte)	{ (pte).pte_low &= ~_PAGE_PSE; return pte; }
 static inline pte_t pte_mkread(pte_t pte)	{ (pte).pte_low |= _PAGE_USER; return pte; }
 static inline pte_t pte_mkexec(pte_t pte)	{ (pte).pte_low |= _PAGE_USER; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte_low |= _PAGE_DIRTY; return pte; }
@@ -244,6 +245,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
 
+#define pte_pgprot(pte) (__pgprot(pte_val(pte) & ~PHYSICAL_PAGE_MASK))
+
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
 #else
diff -puN include/asm-x86_64/page.h~x86-fix-change_page_attr-tlb-and-cache-flushing include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/include/asm-x86_64/page.h
@@ -97,7 +97,7 @@ extern unsigned long phys_base;
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
 /* See Documentation/x86_64/mm.txt for a description of the memory map. */
-#define __PHYSICAL_MASK_SHIFT	46
+#define __PHYSICAL_MASK_SHIFT	52
 #define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
 #define __VIRTUAL_MASK_SHIFT	48
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
diff -puN include/asm-x86_64/pgtable.h~x86-fix-change_page_attr-tlb-and-cache-flushing include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/include/asm-x86_64/pgtable.h
@@ -356,9 +356,9 @@ static inline int pmd_large(pmd_t pte) {
 #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
 #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
-#define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
+#define pte_to_pgoff(pte) (pte_val(pte) >> PAGE_SHIFT)
 #define pgoff_to_pte(off) ((pte_t) { ((off) << PAGE_SHIFT) | _PAGE_FILE })
-#define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
+#define PTE_FILE_MAX_BITS (64 - PAGE_SHIFT)
 
 /* PTE - Level 1 access. */
 
diff -puN include/asm-x86_64/system.h~x86-fix-change_page_attr-tlb-and-cache-flushing include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~x86-fix-change_page_attr-tlb-and-cache-flushing
+++ a/include/asm-x86_64/system.h
@@ -109,7 +109,7 @@ static inline void write_cr4(unsigned lo
 #define stts() write_cr0(8 | read_cr0())
 
 #define wbinvd() \
-	__asm__ __volatile__ ("wbinvd": : :"memory");
+	__asm__ __volatile__ ("wbinvd": : :"memory")
 
 /*
  * On SMP systems, when the scheduler does migration-cost autodetection,
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
modpost-white-list-pattern-adjustment.patch
remove-pci_dac_dma_-apis.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-change_page_attr-tlb-and-cache-flushing.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
kill-vmalloc_earlyreserve.patch
adjust-nosmp-handling.patch
