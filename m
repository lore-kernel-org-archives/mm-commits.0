From: akpm@linux-foundation.org
Subject: + mm-add_to_swap_cache-must-not-sleep.patch added to -mm tree
Date: Mon, 10 Aug 2009 22:37:05 -0700
Message-ID: <200908110537.n7B5b5EO001881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbZHKLyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: add_to_swap_cache() must not sleep
has been added to the -mm tree.  Its filename is
     mm-add_to_swap_cache-must-not-sleep.patch

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
Subject: mm: add_to_swap_cache() must not sleep
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

After commit 355cfa73 ("mm: modify swap_map and add SWAP_HAS_CACHE flag"),
read_swap_cache_async() will busy-wait while a entry doesn't exist in swap
cache but it has SWAP_HAS_CACHE flag.

Such entries can exist on add/delete path of swap cache.  On add path,
add_to_swap_cache() is called soon after SWAP_HAS_CACHE flag is set, and
on delete path, swapcache_free() will be called (SWAP_HAS_CACHE flag is
cleared) soon after __delete_from_swap_cache() is called.  So, the
busy-wait works well in most cases.

But this mechanism can cause soft lockup if add_to_swap_cache() sleeps and
read_swap_cache_async() tries to swap-in the same entry on the same cpu.

This patch calls radix_tree_preload() before swapcache_prepare() and
divides add_to_swap_cache() into two part: radix_tree_preload() part and
radix_tree_insert() part(define it as __add_to_swap_cache()).

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   70 ++++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff -puN mm/swap_state.c~mm-add_to_swap_cache-must-not-sleep mm/swap_state.c
--- a/mm/swap_state.c~mm-add_to_swap_cache-must-not-sleep
+++ a/mm/swap_state.c
@@ -67,10 +67,10 @@ void show_swap_cache_info(void)
 }
 
 /*
- * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
+ * __add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
+static int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
 	int error;
 
@@ -78,28 +78,37 @@ int add_to_swap_cache(struct page *page,
 	VM_BUG_ON(PageSwapCache(page));
 	VM_BUG_ON(!PageSwapBacked(page));
 
+	page_cache_get(page);
+	SetPageSwapCache(page);
+	set_page_private(page, entry.val);
+
+	spin_lock_irq(&swapper_space.tree_lock);
+	error = radix_tree_insert(&swapper_space.page_tree, entry.val, page);
+	if (likely(!error)) {
+		total_swapcache_pages++;
+		__inc_zone_page_state(page, NR_FILE_PAGES);
+		INC_CACHE_INFO(add_total);
+	}
+	spin_unlock_irq(&swapper_space.tree_lock);
+
+	if (unlikely(error)) {
+		set_page_private(page, 0UL);
+		ClearPageSwapCache(page);
+		page_cache_release(page);
+	}
+
+	return error;
+}
+
+
+int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
+{
+	int error;
+
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
-		page_cache_get(page);
-		SetPageSwapCache(page);
-		set_page_private(page, entry.val);
-
-		spin_lock_irq(&swapper_space.tree_lock);
-		error = radix_tree_insert(&swapper_space.page_tree,
-						entry.val, page);
-		if (likely(!error)) {
-			total_swapcache_pages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
-			INC_CACHE_INFO(add_total);
-		}
-		spin_unlock_irq(&swapper_space.tree_lock);
+		error = __add_to_swap_cache(page, entry);
 		radix_tree_preload_end();
-
-		if (unlikely(error)) {
-			set_page_private(page, 0UL);
-			ClearPageSwapCache(page);
-			page_cache_release(page);
-		}
 	}
 	return error;
 }
@@ -290,13 +299,24 @@ struct page *read_swap_cache_async(swp_e
 		}
 
 		/*
+		 * call radix_tree_preload() while we can wait.
+		 */
+		err = radix_tree_preload(gfp_mask & GFP_KERNEL);
+		if (err)
+			break;
+
+		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) /* seems racy */
+		if (err == -EEXIST) {	/* seems racy */
+			radix_tree_preload_end();
 			continue;
-		if (err)           /* swp entry is obsolete ? */
+		}
+		if (err) {		/* swp entry is obsolete ? */
+			radix_tree_preload_end();
 			break;
+		}
 
 		/*
 		 * Associate the page with swap entry in the swap cache.
@@ -308,8 +328,9 @@ struct page *read_swap_cache_async(swp_e
 		 */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
-		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
+		err = __add_to_swap_cache(new_page, entry);
 		if (likely(!err)) {
+			radix_tree_preload_end();
 			/*
 			 * Initiate read into locked page and return.
 			 */
@@ -317,6 +338,7 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(new_page);
 			return new_page;
 		}
+		radix_tree_preload_end();
 		ClearPageSwapBacked(new_page);
 		__clear_page_locked(new_page);
 		swapcache_free(entry, NULL);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch

