From: akpm@linux-foundation.org
Subject: [merged] mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:46 -0700
Message-ID: <200906171836.n5HIakMO002817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759585AbZFQShh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix lumpy reclaim lru handling at isolate_lru_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix lumpy reclaim lru handling at isolate_lru_pages
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At lumpy reclaim, a page failed to be taken by __isolate_lru_page() can be
pushed back to "src" list by list_move().  But the page may not be from
"src" list.  This pushes the page back to wrong LRU.  And list_move()
itself is unnecessary because the page is not on top of LRU.  Then, leave
it as it is if __isolate_lru_page() fails.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -929,18 +929,10 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			switch (__isolate_lru_page(cursor_page, mode, file)) {
-			case 0:
+			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
 				scan++;
-				break;
-
-			case -EBUSY:
-				/* else it is being freed elsewhere */
-				list_move(&cursor_page->lru, src);
-			default:
-				break;	/* ! on LRU or wrong list */
 			}
 		}
 	}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch
memcg-add-interface-to-reset-limits.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch

