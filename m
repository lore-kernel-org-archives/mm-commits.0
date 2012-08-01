From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:11 -0700
Message-ID: <20120801201811.DD280100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2HAUSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:13 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove needless !mm fixup to init_mm when charging
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: remove needless !mm fixup to init_mm when charging

It does not matter to __mem_cgroup_try_charge() if the passed mm is NULL
or init_mm, it will charge the root memcg in either case.

Also fix up the comment in __mem_cgroup_try_charge() that claimed the
init_mm would be charged when no mm was passed.  It's not really
incorrect, but confusing.  Clarify that the root memcg is charged in this
case.

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

 mm/memcontrol.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging
+++ a/mm/memcontrol.c
@@ -2333,7 +2333,7 @@ static int __mem_cgroup_try_charge(struc
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
 	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the init_mm (happens for pagecache usage).
+	 * set, if so charge the root memcg (happens for pagecache usage).
 	 */
 	if (!*ptr && !mm)
 		*ptr = root_mem_cgroup;
@@ -2833,8 +2833,6 @@ int mem_cgroup_try_charge_swapin(struct 
 		ret = 0;
 	return ret;
 charge_cur_mm:
-	if (unlikely(!mm))
-		mm = &init_mm;
 	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
 	if (ret == -EINTR)
 		ret = 0;
@@ -2899,9 +2897,6 @@ int mem_cgroup_cache_charge(struct page 
 	if (PageCompound(page))
 		return 0;
 
-	if (unlikely(!mm))
-		mm = &init_mm;
