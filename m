From: akpm@linux-foundation.org
Subject: +
 mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces.patch added to -mm tree
Date: Mon, 16 Oct 2017 15:18:32 -0700
Message-ID: <59e53038.OabLXsUf9dtieZco%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932428AbdJPWSe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, aarcange@redhat.com, corbet@lwn.net, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: introduce dedicated transparent huge page allocation interfaces
has been added to the -mm tree.  Its filename is
     mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@intel.com>
Subject: mm, thp: introduce dedicated transparent huge page allocation interfaces

This patch introduced 4 new interfaces to allocate a prepared
transparent huge page.
  - alloc_transhuge_page_vma
  - alloc_transhuge_page_nodemask
  - alloc_transhuge_page_node
  - alloc_transhuge_page

The aim is to remove duplicated code and simplify transparent
huge page allocation. These are similar to alloc_hugepage_xxx
which are for hugetlbfs pages. This patch does below changes:
  - define alloc_transhuge_page_xxx interfaces
  - apply them to all existing code
  - declare prep_transhuge_page as static since no others use it
  - remove alloc_hugepage_vma definition since it no longer has users

Link: http://lkml.kernel.org/r/1508145557-9944-2-git-send-email-changbin.du@intel.com
Signed-off-by: Changbin Du <changbin.du@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h     |    4 ---
 include/linux/huge_mm.h |   13 +++++++++
 include/linux/migrate.h |   14 +++-------
 mm/huge_memory.c        |   50 ++++++++++++++++++++++++++++++++------
 mm/khugepaged.c         |   11 +-------
 mm/mempolicy.c          |   10 ++-----
 mm/migrate.c            |   12 +++------
 mm/shmem.c              |    6 +---
 8 files changed, 71 insertions(+), 49 deletions(-)

diff -puN include/linux/gfp.h~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces include/linux/gfp.h
--- a/include/linux/gfp.h~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/include/linux/gfp.h
@@ -498,15 +498,11 @@ alloc_pages(gfp_t gfp_mask, unsigned int
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
 			int node, bool hugepage);
-#define alloc_hugepage_vma(gfp_mask, vma, addr, order)	\
-	alloc_pages_vma(gfp_mask, order, vma, addr, numa_node_id(), true)
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
 #define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
 	alloc_pages(gfp_mask, order)
-#define alloc_hugepage_vma(gfp_mask, vma, addr, order)	\
-	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
diff -puN include/linux/huge_mm.h~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/include/linux/huge_mm.h
@@ -130,9 +130,20 @@ extern unsigned long thp_get_unmapped_ar
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags);
 
-extern void prep_transhuge_page(struct page *page);
 extern void free_transhuge_page(struct page *page);
 
+struct page *alloc_transhuge_page_vma(gfp_t gfp_mask,
+		struct vm_area_struct *vma, unsigned long addr);
+struct page *alloc_transhuge_page_nodemask(gfp_t gfp_mask,
+		int preferred_nid, nodemask_t *nmask);
+
+static inline struct page *alloc_transhuge_page_node(int nid, gfp_t gfp_mask)
+{
+	return alloc_transhuge_page_nodemask(gfp_mask, nid, NULL);
+}
+
+struct page *alloc_transhuge_page(gfp_t gfp_mask);
+
 bool can_split_huge_page(struct page *page, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
diff -puN include/linux/migrate.h~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces include/linux/migrate.h
--- a/include/linux/migrate.h~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/include/linux/migrate.h
@@ -42,19 +42,15 @@ static inline struct page *new_page_node
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
 				preferred_nid, nodemask);
 
-	if (thp_migration_supported() && PageTransHuge(page)) {
-		order = HPAGE_PMD_ORDER;
-		gfp_mask |= GFP_TRANSHUGE;
-	}
-
 	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
 
-	new_page = __alloc_pages_nodemask(gfp_mask, order,
+	if (thp_migration_supported() && PageTransHuge(page))
+		return alloc_transhuge_page_nodemask(gfp_mask | GFP_TRANSHUGE,
+				preferred_nid, nodemask);
+	else
+		return __alloc_pages_nodemask(gfp_mask, order,
 				preferred_nid, nodemask);
-
-	if (new_page && PageTransHuge(page))
-		prep_transhuge_page(new_page);
 
 	return new_page;
 }
diff -puN mm/huge_memory.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/mm/huge_memory.c
@@ -490,7 +490,7 @@ static inline struct list_head *page_def
 	return (struct list_head *)&page[2].mapping;
 }
 
