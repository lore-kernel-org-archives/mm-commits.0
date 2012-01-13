From: akpm@linux-foundation.org
Subject: + mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:48:29 -0800
Message-ID: <20120113224829.AF06810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34523 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab2AMWsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:48:30 -0500
Received: by ggnk3 with SMTP id k3so368021ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:48:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm: memcg: update the correct soft limit tree during migration
has been added to the -mm tree.  Its filename is
     mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: update the correct soft limit tree during migration

end_migration() passes the old page instead of the new page to commit the
charge.  This page descriptor is not used for committing itself, though,
since we also pass the (correct) page_cgroup descriptor.  But it's used to
find the soft limit tree through the page's zone, so the soft limit tree
of the old page's zone is updated instead of that of the new page's, which
might get slightly out of date until the next charge reaches the ratelimit
point.

This glitch has been present since '5564e88 memcg: condense
page_cgroup-to-page lookup points'.

This fixes a bug that I introduced in 2.6.38.  It's benign enough (to
my knowledge) that we probably don't want this for stable.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-update-the-correct-soft-limit-tree-during-migration mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-update-the-correct-soft-limit-tree-during-migration
+++ a/mm/memcontrol.c
@@ -3247,7 +3247,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype);
 	return ret;
 }
 
_
Subject: Subject: mm: memcg: update the correct soft limit tree during migration

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch

