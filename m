From: akpm@linux-foundation.org
Subject: [merged] mm-good-bye-remove_from_page_cache.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:08 -0700
Message-ID: <201103232039.p2NKdiIh028432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933395Ab1CWU5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hannes@cmpxchg.org, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: goodbye remove_from_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-good-bye-remove_from_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: goodbye remove_from_page_cache()
From: Minchan Kim <minchan.kim@gmail.com>

Now delete_from_page_cache() replaces remove_from_page_cache().  So we
remove remove_from_page_cache so fs or something out of mainline will
notice it when compile time and can fix it.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/filemap.c            |   25 +++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff -puN include/linux/pagemap.h~mm-good-bye-remove_from_page_cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-good-bye-remove_from_page_cache
+++ a/include/linux/pagemap.h
@@ -456,7 +456,6 @@ int add_to_page_cache_locked(struct page
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 extern void delete_from_page_cache(struct page *page);
-extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
 
diff -puN mm/filemap.c~mm-good-bye-remove_from_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-good-bye-remove_from_page_cache
+++ a/mm/filemap.c
@@ -137,7 +137,15 @@ void __remove_from_page_cache(struct pag
 	}
 }
 
-void remove_from_page_cache(struct page *page)
+/**
+ * delete_from_page_cache - delete page from page cache
+ * @page: the page which the kernel is trying to remove from page cache
+ *
+ * This must be called only on pages that have been verified to be in the page
+ * cache and locked.  It will never put the page into the free list, the caller
+ * has a reference on the page.
+ */
+void delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 	void (*freepage)(struct page *);
@@ -152,21 +160,6 @@ void remove_from_page_cache(struct page 
 
 	if (freepage)
 		freepage(page);
-}
-EXPORT_SYMBOL(remove_from_page_cache);
-
-/**
- * delete_from_page_cache - delete page from page cache
- * @page: the page which the kernel is trying to remove from page cache
- *
- * This must be called only on pages that have
- * been verified to be in the page cache and locked.
- * It will never put the page into the free list,
- * the caller has a reference on the page.
- */
-void delete_from_page_cache(struct page *page)
-{
-	remove_from_page_cache(page);
 	page_cache_release(page);
 }
 EXPORT_SYMBOL(delete_from_page_cache);
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

