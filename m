From: akpm@linux-foundation.org
Subject: + mm-mlocking-in-try_to_unmap_one.patch added to -mm tree
Date: Thu, 12 Nov 2009 12:55:16 -0800
Message-ID: <200911122055.nACKtGBl018859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbZKLUzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: mlocking in try_to_unmap_one
has been added to the -mm tree.  Its filename is
     mm-mlocking-in-try_to_unmap_one.patch

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
Subject: mm: mlocking in try_to_unmap_one
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

There's contorted mlock/munlock handling in try_to_unmap_anon() and
try_to_unmap_file(), which we'd prefer not to repeat for KSM swapping. 
Simplify it by moving it all down into try_to_unmap_one().

One thing is then lost, try_to_munlock()'s distinction between when no vma
holds the page mlocked, and when a vma does mlock it, but we could not get
mmap_sem to set the page flag.  But its only caller takes no interest in
that distinction (and is better testing SWAP_MLOCK anyway), so let's keep
the code simple and return SWAP_AGAIN for both cases.

try_to_unmap_file()'s TTU_MUNLOCK nonlinear handling was particularly
amusing: once unravelled, it turns out to have been choosing between two
different ways of doing the same nothing.  Ah, no, one way was actually
returning SWAP_FAIL when it meant to return SWAP_SUCCESS.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 
 mm/rmap.c  |  106 ++++++++++++---------------------------------------
 2 files changed, 28 insertions(+), 80 deletions(-)

diff -puN mm/mlock.c~mm-mlocking-in-try_to_unmap_one mm/mlock.c
--- a/mm/mlock.c~mm-mlocking-in-try_to_unmap_one
+++ a/mm/mlock.c
@@ -117,7 +117,7 @@ static void munlock_vma_page(struct page
 			/*
 			 * did try_to_unlock() succeed or punt?
 			 */
-			if (ret == SWAP_SUCCESS || ret == SWAP_AGAIN)
+			if (ret != SWAP_MLOCK)
 				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 
 			putback_lru_page(page);
diff -puN mm/rmap.c~mm-mlocking-in-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~mm-mlocking-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -788,6 +788,8 @@ static int try_to_unmap_one(struct page 
 			ret = SWAP_MLOCK;
 			goto out_unmap;
 		}
+		if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
+			goto out_unmap;
 	}
 	if (!(flags & TTU_IGNORE_ACCESS)) {
 		if (ptep_clear_flush_young_notify(vma, address, pte)) {
@@ -853,12 +855,22 @@ static int try_to_unmap_one(struct page 
 	} else
 		dec_mm_counter(mm, file_rss);
 
-
 	page_remove_rmap(page);
 	page_cache_release(page);
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
+
+	if (MLOCK_PAGES && ret == SWAP_MLOCK) {
+		ret = SWAP_AGAIN;
+		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
+			if (vma->vm_flags & VM_LOCKED) {
+				mlock_vma_page(page);
+				ret = SWAP_MLOCK;
+			}
+			up_read(&vma->vm_mm->mmap_sem);
+		}
+	}
 out:
 	return ret;
 }
@@ -980,23 +992,6 @@ static int try_to_unmap_cluster(unsigned
 	return ret;
 }
 
-/*
- * common handling for pages mapped in VM_LOCKED vmas
- */
-static int try_to_mlock_page(struct page *page, struct vm_area_struct *vma)
-{
-	int mlocked = 0;
-
-	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			mlock_vma_page(page);
-			mlocked++;	/* really mlocked the page */
-		}
-		up_read(&vma->vm_mm->mmap_sem);
-	}
-	return mlocked;
-}
-
 /**
  * try_to_unmap_anon - unmap or unlock anonymous page using the object-based
  * rmap method
@@ -1017,42 +1012,19 @@ static int try_to_unmap_anon(struct page
 {
 	struct anon_vma *anon_vma;
 	struct vm_area_struct *vma;
-	unsigned int mlocked = 0;
 	int ret = SWAP_AGAIN;
-	int unlock = TTU_ACTION(flags) == TTU_MUNLOCK;
-
-	if (MLOCK_PAGES && unlikely(unlock))
-		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
 
 	anon_vma = page_lock_anon_vma(page);
 	if (!anon_vma)
 		return ret;
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-		if (MLOCK_PAGES && unlikely(unlock)) {
-			if (!((vma->vm_flags & VM_LOCKED) &&
-			      page_mapped_in_vma(page, vma)))
-				continue;  /* must visit all unlocked vmas */
-			ret = SWAP_MLOCK;  /* saw at least one mlocked vma */
-		} else {
-			ret = try_to_unmap_one(page, vma, flags);
-			if (ret == SWAP_FAIL || !page_mapped(page))
-				break;
-		}
-		if (ret == SWAP_MLOCK) {
-			mlocked = try_to_mlock_page(page, vma);
-			if (mlocked)
-				break;	/* stop if actually mlocked page */
-		}
+		ret = try_to_unmap_one(page, vma, flags);
+		if (ret != SWAP_AGAIN || !page_mapped(page))
+			break;
 	}
 
 	page_unlock_anon_vma(anon_vma);
