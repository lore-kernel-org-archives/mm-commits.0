Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404C7C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjASBOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjASBOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14814683FB
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927C861B11
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC13C433D2;
        Thu, 19 Jan 2023 01:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090831;
        bh=tjKG5sNAIc5aqJH0BxF9IFqg0YcqDdiTjp1GGVzuvQ0=;
        h=Date:To:From:Subject:From;
        b=ZFhttvkclfjHrV+IT+29bkQ4alckXz5OcqKZ+TvSb216ckSQ5JBRAHQwM41MItbF2
         9Lt6kb8tAg2oBHOjkiEO05mbWmUQiITEqMJM0UPATxpc6O3bYJcU89yG1qj2ZD4zS+
         N6B85bUhJhbMCNGMia94UwlAAYUwtsj5HvqUcco4=
Date:   Wed, 18 Jan 2023 17:13:50 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch removed from -mm tree
Message-Id: <20230119011350.ECC13C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: move swap entry handling into vma lock when faulted
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: move swap entry handling into vma lock when faulted
Date: Fri, 16 Dec 2022 10:50:55 -0500

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

Link: https://lkml.kernel.org/r/20221216155100.2043537-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    6 ++++--
 mm/hugetlb.c            |   37 ++++++++++++++++---------------------
 mm/migrate.c            |   25 +++++++++++++++++++++----
 3 files changed, 41 insertions(+), 27 deletions(-)

--- a/include/linux/swapops.h~mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted
+++ a/include/linux/swapops.h
@@ -337,7 +337,8 @@ extern void __migration_entry_wait(struc
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
 #ifdef CONFIG_HUGETLB_PAGE
-extern void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl);
+extern void __migration_entry_wait_huge(struct vm_area_struct *vma,
+					pte_t *ptep, spinlock_t *ptl);
 extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
 #endif	/* CONFIG_HUGETLB_PAGE */
 #else  /* CONFIG_MIGRATION */
@@ -366,7 +367,8 @@ static inline void __migration_entry_wai
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
@@ -5993,22 +5993,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6023,10 +6007,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * Acquire vma lock before calling huge_pte_alloc and hold
 	 * until finished with ptep.  This prevents huge_pmd_unshare from
 	 * being called elsewhere and making the ptep no longer valid.
-	 *
-	 * ptep could have already be assigned via huge_pte_offset.  That
-	 * is OK, as huge_pte_alloc will return the same value unless
-	 * something has changed.
 	 */
 	hugetlb_vma_lock_read(vma);
 	ptep = huge_pte_alloc(mm, vma, haddr, huge_page_size(h));
@@ -6055,8 +6035,23 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * fault, and is_hugetlb_entry_(migration|hwpoisoned) check will
 	 * properly handle it.
 	 */
-	if (!pte_present(entry))
+	if (!pte_present(entry)) {
+		if (unlikely(is_hugetlb_entry_migration(entry))) {
+			/*
+			 * Release the hugetlb fault lock now, but retain
+			 * the vma lock, because it is needed to guard the
+			 * huge_pte_lockptr() later in
+			 * migration_entry_wait_huge(). The vma lock will
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
@@ -329,24 +329,41 @@ void migration_entry_wait(struct mm_stru
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl)
+/*
+ * The vma read lock must be held upon entry. Holding that lock prevents either
+ * the pte or the ptl from being freed.
+ *
+ * This function will release the vma lock before returning.
+ */
+void __migration_entry_wait_huge(struct vm_area_struct *vma,
+				 pte_t *ptep, spinlock_t *ptl)
 {
 	pte_t pte;
 
+	hugetlb_vma_assert_locked(vma);
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

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

