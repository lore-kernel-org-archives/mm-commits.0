From: akpm@linux-foundation.org
Subject: + mempolicy-apply-page-table-walker-on-queue_pages_range.patch
 added to -mm tree
Date: Mon, 10 Feb 2014 14:42:24 -0800
Message-ID: <52f955d0.HZp8on+eo3afGJDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaBJWmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:42:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + mempolicy-apply-page-table-walker-on-queue_pages_range.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,cpw@sgi.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mpm@selenic.com,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:42:24 -0800


The patch titled
     Subject: mempolicy: apply page table walker on queue_pages_range()
has been added to the -mm tree.  Its filename is
     mempolicy-apply-page-table-walker-on-queue_pages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-apply-page-table-walker-on-queue_pages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-apply-page-table-walker-on-queue_pages_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mempolicy: apply page table walker on queue_pages_range()

queue_pages_range() does page table walking in its own way now, so this
patch rewrites it with walk_page_range().  One difficulty was that
queue_pages_range() needed to check vmas to determine whether we queue
pages from a given vma or skip it.  Now we have test_walk() callback in
mm_walk for that purpose, so we can do the replacement cleanly. 
queue_pages_test_walk() depends on not only the current vma but also the
previous one, so we use queue_pages->prev to keep it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |  265 ++++++++++++++++++-----------------------------
 1 file changed, 104 insertions(+), 161 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-apply-page-table-walker-on-queue_pages_range mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-apply-page-table-walker-on-queue_pages_range
+++ a/mm/mempolicy.c
@@ -476,140 +476,66 @@ static const struct mempolicy_operations
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
+struct queue_pages {
+	struct list_head *pagelist;
+	unsigned long flags;
+	nodemask_t *nmask;
+	struct vm_area_struct *prev;
+};
+
 /*
  * Scan through pages checking if pages follow certain conditions,
  * and move them to the pagelist if they do.
  */
-static int queue_pages_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pte_t *orig_pte;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	do {
-		struct page *page;
-		int nid;
-
-		if (!pte_present(*pte))
-			continue;
-		page = vm_normal_page(vma, addr, *pte);
-		if (!page)
-			continue;
-		/*
-		 * vm_normal_page() filters out zero pages, but there might
-		 * still be PageReserved pages to skip, perhaps in a VDSO.
-		 */
-		if (PageReserved(page))
-			continue;
-		nid = page_to_nid(page);
-		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
-			continue;
-
-		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-			migrate_page_add(page, private, flags);
-		else
-			break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(orig_pte, ptl);
-	return addr != end;
-}
-
-static void queue_pages_hugetlb_pmd_range(struct vm_area_struct *vma,
-		pmd_t *pmd, const nodemask_t *nodes, unsigned long flags,
-				    void *private)
+static int queue_pages_pte(pte_t *pte, unsigned long addr,
+			unsigned long next, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct page *page;
+	struct queue_pages *qp = walk->private;
+	unsigned long flags = qp->flags;
+	int nid;
+
+	if (!pte_present(*pte))
+		return 0;
+	page = vm_normal_page(vma, addr, *pte);
+	if (!page)
+		return 0;
+	/*
+	 * vm_normal_page() filters out zero pages, but there might
+	 * still be PageReserved pages to skip, perhaps in a VDSO.
+	 */
+	if (PageReserved(page))
+		return 0;
+	nid = page_to_nid(page);
+	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
+		return 0;
+
+	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+		migrate_page_add(page, qp->pagelist, flags);
+	return 0;
+}
+
+static int queue_pages_hugetlb(pte_t *pte, unsigned long addr,
+				unsigned long next, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
+	struct queue_pages *qp = walk->private;
+	unsigned long flags = qp->flags;
 	int nid;
 	struct page *page;
-	spinlock_t *ptl;
 
-	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
-	page = pte_page(huge_ptep_get((pte_t *)pmd));
+	page = pte_page(huge_ptep_get(pte));
 	nid = page_to_nid(page);
-	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
-		goto unlock;
+	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
+		return 0;
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
-		isolate_huge_page(page, private);
-unlock:
-	spin_unlock(ptl);
+		isolate_huge_page(page, qp->pagelist);
 #else
 	BUG();
 #endif
-}
-
-static inline int queue_pages_pmd_range(struct vm_area_struct *vma, pud_t *pud,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pmd_t *pmd;
-	unsigned long next;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (!pmd_present(*pmd))
-			continue;
-		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
-			queue_pages_hugetlb_pmd_range(vma, pmd, nodes,
-						flags, private);
-			continue;
-		}
-		split_huge_page_pmd(vma, addr, pmd);
-		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-			continue;
-		if (queue_pages_pte_range(vma, pmd, addr, next, nodes,
-				    flags, private))
-			return -EIO;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
-
-static inline int queue_pages_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pud_t *pud;
-	unsigned long next;
-
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_huge(*pud) && is_vm_hugetlb_page(vma))
-			continue;
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		if (queue_pages_pmd_range(vma, pud, addr, next, nodes,
-				    flags, private))
-			return -EIO;
-	} while (pud++, addr = next, addr != end);
-	return 0;
-}
-
-static inline int queue_pages_pgd_range(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags,
-		void *private)
-{
-	pgd_t *pgd;
-	unsigned long next;
-
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		if (queue_pages_pud_range(vma, pgd, addr, next, nodes,
-				    flags, private))
-			return -EIO;
-	} while (pgd++, addr = next, addr != end);
 	return 0;
 }
 
