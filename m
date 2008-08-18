From: akpm@linux-foundation.org
Subject: + mm-pagecache-insertion-fewer-atomics.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:29:51 -0700
Message-ID: <200808182329.m7INTp2a019432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYHRX34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:29:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: pagecache insertion fewer atomics
has been added to the -mm tree.  Its filename is
     mm-pagecache-insertion-fewer-atomics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pagecache insertion fewer atomics
From: Nick Piggin <npiggin@suse.de>

Setting and clearing the page locked when inserting it into swapcache /
pagecache when it has no other references can use non-atomic page flags
operations because no other CPU may be operating on it at this time.

This saves one atomic operation when inserting a page into pagecache.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   14 +++++++-------
 mm/swap_state.c         |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/pagemap.h~mm-pagecache-insertion-fewer-atomics include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-pagecache-insertion-fewer-atomics
+++ a/include/linux/pagemap.h
@@ -299,14 +299,14 @@ extern int __lock_page_killable(struct p
 extern void __lock_page_nosync(struct page *page);
 extern void unlock_page(struct page *page);
 
-static inline void set_page_locked(struct page *page)
+static inline void __set_page_locked(struct page *page)
 {
-	set_bit(PG_locked, &page->flags);
+	__set_bit(PG_locked, &page->flags);
 }
 
-static inline void clear_page_locked(struct page *page)
+static inline void __clear_page_locked(struct page *page)
 {
-	clear_bit(PG_locked, &page->flags);
+	__clear_bit(PG_locked, &page->flags);
 }
 
 static inline int trylock_page(struct page *page)
@@ -438,17 +438,17 @@ extern void __remove_from_page_cache(str
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
- * the page is new, so we can just run set_page_locked() against it.
+ * the page is new, so we can just run __set_page_locked() against it.
  */
 static inline int add_to_page_cache(struct page *page,
 		struct address_space *mapping, pgoff_t offset, gfp_t gfp_mask)
 {
 	int error;
 
-	set_page_locked(page);
+	__set_page_locked(page);
 	error = add_to_page_cache_locked(page, mapping, offset, gfp_mask);
 	if (unlikely(error))
-		clear_page_locked(page);
+		__clear_page_locked(page);
 	return error;
 }
 
diff -puN mm/swap_state.c~mm-pagecache-insertion-fewer-atomics mm/swap_state.c
--- a/mm/swap_state.c~mm-pagecache-insertion-fewer-atomics
+++ a/mm/swap_state.c
@@ -303,7 +303,7 @@ struct page *read_swap_cache_async(swp_e
 		 * re-using the just freed swap entry for an existing page.
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
-		set_page_locked(new_page);
+		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (likely(!err)) {
@@ -315,7 +315,7 @@ struct page *read_swap_cache_async(swp_e
 			return new_page;
 		}
 		ClearPageSwapBacked(new_page);
-		clear_page_locked(new_page);
+		__clear_page_locked(new_page);
 		swap_free(entry);
 	} while (err != -ENOMEM);
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mm-dirty-page-tracking-race-fix.patch
mm-dirty-page-tracking-race-fix-fix.patch
mm-xip-fix-fault-vs-sparse-page-invalidate-race.patch
mm-xip-ext2-fix-block-allocation-race.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

