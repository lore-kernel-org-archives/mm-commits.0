From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-open-code-accesses-to-res_counter-members.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:28 -0700
Message-ID: <20120416201528.536E7A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58458 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2DPUP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:29 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so646133qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not open code accesses to res_counter members
has been removed from the -mm tree.  Its filename was
     memcg-do-not-open-code-accesses-to-res_counter-members.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: do not open code accesses to res_counter members

We should use the accessor res_counter_read_u64 for that.

Although a purely cosmetic change is sometimes better delayed, to avoid
conflicting with other people's work, we are starting to have people
touching this code as well, and reproducing the open code behavior because
that's the standard =)

Time to fix it, then.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-open-code-accesses-to-res_counter-members mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-open-code-accesses-to-res_counter-members
+++ a/mm/memcontrol.c
@@ -3763,7 +3763,7 @@ move_account:
 			goto try_to_free;
 		cond_resched();
 	/* "ret" should also be checked to ensure all lists are empty. */
-	} while (memcg->res.usage > 0 || ret);
+	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
 out:
 	css_put(&memcg->css);
 	return ret;
@@ -3778,7 +3778,7 @@ try_to_free:
 	lru_add_drain_all();
 	/* try to free all pages in this cgroup */
 	shrink = 1;
-	while (nr_retries && memcg->res.usage > 0) {
+	while (nr_retries && res_counter_read_u64(&memcg->res, RES_USAGE) > 0) {
 		int progress;
 
 		if (signal_pending(current)) {
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
fs-bufferc-remove-bug-in-possible-but-rare-condition.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

