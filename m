From: akpm@linux-foundation.org
Subject: + mm-clarify-__add_to_swap_cache-locking-fix.patch added to -mm tree
Date: Thu, 09 Aug 2007 09:17:06 -0700
Message-ID: <200708091617.l79GH6C6007540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764111AbXHIQSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 12:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     mm-clarify-__add_to_swap_cache-locking fix
has been added to the -mm tree.  Its filename is
     mm-clarify-__add_to_swap_cache-locking-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-clarify-__add_to_swap_cache-locking fix
From: Hugh Dickins <hugh@veritas.com>

Nick's mm-clarify-__add_to_swap_cache-locking.patch is fine for mainline,
but soon generates a "kernel BUG at mm/swap_state.c:78!" when it meets
mm-implement-swap-prefetching.patch in 2.6.23-rc2-mm1.  We could add a fix
to the latter, but I think it's better to adjust Nick's, so that it's right
for whichever tree it's in: move the responsibility to SetPageLocked from
read_swap_cache_async to add_to_swap_cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking-fix mm/swap_state.c
--- a/mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking-fix
+++ a/mm/swap_state.c
@@ -100,15 +100,18 @@ int add_to_swap_cache(struct page *page,
 {
 	int error;
 
+	BUG_ON(PageLocked(page));
 	if (!swap_duplicate(entry)) {
 		INC_CACHE_INFO(noent_race);
 		return -ENOENT;
 	}
+	SetPageLocked(page);
 	error = __add_to_swap_cache(page, entry, GFP_KERNEL);
 	/*
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
 	if (error) {
+		ClearPageLocked(page);
 		swap_free(entry);
 		if (error == -EEXIST)
 			INC_CACHE_INFO(exist_race);
@@ -345,7 +348,6 @@ struct page *read_swap_cache_async(swp_e
 								vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
-			SetPageLocked(new_page);/* could be non-atomic op */
 		}
 
 		/*
@@ -369,9 +371,7 @@ struct page *read_swap_cache_async(swp_e
 		}
 	} while (err != -ENOENT && err != -ENOMEM);
 
-	if (new_page) {
-		ClearPageLocked(new_page);
+	if (new_page)
 		page_cache_release(new_page);
-	}
 	return found_page;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
mm-shmemc-make-3-functions-static.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio_tree-debugging-patch.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
