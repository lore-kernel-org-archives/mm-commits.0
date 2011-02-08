From: akpm@linux-foundation.org
Subject: + mm-add-replace_page_cache_page-function-add-freepage-hook.patch added to -mm tree
Date: Mon, 07 Feb 2011 17:48:06 -0800
Message-ID: <201102080148.p181m6UD007909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab1BHBs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 20:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mszeredi@suse.cz, riel@redhat.com


The patch titled
     mm-add-replace_page_cache_page-function-add-freepage-hook
has been added to the -mm tree.  Its filename is
     mm-add-replace_page_cache_page-function-add-freepage-hook.patch

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
linux-next.patch
mm-vmap-area-cache.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch

