Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5798C433E9
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 20:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E2CB64F4C
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 20:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhCOUsb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 16:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231871AbhCOUsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 16:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DEC64F3F;
        Mon, 15 Mar 2021 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615841300;
        bh=WRvEVg9HBC10Av9in/ldBzbRtOBd9Yp6oNqDAcnJBmM=;
        h=Date:From:To:Subject:From;
        b=Mf82YByaZanUdltsbVdh40s41FBdY0EkDma3n7IHS2JpN7f9QcJxutfzminlL3cSc
         VFLU7aehwoBIKhwnEbMNA8OuPwpU2t/G6GoqXFZX82lU2lFuf4Z/e36AX4mAXqswFE
         0fiNOwu9paxglV316vwbpNiTeCdnLFFEqg7064DM=
Date:   Mon, 15 Mar 2021 13:48:19 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, hpa@zytor.com, joao.m.martins@oracle.com,
        jroedel@suse.de, linmiaohe@huawei.com, luto@kernel.org,
        mchehab+huawei@kernel.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        oneukum@suse.com, osalvador@suse.de, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
 added to -mm tree
Message-ID: <20210315204819.8xAywsXO5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: alloc the vmemmap pages associated with each HugeTLB page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch

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
Subject: mm: hugetlb: alloc the vmemmap pages associated with each HugeTLB page

When we free a HugeTLB page to the buddy allocator, we need to allocate
the vmemmap pages associated with it.  However, we may not be able to
allocate the vmemmap pages when the system is under memory pressure.  In
this case, we just refuse to free the HugeTLB page.  This changes behavior
in some corner cases as listed below:

 1) Failing to free a huge page triggered by the user (decrease nr_pages).

    User needs to try again later.

 2) Failing to free a surplus huge page when freed by the application.

    Try again later when freeing a huge page next time.

 3) Failing to dissolve a free huge page on ZONE_MOVABLE via
    offline_pages().

    This can happen when we have plenty of ZONE_MOVABLE memory, but
    not enough kernel memory to allocate vmemmmap pages.  We may even
    be able to migrate huge page contents, but will not be able to
    dissolve the source huge page.  This will prevent an offline
    operation and is unfortunate as memory offlining is expected to
    succeed on movable zones.  Users that depend on memory hotplug
    to succeed for movable zones should carefully consider whether the
    memory savings gained from this feature are worth the risk of
    possibly not being able to offline memory in certain situations.

 4) Failing to dissolve a huge page on CMA/ZONE_MOVABLE via
    alloc_contig_range() - once we have that handling in place. Mainly
    affects CMA and virtio-mem.

    Similar to 3). virito-mem will handle migration errors gracefully.
    CMA might be able to fallback on other free areas within the CMA
    region.

Vmemmap pages are allocated from the page freeing context.  In order for
those allocations to be not disruptive (e.g.  trigger oom killer)
__GFP_NORETRY is used.  hugetlb_lock is dropped for the allocation because
a non sleeping allocation would be too fragile and it could fail too
easily under memory pressure.  GFP_ATOMIC or other modes to access memory
reserves is not used because we want to prevent consuming reserves under
heavy hugetlb freeing.

