From: akpm@linux-foundation.org
Subject: + memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch added to -mm tree
Date: Mon, 11 Feb 2013 14:00:01 -0800
Message-ID: <20130211220001.C95AC31C2B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:45075 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3BKWAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 17:00:04 -0500
Received: by mail-ie0-f202.google.com with SMTP id k14so1200392iea.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 14:00:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, dan.carpenter@oracle.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: replace cgroup_lock with memcg specific memcg_lock fix
has been added to the -mm tree.  Its filename is
     memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-fix-kmemcg-registration-for-late-caches.patch
linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-fast-hierarchy-aware-child-test-fix-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

