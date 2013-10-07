From: akpm@linux-foundation.org
Subject: + mm-implement-split-page-table-lock-for-pmd-level.patch added to -mm tree
Date: Mon, 07 Oct 2013 16:12:40 -0700
Message-ID: <52533fe8.iNv9hqXmMsrYc4FK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3JGXMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, rostedt@goodmis.org, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-implement-split-page-table-lock-for-pmd-level.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,rostedt@goodmis.org,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:12:40 -0700


The patch titled
     Subject: mm: implement split page table lock for PMD level
has been added to the -mm tree.  Its filename is
     mm-implement-split-page-table-lock-for-pmd-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-implement-split-page-table-lock-for-pmd-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-implement-split-page-table-lock-for-pmd-level.patch

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
Subject: mm: implement split page table lock for PMD level

The basic idea is the same as with PTE level: the lock is embedded into
struct page of table's page.

We can't use mm->pmd_huge_pte to store pgtables for THP, since we don't
take mm->page_table_lock anymore. Let's reuse page->lru of table's page
for that.

pgtable_pmd_page_ctor() returns true, if initialization is successful and
false otherwise.  Current implementation never fails, but assumption that
constructor can fail will help to port it to -rt where spinlock_t is
rather huge and cannot be embedded into struct page -- dynamic allocation
is required.

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
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   32 ++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |    7 ++++++-
 kernel/fork.c            |    4 ++--
 mm/Kconfig               |    3 +++
 4 files changed, 43 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-implement-split-page-table-lock-for-pmd-level include/linux/mm.h
--- a/include/linux/mm.h~mm-implement-split-page-table-lock-for-pmd-level
+++ a/include/linux/mm.h
@@ -1294,13 +1294,45 @@ static inline void pgtable_page_dtor(str
 	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
 		NULL: pte_offset_kernel(pmd, address))
 
+#if USE_SPLIT_PMD_PTLOCKS
+
+static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
+{
+	return &virt_to_page(pmd)->ptl;
+}
+
+static inline bool pgtable_pmd_page_ctor(struct page *page)
+{
+	spin_lock_init(&page->ptl);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	page->pmd_huge_pte = NULL;
+#endif
+	return true;
+}
+
+static inline void pgtable_pmd_page_dtor(struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(page->pmd_huge_pte);
+#endif
+}
+
+#define pmd_huge_pte(mm, pmd) (virt_to_page(pmd)->pmd_huge_pte)
+
+#else
+
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
 	return &mm->page_table_lock;
 }
 
+static inline bool pgtable_pmd_page_ctor(struct page *page) { return true; }
+static inline void pgtable_pmd_page_dtor(struct page *page) {}
+
 #define pmd_huge_pte(mm, pmd) ((mm)->pmd_huge_pte)
 
+#endif
+
 static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl = pmd_lockptr(mm, pmd);
diff -puN include/linux/mm_types.h~mm-implement-split-page-table-lock-for-pmd-level include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-implement-split-page-table-lock-for-pmd-level
+++ a/include/linux/mm_types.h
@@ -24,6 +24,8 @@
 struct address_space;
 
 #define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
+#define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
+		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -130,6 +132,9 @@ struct page {
 
 		struct list_head list;	/* slobs list of pages */
 		struct slab *slab_page; /* slab fields */
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
+		pgtable_t pmd_huge_pte; /* protected by page->ptl */
+#endif
 	};
 
 	/* Remainder is not double word aligned */
@@ -406,7 +411,7 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
 #endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
diff -puN kernel/fork.c~mm-implement-split-page-table-lock-for-pmd-level kernel/fork.c
--- a/kernel/fork.c~mm-implement-split-page-table-lock-for-pmd-level
+++ a/kernel/fork.c
@@ -560,7 +560,7 @@ static void check_mm(struct mm_struct *m
 					  "mm:%p idx:%d val:%ld\n", mm, i, x);
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	VM_BUG_ON(mm->pmd_huge_pte);
 #endif
 }
@@ -814,7 +814,7 @@ struct mm_struct *dup_mm(struct task_str
 	memcpy(mm, oldmm, sizeof(*mm));
 	mm_init_cpumask(mm);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	mm->pmd_huge_pte = NULL;
 #endif
 #ifdef CONFIG_NUMA_BALANCING
diff -puN mm/Kconfig~mm-implement-split-page-table-lock-for-pmd-level mm/Kconfig
--- a/mm/Kconfig~mm-implement-split-page-table-lock-for-pmd-level
+++ a/mm/Kconfig
@@ -215,6 +215,9 @@ config SPLIT_PTLOCK_CPUS
 	default "999999" if !64BIT && GENERIC_LOCKBREAK
 	default "4"
 
+config ARCH_ENABLE_SPLIT_PMD_PTLOCK
+	boolean
+
 #
 # support for memory balloon compaction
 config BALLOON_COMPACTION
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
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