Link: https://lkml.kernel.org/r/20210315092015.35396-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Chen Huang <chenhuang5@huawei.com>
Tested-by: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/hugetlbpage.rst    |    8 +
 Documentation/admin-guide/mm/memory-hotplug.rst |   13 ++
 include/linux/mm.h                              |    2 
 mm/hugetlb.c                                    |   76 +++++++++++---
 mm/hugetlb_vmemmap.c                            |   43 +++++--
 mm/hugetlb_vmemmap.h                            |   23 ++++
 mm/sparse-vmemmap.c                             |   75 +++++++++++++
 7 files changed, 211 insertions(+), 29 deletions(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -60,6 +60,10 @@ HugePages_Surp
         the pool above the value in ``/proc/sys/vm/nr_hugepages``. The
         maximum number of surplus huge pages is controlled by
         ``/proc/sys/vm/nr_overcommit_hugepages``.
+	Note: When the feature of freeing unused vmemmap pages associated
+	with each hugetlb page is enabled, the number of surplus huge pages
+	may be temporarily larger than the maximum number of surplus huge
+	pages when the system is under memory pressure.
 Hugepagesize
 	is the default hugepage size (in Kb).
 Hugetlb
@@ -80,6 +84,10 @@ returned to the huge page pool when free
 privileges can dynamically allocate more or free some persistent huge pages
 by increasing or decreasing the value of ``nr_hugepages``.
 
+Note: When the feature of freeing unused vmemmap pages associated with each
+hugetlb page is enabled, we can fail to free the huge pages triggered by
+the user when ths system is under memory pressure.  Please try again later.
+
 Pages that are used as huge pages are reserved inside the kernel and cannot
 be used for other purposes.  Huge pages cannot be swapped out under
 memory pressure.
--- a/Documentation/admin-guide/mm/memory-hotplug.rst~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -357,6 +357,19 @@ creates ZONE_MOVABLE as following.
    Unfortunately, there is no information to show which memory block belongs
    to ZONE_MOVABLE. This is TBD.
 
+   Memory offlining can fail when dissolving a free huge page on ZONE_MOVABLE
+   and the feature of freeing unused vmemmap pages associated with each hugetlb
+   page is enabled.
+
+   This can happen when we have plenty of ZONE_MOVABLE memory, but not enough
+   kernel memory to allocate vmemmmap pages.  We may even be able to migrate
+   huge page contents, but will not be able to dissolve the source huge page.
+   This will prevent an offline operation and is unfortunate as memory offlining
+   is expected to succeed on movable zones.  Users that depend on memory hotplug
+   to succeed for movable zones should carefully consider whether the memory
+   savings gained from this feature are worth the risk of possibly not being
+   able to offline memory in certain situations.
+
 .. _memory_hotplug_how_to_offline_memory:
 
 How to offline memory
--- a/include/linux/mm.h~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/include/linux/mm.h
@@ -3006,6 +3006,8 @@ static inline void print_vma_addr(char *
 
 void vmemmap_remap_free(unsigned long start, unsigned long end,
 			unsigned long reuse);
+int vmemmap_remap_alloc(unsigned long start, unsigned long end,
+			unsigned long reuse, gfp_t gfp_mask);
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
--- a/mm/hugetlb.c~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/mm/hugetlb.c
@@ -1329,16 +1329,53 @@ static inline void destroy_compound_giga
 						unsigned int order) { }
 #endif
 
-static void update_and_free_page(struct hstate *h, struct page *page)
+static int update_and_free_page_surplus(struct hstate *h, struct page *page,
+					bool acct_surplus)
+	__releases(&hugetlb_lock) __acquires(&hugetlb_lock)
 {
 	int i;
 	struct page *subpage = page;
+	int nid = page_to_nid(page);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
-		return;
+		return 0;
 
 	h->nr_huge_pages--;
-	h->nr_huge_pages_node[page_to_nid(page)]--;
+	h->nr_huge_pages_node[nid]--;
+
+	/*
+	 * If the vmemmap pages associated with the HugeTLB page can be
+	 * optimized, we might block in alloc_huge_page_vmemmap(), so
+	 * drop the hugetlb_lock.
+	 */
+	if (free_vmemmap_pages_per_hpage(h))
+		spin_unlock(&hugetlb_lock);
+
+	if (alloc_huge_page_vmemmap(h, page)) {
+		spin_lock(&hugetlb_lock);
+		INIT_LIST_HEAD(&page->lru);
+		h->nr_huge_pages++;
+		h->nr_huge_pages_node[nid]++;
+
+		/*
+		 * If we cannot allocate vmemmap pages, just refuse to free the
+		 * page and put the page back on the hugetlb free list and treat
+		 * as a surplus page.
+		 */
+		if (acct_surplus) {
+			h->surplus_huge_pages++;
+			h->surplus_huge_pages_node[nid]++;
+		}
+
+		arch_clear_hugepage_flags(page);
+		enqueue_huge_page(h, page);
+
+		return -ENOMEM;
+	}
+
+	if (free_vmemmap_pages_per_hpage(h))
+		spin_lock(&hugetlb_lock);
+
 	for (i = 0; i < pages_per_huge_page(h);
 	     i++, subpage = mem_map_next(subpage, page, i)) {
 		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
@@ -1362,6 +1399,13 @@ static void update_and_free_page(struct
 	} else {
 		__free_pages(page, huge_page_order(h));
 	}
+
+	return 0;
+}
+
+static inline int update_and_free_page(struct hstate *h, struct page *page)
+{
+	return update_and_free_page_surplus(h, page, true);
 }
 
 struct hstate *size_to_hstate(unsigned long size)
@@ -1429,9 +1473,9 @@ static void __free_huge_page(struct page
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		list_del(&page->lru);
-		update_and_free_page(h, page);
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
+		update_and_free_page(h, page);
 	} else {
 		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
@@ -1472,7 +1516,7 @@ void free_huge_page(struct page *page)
 	/*
 	 * Defer freeing if in non-task context to avoid hugetlb_lock deadlock.
 	 */
-	if (!in_task()) {
+	if (in_atomic()) {
 		/*
 		 * Only call schedule_work() if hpage_freelist is previously
 		 * empty. Otherwise, schedule_work() had been called but the
@@ -1719,14 +1763,14 @@ static int free_pool_huge_page(struct hs
 				list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
 			list_del(&page->lru);
+			ClearHPageFreed(page);
 			h->free_huge_pages--;
 			h->free_huge_pages_node[node]--;
 			if (acct_surplus) {
 				h->surplus_huge_pages--;
 				h->surplus_huge_pages_node[node]--;
 			}
-			update_and_free_page(h, page);
-			ret = 1;
+			ret = !update_and_free_page(h, page);
 			break;
 		}
 	}
@@ -1739,10 +1783,14 @@ static int free_pool_huge_page(struct hs
  * nothing for in-use hugepages and non-hugepages.
  * This function returns values like below:
  *
- *  -EBUSY: failed to dissolved free hugepages or the hugepage is in-use
- *          (allocated or reserved.)
- *       0: successfully dissolved free hugepages or the page is not a
- *          hugepage (considered as already dissolved)
+ *  -ENOMEM: failed to allocate vmemmap pages to free the freed hugepages
+ *           when the system is under memory pressure and the feature of
+ *           freeing unused vmemmap pages associated with each hugetlb page
+ *           is enabled.
+ *  -EBUSY:  failed to dissolved free hugepages or the hugepage is in-use
+ *           (allocated or reserved.)
+ *       0:  successfully dissolved free hugepages or the page is not a
+ *           hugepage (considered as already dissolved)
  */
 int dissolve_free_huge_page(struct page *page)
 {
@@ -1794,11 +1842,13 @@ retry:
 			ClearPageHWPoison(head);
 		}
 		list_del(&head->lru);
+		ClearHPageFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		h->max_huge_pages--;
-		update_and_free_page(h, head);
-		rc = 0;
+		rc = update_and_free_page_surplus(h, head, false);
+		if (rc)
+			h->max_huge_pages++;
 	}
 out:
 	spin_unlock(&hugetlb_lock);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/mm/hugetlb_vmemmap.c
@@ -18,10 +18,9 @@
  * 4096 base pages. For each base page, there is a corresponding page struct.
  *
  * Within the HugeTLB subsystem, only the first 4 page structs are used to
- * contain unique information about a HugeTLB page. HUGETLB_CGROUP_MIN_ORDER
- * provides this upper limit. The only 'useful' information in the remaining
- * page structs is the compound_head field, and this field is the same for all
- * tail pages.
+ * contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
+ * this upper limit. The only 'useful' information in the remaining page structs
+ * is the compound_head field, and this field is the same for all tail pages.
  *
  * By removing redundant page structs for HugeTLB pages, memory can be returned
  * to the buddy allocator for other uses.
@@ -181,21 +180,35 @@
 #define RESERVE_VMEMMAP_NR		2U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
-/*
- * How many vmemmap pages associated with a HugeTLB page that can be freed
- * to the buddy allocator.
- *
- * Todo: Returns zero for now, which means the feature is disabled. We will
- * enable it once all the infrastructure is there.
- */
-static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+static inline unsigned long free_vmemmap_pages_size_per_hpage(struct hstate *h)
 {
-	return 0;
+	return (unsigned long)free_vmemmap_pages_per_hpage(h) << PAGE_SHIFT;
 }
 
-static inline unsigned long free_vmemmap_pages_size_per_hpage(struct hstate *h)
+/*
+ * Previously discarded vmemmap pages will be allocated and remapping
+ * after this function returns.
+ */
+int alloc_huge_page_vmemmap(struct hstate *h, struct page *head)
 {
-	return (unsigned long)free_vmemmap_pages_per_hpage(h) << PAGE_SHIFT;
+	unsigned long vmemmap_addr = (unsigned long)head;
+	unsigned long vmemmap_end, vmemmap_reuse;
+
+	if (!free_vmemmap_pages_per_hpage(h))
+		return 0;
+
+	vmemmap_addr += RESERVE_VMEMMAP_SIZE;
+	vmemmap_end = vmemmap_addr + free_vmemmap_pages_size_per_hpage(h);
+	vmemmap_reuse = vmemmap_addr - PAGE_SIZE;
+	/*
+	 * The pages which the vmemmap virtual address range [@vmemmap_addr,
+	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
+	 * the range is mapped to the page which @vmemmap_reuse is mapped to.
+	 * When a HugeTLB page is freed to the buddy allocator, previously
+	 * discarded vmemmap pages must be allocated and remapping.
+	 */
+	return vmemmap_remap_alloc(vmemmap_addr, vmemmap_end, vmemmap_reuse,
+				   GFP_KERNEL | __GFP_NORETRY | __GFP_THISNODE);
 }
 
 void free_huge_page_vmemmap(struct hstate *h, struct page *head)
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/mm/hugetlb_vmemmap.h
@@ -11,10 +11,33 @@
 #include <linux/hugetlb.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+int alloc_huge_page_vmemmap(struct hstate *h, struct page *head);
 void free_huge_page_vmemmap(struct hstate *h, struct page *head);
+
+/*
+ * How many vmemmap pages associated with a HugeTLB page that can be freed
+ * to the buddy allocator.
+ *
+ * Todo: Returns zero for now, which means the feature is disabled. We will
+ * enable it once all the infrastructure is there.
+ */
+static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+{
+	return 0;
+}
 #else
+static inline int alloc_huge_page_vmemmap(struct hstate *h, struct page *head)
+{
+	return 0;
+}
+
 static inline void free_huge_page_vmemmap(struct hstate *h, struct page *head)
 {
 }
+
+static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+{
+	return 0;
+}
 #endif /* CONFIG_HUGETLB_PAGE_FREE_VMEMMAP */
 #endif /* _LINUX_HUGETLB_VMEMMAP_H */
--- a/mm/sparse-vmemmap.c~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page
+++ a/mm/sparse-vmemmap.c
@@ -40,7 +40,8 @@
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @reuse_page:		the page which is reused for the tail vmemmap pages.
  * @reuse_addr:		the virtual address of the @reuse_page page.
- * @vmemmap_pages:	the list head of the vmemmap pages that can be freed.
+ * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
+ *			or is mapped from.
  */
 struct vmemmap_remap_walk {
 	void (*remap_pte)(pte_t *pte, unsigned long addr,
@@ -224,6 +225,78 @@ void vmemmap_remap_free(unsigned long st
 	free_vmemmap_page_list(&vmemmap_pages);
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
+ * @gpf_mask:	GFP flag for allocating vmemmap pages.
+ */
+int vmemmap_remap_alloc(unsigned long start, unsigned long end,
+			unsigned long reuse, gfp_t gfp_mask)
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
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+
+	if (alloc_vmemmap_page_list(start, end, gfp_mask, &vmemmap_pages))
+		return -ENOMEM;
+
+	vmemmap_remap_range(reuse, end, &walk);
+
+	return 0;
+}
+
 /*
  * Allocate a block of memory to be used to back the virtual memory map
  * or to back the page tables that are used to create the mapping.
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

