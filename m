Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FB7C43334
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiF1T0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiF1TZm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:25:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460F11A399
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3717619F7
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D49C3411D;
        Tue, 28 Jun 2022 19:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656444277;
        bh=HNTRBA5IwwA2R3yNI3qtbrNiAN+SGgKFurEYgVDWfLQ=;
        h=Date:To:From:Subject:From;
        b=vCFWoH3ZLYGSVoO6I2N4IYPzwDMw6LZ0C4/3oFEbmcXQxSUAJx92RCQy9YeiArhnu
         mySMjtY6p2G4LJV1cx6rPWJ1/zKMJ/UH7JaOTMqzKJLNpSjs6hP7A9i+Sx+UM6G2Xr
         Rz+r2EVZhvKANKgoUt8EvkE5UEI5OQ9mnLeDyurs=
Date:   Tue, 28 Jun 2022 12:24:36 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch added to mm-unstable branch
Message-Id: <20220628192437.18D49C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: move vmemmap code related to HugeTLB to hugetlb_vmemmap.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: move vmemmap code related to HugeTLB to hugetlb_vmemmap.c
Date: Tue, 28 Jun 2022 17:22:31 +0800

When I first introduced vmemmap manipulation functions related to HugeTLB,
I thought those functions may be reused by other modules (e.g.  using
similar approach to optimize vmemmap pages, unfortunately, the DAX used
the same approach but does not use those functions).  After two years, we
didn't see any other users.  So move those functions to hugetlb_vmemmap.c.
Code movement without any functional change.

Link: https://lkml.kernel.org/r/20220628092235.91270-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    7 
 mm/hugetlb_vmemmap.c |  399 ++++++++++++++++++++++++++++++++++++++++-
 mm/sparse-vmemmap.c  |  399 -----------------------------------------
 3 files changed, 398 insertions(+), 407 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc
