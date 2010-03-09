From: akpm@linux-foundation.org
Subject: [merged] rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:13 -0800
Message-ID: <201003091904.o29J4DHT031029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633Ab0CITEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, minchan.kim@gmail.com, mm-commits@vger.


The patch titled
     rmap: move exclusively owned pages to own anon_vma in do_wp_page()
has been removed from the -mm tree.  Its filename was
     rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: move exclusively owned pages to own anon_vma in do_wp_page()
From: Rik van Riel <riel@redhat.com>

When the parent process breaks the COW on a page, both the original which
is mapped at child and the new page which is mapped parent end up in that
same anon_vma.  Generally this won't be a problem, but for some workloads
it could preserve the O(N) rmap scanning complexity.

A simple fix is to ensure that, when a page which is mapped child gets
reused in do_wp_page, because we already are the exclusive owner, the page
gets moved to our own exclusive child's anon_vma.  

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 +
 mm/memory.c          |    7 +++++++
 mm/rmap.c            |   24 ++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff -puN include/linux/rmap.h~rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page
+++ a/include/linux/rmap.h
@@ -125,6 +125,7 @@ static inline void anon_vma_merge(struct
 /*
  * rmap interfaces called when adding or removing pte of page
  */
+void page_move_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
diff -puN mm/memory.c~rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page mm/memory.c
--- a/mm/memory.c~rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page
+++ a/mm/memory.c
@@ -2138,6 +2138,13 @@ static int do_wp_page(struct mm_struct *
 			page_cache_release(old_page);
 		}
 		reuse = reuse_swap_page(old_page);
+		if (reuse)
+			/*
+			 * The page is all ours.  Move it to our anon_vma so
+			 * the rmap code will not search our parent or siblings.
+			 * Protected against the rmap code by the page lock.
+			 */
+			page_move_anon_rmap(old_page, vma, address);
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
diff -puN mm/rmap.c~rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page mm/rmap.c
--- a/mm/rmap.c~rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page
+++ a/mm/rmap.c
@@ -716,6 +716,30 @@ int page_mkclean(struct page *page)
 EXPORT_SYMBOL_GPL(page_mkclean);
 
 /**
+ * page_move_anon_rmap - move a page to our anon_vma
+ * @page:	the page to move to our anon_vma
+ * @vma:	the vma the page belongs to
+ * @address:	the user virtual address mapped
+ *
+ * When a page belongs exclusively to one process after a COW event,
+ * that page can be moved into the anon_vma that belongs to just that
+ * process, so the rmap code will not search the parent or sibling
+ * processes.
+ */
+void page_move_anon_rmap(struct page *page,
+	struct vm_area_struct *vma, unsigned long address)
+{
+	struct anon_vma *anon_vma = vma->anon_vma;
+
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!anon_vma);
+	VM_BUG_ON(page->index != linear_page_index(vma, address));
+
+	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
+	page->mapping = (struct address_space *) anon_vma;
+}
+
+/**
  * __page_set_anon_rmap - setup new anonymous rmap
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
_

Patches currently in -mm which might be from riel@redhat.com are

fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch

