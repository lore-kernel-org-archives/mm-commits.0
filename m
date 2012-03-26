From: akpm@linux-foundation.org
Subject: + mm-memcg-kill-mem_cgroup_lru_del.patch added to -mm tree
Date: Mon, 26 Mar 2012 16:56:31 -0700
Message-ID: <20120326235631.2BCD1A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49815 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2CZX4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:56:33 -0400
Received: by wejx9 with SMTP id x9so296347wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:56:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org


The patch titled
     Subject: mm/memcg: kill mem_cgroup_lru_del()
has been added to the -mm tree.  Its filename is
     mm-memcg-kill-mem_cgroup_lru_del.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/memcg: kill mem_cgroup_lru_del()

This patch kills mem_cgroup_lru_del(), we can use
mem_cgroup_lru_del_list() instead.  On 0-order isolation we already have
right lru list id.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 -----
 mm/memcontrol.c            |    5 -----
 mm/vmscan.c                |    7 +++++--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-kill-mem_cgroup_lru_del include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-kill-mem_cgroup_lru_del
+++ a/include/linux/memcontrol.h
@@ -66,7 +66,6 @@ struct lruvec *mem_cgroup_zone_lruvec(st
 struct lruvec *mem_cgroup_lru_add_list(struct zone *, struct page *,
 				       enum lru_list);
 void mem_cgroup_lru_del_list(struct page *, enum lru_list);
-void mem_cgroup_lru_del(struct page *);
 struct lruvec *mem_cgroup_lru_move_lists(struct zone *, struct page *,
 					 enum lru_list, enum lru_list);
 
@@ -260,10 +259,6 @@ static inline void mem_cgroup_lru_del_li
 {
 }
 
-static inline void mem_cgroup_lru_del(struct page *page)
-{
-}
-
 static inline struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
 						       struct page *page,
 						       enum lru_list from,
diff -puN mm/memcontrol.c~mm-memcg-kill-mem_cgroup_lru_del mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-kill-mem_cgroup_lru_del
+++ a/mm/memcontrol.c
@@ -1115,11 +1115,6 @@ void mem_cgroup_lru_del_list(struct page
 	mz->lru_size[lru] -= 1 << compound_order(page);
 }
 
-void mem_cgroup_lru_del(struct page *page)
-{
-	mem_cgroup_lru_del_list(page, page_lru(page));
-}
-
 /**
  * mem_cgroup_lru_move_lists - account for moving a page between lrus
  * @zone: zone of the page
diff -puN mm/vmscan.c~mm-memcg-kill-mem_cgroup_lru_del mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-kill-mem_cgroup_lru_del
+++ a/mm/vmscan.c
@@ -1147,7 +1147,7 @@ static unsigned long isolate_lru_pages(u
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
-			mem_cgroup_lru_del(page);
+			mem_cgroup_lru_del_list(page, lru);
 			list_move(&page->lru, dst);
 			nr_taken += hpage_nr_pages(page);
 			break;
@@ -1205,8 +1205,11 @@ static unsigned long isolate_lru_pages(u
 
 			if (__isolate_lru_page(cursor_page, mode) == 0) {
 				unsigned int isolated_pages;
+				enum lru_list cursor_lru;
 
-				mem_cgroup_lru_del(cursor_page);
+				cursor_lru = page_lru(cursor_page);
+				mem_cgroup_lru_del_list(cursor_page,
+							cursor_lru);
 				list_move(&cursor_page->lru, dst);
 				isolated_pages = hpage_nr_pages(cursor_page);
 				nr_taken += isolated_pages;
_
Subject: Subject: mm/memcg: kill mem_cgroup_lru_del()

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

