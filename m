From: akpm@linux-foundation.org
Subject: [merged] memcg-clean-up-force_empty_list-return-value-check.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:16 -0700
Message-ID: <20120801201317.2EBFF5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:41207 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab2HAUNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:19 -0400
Received: by lagr15 with SMTP id r15so343815lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: clean up force_empty_list() return value check
has been removed from the -mm tree.  Its filename was
     memcg-clean-up-force_empty_list-return-value-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: clean up force_empty_list() return value check

After bf544fdc241da8 "memcg: move charges to root cgroup if
use_hierarchy=0 in mem_cgroup_move_hugetlb_parent()"
mem_cgroup_move_parent() returns only -EBUSY or -EINVAL.  So we can remove
the -ENOMEM and -EINTR checks.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-force_empty_list-return-value-check mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-force_empty_list-return-value-check
+++ a/mm/memcontrol.c
@@ -3653,8 +3653,6 @@ static int mem_cgroup_force_empty_list(s
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM || ret == -EINTR)
-			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
 			/* found lock contention or "pc" is obsolete. */
@@ -3711,9 +3709,6 @@ move_account:
 		}
 		mem_cgroup_end_move(memcg);
 		memcg_oom_recover(memcg);
-		/* it seems parent cgroup doesn't have enough mem */
-		if (ret == -ENOMEM)
-			goto try_to_free;
 		cond_resched();
 	/* "ret" should also be checked to ensure all lists are empty. */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

