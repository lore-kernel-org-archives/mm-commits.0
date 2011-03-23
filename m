From: akpm@linux-foundation.org
Subject: [merged] mm-change-__remove_from_page_cache.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:10 -0700
Message-ID: <201103232039.p2NKdkax028435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933284Ab1CWU5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hannes@cmpxchg.org, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: change __remove_from_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-change-__remove_from_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: change __remove_from_page_cache()
From: Minchan Kim <minchan.kim@gmail.com>

Now we renamed remove_from_page_cache with delete_from_page_cache.  As
consistency of __remove_from_swap_cache and remove_from_swap_cache, we
change internal page cache handling function name, too.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |    8 ++++----
 mm/memory-failure.c     |    2 +-
 mm/truncate.c           |    2 +-
 mm/vmscan.c             |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/pagemap.h~mm-change-__remove_from_page_cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-change-__remove_from_page_cache
+++ a/include/linux/pagemap.h
@@ -456,7 +456,7 @@ int add_to_page_cache_locked(struct page
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 extern void delete_from_page_cache(struct page *page);
-extern void __remove_from_page_cache(struct page *page);
+extern void __delete_from_page_cache(struct page *page);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
 
 /*
diff -puN mm/filemap.c~mm-change-__remove_from_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-change-__remove_from_page_cache
+++ a/mm/filemap.c
@@ -108,11 +108,11 @@
  */
 
 /*
- * Remove a page from the page cache and free it. Caller has to make
+ * Delete a page from the page cache and free it. Caller has to make
  * sure the page is locked and that nobody else uses it - or that usage
  * is safe.  The caller must hold the mapping's tree_lock.
  */
-void __remove_from_page_cache(struct page *page)
+void __delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 
@@ -154,7 +154,7 @@ void delete_from_page_cache(struct page 
 
 	freepage = mapping->a_ops->freepage;
 	spin_lock_irq(&mapping->tree_lock);
-	__remove_from_page_cache(page);
+	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 
@@ -444,7 +444,7 @@ int replace_page_cache_page(struct page 
 		new->index = offset;
 
 		spin_lock_irq(&mapping->tree_lock);
-		__remove_from_page_cache(old);
+		__delete_from_page_cache(old);
 		error = radix_tree_insert(&mapping->page_tree, offset, new);
 		BUG_ON(error);
 		mapping->nrpages++;
diff -puN mm/memory-failure.c~mm-change-__remove_from_page_cache mm/memory-failure.c
--- a/mm/memory-failure.c~mm-change-__remove_from_page_cache
+++ a/mm/memory-failure.c
@@ -1130,7 +1130,7 @@ int __memory_failure(unsigned long pfn, 
 
 	/*
 	 * Now take care of user space mappings.
-	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
+	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
 		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
diff -puN mm/truncate.c~mm-change-__remove_from_page_cache mm/truncate.c
--- a/mm/truncate.c~mm-change-__remove_from_page_cache
+++ a/mm/truncate.c
@@ -388,7 +388,7 @@ invalidate_complete_page2(struct address
 
 	clear_page_mlock(page);
 	BUG_ON(page_has_private(page));
-	__remove_from_page_cache(page);
+	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 
diff -puN mm/vmscan.c~mm-change-__remove_from_page_cache mm/vmscan.c
--- a/mm/vmscan.c~mm-change-__remove_from_page_cache
+++ a/mm/vmscan.c
@@ -514,7 +514,7 @@ static int __remove_mapping(struct addre
 
 		freepage = mapping->a_ops->freepage;
 
-		__remove_from_page_cache(page);
+		__delete_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
 		mem_cgroup_uncharge_cache_page(page);
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

