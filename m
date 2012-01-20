From: akpm@linux-foundation.org
Subject: + memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:43:01 -0800
Message-ID: <20120120234301.EA0941E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56675 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2ATXnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:43:02 -0500
Received: by yhjj52 with SMTP id j52so104699yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:43:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg: remove unnecessary thp check in page stat accounting
has been added to the -mm tree.  Its filename is
     memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-unnecessary-thp-check-in-page-stat-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unnecessary-thp-check-in-page-stat-accounting
+++ a/mm/memcontrol.c
@@ -1864,7 +1864,7 @@ void mem_cgroup_update_page_stat(struct 
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		goto out;
 	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(memcg)) || PageTransHuge(page)) {
+	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
 		move_lock_page_cgroup(pc, &flags);
 		need_unlock = true;
_
Subject: Subject: memcg: remove unnecessary thp check in page stat accounting

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch
mm-fix-rss-count-leakage-during-migration.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-add-rss-counters-consistency-check.patch
mm-postpone-migrated-page-mapping-reset.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-make-get_mm_counter-static-inline.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
proc-speedup-proc-stat-handling.patch

