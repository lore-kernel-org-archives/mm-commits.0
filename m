From: akpm@linux-foundation.org
Subject: +
 mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch added to
 -mm tree
Date: Thu, 07 Nov 2013 14:00:18 -0800
Message-ID: <527c0d72.ajVcyvsRfDldBiQt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3KGWAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, kirill.shutemov@linux.intel.com, peterz@infradead.org

Subject: + mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch added to -mm tree
To: peterz@infradead.org,kirill.shutemov@linux.intel.com,mingo@elte.hu
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:00:18 -0800


The patch titled
     Subject: mm: properly separate the bloated ptl from the regular case
has been added to the -mm tree.  Its filename is
     mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: mm: properly separate the bloated ptl from the regular case

Use kernel/bounds.c to convert build-time spinlock_t size check into a
preprocessor symbol and apply that to properly separate the page::ptl
situation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   24 +++++++++++++-----------
 include/linux/mm_types.h |    9 +++++----
 kernel/bounds.c          |    2 ++
 mm/memory.c              |   11 +++++------
 4 files changed, 25 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~mm-properly-separate-the-bloated-ptl-from-the-regular-case include/linux/mm.h
--- a/include/linux/mm.h~mm-properly-separate-the-bloated-ptl-from-the-regular-case
+++ a/include/linux/mm.h
@@ -1317,27 +1317,29 @@ static inline pmd_t *pmd_alloc(struct mm
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
 #if USE_SPLIT_PTE_PTLOCKS
-bool __ptlock_alloc(struct page *page);
-void __ptlock_free(struct page *page);
+#if BLOATED_SPINLOCKS
+extern bool ptlock_alloc(struct page *page);
+extern void ptlock_free(struct page *page);
+
+static inline spinlock_t *ptlock_ptr(struct page *page)
+{
+	return page->ptl;
+}
+#else /* BLOATED_SPINLOCKS */
 static inline bool ptlock_alloc(struct page *page)
 {
-	if (sizeof(spinlock_t) > sizeof(page->ptl))
-		return __ptlock_alloc(page);
 	return true;
 }
+
 static inline void ptlock_free(struct page *page)
 {
-	if (sizeof(spinlock_t) > sizeof(page->ptl))
-		__ptlock_free(page);
 }
 
 static inline spinlock_t *ptlock_ptr(struct page *page)
 {
-	if (sizeof(spinlock_t) > sizeof(page->ptl))
-		return (spinlock_t *) page->ptl;
-	else
-		return (spinlock_t *) &page->ptl;
+	return &page->ptl;
 }
+#endif /* BLOATED_SPINLOCKS */
 
 static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
@@ -1354,7 +1356,7 @@ static inline bool ptlock_init(struct pa
 	 * slab code uses page->slab_cache and page->first_page (for tail
 	 * pages), which share storage with page->ptl.
 	 */
-	VM_BUG_ON(page->ptl);
+	VM_BUG_ON(*(unsigned long *)&page->ptl);
 	if (!ptlock_alloc(page))
 		return false;
 	spin_lock_init(ptlock_ptr(page));
diff -puN include/linux/mm_types.h~mm-properly-separate-the-bloated-ptl-from-the-regular-case include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-properly-separate-the-bloated-ptl-from-the-regular-case
+++ a/include/linux/mm_types.h
@@ -155,10 +155,11 @@ struct page {
 						 * system if PG_buddy is set.
 						 */
 #if USE_SPLIT_PTE_PTLOCKS
-		unsigned long ptl; /* It's spinlock_t if it fits to long,
-				    * otherwise it's pointer to dynamicaly
-				    * allocated spinlock_t.
-				    */
+#if BLOATED_SPINLOCKS
+		spinlock_t *ptl;
+#else
+		spinlock_t ptl;
+#endif
 #endif
 		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
 		struct page *first_page;	/* Compound tail pages */
diff -puN kernel/bounds.c~mm-properly-separate-the-bloated-ptl-from-the-regular-case kernel/bounds.c
--- a/kernel/bounds.c~mm-properly-separate-the-bloated-ptl-from-the-regular-case
+++ a/kernel/bounds.c
@@ -11,6 +11,7 @@
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
 #include <linux/log2.h>
+#include <linux/spinlock.h>
 
 void foo(void)
 {
@@ -21,5 +22,6 @@ void foo(void)
 #ifdef CONFIG_SMP
 	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
 #endif
+	DEFINE(BLOATED_SPINLOCKS, sizeof(spinlock_t) > sizeof(int));
 	/* End of constants */
 }
diff -puN mm/memory.c~mm-properly-separate-the-bloated-ptl-from-the-regular-case mm/memory.c
--- a/mm/memory.c~mm-properly-separate-the-bloated-ptl-from-the-regular-case
+++ a/mm/memory.c
@@ -4271,21 +4271,20 @@ void copy_user_huge_page(struct page *ds
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
-#if USE_SPLIT_PTE_PTLOCKS
-bool __ptlock_alloc(struct page *page)
+#if USE_SPLIT_PTE_PTLOCKS && BLOATED_SPINLOCKS
+bool ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
 
 	ptl = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
 	if (!ptl)
 		return false;
-	page->ptl = (unsigned long)ptl;
+	page->ptl = ptl;
 	return true;
 }
 
-void __ptlock_free(struct page *page)
+void ptlock_free(struct page *page)
 {
-	if (sizeof(spinlock_t) > sizeof(page->ptl))
-		kfree((spinlock_t *)page->ptl);
+	kfree(page->ptl);
 }
 #endif
_

Patches currently in -mm which might be from peterz@infradead.org are

checkpatch-make-the-memory-barrier-test-noisier.patch
linux-next.patch
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
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch

