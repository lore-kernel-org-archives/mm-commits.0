From: akpm@linux-foundation.org
Subject: + swap-cull-unevictable-pages-in-fault-path.patch added to -mm tree
Date: Wed, 11 Jun 2008 13:00:08 -0700
Message-ID: <200806112000.m5BK08mb015258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756713AbYFKUAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     swap: cull unevictable pages in fault path
has been added to the -mm tree.  Its filename is
     swap-cull-unevictable-pages-in-fault-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap: cull unevictable pages in fault path
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

In the fault paths that install new anonymous pages, check whether the
page is evictable or not using lru_cache_add_active_or_unevictable().  If
the page is evictable, just add it to the active lru list [via the pagevec
cache], else add it to the unevictable list.

This "proactive" culling in the fault path mimics the handling of mlocked
pages in Nick Piggin's series to keep mlocked pages off the lru lists.

Notes:

1) This patch is optional--e.g., if one is concerned about the
   additional test in the fault path.  We can defer the moving of
   nonreclaimable pages until when vmscan [shrink_*_list()]
   encounters them.  Vmscan will only need to handle such pages
   once, but if there are a lot of them it could impact system
   performance.

2) The 'vma' argument to page_evictable() is require to notice that
   we're faulting a page into an mlock()ed vma w/o having to scan the
   page's rmap in the fault path.   Culling mlock()ed anon pages is
   currently the only reason for this patch.

3) We can't cull swap pages in read_swap_cache_async() because the
   vma argument doesn't necessarily correspond to the swap cache
   offset passed in by swapin_readahead().  This could [did!] result
   in mlocking pages in non-VM_LOCKED vmas if [when] we tried to
   cull in this path.

4) Move set_pte_at() to after where we add page to lru to keep it
   hidden from other tasks that might walk the page table.
   We already do it in this order in do_anonymous() page.  And,
   these are COW'd anon pages.  Is this safe?

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 ++
 mm/memory.c          |   20 ++++++++++++--------
 mm/swap.c            |   21 +++++++++++++++++++++
 3 files changed, 35 insertions(+), 8 deletions(-)

diff -puN include/linux/swap.h~swap-cull-unevictable-pages-in-fault-path include/linux/swap.h
--- a/include/linux/swap.h~swap-cull-unevictable-pages-in-fault-path
+++ a/include/linux/swap.h
@@ -173,6 +173,8 @@ extern unsigned int nr_free_pagecache_pa
 /* linux/mm/swap.c */
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
+extern void lru_cache_add_active_or_unevictable(struct page *,
+					struct vm_area_struct *);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
diff -puN mm/memory.c~swap-cull-unevictable-pages-in-fault-path mm/memory.c
--- a/mm/memory.c~swap-cull-unevictable-pages-in-fault-path
+++ a/mm/memory.c
@@ -1813,12 +1813,15 @@ gotten:
 		 * thread doing COW.
 		 */
 		ptep_clear_flush(vma, address, page_table);
-		set_pte_at(mm, address, page_table, entry);
-		update_mmu_cache(vma, address, entry);
+
 		SetPageSwapBacked(new_page);
-		lru_cache_add_active_anon(new_page);
+		lru_cache_add_active_or_unevictable(new_page, vma);
 		page_add_new_anon_rmap(new_page, vma, address);
 
+//TODO:  is this safe?  do_anonymous_page() does it this way.
+		set_pte_at(mm, address, page_table, entry);
+		update_mmu_cache(vma, address, entry);
+
 		/* Free the old page.. */
 		new_page = old_page;
 		ret |= VM_FAULT_WRITE;
@@ -2285,7 +2288,7 @@ static int do_anonymous_page(struct mm_s
 		goto release;
 	inc_mm_counter(mm, anon_rss);
 	SetPageSwapBacked(page);
-	lru_cache_add_active_anon(page);
+	lru_cache_add_active_or_unevictable(page, vma);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
 
@@ -2429,12 +2432,11 @@ static int __do_fault(struct mm_struct *
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
-                        inc_mm_counter(mm, anon_rss);
+			inc_mm_counter(mm, anon_rss);
 			SetPageSwapBacked(page);
-                        lru_cache_add_active_anon(page);
-                        page_add_new_anon_rmap(page, vma, address);
+			lru_cache_add_active_or_unevictable(page, vma);
+			page_add_new_anon_rmap(page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(page);
@@ -2443,6 +2445,8 @@ static int __do_fault(struct mm_struct *
 				get_page(dirty_page);
 			}
 		}
+//TODO:  is this safe?  do_anonymous_page() does it this way.
+		set_pte_at(mm, address, page_table, entry);
 
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, entry);
diff -puN mm/swap.c~swap-cull-unevictable-pages-in-fault-path mm/swap.c
--- a/mm/swap.c~swap-cull-unevictable-pages-in-fault-path
+++ a/mm/swap.c
@@ -31,6 +31,8 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 
+#include "internal.h"
+
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
@@ -244,6 +246,25 @@ void add_page_to_unevictable_list(struct
 	spin_unlock_irq(&zone->lru_lock);
 }
 
+/**
+ * lru_cache_add_active_or_unevictable
+ * @page:  the page to be added to LRU
+ * @vma:   vma in which page is mapped for determining reclaimability
+ *
+ * place @page on active or unevictable LRU list, depending on
+ * page_evictable().  Note that if the page is not evictable,
+ * it goes directly back onto it's zone's unevictable list.  It does
+ * NOT use a per cpu pagevec.
+ */
+void lru_cache_add_active_or_unevictable(struct page *page,
+					struct vm_area_struct *vma)
+{
+	if (page_evictable(page, vma))
+		lru_cache_add_lru(page, page_lru(page));
+	else
+		add_page_to_unevictable_list(page);
+}
+
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch

