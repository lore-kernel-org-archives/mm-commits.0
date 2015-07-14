From: akpm@linux-foundation.org
Subject: + mm-swap-zswap-maybe_preload-refactoring.patch added to -mm tree
Date: Tue, 14 Jul 2015 12:14:40 -0700
Message-ID: <55a55fa0.b1KtDoQmZywBYyF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbbGNTOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 15:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 0x7f454c46@gmail.com, axboe@fb.com, dh.herrmann@gmail.com, hannes@cmpxchg.org, hch@lst.de, hughd@google.com, mhocko@suse.cz, minchan@kernel.org, sjennings@variantweb.net, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: zswap: maybe_preload & refactoring
has been added to the -mm tree.  Its filename is
     mm-swap-zswap-maybe_preload-refactoring.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-zswap-maybe_preload-refactoring.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-zswap-maybe_preload-refactoring.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: mm: swap: zswap: maybe_preload & refactoring

zswap_get_swap_cache_page and read_swap_cache_async have pretty much the
same code with only significant difference in return value and usage of
swap_readpage.

I a helper __read_swap_cache_async() with the common code.  Behavior
change: now zswap_get_swap_cache_page will use radix_tree_maybe_preload
instead radix_tree_preload.  Looks like, this wasn't changed only by the
reason of code duplication.

Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +
 mm/swap_state.c      |   37 ++++++++++++++------
 mm/zswap.c           |   73 +++--------------------------------------
 3 files changed, 35 insertions(+), 78 deletions(-)

diff -puN include/linux/swap.h~mm-swap-zswap-maybe_preload-refactoring include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-zswap-maybe_preload-refactoring
+++ a/include/linux/swap.h
@@ -399,6 +399,9 @@ extern void free_pages_and_swap_cache(st
 extern struct page *lookup_swap_cache(swp_entry_t);
 extern struct page *read_swap_cache_async(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr);
+extern struct page *__read_swap_cache_async(swp_entry_t, gfp_t,
+			struct vm_area_struct *vma, unsigned long addr,
+			bool *new_page_allocated);
 extern struct page *swapin_readahead(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr);
 
diff -puN mm/swap_state.c~mm-swap-zswap-maybe_preload-refactoring mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-zswap-maybe_preload-refactoring
+++ a/mm/swap_state.c
@@ -288,17 +288,14 @@ struct page * lookup_swap_cache(swp_entr
 	return page;
 }
 
-/* 
- * Locate a page of swap in physical memory, reserving swap cache space
- * and reading the disk if it is not already cached.
- * A failure return means that either the page allocation failed or that
- * the swap entry is no longer in use.
- */
-struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-			struct vm_area_struct *vma, unsigned long addr)
+struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
+			struct vm_area_struct *vma, unsigned long addr,
+			bool *new_page_allocated)
 {
 	struct page *found_page, *new_page = NULL;
+	struct address_space *swapper_space = swap_address_space(entry);
 	int err;
+	*new_page_allocated = false;
 
 	do {
 		/*
@@ -306,8 +303,7 @@ struct page *read_swap_cache_async(swp_e
 		 * called after lookup_swap_cache() failed, re-calling
 		 * that would confuse statistics.
 		 */
-		found_page = find_get_page(swap_address_space(entry),
-					entry.val);
+		found_page = find_get_page(swapper_space, entry.val);
 		if (found_page)
 			break;
 
@@ -366,7 +362,7 @@ struct page *read_swap_cache_async(swp_e
 			 * Initiate read into locked page and return.
 			 */
 			lru_cache_add_anon(new_page);
-			swap_readpage(new_page);
+			*new_page_allocated = true;
 			return new_page;
 		}
 		radix_tree_preload_end();
@@ -384,6 +380,25 @@ struct page *read_swap_cache_async(swp_e
 	return found_page;
 }
 
+/*
+ * Locate a page of swap in physical memory, reserving swap cache space
+ * and reading the disk if it is not already cached.
+ * A failure return means that either the page allocation failed or that
+ * the swap entry is no longer in use.
+ */
+struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	bool page_was_allocated;
+	struct page *retpage = __read_swap_cache_async(entry, gfp_mask,
+			vma, addr, &page_was_allocated);
+
+	if (page_was_allocated)
+		swap_readpage(retpage);
+
+	return retpage;
+}
+
 static unsigned long swapin_nr_pages(unsigned long offset)
 {
 	static unsigned long prev_offset;
diff -puN mm/zswap.c~mm-swap-zswap-maybe_preload-refactoring mm/zswap.c
--- a/mm/zswap.c~mm-swap-zswap-maybe_preload-refactoring
+++ a/mm/zswap.c
@@ -446,75 +446,14 @@ enum zswap_get_swap_ret {
 static int zswap_get_swap_cache_page(swp_entry_t entry,
 				struct page **retpage)
 {
-	struct page *found_page, *new_page = NULL;
-	struct address_space *swapper_space = swap_address_space(entry);
-	int err;
+	bool page_was_allocated;
 
-	*retpage = NULL;
-	do {
-		/*
-		 * First check the swap cache.  Since this is normally
-		 * called after lookup_swap_cache() failed, re-calling
-		 * that would confuse statistics.
-		 */
-		found_page = find_get_page(swapper_space, entry.val);
-		if (found_page)
-			break;
-
-		/*
-		 * Get a new page to read into from swap.
-		 */
-		if (!new_page) {
-			new_page = alloc_page(GFP_KERNEL);
-			if (!new_page)
-				break; /* Out of memory */
-		}
-
-		/*
-		 * call radix_tree_preload() while we can wait.
-		 */
-		err = radix_tree_preload(GFP_KERNEL);
-		if (err)
-			break;
-
-		/*
-		 * Swap entry may have been freed since our caller observed it.
-		 */
-		err = swapcache_prepare(entry);
-		if (err == -EEXIST) { /* seems racy */
-			radix_tree_preload_end();
-			continue;
-		}
-		if (err) { /* swp entry is obsolete ? */
-			radix_tree_preload_end();
-			break;
-		}
-
-		/* May fail (-ENOMEM) if radix-tree node allocation failed. */
-		__SetPageLocked(new_page);
-		SetPageSwapBacked(new_page);
-		err = __add_to_swap_cache(new_page, entry);
-		if (likely(!err)) {
-			radix_tree_preload_end();
-			lru_cache_add_anon(new_page);
-			*retpage = new_page;
-			return ZSWAP_SWAPCACHE_NEW;
-		}
-		radix_tree_preload_end();
-		ClearPageSwapBacked(new_page);
-		__ClearPageLocked(new_page);
-		/*
-		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
-		 * clear SWAP_HAS_CACHE flag.
-		 */
-		swapcache_free(entry);
-	} while (err != -ENOMEM);
