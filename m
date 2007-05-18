From: akpm@linux-foundation.org
Subject: - mm-more-rmap-checking.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:48 -0700
Message-ID: <200705180706.l4I76lpA010210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46387 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758303AbXERHIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: more rmap checking
has been removed from the -mm tree.  Its filename was
     mm-more-rmap-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: more rmap checking
From: Nick Piggin <npiggin@suse.de>

Re-introduce rmap verification patches that Hugh removed when he removed
PG_map_lock. PG_map_lock actually isn't needed to synchronise access to
anonymous pages, because PG_locked and PTL together already do.

These checks were important in discovering and fixing a rare rmap corruption
in SLES9.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   13 +++------
 mm/memory.c          |    2 -
 mm/rmap.c            |   58 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 11 deletions(-)

diff -puN include/linux/rmap.h~mm-more-rmap-checking include/linux/rmap.h
--- a/include/linux/rmap.h~mm-more-rmap-checking
+++ a/include/linux/rmap.h
@@ -74,17 +74,14 @@ void page_add_new_anon_rmap(struct page 
 void page_add_file_rmap(struct page *);
 void page_remove_rmap(struct page *, struct vm_area_struct *);
 
-/**
- * page_dup_rmap - duplicate pte mapping to a page
- * @page:	the page to add the mapping to
- *
- * For copy_page_range only: minimal extract from page_add_rmap,
- * avoiding unnecessary tests (already checked) so it's quicker.
- */
-static inline void page_dup_rmap(struct page *page)
+#ifdef CONFIG_DEBUG_VM
+void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
+#else
+static inline void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
 {
 	atomic_inc(&page->_mapcount);
 }
+#endif
 
 /*
  * Called from mm/vmscan.c to handle paging out
diff -puN mm/memory.c~mm-more-rmap-checking mm/memory.c
--- a/mm/memory.c~mm-more-rmap-checking
+++ a/mm/memory.c
@@ -481,7 +481,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
 		get_page(page);
-		page_dup_rmap(page);
+		page_dup_rmap(page, vma, addr);
 		rss[!!PageAnon(page)]++;
 	}
 
diff -puN mm/rmap.c~mm-more-rmap-checking mm/rmap.c
--- a/mm/rmap.c~mm-more-rmap-checking
+++ a/mm/rmap.c
@@ -530,19 +530,51 @@ static void __page_set_anon_rmap(struct 
 }
 
 /**
+ * page_set_anon_rmap - sanity check anonymous rmap addition
+ * @page:	the page to add the mapping to
+ * @vma:	the vm area in which the mapping is added
+ * @address:	the user virtual address mapped
+ */
+static void __page_check_anon_rmap(struct page *page,
+	struct vm_area_struct *vma, unsigned long address)
+{
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * The page's anon-rmap details (mapping and index) are guaranteed to
+	 * be set up correctly at this point.
+	 *
+	 * We have exclusion against page_add_anon_rmap because the caller
+	 * always holds the page locked, except if called from page_dup_rmap,
+	 * in which case the page is already known to be setup.
+	 *
+	 * We have exclusion against page_add_new_anon_rmap because those pages
+	 * are initially only visible via the pagetables, and the pte is locked
+	 * over the call to page_add_new_anon_rmap.
+	 */
+	struct anon_vma *anon_vma = vma->anon_vma;
+	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
+	BUG_ON(page->mapping != (struct address_space *)anon_vma);
+	BUG_ON(page->index != linear_page_index(vma, address));
+#endif
+}
+
+/**
  * page_add_anon_rmap - add pte mapping to an anonymous page
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  *
- * The caller needs to hold the pte lock.
+ * The caller needs to hold the pte lock and the page must be locked.
  */
 void page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (atomic_inc_and_test(&page->_mapcount))
 		__page_set_anon_rmap(page, vma, address);
-	/* else checking page index and mapping is racy */
+	else
+		__page_check_anon_rmap(page, vma, address);
 }
 
 /*
@@ -553,10 +585,12 @@ void page_add_anon_rmap(struct page *pag
  *
  * Same as page_add_anon_rmap but must only be called on *new* pages.
  * This means the inc-and-test can be bypassed.
+ * Page does not have to be locked.
  */
 void page_add_new_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
+	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	atomic_set(&page->_mapcount, 0); /* elevate count by 1 (starts at -1) */
 	__page_set_anon_rmap(page, vma, address);
 }
@@ -573,6 +607,26 @@ void page_add_file_rmap(struct page *pag
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 }
 
+#ifdef CONFIG_DEBUG_VM
+/**
+ * page_dup_rmap - duplicate pte mapping to a page
+ * @page:	the page to add the mapping to
+ *
+ * For copy_page_range only: minimal extract from page_add_file_rmap /
+ * page_add_anon_rmap, avoiding unnecessary tests (already checked) so it's
+ * quicker.
+ *
+ * The caller needs to hold the pte lock.
+ */
+void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
+{
+	BUG_ON(page_mapcount(page) == 0);
+	if (PageAnon(page))
+		__page_check_anon_rmap(page, vma, address);
+	atomic_inc(&page->_mapcount);
+}
+#endif
+
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