@@ -642,6 +568,45 @@ static unsigned long change_prot_numa(st
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+static int queue_pages_test_walk(unsigned long start, unsigned long end,
+				struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct queue_pages *qp = walk->private;
+	unsigned long endvma = vma->vm_end;
+	unsigned long flags = qp->flags;
+
+	if (endvma > end)
+		endvma = end;
+	if (vma->vm_start > start)
+		start = vma->vm_start;
+
+	if (!(flags & MPOL_MF_DISCONTIG_OK)) {
+		if (!vma->vm_next && vma->vm_end < end)
+			return -EFAULT;
+		if (qp->prev && qp->prev->vm_end < vma->vm_start)
+			return -EFAULT;
+	}
+
+	qp->prev = vma;
+	walk->skip = 1;
+
+	if (vma->vm_flags & VM_PFNMAP)
+		return 0;
+
+	if (flags & MPOL_MF_LAZY) {
+		change_prot_numa(vma, start, endvma);
+		return 0;
+	}
+
+	if ((flags & MPOL_MF_STRICT) ||
+	    ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
+	     vma_migratable(vma)))
+		/* queue pages from current vma */
+		walk->skip = 0;
+	return 0;
+}
+
 /*
  * Walk through page tables and collect pages to be migrated.
  *
@@ -651,51 +616,29 @@ static unsigned long change_prot_numa(st
  */
 static struct vm_area_struct *
 queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
-		const nodemask_t *nodes, unsigned long flags, void *private)
+		nodemask_t *nodes, unsigned long flags,
+		struct list_head *pagelist)
 {
 	int err;
-	struct vm_area_struct *first, *vma, *prev;
-
-
-	first = find_vma(mm, start);
-	if (!first)
-		return ERR_PTR(-EFAULT);
-	prev = NULL;
-	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
-		unsigned long endvma = vma->vm_end;
-
-		if (endvma > end)
-			endvma = end;
-		if (vma->vm_start > start)
-			start = vma->vm_start;
-
-		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
-			if (!vma->vm_next && vma->vm_end < end)
-				return ERR_PTR(-EFAULT);
-			if (prev && prev->vm_end < vma->vm_start)
-				return ERR_PTR(-EFAULT);
-		}
-
-		if (flags & MPOL_MF_LAZY) {
-			change_prot_numa(vma, start, endvma);
-			goto next;
-		}
-
-		if ((flags & MPOL_MF_STRICT) ||
-		     ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
-		      vma_migratable(vma))) {
-
-			err = queue_pages_pgd_range(vma, start, endvma, nodes,
-						flags, private);
-			if (err) {
-				first = ERR_PTR(err);
-				break;
-			}
-		}
-next:
-		prev = vma;
-	}
-	return first;
+	struct queue_pages qp = {
+		.pagelist = pagelist,
+		.flags = flags,
+		.nmask = nodes,
+		.prev = NULL,
+	};
+	struct mm_walk queue_pages_walk = {
+		.hugetlb_entry = queue_pages_hugetlb,
+		.pte_entry = queue_pages_pte,
+		.test_walk = queue_pages_test_walk,
+		.mm = mm,
+		.private = &qp,
+	};
+
+	err = walk_page_range(start, end, &queue_pages_walk);
+	if (err < 0)
+		return ERR_PTR(err);
+	else
+		return find_vma(mm, start);
 }
 
 /*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memory-failurec-move-refcount-only-in-mf_count_increased.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch

