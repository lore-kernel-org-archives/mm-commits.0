From: akpm@linux-foundation.org
Subject: - mm-remove-fastcall-from-mm.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:13 -0800
Message-ID: <200802052231.m15MVsKG012196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762276AbYBEWlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove fastcall from mm/
has been removed from the -mm tree.  Its filename was
     mm-remove-fastcall-from-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove fastcall from mm/
From: Harvey Harrison <harvey.harrison@gmail.com>

fastcall is always defined to be empty, remove it

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c        |   10 +++++-----
 mm/highmem.c        |    4 ++--
 mm/internal.h       |    2 +-
 mm/memory.c         |    3 ++-
 mm/page-writeback.c |    2 +-
 mm/page_alloc.c     |   16 ++++++++--------
 mm/swap.c           |   10 +++++-----
 7 files changed, 24 insertions(+), 23 deletions(-)

diff -puN mm/filemap.c~mm-remove-fastcall-from-mm mm/filemap.c
--- a/mm/filemap.c~mm-remove-fastcall-from-mm
+++ a/mm/filemap.c
@@ -527,7 +527,7 @@ static inline void wake_up_page(struct p
 	__wake_up_bit(page_waitqueue(page), &page->flags, bit);
 }
 
-void fastcall wait_on_page_bit(struct page *page, int bit_nr)
+void wait_on_page_bit(struct page *page, int bit_nr)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
 
@@ -551,7 +551,7 @@ EXPORT_SYMBOL(wait_on_page_bit);
  * the clear_bit and the read of the waitqueue (to avoid SMP races with a
  * parallel wait_on_page_locked()).
  */
-void fastcall unlock_page(struct page *page)
+void unlock_page(struct page *page)
 {
 	smp_mb__before_clear_bit();
 	if (!TestClearPageLocked(page))
@@ -585,7 +585,7 @@ EXPORT_SYMBOL(end_page_writeback);
  * chances are that on the second loop, the block layer's plug list is empty,
  * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
  */
-void fastcall __lock_page(struct page *page)
+void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
@@ -606,7 +606,7 @@ int fastcall __lock_page_killable(struct
  * Variant of lock_page that does not require the caller to hold a reference
  * on the page's mapping.
  */
-void fastcall __lock_page_nosync(struct page *page)
+void __lock_page_nosync(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 	__wait_on_bit_lock(page_waitqueue(page), &wait, __sleep_on_page_lock,
@@ -1276,7 +1276,7 @@ asmlinkage ssize_t sys_readahead(int fd,
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
  */
-static int fastcall page_cache_read(struct file * file, pgoff_t offset)
+static int page_cache_read(struct file *file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *page; 
diff -puN mm/highmem.c~mm-remove-fastcall-from-mm mm/highmem.c
--- a/mm/highmem.c~mm-remove-fastcall-from-mm
+++ a/mm/highmem.c
@@ -163,7 +163,7 @@ start:
 	return vaddr;
 }
 
-void fastcall *kmap_high(struct page *page)
+void *kmap_high(struct page *page)
 {
 	unsigned long vaddr;
 
@@ -185,7 +185,7 @@ void fastcall *kmap_high(struct page *pa
 
 EXPORT_SYMBOL(kmap_high);
 
-void fastcall kunmap_high(struct page *page)
+void kunmap_high(struct page *page)
 {
 	unsigned long vaddr;
 	unsigned long nr;
diff -puN mm/internal.h~mm-remove-fastcall-from-mm mm/internal.h
--- a/mm/internal.h~mm-remove-fastcall-from-mm
+++ a/mm/internal.h
@@ -34,7 +34,7 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
-extern void fastcall __init __free_pages_bootmem(struct page *page,
+extern void __init __free_pages_bootmem(struct page *page,
 						unsigned int order);
 
 /*
diff -puN mm/memory.c~mm-remove-fastcall-from-mm mm/memory.c
--- a/mm/memory.c~mm-remove-fastcall-from-mm
+++ a/mm/memory.c
@@ -1109,7 +1109,8 @@ int get_user_pages(struct task_struct *t
 }
 EXPORT_SYMBOL(get_user_pages);
 
-pte_t * fastcall get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl)
+pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			spinlock_t **ptl)
 {
 	pgd_t * pgd = pgd_offset(mm, addr);
 	pud_t * pud = pud_alloc(mm, pgd, addr);
diff -puN mm/page-writeback.c~mm-remove-fastcall-from-mm mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-fastcall-from-mm
+++ a/mm/page-writeback.c
@@ -1073,7 +1073,7 @@ static int __set_page_dirty(struct page 
 	return 0;
 }
 
-int fastcall set_page_dirty(struct page *page)
+int set_page_dirty(struct page *page)
 {
 	int ret = __set_page_dirty(page);
 	if (ret)
diff -puN mm/page_alloc.c~mm-remove-fastcall-from-mm mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-fastcall-from-mm
+++ a/mm/page_alloc.c
@@ -537,7 +537,7 @@ static void __free_pages_ok(struct page 
 /*
  * permit the bootmem allocator to evade page validation on high-order frees
  */
-void fastcall __init __free_pages_bootmem(struct page *page, unsigned int order)
+void __init __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	if (order == 0) {
 		__ClearPageReserved(page);
@@ -974,7 +974,7 @@ void mark_free_pages(struct zone *zone)
 /*
  * Free a 0-order page
  */
-static void fastcall free_hot_cold_page(struct page *page, int cold)
+static void free_hot_cold_page(struct page *page, int cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -1007,12 +1007,12 @@ static void fastcall free_hot_cold_page(
 	put_cpu();
 }
 
-void fastcall free_hot_page(struct page *page)
+void free_hot_page(struct page *page)
 {
 	free_hot_cold_page(page, 0);
 }
 	
-void fastcall free_cold_page(struct page *page)
+void free_cold_page(struct page *page)
 {
 	free_hot_cold_page(page, 1);
 }
@@ -1641,7 +1641,7 @@ EXPORT_SYMBOL(__alloc_pages);
 /*
  * Common helper functions.
  */
-fastcall unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
+unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page * page;
 	page = alloc_pages(gfp_mask, order);
@@ -1652,7 +1652,7 @@ fastcall unsigned long __get_free_pages(
 
 EXPORT_SYMBOL(__get_free_pages);
 
-fastcall unsigned long get_zeroed_page(gfp_t gfp_mask)
+unsigned long get_zeroed_page(gfp_t gfp_mask)
 {
 	struct page * page;
 
@@ -1678,7 +1678,7 @@ void __pagevec_free(struct pagevec *pvec
 		free_hot_cold_page(pvec->pages[i], pvec->cold);
 }
 
-fastcall void __free_pages(struct page *page, unsigned int order)
+void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page)) {
 		if (order == 0)
@@ -1690,7 +1690,7 @@ fastcall void __free_pages(struct page *
 
 EXPORT_SYMBOL(__free_pages);
 
-fastcall void free_pages(unsigned long addr, unsigned int order)
+void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
 		VM_BUG_ON(!virt_addr_valid((void *)addr));
diff -puN mm/swap.c~mm-remove-fastcall-from-mm mm/swap.c
--- a/mm/swap.c~mm-remove-fastcall-from-mm
+++ a/mm/swap.c
@@ -41,7 +41,7 @@ static DEFINE_PER_CPU(struct pagevec, lr
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.
  */
-static void fastcall __page_cache_release(struct page *page)
+static void __page_cache_release(struct page *page)
 {
 	if (PageLRU(page)) {
 		unsigned long flags;
@@ -165,7 +165,7 @@ int rotate_reclaimable_page(struct page 
 /*
  * FIXME: speed this up?
  */
-void fastcall activate_page(struct page *page)
+void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
 
@@ -186,7 +186,7 @@ void fastcall activate_page(struct page 
  * inactive,referenced		->	active,unreferenced
  * active,unreferenced		->	active,referenced
  */
-void fastcall mark_page_accessed(struct page *page)
+void mark_page_accessed(struct page *page)
 {
 	if (!PageActive(page) && PageReferenced(page) && PageLRU(page)) {
 		activate_page(page);
@@ -202,7 +202,7 @@ EXPORT_SYMBOL(mark_page_accessed);
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
  */
-void fastcall lru_cache_add(struct page *page)
+void lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
 
@@ -212,7 +212,7 @@ void fastcall lru_cache_add(struct page 
 	put_cpu_var(lru_add_pvecs);
 }
 
-void fastcall lru_cache_add_active(struct page *page)
+void lru_cache_add_active(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_active_pvecs);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
fs-remove-fastcall-it-is-always-empty.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
asm-generic-remove-fastcall.patch
misc-removal-of-final-callers-using-fastcall.patch
