From: akpm@linux-foundation.org
Subject: + migrate-add-hugepage-migration-code-to-migrate_pages.patch
 added to -mm tree
Date: Wed, 14 Aug 2013 16:41:45 -0700
Message-ID: <520c15b9.DCKNH+05d+77hqQg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3HNXlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + migrate-add-hugepage-migration-code-to-migrate_pages.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:41:45 -0700


The patch titled
     Subject: migrate: add hugepage migration code to migrate_pages()
has been added to the -mm tree.  Its filename is
     migrate-add-hugepage-migration-code-to-migrate_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/migrate-add-hugepage-migration-code-to-migrate_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/migrate-add-hugepage-migration-code-to-migrate_pages.patch

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

 mm/mempolicy.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

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
@@ -526,6 +550,11 @@ static inline int check_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
+			check_hugetlb_pmd_range(vma, pmd, nodes,
+						flags, private);
+			continue;
+		}
 		split_huge_page_pmd(vma, addr, pmd);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
@@ -547,6 +576,8 @@ static inline int check_pud_range(struct
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
+		if (pud_huge(*pud) && is_vm_hugetlb_page(vma))
+			continue;
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		if (check_pmd_range(vma, pud, addr, next, nodes,
@@ -638,9 +669,6 @@ check_range(struct mm_struct *mm, unsign
 				return ERR_PTR(-EFAULT);
 		}
 
-		if (is_vm_hugetlb_page(vma))
-			goto next;
-
 		if (flags & MPOL_MF_LAZY) {
 			change_prot_numa(vma, start, endvma);
 			goto next;
@@ -993,7 +1021,11 @@ static void migrate_page_add(struct page
 
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
@@ -1023,7 +1055,7 @@ static int migrate_to_node(struct mm_str
 		err = migrate_pages(&pagelist, new_node_page, dest,
 					MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
-			putback_lru_pages(&pagelist);
+			putback_movable_pages(&pagelist);
 	}
 
 	return err;
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

