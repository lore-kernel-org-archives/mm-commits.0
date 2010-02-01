From: akpm@linux-foundation.org
Subject: + rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:29:11 -0800
Message-ID: <201002012229.o11MTBgd016441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265Ab0BAWaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, minchan.kim@gmail.com


The patch titled
     rmap: move exclusively owned pages to own anon_vma in do_wp_page()
has been added to the -mm tree.  Its filename is
     rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2180,6 +2180,13 @@ static int do_wp_page(struct mm_struct *
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

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
mm-remove-vm_lock_rmap-code.patch

