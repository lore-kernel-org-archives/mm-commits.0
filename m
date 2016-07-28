From: akpm@linux-foundation.org
Subject: [patch 059/101] mm, vmscan: remove highmem_file_pages
Date: Thu, 28 Jul 2016 15:47:29 -0700
Message-ID: <579a8b81.athtfpK0M9zKV03b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcG1Wra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: remove highmem_file_pages

With the reintroduction of per-zone LRU stats, highmem_file_pages is
redundant so remove it.

[mgorman@techsingularity.net: wrong stat is being accumulated in highmem_dirtyable_memory]
  Link: http://lkml.kernel.org/r/20160725092324.GM10438@techsingularity.netLink: http://lkml.kernel.org/r/1469110261-7365-3-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   17 -----------------
 mm/page-writeback.c       |   12 ++++--------
 2 files changed, 4 insertions(+), 25 deletions(-)

diff -puN include/linux/mm_inline.h~mm-vmscan-remove-highmem_file_pages include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmscan-remove-highmem_file_pages
+++ a/include/linux/mm_inline.h
@@ -4,22 +4,6 @@
 #include <linux/huge_mm.h>
 #include <linux/swap.h>
 
-#ifdef CONFIG_HIGHMEM
-extern atomic_t highmem_file_pages;
-
-static inline void acct_highmem_file_pages(int zid, enum lru_list lru,
-							int nr_pages)
-{
-	if (is_highmem_idx(zid) && is_file_lru(lru))
-		atomic_add(nr_pages, &highmem_file_pages);
-}
-#else
-static inline void acct_highmem_file_pages(int zid, enum lru_list lru,
-							int nr_pages)
-{
-}
-#endif
-
 /**
  * page_is_file_cache - should the page be on a file LRU or anon LRU?
  * @page: the page to test
@@ -47,7 +31,6 @@ static __always_inline void __update_lru
 	__mod_node_page_state(pgdat, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
-	acct_highmem_file_pages(zid, lru, nr_pages);
 }
 
 static __always_inline void update_lru_size(struct lruvec *lruvec,
diff -puN mm/page-writeback.c~mm-vmscan-remove-highmem_file_pages mm/page-writeback.c
--- a/mm/page-writeback.c~mm-vmscan-remove-highmem_file_pages
+++ a/mm/page-writeback.c
@@ -299,17 +299,13 @@ static unsigned long node_dirtyable_memo
 
 	return nr_pages;
 }
-#ifdef CONFIG_HIGHMEM
-atomic_t highmem_file_pages;
-#endif
 
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
 	int node;
-	unsigned long x;
+	unsigned long x = 0;
 	int i;
-	unsigned long dirtyable = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
 		for (i = ZONE_NORMAL + 1; i < MAX_NR_ZONES; i++) {
@@ -326,12 +322,12 @@ static unsigned long highmem_dirtyable_m
 			nr_pages = zone_page_state(z, NR_FREE_PAGES);
 			/* watch for underflows */
 			nr_pages -= min(nr_pages, high_wmark_pages(z));
-			dirtyable += nr_pages;
+			nr_pages += zone_page_state(z, NR_ZONE_INACTIVE_FILE);
+			nr_pages += zone_page_state(z, NR_ZONE_ACTIVE_FILE);
+			x += nr_pages;
 		}
 	}
 
-	x = dirtyable + atomic_read(&highmem_file_pages);
