From: akpm@linux-foundation.org
Subject: + mm-create-a-separate-slab-for-page-ptl-allocation.patch added
 to -mm tree
Date: Tue, 05 Nov 2013 15:01:53 -0800
Message-ID: <527978e1.gJq89ytISidyDor2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3KEXBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, fengguang.wu@intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-create-a-separate-slab-for-page-ptl-allocation.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,fengguang.wu@intel.com,mingo@redhat.com,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:01:53 -0800


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

Fengguang said:

: In a 4p server, we noticed up to +469.1% increase in will-it-scale page_fault3
: test case and +199.8% in vm-scalability case-shm-pread-seq-mt.
: 
:     5c02216ce3110aab070d      5a58baaa0a1af0a43d7c
: ------------------------  ------------------------  
:                300409.00      +440.2%   1622770.80  TOTAL will-it-scale.page_fault3.90.threads
: 
:     5c02216ce3110aab070d      5a58baaa0a1af0a43d7c
: ------------------------  ------------------------  
:                291257.80      +469.1%   1657582.20  TOTAL will-it-scale.page_fault3.120.threads
: 
: ...
: 
:     5c02216ce3110aab070d      5a58baaa0a1af0a43d7c
: ------------------------  ------------------------  
:               4034831.40      +199.8%  12095649.80  TOTAL vm-scalability.throughput

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++++++
 init/main.c        |    2 +-
 mm/memory.c        |   12 ++++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-create-a-separate-slab-for-page-ptl-allocation include/linux/mm.h
--- a/include/linux/mm.h~mm-create-a-separate-slab-for-page-ptl-allocation
+++ a/include/linux/mm.h
@@ -1317,6 +1317,7 @@ static inline pmd_t *pmd_alloc(struct mm
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
 #if USE_SPLIT_PTE_PTLOCKS
+void __init ptlock_cache_init(void);
 bool __ptlock_alloc(struct page *page);
 void __ptlock_free(struct page *page);
 static inline bool ptlock_alloc(struct page *page)
@@ -1369,6 +1370,7 @@ static inline void pte_lock_deinit(struc
 }
 
 #else	/* !USE_SPLIT_PTE_PTLOCKS */
+static inline void ptlock_cache_init(void) {}
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
@@ -1380,6 +1382,12 @@ static inline bool ptlock_init(struct pa
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
@@ -473,7 +473,7 @@ static void __init mm_init(void)
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
@@ -4272,11 +4272,19 @@ void copy_user_huge_page(struct page *ds
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if USE_SPLIT_PTE_PTLOCKS
+struct kmem_cache *page_ptl_cachep;
+void __init ptlock_cache_init(void)
+{
+	if (sizeof(spinlock_t) > sizeof(long))
+		page_ptl_cachep = kmem_cache_create("page->ptl",
+				sizeof(spinlock_t), 0, SLAB_PANIC, NULL);
+}
+
 bool __ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
 
-	ptl = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
+	ptl = kmem_cache_alloc(page_ptl_cachep, GFP_KERNEL);
 	if (!ptl)
 		return false;
 	page->ptl = (unsigned long)ptl;
@@ -4286,6 +4294,6 @@ bool __ptlock_alloc(struct page *page)
 void __ptlock_free(struct page *page)
 {
 	if (sizeof(spinlock_t) > sizeof(page->ptl))
-		kfree((spinlock_t *)page->ptl);
+		kmem_cache_free(page_ptl_cachep, (spinlock_t *)page->ptl);
 }
 #endif
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
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch

