From: akpm@linux-foundation.org
Subject: - mm-more-rmap-checking-tidy.patch removed from -mm tree
Date: Tue, 15 May 2007 23:03:38 -0700
Message-ID: <200705160603.l4G63ceM027485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678AbXEPGGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 02:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm-more-rmap-checking tidy
has been removed from the -mm tree.  Its filename was
     mm-more-rmap-checking-tidy.patch

This patch was dropped because it was folded into mm-more-rmap-checking.patch

------------------------------------------------------
Subject: mm-more-rmap-checking tidy
From: Nick Piggin <npiggin@suse.de>

I've moved the bugchecks under CONFIG_DEBUG_VM.

Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   10 +++++++++-
 mm/rmap.c            |    8 ++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN include/linux/rmap.h~mm-more-rmap-checking-tidy include/linux/rmap.h
--- a/include/linux/rmap.h~mm-more-rmap-checking-tidy
+++ a/include/linux/rmap.h
@@ -72,9 +72,17 @@ void __anon_vma_link(struct vm_area_stru
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
-void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
 void page_remove_rmap(struct page *, struct vm_area_struct *);
 
+#ifdef CONFIG_DEBUG_VM
+void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
+#else
+static inline void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
+{
+	atomic_inc(&page->_mapcount);
+}
+#endif
+
 /*
  * Called from mm/vmscan.c to handle paging out
  */
diff -puN mm/rmap.c~mm-more-rmap-checking-tidy mm/rmap.c
--- a/mm/rmap.c~mm-more-rmap-checking-tidy
+++ a/mm/rmap.c
@@ -538,6 +538,7 @@ static void __page_set_anon_rmap(struct 
 static void __page_check_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
+#ifdef CONFIG_DEBUG_VM
 	/*
 	 * The page's anon-rmap details (mapping and index) are guaranteed to
 	 * be set up correctly at this point.
@@ -554,6 +555,7 @@ static void __page_check_anon_rmap(struc
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	BUG_ON(page->mapping != (struct address_space *)anon_vma);
 	BUG_ON(page->index != linear_page_index(vma, address));
+#endif
 }
 
 /**
@@ -567,8 +569,8 @@ static void __page_check_anon_rmap(struc
 void page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	BUG_ON(!PageLocked(page));
-	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (atomic_inc_and_test(&page->_mapcount))
 		__page_set_anon_rmap(page, vma, address);
 	else
@@ -605,6 +607,7 @@ void page_add_file_rmap(struct page *pag
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 }
 
+#ifdef CONFIG_DEBUG_VM
 /**
  * page_dup_rmap - duplicate pte mapping to a page
  * @page:	the page to add the mapping to
@@ -622,6 +625,7 @@ void page_dup_rmap(struct page *page, st
 		__page_check_anon_rmap(page, vma, address);
 	atomic_inc(&page->_mapcount);
 }
+#endif
 
 /**
  * page_remove_rmap - take down pte mapping from a page
_

Patches currently in -mm which might be from npiggin@suse.de are

slob-implement-rcu-freeing.patch
mm-more-rmap-checking.patch
mm-more-rmap-checking-tidy.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
