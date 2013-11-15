From: akpm@linux-foundation.org
Subject: [merged] mm-create-a-separate-slab-for-page-ptl-allocation.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:52 -0800
Message-ID: <52867f54.wP7vTTR52MDnAZ1S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3KOUIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@elte.hu, kirill.shutemov@linux.intel.com

Subject: [merged] mm-create-a-separate-slab-for-page-ptl-allocation.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mingo@elte.hu,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:52 -0800


The patch titled
     Subject: mm: create a separate slab for page->ptl allocation
has been removed from the -mm tree.  Its filename was
     mm-create-a-separate-slab-for-page-ptl-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

