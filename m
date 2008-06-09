From: akpm@linux-foundation.org
Subject: + vmscan-cull-non-reclaimable-pages-in-fault-path.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:47 -0700
Message-ID: <200806090618.m596IlSI006652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbYFIGTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: cull non-reclaimable pages in fault path
has been added to the -mm tree.  Its filename is
     vmscan-cull-non-reclaimable-pages-in-fault-path.patch

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
Subject: vmscan: cull non-reclaimable pages in fault path
From: Lee Schermerhorn <lee.schermerhorn@hp.com>


Against:  2.6.26-rc2-mm1

V2 -> V3:
+ rebase to 23-mm1 atop RvR's split lru series.

V1 -> V2:
+  no changes

"Optional" part of "noreclaim infrastructure"

In the fault paths that install new anonymous pages, check whether
the page is reclaimable or not using lru_cache_add_active_or_noreclaim().
If the page is reclaimable, just add it to the active lru list [via
the pagevec cache], else add it to the noreclaim list.

This "proactive" culling in the fault path mimics the handling of
mlocked pages in Nick Piggin's series to keep mlocked pages off
the lru lists.

Notes:

1) This patch is optional--e.g., if one is concerned about the
   additional test in the fault path.  We can defer the moving of
   nonreclaimable pages until when vmscan [shrink_*_list()]
   encounters them.  Vmscan will only need to handle such pages
   once.

2) The 'vma' argument to page_reclaimable() is require to notice that
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

Index: linux-2.6.26-rc2-mm1/mm/memory.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 ++
 mm/memory.c          |   20 ++++++++++++--------
 mm/swap.c            |   21 +++++++++++++++++++++
 3 files changed, 35 insertions(+), 8 deletions(-)

diff -puN include/linux/swap.h~cull-non-reclaimable-pages-in-fault-path include/linux/swap.h
--- a/include/linux/swap.h~cull-non-reclaimable-pages-in-fault-path
+++ a/include/linux/swap.h
@@ -173,6 +173,8 @@ extern unsigned int nr_free_pagecache_pa
 /* linux/mm/swap.c */
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
+extern void lru_cache_add_active_or_noreclaim(struct page *,
+					struct vm_area_struct *);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
diff -puN mm/memory.c~cull-non-reclaimable-pages-in-fault-path mm/memory.c
--- a/mm/memory.c~cull-non-reclaimable-pages-in-fault-path
+++ a/mm/memory.c
@@ -1792,12 +1792,15 @@ gotten:
 		 * thread doing COW.
 		 */
 		ptep_clear_flush(vma, address, page_table);
-		set_pte_at(mm, address, page_table, entry);
-		update_mmu_cache(vma, address, entry);
+
 		SetPageSwapBacked(new_page);
-		lru_cache_add_active_anon(new_page);
+		lru_cache_add_active_or_noreclaim(new_page, vma);
 		page_add_new_anon_rmap(new_page, vma, address);
 
+//TODO:  is this safe?  do_anonymous_page() does it this way.
+		set_pte_at(mm, address, page_table, entry);
+		update_mmu_cache(vma, address, entry);
+
 		/* Free the old page.. */
 		new_page = old_page;
 		ret |= VM_FAULT_WRITE;
@@ -2264,7 +2267,7 @@ static int do_anonymous_page(struct mm_s
 		goto release;
 	inc_mm_counter(mm, anon_rss);
 	SetPageSwapBacked(page);
-	lru_cache_add_active_anon(page);
+	lru_cache_add_active_or_noreclaim(page, vma);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
 
@@ -2408,12 +2411,11 @@ static int __do_fault(struct mm_struct *
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
+			lru_cache_add_active_or_noreclaim(page, vma);
+			page_add_new_anon_rmap(page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(page);
@@ -2422,6 +2424,8 @@ static int __do_fault(struct mm_struct *
 				get_page(dirty_page);
 			}
 		}
+//TODO:  is this safe?  do_anonymous_page() does it this way.
+		set_pte_at(mm, address, page_table, entry);
 
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, entry);
diff -puN mm/swap.c~cull-non-reclaimable-pages-in-fault-path mm/swap.c
--- a/mm/swap.c~cull-non-reclaimable-pages-in-fault-path
+++ a/mm/swap.c
@@ -31,6 +31,8 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 
+#include "internal.h"
+
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
@@ -273,6 +275,25 @@ void add_page_to_noreclaim_list(struct p
 	spin_unlock_irq(&zone->lru_lock);
 }
 
+/**
+ * lru_cache_add_active_or_noreclaim
+ * @page:  the page to be added to LRU
+ * @vma:   vma in which page is mapped for determining reclaimability
+ *
+ * place @page on active or noreclaim LRU list, depending on
+ * page_reclaimable().  Note that if the page is not reclaimable,
+ * it goes directly back onto it's zone's noreclaim list.  It does
+ * NOT use a per cpu pagevec.
+ */
+void lru_cache_add_active_or_noreclaim(struct page *page,
+					struct vm_area_struct *vma)
+{
+	if (page_reclaimable(page, vma))
+		lru_cache_add_lru(page, LRU_ACTIVE + page_file_cache(page));
+	else
+		add_page_to_noreclaim_list(page);
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
vmscan-define-page_file_cache-function.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

