From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-unneeded-shmem-charge-type.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:06 -0700
Message-ID: <20120801201807.38BA820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:57761 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2HAUSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:10 -0400
Received: by lbbgp10 with SMTP id gp10so47451lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove unneeded shmem charge type
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unneeded-shmem-charge-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: remove unneeded shmem charge type

shmem page charges have not needed a separate charge type to tell them
from regular file pages since 08e552c ("memcg: synchronized LRU").

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

 mm/memcontrol.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-unneeded-shmem-charge-type mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-unneeded-shmem-charge-type
+++ a/mm/memcontrol.c
@@ -379,7 +379,6 @@ static bool move_file(void)
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_ANON,
-	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
 	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
 	NR_CHARGE_TYPE,
@@ -2902,8 +2901,6 @@ int mem_cgroup_cache_charge(struct page 
 
 	if (unlikely(!mm))
 		mm = &init_mm;
-	if (!page_is_file_cache(page))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
@@ -3310,10 +3307,8 @@ void mem_cgroup_prepare_migration(struct
 	 */
 	if (PageAnon(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_ANON;
-	else if (page_is_file_cache(page))
-		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
-		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	/*
 	 * The page is committed to the memcg, but it's not actually
 	 * charged to the res_counter since we plan on replacing the
@@ -3407,10 +3402,6 @@ void mem_cgroup_replace_page_cache(struc
 	 */
 	if (!memcg)
 		return;
-
-	if (PageSwapBacked(oldpage))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
