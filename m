From: akpm@linux-foundation.org
Subject: + mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache.patch
 added to -mm tree
Date: Thu, 08 Sep 2016 16:13:07 -0700
Message-ID: <57d1f083.f07lwo/gPAbVnGtb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753380AbcIHXNJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 19:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aaron.lu@intel.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Use offset of swap entry as key of swap cache
has been added to the -mm tree.  Its filename is
     mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: Use offset of swap entry as key of swap cache

This patch is to improve the performance of swap cache operations when the
type of the swap device is not 0.  Originally, the whole swap entry value
is used as the key of the swap cache, even though there is one radix tree
for each swap device.  If the type of the swap device is not 0, the height
of the radix tree of the swap cache will be increased unnecessary,
especially on 64bit architecture.  For example, for a 1GB swap device on
the x86_64 architecture, the height of the radix tree of the swap cache is
11.  But if the offset of the swap entry is used as the key of the swap
cache, the height of the radix tree of the swap cache is 4.  The increased
height causes unnecessary radix tree descending and increased cache
footprint.

This patch reduces the height of the radix tree of the swap cache via
using the offset of the swap entry instead of the whole swap entry value
as the key of the swap cache.  In 32 processes sequential swap out test
case on a Xeon E5 v3 system with RAM disk as swap, the lock contention for
the spinlock of the swap cache is reduced from 20.15% to 12.19%, when the
type of the swap device is 1.

Use the whole swap entry as key,

perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.__add_to_swap_cache.add_to_swap_cache.add_to_swap.shrink_page_list: 10.37,
perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_node_memcg: 9.78,

Use the swap offset as key,

perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.__add_to_swap_cache.add_to_swap_cache.add_to_swap.shrink_page_list: 6.25,
perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_node_memcg: 5.94,

Link: http://lkml.kernel.org/r/1473270649-27229-1-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/memcontrol.c    |    5 +++--
 mm/mincore.c       |    5 +++--
 mm/swap_state.c    |    8 ++++----
 mm/swapfile.c      |    4 ++--
 5 files changed, 16 insertions(+), 14 deletions(-)

diff -puN include/linux/mm.h~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache include/linux/mm.h
--- a/include/linux/mm.h~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache
+++ a/include/linux/mm.h
@@ -1048,19 +1048,19 @@ struct address_space *page_file_mapping(
 	return page->mapping;
 }
 
+extern pgoff_t __page_file_index(struct page *page);
+
 /*
  * Return the pagecache index of the passed page.  Regular pagecache pages
- * use ->index whereas swapcache pages use ->private
+ * use ->index whereas swapcache pages use swp_offset(->private)
  */
 static inline pgoff_t page_index(struct page *page)
 {
 	if (unlikely(PageSwapCache(page)))
-		return page_private(page);
+		return __page_file_index(page);
 	return page->index;
 }
 
-extern pgoff_t __page_file_index(struct page *page);
-
 /*
  * Return the file index of the page. Regular pagecache pages use ->index
  * whereas swapcache pages use swp_offset(->private)
diff -puN mm/memcontrol.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache mm/memcontrol.c
--- a/mm/memcontrol.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache
+++ a/mm/memcontrol.c
@@ -4395,7 +4395,7 @@ static struct page *mc_handle_swap_pte(s
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
 	 */
-	page = find_get_page(swap_address_space(ent), ent.val);
+	page = find_get_page(swap_address_space(ent), swp_offset(ent));
 	if (do_memsw_account())
 		entry->val = ent.val;
 
@@ -4433,7 +4433,8 @@ static struct page *mc_handle_file_pte(s
 			swp_entry_t swp = radix_to_swp_entry(page);
 			if (do_memsw_account())
 				*entry = swp;
-			page = find_get_page(swap_address_space(swp), swp.val);
+			page = find_get_page(swap_address_space(swp),
+					     swp_offset(swp));
 		}
 	} else
 		page = find_get_page(mapping, pgoff);
diff -puN mm/mincore.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache mm/mincore.c
--- a/mm/mincore.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache
+++ a/mm/mincore.c
@@ -66,7 +66,8 @@ static unsigned char mincore_page(struct
 		 */
 		if (radix_tree_exceptional_entry(page)) {
 			swp_entry_t swp = radix_to_swp_entry(page);
-			page = find_get_page(swap_address_space(swp), swp.val);
+			page = find_get_page(swap_address_space(swp),
+					     swp_offset(swp));
 		}
 	} else
 		page = find_get_page(mapping, pgoff);
@@ -150,7 +151,7 @@ static int mincore_pte_range(pmd_t *pmd,
 			} else {
 #ifdef CONFIG_SWAP
 				*vec = mincore_page(swap_address_space(entry),
-					entry.val);
+						    swp_offset(entry));
 #else
 				WARN_ON(1);
 				*vec = 1;
diff -puN mm/swap_state.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache
+++ a/mm/swap_state.c
@@ -94,7 +94,7 @@ int __add_to_swap_cache(struct page *pag
 	address_space = swap_address_space(entry);
 	spin_lock_irq(&address_space->tree_lock);
 	error = radix_tree_insert(&address_space->page_tree,
-					entry.val, page);
+				  swp_offset(entry), page);
 	if (likely(!error)) {
 		address_space->nrpages++;
 		__inc_node_page_state(page, NR_FILE_PAGES);
@@ -145,7 +145,7 @@ void __delete_from_swap_cache(struct pag
 
 	entry.val = page_private(page);
 	address_space = swap_address_space(entry);
-	radix_tree_delete(&address_space->page_tree, page_private(page));
+	radix_tree_delete(&address_space->page_tree, swp_offset(entry));
 	set_page_private(page, 0);
 	ClearPageSwapCache(page);
 	address_space->nrpages--;
@@ -283,7 +283,7 @@ struct page * lookup_swap_cache(swp_entr
 {
 	struct page *page;
 
-	page = find_get_page(swap_address_space(entry), entry.val);
+	page = find_get_page(swap_address_space(entry), swp_offset(entry));
 
 	if (page) {
 		INC_CACHE_INFO(find_success);
@@ -310,7 +310,7 @@ struct page *__read_swap_cache_async(swp
 		 * called after lookup_swap_cache() failed, re-calling
 		 * that would confuse statistics.
 		 */
-		found_page = find_get_page(swapper_space, entry.val);
+		found_page = find_get_page(swapper_space, swp_offset(entry));
 		if (found_page)
 			break;
 
diff -puN mm/swapfile.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache
+++ a/mm/swapfile.c
@@ -105,7 +105,7 @@ __try_to_reclaim_swap(struct swap_info_s
 	struct page *page;
 	int ret = 0;
 
-	page = find_get_page(swap_address_space(entry), entry.val);
+	page = find_get_page(swap_address_space(entry), swp_offset(entry));
 	if (!page)
 		return 0;
 	/*
@@ -1005,7 +1005,7 @@ int free_swap_and_cache(swp_entry_t entr
 	if (p) {
 		if (swap_entry_free(p, entry, 1) == SWAP_HAS_CACHE) {
 			page = find_get_page(swap_address_space(entry),
-						entry.val);
+					     swp_offset(entry));
 			if (page && !trylock_page(page)) {
 				put_page(page);
 				page = NULL;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-add-swap_cluster_list.patch
mm-dont-use-radix-tree-writeback-tags-for-pages-in-swap-cache.patch
mm-swap-use-offset-of-swap-entry-as-key-of-swap-cache.patch
mm-remove-page_file_index.patch