-void prep_transhuge_page(struct page *page)
+static void prep_transhuge_page(struct page *page)
 {
 	/*
 	 * we use page->mapping and page->indexlru in second tail page
@@ -501,6 +501,45 @@ void prep_transhuge_page(struct page *pa
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
+struct page *alloc_transhuge_page_vma(gfp_t gfp_mask,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct page *page;
+
+	page = alloc_pages_vma(gfp_mask | __GFP_COMP, HPAGE_PMD_ORDER,
+			       vma, addr, numa_node_id(), true);
+	if (unlikely(!page))
+		return NULL;
+	prep_transhuge_page(page);
+	return page;
+}
+
+struct page *alloc_transhuge_page_nodemask(gfp_t gfp_mask,
+		int preferred_nid, nodemask_t *nmask)
+{
+	struct page *page;
+
+	page = __alloc_pages_nodemask(gfp_mask | __GFP_COMP, HPAGE_PMD_ORDER,
+				      preferred_nid, nmask);
+	if (unlikely(!page))
+		return NULL;
+	prep_transhuge_page(page);
+	return page;
+}
+
+struct page *alloc_transhuge_page(gfp_t gfp_mask)
+{
+	struct page *page;
+
+	VM_BUG_ON(!(gfp_mask & __GFP_COMP));
+
+	page = alloc_pages(gfp_mask | __GFP_COMP, HPAGE_PMD_ORDER);
+	if (unlikely(!page))
+		return NULL;
+	prep_transhuge_page(page);
+	return page;
+}
+
 unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size)
 {
@@ -719,12 +758,11 @@ int do_huge_pmd_anonymous_page(struct vm
 		return ret;
 	}
 	gfp = alloc_hugepage_direct_gfpmask(vma);
-	page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
+	page = alloc_transhuge_page_vma(gfp, vma, haddr);
 	if (unlikely(!page)) {
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	prep_transhuge_page(page);
 	return __do_huge_pmd_anonymous_page(vmf, page, gfp);
 }
 
@@ -1295,13 +1333,11 @@ alloc:
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow()) {
 		huge_gfp = alloc_hugepage_direct_gfpmask(vma);
-		new_page = alloc_hugepage_vma(huge_gfp, vma, haddr, HPAGE_PMD_ORDER);
+		new_page = alloc_transhuge_page_vma(huge_gfp, vma, haddr);
 	} else
 		new_page = NULL;
 
-	if (likely(new_page)) {
-		prep_transhuge_page(new_page);
-	} else {
+	if (unlikely(!new_page)) {
 		if (!page) {
 			split_huge_pmd(vma, vmf->pmd, vmf->address);
 			ret |= VM_FAULT_FALLBACK;
diff -puN mm/khugepaged.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/mm/khugepaged.c
@@ -745,14 +745,13 @@ khugepaged_alloc_page(struct page **hpag
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
-	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
+	*hpage = alloc_transhuge_page_node(node, gfp);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
 		return NULL;
 	}
 
-	prep_transhuge_page(*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return *hpage;
 }
@@ -764,13 +763,7 @@ static int khugepaged_find_target_node(v
 
 static inline struct page *alloc_khugepaged_hugepage(void)
 {
-	struct page *page;
-
-	page = alloc_pages(alloc_hugepage_khugepaged_gfpmask(),
-			   HPAGE_PMD_ORDER);
-	if (page)
-		prep_transhuge_page(page);
-	return page;
+	return alloc_transhuge_page(alloc_hugepage_khugepaged_gfpmask());
 }
 
 static struct page *khugepaged_alloc_hugepage(bool *wait)
diff -puN mm/mempolicy.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/mm/mempolicy.c
@@ -949,12 +949,10 @@ static struct page *new_node_page(struct
 	else if (thp_migration_supported() && PageTransHuge(page)) {
 		struct page *thp;
 
-		thp = alloc_pages_node(node,
-			(GFP_TRANSHUGE | __GFP_THISNODE),
-			HPAGE_PMD_ORDER);
+		thp = alloc_transhuge_page_node(node,
+			(GFP_TRANSHUGE | __GFP_THISNODE));
 		if (!thp)
 			return NULL;
-		prep_transhuge_page(thp);
 		return thp;
 	} else
 		return __alloc_pages_node(node, GFP_HIGHUSER_MOVABLE |
@@ -1125,11 +1123,9 @@ static struct page *new_page(struct page
 	} else if (thp_migration_supported() && PageTransHuge(page)) {
 		struct page *thp;
 
-		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
-					 HPAGE_PMD_ORDER);
+		thp = alloc_transhuge_page_vma(GFP_TRANSHUGE, vma, address);
 		if (!thp)
 			return NULL;
-		prep_transhuge_page(thp);
 		return thp;
 	}
 	/*
diff -puN mm/migrate.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces mm/migrate.c
--- a/mm/migrate.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/mm/migrate.c
@@ -1472,12 +1472,10 @@ static struct page *new_page_node(struct
 	else if (thp_migration_supported() && PageTransHuge(p)) {
 		struct page *thp;
 
-		thp = alloc_pages_node(pm->node,
-			(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_RECLAIM,
-			HPAGE_PMD_ORDER);
+		thp = alloc_transhuge_page_node(pm->node,
+			(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_RECLAIM);
 		if (!thp)
 			return NULL;
-		prep_transhuge_page(thp);
 		return thp;
 	} else
 		return __alloc_pages_node(pm->node,
@@ -2017,12 +2015,10 @@ int migrate_misplaced_transhuge_page(str
 	if (numamigrate_update_ratelimit(pgdat, HPAGE_PMD_NR))
 		goto out_dropref;
 
-	new_page = alloc_pages_node(node,
-		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
-		HPAGE_PMD_ORDER);
+	new_page = alloc_transhuge_page_node(node,
+			(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE));
 	if (!new_page)
 		goto out_fail;
-	prep_transhuge_page(new_page);
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff -puN mm/shmem.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces mm/shmem.c
--- a/mm/shmem.c~mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces
+++ a/mm/shmem.c
@@ -1444,11 +1444,9 @@ static struct page *shmem_alloc_hugepage
 	rcu_read_unlock();
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
-	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-			HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(), true);
+	gfp |= __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN;
+	page = alloc_transhuge_page_vma(gfp, &pvma, 0);
 	shmem_pseudo_vma_destroy(&pvma);
-	if (page)
-		prep_transhuge_page(page);
 	return page;
 }
 
_

Patches currently in -mm which might be from changbin.du@intel.com are

mm-update-comments-for-struct-pagemapping.patch
mm-swap_statec-declare-a-few-variables-as-__read_mostly.patch
mm-thp-introduce-dedicated-transparent-huge-page-allocation-interfaces.patch
mm-rename-page-dtor-functions-to-compoundhugetranshuge_page__dtor.patch

