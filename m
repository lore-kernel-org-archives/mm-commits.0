From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch removed from -mm tree
Date: Wed, 06 Nov 2013 13:36:29 -0800
Message-ID: <527ab65d./AWfD1x+loPH1mi1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3KFVga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Nov 2013 16:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, kirill.shutemov@linux.intel.com

Subject: [to-be-updated] mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 06 Nov 2013 13:36:29 -0800


The patch titled
     Subject: mm: dynamically allocate page->ptl if it cannot be embedded to struct page
has been removed from the -mm tree.  Its filename was
     mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: dynamically allocate page->ptl if it cannot be embedded to struct page

If split page table lock is in use, we embed the lock into struct page of
table's page.  We have to disable split lock, if spinlock_t is too big be
to be embedded, like when DEBUG_SPINLOCK or DEBUG_LOCK_ALLOC enabled.

This patch add support for dynamic allocation of split page table lock if
we can't embed it to struct page.

page->ptl is unsigned long now and we use it as spinlock_t if
sizeof(spinlock_t) <= sizeof(long), otherwise it's pointer to spinlock_t.

The spinlock_t allocated in pgtable_page_ctor() for PTE table and in
pgtable_pmd_page_ctor() for PMD table.  All other helpers converted to
support dynamically allocated page->ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/split_page_table_lock |   94 +++++++++++++++++++++++
 arch/x86/xen/mmu.c                     |    2 
 include/linux/mm.h                     |   81 ++++++++++++++-----
 include/linux/mm_types.h               |    5 -
 mm/Kconfig                             |    2 
 mm/memory.c                            |   19 ++++
 6 files changed, 179 insertions(+), 24 deletions(-)

diff -puN /dev/null Documentation/vm/split_page_table_lock
--- /dev/null
+++ a/Documentation/vm/split_page_table_lock
@@ -0,0 +1,94 @@
+Split page table lock
+=====================
+
+Originally, mm->page_table_lock spinlock protected all page tables of the
+mm_struct. But this approach leads to poor page fault scalability of
+multi-threaded applications due high contention on the lock. To improve
+scalability, split page table lock was introduced.
+
+With split page table lock we have separate per-table lock to serialize
+access to the table. At the moment we use split lock for PTE and PMD
+tables. Access to higher level tables protected by mm->page_table_lock.
+
+There are helpers to lock/unlock a table and other accessor functions:
+ - pte_offset_map_lock()
+	maps pte and takes PTE table lock, returns pointer to the taken
+	lock;
+ - pte_unmap_unlock()
+	unlocks and unmaps PTE table;
+ - pte_alloc_map_lock()
+	allocates PTE table if needed and take the lock, returns pointer
+	to taken lock or NULL if allocation failed;
+ - pte_lockptr()
+	returns pointer to PTE table lock;
+ - pmd_lock()
+	takes PMD table lock, returns pointer to taken lock;
+ - pmd_lockptr()
+	returns pointer to PMD table lock;
+
+Split page table lock for PTE tables is enabled compile-time if
+CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
+If split lock is disabled, all tables guaded by mm->page_table_lock.
+
+Split page table lock for PMD tables is enabled, if it's enabled for PTE
+tables and the architecture supports it (see below).
+
+Hugetlb and split page table lock
+---------------------------------
+
+Hugetlb can support several page sizes. We use split lock only for PMD
+level, but not for PUD.
+
+Hugetlb-specific helpers:
+ - huge_pte_lock()
+	takes pmd split lock for PMD_SIZE page, mm->page_table_lock
+	otherwise;
+ - huge_pte_lockptr()
+	returns pointer to table lock;
+
+Support of split page table lock by an architecture
+---------------------------------------------------
+
+There's no need in special enabling of PTE split page table lock:
+everything required is done by pgtable_page_ctor() and pgtable_page_dtor(),
+which must be called on PTE table allocation / freeing.
+
+Make sure the architecture doesn't use slab allocator for page table
+allocation: slab uses page->slab_cache and page->first_page for its pages.
+These fields share storage with page->ptl.
+
+PMD split lock only makes sense if you have more than two page table
+levels.
+
+PMD split lock enabling requires pgtable_pmd_page_ctor() call on PMD table
+allocation and pgtable_pmd_page_dtor() on freeing.
+
+Allocation usually happens in pmd_alloc_one(), freeing in pmd_free(), but
+make sure you cover all PMD table allocation / freeing paths: i.e X86_PAE
+preallocate few PMDs on pgd_alloc().
+
+With everything in place you can set CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK.
+
+NOTE: pgtable_page_ctor() and pgtable_pmd_page_ctor() can fail -- it must
+be handled properly.
+
+page->ptl
+---------
+
+page->ptl is used to access split page table lock, where 'page' is struct
+page of page containing the table. It shares storage with page->private
+(and few other fields in union).
+
+To avoid increasing size of struct page and have best performance, we use a
+trick:
+ - if spinlock_t fits into long, we use page->ptr as spinlock, so we
+   can avoid indirect access and save a cache line.
+ - if size of spinlock_t is bigger then size of long, we use page->ptl as
+   pointer to spinlock_t and allocate it dynamically. This allows to use
+   split lock with enabled DEBUG_SPINLOCK or DEBUG_LOCK_ALLOC, but costs
+   one more cache line for indirect access;
+
+The spinlock_t allocated in pgtable_page_ctor() for PTE table and in
+pgtable_pmd_page_ctor() for PMD table.
+
+Please, never access page->ptl directly -- use appropriate helper.
diff -puN arch/x86/xen/mmu.c~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page
+++ a/arch/x86/xen/mmu.c
@@ -797,7 +797,7 @@ static spinlock_t *xen_pte_lock(struct p
 	spinlock_t *ptl = NULL;
 
 #if USE_SPLIT_PTE_PTLOCKS
-	ptl = __pte_lockptr(page);
+	ptl = ptlock_ptr(page);
 	spin_lock_nest_lock(ptl, &mm->page_table_lock);
 #endif
 
diff -puN include/linux/mm.h~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page include/linux/mm.h
--- a/include/linux/mm.h~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page
+++ a/include/linux/mm.h
@@ -1317,32 +1317,73 @@ static inline pmd_t *pmd_alloc(struct mm
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
 #if USE_SPLIT_PTE_PTLOCKS
-/*
- * We tuck a spinlock to guard each pagetable page into its struct page,
- * at page->private, with BUILD_BUG_ON to make sure that this will not
- * overflow into the next struct page (as it might with DEBUG_SPINLOCK).
- * When freeing, reset page->mapping so free_pages_check won't complain.
- */
-#define __pte_lockptr(page)	&((page)->ptl)
-#define pte_lock_init(_page)	do {					\
-	spin_lock_init(__pte_lockptr(_page));				\
-} while (0)
-#define pte_lock_deinit(page)	((page)->mapping = NULL)
-#define pte_lockptr(mm, pmd)	({(void)(mm); __pte_lockptr(pmd_page(*(pmd)));})
+bool __ptlock_alloc(struct page *page);
+void __ptlock_free(struct page *page);
+static inline bool ptlock_alloc(struct page *page)
+{
+	if (sizeof(spinlock_t) > sizeof(page->ptl))
+		return __ptlock_alloc(page);
+	return true;
+}
+static inline void ptlock_free(struct page *page)
+{
+	if (sizeof(spinlock_t) > sizeof(page->ptl))
+		__ptlock_free(page);
+}
+
+static inline spinlock_t *ptlock_ptr(struct page *page)
+{
+	if (sizeof(spinlock_t) > sizeof(page->ptl))
+		return (spinlock_t *) page->ptl;
+	else
+		return (spinlock_t *) &page->ptl;
+}
+
+static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
+{
+	return ptlock_ptr(pmd_page(*pmd));
+}
+
+static inline bool ptlock_init(struct page *page)
+{
+	/*
+	 * prep_new_page() initialize page->private (and therefore page->ptl)
+	 * with 0. Make sure nobody took it in use in between.
+	 *
+	 * It can happen if arch try to use slab for page table allocation:
+	 * slab code uses page->slab_cache and page->first_page (for tail
+	 * pages), which share storage with page->ptl.
+	 */
+	VM_BUG_ON(page->ptl);
+	if (!ptlock_alloc(page))
+		return false;
+	spin_lock_init(ptlock_ptr(page));
+	return true;
+}
+
+/* Reset page->mapping so free_pages_check won't complain. */
+static inline void pte_lock_deinit(struct page *page)
+{
+	page->mapping = NULL;
+	ptlock_free(page);
+}
+
 #else	/* !USE_SPLIT_PTE_PTLOCKS */
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
-#define pte_lock_init(page)	do {} while (0)
-#define pte_lock_deinit(page)	do {} while (0)
-#define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
+static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
+{
+	return &mm->page_table_lock;
+}
+static inline bool ptlock_init(struct page *page) { return true; }
+static inline void pte_lock_deinit(struct page *page) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
 static inline bool pgtable_page_ctor(struct page *page)
 {
-	pte_lock_init(page);
 	inc_zone_page_state(page, NR_PAGETABLE);
-	return true;
+	return ptlock_init(page);
 }
 
 static inline void pgtable_page_dtor(struct page *page)
@@ -1383,16 +1424,15 @@ static inline void pgtable_page_dtor(str
 
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
-	return &virt_to_page(pmd)->ptl;
+	return ptlock_ptr(virt_to_page(pmd));
 }
 
 static inline bool pgtable_pmd_page_ctor(struct page *page)
 {
-	spin_lock_init(&page->ptl);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	page->pmd_huge_pte = NULL;
 #endif
-	return true;
+	return ptlock_init(page);
 }
 
 static inline void pgtable_pmd_page_dtor(struct page *page)
@@ -1400,6 +1440,7 @@ static inline void pgtable_pmd_page_dtor
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	VM_BUG_ON(page->pmd_huge_pte);
 #endif
+	ptlock_free(page);
 }
 
 #define pmd_huge_pte(mm, pmd) (virt_to_page(pmd)->pmd_huge_pte)
diff -puN include/linux/mm_types.h~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page
+++ a/include/linux/mm_types.h
@@ -155,7 +155,10 @@ struct page {
 						 * system if PG_buddy is set.
 						 */
 #if USE_SPLIT_PTE_PTLOCKS
-		spinlock_t ptl;
+		unsigned long ptl; /* It's spinlock_t if it fits to long,
+				    * otherwise it's pointer to dynamicaly
+				    * allocated spinlock_t.
+				    */
 #endif
 		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
 		struct page *first_page;	/* Compound tail pages */
diff -puN mm/Kconfig~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page mm/Kconfig
--- a/mm/Kconfig~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page
+++ a/mm/Kconfig
@@ -218,8 +218,6 @@ config SPLIT_PTLOCK_CPUS
 	int
 	default "999999" if ARM && !CPU_CACHE_VIPT
 	default "999999" if PARISC && !PA20
-	default "999999" if DEBUG_SPINLOCK || DEBUG_LOCK_ALLOC
-	default "999999" if !64BIT && GENERIC_LOCKBREAK
 	default "4"
 
 config ARCH_ENABLE_SPLIT_PMD_PTLOCK
diff -puN mm/memory.c~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page mm/memory.c
--- a/mm/memory.c~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page
+++ a/mm/memory.c
@@ -4270,3 +4270,22 @@ void copy_user_huge_page(struct page *ds
 	}
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
+
+#if USE_SPLIT_PTE_PTLOCKS
+bool __ptlock_alloc(struct page *page)
+{
+	spinlock_t *ptl;
+
+	ptl = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
+	if (!ptl)
+		return false;
+	page->ptl = (unsigned long)ptl;
+	return true;
+}
+
+void __ptlock_free(struct page *page)
+{
+	if (sizeof(spinlock_t) > sizeof(page->ptl))
+		kfree((spinlock_t *)page->ptl);
+}
+#endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
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
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
cris-fix-potential-null-pointer-dereference.patch
m32r-fix-potential-null-pointer-dereference.patch
xtensa-fix-potential-null-pointer-dereference.patch
mm-allow-pgtable_page_ctor-to-fail.patch
microblaze-add-missing-pgtable_page_ctor-dtor-calls.patch
mn10300-add-missing-pgtable_page_ctor-dtor-calls.patch
openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch
alpha-handle-pgtable_page_ctor-fail.patch
arc-handle-pgtable_page_ctor-fail.patch
arm-handle-pgtable_page_ctor-fail.patch
arm64-handle-pgtable_page_ctor-fail.patch
avr32-handle-pgtable_page_ctor-fail.patch
cris-handle-pgtable_page_ctor-fail.patch
frv-handle-pgtable_page_ctor-fail.patch
hexagon-handle-pgtable_page_ctor-fail.patch
ia64-handle-pgtable_page_ctor-fail.patch
m32r-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
metag-handle-pgtable_page_ctor-fail.patch
mips-handle-pgtable_page_ctor-fail.patch
parisc-handle-pgtable_page_ctor-fail.patch
powerpc-handle-pgtable_page_ctor-fail.patch
s390-handle-pgtable_page_ctor-fail.patch
score-handle-pgtable_page_ctor-fail.patch
sh-handle-pgtable_page_ctor-fail.patch
sparc-handle-pgtable_page_ctor-fail.patch
tile-handle-pgtable_page_ctor-fail.patch
um-handle-pgtable_page_ctor-fail.patch
unicore32-handle-pgtable_page_ctor-fail.patch
x86-handle-pgtable_page_ctor-fail.patch
xtensa-handle-pgtable_page_ctor-fail.patch
iommu-arm-smmu-handle-pgtable_page_ctor-fail.patch
xtensa-use-buddy-allocator-for-pte-table.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch

