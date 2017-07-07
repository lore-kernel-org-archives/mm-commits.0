From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-null-return-check-of-pte_offset_map_lock.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:10:20 -0700
Message-ID: <20170707191020.xzcJ-AjUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdGGTKk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz


The patch titled
     Subject: mm: drop NULL return check of pte_offset_map_lock()
has been removed from the -mm tree.  Its filename was
     mm-drop-null-return-check-of-pte_offset_map_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: drop NULL return check of pte_offset_map_lock()

pte_offset_map_lock() finds and takes ptl, and returns pte.  But some
callers return without unlocking the ptl when pte == NULL, which seems
weird.

Git history said that !pte check in change_pte_range() was introduced in
commit 1ad9f620c3a2 ("mm: numa: recheck for transhuge pages under lock
during protection changes") and still remains after commit 175ad4f1e7a2
("mm: mprotect: use pmd_trans_unstable instead of taking the pmd_lock")
which partially reverts 1ad9f620c3a2.  So I think that it's just dead
code.

Many other caller of pte_offset_map_lock() never check NULL return, so
let's do likewise.

Link: http://lkml.kernel.org/r/1495089737-1292-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    2 --
 mm/mprotect.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN mm/memory.c~mm-drop-null-return-check-of-pte_offset_map_lock mm/memory.c
--- a/mm/memory.c~mm-drop-null-return-check-of-pte_offset_map_lock
+++ a/mm/memory.c
@@ -4014,8 +4014,6 @@ static int __follow_pte_pmd(struct mm_st
 		goto out;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
-	if (!ptep)
-		goto out;
 	if (!pte_present(*ptep))
 		goto unlock;
 	*ptepp = ptep;
diff -puN mm/mprotect.c~mm-drop-null-return-check-of-pte_offset_map_lock mm/mprotect.c
--- a/mm/mprotect.c~mm-drop-null-return-check-of-pte_offset_map_lock
+++ a/mm/mprotect.c
@@ -58,8 +58,6 @@ static unsigned long change_pte_range(st
 	 * reading.
 	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (!pte)
-		return 0;
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch
mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages.patch
mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
mm-hwpoison-introduce-memory_failure_hugetlb.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
mm-hwpoison-introduce-idenfity_page_state.patch

