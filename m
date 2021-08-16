Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6B5C4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B5160F36
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhHPXaP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234662AbhHPXaB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 19:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A105960F36;
        Mon, 16 Aug 2021 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629156569;
        bh=OHlUb6MidmBBNucAQpwi3aDNhSr96p+V4l4WwZeaR0s=;
        h=Date:From:To:Subject:From;
        b=I8DbQLCV9Mm3IxkmalZebC7L+tHcTgvxCV7YAiqXLvy+YFhndhfJ+WHEjnWgC4x0w
         3fSxUw8fLgx6a1AU+zzbJoVoCXo0a6Rk541Aj1uMjWmPGxRodG7zhnX0HMKScUKX7R
         RfN+I5sbyiy4YbfMiIRu1e6i2xwQEgTkCBUHBuuQ=
Date:   Mon, 16 Aug 2021 16:29:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        mike.kravetz@oracle.com
Subject:  +
 hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch added to -mm
 tree
Message-ID: <20210816232929.G-hIt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: vmemmap optimizations when demoting hugetlb pages
has been added to the -mm tree.  Its filename is
     hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: vmemmap optimizations when demoting hugetlb pages

When demoting a hugetlb page with optimized vmemmap, we allocate vmemmap
for the entire address range represented by the huge page.  Then, we split
the huge page into huge pages of a smaller size.  When preparing these
smaller huge pages for use, we optimize vmemmap for their associated
address range and free vmemmap pages.

It is sub-optimal to allocate all the vmemmap pages associated with the
original page and then free most of those pages when preparing the smaller
huge pages after the split.  Instead, calculate the number of vmemmap
pages needed after the split and just allocate that number of pages. 
Then, only populate those areas of the vmmap required for the smaller huge
pages.

Introduce two new routines:
- demote_huge_page_vmemmap - This has knowledge of the hugetlb demote
  process and will calculate the number of huge pages needed for the
  smaller huge pages after the split.  It also creates a 'demote_mask'
  that is used to indicate where within the address range of the
  original huge page the smaller huge pages will reside.  This mask is
  used to map vmemmap pages within the range.
- vmemmap_remap_demote - This is the routine which actually allocates
  the vmemmap pages and performs vmemmap manipulations based on the
  passed demote_mask.

These routines will be used in a subsequent patch.

Link: https://lkml.kernel.org/r/20210816224953.157796-7-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    4 +
 mm/hugetlb_vmemmap.c |   60 ++++++++++++++++++++
 mm/hugetlb_vmemmap.h |    6 ++
 mm/sparse-vmemmap.c  |  123 +++++++++++++++++++++++++++++++++++++++--
 4 files changed, 189 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages
+++ a/include/linux/mm.h
@@ -3071,6 +3071,10 @@ int vmemmap_remap_free(unsigned long sta
 		       unsigned long reuse);
 int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			unsigned long reuse, gfp_t gfp_mask);
+int vmemmap_remap_demote(unsigned long start, unsigned long end,
+			unsigned long reuse, unsigned long demote_nr_pages,
+			unsigned long demote_mask,
+			unsigned long demote_map_pages, gfp_t gfp_mask);
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
--- a/mm/hugetlb_vmemmap.c~hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -264,6 +264,66 @@ void free_huge_page_vmemmap(struct hstat
 		SetHPageVmemmapOptimized(head);
 }
 
+/*
+ * vmammap pages will be allocated and mapped such that this range which
+ * previously represented a single huge page will now represent a set of
+ * pages of a smaller size.
+ */
+int demote_huge_page_vmemmap(struct hstate *h, struct page *head)
+{
+	int ret;
+	unsigned long vmemmap_addr = (unsigned long)head;
+	unsigned long vmemmap_end, vmemmap_reuse;
+	unsigned long demote_mask;
+	unsigned long demote_nr_pages;
+	struct hstate *target;
+
+	VM_BUG_ON(!h->demote_order);
+	if (!HPageVmemmapOptimized(head))
+		return 0;
+
+	target = size_to_hstate(PAGE_SIZE << h->demote_order);
+
+	/* Number of vmemmap pages required to demote page */
+	demote_nr_pages = pages_per_huge_page(h) / pages_per_huge_page(target);
+	demote_nr_pages *= RESERVE_VMEMMAP_NR;
+	demote_nr_pages -= RESERVE_VMEMMAP_NR;	/* pages currently present */
+
+	/*
+	 * mask to identify where within the range new smaller pages will
+	 * reside.  This will be used to map new vmemmap pages.
+	 */
+	demote_mask = ((unsigned long) pages_per_huge_page(target) *
+			sizeof(struct page)) - 1;
+
+	vmemmap_addr += RESERVE_VMEMMAP_SIZE;
+	vmemmap_end = vmemmap_addr + free_vmemmap_pages_size_per_hpage(h);
+	vmemmap_reuse = vmemmap_addr - PAGE_SIZE;
+	/*
+	 * The range [@vmemmap_addr, @vmemmap_end) represents a single huge
+	 * page of size h->order.  It is vmemmap optimized and is only mapped
+	 * with RESERVE_VMEMMAP_NR pages.  The huge page will be split into
+	 * multiple pages of a smaller size (h->demote_order).  vmemmap pages
+	 * must be callocated for each of these smaller size pages and
+	 * appropriately mapped.
+	 */
+	ret = vmemmap_remap_demote(vmemmap_addr, vmemmap_end, vmemmap_reuse,
+				  demote_nr_pages, demote_mask,
+				  RESERVE_VMEMMAP_NR,
+				  GFP_KERNEL | __GFP_NORETRY | __GFP_THISNODE);
+
+	if (!ret) {
+		int i;
+
+		for (i = pages_per_huge_page(target);
+					i < pages_per_huge_page(h);
+					i += pages_per_huge_page(target))
+			SetHPageVmemmapOptimized(head + i);
+	}
+
+	return ret;
+}
+
 void __init hugetlb_vmemmap_init(struct hstate *h)
 {
 	unsigned int nr_pages = pages_per_huge_page(h);
--- a/mm/hugetlb_vmemmap.h~hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
 int alloc_huge_page_vmemmap(struct hstate *h, struct page *head);
 void free_huge_page_vmemmap(struct hstate *h, struct page *head);
+int demote_huge_page_vmemmap(struct hstate *h, struct page *head);
 void hugetlb_vmemmap_init(struct hstate *h);
 
 /*
@@ -33,6 +34,11 @@ static inline void free_huge_page_vmemma
 {
 }
 
+static inline int demote_huge_page_vmemmap(struct hstate *h, struct page *head)
+{
+	return 0;
+}
+
 static inline void hugetlb_vmemmap_init(struct hstate *h)
 {
 }
--- a/mm/sparse-vmemmap.c~hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages
+++ a/mm/sparse-vmemmap.c
@@ -43,6 +43,15 @@
  * @reuse_addr:		the virtual address of the @reuse_page page.
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
  *			or is mapped from.
+ * @demote_mask		demote specific.  mask to know virtual address of
+ *			where to start mapping pages during a demote operation.
+ * @demote_map_pages	demote specific.  number of pages which mapped for
+ *			each demoted page.
+ * @demote_tmp_count	demote specific.  counter for the number of pages
+ *			mapped per page.
+ * @demote_tmp_addr	demote specific.  when more then one page must be
+ *			mapped for each demoted size page, virtual address
+ *			of the next page to be mapped.
  */
 struct vmemmap_remap_walk {
 	void (*remap_pte)(pte_t *pte, unsigned long addr,
@@ -51,6 +60,10 @@ struct vmemmap_remap_walk {
 	struct page *reuse_page;
 	unsigned long reuse_addr;
 	struct list_head *vmemmap_pages;
+	unsigned long demote_mask;
+	unsigned long demote_map_pages;
+	unsigned long demote_tmp_count;
+	unsigned long demote_tmp_addr;
 };
 
 static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start,
@@ -262,6 +275,51 @@ static void vmemmap_restore_pte(pte_t *p
 	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
 }
 
+static void vmemmap_demote_pte(pte_t *pte, unsigned long addr,
+				struct vmemmap_remap_walk *walk)
+{
+	pgprot_t pgprot = PAGE_KERNEL;
+	struct page *page;
+	void *to;
+
+	if (!(addr & walk->demote_mask)) {
+		/* head page */
+		page = list_first_entry(walk->vmemmap_pages, struct page, lru);
+		list_del(&page->lru);
+		to = page_to_virt(page);
+		copy_page(to, (void *)walk->reuse_addr);
+		set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+		/*
+		 * after mapping head page, set demote_tmp_reuse for
+		 * the following tail page to be mapped (if any).
+		 */
+		walk->demote_tmp_count = walk->demote_map_pages;
+		if (--walk->demote_tmp_count)
+			walk->demote_tmp_addr = addr + PAGE_SIZE;
+	} else if (addr == walk->demote_tmp_addr) {
+		/* first tall page */
+		page = list_first_entry(walk->vmemmap_pages, struct page, lru);
+		list_del(&page->lru);
+		to = page_to_virt(page);
+		copy_page(to, (void *)walk->reuse_addr);
+		set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+		if (--walk->demote_tmp_count) {
+			walk->demote_tmp_addr = addr + PAGE_SIZE;
+		} else {
+			walk->demote_tmp_addr = 0UL;
+			/* remaining tail pages mapped to this page */
+			walk->reuse_page = page;
+		}
+	} else {
+		/* remaining tail pages */
+		pgprot_t pgprot = PAGE_KERNEL_RO;
+		pte_t entry = mk_pte(walk->reuse_page, pgprot);
+
+		page = pte_page(*pte);
+		set_pte_at(&init_mm, addr, pte, entry);
+	}
+}
+
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
  *			to the page which @reuse is mapped to, then free vmemmap
@@ -327,11 +385,9 @@ int vmemmap_remap_free(unsigned long sta
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
+static int __alloc_vmemmap_pages(unsigned long nr_pages, int nid,
 				   gfp_t gfp_mask, struct list_head *list)
 {
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
 
 	while (nr_pages--) {
@@ -348,6 +404,21 @@ out:
 	return -ENOMEM;
 }
 
+static int alloc_vmemmap_pages(unsigned long nr_pages, int nid,
+				   gfp_t gfp_mask, struct list_head *list)
+{
+	return __alloc_vmemmap_pages(nr_pages, nid, gfp_mask, list);
+}
+
+static int alloc_vmemmap_range(unsigned long start, unsigned long end,
+				   gfp_t gfp_mask, struct list_head *list)
+{
+	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
+	int nid = page_to_nid((struct page *)start);
+
+	return __alloc_vmemmap_pages(nr_pages, nid, gfp_mask, list);
+}
+
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
@@ -374,7 +445,51 @@ int vmemmap_remap_alloc(unsigned long st
 	/* See the comment in the vmemmap_remap_free(). */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	if (alloc_vmemmap_page_list(start, end, gfp_mask, &vmemmap_pages))
+	if (alloc_vmemmap_range(start, end, gfp_mask, &vmemmap_pages))
+		return -ENOMEM;
+
+	mmap_read_lock(&init_mm);
+	vmemmap_remap_range(reuse, end, &walk);
+	mmap_read_unlock(&init_mm);
+
+	return 0;
+}
+
+/**
+ * vmemmap_remap_demote - remap the optimized vmemmap virtual address range
+ *		for a huge page to accommodate splitting that huge
+ *		page into pages of a smaller size.  That smaller size
+ *		is specified by demote_mask.
+ * @start:	start address of the vmemmap virtual address range to remap
+ *		for smaller pages.
+ * @end:	end address of the vmemmap virtual address range to remap.
+ * @reuse:	reuse address.
+ * @demote_nr_pages: number of vmammap pages to allocate for remapping.
+ * @demote_mask: mask specifying where to perform remapping within the passed
+ *		 range.
+ * @demote_map_pages: number of pages to map for each demoted page
+ * @gfp_mask:	GFP flag for allocating vmemmap pages.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int vmemmap_remap_demote(unsigned long start, unsigned long end,
+			unsigned long reuse, unsigned long demote_nr_pages,
+			unsigned long demote_mask,
+			unsigned long demote_map_pages, gfp_t gfp_mask)
+{
+	LIST_HEAD(vmemmap_pages);
+	int nid = page_to_nid((struct page *)start);
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_demote_pte,
+		.reuse_addr	= reuse,
+		.vmemmap_pages	= &vmemmap_pages,
+		.demote_mask	= demote_mask,
+		.demote_map_pages = demote_map_pages,
+	};
+
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+
+	if (alloc_vmemmap_pages(demote_nr_pages, nid, gfp_mask, &vmemmap_pages))
 		return -ENOMEM;
 
 	mmap_read_lock(&init_mm);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch
hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-document-the-demote-sysfs-interfaces.patch
hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch
hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch

