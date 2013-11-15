From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:27 -0800
Message-ID: <52867eff.mR+x6RUofkfbi6Qc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3KOUH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:27 -0800


The patch titled
     Subject: mm, thp: move ptl taking inside page_check_address_pmd()
has been removed from the -mm tree.  Its filename was
     mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1552,23 +1552,33 @@ int __pmd_trans_huge_lock(pmd_t *pmd, st
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
@@ -1578,14 +1588,15 @@ pmd_t *page_check_address_pmd(struct pag
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
@@ -1593,6 +1604,7 @@ static int __split_huge_page_splitting(s
 				       unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	pmd_t *pmd;
 	int ret = 0;
 	/* For mmu_notifiers */
@@ -1600,9 +1612,8 @@ static int __split_huge_page_splitting(s
 	const unsigned long mmun_end   = address + HPAGE_PMD_SIZE;
 
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
-				     PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG);
+			PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG, &ptl);
 	if (pmd) {
 		/*
 		 * We can't temporarily set the pmd to null in order
@@ -1613,8 +1624,8 @@ static int __split_huge_page_splitting(s
 		 */
 		pmdp_splitting_flush(vma, address, pmd);
 		ret = 1;
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	return ret;
@@ -1745,14 +1756,14 @@ static int __split_huge_page_map(struct
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
@@ -1807,8 +1818,8 @@ static int __split_huge_page_map(struct
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

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

