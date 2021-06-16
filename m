Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DA5C48BE5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 437F660FEE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhFPXmz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234590AbhFPXmy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 19:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DCCA61159;
        Wed, 16 Jun 2021 23:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623886846;
        bh=mpOSshB9CbRrvPpiNf+XiE3Zue3NN/cIFfR0S1Sqo3k=;
        h=Date:From:To:Subject:From;
        b=PH/JTN7mjtrVnQgPjFuID1UyNXUqeY48kBy16GZ+XEUw/PCt7ULjcvVrjGBDZCcV6
         CQI94L4Kx1b9ABD8CMHA2J6oK6H8ODEX5sQDvwIke4tED7f43NOazgSPZlY2ofsJj9
         8btESj/XAiuFyxnLA9nsSB1Z5X55TttTKlEsBUdQ=
Date:   Wed, 16 Jun 2021 16:40:45 -0700
From:   akpm@linux-foundation.org
To:     chenhuang5@huawei.com, corbet@lwn.net, david@redhat.com,
        duanxiongchun@bytedance.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  +
 mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch added to -mm
 tree
Message-ID: <20210616234045.TUQQ3nQQ9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparsemem: split the huge PMD mapping of vmemmap pages
has been added to the -mm tree.  Its filename is
     mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: sparsemem: split the huge PMD mapping of vmemmap pages

Patch series "Split huge PMD mapping of vmemmap pages", v4.

In order to reduce the difficulty of code review in series[1].  We disable
huge PMD mapping of vmemmap pages when that feature is enabled.  In this
series, we do not disable huge PMD mapping of vmemmap pages anymore.  We
will split huge PMD mapping when needed.  When HugeTLB pages are freed
from the pool we do not attempt coalasce and move back to a PMD mapping
because it is much more complex.

[1] https://lore.kernel.org/linux-doc/20210510030027.56044-1-songmuchun@bytedance.com/


This patch (of 3):

In [1], PMD mappings of vmemmap pages were disabled if the the feature
hugetlb_free_vmemmap was enabled.  This was done to simplify the initial
implementation of vmmemap freeing for hugetlb pages.  Now, remove this
simplification by allowing PMD mapping and switching to PTE mappings as
needed for allocated hugetlb pages.

When a hugetlb page is allocated, the vmemmap page tables are walked to
free vmemmap pages.  During this walk, split huge PMD mappings to PTE
mappings as required.  In the unlikely case PTE pages can not be
allocated, return error(ENOMEM) and do not optimize vmemmap of the hugetlb
page.

When HugeTLB pages are freed from the pool, we do not attempt to
coalesce and move back to a PMD mapping because it is much more complex.

[1] https://lkml.kernel.org/r/20210510030027.56044-8-songmuchun@bytedance.com

Link: https://lkml.kernel.org/r/20210616094915.34432-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20210616094915.34432-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    4 -
 mm/hugetlb_vmemmap.c |    5 -
 mm/sparse-vmemmap.c  |  163 +++++++++++++++++++++++++++++++----------
 3 files changed, 129 insertions(+), 43 deletions(-)

--- a/include/linux/mm.h~mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages
+++ a/include/linux/mm.h
@@ -3077,8 +3077,8 @@ static inline void print_vma_addr(char *
 }
 #endif
 
-void vmemmap_remap_free(unsigned long start, unsigned long end,
-			unsigned long reuse);
+int vmemmap_remap_free(unsigned long start, unsigned long end,
+		       unsigned long reuse);
 int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			unsigned long reuse, gfp_t gfp_mask);
 
--- a/mm/hugetlb_vmemmap.c~mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -258,9 +258,8 @@ void free_huge_page_vmemmap(struct hstat
 	 * to the page which @vmemmap_reuse is mapped to, then free the pages
 	 * which the range [@vmemmap_addr, @vmemmap_end] is mapped to.
 	 */
-	vmemmap_remap_free(vmemmap_addr, vmemmap_end, vmemmap_reuse);
-
-	SetHPageVmemmapOptimized(head);
+	if (!vmemmap_remap_free(vmemmap_addr, vmemmap_end, vmemmap_reuse))
+		SetHPageVmemmapOptimized(head);
 }
 
 void __init hugetlb_vmemmap_init(struct hstate *h)
--- a/mm/sparse-vmemmap.c~mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages
+++ a/mm/sparse-vmemmap.c
@@ -38,6 +38,7 @@
  * struct vmemmap_remap_walk - walk vmemmap page table
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
+ * @nr_walked:		the number of walked pte.
  * @reuse_page:		the page which is reused for the tail vmemmap pages.
  * @reuse_addr:		the virtual address of the @reuse_page page.
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
@@ -46,11 +47,44 @@
 struct vmemmap_remap_walk {
 	void (*remap_pte)(pte_t *pte, unsigned long addr,
 			  struct vmemmap_remap_walk *walk);
+	unsigned long nr_walked;
 	struct page *reuse_page;
 	unsigned long reuse_addr;
 	struct list_head *vmemmap_pages;
 };
 
+static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start,
+				  struct vmemmap_remap_walk *walk)
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
+	/* Make pte visible before pmd. See comment in __pte_alloc(). */
+	smp_wmb();
+	pmd_populate_kernel(&init_mm, pmd, pgtable);
+
+	flush_tlb_kernel_range(start, start + PMD_SIZE);
+
+	return 0;
+}
+
 static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
 			      unsigned long end,
 			      struct vmemmap_remap_walk *walk)
@@ -69,58 +103,80 @@ static void vmemmap_pte_range(pmd_t *pmd
 		 */
 		addr += PAGE_SIZE;
 		pte++;
+		walk->nr_walked++;
 	}
 
-	for (; addr != end; addr += PAGE_SIZE, pte++)
+	for (; addr != end; addr += PAGE_SIZE, pte++) {
 		walk->remap_pte(pte, addr, walk);
+		walk->nr_walked++;
+	}
 }
 
-static void vmemmap_pmd_range(pud_t *pud, unsigned long addr,
-			      unsigned long end,
-			      struct vmemmap_remap_walk *walk)
+static int vmemmap_pmd_range(pud_t *pud, unsigned long addr,
+			     unsigned long end,
+			     struct vmemmap_remap_walk *walk)
 {
 	pmd_t *pmd;
 	unsigned long next;
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		BUG_ON(pmd_leaf(*pmd));
+		if (pmd_leaf(*pmd)) {
+			int ret;
 
+			ret = split_vmemmap_huge_pmd(pmd, addr & PMD_MASK, walk);
+			if (ret)
+				return ret;
+		}
 		next = pmd_addr_end(addr, end);
 		vmemmap_pte_range(pmd, addr, next, walk);
 	} while (pmd++, addr = next, addr != end);
+
+	return 0;
 }
 
-static void vmemmap_pud_range(p4d_t *p4d, unsigned long addr,
-			      unsigned long end,
-			      struct vmemmap_remap_walk *walk)
+static int vmemmap_pud_range(p4d_t *p4d, unsigned long addr,
+			     unsigned long end,
+			     struct vmemmap_remap_walk *walk)
 {
 	pud_t *pud;
 	unsigned long next;
 
 	pud = pud_offset(p4d, addr);
 	do {
+		int ret;
+
 		next = pud_addr_end(addr, end);
-		vmemmap_pmd_range(pud, addr, next, walk);
+		ret = vmemmap_pmd_range(pud, addr, next, walk);
+		if (ret)
+			return ret;
 	} while (pud++, addr = next, addr != end);
+
+	return 0;
 }
 
-static void vmemmap_p4d_range(pgd_t *pgd, unsigned long addr,
-			      unsigned long end,
-			      struct vmemmap_remap_walk *walk)
+static int vmemmap_p4d_range(pgd_t *pgd, unsigned long addr,
+			     unsigned long end,
+			     struct vmemmap_remap_walk *walk)
 {
 	p4d_t *p4d;
 	unsigned long next;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
+		int ret;
+
 		next = p4d_addr_end(addr, end);
-		vmemmap_pud_range(p4d, addr, next, walk);
+		ret = vmemmap_pud_range(p4d, addr, next, walk);
+		if (ret)
+			return ret;
 	} while (p4d++, addr = next, addr != end);
