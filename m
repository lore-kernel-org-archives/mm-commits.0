From: akpm@linux-foundation.org
Subject: + memcg-fix-lru-rotation-in-isolate_pages.patch added to -mm tree
Date: Mon, 15 Jun 2009 14:12:18 -0700
Message-ID: <200906152112.n5FLCJnx009665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934810AbZFOVNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 17:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix lru rotation in isolate_pages
has been added to the -mm tree.  Its filename is
     memcg-fix-lru-rotation-in-isolate_pages.patch

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
Subject: memcg: fix lru rotation in isolate_pages
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Try to fix memcg's lru rotation sanity: make memcg use the same logic as
the global LRU does.

Now, at __isolate_lru_page() retruns -EBUSY, the page is rotated to the
tail of LRU in global LRU's isolate LRU pages.  But in memcg, it's not
handled.  This makes memcg do the same behavior as global LRU and rotate
LRU in the page is busy.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++++++++++-
 mm/vmscan.c     |    4 +++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-lru-rotation-in-isolate_pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-lru-rotation-in-isolate_pages
+++ a/mm/memcontrol.c
@@ -649,6 +649,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
 	int lru = LRU_FILE * !!file + !!active;
+	int ret;
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
@@ -666,9 +667,19 @@ unsigned long mem_cgroup_isolate_pages(u
 			continue;
 
 		scan++;
-		if (__isolate_lru_page(page, mode, file) == 0) {
+		ret = __isolate_lru_page(page, mode, file);
+		switch (ret) {
+		case 0:
 			list_move(&page->lru, dst);
+			mem_cgroup_del_lru(page);
 			nr_taken++;
+			break;
+		case -EBUSY:
+			/* we don't affect global LRU but rotate in our LRU */
+			mem_cgroup_rotate_lru_list(page, page_lru(page));
+			break;
+		default:
+			break;
 		}
 	}
 
diff -puN mm/vmscan.c~memcg-fix-lru-rotation-in-isolate_pages mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-lru-rotation-in-isolate_pages
+++ a/mm/vmscan.c
@@ -837,7 +837,6 @@ int __isolate_lru_page(struct page *page
 		 */
 		ClearPageLRU(page);
 		ret = 0;
-		mem_cgroup_del_lru(page);
 	}
 
 	return ret;
@@ -885,12 +884,14 @@ static unsigned long isolate_lru_pages(u
 		switch (__isolate_lru_page(page, mode, file)) {
 		case 0:
 			list_move(&page->lru, dst);
+			mem_cgroup_del_lru(page);
 			nr_taken++;
 			break;
 
 		case -EBUSY:
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
+			mem_cgroup_rotate_lru_list(page, page_lru(page));
 			continue;
 
 		default:
@@ -931,6 +932,7 @@ static unsigned long isolate_lru_pages(u
 				continue;
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
+				mem_cgroup_del_lru(page);
 				nr_taken++;
 				scan++;
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
memcg-fix-lru-rotation-in-isolate_pages.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch

