From: akpm@linux-foundation.org
Subject: + mm-mempolicy-rename-check_range-to-queue_pages_range.patch
 added to -mm tree
Date: Thu, 15 Aug 2013 14:52:03 -0700
Message-ID: <520d4d83.FWZ29hiIqfGCy6EB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3HOVwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 17:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-mempolicy-rename-check_range-to-queue_pages_range.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 14:52:03 -0700


The patch titled
     Subject: mm/mempolicy: rename check_*range to queue_pages_*range
has been added to the -mm tree.  Its filename is
     mm-mempolicy-rename-check_range-to-queue_pages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-rename-check_range-to-queue_pages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-rename-check_range-to-queue_pages_range.patch

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
Subject: mm/mempolicy: rename check_*range to queue_pages_*range

The function check_range() (and its family) is not well-named, because it
does not only checking something, but moving pages from list to list to do
page migration for them.  So queue_pages_*range is more desirable name.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-rename-check_range-to-queue_pages_range mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-rename-check_range-to-queue_pages_range
+++ a/mm/mempolicy.c
@@ -476,8 +476,11 @@ static const struct mempolicy_operations
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
-/* Scan through pages checking if pages follow certain conditions. */
-static int check_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+/*
+ * Scan through pages checking if pages follow certain conditions,
+ * and move them to the pagelist if they do.
+ */
+static int queue_pages_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags,
 		void *private)
@@ -515,8 +518,8 @@ static int check_pte_range(struct vm_are
 	return addr != end;
 }
 
-static void check_hugetlb_pmd_range(struct vm_area_struct *vma, pmd_t *pmd,
-		const nodemask_t *nodes, unsigned long flags,
+static void queue_pages_hugetlb_pmd_range(struct vm_area_struct *vma,
+		pmd_t *pmd, const nodemask_t *nodes, unsigned long flags,
 				    void *private)
 {
 #ifdef CONFIG_HUGETLB_PAGE
@@ -539,7 +542,7 @@ unlock:
 #endif
 }
 
-static inline int check_pmd_range(struct vm_area_struct *vma, pud_t *pud,
+static inline int queue_pages_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long addr, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags,
 		void *private)
@@ -551,21 +554,21 @@ static inline int check_pmd_range(struct
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
-			check_hugetlb_pmd_range(vma, pmd, nodes,
+			queue_pages_hugetlb_pmd_range(vma, pmd, nodes,
 						flags, private);
 			continue;
 		}
 		split_huge_page_pmd(vma, addr, pmd);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
-		if (check_pte_range(vma, pmd, addr, next, nodes,
+		if (queue_pages_pte_range(vma, pmd, addr, next, nodes,
 				    flags, private))
 			return -EIO;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int check_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
+static inline int queue_pages_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
 		unsigned long addr, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags,
 		void *private)
@@ -580,14 +583,14 @@ static inline int check_pud_range(struct
 			continue;
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		if (check_pmd_range(vma, pud, addr, next, nodes,
+		if (queue_pages_pmd_range(vma, pud, addr, next, nodes,
 				    flags, private))
 			return -EIO;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
-static inline int check_pgd_range(struct vm_area_struct *vma,
+static inline int queue_pages_pgd_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags,
 		void *private)
@@ -600,7 +603,7 @@ static inline int check_pgd_range(struct
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		if (check_pud_range(vma, pgd, addr, next, nodes,
+		if (queue_pages_pud_range(vma, pgd, addr, next, nodes,
 				    flags, private))
 			return -EIO;
 	} while (pgd++, addr = next, addr != end);
@@ -638,12 +641,14 @@ static unsigned long change_prot_numa(st
 #endif /* CONFIG_ARCH_USES_NUMA_PROT_NONE */
 
 /*
- * Check if all pages in a range are on a set of nodes.
- * If pagelist != NULL then isolate pages from the LRU and
- * put them on the pagelist.
+ * Walk through page tables and collect pages to be migrated.
+ *
+ * If pages found in a given range are on a set of nodes (determined by
+ * @nodes and @flags,) it's isolated and queued to the pagelist which is
+ * passed via @private.)
  */
 static struct vm_area_struct *
-check_range(struct mm_struct *mm, unsigned long start, unsigned long end,
+queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags, void *private)
 {
 	int err;
@@ -678,7 +683,7 @@ check_range(struct mm_struct *mm, unsign
 		     ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
 		      vma_migratable(vma))) {
 
-			err = check_pgd_range(vma, start, endvma, nodes,
+			err = queue_pages_pgd_range(vma, start, endvma, nodes,
 						flags, private);
 			if (err) {
 				first = ERR_PTR(err);
@@ -1048,7 +1053,7 @@ static int migrate_to_node(struct mm_str
 	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
 	 */
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
-	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	queue_pages_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
@@ -1286,7 +1291,7 @@ static long do_mbind(unsigned long start
 	if (err)
 		goto mpol_out;
 
-	vma = check_range(mm, start, end, nmask,
+	vma = queue_pages_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	err = PTR_ERR(vma);	/* maybe ... */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch

