From: akpm@linux-foundation.org
Subject: + mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
 added to -mm tree
Date: Mon, 07 Oct 2013 16:10:13 -0700
Message-ID: <52533f55.DuUnOjPLDaU84Prh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3JGXKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:10:13 -0700


The patch titled
     Subject: mm, thp: move ptl taking inside page_check_address_pmd()
has been added to the -mm tree.  Its filename is
     mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch

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
Subject: mm, thp: move ptl taking inside page_check_address_pmd()

With split page table lock we can't know which lock we need to take before
we find the relevant pmd.

Let's move lock taking inside the function.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +-
 mm/huge_memory.c        |   43 +++++++++++++++++++++++---------------
 mm/rmap.c               |   13 ++++-------
 3 files changed, 34 insertions(+), 25 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-move-ptl-taking-inside-page_check_address_pmd include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-move-ptl-taking-inside-page_check_address_pmd
+++ a/include/linux/huge_mm.h
@@ -54,7 +54,8 @@ enum page_check_address_pmd_flag {
 extern pmd_t *page_check_address_pmd(struct page *page,
 				     struct mm_struct *mm,
 				     unsigned long address,
-				     enum page_check_address_pmd_flag flag);
+				     enum page_check_address_pmd_flag flag,
+				     spinlock_t **ptl);
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
diff -puN mm/huge_memory.c~mm-thp-move-ptl-taking-inside-page_check_address_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-move-ptl-taking-inside-page_check_address_pmd
+++ a/mm/huge_memory.c
@@ -1493,23 +1493,33 @@ int __pmd_trans_huge_lock(pmd_t *pmd, st
 	return 0;
 }
 
+/*
+ * This function returns whether a given @page is mapped onto the @address
+ * in the virtual space of @mm.
+ *
+ * When it's true, this function returns *pmd with holding the page table lock
+ * and passing it back to the caller via @ptl.
+ * If it's false, returns NULL without holding the page table lock.
+ */
 pmd_t *page_check_address_pmd(struct page *page,
 			      struct mm_struct *mm,
 			      unsigned long address,
-			      enum page_check_address_pmd_flag flag)
+			      enum page_check_address_pmd_flag flag,
+			      spinlock_t **ptl)
 {
-	pmd_t *pmd, *ret = NULL;
+	pmd_t *pmd;
 
 	if (address & ~HPAGE_PMD_MASK)
-		goto out;
+		return NULL;
 
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
-		goto out;
+		return NULL;
+	*ptl = pmd_lock(mm, pmd);
 	if (pmd_none(*pmd))
-		goto out;
+		goto unlock;
 	if (pmd_page(*pmd) != page)
-		goto out;
+		goto unlock;
 	/*
 	 * split_vma() may create temporary aliased mappings. There is
 	 * no risk as long as all huge pmd are found and have their
@@ -1519,14 +1529,15 @@ pmd_t *page_check_address_pmd(struct pag
 	 */
 	if (flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
 	    pmd_trans_splitting(*pmd))
-		goto out;
+		goto unlock;
 	if (pmd_trans_huge(*pmd)) {
 		VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG &&
 			  !pmd_trans_splitting(*pmd));
-		ret = pmd;
+		return pmd;
 	}
-out:
-	return ret;
+unlock:
+	spin_unlock(*ptl);
+	return NULL;
 }
 
 static int __split_huge_page_splitting(struct page *page,
@@ -1534,6 +1545,7 @@ static int __split_huge_page_splitting(s
 				       unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	pmd_t *pmd;
 	int ret = 0;
 	/* For mmu_notifiers */
@@ -1541,9 +1553,8 @@ static int __split_huge_page_splitting(s
 	const unsigned long mmun_end   = address + HPAGE_PMD_SIZE;
 
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
-				     PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG);
+			PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG, &ptl);
 	if (pmd) {
 		/*
 		 * We can't temporarily set the pmd to null in order
@@ -1554,8 +1565,8 @@ static int __split_huge_page_splitting(s
 		 */
 		pmdp_splitting_flush(vma, address, pmd);
 		ret = 1;
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	return ret;
@@ -1686,14 +1697,14 @@ static int __split_huge_page_map(struct
 				 unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	pmd_t *pmd, _pmd;
 	int ret = 0, i;
 	pgtable_t pgtable;
 	unsigned long haddr;
 
-	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
-				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
+			PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG, &ptl);
 	if (pmd) {
 		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 		pmd_populate(mm, &_pmd, pgtable);
@@ -1748,8 +1759,8 @@ static int __split_huge_page_map(struct
 		pmdp_invalidate(vma, address, pmd);
 		pmd_populate(mm, pmd, pgtable);
 		ret = 1;
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 
 	return ret;
 }
diff -puN mm/rmap.c~mm-thp-move-ptl-taking-inside-page_check_address_pmd mm/rmap.c
--- a/mm/rmap.c~mm-thp-move-ptl-taking-inside-page_check_address_pmd
+++ a/mm/rmap.c
@@ -665,25 +665,23 @@ int page_referenced_one(struct page *pag
 			unsigned long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	int referenced = 0;
 
 	if (unlikely(PageTransHuge(page))) {
 		pmd_t *pmd;
 
-		spin_lock(&mm->page_table_lock);
 		/*
 		 * rmap might return false positives; we must filter
 		 * these out using page_check_address_pmd().
 		 */
 		pmd = page_check_address_pmd(page, mm, address,
-					     PAGE_CHECK_ADDRESS_PMD_FLAG);
-		if (!pmd) {
-			spin_unlock(&mm->page_table_lock);
+					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
+		if (!pmd)
 			goto out;
-		}
 
 		if (vma->vm_flags & VM_LOCKED) {
-			spin_unlock(&mm->page_table_lock);
+			spin_unlock(ptl);
 			*mapcount = 0;	/* break early from loop */
 			*vm_flags |= VM_LOCKED;
 			goto out;
@@ -692,10 +690,9 @@ int page_referenced_one(struct page *pag
 		/* go ahead even if the pmd is pmd_trans_splitting() */
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 	} else {
 		pte_t *pte;
-		spinlock_t *ptl;
 
 		/*
 		 * rmap might return false positives; we must filter
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