-
-	if (mlocked)
-		ret = SWAP_MLOCK;	/* actually mlocked the page */
-	else if (ret == SWAP_MLOCK)
-		ret = SWAP_AGAIN;	/* saw VM_LOCKED vma */
-
 	return ret;
 }
 
@@ -1082,42 +1054,23 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_cursor = 0;
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
-	unsigned int mlocked = 0;
-	int unlock = TTU_ACTION(flags) == TTU_MUNLOCK;
-
-	if (MLOCK_PAGES && unlikely(unlock))
-		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
 
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
-		if (MLOCK_PAGES && unlikely(unlock)) {
-			if (!((vma->vm_flags & VM_LOCKED) &&
-						page_mapped_in_vma(page, vma)))
-				continue;	/* must visit all vmas */
-			ret = SWAP_MLOCK;
-		} else {
-			ret = try_to_unmap_one(page, vma, flags);
-			if (ret == SWAP_FAIL || !page_mapped(page))
-				goto out;
-		}
-		if (ret == SWAP_MLOCK) {
-			mlocked = try_to_mlock_page(page, vma);
-			if (mlocked)
-				goto out;  /* stop if actually mlocked page */
-		}
+		ret = try_to_unmap_one(page, vma, flags);
+		if (ret != SWAP_AGAIN || !page_mapped(page))
+			goto out;
 	}
 
 	if (list_empty(&mapping->i_mmap_nonlinear))
 		goto out;
 
+	/* We don't bother to try to find the munlocked page in nonlinears */
+	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
+		goto out;
+
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
 						shared.vm_set.list) {
-		if (MLOCK_PAGES && unlikely(unlock)) {
-			if (!(vma->vm_flags & VM_LOCKED))
-				continue;	/* must visit all vmas */
-			ret = SWAP_MLOCK;	/* leave mlocked == 0 */
-			goto out;		/* no need to look further */
-		}
 		if (!MLOCK_PAGES && !(flags & TTU_IGNORE_MLOCK) &&
 			(vma->vm_flags & VM_LOCKED))
 			continue;
@@ -1159,10 +1112,9 @@ static int try_to_unmap_file(struct page
 			cursor = (unsigned long) vma->vm_private_data;
 			while ( cursor < max_nl_cursor &&
 				cursor < vma->vm_end - vma->vm_start) {
-				ret = try_to_unmap_cluster(cursor, &mapcount,
-								vma, page);
-				if (ret == SWAP_MLOCK)
-					mlocked = 2;	/* to return below */
+				if (try_to_unmap_cluster(cursor, &mapcount,
+						vma, page) == SWAP_MLOCK)
+					ret = SWAP_MLOCK;
 				cursor += CLUSTER_SIZE;
 				vma->vm_private_data = (void *) cursor;
 				if ((int)mapcount <= 0)
@@ -1183,10 +1135,6 @@ static int try_to_unmap_file(struct page
 		vma->vm_private_data = NULL;
 out:
 	spin_unlock(&mapping->i_mmap_lock);
-	if (mlocked)
-		ret = SWAP_MLOCK;	/* actually mlocked the page */
-	else if (ret == SWAP_MLOCK)
-		ret = SWAP_AGAIN;	/* saw VM_LOCKED vma */
 	return ret;
 }
 
@@ -1229,7 +1177,7 @@ int try_to_unmap(struct page *page, enum
  *
  * Return values are:
  *
- * SWAP_SUCCESS	- no vma's holding page mlocked.
+ * SWAP_AGAIN	- no vma is holding page mlocked, or,
  * SWAP_AGAIN	- page mapped in mlocked vma -- couldn't acquire mmap sem
  * SWAP_MLOCK	- page is now mlocked.
  */
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

