From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:52:29 -0800
Message-ID: <20130222235229.914655A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:48783 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:52:30 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so121558ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:52:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, dan.carpenter@oracle.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace cgroup_lock with memcg specific memcg_lock fix
has been removed from the -mm tree.  Its filename was
     memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch

This patch was dropped because it was folded into memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: replace cgroup_lock with memcg specific memcg_lock fix

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix
+++ a/mm/memcontrol.c
@@ -5736,7 +5736,7 @@ static int mem_cgroup_oom_control_write(
 	mutex_lock(&memcg_create_mutex);
 	/* oom-kill-disable is a flag for subhierarchy. */
 	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		cgroup_unlock();
+		mutex_unlock(&memcg_create_mutex);
 		return -EINVAL;
 	}
 	memcg->oom_kill_disable = val;
_

Patches currently in -mm which might be from glommer@parallels.com are

memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch

