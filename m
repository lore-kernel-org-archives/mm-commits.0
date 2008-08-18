From: akpm@linux-foundation.org
Subject: + mm-page-lock-use-lock-bitops.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:29:55 -0700
Message-ID: <200808182329.m7INTtxb019438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYHRXaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: page lock use lock bitops
has been added to the -mm tree.  Its filename is
     mm-page-lock-use-lock-bitops.patch

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
Subject: mm: page lock use lock bitops
From: Nick Piggin <npiggin@suse.de>

trylock_page, unlock_page open and close a critical section. Hence,
we can use the lock bitops to get the desired memory ordering.

Also, mark trylock as likely to succeed (and remove the annotation from
callers).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |   13 +++++--------
 mm/swapfile.c           |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN include/linux/pagemap.h~mm-page-lock-use-lock-bitops include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-page-lock-use-lock-bitops
+++ a/include/linux/pagemap.h
@@ -311,7 +311,7 @@ static inline void __clear_page_locked(s
 
 static inline int trylock_page(struct page *page)
 {
-	return !test_and_set_bit(PG_locked, &page->flags);
+	return (likely(!test_and_set_bit_lock(PG_locked, &page->flags)));
 }
 
 /*
diff -puN mm/filemap.c~mm-page-lock-use-lock-bitops mm/filemap.c
--- a/mm/filemap.c~mm-page-lock-use-lock-bitops
+++ a/mm/filemap.c
@@ -573,17 +573,14 @@ EXPORT_SYMBOL(wait_on_page_bit);
  * mechananism between PageLocked pages and PageWriteback pages is shared.
  * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
  *
- * The first mb is necessary to safely close the critical section opened by the
- * test_and_set_bit() to lock the page; the second mb is necessary to enforce
- * ordering between the clear_bit and the read of the waitqueue (to avoid SMP
- * races with a parallel wait_on_page_locked()).
+ * The mb is necessary to enforce ordering between the clear_bit and the read
+ * of the waitqueue (to avoid SMP races with a parallel wait_on_page_locked()).
  */
 void unlock_page(struct page *page)
 {
-	smp_mb__before_clear_bit();
-	if (!test_and_clear_bit(PG_locked, &page->flags))
-		BUG();
-	smp_mb__after_clear_bit(); 
+	VM_BUG_ON(!PageLocked(page));
+	clear_bit_unlock(PG_locked, &page->flags);
+	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_locked);
 }
 EXPORT_SYMBOL(unlock_page);
diff -puN mm/swapfile.c~mm-page-lock-use-lock-bitops mm/swapfile.c
--- a/mm/swapfile.c~mm-page-lock-use-lock-bitops
+++ a/mm/swapfile.c
@@ -422,7 +422,7 @@ void free_swap_and_cache(swp_entry_t ent
 	if (p) {
 		if (swap_entry_free(p, swp_offset(entry)) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
-			if (page && unlikely(!trylock_page(page))) {
+			if (page && !trylock_page(page)) {
 				page_cache_release(page);
 				page = NULL;
 			}
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

