From: akpm@linux-foundation.org
Subject: + memcg-avoid-dangling-reference-count-in-creation-failure.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:02:26 -0800
Message-ID: <20130126000227.39C235A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54433 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3AZAC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:02:28 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so94378qcq.5
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:02:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: avoid dangling reference count in creation failure.
has been added to the -mm tree.  Its filename is
     memcg-avoid-dangling-reference-count-in-creation-failure.patch

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
Subject: memcg: avoid dangling reference count in creation failure.

When use_hierarchy is enabled, we acquire an extra reference count in our
parent during cgroup creation.  We don't release it, though, if any
failure exist in the creation process.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-avoid-dangling-reference-count-in-creation-failure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-dangling-reference-count-in-creation-failure
+++ a/mm/memcontrol.c
@@ -6195,6 +6195,8 @@ mem_cgroup_css_online(struct cgroup *con
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
+		if (parent->use_hierarchy)
+			mem_cgroup_put(parent);
 	}
 	return error;
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

memcg-fix-typo-in-kmemcg-cache-walk-macro.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

