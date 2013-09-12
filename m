From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-rename-check_range-to-queue_pages_range.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:29 -0700
Message-ID: <5232199d.0ebpqH0+tyS6XEso%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-mempolicy-rename-check_range-to-queue_pages_range.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:29 -0700


The patch titled
     Subject: mm/mempolicy: rename check_*range to queue_pages_*range
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-rename-check_range-to-queue_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -553,21 +556,21 @@ static inline int check_pmd_range(struct
 		if (!pmd_present(*pmd))
 			continue;
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
@@ -582,14 +585,14 @@ static inline int check_pud_range(struct
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
@@ -602,7 +605,7 @@ static inline int check_pgd_range(struct
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		if (check_pud_range(vma, pgd, addr, next, nodes,
+		if (queue_pages_pud_range(vma, pgd, addr, next, nodes,
 				    flags, private))
 			return -EIO;
 	} while (pgd++, addr = next, addr != end);
@@ -640,12 +643,14 @@ static unsigned long change_prot_numa(st
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
@@ -680,7 +685,7 @@ check_range(struct mm_struct *mm, unsign
 		     ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
 		      vma_migratable(vma))) {
 
-			err = check_pgd_range(vma, start, endvma, nodes,
+			err = queue_pages_pgd_range(vma, start, endvma, nodes,
 						flags, private);
 			if (err) {
 				first = ERR_PTR(err);
@@ -1050,7 +1055,7 @@ static int migrate_to_node(struct mm_str
 	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
 	 */
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
-	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	queue_pages_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
@@ -1288,7 +1293,7 @@ static long do_mbind(unsigned long start
 	if (err)
 		goto mpol_out;
 
-	vma = check_range(mm, start, end, nmask,
+	vma = queue_pages_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
 	err = PTR_ERR(vma);	/* maybe ... */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

