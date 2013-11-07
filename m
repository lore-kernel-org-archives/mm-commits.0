From: akpm@linux-foundation.org
Subject: + mm-create-a-separate-slab-for-page-ptl-allocation.patch added
 to -mm tree
Date: Thu, 07 Nov 2013 14:00:19 -0800
Message-ID: <527c0d73.Jj0B2KWfpTQZkwBV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3KGWAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:00:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@elte.hu, kirill.shutemov@linux.intel.com

Subject: + mm-create-a-separate-slab-for-page-ptl-allocation.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,mingo@elte.hu,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:00:19 -0800


The patch titled
     Subject: mm: create a separate slab for page->ptl allocation
has been added to the -mm tree.  Its filename is
     mm-create-a-separate-slab-for-page-ptl-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-create-a-separate-slab-for-page-ptl-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-create-a-separate-slab-for-page-ptl-allocation.patch

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
Subject: mm: create a separate slab for page->ptl allocation

If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64 is
72 bytes.  For page->ptl they will be allocated from kmalloc-96 slab, so
we loose 24 on each.  An average system can easily allocate few tens
thousands of page->ptl and overhead is significant.

Let's create a separate slab for page->ptl allocation to solve this.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++++++
 init/main.c        |    2 +-
 mm/memory.c        |    7 +++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-create-a-separate-slab-for-page-ptl-allocation include/linux/mm.h
--- a/include/linux/mm.h~mm-create-a-separate-slab-for-page-ptl-allocation
+++ a/include/linux/mm.h
@@ -1318,6 +1318,7 @@ static inline pmd_t *pmd_alloc(struct mm
 
 #if USE_SPLIT_PTE_PTLOCKS
 #if BLOATED_SPINLOCKS
+void __init ptlock_cache_init(void);
 extern bool ptlock_alloc(struct page *page);
 extern void ptlock_free(struct page *page);
 
@@ -1326,6 +1327,7 @@ static inline spinlock_t *ptlock_ptr(str
 	return page->ptl;
 }
 #else /* BLOATED_SPINLOCKS */
+static inline void ptlock_cache_init(void) {}
 static inline bool ptlock_alloc(struct page *page)
 {
 	return true;
@@ -1378,10 +1380,17 @@ static inline spinlock_t *pte_lockptr(st
 {
 	return &mm->page_table_lock;
 }
+static inline void ptlock_cache_init(void) {}
 static inline bool ptlock_init(struct page *page) { return true; }
 static inline void pte_lock_deinit(struct page *page) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
+static inline void pgtable_init(void)
+{
+	ptlock_cache_init();
+	pgtable_cache_init();
+}
+
 static inline bool pgtable_page_ctor(struct page *page)
 {
 	inc_zone_page_state(page, NR_PAGETABLE);
diff -puN init/main.c~mm-create-a-separate-slab-for-page-ptl-allocation init/main.c
--- a/init/main.c~mm-create-a-separate-slab-for-page-ptl-allocation
+++ a/init/main.c
@@ -476,7 +476,7 @@ static void __init mm_init(void)
 	mem_init();
 	kmem_cache_init();
 	percpu_init_late();
-	pgtable_cache_init();
+	pgtable_init();
 	vmalloc_init();
 }
 
diff -puN mm/memory.c~mm-create-a-separate-slab-for-page-ptl-allocation mm/memory.c
--- a/mm/memory.c~mm-create-a-separate-slab-for-page-ptl-allocation
+++ a/mm/memory.c
@@ -4272,6 +4272,13 @@ void copy_user_huge_page(struct page *ds
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if USE_SPLIT_PTE_PTLOCKS && BLOATED_SPINLOCKS
+static struct kmem_cache *page_ptl_cachep;
+void __init ptlock_cache_init(void)
+{
+	page_ptl_cachep = kmem_cache_create("page->ptl", sizeof(spinlock_t), 0,
+			SLAB_PANIC, NULL);
+}
+
 bool ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
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
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch

