From: akpm@linux-foundation.org
Subject: + ksm-no-debug-in-page_dup_rmap.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:35 -0700
Message-ID: <200907232107.n6NL7aH8027490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbZGWVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com


The patch titled
     ksm: no debug in page_dup_rmap()
has been added to the -mm tree.  Its filename is
     ksm-no-debug-in-page_dup_rmap.patch

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
@@ -595,7 +595,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
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
@@ -709,27 +709,6 @@ void page_add_file_rmap(struct page *pag
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
