From: akpm@linux-foundation.org
Subject: [patch 094/119] mm: pin address_space before dereferencing
 it while isolating an LRU page
Date: Wed, 31 Jan 2018 16:19:52 -0800
Message-ID: <20180201001952.qsQjI2HUP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAATx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ying.huang@intel.com

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: pin address_space before dereferencing it while isolating an LRU page

Minchan Kim asked the following question -- what locks protects
address_space destroying when race happens between inode trauncation and
__isolate_lru_page?  Jan Kara clarified by describing the race as follows

CPU1                                            CPU2

truncate(inode)                                 __isolate_lru_page()
  ...
  truncate_inode_page(mapping, page);
    delete_from_page_cache(page)
      spin_lock_irqsave(&mapping->tree_lock, flags);
        __delete_from_page_cache(page, NULL)
          page_cache_tree_delete(..)
            ...                                   mapping = page_mapping(page);
            page->mapping = NULL;
            ...
      spin_unlock_irqrestore(&mapping->tree_lock, flags);
      page_cache_free_page(mapping, page)
        put_page(page)
          if (put_page_testzero(page)) -> false
- inode now has no pages and can be freed including embedded address_space

                                                  if (mapping && !mapping->a_ops->migratepage)
- we've dereferenced mapping which is potentially already free.

The race is theoretically possible but unlikely.  Before the
delete_from_page_cache, truncate_cleanup_page is called so the page is
likely to be !PageDirty or PageWriteback which gets skipped by the only
caller that checks the mappping in __isolate_lru_page.  Even if the race
occurs, a substantial amount of work has to happen during a tiny window
with no preemption but it could potentially be done using a virtual
machine to artifically slow one CPU or halt it during the critical window.

This patch should eliminate the race with truncation by try-locking the
page before derefencing mapping and aborting if the lock was not acquired.
There was a suggestion from Huang Ying to use RCU as a side-effect to
prevent mapping being freed.  However, I do not like the solution as it's
an unconventional means of preserving a mapping and it's not a context
where rcu_read_lock is obviously protecting rcu data.

Link: http://lkml.kernel.org/r/20180104102512.2qos3h5vqzeisrek@techsingularity.net
Fixes: c82449352854 ("mm: compaction: make isolate_lru_page() filter-aware again")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-pin-address_space-before-dereferencing-it-while-isolating-an-lru-page mm/vmscan.c
--- a/mm/vmscan.c~mm-pin-address_space-before-dereferencing-it-while-isolating-an-lru-page
+++ a/mm/vmscan.c
@@ -1415,14 +1415,24 @@ int __isolate_lru_page(struct page *page
 
 		if (PageDirty(page)) {
 			struct address_space *mapping;
+			bool migrate_dirty;
 
 			/*
 			 * Only pages without mappings or that have a
 			 * ->migratepage callback are possible to migrate
-			 * without blocking
+			 * without blocking. However, we can be racing with
+			 * truncation so it's necessary to lock the page
+			 * to stabilise the mapping as truncation holds
+			 * the page lock until after the page is removed
+			 * from the page cache.
 			 */
+			if (!trylock_page(page))
+				return ret;
+
 			mapping = page_mapping(page);
-			if (mapping && !mapping->a_ops->migratepage)
+			migrate_dirty = mapping && mapping->a_ops->migratepage;
+			unlock_page(page);
+			if (!migrate_dirty)
 				return ret;
 		}
 	}
_
