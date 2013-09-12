From: akpm@linux-foundation.org
Subject: [merged]
 migrate-add-hugepage-migration-code-to-migrate_pages.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:15 -0700
Message-ID: <5232198f.gY2n3q60GIs7Utr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] migrate-add-hugepage-migration-code-to-migrate_pages.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:15 -0700


The patch titled
     Subject: migrate: add hugepage migration code to migrate_pages()
has been removed from the -mm tree.  Its filename was
     migrate-add-hugepage-migration-code-to-migrate_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: migrate: add hugepage migration code to migrate_pages()

Extend check_range() to handle vma with VM_HUGETLB set.  We will be able
to migrate hugepage with migrate_pages(2) after applying the enablement
patch which comes later in this series.

Note that for larger hugepages (covered by pud entries, 1GB for x86_64 for
example), we simply skip it now.

Note that using pmd_huge/pud_huge assumes that hugepages are pointed to by
pmd/pud.  This is not true in some architectures implementing hugepage
with other mechanisms like ia64, but it's OK because pmd_huge/pud_huge
simply return 0 in such arch and page walker simply ignores such
hugepages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~migrate-add-hugepage-migration-code-to-migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~migrate-add-hugepage-migration-code-to-migrate_pages
+++ a/mm/mempolicy.c
@@ -515,6 +515,30 @@ static int check_pte_range(struct vm_are
 	return addr != end;
 }
 
+static void check_hugetlb_pmd_range(struct vm_area_struct *vma, pmd_t *pmd,
+		const nodemask_t *nodes, unsigned long flags,
+				    void *private)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	int nid;
+	struct page *page;
+
+	spin_lock(&vma->vm_mm->page_table_lock);
+	page = pte_page(huge_ptep_get((pte_t *)pmd));
+	nid = page_to_nid(page);
+	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
+		goto unlock;
+	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
+	if (flags & (MPOL_MF_MOVE_ALL) ||
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
+		isolate_huge_page(page, private);
+unlock:
+	spin_unlock(&vma->vm_mm->page_table_lock);
+#else
+	BUG();
+#endif
+}
+
 static inline int check_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long addr, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags,
@@ -526,6 +550,13 @@ static inline int check_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (!pmd_present(*pmd))
+			continue;
+		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
+			check_hugetlb_pmd_range(vma, pmd, nodes,
+						flags, private);
+			continue;
+		}
 		split_huge_page_pmd(vma, addr, pmd);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
@@ -547,6 +578,8 @@ static inline int check_pud_range(struct
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
+		if (pud_huge(*pud) && is_vm_hugetlb_page(vma))
+			continue;
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		if (check_pmd_range(vma, pud, addr, next, nodes,
@@ -638,9 +671,6 @@ check_range(struct mm_struct *mm, unsign
 				return ERR_PTR(-EFAULT);
 		}
 
-		if (is_vm_hugetlb_page(vma))
-			goto next;
-
 		if (flags & MPOL_MF_LAZY) {
 			change_prot_numa(vma, start, endvma);
 			goto next;
@@ -993,7 +1023,11 @@ static void migrate_page_add(struct page
 
 static struct page *new_node_page(struct page *page, unsigned long node, int **x)
 {
-	return alloc_pages_exact_node(node, GFP_HIGHUSER_MOVABLE, 0);
+	if (PageHuge(page))
+		return alloc_huge_page_node(page_hstate(compound_head(page)),
+					node);
+	else
+		return alloc_pages_exact_node(node, GFP_HIGHUSER_MOVABLE, 0);
 }
 
 /*
@@ -1023,7 +1057,7 @@ static int migrate_to_node(struct mm_str
 		err = migrate_pages(&pagelist, new_node_page, dest,
 					MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
-			putback_lru_pages(&pagelist);
+			putback_movable_pages(&pagelist);
 	}
 
 	return err;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

