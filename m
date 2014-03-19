From: akpm@linux-foundation.org
Subject: +
 mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch added to -mm tree
Date: Wed, 19 Mar 2014 13:25:22 -0700
Message-ID: <5329fd32.ha338PddVOim2g2K%akpm__26186.2124003985$1395260748$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaCSUZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 16:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 13:25:22 -0700


The patch titled
     Subject: mm: add !pte_present() check on existing hugetlb_entry callbacks
has been added to the -mm tree.  Its filename is
     mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch

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
Subject: mm: add !pte_present() check on existing hugetlb_entry callbacks

Page table walker doesn't check non-present hugetlb entry in common path,
so hugetlb_entry() callbacks must check it.  The reason for this behavior
is that some callers want to handle it in its own way.

However, some callers don't check it now, which causes unpredictable
result, for example when we have a race between migrating hugepage and
reading /proc/pid/numa_maps.  This patch fixes it by adding !pte_present
checks on buggy callbacks.

This bug exists for years and got visible by introducing hugepage migration.

ChangeLog v2:
- fix if condition (check !pte_present() instead of pte_present())

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +++
 mm/mempolicy.c     |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks
+++ a/fs/proc/task_mmu.c
@@ -1299,6 +1299,9 @@ static int gather_hugetlb_stats(pte_t *p
 	if (pte_none(*pte))
 		return 0;
 
+	if (!pte_present(*pte))
+		return 0;
+
 	page = pte_page(*pte);
 	if (!page)
 		return 0;
diff -puN mm/mempolicy.c~mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks mm/mempolicy.c
--- a/mm/mempolicy.c~mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks
+++ a/mm/mempolicy.c
@@ -524,8 +524,12 @@ static int queue_pages_hugetlb(pte_t *pt
 	unsigned long flags = qp->flags;
 	int nid;
 	struct page *page;
+	pte_t entry;
 
-	page = pte_page(huge_ptep_get(pte));
+	entry = huge_ptep_get(pte);
+	if (!pte_present(entry))
+		return 0;
+	page = pte_page(entry);
 	nid = page_to_nid(page);
 	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
 		return 0;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-call-vma_adjust_trans_huge-only-for-thp-enabled-vma.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

