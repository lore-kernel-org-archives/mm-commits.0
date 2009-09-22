From: akpm@linux-foundation.org
Subject: [merged] ksm-no-debug-in-page_dup_rmap.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:20 -0700
Message-ID: <200909222039.n8MKdKa2003209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZIVUkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.s


The patch titled
     ksm: no debug in page_dup_rmap()
has been removed from the -mm tree.  Its filename was
     ksm-no-debug-in-page_dup_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: no debug in page_dup_rmap()
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

page_dup_rmap(), used on each mapped page when forking, was originally
just an inline atomic_inc of mapcount.  2.6.22 added CONFIG_DEBUG_VM
out-of-line checks to it, which would need to be ever-so-slightly
complicated to allow for the PageKsm() we're about to define.

But I think these checks never caught anything.  And if it's coding errors
we're worried about, such checks should be in page_remove_rmap() too, not
just when forking; whereas if it's pagetable corruption we're worried
about, then they shouldn't be limited to CONFIG_DEBUG_VM.

Oh, just revert page_dup_rmap() to an inline atomic_inc of mapcount.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    6 +-----
 mm/memory.c          |    2 +-
 mm/rmap.c            |   21 ---------------------
 3 files changed, 2 insertions(+), 27 deletions(-)

diff -puN include/linux/rmap.h~ksm-no-debug-in-page_dup_rmap include/linux/rmap.h
--- a/include/linux/rmap.h~ksm-no-debug-in-page_dup_rmap
+++ a/include/linux/rmap.h
@@ -71,14 +71,10 @@ void page_add_new_anon_rmap(struct page 
 void page_add_file_rmap(struct page *);
 void page_remove_rmap(struct page *);
 
-#ifdef CONFIG_DEBUG_VM
-void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
-#else
-static inline void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
+static inline void page_dup_rmap(struct page *page)
 {
 	atomic_inc(&page->_mapcount);
 }
-#endif
 
 /*
  * Called from mm/vmscan.c to handle paging out
diff -puN mm/memory.c~ksm-no-debug-in-page_dup_rmap mm/memory.c
--- a/mm/memory.c~ksm-no-debug-in-page_dup_rmap
+++ a/mm/memory.c
@@ -597,7 +597,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
 		get_page(page);
-		page_dup_rmap(page, vma, addr);
+		page_dup_rmap(page);
 		rss[!!PageAnon(page)]++;
 	}
 
diff -puN mm/rmap.c~ksm-no-debug-in-page_dup_rmap mm/rmap.c
--- a/mm/rmap.c~ksm-no-debug-in-page_dup_rmap
+++ a/mm/rmap.c
@@ -710,27 +710,6 @@ void page_add_file_rmap(struct page *pag
 	}
 }
 
-#ifdef CONFIG_DEBUG_VM
-/**
- * page_dup_rmap - duplicate pte mapping to a page
- * @page:	the page to add the mapping to
- * @vma:	the vm area being duplicated
- * @address:	the user virtual address mapped
- *
- * For copy_page_range only: minimal extract from page_add_file_rmap /
- * page_add_anon_rmap, avoiding unnecessary tests (already checked) so it's
- * quicker.
- *
- * The caller needs to hold the pte lock.
- */
-void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
-{
-	if (PageAnon(page))
-		__page_check_anon_rmap(page, vma, address);
-	atomic_inc(&page->_mapcount);
-}
-#endif
-
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

