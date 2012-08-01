From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:55 -0700
Message-ID: <20120801201755.D0E6F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab2HAUR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:58 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions
has been removed from the -mm tree.  Its filename was
     mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions

Not all uncharge paths need to check if the page is swapcache, some of
them can know for sure.

Push down the check into all callsites of uncharge_common() so that the
patch that removes some of them is more obvious.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions
+++ a/mm/memcontrol.c
@@ -2987,8 +2987,7 @@ __mem_cgroup_uncharge_common(struct page
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	if (PageSwapCache(page))
-		return NULL;
+	VM_BUG_ON(PageSwapCache(page));
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
@@ -3085,6 +3084,8 @@ void mem_cgroup_uncharge_page(struct pag
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
+	if (PageSwapCache(page))
+		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
 }
 
@@ -3092,6 +3093,8 @@ void mem_cgroup_uncharge_cache_page(stru
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
+	if (PageSwapCache(page))
+		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -3156,6 +3159,8 @@ mem_cgroup_uncharge_swapcache(struct pag
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
+	if (PageSwapCache(page))
+		return;
 	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
@@ -3345,10 +3350,11 @@ void mem_cgroup_end_migration(struct mem
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	__mem_cgroup_uncharge_common(unused,
-		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
-		true);
+	if (!PageSwapCache(unused))
+		__mem_cgroup_uncharge_common(unused,
+					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+					     true);
 	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

