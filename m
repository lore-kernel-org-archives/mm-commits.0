From: akpm@linux-foundation.org
Subject: [folded] mm-add-replace_page_cache_page-function-add-freepage-hook.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:57:46 -0700
Message-ID: <201103222257.p2MMvlJT032586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab1CVW6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 18:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mszeredi@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-add-replace_page_cache_page-function-add-freepage-hook
has been removed from the -mm tree.  Its filename was
     mm-add-replace_page_cache_page-function-add-freepage-hook.patch

This patch was dropped because it was folded into mm-add-replace_page_cache_page-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-replace_page_cache_page-function-add-freepage-hook
From: Minchan Kim <minchan.kim@gmail.com>

6072d13c ("Call the filesystem back whenever a page is removed from the
page cache") added new freepage hook in page cache drop function.

So, replace_page_cache_page should call freepage to support page cleanup
to fs.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/filemap.c~mm-add-replace_page_cache_page-function-add-freepage-hook mm/filemap.c
--- a/mm/filemap.c~mm-add-replace_page_cache_page-function-add-freepage-hook
+++ a/mm/filemap.c
@@ -436,7 +436,10 @@ int replace_page_cache_page(struct page 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (!error) {
 		struct address_space *mapping = old->mapping;
+		void (*freepage)(struct page *);
+
 		pgoff_t offset = old->index;
+		freepage = mapping->a_ops->freepage;
 
 		page_cache_get(new);
 		new->mapping = mapping;
@@ -452,6 +455,8 @@ int replace_page_cache_page(struct page 
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
+		if (freepage)
+			freepage(old);
 		page_cache_release(old);
 		mem_cgroup_end_migration(memcg, old, new, true);
 	} else {
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
mm-vmap-area-cache.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-add-replace_page_cache_page-function.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
mm-reclaim-invalidated-page-asap.patch
mempolicy-remove-redundant-check-in-__mpol_equal.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback.patch
mm-remove-inline-from-scan_swap_map.patch
mm-simplify-code-of-swapc.patch

