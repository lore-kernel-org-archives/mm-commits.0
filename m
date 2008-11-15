From: akpm@linux-foundation.org
Subject: + mm-remove-unevictables-show_page_path.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:55:05 -0800
Message-ID: <200811150055.mAF0t51W000864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbYKOAz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:55:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, hugh@veritas.com, riel@redhat.com


The patch titled
     mm: remove unevictable's show_page_path
has been added to the -mm tree.  Its filename is
     mm-remove-unevictables-show_page_path.patch

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
Subject: mm: remove unevictable's show_page_path
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Hugh Dickins reported show_page_path() is buggy and unsafe.  because

 - lack dput() against d_find_alias()
 - don't concern vma->vm_mm->owner == NULL
 - lack lock_page()

it was only for debugging, so rather than trying to fix it, just remove it
now.

Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

diff -puN mm/vmscan.c~mm-remove-unevictables-show_page_path mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-unevictables-show_page_path
+++ a/mm/vmscan.c
@@ -2421,39 +2421,6 @@ int page_evictable(struct page *page, st
 	return 1;
 }
 
-static void show_page_path(struct page *page)
-{
-	char buf[256];
-	if (page_is_file_cache(page)) {
-		struct address_space *mapping = page->mapping;
-		struct dentry *dentry;
-		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-
-		spin_lock(&mapping->i_mmap_lock);
-		dentry = d_find_alias(mapping->host);
-		printk(KERN_INFO "rescued: %s %lu\n",
-		       dentry_path(dentry, buf, 256), pgoff);
-		spin_unlock(&mapping->i_mmap_lock);
-	} else {
-#if defined(CONFIG_MM_OWNER) && defined(CONFIG_MMU)
-		struct anon_vma *anon_vma;
-		struct vm_area_struct *vma;
-
-		anon_vma = page_lock_anon_vma(page);
-		if (!anon_vma)
-			return;
-
-		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-			printk(KERN_INFO "rescued: anon %s\n",
-			       vma->vm_mm->owner->comm);
-			break;
-		}
-		page_unlock_anon_vma(anon_vma);
-#endif
-	}
-}
-
-
 /**
  * check_move_unevictable_page - check page for evictability and move to appropriate zone lru list
  * @page: page to check evictability and move to appropriate lru list
@@ -2474,8 +2441,6 @@ retry:
 	if (page_evictable(page, NULL)) {
 		enum lru_list l = LRU_INACTIVE_ANON + page_is_file_cache(page);
 
-		show_page_path(page);
