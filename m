From: akpm@linux-foundation.org
Subject: + mlock-replace-stale-comments-in-munlock_vma_page.patch added to -mm tree
Date: Wed, 02 Dec 2009 17:10:51 -0800
Message-ID: <200912030110.nB31ApcT032544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674AbZLCBKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 20:10:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     mlock: replace stale comments in munlock_vma_page()
has been added to the -mm tree.  Its filename is
     mlock-replace-stale-comments-in-munlock_vma_page.patch

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
Subject: mlock: replace stale comments in munlock_vma_page()
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Cleanup stale comments on munlock_vma_page().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff -puN mm/mlock.c~mlock-replace-stale-comments-in-munlock_vma_page mm/mlock.c
--- a/mm/mlock.c~mlock-replace-stale-comments-in-munlock_vma_page
+++ a/mm/mlock.c
@@ -88,23 +88,20 @@ void mlock_vma_page(struct page *page)
 	}
 }
 
-/*
- * called from munlock()/munmap() path with page supposedly on the LRU.
+/**
+ * munlock_vma_page - munlock a vma page
+ * @page - page to be unlocked
  *
- * Note:  unlike mlock_vma_page(), we can't just clear the PageMlocked
- * [in try_to_munlock()] and then attempt to isolate the page.  We must
- * isolate the page to keep others from messing with its unevictable
- * and mlocked state while trying to munlock.  However, we pre-clear the
- * mlocked state anyway as we might lose the isolation race and we might
- * not get another chance to clear PageMlocked.  If we successfully
- * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
- * mapping the page, it will restore the PageMlocked state, unless the page
- * is mapped in a non-linear vma.  So, we go ahead and ClearPageMlocked(),
- * perhaps redundantly.
- * If we lose the isolation race, and the page is mapped by other VM_LOCKED
- * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
- * either of which will restore the PageMlocked state by calling
- * mlock_vma_page() above, if it can grab the vma's mmap sem.
+ * called from munlock()/munmap() path with page supposedly on the LRU.
+ * When we munlock a page, because the vma where we found the page is being
+ * munlock()ed or munmap()ed, we want to check whether other vmas hold the
+ * page locked so that we can leave it on the unevictable lru list and not
+ * bother vmscan with it.  However, to walk the page's rmap list in
+ * try_to_munlock() we must isolate the page from the LRU.  If some other
+ * task has removed the page from the LRU, we won't be able to do that.
+ * So we clear the PageMlocked as we might not get another chance.  If we
+ * can't isolate the page, we leave it for putback_lru_page() and vmscan
+ * [page_referenced()/try_to_unmap()] to deal with.
  */
 void munlock_vma_page(struct page *page)
 {
@@ -123,12 +120,12 @@ void munlock_vma_page(struct page *page)
 			putback_lru_page(page);
 		} else {
 			/*
-			 * We lost the race.  let try_to_unmap() deal
-			 * with it.  At least we get the page state and
-			 * mlock stats right.  However, page is still on
-			 * the noreclaim list.  We'll fix that up when
-			 * the page is eventually freed or we scan the
-			 * noreclaim list.
+			 * Some other task has removed the page from the LRU.
+			 * putback_lru_page() will take care of removing the
+			 * page from the unevictable list, if necessary.
+			 * vmscan [page_referenced()] will move the page back
+			 * to the unevictable list if some other vma has it
+			 * mlocked.
 			 */
 			if (PageUnevictable(page))
 				count_vm_event(UNEVICTABLE_PGSTRANDED);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

acpi-remove-nid_inval.patch
hugetlb-offload-per-node-attribute-registrations-fix.patch
swap-rework-map_swap_page-again.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-remove-unevictable_migrate_page-function.patch
mlock-replace-stale-comments-in-munlock_vma_page.patch

