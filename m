From: akpm@linux-foundation.org
Subject: + mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
 added to -mm tree
Date: Mon, 07 Oct 2013 16:10:02 -0700
Message-ID: <52533f4a.qe6/uEIMKGd4Fa3I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3JGXKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:10:02 -0700


The patch titled
     Subject: mm: rename USE_SPLIT_PTLOCKS to USE_SPLIT_PTE_PTLOCKS
has been added to the -mm tree.  Its filename is
     mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch

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
Subject: mm: rename USE_SPLIT_PTLOCKS to USE_SPLIT_PTE_PTLOCKS

We're going to introduce split page table lock for PMD level.  Let's
rename existing split ptlock for PTE level to avoid confusion.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
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

 arch/arm/mm/fault-armv.c |    6 +++---
 arch/x86/xen/mmu.c       |    6 +++---
 include/linux/mm.h       |    6 +++---
 include/linux/mm_types.h |    8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/arm/mm/fault-armv.c~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks arch/arm/mm/fault-armv.c
--- a/arch/arm/mm/fault-armv.c~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks
+++ a/arch/arm/mm/fault-armv.c
@@ -65,7 +65,7 @@ static int do_adjust_pte(struct vm_area_
 	return ret;
 }
 
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTE_PTLOCKS
 /*
  * If we are using split PTE locks, then we need to take the page
  * lock here.  Otherwise we are using shared mm->page_table_lock
@@ -84,10 +84,10 @@ static inline void do_pte_unlock(spinloc
 {
 	spin_unlock(ptl);
 }
-#else /* !USE_SPLIT_PTLOCKS */
+#else /* !USE_SPLIT_PTE_PTLOCKS */
 static inline void do_pte_lock(spinlock_t *ptl) {}
 static inline void do_pte_unlock(spinlock_t *ptl) {}
-#endif /* USE_SPLIT_PTLOCKS */
+#endif /* USE_SPLIT_PTE_PTLOCKS */
 
 static int adjust_pte(struct vm_area_struct *vma, unsigned long address,
 	unsigned long pfn)
diff -puN arch/x86/xen/mmu.c~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks
+++ a/arch/x86/xen/mmu.c
@@ -796,7 +796,7 @@ static spinlock_t *xen_pte_lock(struct p
 {
 	spinlock_t *ptl = NULL;
 
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTE_PTLOCKS
 	ptl = __pte_lockptr(page);
 	spin_lock_nest_lock(ptl, &mm->page_table_lock);
 #endif
@@ -1637,7 +1637,7 @@ static inline void xen_alloc_ptpage(stru
 
 			__set_pfn_prot(pfn, PAGE_KERNEL_RO);
 
-			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
+			if (level == PT_PTE && USE_SPLIT_PTE_PTLOCKS)
 				__pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
 
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
@@ -1671,7 +1671,7 @@ static inline void xen_release_ptpage(un
 		if (!PageHighMem(page)) {
 			xen_mc_batch();
 
-			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
+			if (level == PT_PTE && USE_SPLIT_PTE_PTLOCKS)
 				__pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 
 			__set_pfn_prot(pfn, PAGE_KERNEL);
diff -puN include/linux/mm.h~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks
+++ a/include/linux/mm.h
@@ -1232,7 +1232,7 @@ static inline pmd_t *pmd_alloc(struct mm
 }
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTE_PTLOCKS
 /*
  * We tuck a spinlock to guard each pagetable page into its struct page,
  * at page->private, with BUILD_BUG_ON to make sure that this will not
@@ -1245,14 +1245,14 @@ static inline pmd_t *pmd_alloc(struct mm
 } while (0)
 #define pte_lock_deinit(page)	((page)->mapping = NULL)
 #define pte_lockptr(mm, pmd)	({(void)(mm); __pte_lockptr(pmd_page(*(pmd)));})
-#else	/* !USE_SPLIT_PTLOCKS */
+#else	/* !USE_SPLIT_PTE_PTLOCKS */
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
 #define pte_lock_init(page)	do {} while (0)
 #define pte_lock_deinit(page)	do {} while (0)
 #define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
-#endif /* USE_SPLIT_PTLOCKS */
+#endif /* USE_SPLIT_PTE_PTLOCKS */
 
 static inline void pgtable_page_ctor(struct page *page)
 {
diff -puN include/linux/mm_types.h~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks
+++ a/include/linux/mm_types.h
@@ -23,7 +23,7 @@
 
 struct address_space;
 
-#define USE_SPLIT_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
+#define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -141,7 +141,7 @@ struct page {
 						 * indicates order in the buddy
 						 * system if PG_buddy is set.
 						 */
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTE_PTLOCKS
 		spinlock_t ptl;
 #endif
 		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
@@ -309,14 +309,14 @@ enum {
 	NR_MM_COUNTERS
 };
 
-#if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
+#if USE_SPLIT_PTE_PTLOCKS && defined(CONFIG_MMU)
 #define SPLIT_RSS_COUNTING
 /* per-thread cached information, */
 struct task_rss_stat {
 	int events;	/* for synchronization threshold */
 	int count[NR_MM_COUNTERS];
 };
-#endif /* USE_SPLIT_PTLOCKS */
+#endif /* USE_SPLIT_PTE_PTLOCKS */
 
 struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
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

