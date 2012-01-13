From: akpm@linux-foundation.org
Subject: [merged] memcg-simplify-page-cache-charging.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:10 -0800
Message-ID: <20120113203411.21A185C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099Ab2AMUeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:13 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify page cache charging
has been removed from the -mm tree.  Its filename was
     memcg-simplify-page-cache-charging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: simplify page cache charging

This patch is a clean up. No functional/logical changes.

Because of commit ef6a3c6311 ("mm: add replace_page_cache_page()
function") , FUSE uses replace_page_cache() instead of
add_to_page_cache().  Then, mem_cgroup_cache_charge() is not called
against FUSE's pages from splice.

So now, mem_cgroup_cache_charge() gets pages that are not on the LRU with
the exception of PageSwapCache pages.  For checking,
WARN_ON_ONCE(PageLRU(page)) is added.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-page-cache-charging mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-page-cache-charging
+++ a/mm/memcontrol.c
@@ -2790,6 +2790,7 @@ int mem_cgroup_cache_charge(struct page 
 				gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg = NULL;
+	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -2799,31 +2800,17 @@ int mem_cgroup_cache_charge(struct page 
 
 	if (unlikely(!mm))
 		mm = &init_mm;
+	if (!page_is_file_cache(page))
+		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
-	if (page_is_file_cache(page)) {
-		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
-		if (ret || !memcg)
-			return ret;
-
-		/*
-		 * FUSE reuses pages without going through the final
-		 * put that would remove them from the LRU list, make
-		 * sure that they get relinked properly.
-		 */
-		__mem_cgroup_commit_charge_lrucare(page, memcg,
-					MEM_CGROUP_CHARGE_TYPE_CACHE);
-		return ret;
-	}
-	/* shmem */
-	if (PageSwapCache(page)) {
+	if (!PageSwapCache(page)) {
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
+		WARN_ON_ONCE(PageLRU(page));
+	} else { /* page is swapcache/shmem */
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
 		if (!ret)
-			__mem_cgroup_commit_charge_swapin(page, memcg,
-					MEM_CGROUP_CHARGE_TYPE_SHMEM);
-	} else
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_SHMEM);
