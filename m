From: akpm@linux-foundation.org
Subject: + mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch added to -mm tree
Date: Mon, 15 Jun 2009 14:09:27 -0700
Message-ID: <200906152109.n5FL9R0T007192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934632AbZFOVKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 17:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm: fix lumpy reclaim lru handling at isolate_lru_pages
has been added to the -mm tree.  Its filename is
     mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch

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
migration-only-migrate_prep-once-per-move_pages.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
mm-add-swap-cache-interface-for-swap-reference.patch
mm-modify-swap_map-and-add-swap_has_cache-flag.patch
mm-modify-swap_map-and-add-swap_has_cache-flag-update.patch
mm-reuse-unused-swap-entry-if-necessary.patch
mm-reuse-unused-swap-entry-if-necessary-update.patch
vmscan-handle-may_swap-more-strictly.patch
mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch
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
memcg-fix-lru-rotation-in-isolate_pages-v2.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch

