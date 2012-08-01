From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-check-for-signal_pending-during-rmdir.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:13 -0700
Message-ID: <20120801201313.BE84D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:14 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove check for signal_pending() during rmdir()
has been removed from the -mm tree.  Its filename was
     memcg-remove-check-for-signal_pending-during-rmdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: remove check for signal_pending() during rmdir()

After bf544fdc241da8 "memcg: move charges to root cgroup if
use_hierarchy=0 in mem_cgroup_move_hugetlb_parent()", no memory reclaim
will occur when removing a memory cgroup.  If -EINTR is returned here,
cgroup will show a warning.

We don't need to handle any user interruption signal.  Remove this.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-check-for-signal_pending-during-rmdir mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-check-for-signal_pending-during-rmdir
+++ a/mm/memcontrol.c
@@ -3691,9 +3691,6 @@ move_account:
 		ret = -EBUSY;
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
-		ret = -EINTR;
-		if (signal_pending(current))
-			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

