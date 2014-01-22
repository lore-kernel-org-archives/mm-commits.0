From: akpm@linux-foundation.org
Subject: [merged]
 mm-create-a-separate-slab-for-page-ptl-allocation-try-two.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:12:40 -0800
Message-ID: <52e02638.X6vvh/JEp38oKmeK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-create-a-separate-slab-for-page-ptl-allocation-try-two.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:40 -0800


The patch titled
     Subject: mm: create a separate slab for page->ptl allocation
has been removed from the -mm tree.  Its filename was
     mm-create-a-separate-slab-for-page-ptl-allocation-try-two.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: create a separate slab for page->ptl allocation

If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64 is
72 bytes.  For page->ptl they will be allocated from kmalloc-96 slab, so
we loose 24 on each.  An average system can easily allocate few tens
thousands of page->ptl and overhead is significant.

Let's create a separate slab for page->ptl allocation to solve this.

To make sure that it really works this time, some numbers from my test
machine (just booted, no load):

Before:
  # grep '^\(kmalloc-96\|page->ptl\)' /proc/slabinfo
  kmalloc-96         31987  32190    128   30    1 : tunables  120   60    8 : slabdata   1073   1073     92
After:
  # grep '^\(kmalloc-96\|page->ptl\)' /proc/slabinfo
  page->ptl          27516  28143     72   53    1 : tunables  120   60    8 : slabdata    531    531      9
  kmalloc-96          3853   5280    128   30    1 : tunables  120   60    8 : slabdata    176    176      0

Note that the patch is useful not only for debug case, but also for
PREEMPT_RT, where spinlock_t is always bloated.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++++++++
 init/main.c        |    2 +-
 mm/memory.c        |   13 +++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-create-a-separate-slab-for-page-ptl-allocation-try-two include/linux/mm.h
--- a/include/linux/mm.h~mm-create-a-separate-slab-for-page-ptl-allocation-try-two
+++ a/include/linux/mm.h
@@ -1350,6 +1350,7 @@ static inline pmd_t *pmd_alloc(struct mm
 
 #if USE_SPLIT_PTE_PTLOCKS
 #if ALLOC_SPLIT_PTLOCKS
+void __init ptlock_cache_init(void);
 extern bool ptlock_alloc(struct page *page);
 extern void ptlock_free(struct page *page);
 
@@ -1358,6 +1359,10 @@ static inline spinlock_t *ptlock_ptr(str
 	return page->ptl;
 }
 #else /* ALLOC_SPLIT_PTLOCKS */
+static inline void ptlock_cache_init(void)
+{
+}
+
 static inline bool ptlock_alloc(struct page *page)
 {
 	return true;
@@ -1410,10 +1415,17 @@ static inline spinlock_t *pte_lockptr(st
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
diff -puN init/main.c~mm-create-a-separate-slab-for-page-ptl-allocation-try-two init/main.c
--- a/init/main.c~mm-create-a-separate-slab-for-page-ptl-allocation-try-two
+++ a/init/main.c
@@ -476,7 +476,7 @@ static void __init mm_init(void)
 	mem_init();
 	kmem_cache_init();
 	percpu_init_late();
-	pgtable_cache_init();
+	pgtable_init();
 	vmalloc_init();
 }
 
diff -puN mm/memory.c~mm-create-a-separate-slab-for-page-ptl-allocation-try-two mm/memory.c
--- a/mm/memory.c~mm-create-a-separate-slab-for-page-ptl-allocation-try-two
+++ a/mm/memory.c
@@ -4275,11 +4275,20 @@ void copy_user_huge_page(struct page *ds
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
+
+static struct kmem_cache *page_ptl_cachep;
+
+void __init ptlock_cache_init(void)
+{
+	page_ptl_cachep = kmem_cache_create("page->ptl", sizeof(spinlock_t), 0,
+			SLAB_PANIC, NULL);
+}
+
 bool ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
 
-	ptl = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
+	ptl = kmem_cache_alloc(page_ptl_cachep, GFP_KERNEL);
 	if (!ptl)
 		return false;
 	page->ptl = ptl;
@@ -4288,6 +4297,6 @@ bool ptlock_alloc(struct page *page)
 
 void ptlock_free(struct page *page)
 {
-	kfree(page->ptl);
+	kmem_cache_free(page_ptl_cachep, page->ptl);
 }
 #endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch

