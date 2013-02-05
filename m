From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-typo-in-kmemcg-cache-walk-macro.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:30 -0800
Message-ID: <20130205202030.AF4E55A406B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:38986 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab3BEUUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:31 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so65834ghb.0
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix typo in kmemcg cache walk macro
has been removed from the -mm tree.  Its filename was
     memcg-fix-typo-in-kmemcg-cache-walk-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: fix typo in kmemcg cache walk macro

The macro for_each_memcg_cache_index contains a silly yet potentially
deadly mistake.  Although the macro parameter is _idx, the loop tests are
done over i, not _idx.

This hasn't generated any problems so far, because all users use i as a
loop index.  However, while playing with an extension of the code I ended
using another loop index and the compiler was quick to complain.

Unfortunately, this is not the kind of thing that testing reveals =(

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-fix-typo-in-kmemcg-cache-walk-macro include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-typo-in-kmemcg-cache-walk-macro
+++ a/include/linux/memcontrol.h
@@ -429,7 +429,7 @@ extern int memcg_limited_groups_array_si
  * the slab_mutex must be held when looping through those caches
  */
 #define for_each_memcg_cache_index(_idx)	\
-	for ((_idx) = 0; i < memcg_limited_groups_array_size; (_idx)++)
+	for ((_idx) = 0; (_idx) < memcg_limited_groups_array_size; (_idx)++)
 
 static inline bool memcg_kmem_enabled(void)
 {
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
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

