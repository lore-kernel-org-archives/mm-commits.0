From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-kmemcg-registration-for-late-caches.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:36:01 -0800
Message-ID: <20130213203602.02F395A42C4@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:38440 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3BMUgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:36:03 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so886960ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:36:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix kmemcg registration for late caches
has been removed from the -mm tree.  Its filename was
     memcg-fix-kmemcg-registration-for-late-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: fix kmemcg registration for late caches

The designed workflow for the caches in kmemcg is: register it with
memcg_register_cache() if kmemcg is already available or later on when a
new kmemcg appears at memcg_update_cache_sizes() which will handle all
caches in the system.  The caches created at boot time will be handled by
the later, and the memcg-caches as well as any system caches that are
registered later on by the former.

There is a bug, however, in memcg_register_cache: we correctly set up the
array size, but do not mark the cache as a root cache.  This means that
allocations for any cache appearing late in the game will see
memcg->memcg_params->is_root_cache == false, and in particular, trigger
VM_BUG_ON(!cachep->memcg_params->is_root_cache) in __memcg_kmem_cache_get.

The obvious fix is to include the missing assignment.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-kmemcg-registration-for-late-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-kmemcg-registration-for-late-caches
+++ a/mm/memcontrol.c
@@ -3030,7 +3030,9 @@ int memcg_register_cache(struct mem_cgro
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
-	}
+	} else
+		s->memcg_params->is_root_cache = true;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
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

