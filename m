From: akpm@linux-foundation.org
Subject: [merged] mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:29 -0800
Message-ID: <52867f01.vluJqDwBHG8iE+tP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3KOUHb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:29 -0800


The patch titled
     Subject: mm, thp: do not access mm->pmd_huge_pte directly
has been removed from the -mm tree.  Its filename was
     mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: do not access mm->pmd_huge_pte directly

Currently mm->pmd_huge_pte protected by page table lock.  It will not work
with split lock.  We have to have per-pmd pmd_huge_pte for proper access
serialization.

For now, let's just introduce wrapper to access mm->pmd_huge_pte.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

 arch/s390/mm/pgtable.c |   12 ++++++------
 arch/sparc/mm/tlb.c    |   12 ++++++------
 include/linux/mm.h     |    1 +
 mm/pgtable-generic.c   |   12 ++++++------
 4 files changed, 19 insertions(+), 18 deletions(-)

diff -puN arch/s390/mm/pgtable.c~mm-thp-do-not-access-mm-pmd_huge_pte-directly arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~mm-thp-do-not-access-mm-pmd_huge_pte-directly
+++ a/arch/s390/mm/pgtable.c
@@ -1244,11 +1244,11 @@ void pgtable_trans_huge_deposit(struct m
 	assert_spin_locked(&mm->page_table_lock);
 
 	/* FIFO */
-	if (!mm->pmd_huge_pte)
+	if (!pmd_huge_pte(mm, pmdp))
 		INIT_LIST_HEAD(lh);
 	else
-		list_add(lh, (struct list_head *) mm->pmd_huge_pte);
-	mm->pmd_huge_pte = pgtable;
+		list_add(lh, (struct list_head *) pmd_huge_pte(mm, pmdp));
+	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
@@ -1260,12 +1260,12 @@ pgtable_t pgtable_trans_huge_withdraw(st
 	assert_spin_locked(&mm->page_table_lock);
 
 	/* FIFO */
-	pgtable = mm->pmd_huge_pte;
+	pgtable = pmd_huge_pte(mm, pmdp);
 	lh = (struct list_head *) pgtable;
 	if (list_empty(lh))
-		mm->pmd_huge_pte = NULL;
+		pmd_huge_pte(mm, pmdp) = NULL;
 	else {
-		mm->pmd_huge_pte = (pgtable_t) lh->next;
+		pmd_huge_pte(mm, pmdp) = (pgtable_t) lh->next;
 		list_del(lh);
 	}
 	ptep = (pte_t *) pgtable;
diff -puN arch/sparc/mm/tlb.c~mm-thp-do-not-access-mm-pmd_huge_pte-directly arch/sparc/mm/tlb.c
--- a/arch/sparc/mm/tlb.c~mm-thp-do-not-access-mm-pmd_huge_pte-directly
+++ a/arch/sparc/mm/tlb.c
@@ -196,11 +196,11 @@ void pgtable_trans_huge_deposit(struct m
 	assert_spin_locked(&mm->page_table_lock);
 
 	/* FIFO */
-	if (!mm->pmd_huge_pte)
+	if (!pmd_huge_pte(mm, pmdp))
 		INIT_LIST_HEAD(lh);
 	else
-		list_add(lh, (struct list_head *) mm->pmd_huge_pte);
-	mm->pmd_huge_pte = pgtable;
+		list_add(lh, (struct list_head *) pmd_huge_pte(mm, pmdp));
+	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
@@ -211,12 +211,12 @@ pgtable_t pgtable_trans_huge_withdraw(st
 	assert_spin_locked(&mm->page_table_lock);
 
 	/* FIFO */
-	pgtable = mm->pmd_huge_pte;
+	pgtable = pmd_huge_pte(mm, pmdp);
 	lh = (struct list_head *) pgtable;
 	if (list_empty(lh))
-		mm->pmd_huge_pte = NULL;
+		pmd_huge_pte(mm, pmdp) = NULL;
 	else {
-		mm->pmd_huge_pte = (pgtable_t) lh->next;
+		pmd_huge_pte(mm, pmdp) = (pgtable_t) lh->next;
 		list_del(lh);
 	}
 	pte_val(pgtable[0]) = 0;
diff -puN include/linux/mm.h~mm-thp-do-not-access-mm-pmd_huge_pte-directly include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-do-not-access-mm-pmd_huge_pte-directly
+++ a/include/linux/mm.h
@@ -1383,6 +1383,7 @@ static inline spinlock_t *pmd_lockptr(st
 	return &mm->page_table_lock;
 }
 
+#define pmd_huge_pte(mm, pmd) ((mm)->pmd_huge_pte)
 
 static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
 {
diff -puN mm/pgtable-generic.c~mm-thp-do-not-access-mm-pmd_huge_pte-directly mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-do-not-access-mm-pmd_huge_pte-directly
+++ a/mm/pgtable-generic.c
@@ -154,11 +154,11 @@ void pgtable_trans_huge_deposit(struct m
 	assert_spin_locked(&mm->page_table_lock);
 
 	/* FIFO */
-	if (!mm->pmd_huge_pte)
+	if (!pmd_huge_pte(mm, pmdp))
 		INIT_LIST_HEAD(&pgtable->lru);
 	else
-		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
-	mm->pmd_huge_pte = pgtable;
+		list_add(&pgtable->lru, &pmd_huge_pte(mm, pmdp)->lru);
+	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
@@ -173,11 +173,11 @@ pgtable_t pgtable_trans_huge_withdraw(st
 	assert_spin_locked(&mm->page_table_lock);
 
 	/* FIFO */
-	pgtable = mm->pmd_huge_pte;
+	pgtable = pmd_huge_pte(mm, pmdp);
 	if (list_empty(&pgtable->lru))
-		mm->pmd_huge_pte = NULL;
+		pmd_huge_pte(mm, pmdp) = NULL;
 	else {
-		mm->pmd_huge_pte = list_entry(pgtable->lru.next,
+		pmd_huge_pte(mm, pmdp) = list_entry(pgtable->lru.next,
 					      struct page, lru);
 		list_del(&pgtable->lru);
 	}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