+++ a/include/linux/mm.h
@@ -3227,13 +3227,6 @@ static inline void print_vma_addr(char *
 }
 #endif
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-int vmemmap_remap_free(unsigned long start, unsigned long end,
-		       unsigned long reuse);
-int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			unsigned long reuse, gfp_t gfp_mask);
-#endif
-
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc
+++ a/mm/hugetlb_vmemmap.c
@@ -10,9 +10,31 @@
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
-#include <linux/memory.h>
+#include <linux/pgtable.h>
+#include <linux/bootmem_info.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 
+/**
+ * struct vmemmap_remap_walk - walk vmemmap page table
+ *
+ * @remap_pte:		called for each lowest-level entry (PTE).
+ * @nr_walked:		the number of walked pte.
+ * @reuse_page:		the page which is reused for the tail vmemmap pages.
+ * @reuse_addr:		the virtual address of the @reuse_page page.
+ * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
+ *			or is mapped from.
+ */
+struct vmemmap_remap_walk {
+	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+					     struct vmemmap_remap_walk *walk);
+	unsigned long		nr_walked;
+	struct page		*reuse_page;
+	unsigned long		reuse_addr;
+	struct list_head	*vmemmap_pages;
+};
+
 /*
  * There are a lot of struct page structures associated with each HugeTLB page.
  * For tail pages, the value of compound_head is the same. So we can reuse first
@@ -23,6 +45,381 @@
 #define RESERVE_VMEMMAP_NR		1U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
+static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
+{
+	pmd_t __pmd;
+	int i;
+	unsigned long addr = start;
+	struct page *page = pmd_page(*pmd);
+	pte_t *pgtable = pte_alloc_one_kernel(&init_mm);
+
+	if (!pgtable)
+		return -ENOMEM;
+
+	pmd_populate_kernel(&init_mm, &__pmd, pgtable);
+
+	for (i = 0; i < PMD_SIZE / PAGE_SIZE; i++, addr += PAGE_SIZE) {
+		pte_t entry, *pte;
+		pgprot_t pgprot = PAGE_KERNEL;
+
+		entry = mk_pte(page + i, pgprot);
+		pte = pte_offset_kernel(&__pmd, addr);
+		set_pte_at(&init_mm, addr, pte, entry);
+	}
+
+	spin_lock(&init_mm.page_table_lock);
+	if (likely(pmd_leaf(*pmd))) {
+		/*
+		 * Higher order allocations from buddy allocator must be able to
+		 * be treated as indepdenent small pages (as they can be freed
+		 * individually).
+		 */
+		if (!PageReserved(page))
+			split_page(page, get_order(PMD_SIZE));
+
+		/* Make pte visible before pmd. See comment in pmd_install(). */
+		smp_wmb();
+		pmd_populate_kernel(&init_mm, pmd, pgtable);
+		flush_tlb_kernel_range(start, start + PMD_SIZE);
+	} else {
+		pte_free_kernel(&init_mm, pgtable);
+	}
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
+{
+	int leaf;
+
+	spin_lock(&init_mm.page_table_lock);
+	leaf = pmd_leaf(*pmd);
+	spin_unlock(&init_mm.page_table_lock);
+
+	if (!leaf)
+		return 0;
+
+	return __split_vmemmap_huge_pmd(pmd, start);
+}
+
+static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
+			      unsigned long end,
+			      struct vmemmap_remap_walk *walk)
+{
+	pte_t *pte = pte_offset_kernel(pmd, addr);
+
+	/*
+	 * The reuse_page is found 'first' in table walk before we start
+	 * remapping (which is calling @walk->remap_pte).
+	 */
+	if (!walk->reuse_page) {
+		walk->reuse_page = pte_page(*pte);
+		/*
+		 * Because the reuse address is part of the range that we are
+		 * walking, skip the reuse address range.
+		 */
+		addr += PAGE_SIZE;
+		pte++;
+		walk->nr_walked++;
+	}
+
+	for (; addr != end; addr += PAGE_SIZE, pte++) {
+		walk->remap_pte(pte, addr, walk);
+		walk->nr_walked++;
+	}
+}
+
+static int vmemmap_pmd_range(pud_t *pud, unsigned long addr,
+			     unsigned long end,
+			     struct vmemmap_remap_walk *walk)
+{
+	pmd_t *pmd;
+	unsigned long next;
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		int ret;
+
+		ret = split_vmemmap_huge_pmd(pmd, addr & PMD_MASK);
+		if (ret)
+			return ret;
+
+		next = pmd_addr_end(addr, end);
+		vmemmap_pte_range(pmd, addr, next, walk);
+	} while (pmd++, addr = next, addr != end);
+
+	return 0;
+}
+
+static int vmemmap_pud_range(p4d_t *p4d, unsigned long addr,
+			     unsigned long end,
+			     struct vmemmap_remap_walk *walk)
+{
+	pud_t *pud;
+	unsigned long next;
+
+	pud = pud_offset(p4d, addr);
+	do {
+		int ret;
+
+		next = pud_addr_end(addr, end);
+		ret = vmemmap_pmd_range(pud, addr, next, walk);
+		if (ret)
+			return ret;
+	} while (pud++, addr = next, addr != end);
+
+	return 0;
+}
+
+static int vmemmap_p4d_range(pgd_t *pgd, unsigned long addr,
+			     unsigned long end,
+			     struct vmemmap_remap_walk *walk)
+{
+	p4d_t *p4d;
+	unsigned long next;
+
+	p4d = p4d_offset(pgd, addr);
+	do {
+		int ret;
+
+		next = p4d_addr_end(addr, end);
+		ret = vmemmap_pud_range(p4d, addr, next, walk);
+		if (ret)
+			return ret;
+	} while (p4d++, addr = next, addr != end);
+
+	return 0;
+}
+
+static int vmemmap_remap_range(unsigned long start, unsigned long end,
+			       struct vmemmap_remap_walk *walk)
+{
+	unsigned long addr = start;
+	unsigned long next;
+	pgd_t *pgd;
+
+	VM_BUG_ON(!PAGE_ALIGNED(start));
+	VM_BUG_ON(!PAGE_ALIGNED(end));
+
+	pgd = pgd_offset_k(addr);
+	do {
+		int ret;
+
+		next = pgd_addr_end(addr, end);
+		ret = vmemmap_p4d_range(pgd, addr, next, walk);
+		if (ret)
+			return ret;
+	} while (pgd++, addr = next, addr != end);
+
+	/*
+	 * We only change the mapping of the vmemmap virtual address range
+	 * [@start + PAGE_SIZE, end), so we only need to flush the TLB which
+	 * belongs to the range.
+	 */
+	flush_tlb_kernel_range(start + PAGE_SIZE, end);
+
+	return 0;
+}
+
+/*
+ * Free a vmemmap page. A vmemmap page can be allocated from the memblock
+ * allocator or buddy allocator. If the PG_reserved flag is set, it means
+ * that it allocated from the memblock allocator, just free it via the
+ * free_bootmem_page(). Otherwise, use __free_page().
+ */
+static inline void free_vmemmap_page(struct page *page)
+{
+	if (PageReserved(page))
+		free_bootmem_page(page);
+	else
+		__free_page(page);
+}
+
+/* Free a list of the vmemmap pages */
+static void free_vmemmap_page_list(struct list_head *list)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, list, lru) {
+		list_del(&page->lru);
+		free_vmemmap_page(page);
+	}
+}
+
+static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
+			      struct vmemmap_remap_walk *walk)
+{
+	/*
+	 * Remap the tail pages as read-only to catch illegal write operation
+	 * to the tail pages.
+	 */
+	pgprot_t pgprot = PAGE_KERNEL_RO;
+	pte_t entry = mk_pte(walk->reuse_page, pgprot);
+	struct page *page = pte_page(*pte);
+
+	list_add_tail(&page->lru, walk->vmemmap_pages);
+	set_pte_at(&init_mm, addr, pte, entry);
+}
+
+/*
+ * How many struct page structs need to be reset. When we reuse the head
+ * struct page, the special metadata (e.g. page->flags or page->mapping)
+ * cannot copy to the tail struct page structs. The invalid value will be
+ * checked in the free_tail_pages_check(). In order to avoid the message
+ * of "corrupted mapping in tail page". We need to reset at least 3 (one
+ * head struct page struct and two tail struct page structs) struct page
+ * structs.
+ */
+#define NR_RESET_STRUCT_PAGE		3
+
+static inline void reset_struct_pages(struct page *start)
+{
+	int i;
+	struct page *from = start + NR_RESET_STRUCT_PAGE;
+
+	for (i = 0; i < NR_RESET_STRUCT_PAGE; i++)
+		memcpy(start + i, from, sizeof(*from));
+}
+
+static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+				struct vmemmap_remap_walk *walk)
+{
+	pgprot_t pgprot = PAGE_KERNEL;
+	struct page *page;
+	void *to;
+
+	BUG_ON(pte_page(*pte) != walk->reuse_page);
+
+	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
+	list_del(&page->lru);
+	to = page_to_virt(page);
+	copy_page(to, (void *)walk->reuse_addr);
+	reset_struct_pages(to);
+
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+}
+
+/**
+ * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
+ *			to the page which @reuse is mapped to, then free vmemmap
+ *			which the range are mapped to.
+ * @start:	start address of the vmemmap virtual address range that we want
+ *		to remap.
+ * @end:	end address of the vmemmap virtual address range that we want to
+ *		remap.
+ * @reuse:	reuse address.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+static int vmemmap_remap_free(unsigned long start, unsigned long end,
+			      unsigned long reuse)
+{
+	int ret;
+	LIST_HEAD(vmemmap_pages);
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_remap_pte,
+		.reuse_addr	= reuse,
+		.vmemmap_pages	= &vmemmap_pages,
+	};
+
+	/*
+	 * In order to make remapping routine most efficient for the huge pages,
+	 * the routine of vmemmap page table walking has the following rules
+	 * (see more details from the vmemmap_pte_range()):
+	 *
+	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
+	 *   should be continuous.
+	 * - The @reuse address is part of the range [@reuse, @end) that we are
+	 *   walking which is passed to vmemmap_remap_range().
+	 * - The @reuse address is the first in the complete range.
+	 *
+	 * So we need to make sure that @start and @reuse meet the above rules.
+	 */
+	BUG_ON(start - reuse != PAGE_SIZE);
+
+	mmap_read_lock(&init_mm);
+	ret = vmemmap_remap_range(reuse, end, &walk);
+	if (ret && walk.nr_walked) {
+		end = reuse + walk.nr_walked * PAGE_SIZE;
+		/*
+		 * vmemmap_pages contains pages from the previous
+		 * vmemmap_remap_range call which failed.  These
+		 * are pages which were removed from the vmemmap.
+		 * They will be restored in the following call.
+		 */
+		walk = (struct vmemmap_remap_walk) {
+			.remap_pte	= vmemmap_restore_pte,
+			.reuse_addr	= reuse,
+			.vmemmap_pages	= &vmemmap_pages,
+		};
+
+		vmemmap_remap_range(reuse, end, &walk);
+	}
+	mmap_read_unlock(&init_mm);
+
+	free_vmemmap_page_list(&vmemmap_pages);
+
+	return ret;
+}
+
+static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
+				   gfp_t gfp_mask, struct list_head *list)
+{
+	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
+	int nid = page_to_nid((struct page *)start);
+	struct page *page, *next;
+
+	while (nr_pages--) {
+		page = alloc_pages_node(nid, gfp_mask, 0);
+		if (!page)
+			goto out;
+		list_add_tail(&page->lru, list);
+	}
+
+	return 0;
+out:
+	list_for_each_entry_safe(page, next, list, lru)
+		__free_pages(page, 0);
+	return -ENOMEM;
+}
+
+/**
+ * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
+ *			 to the page which is from the @vmemmap_pages
+ *			 respectively.
+ * @start:	start address of the vmemmap virtual address range that we want
+ *		to remap.
+ * @end:	end address of the vmemmap virtual address range that we want to
+ *		remap.
+ * @reuse:	reuse address.
+ * @gfp_mask:	GFP flag for allocating vmemmap pages.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
+			       unsigned long reuse, gfp_t gfp_mask)
+{
+	LIST_HEAD(vmemmap_pages);
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_restore_pte,
+		.reuse_addr	= reuse,
+		.vmemmap_pages	= &vmemmap_pages,
+	};
+
+	/* See the comment in the vmemmap_remap_free(). */
+	BUG_ON(start - reuse != PAGE_SIZE);
+
+	if (alloc_vmemmap_page_list(start, end, gfp_mask, &vmemmap_pages))
+		return -ENOMEM;
+
+	mmap_read_lock(&init_mm);
+	vmemmap_remap_range(reuse, end, &walk);
+	mmap_read_unlock(&init_mm);
+
+	return 0;
+}
+
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
--- a/mm/sparse-vmemmap.c~mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc
+++ a/mm/sparse-vmemmap.c
@@ -27,408 +27,9 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
-#include <linux/pgtable.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
-#include <asm/tlbflush.h>
-
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-/**
- * struct vmemmap_remap_walk - walk vmemmap page table
- *
- * @remap_pte:		called for each lowest-level entry (PTE).
- * @nr_walked:		the number of walked pte.
- * @reuse_page:		the page which is reused for the tail vmemmap pages.
- * @reuse_addr:		the virtual address of the @reuse_page page.
- * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
- *			or is mapped from.
- */
-struct vmemmap_remap_walk {
-	void (*remap_pte)(pte_t *pte, unsigned long addr,
-			  struct vmemmap_remap_walk *walk);
-	unsigned long nr_walked;
-	struct page *reuse_page;
-	unsigned long reuse_addr;
-	struct list_head *vmemmap_pages;
-};
-
-static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
-{
-	pmd_t __pmd;
-	int i;
-	unsigned long addr = start;
-	struct page *page = pmd_page(*pmd);
-	pte_t *pgtable = pte_alloc_one_kernel(&init_mm);
-
-	if (!pgtable)
-		return -ENOMEM;
-
-	pmd_populate_kernel(&init_mm, &__pmd, pgtable);
-
-	for (i = 0; i < PMD_SIZE / PAGE_SIZE; i++, addr += PAGE_SIZE) {
-		pte_t entry, *pte;
-		pgprot_t pgprot = PAGE_KERNEL;
-
-		entry = mk_pte(page + i, pgprot);
-		pte = pte_offset_kernel(&__pmd, addr);
-		set_pte_at(&init_mm, addr, pte, entry);
-	}
-
-	spin_lock(&init_mm.page_table_lock);
-	if (likely(pmd_leaf(*pmd))) {
-		/*
-		 * Higher order allocations from buddy allocator must be able to
-		 * be treated as indepdenent small pages (as they can be freed
-		 * individually).
-		 */
-		if (!PageReserved(page))
-			split_page(page, get_order(PMD_SIZE));
-
-		/* Make pte visible before pmd. See comment in pmd_install(). */
-		smp_wmb();
-		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		flush_tlb_kernel_range(start, start + PMD_SIZE);
-	} else {
-		pte_free_kernel(&init_mm, pgtable);
-	}
-	spin_unlock(&init_mm.page_table_lock);
-
-	return 0;
-}
-
-static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
-{
-	int leaf;
-
-	spin_lock(&init_mm.page_table_lock);
-	leaf = pmd_leaf(*pmd);
-	spin_unlock(&init_mm.page_table_lock);
-
-	if (!leaf)
-		return 0;
-
-	return __split_vmemmap_huge_pmd(pmd, start);
-}
-
-static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
-			      unsigned long end,
-			      struct vmemmap_remap_walk *walk)
-{
-	pte_t *pte = pte_offset_kernel(pmd, addr);
-
-	/*
-	 * The reuse_page is found 'first' in table walk before we start
-	 * remapping (which is calling @walk->remap_pte).
-	 */
-	if (!walk->reuse_page) {
-		walk->reuse_page = pte_page(*pte);
-		/*
-		 * Because the reuse address is part of the range that we are
-		 * walking, skip the reuse address range.
-		 */
-		addr += PAGE_SIZE;
-		pte++;
-		walk->nr_walked++;
-	}
-
-	for (; addr != end; addr += PAGE_SIZE, pte++) {
-		walk->remap_pte(pte, addr, walk);
-		walk->nr_walked++;
-	}
-}
-
-static int vmemmap_pmd_range(pud_t *pud, unsigned long addr,
-			     unsigned long end,
-			     struct vmemmap_remap_walk *walk)
-{
-	pmd_t *pmd;
-	unsigned long next;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		int ret;
-
-		ret = split_vmemmap_huge_pmd(pmd, addr & PMD_MASK);
-		if (ret)
-			return ret;
-
-		next = pmd_addr_end(addr, end);
-		vmemmap_pte_range(pmd, addr, next, walk);
-	} while (pmd++, addr = next, addr != end);
-
-	return 0;
-}
-
-static int vmemmap_pud_range(p4d_t *p4d, unsigned long addr,
-			     unsigned long end,
-			     struct vmemmap_remap_walk *walk)
-{
-	pud_t *pud;
-	unsigned long next;
-
-	pud = pud_offset(p4d, addr);
-	do {
-		int ret;
-
-		next = pud_addr_end(addr, end);
-		ret = vmemmap_pmd_range(pud, addr, next, walk);
-		if (ret)
-			return ret;
-	} while (pud++, addr = next, addr != end);
-
-	return 0;
-}
-
-static int vmemmap_p4d_range(pgd_t *pgd, unsigned long addr,
-			     unsigned long end,
-			     struct vmemmap_remap_walk *walk)
-{
-	p4d_t *p4d;
-	unsigned long next;
-
-	p4d = p4d_offset(pgd, addr);
-	do {
-		int ret;
-
-		next = p4d_addr_end(addr, end);
-		ret = vmemmap_pud_range(p4d, addr, next, walk);
-		if (ret)
-			return ret;
-	} while (p4d++, addr = next, addr != end);
-
-	return 0;
-}
-
-static int vmemmap_remap_range(unsigned long start, unsigned long end,
-			       struct vmemmap_remap_walk *walk)
-{
-	unsigned long addr = start;
-	unsigned long next;
-	pgd_t *pgd;
-
-	VM_BUG_ON(!PAGE_ALIGNED(start));
-	VM_BUG_ON(!PAGE_ALIGNED(end));
-
-	pgd = pgd_offset_k(addr);
-	do {
-		int ret;
-
-		next = pgd_addr_end(addr, end);
-		ret = vmemmap_p4d_range(pgd, addr, next, walk);
-		if (ret)
-			return ret;
-	} while (pgd++, addr = next, addr != end);
-
-	/*
-	 * We only change the mapping of the vmemmap virtual address range
-	 * [@start + PAGE_SIZE, end), so we only need to flush the TLB which
-	 * belongs to the range.
-	 */
-	flush_tlb_kernel_range(start + PAGE_SIZE, end);
-
-	return 0;
-}
-
-/*
- * Free a vmemmap page. A vmemmap page can be allocated from the memblock
- * allocator or buddy allocator. If the PG_reserved flag is set, it means
- * that it allocated from the memblock allocator, just free it via the
- * free_bootmem_page(). Otherwise, use __free_page().
- */
-static inline void free_vmemmap_page(struct page *page)
-{
-	if (PageReserved(page))
-		free_bootmem_page(page);
-	else
-		__free_page(page);
-}
-
-/* Free a list of the vmemmap pages */
-static void free_vmemmap_page_list(struct list_head *list)
-{
-	struct page *page, *next;
-
-	list_for_each_entry_safe(page, next, list, lru) {
-		list_del(&page->lru);
-		free_vmemmap_page(page);
-	}
-}
-
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
-{
-	/*
-	 * Remap the tail pages as read-only to catch illegal write operation
-	 * to the tail pages.
-	 */
-	pgprot_t pgprot = PAGE_KERNEL_RO;
-	pte_t entry = mk_pte(walk->reuse_page, pgprot);
-	struct page *page = pte_page(*pte);
-
-	list_add_tail(&page->lru, walk->vmemmap_pages);
-	set_pte_at(&init_mm, addr, pte, entry);
-}
-
-/*
- * How many struct page structs need to be reset. When we reuse the head
- * struct page, the special metadata (e.g. page->flags or page->mapping)
- * cannot copy to the tail struct page structs. The invalid value will be
- * checked in the free_tail_pages_check(). In order to avoid the message
- * of "corrupted mapping in tail page". We need to reset at least 3 (one
- * head struct page struct and two tail struct page structs) struct page
- * structs.
- */
-#define NR_RESET_STRUCT_PAGE		3
-
-static inline void reset_struct_pages(struct page *start)
-{
-	int i;
-	struct page *from = start + NR_RESET_STRUCT_PAGE;
-
-	for (i = 0; i < NR_RESET_STRUCT_PAGE; i++)
-		memcpy(start + i, from, sizeof(*from));
-}
-
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
-{
-	pgprot_t pgprot = PAGE_KERNEL;
-	struct page *page;
-	void *to;
-
-	BUG_ON(pte_page(*pte) != walk->reuse_page);
-
-	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&page->lru);
-	to = page_to_virt(page);
-	copy_page(to, (void *)walk->reuse_addr);
-	reset_struct_pages(to);
-
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
-}
-
-/**
- * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to the page which @reuse is mapped to, then free vmemmap
- *			which the range are mapped to.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @reuse:	reuse address.
- *
- * Return: %0 on success, negative error code otherwise.
- */
-int vmemmap_remap_free(unsigned long start, unsigned long end,
-		       unsigned long reuse)
-{
-	int ret;
-	LIST_HEAD(vmemmap_pages);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
-		.reuse_addr	= reuse,
-		.vmemmap_pages	= &vmemmap_pages,
-	};
-
-	/*
-	 * In order to make remapping routine most efficient for the huge pages,
-	 * the routine of vmemmap page table walking has the following rules
-	 * (see more details from the vmemmap_pte_range()):
-	 *
-	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
-	 *   should be continuous.
-	 * - The @reuse address is part of the range [@reuse, @end) that we are
-	 *   walking which is passed to vmemmap_remap_range().
-	 * - The @reuse address is the first in the complete range.
-	 *
-	 * So we need to make sure that @start and @reuse meet the above rules.
-	 */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	mmap_read_lock(&init_mm);
-	ret = vmemmap_remap_range(reuse, end, &walk);
-	if (ret && walk.nr_walked) {
-		end = reuse + walk.nr_walked * PAGE_SIZE;
-		/*
-		 * vmemmap_pages contains pages from the previous
-		 * vmemmap_remap_range call which failed.  These
-		 * are pages which were removed from the vmemmap.
-		 * They will be restored in the following call.
-		 */
-		walk = (struct vmemmap_remap_walk) {
-			.remap_pte	= vmemmap_restore_pte,
-			.reuse_addr	= reuse,
-			.vmemmap_pages	= &vmemmap_pages,
-		};
-
-		vmemmap_remap_range(reuse, end, &walk);
-	}
-	mmap_read_unlock(&init_mm);
-
-	free_vmemmap_page_list(&vmemmap_pages);
-
-	return ret;
-}
-
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   gfp_t gfp_mask, struct list_head *list)
-{
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
-	struct page *page, *next;
-
-	while (nr_pages--) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
-		if (!page)
-			goto out;
-		list_add_tail(&page->lru, list);
-	}
-
-	return 0;
-out:
-	list_for_each_entry_safe(page, next, list, lru)
-		__free_pages(page, 0);
-	return -ENOMEM;
-}
-
-/**
- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
- *			 to the page which is from the @vmemmap_pages
- *			 respectively.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @reuse:	reuse address.
- * @gfp_mask:	GFP flag for allocating vmemmap pages.
- *
- * Return: %0 on success, negative error code otherwise.
- */
-int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			unsigned long reuse, gfp_t gfp_mask)
-{
-	LIST_HEAD(vmemmap_pages);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_restore_pte,
-		.reuse_addr	= reuse,
-		.vmemmap_pages	= &vmemmap_pages,
-	};
-
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	if (alloc_vmemmap_page_list(start, end, gfp_mask, &vmemmap_pages))
-		return -ENOMEM;
-
-	mmap_read_lock(&init_mm);
-	vmemmap_remap_range(reuse, end, &walk);
-	mmap_read_unlock(&init_mm);
-
-	return 0;
-}
-#endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparsemem-fix-missing-higher-order-allocation-splitting.patch
mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