+
+	return 0;
 }
 
-static void vmemmap_remap_range(unsigned long start, unsigned long end,
-				struct vmemmap_remap_walk *walk)
+static int vmemmap_remap_range(unsigned long start, unsigned long end,
+			       struct vmemmap_remap_walk *walk)
 {
 	unsigned long addr = start;
 	unsigned long next;
@@ -131,8 +187,12 @@ static void vmemmap_remap_range(unsigned
 
 	pgd = pgd_offset_k(addr);
 	do {
+		int ret;
+
 		next = pgd_addr_end(addr, end);
-		vmemmap_p4d_range(pgd, addr, next, walk);
+		ret = vmemmap_p4d_range(pgd, addr, next, walk);
+		if (ret)
+			return ret;
 	} while (pgd++, addr = next, addr != end);
 
 	/*
@@ -141,6 +201,8 @@ static void vmemmap_remap_range(unsigned
 	 * belongs to the range.
 	 */
 	flush_tlb_kernel_range(start + PAGE_SIZE, end);
+
+	return 0;
 }
 
 /*
@@ -179,10 +241,27 @@ static void vmemmap_remap_pte(pte_t *pte
 	pte_t entry = mk_pte(walk->reuse_page, pgprot);
 	struct page *page = pte_page(*pte);
 
-	list_add(&page->lru, walk->vmemmap_pages);
+	list_add_tail(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
 
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
+
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+}
+
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
  *			to the page which @reuse is mapped to, then free vmemmap
@@ -193,12 +272,12 @@ static void vmemmap_remap_pte(pte_t *pte
  *		remap.
  * @reuse:	reuse address.
  *
- * Note: This function depends on vmemmap being base page mapped. Please make
- * sure that we disable PMD mapping of vmemmap pages when calling this function.
+ * Return: %0 on success, negative error code otherwise.
  */
-void vmemmap_remap_free(unsigned long start, unsigned long end,
-			unsigned long reuse)
+int vmemmap_remap_free(unsigned long start, unsigned long end,
+		       unsigned long reuse)
 {
+	int ret;
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
@@ -221,25 +300,31 @@ void vmemmap_remap_free(unsigned long st
 	 */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	vmemmap_remap_range(reuse, end, &walk);
-	free_vmemmap_page_list(&vmemmap_pages);
-}
+	mmap_write_lock(&init_mm);
+	ret = vmemmap_remap_range(reuse, end, &walk);
+	mmap_write_downgrade(&init_mm);
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
-				struct vmemmap_remap_walk *walk)
-{
-	pgprot_t pgprot = PAGE_KERNEL;
-	struct page *page;
-	void *to;
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
 
-	BUG_ON(pte_page(*pte) != walk->reuse_page);
+		vmemmap_remap_range(reuse, end, &walk);
+	}
+	mmap_read_unlock(&init_mm);
 
-	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&page->lru);
-	to = page_to_virt(page);
-	copy_page(to, (void *)walk->reuse_addr);
+	free_vmemmap_page_list(&vmemmap_pages);
 
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+	return ret;
 }
 
 static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
@@ -273,6 +358,8 @@ out:
  *		remap.
  * @reuse:	reuse address.
  * @gfp_mask:	GFP flag for allocating vmemmap pages.
+ *
+ * Return: %0 on success, negative error code otherwise.
  */
 int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			unsigned long reuse, gfp_t gfp_mask)
@@ -287,12 +374,12 @@ int vmemmap_remap_alloc(unsigned long st
 	/* See the comment in the vmemmap_remap_free(). */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
-
 	if (alloc_vmemmap_page_list(start, end, gfp_mask, &vmemmap_pages))
 		return -ENOMEM;
 
+	mmap_read_lock(&init_mm);
 	vmemmap_remap_range(reuse, end, &walk);
+	mmap_read_unlock(&init_mm);
 
 	return 0;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch
mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch
mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages.patch
mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch

