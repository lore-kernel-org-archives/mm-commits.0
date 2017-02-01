From: akpm@linux-foundation.org
Subject: +
 mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch added to
 -mm tree
Date: Tue, 31 Jan 2017 16:10:08 -0800
Message-ID: <58912760.OCs09uS2wqSH8Pav%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbdBAAKK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix handling PTE-mapped THPs in page_idle_clear_pte_refs()
has been added to the -mm tree.  Its filename is
     mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix handling PTE-mapped THPs in page_idle_clear_pte_refs()

For PTE-mapped THP page_check_address_transhuge() is not adequate: it
cannot find all relevant PTEs, only the first one.i

Let's switch it to page_vma_mapped_walk().

I don't think it's subject for stable@: it's not fatal.

Link: http://lkml.kernel.org/r/20170129173858.45174-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN mm/page_idle.c~mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs mm/page_idle.c
--- a/mm/page_idle.c~mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs
+++ a/mm/page_idle.c
@@ -54,27 +54,27 @@ static int page_idle_clear_pte_refs_one(
 					struct vm_area_struct *vma,
 					unsigned long addr, void *arg)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	pmd_t *pmd;
-	pte_t *pte;
-	spinlock_t *ptl;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = addr,
+	};
 	bool referenced = false;
 
-	if (!page_check_address_transhuge(page, mm, addr, &pmd, &pte, &ptl))
-		return SWAP_AGAIN;
-
-	if (pte) {
-		referenced = ptep_clear_young_notify(vma, addr, pte);
-		pte_unmap(pte);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		referenced = pmdp_clear_young_notify(vma, addr, pmd);
-	} else {
-		/* unexpected pmd-mapped page? */
-		WARN_ON_ONCE(1);
+	while (page_vma_mapped_walk(&pvmw)) {
+		addr = pvmw.address;
+		if (pvmw.pte) {
+			referenced = ptep_clear_young_notify(vma, addr,
+					pvmw.pte);
+		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+			referenced = pmdp_clear_young_notify(vma, addr,
+					pvmw.pmd);
+		} else {
+			/* unexpected pmd-mapped page? */
+			WARN_ON_ONCE(1);
+		}
 	}
 
-	spin_unlock(ptl);
-
 	if (referenced) {
 		clear_page_idle(page);
 		/*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-sleeping-function-called-from-invalid-context-shmem_undo_range.patch
mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch
uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

