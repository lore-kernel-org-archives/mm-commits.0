Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324BDC4167B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbiK2VXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiK2VXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:23:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98531705C
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E727B8191E
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF70C433C1;
        Tue, 29 Nov 2022 21:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669756979;
        bh=h9QHGT/xJ+d3HykC/gWNSztdvq/6ZFeeWllN7aEKYGE=;
        h=Date:To:From:Subject:From;
        b=G05fljB4ny9T75eWFO/hMd+D0V8i6eIc6M1D7XFuS+nl2+GQ2Md2HxL56zDRioovN
         Jym74GRPGPayr8pqoxqdagPajJxtwCFdNrP4conFu+1lX1ZjORz38fcIw2ojN71XD1
         nIK1l4tB8IPH+UjoiB9mqKMj8v845JMLnbDOjR+A=
Date:   Tue, 29 Nov 2022 13:22:58 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jannh@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch added to mm-unstable branch
Message-Id: <20221129212259.2BF70C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: move swap entry handling into vma lock when faulted
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: move swap entry handling into vma lock when faulted
Date: Tue, 29 Nov 2022 14:35:20 -0500

In hugetlb_fault(), there used to have a special path to handle swap entry
at the entrance using huge_pte_offset().  That's unsafe because
huge_pte_offset() for a pmd sharable range can access freed pgtables if
without any lock to protect the pgtable from being freed after pmd
unshare.

Here the simplest solution to make it safe is to move the swap handling to
be after the vma lock being held.  We may need to take the fault mutex on
either migration or hwpoison entries now (also the vma lock, but that's
really needed), however neither of them is hot path.

Note that the vma lock cannot be released in hugetlb_fault() when the
migration entry is detected, because in migration_entry_wait_huge() the
pgtable page will be used again (by taking the pgtable lock), so that also
need to be protected by the vma lock.  Modify migration_entry_wait_huge()
so that it must be called with vma read lock held, and properly release
the lock in __migration_entry_wait_huge().

Link: https://lkml.kernel.org/r/20221129193526.3588187-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    6 ++++--
 mm/hugetlb.c            |   32 +++++++++++++++-----------------
 mm/migrate.c            |   25 +++++++++++++++++++++----
 3 files changed, 40 insertions(+), 23 deletions(-)

--- a/include/linux/swapops.h~mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted
+++ a/include/linux/swapops.h
@@ -335,7 +335,8 @@ extern void __migration_entry_wait(struc
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
 #ifdef CONFIG_HUGETLB_PAGE
-extern void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl);
+extern void __migration_entry_wait_huge(struct vm_area_struct *vma,
+					pte_t *ptep, spinlock_t *ptl);
 extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
 #endif	/* CONFIG_HUGETLB_PAGE */
 #else  /* CONFIG_MIGRATION */
@@ -364,7 +365,8 @@ static inline void __migration_entry_wai
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
 #ifdef CONFIG_HUGETLB_PAGE
-static inline void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl) { }
+static inline void __migration_entry_wait_huge(struct vm_area_struct *vma,
+					       pte_t *ptep, spinlock_t *ptl) { }
 static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
 #endif	/* CONFIG_HUGETLB_PAGE */
 static inline int is_writable_migration_entry(swp_entry_t entry)
--- a/mm/hugetlb.c~mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted
+++ a/mm/hugetlb.c
@@ -5826,22 +5826,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	int need_wait_lock = 0;
 	unsigned long haddr = address & huge_page_mask(h);
 
-	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
-	if (ptep) {
-		/*
-		 * Since we hold no locks, ptep could be stale.  That is
-		 * OK as we are only making decisions based on content and
-		 * not actually modifying content here.
-		 */
-		entry = huge_ptep_get(ptep);
-		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, ptep);
-			return 0;
-		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
-			return VM_FAULT_HWPOISON_LARGE |
-				VM_FAULT_SET_HINDEX(hstate_index(h));
-	}
-
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
@@ -5888,8 +5872,22 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * fault, and is_hugetlb_entry_(migration|hwpoisoned) check will
 	 * properly handle it.
 	 */
-	if (!pte_present(entry))
+	if (!pte_present(entry)) {
+		if (unlikely(is_hugetlb_entry_migration(entry))) {
+			/*
+			 * Release fault lock first because the vma lock is
+			 * needed to guard the huge_pte_lockptr() later in
+			 * migration_entry_wait_huge().  The vma lock will
+			 * be released there.
+			 */
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			migration_entry_wait_huge(vma, ptep);
+			return 0;
+		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
+			ret = VM_FAULT_HWPOISON_LARGE |
+			    VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
+	}
 
 	/*
 	 * If we are going to COW/unshare the mapping later, we examine the
--- a/mm/migrate.c~mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted
+++ a/mm/migrate.c
@@ -326,24 +326,41 @@ void migration_entry_wait(struct mm_stru
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl)
+void __migration_entry_wait_huge(struct vm_area_struct *vma,
+				 pte_t *ptep, spinlock_t *ptl)
 {
 	pte_t pte;
 
+	/*
+	 * The vma read lock must be taken, which will be released before
+	 * the function returns.  It makes sure the pgtable page (along
+	 * with its spin lock) not be freed in parallel.
+	 */
+	hugetlb_vma_assert_locked(vma);
+
 	spin_lock(ptl);
 	pte = huge_ptep_get(ptep);
 
-	if (unlikely(!is_hugetlb_entry_migration(pte)))
+	if (unlikely(!is_hugetlb_entry_migration(pte))) {
 		spin_unlock(ptl);
-	else
+		hugetlb_vma_unlock_read(vma);
+	} else {
+		/*
+		 * If migration entry existed, safe to release vma lock
+		 * here because the pgtable page won't be freed without the
+		 * pgtable lock released.  See comment right above pgtable
+		 * lock release in migration_entry_wait_on_locked().
+		 */
+		hugetlb_vma_unlock_read(vma);
 		migration_entry_wait_on_locked(pte_to_swp_entry(pte), NULL, ptl);
+	}
 }
 
 void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte)
 {
 	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, pte);
 
-	__migration_entry_wait_huge(pte, ptl);
+	__migration_entry_wait_huge(vma, pte, ptl);
 }
 #endif
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch
mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch
selftests-vm-use-memfd-for-hugepage-mmap-test.patch
mm-thp-re-apply-mkdirty-for-small-pages-after-split.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

