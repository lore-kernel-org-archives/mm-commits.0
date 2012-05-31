From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-kill-mem_cgroup_lru_del.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:00 -0700
Message-ID: <20120531191700.7205AA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34772 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932967Ab2EaTRC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:17:02 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75709lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: kill mem_cgroup_lru_del()
has been removed from the -mm tree.  Its filename was
     mm-memcg-kill-mem_cgroup_lru_del.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
 mm/vmscan.c                |    2 +-
 3 files changed, 1 insertion(+), 11 deletions(-)

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
 
@@ -265,10 +264,6 @@ static inline void mem_cgroup_lru_del_li
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
@@ -1057,7 +1057,7 @@ static unsigned long isolate_lru_pages(u
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
-			mem_cgroup_lru_del(page);
+			mem_cgroup_lru_del_list(page, lru);
 			list_move(&page->lru, dst);
 			nr_taken += hpage_nr_pages(page);
 			break;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

