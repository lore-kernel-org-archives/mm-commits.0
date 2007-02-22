From: akpm@linux-foundation.org
Subject: + mm-more-rmap-checking.patch added to -mm tree
Date: Wed, 21 Feb 2007 20:19:10 -0800
Message-ID: <200702220419.l1M4JARe004249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36408 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbXBVETS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 23:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hugh@veritas.com


The patch titled
     mm: more rmap checking
has been added to the -mm tree.  Its filename is
     mm-more-rmap-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/linux/rmap.h |   13 ---------
 mm/memory.c          |    2 -
 mm/rmap.c            |   54 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 15 deletions(-)

diff -puN include/linux/rmap.h~mm-more-rmap-checking include/linux/rmap.h
--- a/include/linux/rmap.h~mm-more-rmap-checking
+++ a/include/linux/rmap.h
@@ -72,20 +72,9 @@ void __anon_vma_link(struct vm_area_stru
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
+void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
 void page_remove_rmap(struct page *, struct vm_area_struct *);
 
-/**
- * page_dup_rmap - duplicate pte mapping to a page
- * @page:	the page to add the mapping to
- *
- * For copy_page_range only: minimal extract from page_add_rmap,
- * avoiding unnecessary tests (already checked) so it's quicker.
- */
-static inline void page_dup_rmap(struct page *page)
-{
-	atomic_inc(&page->_mapcount);
-}
-
 /*
  * Called from mm/vmscan.c to handle paging out
  */
diff -puN mm/memory.c~mm-more-rmap-checking mm/memory.c
--- a/mm/memory.c~mm-more-rmap-checking
+++ a/mm/memory.c
@@ -482,7 +482,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
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
@@ -522,19 +522,49 @@ static void __page_set_anon_rmap(struct 
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
+	BUG_ON(!PageLocked(page));
+	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (atomic_inc_and_test(&page->_mapcount))
 		__page_set_anon_rmap(page, vma, address);
-	/* else checking page index and mapping is racy */
+	else
+		__page_check_anon_rmap(page, vma, address);
 }
 
 /*
@@ -545,10 +575,12 @@ void page_add_anon_rmap(struct page *pag
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
@@ -566,6 +598,24 @@ void page_add_file_rmap(struct page *pag
 }
 
 /**
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
+
+/**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
  *
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
