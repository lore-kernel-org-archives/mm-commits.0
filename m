From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:38 -0700
Message-ID: <20120322201938.91BB6A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56636 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab2CVUTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:39 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so401558ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove unnecessary thp check in page stat accounting
has been removed from the -mm tree.  Its filename was
     memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: remove unnecessary thp check in page stat accounting

e94c8a9cbce1ae ("memcg: make mem_cgroup_split_huge_fixup() more
efficient") removed move_lock_page_cgroup().  So we do not have to check
PageTransHuge in mem_cgroup_update_page_stat() and fallback into the
locked accounting because both move_account() and thp split are done with
compound_lock so they cannot race.

The race between update vs.  move is protected by mem_cgroup_stealed.

PageTransHuge pages shouldn't appear in this code path currently because
we are tracking only file pages at the moment but later we are planning
to track also other pages (e.g. mlocked ones).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Ying Han<yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-unnecessary-thp-check-in-page-stat-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unnecessary-thp-check-in-page-stat-accounting
+++ a/mm/memcontrol.c
@@ -1898,7 +1898,7 @@ void mem_cgroup_update_page_stat(struct 
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		goto out;
 	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(memcg)) || PageTransHuge(page)) {
+	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
 		move_lock_page_cgroup(pc, &flags);
 		need_unlock = true;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch
procfs-speed-up-proc-pid-stat-statm.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

