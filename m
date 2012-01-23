From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:42 -0800
Message-ID: <20120123202142.BB81110004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57843 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2AWUVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:43 -0500
Received: by yhjj52 with SMTP id j52so324726yhj.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: update the correct soft limit tree during migration
has been removed from the -mm tree.  Its filename was
     mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

This glitch has been present since 5564e88 ("memcg: condense
page_cgroup-to-page lookup points").

This fixes a bug that I introduced in 2.6.38.  It's benign enough (to
my knowledge) that we probably don't want this for stable.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch

