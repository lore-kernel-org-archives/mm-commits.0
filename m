From: akpm@linux-foundation.org
Subject: [merged]
 mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:58:33 -0800
Message-ID: <52e2b7d9.KEjslaOB4EoIljPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill@shutemov.name, sasha.levin@oracle.com

Subject: [merged] mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch removed from -mm tree
To: sasha.levin@oracle.com,kirill@shutemov.name,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:33 -0800


The patch titled
     Subject: mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE
has been removed from the -mm tree.  Its filename was
     mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE

Most of the VM_BUG_ON assertions are performed on a page.  Usually, when
one of these assertions fails we'll get a BUG_ON with a call stack and the
registers.

I've recently noticed based on the requests to add a small piece of code
that dumps the page to various VM_BUG_ON sites that the page dump is quite
useful to people debugging issues in mm.

This patch adds a VM_BUG_ON_PAGE(cond, page) which beyond doing what
VM_BUG_ON() does, also dumps the page before executing the actual BUG_ON.

[akpm@linux-foundation.org: fix up includes]
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c              |    8 +++---
 include/linux/gfp.h            |    1 
 include/linux/hugetlb.h        |    3 +-
 include/linux/hugetlb_cgroup.h |    5 ++--
 include/linux/mm.h             |   29 +++++++++++-------------
 include/linux/mmdebug.h        |    9 +++++++
 include/linux/page-flags.h     |   10 ++++----
 include/linux/pagemap.h        |   10 ++++----
 include/linux/percpu.h         |    1 
 mm/cleancache.c                |    6 ++---
 mm/compaction.c                |    2 -
 mm/filemap.c                   |   16 ++++++-------
 mm/huge_memory.c               |   36 +++++++++++++++----------------
 mm/hugetlb.c                   |   10 ++++----
 mm/hugetlb_cgroup.c            |    2 -
 mm/internal.h                  |   10 ++++----
 mm/ksm.c                       |   12 +++++-----
 mm/memcontrol.c                |   28 ++++++++++++------------
 mm/memory.c                    |    8 +++---
 mm/migrate.c                   |    6 ++---
 mm/mlock.c                     |    4 +--
 mm/page_alloc.c                |   22 +++++++++---------
 mm/page_io.c                   |    4 +--
 mm/rmap.c                      |   10 ++++----
 mm/shmem.c                     |    8 +++---
 mm/slub.c                      |   12 +++++-----
 mm/swap.c                      |   36 +++++++++++++++----------------
 mm/swap_state.c                |   16 ++++++-------
 mm/swapfile.c                  |    8 +++---
 mm/vmscan.c                    |   20 ++++++++---------
 30 files changed, 181 insertions(+), 171 deletions(-)

diff -puN arch/x86/mm/gup.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/arch/x86/mm/gup.c
@@ -108,8 +108,8 @@ static noinline int gup_pte_range(pmd_t
 
 static inline void get_head_page_multiple(struct page *page, int nr)
 {
-	VM_BUG_ON(page != compound_head(page));
-	VM_BUG_ON(page_count(page) == 0);
+	VM_BUG_ON_PAGE(page != compound_head(page), page);
+	VM_BUG_ON_PAGE(page_count(page) == 0, page);
 	atomic_add(nr, &page->_count);
 	SetPageReferenced(page);
 }
@@ -135,7 +135,7 @@ static noinline int gup_huge_pmd(pmd_t p
 	head = pte_page(pte);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON(compound_head(page) != head);
+		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		if (PageTail(page))
 			get_huge_page_tail(page);
@@ -212,7 +212,7 @@ static noinline int gup_huge_pud(pud_t p
 	head = pte_page(pte);
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON(compound_head(page) != head);
+		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		if (PageTail(page))
 			get_huge_page_tail(page);
diff -puN include/linux/gfp.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/gfp.h
--- a/include/linux/gfp.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/gfp.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_GFP_H
 #define __LINUX_GFP_H
 
+#include <linux/mmdebug.h>
 #include <linux/mmzone.h>
 #include <linux/stddef.h>
 #include <linux/linkage.h>
diff -puN include/linux/hugetlb.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/hugetlb.h
@@ -2,6 +2,7 @@
 #define _LINUX_HUGETLB_H
 
 #include <linux/mm_types.h>
+#include <linux/mmdebug.h>
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
@@ -354,7 +355,7 @@ static inline pte_t arch_make_huge_pte(p
 
 static inline struct hstate *page_hstate(struct page *page)
 {
-	VM_BUG_ON(!PageHuge(page));
+	VM_BUG_ON_PAGE(!PageHuge(page), page);
 	return size_to_hstate(PAGE_SIZE << compound_order(page));
 }
 
diff -puN include/linux/hugetlb_cgroup.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/hugetlb_cgroup.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_HUGETLB_CGROUP_H
 #define _LINUX_HUGETLB_CGROUP_H
 
+#include <linux/mmdebug.h>
 #include <linux/res_counter.h>
 
 struct hugetlb_cgroup;
@@ -28,7 +29,7 @@ struct hugetlb_cgroup;
 
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 {
-	VM_BUG_ON(!PageHuge(page));
+	VM_BUG_ON_PAGE(!PageHuge(page), page);
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
@@ -38,7 +39,7 @@ static inline struct hugetlb_cgroup *hug
 static inline
 int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
 {
-	VM_BUG_ON(!PageHuge(page));
+	VM_BUG_ON_PAGE(!PageHuge(page), page);
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return -1;
diff -puN include/linux/mm.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/mm.h
--- a/include/linux/mm.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/mm.h
@@ -5,6 +5,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/mmdebug.h>
 #include <linux/gfp.h>
 #include <linux/bug.h>
 #include <linux/list.h>
@@ -303,7 +304,7 @@ static inline int get_freepage_migratety
  */
 static inline int put_page_testzero(struct page *page)
 {
-	VM_BUG_ON(atomic_read(&page->_count) == 0);
+	VM_BUG_ON_PAGE(atomic_read(&page->_count) == 0, page);
 	return atomic_dec_and_test(&page->_count);
 }
 
@@ -364,7 +365,7 @@ static inline int is_vmalloc_or_module_a
 static inline void compound_lock(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON(PageSlab(page));
+	VM_BUG_ON_PAGE(PageSlab(page), page);
 	bit_spin_lock(PG_compound_lock, &page->flags);
 #endif
 }
@@ -372,7 +373,7 @@ static inline void compound_lock(struct
 static inline void compound_unlock(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON(PageSlab(page));
+	VM_BUG_ON_PAGE(PageSlab(page), page);
 	bit_spin_unlock(PG_compound_lock, &page->flags);
 #endif
 }
@@ -447,7 +448,7 @@ static inline bool __compound_tail_refco
  */
 static inline bool compound_tail_refcounted(struct page *page)
 {
-	VM_BUG_ON(!PageHead(page));
+	VM_BUG_ON_PAGE(!PageHead(page), page);
 	return __compound_tail_refcounted(page);
 }
 
@@ -456,9 +457,9 @@ static inline void get_huge_page_tail(st
 	/*
 	 * __split_huge_page_refcount() cannot run from under us.
 	 */
-	VM_BUG_ON(!PageTail(page));
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	VM_BUG_ON_PAGE(!PageTail(page), page);
+	VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
+	VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
 	if (compound_tail_refcounted(page->first_page))
 		atomic_inc(&page->_mapcount);
 }
@@ -474,7 +475,7 @@ static inline void get_page(struct page
 	 * Getting a normal page or the head of a compound page
 	 * requires to already have an elevated page->_count.
 	 */
-	VM_BUG_ON(atomic_read(&page->_count) <= 0);
+	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
 	atomic_inc(&page->_count);
 }
 
@@ -511,13 +512,13 @@ static inline int PageBuddy(struct page
 
 static inline void __SetPageBuddy(struct page *page)
 {
-	VM_BUG_ON(atomic_read(&page->_mapcount) != -1);
+	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
 	atomic_set(&page->_mapcount, PAGE_BUDDY_MAPCOUNT_VALUE);
 }
 
 static inline void __ClearPageBuddy(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	VM_BUG_ON_PAGE(!PageBuddy(page), page);
 	atomic_set(&page->_mapcount, -1);
 }
 
@@ -1401,7 +1402,7 @@ static inline bool ptlock_init(struct pa
 	 * slab code uses page->slab_cache and page->first_page (for tail
 	 * pages), which share storage with page->ptl.
 	 */
-	VM_BUG_ON(*(unsigned long *)&page->ptl);
+	VM_BUG_ON_PAGE(*(unsigned long *)&page->ptl, page);
 	if (!ptlock_alloc(page))
 		return false;
 	spin_lock_init(ptlock_ptr(page));
@@ -1492,7 +1493,7 @@ static inline bool pgtable_pmd_page_ctor
 static inline void pgtable_pmd_page_dtor(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON(page->pmd_huge_pte);
+	VM_BUG_ON_PAGE(page->pmd_huge_pte, page);
 #endif
 	ptlock_free(page);
 }
@@ -2029,10 +2030,6 @@ extern void shake_page(struct page *p, i
 extern atomic_long_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
-extern void dump_page(struct page *page, char *reason);
-extern void dump_page_badflags(struct page *page, char *reason,
-			       unsigned long badflags);
-
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr,
diff -puN include/linux/mmdebug.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/mmdebug.h
@@ -1,10 +1,19 @@
 #ifndef LINUX_MM_DEBUG_H
 #define LINUX_MM_DEBUG_H 1
 
+struct page;
+
+extern void dump_page(struct page *page, char *reason);
+extern void dump_page_badflags(struct page *page, char *reason,
+			       unsigned long badflags);
+
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
+#define VM_BUG_ON_PAGE(cond, page) \
+	do { if (unlikely(cond)) { dump_page(page, NULL); BUG(); } } while (0)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
diff -puN include/linux/page-flags.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/page-flags.h
@@ -412,7 +412,7 @@ static inline void ClearPageCompound(str
  */
 static inline int PageTransHuge(struct page *page)
 {
-	VM_BUG_ON(PageTail(page));
+	VM_BUG_ON_PAGE(PageTail(page), page);
 	return PageHead(page);
 }
 
@@ -460,25 +460,25 @@ static inline int PageTransTail(struct p
  */
 static inline int PageSlabPfmemalloc(struct page *page)
 {
-	VM_BUG_ON(!PageSlab(page));
+	VM_BUG_ON_PAGE(!PageSlab(page), page);
 	return PageActive(page);
 }
 
 static inline void SetPageSlabPfmemalloc(struct page *page)
 {
-	VM_BUG_ON(!PageSlab(page));
+	VM_BUG_ON_PAGE(!PageSlab(page), page);
 	SetPageActive(page);
 }
 
 static inline void __ClearPageSlabPfmemalloc(struct page *page)
 {
-	VM_BUG_ON(!PageSlab(page));
+	VM_BUG_ON_PAGE(!PageSlab(page), page);
 	__ClearPageActive(page);
 }
 
 static inline void ClearPageSlabPfmemalloc(struct page *page)
 {
-	VM_BUG_ON(!PageSlab(page));
+	VM_BUG_ON_PAGE(!PageSlab(page), page);
 	ClearPageActive(page);
 }
 
diff -puN include/linux/pagemap.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/pagemap.h
@@ -162,7 +162,7 @@ static inline int page_cache_get_specula
 	 * disabling preempt, and hence no need for the "speculative get" that
 	 * SMP requires.
 	 */
-	VM_BUG_ON(page_count(page) == 0);
+	VM_BUG_ON_PAGE(page_count(page) == 0, page);
 	atomic_inc(&page->_count);
 
 #else
@@ -175,7 +175,7 @@ static inline int page_cache_get_specula
 		return 0;
 	}
 #endif
-	VM_BUG_ON(PageTail(page));
+	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	return 1;
 }
@@ -191,14 +191,14 @@ static inline int page_cache_add_specula
 # ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif
-	VM_BUG_ON(page_count(page) == 0);
+	VM_BUG_ON_PAGE(page_count(page) == 0, page);
 	atomic_add(count, &page->_count);
 
 #else
 	if (unlikely(!atomic_add_unless(&page->_count, count, 0)))
 		return 0;
 #endif
-	VM_BUG_ON(PageCompound(page) && page != compound_head(page));
+	VM_BUG_ON_PAGE(PageCompound(page) && page != compound_head(page), page);
 
 	return 1;
 }
@@ -210,7 +210,7 @@ static inline int page_freeze_refs(struc
 
 static inline void page_unfreeze_refs(struct page *page, int count)
 {
-	VM_BUG_ON(page_count(page) != 0);
+	VM_BUG_ON_PAGE(page_count(page) != 0, page);
 	VM_BUG_ON(count == 0);
 
 	atomic_set(&page->_count, count);
diff -puN include/linux/percpu.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page include/linux/percpu.h
--- a/include/linux/percpu.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/include/linux/percpu.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_PERCPU_H
 #define __LINUX_PERCPU_H
 
+#include <linux/mmdebug.h>
 #include <linux/preempt.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
diff -puN mm/cleancache.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/cleancache.c
--- a/mm/cleancache.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/cleancache.c
@@ -237,7 +237,7 @@ int __cleancache_get_page(struct page *p
 		goto out;
 	}
 
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	fake_pool_id = page->mapping->host->i_sb->cleancache_poolid;
 	if (fake_pool_id < 0)
 		goto out;
@@ -279,7 +279,7 @@ void __cleancache_put_page(struct page *
 		return;
 	}
 
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	fake_pool_id = page->mapping->host->i_sb->cleancache_poolid;
 	if (fake_pool_id < 0)
 		return;
@@ -318,7 +318,7 @@ void __cleancache_invalidate_page(struct
 		if (pool_id < 0)
 			return;
 
-		VM_BUG_ON(!PageLocked(page));
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		if (cleancache_get_key(mapping->host, &key) >= 0) {
 			cleancache_ops->invalidate_page(pool_id,
 					key, page->index);
diff -puN mm/compaction.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/compaction.c
--- a/mm/compaction.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/compaction.c
@@ -601,7 +601,7 @@ isolate_migratepages_range(struct zone *
 		if (__isolate_lru_page(page, mode) != 0)
 			continue;
 
-		VM_BUG_ON(PageTransCompound(page));
+		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
 		/* Successfully isolated */
 		cc->finished_update_migrate = true;
diff -puN mm/filemap.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/filemap.c
--- a/mm/filemap.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/filemap.c
@@ -409,9 +409,9 @@ int replace_page_cache_page(struct page
 {
 	int error;
 
-	VM_BUG_ON(!PageLocked(old));
-	VM_BUG_ON(!PageLocked(new));
-	VM_BUG_ON(new->mapping);
+	VM_BUG_ON_PAGE(!PageLocked(old), old);
+	VM_BUG_ON_PAGE(!PageLocked(new), new);
+	VM_BUG_ON_PAGE(new->mapping, new);
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (!error) {
@@ -461,8 +461,8 @@ int add_to_page_cache_locked(struct page
 {
 	int error;
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(PageSwapBacked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
 
 	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
@@ -607,7 +607,7 @@ EXPORT_SYMBOL_GPL(add_page_wait_queue);
  */
 void unlock_page(struct page *page)
 {
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	clear_bit_unlock(PG_locked, &page->flags);
 	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_locked);
@@ -760,7 +760,7 @@ repeat:
 			page_cache_release(page);
 			goto repeat;
 		}
-		VM_BUG_ON(page->index != offset);
+		VM_BUG_ON_PAGE(page->index != offset, page);
 	}
 	return page;
 }
@@ -1656,7 +1656,7 @@ retry_find:
 		put_page(page);
 		goto retry_find;
 	}
-	VM_BUG_ON(page->index != offset);
+	VM_BUG_ON_PAGE(page->index != offset, page);
 
 	/*
 	 * We have a locked page in the page cache, now we need to check
diff -puN mm/huge_memory.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/huge_memory.c
@@ -712,7 +712,7 @@ static int __do_huge_pmd_anonymous_page(
 	pgtable_t pgtable;
 	spinlock_t *ptl;
 
-	VM_BUG_ON(!PageCompound(page));
+	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	pgtable = pte_alloc_one(mm, haddr);
 	if (unlikely(!pgtable))
 		return VM_FAULT_OOM;
@@ -893,7 +893,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out;
 	}
 	src_page = pmd_page(pmd);
-	VM_BUG_ON(!PageHead(src_page));
+	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	get_page(src_page);
 	page_dup_rmap(src_page);
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
@@ -1067,7 +1067,7 @@ static int do_huge_pmd_wp_page_fallback(
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto out_free_pages;
-	VM_BUG_ON(!PageHead(page));
+	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
@@ -1133,7 +1133,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		goto out_unlock;
 
 	page = pmd_page(orig_pmd);
-	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
+	VM_BUG_ON_PAGE(!PageCompound(page) || !PageHead(page), page);
 	if (page_mapcount(page) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
@@ -1211,7 +1211,7 @@ alloc:
 			add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 			put_huge_zero_page();
 		} else {
-			VM_BUG_ON(!PageHead(page));
+			VM_BUG_ON_PAGE(!PageHead(page), page);
 			page_remove_rmap(page);
 			put_page(page);
 		}
@@ -1249,7 +1249,7 @@ struct page *follow_trans_huge_pmd(struc
 		goto out;
 
 	page = pmd_page(*pmd);
-	VM_BUG_ON(!PageHead(page));
+	VM_BUG_ON_PAGE(!PageHead(page), page);
 	if (flags & FOLL_TOUCH) {
 		pmd_t _pmd;
 		/*
@@ -1274,7 +1274,7 @@ struct page *follow_trans_huge_pmd(struc
 		}
 	}
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	VM_BUG_ON(!PageCompound(page));
+	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	if (flags & FOLL_GET)
 		get_page_foll(page);
 
@@ -1432,9 +1432,9 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		} else {
 			page = pmd_page(orig_pmd);
 			page_remove_rmap(page);
-			VM_BUG_ON(page_mapcount(page) < 0);
+			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-			VM_BUG_ON(!PageHead(page));
+			VM_BUG_ON_PAGE(!PageHead(page), page);
 			atomic_long_dec(&tlb->mm->nr_ptes);
 			spin_unlock(ptl);
 			tlb_remove_page(tlb, page);
@@ -2176,9 +2176,9 @@ static int __collapse_huge_page_isolate(
 		if (unlikely(!page))
 			goto out;
 
-		VM_BUG_ON(PageCompound(page));
-		BUG_ON(!PageAnon(page));
-		VM_BUG_ON(!PageSwapBacked(page));
+		VM_BUG_ON_PAGE(PageCompound(page), page);
+		VM_BUG_ON_PAGE(!PageAnon(page), page);
+		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 
 		/* cannot use mapcount: can't collapse if there's a gup pin */
 		if (page_count(page) != 1)
@@ -2201,8 +2201,8 @@ static int __collapse_huge_page_isolate(
 		}
 		/* 0 stands for page_is_file_cache(page) == false */
 		inc_zone_page_state(page, NR_ISOLATED_ANON + 0);
-		VM_BUG_ON(!PageLocked(page));
-		VM_BUG_ON(PageLRU(page));
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
+		VM_BUG_ON_PAGE(PageLRU(page), page);
 
 		/* If there is no mapped pte young don't collapse the page */
 		if (pte_young(pteval) || PageReferenced(page) ||
@@ -2232,7 +2232,7 @@ static void __collapse_huge_page_copy(pt
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
-			VM_BUG_ON(page_mapcount(src_page) != 1);
+			VM_BUG_ON_PAGE(page_mapcount(src_page) != 1, src_page);
 			release_pte_page(src_page);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
@@ -2311,7 +2311,7 @@ static struct page
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
-	VM_BUG_ON(*hpage);
+	VM_BUG_ON_PAGE(*hpage, *hpage);
 	/*
 	 * Allocate the page while the vma is still valid and under
 	 * the mmap_sem read mode so there is no memory allocation
@@ -2580,7 +2580,7 @@ static int khugepaged_scan_pmd(struct mm
 		 */
 		node = page_to_nid(page);
 		khugepaged_node_load[node]++;
-		VM_BUG_ON(PageCompound(page));
+		VM_BUG_ON_PAGE(PageCompound(page), page);
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
 			goto out_unmap;
 		/* cannot use mapcount: can't collapse if there's a gup pin */
@@ -2876,7 +2876,7 @@ again:
 		return;
 	}
 	page = pmd_page(*pmd);
-	VM_BUG_ON(!page_count(page));
+	VM_BUG_ON_PAGE(!page_count(page), page);
 	get_page(page);
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
diff -puN mm/hugetlb.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/hugetlb.c
@@ -584,7 +584,7 @@ static void update_and_free_page(struct
 				1 << PG_active | 1 << PG_reserved |
 				1 << PG_private | 1 << PG_writeback);
 	}
-	VM_BUG_ON(hugetlb_cgroup_from_page(page));
+	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	arch_release_hugepage(page);
@@ -1089,7 +1089,7 @@ retry:
 		 * no users -- drop the buddy allocator's reference.
 		 */
 		put_page_testzero(page);
-		VM_BUG_ON(page_count(page));
+		VM_BUG_ON_PAGE(page_count(page), page);
 		enqueue_huge_page(h, page);
 	}
 free:
@@ -3503,7 +3503,7 @@ int dequeue_hwpoisoned_huge_page(struct
 
 bool isolate_huge_page(struct page *page, struct list_head *list)
 {
-	VM_BUG_ON(!PageHead(page));
+	VM_BUG_ON_PAGE(!PageHead(page), page);
 	if (!get_page_unless_zero(page))
 		return false;
 	spin_lock(&hugetlb_lock);
@@ -3514,7 +3514,7 @@ bool isolate_huge_page(struct page *page
 
 void putback_active_hugepage(struct page *page)
 {
-	VM_BUG_ON(!PageHead(page));
+	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
@@ -3523,7 +3523,7 @@ void putback_active_hugepage(struct page
 
 bool is_hugepage_active(struct page *page)
 {
-	VM_BUG_ON(!PageHuge(page));
+	VM_BUG_ON_PAGE(!PageHuge(page), page);
 	/*
 	 * This function can be called for a tail page because the caller,
 	 * scan_movable_pages, scans through a given pfn-range which typically
diff -puN mm/hugetlb_cgroup.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/hugetlb_cgroup.c
@@ -390,7 +390,7 @@ void hugetlb_cgroup_migrate(struct page
 	if (hugetlb_cgroup_disabled())
 		return;
 
-	VM_BUG_ON(!PageHuge(oldhpage));
+	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
diff -puN mm/internal.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/internal.h
--- a/mm/internal.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/internal.h
@@ -27,8 +27,8 @@ static inline void set_page_count(struct
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageTail(page));
-	VM_BUG_ON(atomic_read(&page->_count));
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(atomic_read(&page->_count), page);
 	set_page_count(page, 1);
 }
 
@@ -46,7 +46,7 @@ static inline void __get_page_tail_foll(
 	 * speculative page access (like in
 	 * page_cache_get_speculative()) on tail pages.
 	 */
-	VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
+	VM_BUG_ON_PAGE(atomic_read(&page->first_page->_count) <= 0, page);
 	if (get_page_head)
 		atomic_inc(&page->first_page->_count);
 	get_huge_page_tail(page);
@@ -71,7 +71,7 @@ static inline void get_page_foll(struct
 		 * Getting a normal page or the head of a compound page
 		 * requires to already have an elevated page->_count.
 		 */
-		VM_BUG_ON(atomic_read(&page->_count) <= 0);
+		VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
 		atomic_inc(&page->_count);
 	}
 }
@@ -173,7 +173,7 @@ static inline void munlock_vma_pages_all
 static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 				    struct page *page)
 {
-	VM_BUG_ON(PageLRU(page));
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
diff -puN mm/ksm.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/ksm.c
--- a/mm/ksm.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/ksm.c
@@ -1898,13 +1898,13 @@ int rmap_walk_ksm(struct page *page, str
 	int ret = SWAP_AGAIN;
 	int search_new_forks = 0;
 
-	VM_BUG_ON(!PageKsm(page));
+	VM_BUG_ON_PAGE(!PageKsm(page), page);
 
 	/*
 	 * Rely on the page lock to protect against concurrent modifications
 	 * to that page's node of the stable tree.
 	 */
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	stable_node = page_stable_node(page);
 	if (!stable_node)
@@ -1958,13 +1958,13 @@ void ksm_migrate_page(struct page *newpa
 {
 	struct stable_node *stable_node;
 
-	VM_BUG_ON(!PageLocked(oldpage));
-	VM_BUG_ON(!PageLocked(newpage));
-	VM_BUG_ON(newpage->mapping != oldpage->mapping);
+	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
+	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
+	VM_BUG_ON_PAGE(newpage->mapping != oldpage->mapping, newpage);
 
 	stable_node = page_stable_node(newpage);
 	if (stable_node) {
-		VM_BUG_ON(stable_node->kpfn != page_to_pfn(oldpage));
+		VM_BUG_ON_PAGE(stable_node->kpfn != page_to_pfn(oldpage), oldpage);
 		stable_node->kpfn = page_to_pfn(newpage);
 		/*
 		 * newpage->mapping was set in advance; now we need smp_wmb()
diff -puN mm/memcontrol.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/memcontrol.c
--- a/mm/memcontrol.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/memcontrol.c
@@ -2897,7 +2897,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	unsigned short id;
 	swp_entry_t ent;
 
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	pc = lookup_page_cgroup(page);
 	lock_page_cgroup(pc);
@@ -2931,7 +2931,7 @@ static void __mem_cgroup_commit_charge(s
 	bool anon;
 
 	lock_page_cgroup(pc);
-	VM_BUG_ON(PageCgroupUsed(pc));
+	VM_BUG_ON_PAGE(PageCgroupUsed(pc), page);
 	/*
 	 * we don't need page_cgroup_lock about tail pages, becase they are not
 	 * accessed by any other context at this point.
@@ -2966,7 +2966,7 @@ static void __mem_cgroup_commit_charge(s
 	if (lrucare) {
 		if (was_on_lru) {
 			lruvec = mem_cgroup_zone_lruvec(zone, pc->mem_cgroup);
-			VM_BUG_ON(PageLRU(page));
+			VM_BUG_ON_PAGE(PageLRU(page), page);
 			SetPageLRU(page);
 			add_page_to_lru_list(page, lruvec, page_lru(page));
 		}
@@ -3780,7 +3780,7 @@ void __memcg_kmem_uncharge_pages(struct
 	if (!memcg)
 		return;
 
-	VM_BUG_ON(mem_cgroup_is_root(memcg));
+	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 }
 #else
@@ -3859,7 +3859,7 @@ static int mem_cgroup_move_account(struc
 	bool anon = PageAnon(page);
 
 	VM_BUG_ON(from == to);
-	VM_BUG_ON(PageLRU(page));
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 	/*
 	 * The page is isolated from LRU. So, collapse function
 	 * will not handle this page. But page splitting can happen.
@@ -3952,7 +3952,7 @@ static int mem_cgroup_move_parent(struct
 		parent = root_mem_cgroup;
 
 	if (nr_pages > 1) {
-		VM_BUG_ON(!PageTransHuge(page));
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		flags = compound_lock_irqsave(page);
 	}
 
@@ -3986,7 +3986,7 @@ static int mem_cgroup_charge_common(stru
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
-		VM_BUG_ON(!PageTransHuge(page));
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/*
 		 * Never OOM-kill a process for a huge page.  The
 		 * fault handler will fall back to regular pages.
@@ -4006,8 +4006,8 @@ int mem_cgroup_newpage_charge(struct pag
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	VM_BUG_ON(page_mapped(page));
-	VM_BUG_ON(page->mapping && !PageAnon(page));
+	VM_BUG_ON_PAGE(page_mapped(page), page);
+	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
 	VM_BUG_ON(!mm);
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
 					MEM_CGROUP_CHARGE_TYPE_ANON);
@@ -4211,7 +4211,7 @@ __mem_cgroup_uncharge_common(struct page
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
-		VM_BUG_ON(!PageTransHuge(page));
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 	}
 	/*
 	 * Check if our page_cgroup is valid
@@ -4303,7 +4303,7 @@ void mem_cgroup_uncharge_page(struct pag
 	/* early check. */
 	if (page_mapped(page))
 		return;
-	VM_BUG_ON(page->mapping && !PageAnon(page));
+	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
 	/*
 	 * If the page is in swap cache, uncharge should be deferred
 	 * to the swap path, which also properly accounts swap usage
@@ -4323,8 +4323,8 @@ void mem_cgroup_uncharge_page(struct pag
 
 void mem_cgroup_uncharge_cache_page(struct page *page)
 {
-	VM_BUG_ON(page_mapped(page));
-	VM_BUG_ON(page->mapping);
+	VM_BUG_ON_PAGE(page_mapped(page), page);
+	VM_BUG_ON_PAGE(page->mapping, page);
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -6880,7 +6880,7 @@ static enum mc_target_type get_mctgt_typ
 	enum mc_target_type ret = MC_TARGET_NONE;
 
 	page = pmd_page(pmd);
-	VM_BUG_ON(!page || !PageHead(page));
+	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
 	if (!move_anon())
 		return ret;
 	pc = lookup_page_cgroup(page);
diff -puN mm/memory.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/memory.c
--- a/mm/memory.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/memory.c
@@ -289,7 +289,7 @@ int __tlb_remove_page(struct mmu_gather
 			return 0;
 		batch = tlb->active;
 	}
-	VM_BUG_ON(batch->nr > batch->max);
+	VM_BUG_ON_PAGE(batch->nr > batch->max, page);
 
 	return batch->max - batch->nr;
 }
@@ -2702,7 +2702,7 @@ static int do_wp_page(struct mm_struct *
 					goto unwritable_page;
 				}
 			} else
-				VM_BUG_ON(!PageLocked(old_page));
+				VM_BUG_ON_PAGE(!PageLocked(old_page), old_page);
 
 			/*
 			 * Since we dropped the lock we need to revalidate
@@ -3358,7 +3358,7 @@ static int __do_fault(struct mm_struct *
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
 		lock_page(vmf.page);
 	else
-		VM_BUG_ON(!PageLocked(vmf.page));
+		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
 
 	/*
 	 * Should we do an early C-O-W break?
@@ -3395,7 +3395,7 @@ static int __do_fault(struct mm_struct *
 						goto unwritable_page;
 					}
 				} else
-					VM_BUG_ON(!PageLocked(page));
+					VM_BUG_ON_PAGE(!PageLocked(page), page);
 				page_mkwrite = 1;
 			}
 		}
diff -puN mm/migrate.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/migrate.c
--- a/mm/migrate.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/migrate.c
@@ -499,7 +499,7 @@ void migrate_page_copy(struct page *newp
 	if (PageUptodate(page))
 		SetPageUptodate(newpage);
 	if (TestClearPageActive(page)) {
-		VM_BUG_ON(PageUnevictable(page));
+		VM_BUG_ON_PAGE(PageUnevictable(page), page);
 		SetPageActive(newpage);
 	} else if (TestClearPageUnevictable(page))
 		SetPageUnevictable(newpage);
@@ -871,7 +871,7 @@ static int __unmap_and_move(struct page
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!page->mapping) {
-		VM_BUG_ON(PageAnon(page));
+		VM_BUG_ON_PAGE(PageAnon(page), page);
 		if (page_has_private(page)) {
 			try_to_free_buffers(page);
 			goto uncharge;
@@ -1618,7 +1618,7 @@ static int numamigrate_isolate_page(pg_d
 {
 	int page_lru;
 
-	VM_BUG_ON(compound_order(page) && !PageTransHuge(page));
+	VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page), page);
 
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, 1UL << compound_order(page)))
diff -puN mm/mlock.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/mlock.c
--- a/mm/mlock.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/mlock.c
@@ -279,8 +279,8 @@ static int __mlock_posix_error_return(lo
 static bool __putback_lru_fast_prepare(struct page *page, struct pagevec *pvec,
 		int *pgrescued)
 {
-	VM_BUG_ON(PageLRU(page));
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	if (page_mapcount(page) <= 1 && page_evictable(page)) {
 		pagevec_add(pvec, page);
diff -puN mm/page_alloc.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/page_alloc.c
@@ -509,12 +509,12 @@ static inline int page_is_buddy(struct p
 		return 0;
 
 	if (page_is_guard(buddy) && page_order(buddy) == order) {
-		VM_BUG_ON(page_count(buddy) != 0);
+		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
 		return 1;
 	}
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		VM_BUG_ON(page_count(buddy) != 0);
+		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
 		return 1;
 	}
 	return 0;
@@ -564,8 +564,8 @@ static inline void __free_one_page(struc
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
-	VM_BUG_ON(page_idx & ((1 << order) - 1));
-	VM_BUG_ON(bad_range(zone, page));
+	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
+	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
 	while (order < MAX_ORDER-1) {
 		buddy_idx = __find_buddy_index(page_idx, order);
@@ -827,7 +827,7 @@ static inline void expand(struct zone *z
 		area--;
 		high--;
 		size >>= 1;
-		VM_BUG_ON(bad_range(zone, &page[size]));
+		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 		if (high < debug_guardpage_minorder()) {
@@ -980,7 +980,7 @@ int move_freepages(struct zone *zone,
 
 	for (page = start_page; page <= end_page;) {
 		/* Make sure we are not inadvertently changing nodes */
-		VM_BUG_ON(page_to_nid(page) != zone_to_nid(zone));
+		VM_BUG_ON_PAGE(page_to_nid(page) != zone_to_nid(zone), page);
 
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
@@ -1429,8 +1429,8 @@ void split_page(struct page *page, unsig
 {
 	int i;
 
-	VM_BUG_ON(PageCompound(page));
-	VM_BUG_ON(!page_count(page));
+	VM_BUG_ON_PAGE(PageCompound(page), page);
+	VM_BUG_ON_PAGE(!page_count(page), page);
 
 #ifdef CONFIG_KMEMCHECK
 	/*
@@ -1577,7 +1577,7 @@ again:
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
 
-	VM_BUG_ON(bad_range(zone, page));
+	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 	if (prep_new_page(page, order, gfp_flags))
 		goto again;
 	return page;
@@ -6021,7 +6021,7 @@ void set_pageblock_flags_group(struct pa
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
-	VM_BUG_ON(!zone_spans_pfn(zone, pfn));
+	VM_BUG_ON_PAGE(!zone_spans_pfn(zone, pfn), page);
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)
@@ -6539,4 +6539,4 @@ void dump_page(struct page *page, char *
 {
 	dump_page_badflags(page, reason, 0);
 }
-
+EXPORT_SYMBOL_GPL(dump_page);
diff -puN mm/page_io.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/page_io.c
--- a/mm/page_io.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/page_io.c
@@ -320,8 +320,8 @@ int swap_readpage(struct page *page)
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(PageUptodate(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(PageUptodate(page), page);
 	if (frontswap_load(page) == 0) {
 		SetPageUptodate(page);
 		unlock_page(page);
diff -puN mm/rmap.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/rmap.c
--- a/mm/rmap.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/rmap.c
@@ -894,9 +894,9 @@ void page_move_anon_rmap(struct page *pa
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON(!anon_vma);
-	VM_BUG_ON(page->index != linear_page_index(vma, address));
+	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
@@ -995,7 +995,7 @@ void do_page_add_anon_rmap(struct page *
 	if (unlikely(PageKsm(page)))
 		return;
 
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	/* address might be in next vma when migration races vma_adjust */
 	if (first)
 		__page_set_anon_rmap(page, vma, address, exclusive);
@@ -1481,7 +1481,7 @@ int try_to_unmap(struct page *page, enum
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
-	VM_BUG_ON(!PageHuge(page) && PageTransHuge(page));
+	VM_BUG_ON_PAGE(!PageHuge(page) && PageTransHuge(page), page);
 
 	/*
 	 * During exec, a temporary VMA is setup and later moved.
@@ -1533,7 +1533,7 @@ int try_to_munlock(struct page *page)
 
 	};
 
-	VM_BUG_ON(!PageLocked(page) || PageLRU(page));
+	VM_BUG_ON_PAGE(!PageLocked(page) || PageLRU(page), page);
 
 	ret = rmap_walk(page, &rwc);
 	return ret;
diff -puN mm/shmem.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/shmem.c
--- a/mm/shmem.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/shmem.c
@@ -285,8 +285,8 @@ static int shmem_add_to_page_cache(struc
 {
 	int error;
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(!PageSwapBacked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 
 	page_cache_get(page);
 	page->mapping = mapping;
@@ -491,7 +491,7 @@ static void shmem_undo_range(struct inod
 				continue;
 			if (!unfalloc || !PageUptodate(page)) {
 				if (page->mapping == mapping) {
-					VM_BUG_ON(PageWriteback(page));
+					VM_BUG_ON_PAGE(PageWriteback(page), page);
 					truncate_inode_page(mapping, page);
 				}
 			}
@@ -568,7 +568,7 @@ static void shmem_undo_range(struct inod
 			lock_page(page);
 			if (!unfalloc || !PageUptodate(page)) {
 				if (page->mapping == mapping) {
-					VM_BUG_ON(PageWriteback(page));
+					VM_BUG_ON_PAGE(PageWriteback(page), page);
 					truncate_inode_page(mapping, page);
 				}
 			}
diff -puN mm/slub.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/slub.c
--- a/mm/slub.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/slub.c
@@ -1559,7 +1559,7 @@ static inline void *acquire_slab(struct
 		new.freelist = freelist;
 	}
 
-	VM_BUG_ON(new.frozen);
+	VM_BUG_ON_PAGE(new.frozen, &new);
 	new.frozen = 1;
 
 	if (!__cmpxchg_double_slab(s, page,
@@ -1812,7 +1812,7 @@ static void deactivate_slab(struct kmem_
 			set_freepointer(s, freelist, prior);
 			new.counters = counters;
 			new.inuse--;
-			VM_BUG_ON(!new.frozen);
+			VM_BUG_ON_PAGE(!new.frozen, &new);
 
 		} while (!__cmpxchg_double_slab(s, page,
 			prior, counters,
@@ -1840,7 +1840,7 @@ redo:
 
 	old.freelist = page->freelist;
 	old.counters = page->counters;
-	VM_BUG_ON(!old.frozen);
+	VM_BUG_ON_PAGE(!old.frozen, &old);
 
 	/* Determine target state of the slab */
 	new.counters = old.counters;
@@ -1952,7 +1952,7 @@ static void unfreeze_partials(struct kme
 
 			old.freelist = page->freelist;
 			old.counters = page->counters;
-			VM_BUG_ON(!old.frozen);
+			VM_BUG_ON_PAGE(!old.frozen, &old);
 
 			new.counters = old.counters;
 			new.freelist = old.freelist;
@@ -2225,7 +2225,7 @@ static inline void *get_freelist(struct
 		counters = page->counters;
 
 		new.counters = counters;
-		VM_BUG_ON(!new.frozen);
+		VM_BUG_ON_PAGE(!new.frozen, &new);
 
 		new.inuse = page->objects;
 		new.frozen = freelist != NULL;
@@ -2319,7 +2319,7 @@ load_freelist:
 	 * page is pointing to the page from which the objects are obtained.
 	 * That page must be frozen for per cpu allocations to work.
 	 */
-	VM_BUG_ON(!c->page->frozen);
+	VM_BUG_ON_PAGE(!c->page->frozen, c->page);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);
diff -puN mm/swap.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/swap.c
--- a/mm/swap.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/swap.c
@@ -57,7 +57,7 @@ static void __page_cache_release(struct
 
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, zone);
-		VM_BUG_ON(!PageLRU(page));
+		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -130,8 +130,8 @@ static void put_compound_page(struct pag
 			 * __split_huge_page_refcount cannot race
 			 * here.
 			 */
-			VM_BUG_ON(!PageHead(page_head));
-			VM_BUG_ON(page_mapcount(page) != 0);
+			VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
+			VM_BUG_ON_PAGE(page_mapcount(page) != 0, page);
 			if (put_page_testzero(page_head)) {
 				/*
 				 * If this is the tail of a slab
@@ -148,7 +148,7 @@ static void put_compound_page(struct pag
 				 * the compound page enters the buddy
 				 * allocator.
 				 */
-				VM_BUG_ON(PageSlab(page_head));
+				VM_BUG_ON_PAGE(PageSlab(page_head), page_head);
 				__put_compound_page(page_head);
 			}
 			return;
@@ -199,7 +199,7 @@ out_put_single:
 				__put_single_page(page);
 			return;
 		}
-		VM_BUG_ON(page_head != page->first_page);
+		VM_BUG_ON_PAGE(page_head != page->first_page, page);
 		/*
 		 * We can release the refcount taken by
 		 * get_page_unless_zero() now that
@@ -207,12 +207,12 @@ out_put_single:
 		 * compound_lock.
 		 */
 		if (put_page_testzero(page_head))
-			VM_BUG_ON(1);
+			VM_BUG_ON_PAGE(1, page_head);
 		/* __split_huge_page_refcount will wait now */
-		VM_BUG_ON(page_mapcount(page) <= 0);
+		VM_BUG_ON_PAGE(page_mapcount(page) <= 0, page);
 		atomic_dec(&page->_mapcount);
-		VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
-		VM_BUG_ON(atomic_read(&page->_count) != 0);
+		VM_BUG_ON_PAGE(atomic_read(&page_head->_count) <= 0, page_head);
+		VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
 		compound_unlock_irqrestore(page_head, flags);
 
 		if (put_page_testzero(page_head)) {
@@ -223,7 +223,7 @@ out_put_single:
 		}
 	} else {
 		/* page_head is a dangling pointer */
-		VM_BUG_ON(PageTail(page));
+		VM_BUG_ON_PAGE(PageTail(page), page);
 		goto out_put_single;
 	}
 }
@@ -264,7 +264,7 @@ bool __get_page_tail(struct page *page)
 			 * page. __split_huge_page_refcount
 			 * cannot race here.
 			 */
-			VM_BUG_ON(!PageHead(page_head));
+			VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
 			__get_page_tail_foll(page, true);
 			return true;
 		} else {
@@ -604,8 +604,8 @@ EXPORT_SYMBOL(__lru_cache_add);
  */
 void lru_cache_add(struct page *page)
 {
-	VM_BUG_ON(PageActive(page) && PageUnevictable(page));
-	VM_BUG_ON(PageLRU(page));
+	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 	__lru_cache_add(page);
 }
 
@@ -846,7 +846,7 @@ void release_pages(struct page **pages,
 			}
 
 			lruvec = mem_cgroup_page_lruvec(page, zone);
-			VM_BUG_ON(!PageLRU(page));
+			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
@@ -888,9 +888,9 @@ void lru_add_page_tail(struct page *page
 {
 	const int file = 0;
 
-	VM_BUG_ON(!PageHead(page));
-	VM_BUG_ON(PageCompound(page_tail));
-	VM_BUG_ON(PageLRU(page_tail));
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
+	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
 	VM_BUG_ON(NR_CPUS != 1 &&
 		  !spin_is_locked(&lruvec_zone(lruvec)->lru_lock));
 
@@ -929,7 +929,7 @@ static void __pagevec_lru_add_fn(struct
 	int active = PageActive(page);
 	enum lru_list lru = page_lru(page);
 
-	VM_BUG_ON(PageLRU(page));
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, lru);
diff -puN mm/swap_state.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/swap_state.c
--- a/mm/swap_state.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/swap_state.c
@@ -83,9 +83,9 @@ int __add_to_swap_cache(struct page *pag
 	int error;
 	struct address_space *address_space;
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(PageSwapCache(page));
-	VM_BUG_ON(!PageSwapBacked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(PageSwapCache(page), page);
+	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 
 	page_cache_get(page);
 	SetPageSwapCache(page);
@@ -139,9 +139,9 @@ void __delete_from_swap_cache(struct pag
 	swp_entry_t entry;
 	struct address_space *address_space;
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(!PageSwapCache(page));
-	VM_BUG_ON(PageWriteback(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+	VM_BUG_ON_PAGE(PageWriteback(page), page);
 
 	entry.val = page_private(page);
 	address_space = swap_address_space(entry);
@@ -165,8 +165,8 @@ int add_to_swap(struct page *page, struc
 	swp_entry_t entry;
 	int err;
 
-	VM_BUG_ON(!PageLocked(page));
-	VM_BUG_ON(!PageUptodate(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageUptodate(page), page);
 
 	entry = get_swap_page();
 	if (!entry.val)
diff -puN mm/swapfile.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/swapfile.c
--- a/mm/swapfile.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/swapfile.c
@@ -906,7 +906,7 @@ int reuse_swap_page(struct page *page)
 {
 	int count;
 
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	if (unlikely(PageKsm(page)))
 		return 0;
 	count = page_mapcount(page);
@@ -926,7 +926,7 @@ int reuse_swap_page(struct page *page)
  */
 int try_to_free_swap(struct page *page)
 {
-	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	if (!PageSwapCache(page))
 		return 0;
@@ -2714,7 +2714,7 @@ struct swap_info_struct *page_swap_info(
  */
 struct address_space *__page_file_mapping(struct page *page)
 {
-	VM_BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	return page_swap_info(page)->swap_file->f_mapping;
 }
 EXPORT_SYMBOL_GPL(__page_file_mapping);
@@ -2722,7 +2722,7 @@ EXPORT_SYMBOL_GPL(__page_file_mapping);
 pgoff_t __page_file_index(struct page *page)
 {
 	swp_entry_t swap = { .val = page_private(page) };
-	VM_BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	return swp_offset(swap);
 }
 EXPORT_SYMBOL_GPL(__page_file_index);
diff -puN mm/vmscan.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page mm/vmscan.c
--- a/mm/vmscan.c~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page
+++ a/mm/vmscan.c
@@ -603,7 +603,7 @@ void putback_lru_page(struct page *page)
 	bool is_unevictable;
 	int was_unevictable = PageUnevictable(page);
 
-	VM_BUG_ON(PageLRU(page));
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 
 redo:
 	ClearPageUnevictable(page);
@@ -794,8 +794,8 @@ static unsigned long shrink_page_list(st
 		if (!trylock_page(page))
 			goto keep;
 
-		VM_BUG_ON(PageActive(page));
-		VM_BUG_ON(page_zone(page) != zone);
+		VM_BUG_ON_PAGE(PageActive(page), page);
+		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
 
 		sc->nr_scanned++;
 
@@ -1079,14 +1079,14 @@ activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (PageSwapCache(page) && vm_swap_full())
 			try_to_free_swap(page);
-		VM_BUG_ON(PageActive(page));
+		VM_BUG_ON_PAGE(PageActive(page), page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
 		unlock_page(page);
 keep:
 		list_add(&page->lru, &ret_pages);
-		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
+		VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page), page);
 	}
 
 	free_hot_cold_page_list(&free_pages, 1);
@@ -1240,7 +1240,7 @@ static unsigned long isolate_lru_pages(u
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
 
-		VM_BUG_ON(!PageLRU(page));
+		VM_BUG_ON_PAGE(!PageLRU(page), page);
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
@@ -1295,7 +1295,7 @@ int isolate_lru_page(struct page *page)
 {
 	int ret = -EBUSY;
 
-	VM_BUG_ON(!page_count(page));
+	VM_BUG_ON_PAGE(!page_count(page), page);
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
@@ -1366,7 +1366,7 @@ putback_inactive_pages(struct lruvec *lr
 		struct page *page = lru_to_page(page_list);
 		int lru;
 
-		VM_BUG_ON(PageLRU(page));
+		VM_BUG_ON_PAGE(PageLRU(page), page);
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1586,7 +1586,7 @@ static void move_active_pages_to_lru(str
 		page = lru_to_page(list);
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
-		VM_BUG_ON(PageLRU(page));
+		VM_BUG_ON_PAGE(PageLRU(page), page);
 		SetPageLRU(page);
 
 		nr_pages = hpage_nr_pages(page);
@@ -3701,7 +3701,7 @@ void check_move_unevictable_pages(struct
 		if (page_evictable(page)) {
 			enum lru_list lru = page_lru_base_type(page);
 
-			VM_BUG_ON(PageActive(page));
+			VM_BUG_ON_PAGE(PageActive(page), page);
 			ClearPageUnevictable(page);
 			del_page_from_lru_list(page, lruvec, LRU_UNEVICTABLE);
 			add_page_to_lru_list(page, lruvec, lru);
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
linux-next.patch

