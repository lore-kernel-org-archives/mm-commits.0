From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-fast-hierarchy-aware-child-test-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:52:08 -0800
Message-ID: <20130222235208.E976F31C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:60370 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:52:10 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so121214vea.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:52:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fast hierarchy-aware child test fix
has been removed from the -mm tree.  Its filename was
     memcg-fast-hierarchy-aware-child-test-fix-fix.patch

This patch was dropped because it was folded into memcg-fast-hierarchy-aware-child-test.patch

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: fast hierarchy-aware child test fix

Cc: Glauber Costa <glommer@parallels.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test-fix-fix
+++ a/mm/memcontrol.c
@@ -5734,8 +5734,7 @@ static int mem_cgroup_oom_control_write(
 
 	cgroup_lock();
 	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) ||
-	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
+	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
 		cgroup_unlock();
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from glommer@parallels.com are

memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch

