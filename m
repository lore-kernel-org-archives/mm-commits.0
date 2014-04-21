From: akpm@linux-foundation.org
Subject: +
 mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch added to -mm tree
Date: Mon, 21 Apr 2014 15:03:56 -0700
Message-ID: <535595cc.6Kx+8pX9257Po/Cb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaDUWD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, bsingharora@gmail.com, nasa4836@gmail.com

Subject: + mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch added to -mm tree
To: nasa4836@gmail.com,bsingharora@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:03:56 -0700


The patch titled
     Subject: mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()

Currently, the iteration job in mem_cgroup_iter() delegates to
__mem_cgroup_iter_next(), which will skip dead nodes.

Thus, the outer while loop in mem_cgroup_iter() is meaningless.
It could be proven by this:

1. memcg != NULL
    we are done, no loop needed.
2. memcg == NULL
   2.1 prev != NULL, a round-trip is done, break out, no loop.
   2.2 prev == NULL, this is impossible, since prev==NULL means
       the initial interation, it will returns memcg==root.

So remove this meaningless while loop.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   53 ++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1212,6 +1212,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
+	struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
+	int uninitialized_var(seq);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1229,40 +1231,33 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	}
 
 	rcu_read_lock();
-	while (!memcg) {
-		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
-		int uninitialized_var(seq);
-
-		if (reclaim) {
-			int nid = zone_to_nid(reclaim->zone);
-			int zid = zone_idx(reclaim->zone);
-			struct mem_cgroup_per_zone *mz;
-
-			mz = mem_cgroup_zoneinfo(root, nid, zid);
-			iter = &mz->reclaim_iter[reclaim->priority];
-			if (prev && reclaim->generation != iter->generation) {
-				iter->last_visited = NULL;
-				goto out_unlock;
-			}
-
-			last_visited = mem_cgroup_iter_load(iter, root, &seq);
+	if (reclaim) {
+		int nid = zone_to_nid(reclaim->zone);
+		int zid = zone_idx(reclaim->zone);
+		struct mem_cgroup_per_zone *mz;
+
+		mz = mem_cgroup_zoneinfo(root, nid, zid);
+		iter = &mz->reclaim_iter[reclaim->priority];
+		if (prev && reclaim->generation != iter->generation) {
+			iter->last_visited = NULL;
+			goto out_unlock;
 		}
 
-		memcg = __mem_cgroup_iter_next(root, last_visited);
+		last_visited = mem_cgroup_iter_load(iter, root, &seq);
+	}
 
-		if (reclaim) {
-			mem_cgroup_iter_update(iter, last_visited, memcg, root,
-					seq);
-
-			if (!memcg)
-				iter->generation++;
-			else if (!prev && memcg)
-				reclaim->generation = iter->generation;
-		}
+	memcg = __mem_cgroup_iter_next(root, last_visited);
 
-		if (prev && !memcg)
-			goto out_unlock;
+	if (reclaim) {
+		mem_cgroup_iter_update(iter, last_visited, memcg, root,
+				seq);
+
+		if (!memcg)
+			iter->generation++;
+		else if (!prev && memcg)
+			reclaim->generation = iter->generation;
 	}
+
 out_unlock:
 	rcu_read_unlock();
 out_css_put:
_

Patches currently in -mm which might be from nasa4836@gmail.com are

mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
linux-next.patch

