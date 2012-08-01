From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:58 -0700
Message-ID: <20120801201758.C8BFC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2HAUSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:00 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: only check for PageSwapCache when uncharging anon
has been removed from the -mm tree.  Its filename was
     mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: only check for PageSwapCache when uncharging anon

Only anon pages that are uncharged at the time of the last page table
mapping vanishing may be in swapcache.

When shmem pages, file pages, swap-freed anon pages, or just migrated
pages are uncharged, they are known for sure to be not in swapcache.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-only-check-for-pageswapcache-when-uncharging-anon mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-only-check-for-pageswapcache-when-uncharging-anon
+++ a/mm/memcontrol.c
@@ -3093,8 +3093,6 @@ void mem_cgroup_uncharge_cache_page(stru
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
-	if (PageSwapCache(page))
-		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -3159,8 +3157,6 @@ mem_cgroup_uncharge_swapcache(struct pag
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
-	if (PageSwapCache(page))
-		return;
 	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
@@ -3350,11 +3346,10 @@ void mem_cgroup_end_migration(struct mem
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	if (!PageSwapCache(unused))
-		__mem_cgroup_uncharge_common(unused,
-					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
-					     true);
+	__mem_cgroup_uncharge_common(unused,
+				     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+				     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+				     true);
 	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

